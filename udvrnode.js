const tvguide_xml='c:\\delphijustin\\tvguide.xml';
const node_xml_stream = require('node-xml-stream');
const parser = new node_xml_stream();
const fs = require('fs');
var nChannel=0;nProgramme=0;
let tvshow,icon,subtitle,category,desc;
var ch="";
var NewEpisode=false;
var categories=new Array();
process.argv.forEach((val, index) => {
 if(index==2){ch=val;}
});
// callback contains the name of the node and any attributes associated
parser.on('opentag', function(name, attrs) {
    if(name === "programme") {
        attr = attrs;
        nProgramme++;
tvshow="";
subtitle="";
category="";
desc="";
NewEpisode=false;
icon="defaulticon.gif";
    }
    if(name === "icon")icon=attrs.src;
    if(name === "new")NewEpisode=true;
    if(name === "channel")nChannel++;
    t_name = name;
});

// callback contains the name of the node.
parser.on('closetag', function(name) {
    if(name === "new")NewEpisode=true;
    if(name === 'programme') {
if(attr.channel==ch)console.log('addProgramme({"title":"'+tvshow+'","subtitle":"'+subtitle+'","desc":"'+desc+'","cat":"'+category+'","startsat":"'+attr.start+'","stopsat":"'+attr.stop+'","icon":"'+icon+'","NewEpisode":'+NewEpisode+'});');
}
});

// callback contains the text within the node.
parser.on('text', function(text) {
    if(t_name.toUpperCase() === 'TITLE') {
        tvshow= escape(text);
    }

    if(t_name.toUpperCase() === 'SUB-TITLE') {
        subtitle = escape(text);
    }
    if(t_name.toUpperCase() === 'CATEGORY') {
        category = text;
	if(categories.indexOf(text)==-1)categories.push(text);
    }
    if(t_name.toUpperCase() === 'DESC') {
        desc = escape(text);
    }
    if(t_name.toUpperCase() === 'NEW') {
       NewEpisode=true;
    }

});

// callback to do something after stream has finished
parser.on('finish', function() {
categories.forEach(function(cat){
console.log("addCategory('"+cat+"');");
});
   console.log('listingEnd({"date":'+Date.now()+',"cbChannel":'+nChannel+',"cbProgramme":'+nProgramme+'});');
});

let stream = fs.createReadStream(tvguide_xml, 'UTF-8');
stream.pipe(parser);
