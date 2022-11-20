<?php 
include "config.php";
header("Content-Type: text/plain");
if( explode(".",$_GET['p'])[0]!=$pin)die("-2");
function issafe($s){
return strpos(":".$s,"<")+strpos(":".$s,">")+strpos(":".$s,"&")+strpos(":".$s,"|")+strpos(":".$s,chr(13))+strpos(":".$s,chr(10))+strpos(":".$s,chr(34))+strpos(":".$s,chr(39))+strpos(":".$s,"%")==0;
}
if(!issafe($_GET['d'].$_GET['c']))die("-1");
echo file_put_contents($lastremo_bat,"cscript.exe %udvrdir%\\remote.vbs //NoLogo /COMPort:%ArduinoPort% /dev:".$_GET['d']." /sw:0 /C:".$_GET['c']."
echo %time% - %date%(".$_SERVER['REMOTE_ADDR']."@".gethostbyaddr($_SERVER['REMOTE_ADDR']).") Sent ".$_GET['c']." to device ".$_GET['d']);
?>