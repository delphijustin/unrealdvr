<!doctype html>
<html>
<head>
<style>
.tg  {border-collapse:collapse;border-spacing:0;}
.tg td{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  overflow:hidden;padding:10px 5px;word-break:normal;}
.tg th{border-color:black;border-style:solid;border-width:1px;font-family:Arial, sans-serif;font-size:14px;
  font-weight:normal;overflow:hidden;padding:10px 5px;word-break:normal;}
.tg .tg-0lax{text-align:left;vertical-align:top
.newepisode{
color:red;
}
</style>
<title>Listing for channel <?php echo $_GET['c'];
$pathchar="\\";include 'config.php';
if(strpos($udvrdir,$pathchar)===false)$pathchar="/";?></title>
<script>
const updateComplete=<?php echo is_file($udvrdir.$pathchar."channels".$pathchar."success")*1;?>;
var programmes;
var lastUpdated=0;allShows=0;allChans=0;
var descriptions=new Array();
categories=new Array();
function showDescription(index){
alert(descriptions[index]);
}
function addCategory(cat){
categories.push(cat);
}
function filterTime(form){
let tx=new Date(form.t.value);
for(i=0;i<programmes.length;i++){
let td=programmes[i].getElementsByTagName("td");
if(tx.getTime()>=new Date(td[2].innerText).getTime()&&tx.getTime()<=new Date(td[3].innerText).getTime()){
programmes[i].style.display="table-row";}else{
programmes[i].style.display="none";
}
}
}
function addProgramme(programme){
var descindex=descriptions.push(unescape(programme.desc))-1;
let tr='<tr class="programme cat'+programme.cat.replaceAll(" ","_").replaceAll("&amp;","AND");
if(programme.NewEpisode)tr+=" newepisode";
tr+='"><td class="tg-0lax"><a href="//www.google.com/search?q='+programme.title+'%20'+programme.subtitle+'"><img src="'+programme.icon+'" height="128px" width="128px">'+unescape(programme.title)+'</a></td><td class="tg-0lax"><a href="javascript:showDescription('+descindex+')">'+unescape(programme.subtitle);
if(programme.subtitle=='')tr+='(No subtitle)';
tr+='</a></td><td class="tg-0lax">'+tvtime(programme.startsat)+'</td><td class="tg-0lax">'+tvtime(programme.stopsat)+'</td></tr>';
document.writeln(tr);
}
function pageStartup(){
programmes=document.getElementsByClassName("programme");
for(i=0;i<categories.length;i++){
var catop=document.createElement("option");
catop.value="cat"+categories[i].replaceAll(" ","_").replaceAll("&amp;","AND");
catop.innerText=categories[i].replaceAll("&amp;","&")+"("+document.getElementsByClassName(catop.value).length+")";
document.getElementById("cat").appendChild(catop);
}
document.getElementById("info").innerText=programmes.length+" show";
if(programmes.length!=1)
document.getElementById("info").innerText+="s";
document.getElementById("info").innerText+=" found. Last Updated "+new Date(lastUpdated).toString()+" "+allShows+" shows on "+allChans+" channels ";
if(updateComplete==0)
document.getElementById("info").innerText+="Updating database is still in progress ";
for(i=0;i<programmes.length;i++)
if(i%2==0)
programmes[i].style.backgroundColor="gray";
let allNew=document.getElementsByClassName("newepisode");
for(i=0;i<allNew.length;i++)
allNew[i].style.fontWeight="bolder";
}
function tvtime(ts){
let year=ts.substr(0,4);
let month=ts.substr(4,2);
let day=ts.substr(6,2);
let hour=ts.substr(8,2);
let minute=ts.substr(10,2);
let second=ts.substr(12,2);
let offset=ts.substr(15);
let ds=new Date(month+"/"+day+"/"+year+" "+hour+":"+minute+":"+second+" GMT"+offset).toLocaleString();
if(ds.indexOf(":")<0)return ds+' 12:00:00 AM';
return ds;
}
function filterClass(classname){
for(i=0;i<programmes.length;i++)
if(programmes[i].className.indexOf(classname)<0){
programmes[i].style.display="none";
}else{
programmes[i].style.display="table-row";
}
}
function listingEnd(obj){
lastUpdated=obj.date;
allShows=obj.cbProgramme;
allChans=obj.cbChannel;
}
function setChannel(form){
location.search="?c="+form.c.value;
}
</script>
</head>
<body onload="pageStartup()"><form action="javascript:;" method="get">
<?php
if($xmltvenabled)
$xml=simplexml_load_string(file_get_contents($channels_xml)) or $xmltvenabled=false; ?>
<datalist id="channels">
<?php
foreach($xml->{"channel"} as $ch){?>
<option value="<?php echo $ch->{"display-name"}[2];?>"><?php echo $ch->{"display-name"}[2]." ".$ch->{"display-name"}[0];?></option>
<?php }?></datalist>
Channel:<input list="channels" name="c">
Category:<select id="cat" oninput="filterClass(this.value)">
<option value="programme" selected>Show All</option>
<option value="newepisode">Only new episodes</option>
</select>
Time:<input type="datetime-local" name="t" value="<?php $_GET['t'];?>">
<input type="button" onclick="setChannel(this.form)" value="Show Listings">
<input type="button" onclick="filterTime(this.form)" value="Filter Time">
</form>
<table class="tg">
<thead>
  <tr>
    <th class="tg-0lax">TVShow</th>
    <th class="tg-0lax">Subtitle</th>
    <th class="tg-0lax">Start Time</th>
    <th class="tg-0lax">End Time</th>
  </tr>
</thead>
<tbody>
<script><?php $pathchar="\\";
if(strpos($udvrdir,$pathchar)===false)$pathchar="/";
$chfn=$udvrdir."channels".$pathchar."ch".$_GET['c'].".js";
readfile($chfn);
?></script>
</tbody>
</table>
<p>
<!-- DO NOT REMOVE THIS LINE --><a href="https://www.flaticon.com/free-icons/television" title="television icons">Television icons created by Freepik - Flaticon</a>
<?php if(!is_file($chfn)&&strlen($_GET['c'])>0){?>
Channel file not made yet.<?php }?>
<div id="info"><div></p>
</body>
</html>
