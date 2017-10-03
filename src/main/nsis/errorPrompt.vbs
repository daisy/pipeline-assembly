' OBJECTS
Set oShell = CreateObject("Wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set oArgs = WScript.Arguments
' VARIANTS
Dim logPath: logPath = oShell.ExpandEnvironmentStrings("%APPDATA%") & "\DAISY Pipeline 2\log"
' CONSTANTS
Const NO_START = "5"

catchErrors oArgs(0)

' PROCEDURES
Sub catchErrors(ByVal exitCode)
    Dim msg
    If (checkLogs) Then
        Select Case exitCode
        Case NO_START
            msg = "DAISY Pipeline 2 was unable to start." & _
                    vbCrlf & vbCrlf & _
                    readLogs & vbCrlf & _
                    "View logs?"
            If errorPrompt(msg) Then viewLogs
        Case Else
            msg = "DAISY Pipeline 2 failed." & _
                    vbCrlf & "Error Code: " & exitCode & _
                    vbCrlf & vbCrlf & _
                    "View logs?"
            If errorPrompt(msg) Then viewLogs
        End Select
    Else
        msg = "DAISY Pipeline 2 was unable to start." & _
                vbCrlf & vbCrlf & _
                "No Logs were created." & _
                vbCrlf & vbCrlf & _
                "Would you like to report this issue?"
        If errorPrompt(msg) Then reportNewIssue
    End If
End Sub

Function readLogs()
    Set objFile = fso.OpenTextFile("" & logPath & "\daisy-pipeline-launch.log" & "" , 1)
    Do While Not objFile.AtEndOfStream
        readLogs = readLogs & objFile.ReadLine & vbCrLf
    Loop
    objFile.Close
End Function

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
    path = "http://daisy.github.io/pipeline/Get-Help/Issue-Tracker.html"
    oShell.Run(Path)
End Sub

Sub viewLogs()
    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim runCmd: runCmd = "explorer.exe /e /separate,""" & logPath & """" ' escape quotes just to be sure
    oShell.Run(runCmd)
End Sub

Function checkLogs()
    If (fso.FolderExists("" & logPath & "")) And (fso.FileExists("" & logPath & "\daisy-pipeline-launch.log" & "")) Then
        checkLogs = True
    Else
        checkLogs = False
    End If
End Function
