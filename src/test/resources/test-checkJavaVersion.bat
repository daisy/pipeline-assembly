@echo off
setlocal enabledelayedexpansion
set checkJavaVersion="..\..\main\resources\bin\checkJavaVersion.bat"

if "%*" == ":mock-reg-query-1"    goto %*
if "%*" == ":mock-reg-query-2"    goto %*
if "%*" == ":mock-java-version-1" goto %*

goto BEGIN

rem # # HELPERS # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:info msg
    echo Test %test% of %testing%: %~1
goto :EOF

:fail msg
    set line=    [FAILURE] Test %test%: %testing% %~1
    echo [91m%line%[0m
goto :EOF

:pass
    set line=Test %test% passed
    echo [92m%line%[0m
goto :EOF

rem # # MOCKS # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:mock-reg-query-1
rem Mock `reg query "HKLM\SOFTWARE\JavaSoft\JRE" /v CurrentVersion`
    echo.
    echo HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\JRE
    echo     CurrentVersion    REG_SZ    10.0.1
    echo.
    echo.
goto :EOF

:mock-reg-query-2
rem Mock `reg query "HKLM\SOFTWARE\JavaSoft\JRE\10.0.1" /v JavaHome`
    echo.
    echo HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\JRE\10.0.1
    echo     CurrentVersion    REG_SZ    C:\Program Files\Java\jre-10.0.1
    echo.
    echo.
goto :EOF

:mock-java-version-1
rem Mock `java -version`
    echo java version "10.0.1" 2018-04-17
    echo Java(TM) SE Runtime Environment 18.3 (build 10.0.1+10)
    echo Java HotSpot(TM) 64-Bit Server VM 18.3 (build 10.0.1+10, mixed mode)
    echo.
goto :EOF

rem # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

:BEGIN

:TEST1
rem test validate_version
    set testing=validate_version
    rem test 1a
    set test=1a
    set JAVA_VER=1.1.1
    call:info "1.1.1"
    call %checkJavaVersion% :%testing% "" 2 >nul
    if %ERRORLEVEL% == 1 (
        call:fail "failed with errorLevel %ERRORLEVEL%"
        goto TEST2
    )
    if %ERRORLEVEL% == 2 (
        call:fail "incorrectly processed "%JAVA_VER%" as invalid"
        goto TEST2
    )
    if %ERRORLEVEL% == 0 call:pass

    rem test 1b
    set test=1b
    set JAVA_VER=1.1
    call:info "1.1"
    call %checkJavaVersion% :%testing% "" 2 >nul
    if %ERRORLEVEL% == 1 (
      call:fail "failed with errorLevel %ERRORLEVEL%"
      goto TEST2
    )
    if %ERRORLEVEL% == 0 (
        call:fail "incorrectly processed "%JAVA_VER%" as valid"
        goto TEST2
    )
    if %ERRORLEVEL% == 2 call:pass


:TEST2
rem test compare_versions
    set testing=compare_versions
    rem test 2a
    set test=2a
    set ver1=1
    set ver2=1
    call:info "%ver1%, %ver2%"
    call %checkJavaVersion% :%testing% %ver1% %ver2%
    if errorLevel 1 (
        call:fail "failed with errorLevel %ERRORLEVEL%"
        goto TEST3
    )
    if %ERRORLEVEL% == -2 (
        call:fail "incorrectly compared %ver1% as < %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == -1 (
        call:fail "incorrectly compared %ver1% as > %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == 0 call:pass

    rem test 2b
    set test=2b
    set ver1=1.0.1
    set ver2=1.0.0
    call:info "%ver1%, %ver2%"
    call %checkJavaVersion% :%testing% %ver1% %ver2%
    if errorLevel 1 (
        call:fail "failed with errorLevel %ERRORLEVEL%"
        goto TEST3
    )
    if %ERRORLEVEL% == -2 (
        call:fail "incorrectly compared %ver1% as < %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == 0 (
        call:fail "incorrectly compared %ver1% as == %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == -1 call:pass

    rem test 2c
    set test=2c
    set ver1=1.0.0
    set ver2=1.0.1
    call:info "%ver1%, %ver2%"
    call %checkJavaVersion% :%testing% %ver1% %ver2%
    if errorLevel 1 (
        call:fail "failed with errorLevel %ERRORLEVEL%"
        goto TEST3
    )
    if %ERRORLEVEL% == -1 (
        call:fail "incorrectly compared %ver1% as > %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == 0 (
        call:fail "incorrectly compared %ver1% as == %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == -2 call:pass

    rem test 2d
    set test=2d
    set ver1=1.0
    set ver2=1.0.0
    call:info "%ver1%, %ver2%"
    call %checkJavaVersion% :%testing% %ver1% %ver2%
    if errorLevel 1 (
        call:fail "failed with errorLevel %ERRORLEVEL%"
        goto TEST3
    )
    if %ERRORLEVEL% == -2 (
        call:fail "incorrectly compared %ver1% as < %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == -1 (
        call:fail "incorrectly compared %ver1% as > %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == 0 call:pass

    rem test 2e
    set test=2e
    set ver1=1.0
    set ver2=1.0.1
    call:info "%ver1%, %ver2%"
    call %checkJavaVersion% :%testing% %ver1% %ver2%
    if errorLevel 1 (
        call:fail "failed with errorLevel %ERRORLEVEL%"
        goto TEST3
    )
    if %ERRORLEVEL% == -1 (
        call:fail "incorrectly compared %ver1% as > %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == 0 (
        call:fail "incorrectly compared %ver1% as == %ver2%"
        goto TEST3
    )
    if %ERRORLEVEL% == -2 call:pass

:TEST3
rem test parse_java-version_output
    set test=3
    set testing=parse_java-version_output
    set path=java.exe &rem replace with path to your java exe
    call:info "mock input"
    call %checkJavaVersion% :%testing% "call %~dpnx0 :mock-java-version-1"
    if errorLevel 1 (
        call:fail "failed with errorLevel %ERRORLEVEL%"
        goto TEST4
    )
    if not "%RETURN%" == "10.0.1" (
        call:fail "failed to parse java -version, output: "%RETURN%""
        goto TEST4
    )
    call:pass

:TEST4
rem test search_registry
    set testing=parse_regKey_value
    rem test 4a
    set test=4a
    call:info "mock input"
    call %checkJavaVersion% :%testing% "call %~dpnx0 :mock-reg-query-1"
    if errorLevel 1 (
        call:fail "failed with errorLevel %ERRORLEVEL%"
        goto END
    )
    if not "%RETURN%" == "10.0.1" (
        call:fail "failed to parse CurrentVersion, output: "%RETURN%""
        goto END
    )
    call:pass

    rem test 4b
    set test=4b
    call:info "mock input"
    call %checkJavaVersion% :%testing% "call %~dpnx0 :mock-reg-query-2"
    if errorLevel 1 (
        call:fail "failed with errorLevel %ERRORLEVEL%"
        goto END
    )
    if not "%RETURN%" == "C:\Program Files\Java\jre-10.0.1" (
        call:fail "failed to parse mock JavaHome, output: "%RETURN%""
        goto END
    )
    call:pass

:END
