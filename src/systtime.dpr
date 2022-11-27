program systtime;

{$apptype console}

uses
  windows,sysutils;
var st0,st:systemtime;
ntype:byte=0;
offset:tdatetime;
err:integer;
function LocalDateTimeFromUTCDateTime(const UTCDateTime,offset: TDateTime): TDateTime;
var
  LocalSystemTime: TSystemTime;
  UTCSystemTime: TSystemTime;
  LocalFileTime: TFileTime;
  UTCFileTime: TFileTime;
begin
  DateTimeToSystemTime(UTCDateTime, UTCSystemTime);
  SystemTimeToFileTime(UTCSystemTime, UTCFileTime);
  if FileTimeToLocalFileTime(UTCFileTime, LocalFileTime)
  and FileTimeToSystemTime(LocalFileTime, LocalSystemTime) then begin
    Result := SystemTimeToDateTime(LocalSystemTime)+offset;
  end else begin
    Result := UTCDateTime;  // Default to UTC if any conversion function fails.
  end;
end;
begin
if comparetext(paramstr(1),'/vd')=0then
try strtodate(paramstr(2));exitprocess(0);except on e:exception do
begin writeln(e.message);;exitprocess(1);end;end;
if comparetext(paramstr(1),'/vt')=0then
try strtotime(paramstr(2)+paramstr(3));exitprocess(0);except on e:exception do
begin writeln(e.message);;exitprocess(1);end;end;
if pos(':',paramstr(1))>1then exitprocess(round(strtotime(paramstr(1))/
encodetime(0,0,1,0)));
if(pos('/',paramstr(2))<>1)and(length(paramstr(2))>0)then
datetimetosystemtime(strtotime(trim(paramstr(2)+paramstr(3))),st)else
getlocaltime(st);
if comparetext('/conv',paramstr(2))=0then
begin
st0.wYear:=strtoint(copy(paramstr(3),1,4));
st0.wMonth:=strtoint(copy(paramstr(3),5,2));
st0.wDay:=strtoint(copy(paramstr(3),7,2));
st0.wHour:=strtoint(copy(paramstr(3),9,2));
st0.wMinute:=strtoint(copy(paramstr(3),11,2));
st0.wSecond:=strtoint(copy(paramstr(3),13,2));
offset:=strtotime(format('%s:%s',[copy(paramstr(4),2,2),copy(paramstr(4),4,2)]));
case paramstr(4)[1]of
'+':;
'-':offset:=-offset;
else raise exception.Create('Timezone offset must begin with a + or -');
end;
datetimetosystemtime(LocalDateTimeFromUTCDateTime(systemtimetodatetime(st0),
offset),st);
end;
val(paramstr(1),ntype,err);
case ntype of
0:exitprocess(gettickcount);
1:exitprocess(st.wmonth);
2:exitprocess(st.wday);
3:exitprocess(st.wyear);
4:exitprocess(st.wdayofweek);
5:exitprocess(st.whour);
6:exitprocess(st.wminute);
7:exitprocess(st.wsecond);
8:exitprocess(st.wmilliseconds);
9:case st.wHour of
13..23:exitprocess(st.wHour-12);
0:exitprocess(12);
else exitprocess(st.whour);
  end;
 end;
end.
