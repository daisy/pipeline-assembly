Set oShell = CreateObject ("Wscript.Shell")
Set oArgs = WScript.Arguments
' Create and show MsgBox
Dim Msg, Style, Title, Response
If oArgs.Count < 1 Then 
	Msg = "DAISY Pipeline 2 was unable to start." & vbCrLf & vbCrLf & "No logs were created. Would you like to report this issue?"
	Style = vbYesNo + vbCritical
	Title = "Error"
	Response = MsgBox(Msg, Style, Title)
	If Response=vbYes Then ReportIssue()
Else 
	Msg = "DAISY Pipeline 2 was unable to start." & vbCrLf & vbCrLf & "Click OK to view logs."
	Style = vbOK + vbCritical
	Title = "Error"
	Response = MsgBox(Msg, Style, Title)
	If Response=vbOK Then OpenLogs()
End If


' Run File Explorer with path
Sub OpenLogs()
	Dim RunCmd
	Dim Path
	Path = Wscript.Arguments(0)
	RunCmd = "explorer.exe /e,""" & Path & """" ' escape quotes
	oShell.Run RunCmd
End Sub

Sub ReportIssue() 
	Dim Path 
	Path = "https://github.com/daisy/pipeline/issues/521"
	oShell.Run(Path)
End Sub