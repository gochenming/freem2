program GameCenter;

uses
  Forms,
  GMain in 'GMain.pas' {frmMain},
  GShare in 'GShare.pas',
  HUtil32 in '..\Common\HUtil32.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  GLoginServer in 'GLoginServer.pas' {frmLoginServerConfig},
  GLoginServerRouteSet in 'GLoginServerRouteSet.pas' {frmLoginServerRouteSet},
  GCertServerSet in 'GCertServerSet.pas' {frmCertServerSet},
  Share in '..\LoginTools\Share\Share.pas',
  SDK in '..\SDK\SDK.pas',
  EDcode in 'EDcode.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.HintPause:=100;
  Application.HintShortPause:=100;
  Application.HintHidePause:=15000;  
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmLoginServerConfig, frmLoginServerConfig);
  Application.CreateForm(TfrmLoginServerRouteSet, frmLoginServerRouteSet);
  Application.CreateForm(TfrmCertServerSet, frmCertServerSet);
  Application.Run;
end.
