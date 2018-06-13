@echo off
rem Checks java version via the following methods, respectively:
rem    - check if JAVA env variable is set, and parse it's java -version output
rem    - check if JAVA_HOME env variable is set, and parse it's java -version output
rem    - parse java -version output of the java.exe on PATH env variable (run java command)
rem    - search the registry and use CurrentVersion, check if it's > 3 numbers, and get JAVA_HOME with JavaHome registry key
rem    - search the registry and parse java -version from JavaHome key's path to the exe
rem Then sets JAVA to the path to the java.exe that passed the version check (if any)
rem Returns via exitCode:
rem   0 check passed and JAVA set
rem   1 check failed
rem   3 check failed fatally (something wrong with code)

set exitCode=0
set PROGNAME=%~nx0
set REQUIRED_JAVA_VER=9


goto BEGIN

rem # # HELPERS # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:warn
    echo %PROGNAME%: %*
goto :EOF

:parse_java_version path
    call:parse_java-version_output %1 -version
    if errorLevel 1 (
        call:warn Failed to parse java -version output from: "%~1"
        set exitCode=3
        exit /b 1
    )
    set JAVA_VER=%RETURN%
    call:validate_version "Version parsed from %~1 is invalid: "%RETURN%"" 3
goto :EOF

:parse_java-version_output command
    for /f "usebackq tokens=3" %%a in (`%* 2^>^&1`) do (
        set RETURN=%%~a
        rem Stop after first line
        goto :EOF
    )
goto :EOF

:check_version
    call:compare_versions %JAVA_VER% %REQUIRED_JAVA_VER%
    if errorLevel 1 (
        call:warn Failed to compare versions: "%JAVA_VER%" with "%REQUIRED_JAVA_VER%"
        set exitCode=3
        exit /b 1
    )
    set VER_CHECK=%ERRORLEVEL%
goto :EOF

:compare_versions  version1  version2
rem Compares up to 4 numbers (X.X.X.X)
rem Returns via %ERRORLEVEL%... v1<v2:-2, v1=v2:0, v1>v2:-1
    for /f "tokens=1,2,3,4 delims=._-" %%a in ("%~1") do (
        for /f "tokens=1,2,3,4 delims=._-" %%w in ("%~2") do (
            if %%a lss %%w exit /b -2
            if %%a gtr %%w exit /b -1
            if %%b lss %%x exit /b -2
            if %%b gtr %%x exit /b -1
            if %%c lss %%y exit /b -2
            if %%c gtr %%y exit /b -1
            if %%d lss %%z exit /b -2
            if %%d gtr %%z exit /b -1
            exit /b 0
        )
    )
goto :EOF

:search_registry
    call:parse_regKey_value "reg query ""HKLM\SOFTWARE\JavaSoft\JRE"" /v CurrentVersion"
    if errorLevel 1 if "%RET%" == "" goto javaHome_try_jdk
    set JAVA_VER=%RETURN%
    call:validate_version "CurrentVersion is not valid: "%JAVA_VER%"" 3
    call:parse_regKey_value "reg query ""HKLM\SOFTWARE\JavaSoft\JRE\%JAVA_VER%"" /v JavaHome"
    if errorLevel 1 if "%RETURN%" == "" goto javaHome_try_jdk
    set JAVA_HOME=%RETURN%
    goto :EOF
    :javaHome_try_jdk
        call:parse_regKey_value "reg query ""HKLM\SOFTWARE\JavaSoft\JDK"" /v CurrentVersion"
        if errorLevel 1 if "%RET%" == "" exit /b 1
        set JAVA_VER=%RETURN%
        call:validate_version "CurrentVersion is not valid: "%JAVA_VER%"" 3
        call:parse_regKey_value "reg query ""HKLM\SOFTWARE\JavaSoft\JDK\%JAVA_VER%"" /v JavaHome"
        if errorLevel 1 if "%RET%" == "" exit /b 1
        set JAVA_HOME=%RETURN%
goto :EOF

:parse_regKey_value command
    for /f "usebackq skip=2 tokens=3*" %%x in (`%~1`) do (
      if not "%%y"=="" (
        set RETURN=%%x %%y
        goto :EOF
      )
      set RETURN=%%x
    )
goto :EOF

:validate_version errorMsg exitCode
rem fails if JAVA_VER < 3 numbers
    for /f "tokens=1,2,3* delims=._-" %%a in ("%JAVA_VER%") do (if not "%%c" == "" goto :EOF)
    call:warn %~1
    set exitCode=%2
    exit /b %exitCode%
goto :EOF

rem # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:BEGIN
    call:warn Checking Java version, at least Java "%REQUIRED_JAVA_VER%" is required...

:CheckJAVA
    if not defined JAVA goto CheckJAVA_HOME
    if not exist "%JAVA%" goto CheckJAVA_HOME
    call:parse_java_version "%JAVA%"
    if errorLevel 1 goto Finish
    call:check_version
    if errorLevel 1 goto Finish
    if "%VER_CHECK%" == "-2" goto CheckJAVA_HOME

    call:warn Found compatible JVM from JAVA env variable: "%JAVA_VER%"
goto Finish

:CheckJAVA_HOME
    if "%JAVA_HOME%" == "" (
        call:warn JAVA_HOME not set; results may vary
        goto CheckJavaExecutable
    )
    if not exist "%JAVA_HOME%" (
        call:warn JAVA_HOME is not valid: "%JAVA_HOME%", trying java.exe on PATH...
        goto CheckJavaExecutable
    )
    if not exist "%JAVA_HOME%\bin\java.exe" (
        call:warn java.exe not found in "%JAVA_HOME%\bin", trying java.exe on PATH...
        goto CheckJavaExecutable
    )
    call:parse_java_version "%JAVA_HOME%\bin\java.exe"
    if errorLevel 1 goto Finish
    call:check_version
    if errorLevel 1 goto Finish
    if "%VER_CHECK%" == "-2" (
      call:warn JAVA_HOME points to an incompatible JVM, trying java.exe on PATH...
      goto CheckJavaExecutable
    )

    call:warn Found compatible JVM from JAVA_HOME: "%JAVA_VER%"
    set JAVA=%JAVA_HOME%\bin\java.exe
goto Finish

:CheckJavaExecutable
    if not exist "java.exe" goto CheckCurrentVersion
    call:parse_java_version "java.exe"
    if errorLevel 1 goto Finish
    call:check_version
    if errorLevel 1 goto Finish
    if "%VER_CHECK%" == "-2" goto CheckCurrentVersion

    call:warn Found compatible JVM from java.exe: "%JAVA_VER%"
    set JAVA=java.exe
goto Finish

:CheckCurrentVersion
    call:search_registry
    if errorLevel 1 (
        call:warn Registry does not contain a compatible JVM
        goto Finish
    )
    call:check_version
    if errorLevel 1 goto Finish
    if "%VER_CHECK%" == "-2" (
        call:warn CurrentVersion registry key shows an incompatible version of Java, trying JavaHome registry key...
        goto CheckJavaHomeKey
    )

    call:warn Found compatible JVM from CurrentVersion registry key: "%JAVA_VER%"
    set JAVA=%JAVA_HOME%\bin\java.exe
goto Finish

:CheckJavaHomeKey
    call:parse_java_version "%JAVA_HOME%\bin\java.exe"
    if errorLevel 1 goto Finish
    echo test
    call:check_version
    if errorLevel 1 goto Finish
    if "%VER_CHECK%" == "-2" (
      call:warn JavaHome registry key points to an incompatible JVM
      goto Finish
    )

    call:warn Found compatible JVM from JavaHome registry key: "%JAVA_VER%"
    set JAVA=%JAVA_HOME%\bin\java.exe
goto Finish

rem # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:Finish
    if not "%exitCode%" == 0 goto END
    if "%VER_CHECK%" == "-2" set exitCode=1
goto END

:END
    endlocal & set exitCode=%exitCode% & set JAVA=%JAVA%
goto EXIT

:EXIT
    exit /b %exitCode%
