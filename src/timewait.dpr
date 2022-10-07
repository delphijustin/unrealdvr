program timewait;
{$RESOURCE TIMEWAIT-DATA.RES}
{$apptype console}

uses
  SysUtils,
  windows;
const default_time='hh:mm:ss';
var
systime1,systime2:systemtime;
I:Integer;
success:boolean;
stdout:thandle;
conscr:CONSOLE_SCREEN_BUFFER_INFO;

function consoleAbort(dwtype:Dword):bool;stdcall;
begin
writeln('*** TimeWait Aborted ***');
exitprocess(3);
end;

begin
setconsolectrlhandler(@consoleabort,true);
success:=false;
try
stdout:=getstdhandle(std_output_handle);
GetConsoleScreenBufferInfo(stdout,conscr);
case paramcount of
0:begin
setconsolectrlhandler(@consoleabort,false);
writeln('Usage:',extractfilename(paramstr(0)),' time1 [time2]');
writeln('If only one parameter is specified then it will use time1 as the end time.');
writeln('NOTE: For 12-hour times do not use spaces between time, example(3:00pm)');
writeln('For times that violate the time range, use only time1 and not [time2]');
writeln;
writeln('For more free tools visit http://tools.delphijustin.biz');
write('Press enter to quit...');
readln;
exitprocess(0);
end;
1:begin datetimetosystemtime(strtotime(paramstr(1)),systime1);success:=true;
PDWORD(@systime1.wSecond)^:=0;getlocaltime(systime2);systime2.wMonth:=12;
systime2.wDay:=30;systime2.wYear:=1899;pdword(@systime2.wSecond)^:=0;
 while systemtimetodatetime(systime1)<>systemtimetodatetime(systime2)do begin
 sleep(1000);getlocaltime(systime2);pdword(@systime2.wSecond)^:=0;
 writeln(timetostr(time));SetConsoleCursorPosition(stdout,conscr.dwCursorPosition);
 systime2.wMonth:=12;systime2.wDay:=30;systime2.wYear:=1899;end;end;
2:begin for I:=round(strtotime(paramstr(1))/encodetime(0,0,1,0))to round(
strtotime(paramstr(2))/encodetime(0,0,1,0))do begin Setconsolecursorposition(
stdout,conscr.dwCursorPosition); writeln(formatdatetime(default_time,i*
encodetime(0,0,1,0)));sleep(1000);success:=true;end;end;
else raise exception.Create(syserrormessage(error_invalid_parameter));
end;
if success then writeln(syserrormessage(0))else writeln('Time range error');
exitprocess(ord(not success));
except on e:exception do writeln(e.classname,': ',e.message);end;
exitprocess(2);
end.
