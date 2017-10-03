' OBJECTS
Set oShell = CreateObject("Wscript.Shell")
' VARIANTS
Dim strArgs
Dim exitCode

' START
strArgs = "cmd.exe /c pipeline2.bat gui"
exitCode = oShell.Run(strArgs, 0, true)
If exitCode<>0 Then oShell.Run "errorPrompt.vbs " & exitCode
