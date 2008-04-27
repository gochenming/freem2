unit DBTools;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmDBTool = class(TForm)
    PageControl1:  TPageControl;
    TabSheet1:     TTabSheet;
    GroupBox1:     TGroupBox;
    GridMirDBInfo: TStringGrid;
    GroupBox2:     TGroupBox;
    GridHumDBInfo: TStringGrid;
    TabSheet2:     TTabSheet;
    ButtonStartRebuild: TButton;
    LabelProcess:  TLabel;
    TimerShowInfo: TTimer;
    GroupBox3:     TGroupBox;
    CheckBoxDelDenyChr: TCheckBox;
    CheckBoxDelAllItem: TCheckBox;
    CheckBoxDelAllSkill: TCheckBox;
    CheckBoxDelBonusAbil: TCheckBox;
    CheckBoxDelLevel: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartRebuildClick(Sender: TObject);
    procedure TimerShowInfoTimer(Sender: TObject);
    procedure CheckBoxDelDenyChrClick(Sender: TObject);
    procedure CheckBoxDelLevelClick(Sender: TObject);
    procedure CheckBoxDelAllItemClick(Sender: TObject);
    procedure CheckBoxDelAllSkillClick(Sender: TObject);
    procedure CheckBoxDelBonusAbilClick(Sender: TObject);
  private
    procedure RefDBInfo();
    { Private declarations }
  public
    procedure Open();
    { Public declarations }
  end;

  TBuildDB = class(TThread)
  private
    procedure UpdateProcess();
    { Private declarations }
  protected
    procedure Execute; override;
  end;

var
  frmDBTool: TfrmDBTool;

implementation

uses
  HumDB, DBShare, Grobal2;

var
  boRebuilding: boolean = False;
  BuildDB:      TBuildDB;
  nProcID:      integer;
  nProcMax:     integer;
  UpdateProcessTick: longword;
  boDelDenyChr: boolean = False;
  boDelAllItem: boolean = False;
  boDelAllSkill: boolean = False;
  boDelBonusAbil: boolean = False;
  boDelLevel:   boolean = False;


{$R *.dfm}

{ TfrmDBTool }

procedure TfrmDBTool.Open;
begin
  RefDBInfo();
  ShowModal;
end;

procedure TfrmDBTool.RefDBInfo;
begin
  {try
    if HumDataDB.Open then begin
      GridMirDBInfo.Cells[1, 1] := HumDataDB.m_sDBFileName;
      GridMirDBInfo.Cells[1, 2] := HumDataDB.m_Header.sDesc;
      GridMirDBInfo.Cells[1, 3] := IntToStr(HumDataDB.m_Header.nHumCount);
      GridMirDBInfo.Cells[1, 4] := IntToStr(HumDataDB.m_QuickList.Count);
      GridMirDBInfo.Cells[1, 5] := IntToStr(HumDataDB.m_DeletedList.Count);
      GridMirDBInfo.Cells[1, 6] := DateTimeToStr(HumDataDB.m_Header.dUpdateDate);
    end;
  finally
    HumDataDB.Close();
  end;
  try
    if HumChrDB.Open then begin
      GridHumDBInfo.Cells[1, 1] := HumChrDB.m_sDBFileName;
      GridHumDBInfo.Cells[1, 2] := HumChrDB.m_Header.sDesc;
      GridHumDBInfo.Cells[1, 3] := IntToStr(HumChrDB.m_Header.nHumCount);
      GridHumDBInfo.Cells[1, 4] := IntToStr(HumChrDB.m_QuickList.Count);
      GridHumDBInfo.Cells[1, 5] := IntToStr(HumChrDB.m_DeletedList.Count);
      GridHumDBInfo.Cells[1, 6] := DateTimeToStr(HumChrDB.m_Header.dUpdateDate);
    end;
  finally
    HumChrDB.Close();
  end;}
end;

procedure TfrmDBTool.FormCreate(Sender: TObject);
begin
  GridMirDBInfo.Cells[0, 0] := 'Type';
  GridMirDBInfo.Cells[1, 0] := 'Value';
  GridMirDBInfo.Cells[0, 1] := 'FileName';
  GridMirDBInfo.Cells[0, 2] := 'Description';
  GridMirDBInfo.Cells[0, 3] := 'Created';
  GridMirDBInfo.Cells[0, 4] := 'Loaded';
  GridMirDBInfo.Cells[0, 5] := 'Deleted';
  GridMirDBInfo.Cells[0, 6] := 'Last Update';

  GridHumDBInfo.Cells[0, 0] := 'Type';
  GridHumDBInfo.Cells[1, 0] := 'Value';
  GridHumDBInfo.Cells[0, 1] := 'FileName';
  GridHumDBInfo.Cells[0, 2] := 'Description';
  GridHumDBInfo.Cells[0, 3] := 'Created';
  GridHumDBInfo.Cells[0, 4] := 'Loaded';
  GridHumDBInfo.Cells[0, 5] := 'Deleted';
  GridHumDBInfo.Cells[0, 6] := 'Last Update';
end;

procedure TfrmDBTool.ButtonStartRebuildClick(Sender: TObject);

begin
  boAutoClearDB := False;
  boRebuilding := True;
  ButtonStartRebuild.Enabled := False;
  BuildDB := TBuildDB.Create(False);
  BuildDB.FreeOnTerminate := True;
  TimerShowInfo.Enabled := True;

end;

{ TBuildDB }

procedure TBuildDB.Execute;
var
  I: integer;
  NewChrDB: TFileHumDB;
  NewDataDB: TFileDB;
  sHumDBFile, sMirDBFile: string;
  SrcHumanRCD: THumDataInfo;
  HumRecord: THumInfo;
  nSrcHumIndex: integer;
begin

  sHumDBFile := sHumDBFilePath + 'NewHum.DB';
  sMirDBFile := sHumDBFilePath + 'NewMir.DB';
  if FileExists(sHumDBFile) then DeleteFile(sHumDBFile);
  if FileExists(sMirDBFile) then DeleteFile(sMirDBFile);

  NewChrDB  := TFileHumDB.Create(sHumDBFile);
  NewDataDB := TFileDB.Create;
  try
    if HumDataDB.Open and HumChrDB.Open then begin
      nProcID  := 0;
      nProcMax := HumDataDB.m_QuickList.Count - 1;
      for I := 0 to HumDataDB.m_QuickList.Count - 1 do begin
        nProcID := I;
        if (HumDataDB.Get(I, SrcHumanRCD) < 0) or (SrcHumanRCD.Data.sChrName = '') then
          Continue;
        if boDelDenyChr then begin
          FillChar(HumRecord, SizeOf(HumRecord), #0);
          nSrcHumIndex := HumChrDB.Index(SrcHumanRCD.Data.sChrName);
          if HumChrDB.GetBy(nSrcHumIndex, HumRecord) then begin
            if HumRecord.boDeleted then Continue;
          end;
        end;
        if boDelLevel then begin
          FillChar(SrcHumanRCD.Data.Abil, SizeOf(TAbility), #0);
          SrcHumanRCD.Data.sCurMap   := '3';
          SrcHumanRCD.Data.wCurX     := 330;
          SrcHumanRCD.Data.wCurY     := 330;
          SrcHumanRCD.Data.nGold     := 0;
          SrcHumanRCD.Data.sHomeMap  := '3';
          SrcHumanRCD.Data.wHomeX    := 330;
          SrcHumanRCD.Data.wHomeY    := 330;
          SrcHumanRCD.Data.btReLevel := 0;
          SrcHumanRCD.Data.sMasterName := '';
          SrcHumanRCD.Data.boMaster  := False;
          SrcHumanRCD.Data.sDearName := '';
          SrcHumanRCD.Data.btCreditPoint := 0;
          SrcHumanRCD.Data.btMarryCount := 0;
          SrcHumanRCD.Data.sStoragePwd := '';
          SrcHumanRCD.Data.nPKPoint  := 0;
        end;


        if boDelAllItem then begin
          FillChar(SrcHumanRCD.Data.HumItems, SizeOf(THumItems), #0);
          FillChar(SrcHumanRCD.Data.BagItems, SizeOf(TBagItems), #0);
          FillChar(SrcHumanRCD.Data.StorageItems, SizeOf(TStorageItems), #0);
        end;

        if boDelAllSkill then begin
          FillChar(SrcHumanRCD.Data.Magic, SizeOf(THumMagic), #0);
        end;
        if boDelBonusAbil then begin
          FillChar(SrcHumanRCD.Data.BonusAbil, SizeOf(TNakedAbility), #0);
          SrcHumanRCD.Data.nBonusPoint := 0;
        end;


        NewDataDB.Lock;
        try
          if NewDataDB.Index(SrcHumanRCD.Data.sChrName) >= 0 then Continue;
        finally
          NewDataDB.UnLock;
        end;
        FillChar(HumRecord, SizeOf(THumInfo), #0);
        try
          if NewChrDB.Open then begin
            if NewChrDB.ChrCountOfAccount(SrcHumanRCD.Data.sChrName) < g_nMaxCreateChar then
            begin
              HumRecord.sChrName     := SrcHumanRCD.Data.sChrName;
              HumRecord.sAccount     := SrcHumanRCD.Data.sAccount;
              HumRecord.boDeleted    := False;
              HumRecord.btCount      := 0;
              NewChrDB.Add(HumRecord);
            end;
          end;
        finally
          NewChrDB.Close;
        end;

        try
          if NewDataDB.Open and (NewDataDB.Index(SrcHumanRCD.Data.sChrName) = -1) then
          begin
            NewDataDB.Add(SrcHumanRCD);
          end;
        finally
          NewDataDB.Close;
        end;
      end;
    end;
  finally
    HumDataDB.Close;
    HumChrDB.Close;
  end;

  NewChrDB.Free;
  NewDataDB.Free;
  boRebuilding := False;

end;

procedure TBuildDB.UpdateProcess;
begin
  if (GetTickCount - UpdateProcessTick > 1000) or (nProcID >= nProcMax) then begin
    UpdateProcessTick := GetTickCount();
    //frmDBTool.LabelProcess.Caption:=IntToStr(nProcID) + '/' + IntToStr(nProcMax);
  end;

end;

procedure TfrmDBTool.TimerShowInfoTimer(Sender: TObject);
begin
  LabelProcess.Caption := IntToStr(nProcID) + '/' + IntToStr(nProcMax);
  if not boRebuilding then begin
    TimerShowInfo.Enabled := False;
    LabelProcess.Caption  := '��ɣ�����';
    ShowMessage('��ɣ�����');
  end;
end;

procedure TfrmDBTool.CheckBoxDelDenyChrClick(Sender: TObject);
begin
  boDelDenyChr := CheckBoxDelDenyChr.Checked;
end;

procedure TfrmDBTool.CheckBoxDelLevelClick(Sender: TObject);
begin
  boDelLevel := CheckBoxDelLevel.Checked;
end;

procedure TfrmDBTool.CheckBoxDelAllItemClick(Sender: TObject);
begin
  boDelAllItem := CheckBoxDelAllItem.Checked;
end;

procedure TfrmDBTool.CheckBoxDelAllSkillClick(Sender: TObject);
begin
  boDelAllSkill := CheckBoxDelAllSkill.Checked;
end;

procedure TfrmDBTool.CheckBoxDelBonusAbilClick(Sender: TObject);
begin
  boDelBonusAbil := CheckBoxDelBonusAbil.Checked;
end;

end.
