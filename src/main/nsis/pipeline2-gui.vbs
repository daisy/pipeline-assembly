' OBJECTS
Set oShell = CreateObject("Wscript.Shell")
' VARIANTS
Dim strArgs
Dim exitCode
' CONSTANTS
Const NO_ERROR = 0
Const NO_START = 1

' START
strArgs = "cmd.exe /c pipeline2.bat gui"
exitCode = oShell.Run(strArgs, 0, true)
catchErrorrs exitCode



' PROCEDURES
Sub catchErrorrs(ByVal exitCode)
    Dim msg
    Select Case exitCode
        Case NO_ERROR
            Exit Sub
        Case NO_START
            msg = "DAISY Pipeline 2 was unable to start." & _
                    vbCrlf & vbCrlf & _
                    "View logs?"
            If errorPrompt(msg) Then viewLogs
        Case Else
            msg = "Unknown error: " & exitCode & _
                    vbCrlf & vbCrlf & _
                    "Would you like to report this issue?"
            If errorPrompt(UNKNOWN_MSG & exitCode & vbCrlf & vbCrlf & REPORT_MSG) Then reportNewIssue
    End Select
End Sub

Function errorPrompt(msg)
    Dim response: response = MsgBox(msg, vbYesNo + vbCritical, "Error")
    If response=vbYes Then
        errorPrompt = True 'return
    Else
        errorPrompt = False 'return
    End If
End Function

Sub reportNewIssue()
    Dim path
    path = "https://github.com/daisy/pipeline/issues/new"
    catchErrorrs oShell.Run(Path)
End Sub

Sub viewLogs()
    Dim logPath: logPath = oShell.ExpandEnvironmentStrings("%APPDATA%") & "\DAISY Pipeline 2\log"
    Dim runCmd: runCmd = "explorer.exe /e /separate,""" & logPath & """" ' escape quotes just to be sure
    catchErrorrs oShell.Run(runCmd)
End Sub
