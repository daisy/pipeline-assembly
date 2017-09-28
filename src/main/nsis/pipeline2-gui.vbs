Set oShell = CreateObject("Wscript.Shell")
Dim strArgs
Dim errnum

strArgs = "cmd /c pipeline2.bat gui"
errnum = oShell.Run(strArgs, 1, true) & ""
If errnum = "" Then
	MsgBox "No exitCode was found."
Else
	MsgBox "errnum: " + errnum
End If
'Dim logPath
'logPath = """oShell.ExpandEnvironmentStrings(""%APPDATA%"")""\DAISY Pipeline 2\log"
'MsgBox "logPath: " + logPath


Sub NoStartMsg()
	' Create and show MsgBox
	Dim Msg, Style, Title, Response
	If oArgs.Count < 1 Then
		Msg = "DAISY Pipeline 2 was unable to start." & vbCrLf & vbCrLf & "No logs were created. Would you like to report this issue?"
		Style = vbYesNo + vbCritical
		Title = "Error"
		Response = MsgBox(Msg, Style, Title)
		If Response=vbYes Then ReportNewIssue()
	Else
		Msg = "DAISY Pipeline 2 was unable to start." & vbCrLf & vbCrLf & "Click OK to view logs."
		Style = vbOK + vbCritical
		Title = "Error"
		Response = MsgBox(Msg, Style, Title)
		' Open File Explorer to path
		If Response=vbOK Then

		End If
	End If

End Sub

Sub ReportNewIssue()
	Dim Path
	Path = "https://github.com/daisy/pipeline/issues/new"
	oShell.Run(Path)
End Sub

Sub ViewLogs()
	Dim RunCmd
	Dim logPath
	logPath = """oShell.ExpandEnvironmentStrings(""%APPDATA%"")""\DAISY Pipeline 2\log"
	RunCmd = "explorer.exe /e,""" & logPath & """" ' escape quotes
	oShell.Run RunCmd
End Sub
