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
;  Environ variables defines
;----------------------------------------------------------
!define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
!define env_hkcu 'HKCU "Environment"'
!include EnvVarUpdate.nsh

;----------------------------------------------------------
;   Headers and Macros
;----------------------------------------------------------
; required for JRE check
!include WordFunc.nsh
!insertmacro VersionConvert
!insertmacro VersionCompare
;other
!include LogicLib.nsh
!include "x64.nsh"


Function CheckJavaVersion
  var /GLOBAL JAVA_VER
  var /GLOBAL JAVA_SEM_VER
  var /GLOBAL JAVA_HOME

  StrCmp $CHECK_JRE "false" End
  DetailPrint "Checking JRE version..."

  push $R0
  push $R1
  push $0
  push $2
  push $3
  push $4

  DetectTryJRE64:
    ${if} ${RunningX64}
      SetRegView 64
    ${EndIf}
    ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
    StrCmp $2 "" DetectTryJDK64
    ReadRegStr $3 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$2" "MicroVersion"
    StrCmp $3 "" DetectTryJDK64
    ReadRegStr $4 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$2" "UpdateVersion"
    StrCmp $4 "" 0 GotFromUpdate
    ReadRegStr $4 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$2" "JavaHome"
    Goto GotJRE
  DetectTryJDK64:
    ${if} ${RunningX64}
      SetRegView 64
    ${EndIf}
    ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Development Kit" "CurrentVersion"
    StrCmp $2 "" DetectTryJRE32
    ReadRegStr $3 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$2" "MicroVersion"
    StrCmp $3 "" DetectTryJRE32
    ReadRegStr $4 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$2" "UpdateVersion"
    StrCmp $4 "" 0 GotFromUpdate
    ReadRegStr $4 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$2" "JavaHome"
    goto GotJRE
  DetectTryJRE32:
    SetRegView 32
    ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
    StrCmp $2 "" DetectTryJDK32
    ReadRegStr $3 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$2" "MicroVersion"
    StrCmp $3 "" DetectTryJDK32
    ReadRegStr $4 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$2" "UpdateVersion"
    StrCmp $4 "" 0 GotFromUpdate
    ReadRegStr $4 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$2" "JavaHome"
    Goto GotJRE
  DetectTryJDK32:
    SetRegView 32
    ReadRegStr $2 HKLM "SOFTWARE\JavaSoft\Java Development Kit" "CurrentVersion"
    StrCmp $2 "" NoFound
    ReadRegStr $3 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$2" "MicroVersion"
    StrCmp $3 "" NoFound
    ReadRegStr $4 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$2" "UpdateVersion"
    StrCmp $4 "" 0 GotFromUpdate
    ReadRegStr $4 HKLM "SOFTWARE\JavaSoft\Java Development Kit\$2" "JavaHome"
  GotJRE:
    SetRegView 32
    ; calc build version
    strlen $0 $3
    intcmp $0 1 0 0 GetFromMicro
    ; get it from the path
  GetFromPath:
    strlen $R0 $4
    intop $R0 $R0 - 1
    StrCpy $0 ""
  loopP:
    StrCpy $R1 $4 1 $R0
    StrCmp $R1 "" DotFoundP
    StrCmp $R1 "_" UScoreFound
    StrCmp $R1 "." DotFoundP
    StrCpy $0 "$R1$0"
    Goto GoLoopingP
  DotFoundP:
    push ""
    Exch 6
    goto CalcMicro
  UScoreFound:
    push $0
    Exch 6
    goto CalcMicro
  GoLoopingP:
    intcmp $R0 0 DotFoundP DotFoundP
    IntOp $R0 $R0 - 1
    Goto loopP
  GetFromMicro:
    strcpy $4 $3
    goto GetFromPath
  GotFromUpdate:
    SetRegView 32
    push $4
    Exch 6

  CalcMicro:
    Push $3 ; micro
    Exch 6
    ; break version into major and minor
    StrCpy $R0 0
    StrCpy $0 ""
  loop:
    StrCpy $R1 $2 1 $R0
    StrCmp $R1 "" done
    StrCmp $R1 "." DotFound
    StrCpy $0 "$0$R1"
    Goto GoLooping
  DotFound:
    Push $0 ; major
    Exch 5
    StrCpy $0 ""
  GoLooping:
    IntOp $R0 $R0 + 1
    Goto loop

  done:
    Push $0 ; minor
    Exch 7
    ; restore register values
    pop $0
    pop $2
    pop $R1
    pop $R0
    pop $3
    pop $4
    goto CheckJavaVersion
  NoFound:
    pop $4
    pop $3
    pop $0
    pop $2
    pop $R1
    pop $R0
    push ""
    push "installed"
    push "java"
    push "no"


  CheckJavaVersion:
    pop $0 ; major version
    pop $1 ; minor version
    pop $2 ; micro version
    pop $3 ; build/update version

    StrCpy $JAVA_SEM_VER "$0.$1.$2.$3" ;use . instead of _ for the build so the comparison works
    StrCpy $JAVA_VER "$0.$1"

    ;First check version number
    StrCmp "no" "$0" InstallJava
    ${VersionConvert} $JAVA_SEM_VER "" $R1
    ${VersionCompare} $R1 ${REQUIRED_JAVA_VER} $R2
    IntCmp 2 $R2 InstallJava
    ;Then check binary file exist
    ReadRegStr $JAVA_HOME HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$JAVA_VER" JavaHome
    ${if} $JAVA_HOME == ""
      SetRegView 64
      ReadRegStr $JAVA_HOME HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\$JAVA_VER" JavaHome
      SetRegView 32
    ${endif}
    IfFileExists "$JAVA_HOME\bin\java.exe" 0 InstallJava
    DetailPrint "Found a compatible JVM ($JAVA_VER)"
    ;Set JAVA_HOME env var
    ; HKLM (all users) vs HKCU (current user) defines
    WriteRegExpandStr ${env_hklm} JAVA_HOME "$JAVA_HOME"
    ${EnvVarUpdate} $0 "PATH" "A" "HKLM" "$JAVA_HOME\bin"
    ; make sure windows knows about the change
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000

    DetailPrint "JAVA_HOME set to $JAVA_HOME\bin"
    Goto End

  InstallJava:
        ClearErrors
        messageBox mb_yesno "Java JRE not found or too old. Daisy Pipeline 2 needs at least Java ${REQUIRED_JAVA_VER}, would you like to install it now?" IDNO Exit
	setOutPath $TEMP
        ; FIXME: can not find an online installer for Java 9
        File "jre-8u102-windows-i586-iftw.exe"
        ExecWait '"$TEMP\jre-8u102-windows-i586-iftw.exe" WEB_JAVA=0 SPONSORS=0'

        IfErrors 0 End
        messageBox mb_iconstop "Java installation returned an error. Please contact the Daisy Pipeline 2 developing team."
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit

  Exit:
        quit
  End:
FunctionEnd
