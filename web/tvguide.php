<pre>
<?php
include "config.php";
$xml=simplexml_load_string(file_get_contents($tvguide)) or die("Show information failed");
if(substr($_GET['c'],0,1)!='.'){
for($i=0;$i<count($xml->{"programme"});$i++)
foreach($xml->{"programme"}[$i]->attributes() as $a => $b)
if($a=="channel"&&$b==$_GET['c']){?>
<!-- begin -->
<?php print_r($xml->{"programme"}[$i]);?>
<!-- end -->
<?php }}else{
date_default_timezone_set('UTC');
for($i=0;$i<count($xml->{"programme"});$i++)
foreach($xml->{"programme"}[$i]->attributes() as $a => $b)
if($a=="start"&&strpos('='.$b,date(substr($_GET['c'],1)))==1){?>
<!-- begin -->
<?php print_r($xml->{"programme"}[$i]);?>
<!-- end -->
<?php }}?>