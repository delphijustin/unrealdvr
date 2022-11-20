program sortmp4;

{$apptype console}

uses
  windows,
  sysutils,
  Classes;
type TMP4Sort=record
Created:filetime;
filename:array[0..max_path]of char;
Handle:thandle;
end;
PMP4Sort=^TMP4Sort;
var filelist:tlist;
Files:tstringlist;
mp4sort:pmp4sort;
I:integer;

function compareMP4(item1,item2:Pointer):Integer;
begin
result:=comparefiletime(pmp4sort(item1).created,pmp4sort(item2).created);
end;
begin
files:=tstringlist.Create;
files.LoadFromFile(paramstr(1));
filelist:=tlist.Create;
for I:=0to files.Count-1do
begin
new(mp4sort);
mp4sort.Handle:=createfile(strplcopy(mp4sort.filename,files[I],max_path),
generic_read,file_share_read or file_share_write or file_share_delete,nil,
open_existing,file_attribute_normal,0);
if getfiletime(mp4sort.Handle,@mp4sort.Created,nil,nil)then filelist.Add(mp4sort);
closehandle(mp4sort.handle);
end;
filelist.Sort(@comparemp4);
files.Clear;
for I:=0to filelist.Count-1do files.Append(format('file %s',[PMP4Sort(filelist[i
]).filename]));
files.Text:=stringreplace(files.Text,'\','\\',[rfreplaceall]);
files.SaveToFile(Paramstr(1));
exitprocess(filelist.Count);
end.
