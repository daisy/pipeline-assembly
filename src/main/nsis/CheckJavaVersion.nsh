###############################################################################
; Find installed java version and return major, minor, micro and build/update version
; For some reason v1.2.1_004 did not give a build version, but it's the only one of its kind.
; There are 3 ways to get the build version:
;   1) from the UpdateVersion key
;   2) or from the MicroVersion key
;   3) or from the JavaHome key
;example
;  call GetJavaVersion
;  pop $0 ; major version
;  pop $1 ; minor version
;  pop $2 ; micro version
;  pop $3 ; build/update version
;  strcmp $0 "no" JavaNotInstalled
;  strcmp $3 "" nobuild
;  DetailPrint "$0.$1.$2_$3"
;  goto fin
;nobuild:
;  DetailPrint "$0.$1.$2"
;  goto fin
;JavaNotInstalled:
;  DetailPrint "Java Not Installed"
;fin:

;----------------------------------------------------------
;  General defines
;----------------------------------------------------------
!define REQUIRED_JAVA_VER "9.0.0"
;----------------------------------------------------------

;----------------------------------------------------------
;  Environ variables defines
;----------------------------------------------------------
!define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
!define env_hkcu 'HKCU "Environment"'
!include EnvVarUpdate.nsh
;----------------------------------------------------------

;----------------------------------------------------------
;   Headers and Macros
;----------------------------------------------------------
; required for JRE check
!include WordFunc.nsh
!insertmacro VersionConvert
!insertmacro VersionCompare
;other
!include LogicLib.nsh
!include x64.nsh
!include Validate.nsh

!define CheckVersionKeys "!insertmacro CheckVersionKeys"
!macro CheckVersionKeys javaKey goto
  ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\${javaKey}" "CurrentVersion"
  StrCmp $2 "" ${goto}
  ReadRegStr $JAVA_HOME HKLM "SOFTWARE\JavaSoft\${javaKey}\$2" "JavaHome"
  Goto GetFromPath
!macroend

!define SetRegViewx64 "!insertmacro SetRegViewx64"
!macro SetRegViewx64
  ${if} ${RunningX64}
    SetRegView 64
  ${EndIf}
!macroend
;----------------------------------------------------------


Function CheckJavaVersion
  var /GLOBAL JAVA_VER
  var /GLOBAL JAVA_HOME

  ;store values for restoration at End:
  push $R0
  push $R1
  push $R2
  push $0
  push $1
  push $2
  push $3

  StrCmp $CHECK_JRE "false" End
  DetailPrint "Checking JRE version..."

  TryJRE_64:
    ${SetRegViewx64}
    ${CheckVersionKeys} "JRE" "TryJDK_64"
  TryJDK_64:
    ${SetRegViewx64}
    ${CheckVersionKeys} "JDK" "TryJRE_32"
  TryJRE_32:
    SetRegView 32
    ${CheckVersionKeys} "JRE" "TryJDK_32"
  TryJDK_32:
    SetRegView 32
    ${CheckVersionKeys} "JDK" "NoFound"

  GetFromPath:
    ;work backwards from end of path, pushing numbers every
    ;time we encounter a non-digit, until we encounter a hyphen
    ;example: "C:\Program Files\Java\jdk-10.0.1" -> "10.0.1"
    StrCpy $R0 "" ;make sure R0 is empty
    ;end char index -> 0
    StrLen $0 $JAVA_HOME
    IntOp $0 $0 - 1
  Loop:
    StrCpy $R1 $JAVA_HOME 1 $0 ;current char -> R1
    IntOp $0 $0 - 1 ;decrement index
    StrCpy $R2 $JAVA_HOME 1 $0 ;next char -> R2

    StrCpy $R0 "$R1$R0" ;prepend current char ($R1) to current num ($R0)
    ${Validate} $3 $R2 ${NUMERIC} ;check next char is digit
    IntCmp $3 0 FoundNonDigit ;$3=0: next char is non-digit
    goto Loop
  FoundNonDigit:
    StrCmp $R2 "-" EndLoop ;Java 9+ is of the form jxx-X.X.X
    IntOp $0 $0 - 1 ;skip non-digit
    push $R0 ;push current num
    StrCpy $R0 "" ;clear current num
    goto Loop
  EndLoop:
    push $R0 ;push major
    goto Done

  Done:
    SetRegView 32
    goto CheckJavaVersion
  NoFound:
    SetRegView 32
    push ""
    push "installed"
    push "java"
    push "no"
    goto CheckJavaVersion

  CheckJavaVersion:
    pop $0 ; major version
    pop $1 ; minor version
    pop $2 ; build/update version

    StrCpy $JAVA_VER "$0.$1.$2"

    StrCmp "no" "$0" InstallJava ;NoFound
    ;First check version meets requirements
    ${VersionConvert} $JAVA_VER "" $R1
    ${VersionCompare} $R1 ${REQUIRED_JAVA_VER} $R2
    DetailPrint "Found JVM $JAVA_VER"
    IntCmp 2 $R2 InstallJava
    ;Then check binary file exists
    IfFileExists "$JAVA_HOME\bin\java.exe" 0 InstallJava
    DetailPrint "Found a compatible JVM ($JAVA_VER)"
    
    Goto End
    ;FIXME: setting JAVA_HOME doesn't work
    ${if} $JAVA_HOME == ""
      ;Set JAVA_HOME env var
      ; HKLM (all users) vs HKCU (current user) defines
      WriteRegExpandStr ${env_hklm} JAVA_HOME "$JAVA_HOME"
      ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$JAVA_HOME\bin"
      ; make sure windows knows about the change
      SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
      DetailPrint "JAVA_HOME set to $JAVA_HOME\bin"
    ${endIf}

  InstallJava:
        ClearErrors
        messageBox mb_yesno "Java was not found, or your version doesn't meet our requirements. $\n$\nDaisy Pipeline 2 needs at least Java ${REQUIRED_JAVA_VER}, would you like to install it?" IDNO Exit
        goto TempJavaInstall

        ; FIXME: can't find an online installer (iftw) for Java 9
        setOutPath $TEMP
        File "jre-8u102-windows-i586-iftw.exe"
        ExecWait '"$TEMP\jre-8u102-windows-i586-iftw.exe" WEB_JAVA=0 SPONSORS=0'

        TempJavaInstall:
          MessageBox MB_OK "You will now be redirected to the Java 10 downloads page. $\n$\nPlease accept the license agreement, download the Java 10 installer for Windows, and run it."
          ExecShell "open" "http://www.oracle.com/technetwork/java/javase/downloads/jdk10-downloads-4416644.html"
          MessageBox MB_YESNO "Please accept the license agreement, download the Java 10 installer for Windows, and run it. $\n$\nWould you like additional instructions for installing Java? " IDNO Wait
          ExecShell "open" "https://docs.oracle.com/javase/10/install/installation-jdk-and-jre-microsoft-windows-platforms.htm#JSJIG-GUID-371F38CC-248F-49EC-BB9C-C37FC89E52A0"
          Wait:
            MessageBox MB_OK "Once Java 10 has been installed, click OK to resume Daisy Pipeline 2 installation. " IDOK TryAgain

        IfErrors 0 End
        messageBox mb_iconstop "Java installation returned an error. Please contact the Daisy Pipeline 2 developing team."
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit

  Exit:
        quit
  TryAgain:
    ;restore registry
    pop $3
    pop $2
    pop $1
    pop $0
    pop $R2
    pop $R1
    pop $R0
    Call CheckJavaVersion
  End:
    ;restore registry
    pop $3
    pop $2
    pop $1
    pop $0
    pop $R2
    pop $R1
    pop $R0
FunctionEnd
