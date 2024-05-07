Dim WinScriptHost
Dim scriptFolder
Dim ddnsPath

'
' This script calls `namecheap-dynamicdns.bat` but without a CMD prompt window.
' If using a scheduled task, set this script as the action.
'

' Get the folder path of the script
scriptFolder = Replace(WScript.ScriptFullName, WScript.ScriptName, "")

' Construct the path for namecheap-dynamicdns.bat in the same folder as the script
ddnsPath = scriptFolder & "namecheap-dynamicdns.bat"

' Create WScript.Shell object
Set WinScriptHost = CreateObject("WScript.Shell")

' Run namecheap-dynamicdns.bat script
WinScriptHost.Run Chr(34) & ddnsPath & Chr(34), 0

' Release the WScript.Shell object
Set WinScriptHost = Nothing