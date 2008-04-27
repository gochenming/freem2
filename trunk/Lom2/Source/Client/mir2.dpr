program mir2;

uses
  Forms,
  Dialogs,
  IniFiles,
  Windows,
  SysUtils,
  ClMain in 'ClMain.pas' {frmMain},
  FState in 'FState.pas' {FrmDlg},
  DlgConfig in 'DlgConfig.pas' {frmDlgConfig},
  DrawScrn in 'DrawScrn.pas',
  IntroScn in 'IntroScn.pas',
  PlayScn in 'PlayScn.pas',
  MapUnit in 'MapUnit.pas',
  ClFunc in 'ClFunc.pas',
  cliUtil in 'cliUtil.pas',
  DWinCtl in 'DWinCtl.pas',
  WIL in 'WIL.pas',
  magiceff in 'magiceff.pas',
  SoundUtil in 'SoundUtil.pas',
  Actor in 'Actor.pas',
  HerbActor in 'HerbActor.pas',
  AxeMon in 'AxeMon.pas',
  clEvent in 'clEvent.pas',
  HUtil32 in 'HUtil32.pas',
  Grobal2 in '..\Common\Grobal2.pas',
  MShare in 'MShare.pas',
  SDK in '..\SDK\SDK.pas',
  Mpeg in 'Mpeg.pas',
  wmutil in 'wmutil.pas',
  Share in 'Share.pas',
  EDcode in '..\Common\EDcode.pas',
  svn in '..\Common\svn.pas',
  nixtime in '..\Common\nixtime.pas',
  WebForm in 'WebForm.pas' {Form1};

{$R *.RES}

var
  AppPath: String;
begin
  Application.Initialize;

  AppPath := IncludeTrailingPathDelimiter(ExtractFileDir(Application.ExeName));
  if not DirectoryExists(AppPath+'Data') then begin
    Application.MessageBox('�����ļ����޷��ҵ�������exe�Ƿ��ڿͻ���Ŀ¼�С�','����');
    exit;
  end;

  //Application.Title := 'legend of mir';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TFrmDlg, FrmDlg);
  Application.CreateForm(TfrmDlgConfig, frmDlgConfig);
  InitObj();

  g_nThisCRC := CalcFileCRC(Application.ExeName);
  Application.Run;
end.
