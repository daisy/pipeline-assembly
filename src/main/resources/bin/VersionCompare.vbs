Set oArgs = WScript.Arguments
Set ret = CompareVersions oArgs(0) oArgs(1)
WScript Quit ret

'from: http://www.itprotoday.com/management-mobility/comparing-file-version-numbers-vbscript-and-powershell

' Compares two versions "a.b.c.d". If Version1 < Version2,
' returns -1. If Version1 = Version2, returns 0.
' If Version1 > Version2, returns 1.
Function CompareVersions(ByVal Version1, ByVal Version2)
  Dim Ver1, Ver2, Result
  Ver1 = GetVersionStringAsArray(Version1)
  Ver2 = GetVersionStringAsArray(Version2)
  If Ver1(0) < Ver2(0) Then
    Result = -1
  ElseIf Ver1(0) = Ver2(0) Then
    If Ver1(1) < Ver2(1) Then
      Result = -1
    ElseIf Ver1(1) = Ver2(1) Then
      Result = 0
    Else
      Result = 1
    End If
  Else
    Result = 1
  End If
  CompareVersions = Result
End Function

' Bitwise left shift
Function Lsh(ByVal N, ByVal Bits)
  Lsh = N * (2 ^ Bits)
End Function

' Returns a version string "a.b.c.d" as a two-element numeric
' array. The first array element is the most significant 32 bits,
' and the second element is the least significant 32 bits.
Function GetVersionStringAsArray(ByVal Version)
  Dim VersionAll, VersionParts, N
  VersionAll = Array(0, 0, 0, 0)
  VersionParts = Split(Version, ".")
  For N = 0 To UBound(VersionParts)
    VersionAll(N) = CLng(VersionParts(N))
  Next

  Dim Hi, Lo
  Hi = Lsh(VersionAll(0), 16) + VersionAll(1)
  Lo = Lsh(VersionAll(2), 16) + VersionAll(3)

  GetVersionStringAsArray = Array(Hi, Lo)
End Function
