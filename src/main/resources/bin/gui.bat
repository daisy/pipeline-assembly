rem 
rem  Gui launcher
rem 

rem set appropriate main class
setlocal
set MAIN=org.daisy.pipeline.swt.launcher.Main
rem call the pipeline launcher
Call %~dp0\pipeline2.bat
endlocal
