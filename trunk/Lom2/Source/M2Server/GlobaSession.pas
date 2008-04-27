unit GlobaSession;

interface

uses
  svn, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ExtCtrls;

type
  TfrmGlobaSession = class(TForm)
    StringGrid: TStringGrid;
    RefTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure RefTimerTimer(Sender: TObject);
  private
    procedure RefShow();
    { Private declarations }
  public
    procedure ShowDlg();
    { Public declarations }
  end;

var
  frmGlobaSession: TfrmGlobaSession;

implementation

uses IDSocCli, Grobal2;

{$R *.dfm}

procedure TfrmGlobaSession.FormCreate(Sender: TObject);
begin
  StringGrid.Cells[0,0]:='Session ID';
  StringGrid.Cells[1,0]:='IP Address';
  StringGrid.Cells[2,0]:='Account ID';
  StringGrid.Cells[3,0]:='Joined Session';
end;

procedure TfrmGlobaSession.ShowDlg;
begin
  RefTimer.Enabled:=True;
  RefShow();
  ShowModal;
  RefTimer.Enabled:=False;
end;

procedure TfrmGlobaSession.RefTimerTimer(Sender: TObject);
begin
  RefShow();
end;

procedure TfrmGlobaSession.RefShow;
var
  i:integer;
  GlobaSessionInfo:pTGlobaSessionInfo;
begin
  StringGrid.RowCount:=FrmIDSoc.GlobaSessionList.Count + 1;
  if StringGrid.RowCount > 1 then StringGrid.FixedRows:=1;
  for i:=0 to FrmIDSoc.GlobaSessionList.Count -1 do begin
    GlobaSessionInfo:=FrmIDSoc.GlobaSessionList.Items[i];
    if GlobaSessionInfo <> nil then begin
      StringGrid.Cells[0,i+1]:=GlobaSessionInfo.sAccount;
      StringGrid.Cells[1,i+1]:=GlobaSessionInfo.sIPaddr;
      StringGrid.Cells[2,i+1]:=IntToStr(GlobaSessionInfo.nSessionID);
      StringGrid.Cells[3,i+1]:=DateTimeToStr(GlobaSessionInfo.dAddDate);
    end;
  end;
end;


{---- Adjust global SVN revision ----}
initialization
  SVNRevision('$Id: GlobaSession.pas 335 2006-08-26 00:53:23Z Fugly $');
end.
