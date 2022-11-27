<?php header("Content-type: text/plain");
if($_GET['config']!=1)die("This cannot be installed from a web browser");
$installerid=random_int(1,PHP_INT_MAX);
$bStrXMLTV="false";
if(strtolower($_GET['xmlkey'])!="/null")$bStrXMLTV="true";
$insChannels_xml='$udvrdir."channels.xml"';
if(strtolower($_GET['xmlkey'])=="/free")
$insChannels_xml='"http://hosts.delphianserver.com:888/mediacom-chan.xml"';
?>
[results]
Wrote=<?php echo file_put_contents('config.php','<?php
$pin='.explode(".",$_GET['pin'])[0].';//the secret pin# used to change channels.
$udvrdir="'.$_GET['dir'].'";
$lastremo_bat=$udvrdir."lastremo.bat";//filename for where the channel commands are written to
$xmltvenabled='.$bStrXMLTV.';//Set to true to use xmltv if you have the correct xml files
$tvguide=$udvrdir."tvguide.xml";//path to tvguide.xml, this file is made by xmltvlistings.com
$channels_xml='.$insChannels_xml.';
$channels_db=$udvrdir."channels.db";//filename for channel database
$channels_js=$udvrdir."channels.js";//for web-based tvguide
$hlsurl="'.$_GET['hls'].'";//url to hls m3u8 stream file
?>
')*1;?>

freshinstall=<?php if(is_file("install.php")){echo "1
";}else {echo "0
";}?>
newid=<?php echo $installerid."
";?>
[index.php]
<?php include "index.php";
if(copy("install.php","install".$installerid.".php"))unlink("install.php");
?>
<?php header("Content-type: text/plain");
if($_GET['config']!=1)die("This cannot be installed from a web browser");
$installerid=random_int(1,PHP_INT_MAX);
$bStrXMLTV="false";
if(strtolower($_GET['xmlkey'])!="/null")$bStrXMLTV="true";
$insChannels_xml='$udvrdir."channels.xml"';
if(strtolower($_GET['xmlkey'])=="/free")
$insChannels_xml='"http://hosts.delphianserver.com:888/mediacom-chan.xml"';
?>
[results]
Wrote=<?php echo file_put_contents('config.php','<?php
$pin='.explode(".",$_GET['pin'])[0].';//the secret pin# used to change channels.
$udvrdir="'.$_GET['dir'].'";
$lastremo_bat=$udvrdir."lastremo.bat";//filename for where the channel commands are written to
$xmltvenabled='.$bStrXMLTV.';//Set to true to use xmltv if you have the correct xml files
$tvguide=$udvrdir."tvguide.xml";//path to tvguide.xml, this file is made by xmltvlistings.com
$channels_xml='.$insChannels_xml.';
$channels_db=$udvrdir."channels.db";//filename for channel database
$channels_js=$udvrdir."channels.js";//for web-based tvguide
$hlsurl="'.$_GET['hls'].'";//url to hls m3u8 stream file
?>
')*1;?>

freshinstall=<?php if(is_file("install.php")){echo "1
";}else {echo "0
";}?>
newid=<?php echo $installerid."
";?>
[index.php]
<?php include "index.php";
if(copy("install.php","install".$installerid.".php"))unlink("install.php");
?>
