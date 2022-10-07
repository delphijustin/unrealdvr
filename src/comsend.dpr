program comsend;

uses
  Forms,
  comsendUnit1 in 'comsendUnit1.pas' {COMSendWND};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TCOMSendWND, COMSendWND);
  Application.Run;
end.
