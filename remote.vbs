set args = WScript.Arguments.Named
if len(args.Item("COMPort"))*len(args.Item("dev"))*len(args.Item("C")) = 0 then
WScript.echo "Usage: remote.vbs /COMPort:PortName /dev:a_or_b /C:Channel_or_command /sw:Optional_show_window#"
WScript.Quit 1
end if
Dim objFS, objFile,objShell
Set objFS = CreateObject("Scripting.FileSystemObject")
Set objFile = objFS.CreateTextFile("C:\delphijustin\lastrc.ps1")
objFile.WriteLine("$port = new-Object System.IO.Ports.SerialPort "&args.Item("COMPort")&",9600,None,8,one")
objFile.WriteLine("$port.open()")
objFile.WriteLine("timeout /T 10")
objFile.WriteLine("$port.WriteLine('"&args.Item("dev")&"')")
objFile.WriteLine("timeout /T 5")
objFile.WriteLine("$port.WriteLine('"&args.Item("C")&"')")
objFile.WriteLine("timeout /T 5")
objFile.WriteLine("$port.close()")
objFile.Close()
set objShell = WScript.CreateObject("WScript.Shell")
intReturn = objShell.Run("PowerShell.exe -command c:\delphijustin\lastrc.ps1",CInt(args.Item("sw")),true)
if intReturn <> 0 then
WScript.echo "Unreal DVR Powerscript failed "&intReturn
end if