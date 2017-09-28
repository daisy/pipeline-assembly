Set oShell = CreateObject ("Wscript.Shell")
Set oArgs = WScript.Arguments

' Create and show MsgBox
Dim msg, style, title, response
If oArgs.Count < 1 Then 
	msg = "DAISY Pipeline 2 was unable to start." & vbCrLf & vbCrLf & "No logs were created. Would you like to report this issue?"
	style = vbYesNo + vbCritical
	title = "Error"
	response = MsgBox(Msg, Style, Title)
	If response=vbYes Then reportIssue()
Else 
	msg = "DAISY Pipeline 2 was unable to start." & vbCrLf & vbCrLf & "Click OK to view logs."
	style = vbOK + vbCritical
	title = "Error"
	response = MsgBox(Msg, Style, Title)
	If response=vbOK Then openToLogs()
End If


' Run File Explorer with path
Sub openToLogs()
	Dim path: path = Wscript.Arguments(0)
	Dim runCmd: runCmd = "explorer.exe /e,""" & path & """" ' escape quotes
	oShell.Run runCmd
End Sub

Sub reportIssue() 
	Dim path: path = "https://github.com/daisy/pipeline/issues/new"
	oShell.Run(path)
End Sub