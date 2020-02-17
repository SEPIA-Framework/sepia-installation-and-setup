On Error Resume Next
If WScript.Arguments.Count < 2 Then
    WScript.Echo "Missing parameters"
	WScript.Quit(1)
End if
Set fso = CreateObject("Scripting.FileSystemObject")
If NOT fso.FolderExists(WScript.Arguments(0)) Then
fso.CreateFolder(WScript.Arguments(0))
End If
set objShell = CreateObject("Shell.Application")
set FilesInZip=objShell.NameSpace(WScript.Arguments(1)).items
objShell.NameSpace(WScript.Arguments(0)).CopyHere(FilesInZip)
Set fso = Nothing
Set objShell = Nothing
If Err.Number <> 0 Then
    WScript.Echo "Error in unzip.vbs"
	WScript.Echo "Error number: " & Err.Number
    WScript.Echo "Description: " &  Err.Description
    WScript.Quit(1)
End If