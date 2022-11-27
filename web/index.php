<!DOCTYPE html>
<html>
<head>
<?php include "config.php";
if($xmltvenabled)
$xml=simplexml_load_string(file_get_contents($channels_xml)) or $xmltvenabled=false; ?>
<title>delphijustin's TV</title>
<script src="jquery-3.6.1.min.js"></script>
<script> var channelid=new Array();
function setCookie(cname, cvalue, exdays) {
  const d = new Date();
  d.setTime(d.getTime() + (exdays*24*60*60*1000));
  let expires = "expires="+ d.toUTCString();
  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}
function getCookie(cname) {
  let name = cname + "=";
  let decodedCookie = decodeURIComponent(document.cookie);
  let ca = decodedCookie.split(';');
  for(let i = 0; i <ca.length; i++) {
    let c = ca[i];
    while (c.charAt(0) == ' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length, c.length);
    }
  }
  return "";
}
function remoteTransmit(dev,command,pin){
if(dev.toLowerCase()!="a"&&dev.toLowerCase()!="b"){
alert("Device letter must be A or B");return;
}
$.get("udvrweb.php?d="+dev+"&c="+command+"&p="+Math.random()+pin,function(data){
switch(data*1){
case 0:alert("Server error");return;
case -1:alert("Bad symbols used");return;
case -2:alert("Bad password");return;
}
if(document.getElementById("sPIN").checked)setCookie("djUnreal_Pin",pin+Math.random(),30);
});
}
function pageloaded(){
document.getElementById("pin").value=getCookie("djUnreal_Pin").split(".")[0];
}
function submit(f){
f.action=location.pathname;
f.submit();
}
function setChannel(f){
document.getElementById("tvguide").src="channel.php?c="+Number(f.c.value);
}
</script>
<link rel="stylesheet" href="http://player.eyevinn.technology/v0.4.2/build/eyevinn-html-player.css">
</head>
<body onload="pageloaded()">
    <div id="player-wrapper"></div>

    <script src="http://player.eyevinn.technology/v0.4.2/build/eyevinn-html-player.js" type="text/javascript"></script>
    <script>
      document.addEventListener('DOMContentLoaded', function(event) {
        setupEyevinnPlayer('player-wrapper', 'http://host.delphianserver.com:888/stream/tv.m3u8').then(function(player) {
          var muteOnStart = false;
          player.play(muteOnStart);
        });
      });
    </script>
<form method="post" action="javascript:;">
Pin#:<input type="password" id="pin" name="p">
<input type="checkbox" id="sPIN">Save pin<br>
Device:<select name="d" id="device">
<option value="B" selected>B(default)</option>
<option value="A">A</option>
</select><br>
<datalist id="channels">
<option value="power">Power button</option>
<option value="info">info button</option>
<option value="exit">exit button</option>
<?php if($xmltvenabled){
$batfile='@echo off
if "%1"=="." goto nextch
if "%1"=="*" call %0 . ';
$tvguidedb="[channelsByNumber]
";
foreach($xml->{"channel"} as $ch){
$batfile.=$ch->{"display-name"}[2]." ";?>
<option value="<?php echo $ch->{"display-name"}[2];?>"><?php echo $ch->{"display-name"}[2]." ".$ch->{"display-name"}[0];?></option>
<?php $tvguidedb.=$ch->{"display-name"}[2]."=".$ch->{"display-name"}[0]."
";
}
}
$batfile.="
";?></datalist>Channel:<input name="c" id="selch" list="channels"><br>
<?php if($xmltvenabled){
$tvguidedb.="[channelsByID]
";
for($i=0;$i<count($xml->{"channel"});$i++)
foreach($xml->{"channel"}[$i]->attributes() as $a => $b){if($a=="id"){
$tvguidedb.=$xml->{"channel"}[$i]->{"display-name"}[2]."=".$b."
";
$batfile.='if "%1"=="'.$xml->{"channel"}[$i]->{"display-name"}[2].'" set cid='.$b.'
';
}}file_put_contents($channels_db,$tvguidedb);
$batfile.='goto done
:nextch
if "%2"=="" goto done
echo Processing channel %2...
call %0 %2
node udvrnode.js %cid% >%udvrdir%\channels\ch%2.js
shift /2
goto nextch
:done
';
if(!is_file($udvrdir."channels.bat"))
file_put_contents($udvrdir."channels.bat",$batfile);
}?>
<input type="button" value="Change Channel" onclick="remoteTransmit(this.form.d.value,this.form.c.value,this.form.p.value)">
<input type="button" value="See channel listing" onclick="setChannel(this.form)">
<p><iframe src="channel.php" height="255px" width="100%" id="tvguide">
</iframe></p>
</form>
</body>
</html>
