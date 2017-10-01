' OBJECTS
Set oShell = CreateObject("Wscript.Shell")
' VARIANTS
Dim strArgs
Dim exitCode
' CONSTANTS
Const NO_ERROR = 0
Const NO_LOGS = 4
Const NO_START = 5

' START
strArgs = "cmd.exe /c pipeline2.bat"
exitCode = oShell.Run(strArgs, 0, true)
catchErrors exitCode



' PROCEDURES
Sub catchErrors(ByVal exitCode)
    Dim msg
    Select Case exitCode
        Case NO_ERROR
            Exit Sub
        Case NO_LOGS
            msg = "No Logs were created." & _
                    vbCrlf & vbCrlf & _
                    "Would you like to report this issue?"
            If errorPrompt(msg) Then reportNewIssue
        Case NO_START
            msg = "DAISY Pipeline 2 was unable to start." & _
                    vbCrlf & vbCrlf & _
                    "View logs?"
            If errorPrompt(msg) Then viewLogs
        Case Else
            msg = "DAISY Pipeline 2 was unable to start." & _
                    vbCrlf & _
                    "Error: " & exitCode & _
                    vbCrlf & vbCrlf & _
                    "View logs?"
            If errorPrompt(msg) Then viewLogs
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
    catchErrors oShell.Run(Path)
End Sub

Sub viewLogs()
    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim logPath: logPath = oShell.ExpandEnvironmentStrings("%APPDATA%") & "\DAISY Pipeline 2\log"
    If (fso.FolderExists("" & logPath & "")) Then
        Dim runCmd: runCmd = "explorer.exe /e /separate,""" & logPath & """" ' escape quotes just to be sure
        catchErrors oShell.Run(runCmd)
    Else
        catchErrors NO_LOGS
    End If
End Sub
