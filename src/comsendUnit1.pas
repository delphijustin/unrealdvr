unit comsendUnit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CPDrv, StdCtrls;
const param_welcome='/welcome';
param_newline='/newline';
param_data='/data';
param_done='/done';
param_port='/port';
param_speed='/speed';
caption_inactive='COMSend(inactive)';
type
  TCOMSendWND = class(TForm)
    Memo1: TMemo;
    CommPortDriver1: TCommPortDriver;
    procedure CommPortDriver1ReceiveData(Sender: TObject; DataPtr: Pointer;
      DataSize: Cardinal);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  COMSendWND: TCOMSendWND;
  args:tstringlist;
implementation

{$R *.DFM}

procedure TCOMSendWND.CommPortDriver1ReceiveData(Sender: TObject;
  DataPtr: Pointer; DataSize: Cardinal);
var szpacket:pansichar;
begin
szpacket:=stralloc(datasize+1);
zeromemory(szpacket,datasize+1);
copymemory(szpacket,dataptr,datasize);
memo1.Text:=memo1.Text+strpas(szpacket);
if comparetext(args.values[param_welcome],szpacket)=0then
begin
if args.IndexOf(param_newline)=-1then
commportdriver1.SendString(args.values[param_data])else
commportdriver1.SendString(args.values[param_data]+#13#10);
end;
if comparetext(args.values[param_done],szpacket)=0then close;
strdispose(szpacket);
end;

procedure TCOMSendWND.FormCreate(Sender: TObject);
begin
memo1.Text:=format(memo1.text,[extractfilename(paramstr(0))]);
args:=tstringlist.Create;
args.CommaText:=strpas(getcommandline);
if paramcount>0then begin
commportdriver1.PortName:='\\.\'+args.Values[param_port];
commportdriver1.BaudRateValue:=strtointdef(args.values[param_speed],9600);
commportdriver1.Connect;
end else caption:=caption_inactive;
application.Title:=caption;
end;

end.
