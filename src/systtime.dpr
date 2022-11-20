program systtime;

{$apptype console}

uses
  windows,sysutils;
var st:systemtime;
ntype:byte=0;
err:integer;
begin
if comparetext(paramstr(1),'/vd')=0then
try strtodate(paramstr(2));exitprocess(0);except on e:exception do
begin writeln(e.message);;exitprocess(1);end;end;
if comparetext(paramstr(1),'/vt')=0then
try strtotime(paramstr(2)+paramstr(3));exitprocess(0);except on e:exception do
begin writeln(e.message);;exitprocess(1);end;end;
if pos(':',paramstr(1))>1then exitprocess(round(strtotime(paramstr(1))/
encodetime(0,0,1,0)));
if length(paramstr(2))>0then
datetimetosystemtime(strtotime(trim(paramstr(2)+paramstr(3))),st)else
getlocaltime(st);
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
end;
end.
