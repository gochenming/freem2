unit PrefConfig;

interface

uses
  svn, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin,IniFiles;

type
  TfrmPrefConfig = class(TForm)
    GroupBoxServer: TGroupBox;
    EditServerCheckTimeOut: TSpinEdit;
    LabelCheckTimeOut: TLabel;
    GroupBox1: TGroupBox;
    LabelSendBlockSize: TLabel;
    EditSendBlockSize: TSpinEdit;
    ButtonOK: TButton;
    procedure EditServerCheckTimeOutChange(Sender: TObject);
    procedure EditSendBlockSizeChange(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    boShowOK:Boolean;//��������ʾ����ǰ���������¼�
    { Public declarations }
  end;

var
  frmPrefConfig: TfrmPrefConfig;

implementation

uses GateShare;

{$R *.dfm}

procedure TfrmPrefConfig.EditServerCheckTimeOutChange(Sender: TObject);
begin
  if boShowOK then
    dwCheckServerTimeOutTime:=EditServerCheckTimeOut.Value * 1000;
end;

procedure TfrmPrefConfig.EditSendBlockSizeChange(Sender: TObject);
begin
  if boShowOK then
    nClientSendBlockSize:=EditSendBlockSize.Value;
end;

procedure TfrmPrefConfig.ButtonOKClick(Sender: TObject);
begin
  Conf.WriteInteger(GateClass,'ServerCheckTimeOut',dwCheckServerTimeOutTime);
  Conf.WriteInteger(GateClass,'ClientSendBlockSize',nClientSendBlockSize);
  Close;
end;


{---- Adjust global SVN revision ----}
initialization
  SVNRevision('$Id: PrefConfig.pas 121 2006-08-06 01:10:41Z Dataforce $');
end.
