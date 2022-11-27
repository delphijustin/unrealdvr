var objShell = WScript.CreateObject("WScript.Shell")
var fs = WScript.CreateObject("Scripting.FileSystemObject");
var args=WScript.Arguments.Named;
if(args.item("C")==null){
WScript.echo("Usage: cscript.exe chsearch.js /C:channel [/Q:search_text]");
WScript.quit(1);
}
if(!fs.FileExists(objShell.ExpandEnvironmentStrings("%systemdrive%\\delphijustin\\channels\\ch"+args.Item("C")+".js")))
objShell.Run("%systemdrive%\\delphijustin\\udvr.bat /js "+args.Item("C"),1,true);
var chjs=fs.OpenTextFile(objShell.ExpandEnvironmentStrings("%systemdrive%\\delphijustin\\channels\\ch"+args.Item("C")+".js"));
var programmeCount=0;
function addCategory(cat){return -1;}
function listingEnd(obj){
WScript.echo(programmeCount+" shows found");
WScript.echo("Last updated "+new Date(obj.date).toString()+" "+obj.cbProgramme+" shows on "+obj.cbChannel+" channels");
}
function tvtime(ts){
var t= new Date(objShell.Run("%SYSTEMDRIVE%\\delphijustin\\systtime.exe 3 /conv "+ts,0,true),objShell.Run("%SYSTEMDRIVE%\\delphijustin\\systtime.exe 1 /conv "+ts,0,true)-1,objShell.Run("%SYSTEMDRIVE%\\delphijustin\\systtime.exe 2 /conv "+ts,0,true),objShell.Run("%SYSTEMDRIVE%\\delphijustin\\systtime.exe 5 /conv "+ts,0,true),objShell.Run("%SYSTEMDRIVE%\\delphijustin\\systtime.exe 6 /conv "+ts,0,true),objShell.Run("%SYSTEMDRIVE%\\delphijustin\\systtime.exe 7 /conv "+ts,0,true));
return t.toDateString()+" "+t.toLocaleTimeString();
}
function containsQ(text){
if(args.item("Q")==null)return true;
if(args.item("Q")=="")return true;
return(text.toLowerCase().indexOf(args.item("Q").toLowerCase())>=0);
}
function addProgramme(programme){
var title=unescape(programme.title+": "+programme.subtitle);
if(containsQ(title+programme.cat+tvtime(programme.startsat)+tvtime(programme.stopsat))){
WScript.echo(title+" "+tvtime(programme.startsat)+" - "+tvtime(programme.stopsat));
programmeCount++;
}}
eval(chjs.ReadAll());
chjs.Close();