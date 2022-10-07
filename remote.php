<!DOCTYPE html>
<html>
<body>
<pre><?php $loggedon=false;
define('Password','P@ssword');//Change P@ssword to a different password
/*
default password is P@ssword
When installing make sure IIS has Anonymous User account the same as your windows account.
To do this Double click on Authentication
Click Anonymous Authentication
Click Edit...
*/
if(strlen($_POST['p'])>0){
if(Password==$_POST['p']){
$loggedon=true;
passthru('C:\\delphijustin\\udvr.bat '.$_POST['c']*1);
}
if(!$loggedon){
?>Invalid Password<?php }}?></pre>
<form method="post">
Password:<input type="password" name="p"><br>
Channel:<input type="number" name="c">
<input type="submit" value="Change Channel">
</form>
</body>
</html>