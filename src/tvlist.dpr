program tvlist;
{$apptype console}
uses
  SysUtils,
  windows,
  comobj,
  classes,
  inifiles,
  httpapp,
  filectrl,
  shellapi,
  urlmon;
const xmltvlistings_com:array[0..1]of pchar=(
'https://www.xmltvlistings.com/xmltv/get/%s/%s/%d',
'https://www.xmltvlistings.com/xmltv/get_channels/%s/%s');
install_url='%s/install%s.php?pin=%g&hls=%s&dir=%s&xmlkey=%s&config=1';
tvguide_php_url='?c=%s&r=%g';
mediacom_dwight='http://host.delphianserver.com:888/mediacom-dwight.php?f=%d';
config_done:dword=1;
var fn,url,fmturl,jsfile,rold,hls:array[0..max_path]of char;
I,count,foundM3U8:integer;
systemdrive:array[0..4]of char;
apikey,lineup,installerid:array[byte]of char;
dbfile:tinifile;
t1,t2,showStart:tdatetime;
disp,rs,fileid,tid,wrote,xmlfetch,dwPin:dword;
hk,hkserver:hkey;
db,chListings,chItem:tstringlist;
stdout,js:THandle;
chan,installdir:string;
pin:array[0..15]of char;
jsarray:ansistring;
srM3U8:TSearchRec;
chansFound:tlist;
conAttrib:word=foreground_red or foreground_green or foreground_blue;
function GetConsoleWindow:HWND;stdcall;external kernel32;
label retryCh,chooseCh,goodpass,badpass;
function Ask(validAnswers:array of string):integer;
label tryagain;
var I:integer;
choice:string;
begin
result:=-1;
write('Type ');
for i:=low(validanswers)to high(validanswers)do
if i<high(validanswers)then write(validanswers[i],', ')else write('or ',
validanswers[i],':');
tryagain:readln(choice);
for I:=low(validanswers)to high(validanswers)do
if comparetext(validanswers[i],trim(choice))=0then result:=I;
if result>-1then exit;
writeln('"',choice,'" is not a valid option');
goto tryagain;
end;
function querytvlistsettings:boolean;
var rs,cnsize:dword;
begin
disp:=0;
regcreatekeyex(hk,'TVList',0,nil,reg_option_non_volatile,key_all_access,nil,
hkserver,@disp);strcopy(apikey,'/null');lineup[0]:=#0;
result:=(disp<>reg_created_new_key);
dwPin:=0;strcopy(hls,'tv.m3u8');
rs:=sizeof(hls);regqueryvalueex(hkserver,'M3U8Url',nil,nil,@hls,@rs);
rs:=4;regqueryvalueex(hkserver,'pin',nil,nil,@dwpin,@rs);strfmt(pin,'%d',[dwpin]);
cnsize:=max_computername_length;getcomputername(strend(strcopy(url,'http://')),
cnsize);
rs:=sizeof(url);regqueryvalueex(hkserver,'RootURL',nil,nil,@url,@rs);
rs:=sizeof(apikey);regqueryvalueex(hkserver,'XMLTVListingsKey',nil,nil,@apikey,@rs);
rs:=sizeof(lineup);regqueryvalueex(hkserver,'XMLTVListingsLineup',nil,nil,@lineup,@rs);
xmlfetch:=2;rs:=4;regqueryvalueex(hkserver,'XMLFetch',nil,nil,@xmlfetch,@rs);
installerid[0]:=#0;rs:=sizeof(installerid);regqueryvalueex(hkserver,'InstallID',
nil,nil,@installerid,@rs);
end;
function busyThread(reserved:pointer):dword;stdcall;
label loop;
begin
loop:sleep(1000);
write('.');
goto loop;
end;
function lookupChannel(const ch:string):string;
var I:integer;
begin
result:='';
for I:=0to db.Count-1do begin
if(db.Names[i]=ch)then result:=db.Values[db.Names[i]];
if(db.Values[db.Names[i]]=ch)then result:=db.Names[i];
if length(result)>0then exit;
end;
end;
Function UnivDateTime2LocalDateTime(d:TDateTime):TDateTime;
var
 TZI:TTimeZoneInformation;
 LocalTime, UniversalTime:TSystemTime;
begin
  GetTimeZoneInformation(tzi);
  DateTimeToSystemTime(d,UniversalTime);
  SystemTimeToTzSpecificLocalTime(@tzi,UniversalTime,LocalTime);
  Result := SystemTimeToDateTime(LocalTime);
end;
function DateTimeToXML(t:tdatetime;const offset:string='+0000'):string;
begin
result:=formatdatetime('yyyymmddhhnn',t)+'00 '+offset;
end;
function downloaddatabase(options:longword):dword;stdcall;
begin
if options and 1>0then
regcreatekeyex(hkey_current_user,'Software\Justin\UnrealDVR',0,nil,
reg_option_non_volatile,key_all_access,nil,hk,nil);
QueryTVListSettings;
if options and 1>0then
regclosekey(hk);regclosekey(hkserver);
if(pos('/null',lowercase(apikey))>0)then raise exception.Create('API Key is /null');
if(pos('/free',lowercase(apikey))=0)then strlfmt(url,max_path,xmltvlistings_com[
strtoint(paramstr(1))],[apikey,lineup,strtointdef(paramstr(3),2)])else strfmt(url,
mediacom_dwight,[strtoint(paramstr(1))]);
writeln('Downloading database from ',stringreplace(url,apikey,'{API_KEY}',[]),
'...');
try
olecheck(URLDownloadToFile(nil,url,strplcopy(fn,paramstr(2),max_path),0,nil));
except on e:exception do begin write('DownloadDB: ',e.message);result:=1;exit;
end;end;
result:=0;
end;
function XMLToDateTime(const s:string):tdatetime;
var yyyy,mm,dd,hh,nn,ss,xx:string;
begin
yyyy:=copy(s,1,4);
mm:=copy(s,5,2);
dd:=copy(s,7,2);
hh:=copy(s,9,2);
nn:=copy(s,11,2);
ss:=copy(s,13,2);
xx:=copy(s,16,5);
if xx[1]='+'then
result:=UnivDateTime2LocalDateTime(strtodatetime(format('%s/%s/%s %s:%s:%s',[
mm,dd,yyyy,hh,nn,ss]))+strtotime(format('%s:%s',[copy(xx,2,2),copy(xx,4,2)])))else
if xx[1]='-'then
result:=UnivDateTime2LocalDateTime(strtodatetime(format('%s/%s/%s %s:%s:%s',[
mm,dd,yyyy,hh,nn,ss]))-strtotime(format('%s:%s',[copy(xx,2,2),copy(xx,4,2)])))else
raise exception.CreateFmt('"%s" is not a valid time offset',[xx]);
end;
begin
try
if paramcount=0then
begin
regcreatekeyex(hkey_current_user,'Software\Justin\UnrealDVR',0,nil,
reg_option_non_volatile,key_all_access,nil,hk,nil);apikey[0]:=#0;lineup[0]:=#0;
disp:=0;
querytvlistsettings;
writeln('XMLTVListings.com is a database of TV Channels and shows.');
writeln('It costs $19.99 yearly, if you don'#39't wanna use the database type /null for the api key');
writeln('If you want a free database of shows with the channel numbers correct');
writeln('for Mediacom dwight,il type /free for the api key');
writeln;
write('Enter XMLTVListings.com API Key[',apikey,']:');strcopy(rold,apikey);
readln(apikey);
if length(trim(apikey))>0then begin strcopy(rold,apikey);
regsetvalueex(hkserver,'XMLTVListingsKey',0,reg_sz,@apikey,sizeof(char)*(1+strlen(
apikey)));end;strcopy(apikey,rold);write(
'Enter Lineup ID(can be left blank if free or no database is used)[',lineup,']: ');
readln(lineup);
if length(trim(lineup))>0then
regsetvalueex(hkserver,'XMLTVListingsLineup',0,reg_sz,@lineup,sizeof(char)*(1+strlen(
lineup)));
writeln(
'The unreal web server files must be put in a directory where the files can be access from a web browser and Unreal DVR');
writeln('The folder must have the following files:');
writeln(
'config.php,index.php,jquery-3.6.1.min.js,tvguide.php,listings.php,udvrweb.php,install.php');
write('Enter URL for unreal website files:[',url,']: ');strcopy(fmturl,url);
readln(url);
if length(trim(url))>0then
regsetvalueex(hkserver,'RootURL',0,reg_sz,@url,sizeof(char)*(1+strlen(url)))else
strcopy(url,fmturl);fmturl[0]:=#0;
write('Enter a pin#(for changing channels)[',pin,']: ');readln(pin);
dwpin:=strtointdef(pin,dwpin);regsetvalueex(hkserver,'pin',0,reg_dword,@dwpin,4);
strfmt(pin,'%d',[dwpin]);
write('Enter HLS .m3u8 file URL[',hls,']: ');strcopy(rold,hls);readln(hls);
if length(trim(hls))>0then begin strcopy(rold,hls);
regsetvalueex(hkserver,'M3U8Url',0,reg_sz,@hls,sizeof(char)*(1+strlen(hls)));end;
strcopy(hls,rold);
getenvironmentvariable('SystemDrive',systemdrive,4);
installdir:=strpas(systemdrive)+'\\delphijustin\\';
if directoryexists(format('%s\cygwin64\srv\www',[systemdrive]))or directoryExists(
format('%s\cygwin\srv\www',[systemdrive]))then begin
writeln('Cygwin webserver was found, is thats where the web files located?');
case ask(['yes','no'])of
0:installdir:=format(
'/cygdrive/%s/delphijustin/',[copy(lowercase(systemdrive),1,1)]);
end;
end;
strlfmt(fmturl,max_path,install_url,[url,installerid,strtointdef(pin,0)+time,
httpencode(hls),httpencode(installdir),httpencode(apikey)]);
writeln('Configuring...');try olecheck(urldownloadtofile(nil,fmturl,'tvlist.web',
0,nil));except on e:exception do writeln('WebError: ',e.message);end;
if getprivateprofileint('results','freshinstall',2,'.\tvlist.web')=1then begin
getprivateprofilestring('results','newid','',installerid,255,'.\tvlist.web');
regsetvalueex(hkserver,'InstallID',0,reg_sz,@installerid,sizeof(char)*(1+strlen(
installerid)));end;
if getprivateprofileint('results','Wrote',0,'.\tvlist.web')=0then
writeln('Configure failed')else begin
regsetvalueex(hkserver,'configVersion',0,reg_dword,@config_done,4);end;
writeln('Press enter to return...');readln;
regclosekey(hk);
regclosekey(hkserver);
exitprocess(0);
end;
stdout:=getstdhandle(std_output_handle);
chansfound:=tlist.Create;
expandenvironmentstrings('%SystemDrive%\delphijustin\channels.db',fn,max_path+1);
dbfile:=tinifile.Create(fn);
db:=tstringlist.create;
if comparetext(paramstr(1),'/search')=0then begin
dbfile.ReadSectionValues( 'channelsByID',db);
db.Text:=stringreplace(db.Text,'-','',[rfreplaceall]);
if db.IndexOfName(Paramstr(2))<0then raise exception.CreateFmt(
'%s channel not found',[paramstr(2)]);
regcreatekeyex(hkey_current_user,'Software\Justin\UnrealDVR',0,nil,
reg_option_non_volatile,key_all_access,nil,hk,nil);
QueryTVListSettings;
regqueryvalueex(hkserver,'RootURL',nil,nil,@url,@rs);strcat(url,'/tvguide.php');
regclosekey(hkserver);regclosekey(hk);
if strlen(url)=0 then raise exception.Create('Please ccnfigure tvlist');
strlfmt(fmturl,max_path,strlcat(url,tvguide_php_url,max_path),[db.values[
paramstr(2)],getcurrentprocessid+time]);fileid:=gettempfilename('.','udvrls',0
,fn);writeln('Downloading results...');
olecheck(urldownloadtofile(nil,fmturl,fn,0,nil));
chlistings:=tstringlist.Create;
chitem:=tstringlist.Create;chlistings.LoadFromFile(fn);deletefile(fn);chlistings.Text:=
stringreplace(stringreplace(stringreplace(stringreplace(chlistings.Text,']','',[
rfreplaceall]),'[','',[rfreplaceall]),' => ','=',[rfreplaceall]),'  ','',[
rfreplaceall]);count:=0;showstart:=now;
while chlistings.IndexOf('<!-- begin -->')>-1do
begin
chitem.Clear;
for i:=chlistings.IndexOf('<!-- begin -->')+1to chlistings.IndexOf('<!-- end -->')-1do
chitem.Append(chlistings[i]);
if(chlistings.IndexOf('<!-- begin -->')+chlistings.IndexOf('<!-- end -->')<0)
then break;
chlistings[chlistings.IndexOf('<!-- begin -->')]:='';
chlistings[chlistings.IndexOf('<!-- end -->')]:='';
t1:=xmltodatetime(chitem.values['start']);
t2:=xmltodatetime(chitem.values['stop']);
if((pos(uppercase(paramstr(3)),uppercase(chitem.Text))>0)or(paramstr(3)='*'))and((
frac(t1)>=frac(showstart))and(trunc(showstart)=trunc(t1))or(pos(' /-T',uppercase(
getcommandline))>0))then begin
setconsoletextattribute(stdout,conattrib);
conattrib:=conattrib xor background_green;inc(count);write(count,'. ');
if chitem.Values['new']='SimpleXMLElement Object'then write('(new) ');
write(datetimetostr(xmltodatetime(chitem.values['start'])),' to ',datetimetostr(
xmltodatetime(chitem.values['stop'])),' -> ',chitem.values['title'],' ');
writeln(chitem.values['sub-title']);
if length(chitem.values['desc'])>0then writeln(chitem.values['desc']);
end;
end;
setconsoletextattribute(stdout,foreground_red or foreground_green or
foreground_blue);
if count=0 then writeln('Nothing found for "',paramstr(3),'"');exitprocess(count);
end;
if comparetext(paramstr(1),'/js')=0then begin
regcreatekeyex(hkey_current_user,'Software\Justin\UnrealDVR',0,nil,
reg_option_non_volatile,key_all_access,nil,hk,nil);
rs:=sizeof(url);url[0]:=#0;
querytvlistsettings;
regqueryvalueex(hkserver,'RootURL',nil,nil,@url,@rs);strcat(url,'/tvguide.php');
regclosekey(hkserver);
regclosekey(hk);
if strlen(url)=0 then begin writeln('Please configure tvlist');exitprocess(0);end;
dbfile.ReadSectionValues( 'channelsByID',db);
db.Text:=stringreplace(db.Text,'-','',[rfreplaceall]);
expandenvironmentstrings('%SystemDrive%\delphijustin\channels.js_',jsfile,max_path+1);
js:=createfile(jsfile,generic_write,file_share_read or file_share_write,nil,
create_always,file_attribute_normal,0);
strlfmt(fmturl,max_path,strlcat(url,tvguide_php_url,max_path),['.Ymd'+paramstr(
2),time+getcurrentprocessid]);
fileid:=gettempfilename('.','udvrls',0,fn);writeln('Downloading results...');
createthread(nil,0,@busythread,nil,0,tid);
olecheck(urldownloadtofile(nil,fmturl,fn,0,nil));
jsarray:='';
chlistings:=tstringlist.Create;chitem:=tstringlist.Create;
chlistings.LoadFromFile(fn);
writeln('Creating javascript channels(this may take alot of minutes)...');
deletefile(fn);
chlistings.Text:=stringreplace(stringreplace(stringreplace(
stringreplace(chlistings.Text,']','',[rfreplaceall]),'[','',[rfreplaceall]),
' => ','=',[rfreplaceall]),'  ','',[rfreplaceall]);
while chlistings.IndexOf('<!-- begin -->')>-1do
begin
chitem.Clear;
for i:=chlistings.IndexOf('<!-- begin -->')+1to chlistings.IndexOf('<!-- end -->')-1do
chitem.Append(chlistings[i]);
if(chlistings.IndexOf('<!-- begin -->')+chlistings.IndexOf('<!-- end -->')<0)
then break;
chlistings[chlistings.IndexOf('<!-- begin -->')]:='';
chlistings[chlistings.IndexOf('<!-- end -->')]:='';
t1:=xmltodatetime(chitem.values['start']);
t2:=xmltodatetime(chitem.values['stop']);
if chitem.Values['new']='SimpleXMLElement Object'then jsarray:=jsarray+
#13#10'{"tvshow":"'+httpencode('<b class="newepisode">NEW '+chitem.values['title']+
'</b>')+'","subtitle":"'+httpencode(chitem.values['sub-title'])+'","startat":"'+datetimetostr(t1)+
'","stopsat":"'+datetimetostr(t2)+'","gchannel":"#'+lookupchannel(chitem.values[
'channel'])+' '+dbfile.ReadString('channelsByNumber',lookupchannel(chitem.values[
'channel']),'CHANNEL_ERROR')+'"}'else jsarray:=jsarray+#13#10'{"tvshow":"'+
httpencode(chitem.values['title'])+'","subtitle":"'+httpencode(chitem.values[
'sub-title'])+'","startat":"'+datetimetostr(t1)+'","stopsat":"'+datetimetostr(t2
)+'","gchannel":"#'+lookupchannel(chitem.values['channel'])+' '+dbfile.ReadString
('channelsByNumber',lookupchannel(chitem.values['channel']),'CHANNEL_ERROR')+'"}';
end;
writefile(js,jsarray[1],length(jsarray),wrote,nil);
closehandle(js);
deletefile(strpcopy(fn,changefileext(jsfile,'.js')));
renamefile(jsfile,fn);
exitprocess(0);
end;
if comparetext(paramstr(1),'/chan')=0then begin
dbfile.ReadSectionValues('channelsByNumber',db);
db.Text:=stringreplace(uppercase(db.text),'-','',[rfreplaceall]);
retryCh:
if db.Count=0 then begin writeln(
'Cannot use names since channels.db is empty or not found');
write('Enter channel#(type abort to cancel): ');
end else write('Channel Search(type abort to cancel): ');readln(chan);
if(strtointdef(chan,0)<1)and(comparetext(chan,'abort')<>0)and(db.Count=0)then
goto retryCh;
chansfound.Clear;
if(comparetext(chan,'abort')=0)then exitprocess(0);
if(strtointdef(chan,0)>0)then exitprocess(strtoint(chan));
for I:=0to db.count-1do
if(pos(uppercase(chan),db[i])>0)and(strtointdef(db.names[i],0)>0)then
writeln(chansfound.Add(pointer(strtointdef(db.names[i],0))),'. ',db.values[
db.names[i]],' on ',db.names[i]);
if chansfound.Count=0then begin writeln('Nothing found for "',chan,'"');
goto retryCh;end;
chooseCh:write('Pick a number between 0 and ',chansfound.count-1,
' type abort to cancel: ');chan:='';readln(chan);if comparetext('abort',chan)=0
then exitprocess(0);if(strtointdef(chan,-1)<0)or(strtointdef(chan,-1)>=
chansfound.Count)then goto chooseCh;write('You choose #',chan);exitprocess(
integer(chansfound[strtoint(chan)]));;
end;
if(comparetext(paramstr(1),'/test')=0)then begin
regcreatekeyex(hkey_current_user,'Software\Justin\UnrealDVR',0,nil,
reg_option_non_volatile,key_all_access,nil,hk,nil);apikey[0]:=#0;lineup[0]:=#0;
rs:=sizeof(fn);regqueryvalueex(hk,'M3U8Path',nil,nil,@fn,@rs);regclosekey(hk);
foundM3u8:=findfirst(format('%s\*.m3u8',[fn]),faAnyfile,srm3u8);
sysutils.FindClose(srM3u8);
exitprocess(foundm3u8);
end;
if(strtointdef(paramstr(1),-1)<0)or(strtointdef(paramstr(1),0)>1)then
raise exception.Create(syserrormessage(error_invalid_parameter));
downloadDatabase(1);
except on e:exception do begin writeln(e.message);showwindow(getconsolewindow,
sw_show);exitprocess(maxlong);end;end;
showwindow(getconsolewindow,sw_show);
end.
