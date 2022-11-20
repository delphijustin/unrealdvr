<!doctype html>
<html>
<head>
<?php include 'config.php';
if($xmltvenabled)
$xml=simplexml_load_string(file_get_contents($channels_xml)) or die("</head><body>Please configure xmltv first</body></html>");
$jsChannels=file($channels_js);
?>
<style>
 
$sortcols: 'gchannel', 'tvshow', 'startat','stopsat','subtitle';
 
%sortcol {
  background: rgba(navy, .15);
  text-shadow: 0 1px #eee;
   
  &:before {
    box-shadow: 0 0 .5em navy;
  }
   
  &.prop__name {
    color: lightcyan;
     
    &[data-dir='1']:after { content: '▲'; }
    &[data-dir='-1']:after { content: '▼'; }
  }
}
 
* { box-sizing: inherit; }
 
body {
  background: #555;
  font: 1em/1.25 trebuchet ms, verdana, sans-serif;
  color: #fff;
}
 
table {
  box-sizing: border-box;
  overflow: hidden;
  margin: 4em auto;
  border-collapse: collapse;
  min-width: 23em; width: 70%; max-width: 56em;
  border-radius: .5em;
  box-shadow: 0 0 .5em #000;
}
 
thead {
  background: linear-gradient(#606062, #28262b);
  font-weight: 700;
  letter-spacing: 1px;
  text-transform: uppercase;
  cursor: pointer;
}
 
th { text-align: left; }
 
tbody {
  display: flex;
  flex-direction: column;
  color: #000;
}
 
tr {
  display: block;
  overflow: hidden;
  width: 100%;
}
 
.odd {
  background: linear-gradient(#eee 1px, #ddd 1px, #ccc calc(100% - 1px), #999 calc(100% - 1px));
}
 
.even {
  background: linear-gradient(#eee 1px, #bbb 1px, #aaa calc(100% - 1px), #999 calc(100% - 1px));
}
 
[class*='prop__'] {
  float: left;
  position: relative;
  padding: .5em 1em;
  width: 40%;
   
  &:last-child { width: 20%; }
   
  &:before {
    position: absolute;
    top: -.5em; right: 0; bottom: -5em; left: 0;
    content: ''
  }
   
  &:after {
    position: absolute;
    right: .5em;
  }
}
 
@each $col in $sortcols {
  [data-sort-by='#{$col}'] {
    [data-prop-name='#{$col}'] {
      @extend %sortcol;
    }
  }
}
</style>
<title>Listings for <?php echo $_GET['lq'];?></title>
</head>
<body onload="initTVGuide()">
<?php if(!$xmltvenabled){?>
<center>Please enable xmltv to use TVGuide</center>
</body>
</html>
<?php die();}
echo "<p>There are currently ".number_format(count($jsChannels))." shows in the database</p>";
function testTime($tvobj){
if(strlen($_GET['t'])==0)return false;
$start=strtotime($tvobj->startat);
$stops=strtotime($tvobj->stopsat);
$ts=strtotime($_GET['t']);
if($start<=$ts&&$stops>=$ts)return true;
return false;
}
?>
<form method="get">
<datalist id="channels"><?php
foreach($xml->{"channel"} as $ch){?>
<option value="#<?php echo $ch->{"display-name"}[2];?>"><?php echo $ch->{"display-name"}[2]." ".$ch->{"display-name"}[0];?></option><?php } ?></datalist>
Search:
<input list="channels" name="lq" value="<?php echo $_GET['lq'];?>">
Filter time:<input type="datetime-local" name="t" value="<?php echo $_GET['t'];?>">
<input type="submit" value="Search">
<input type="reset" value="Clear Search">
</form>
<table>
  <thead>
    <tr>
      <th class='prop__name' data-prop-name='gchannel'>Channel</th>
      <th class='prop__name' data-prop-name='tvshow'>TV Show</th>
      <th class='prop__name' data-prop-name='subtitle'>Subtitle</th>
      <th class='prop__name' data-prop-name='startat'>Start Time</th>
      <th class='prop__name' data-prop-name='stopsat'>End Time</th>
    </tr>
  </thead>
  <tbody></tbody>
</table>
<script>
var table = document.querySelector('table'), 
    table_meta_container = table.querySelector('thead'), 
    table_data_container = table.querySelector('tbody'),
    data = [
<?php $results=array();
foreach ($jsChannels as $line_num => $tvitem)
if(strlen($tvitem)>0){
$tvobj=json_decode($tvitem);
if(stripos(urldecode($tvobj->tvshow.$tvobj->subtitle.$tvobj->gchannel),$_GET['lq'])!==false||testTime($tvobj))
$results[]=$tvitem;
}
echo implode(',',$results);?>
], n = data.length;
 
var createTable = function(src) {
  var frag = document.createDocumentFragment(), 
      curr_item, curr_p;
   
  for(var i = 0; i < n; i++) {
    curr_item = document.createElement('tr');
    curr_item.classList.add(((i%2 === 0)?'odd':'even'));
    data[i].el = curr_item;
     
    for(var p in data[i]) {
      if(p !== 'el') {
        curr_p = document.createElement('td');
        curr_p.classList.add('prop__value');
        curr_p.dataset.propName = p;
        curr_p.textContent = data[i][p];
        curr_item.appendChild(curr_p)
      }
    }
     
    frag.appendChild(curr_item);
  }
   
  table_data_container.appendChild(frag);
};
 
var sortTable = function(entries, type, dir) {  
  entries.sort(function(a, b) { 
    if(a[type] < b[type]) return -dir;
    if(a[type] > b[type]) return dir;
    return 0;
  });
   
  table.dataset.sortBy = type;
   
  for(var i = 0; i < n; i++) {
    entries[i].el.style.order = i + 1;
     
    if((i%2 === 0 && entries[i].el.classList.contains('even')) || 
       (i%2 !== 0 && entries[i].el.classList.contains('odd'))) {
      entries[i].el.classList.toggle('odd');
      entries[i].el.classList.toggle('even');
    }
  }
};
 
createTable(data);
 
table_meta_container.addEventListener('click', function(e) {
  var t = e.target;
   
  if(t.classList.contains('prop__name')) {
    if(!t.dataset.dir) { t.dataset.dir = 1; }
    else { t.dataset.dir *= -1; }
     
    sortTable(data, t.dataset.propName, t.dataset.dir);
  }
}, false);
var TVGuideCols;
function initTVGuide(){
TVGuideCols=document.getElementsByClassName("prop__value");
for(var i=0;i<TVGuideCols.length;i++)
TVGuideCols[i].innerHTML=unescape(TVGuideCols[i].innerText.replaceAll("+"," "));
document.getElementById("newcount").innerText=document.getElementsByClassName("newepisode").length+" new episode";
if(document.getElementsByClassName("newepisode").length!=1)
document.getElementById("newcount").innerText+="s";
}
</script>
<p>Found <?php echo number_format(count($results));?> show<?php if(count($results)!=1)echo "s";?>&nbsp;
There are <span id="newcount"></span></p>
</body>
</html>
