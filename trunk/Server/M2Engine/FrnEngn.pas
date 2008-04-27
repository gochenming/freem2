unit FrnEngn;

interface

uses
  Windows, Classes, SysUtils, Grobal2, SDK;
type
  TFrontEngine = class(TThread)
    m_UserCriticalSection: TRTLCriticalSection;
    m_LoadRcdList: TList; //0x30
    m_SaveRcdList: TList; //0x34
    m_ChangeGoldList: TList; //0x38
  private
    m_LoadRcdTempList: TList;
    m_SaveRcdTempList: TList;
    procedure GetGameTime();
    procedure ProcessGameDate();
    function LoadHumFromDB(LoadUser: pTLoadDBInfo; var boReTry: Boolean): Boolean;
    function ChangeUserGoldInDB(GoldChangeInfo: pTGoldChangeInfo): Boolean;
    procedure Run();
    { Private declarations }
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    function SaveListCount(): Integer;
    function IsIdle(): Boolean;
    function IsFull(): Boolean;
    procedure DeleteHuman(nGateIndex, nSocket: Integer);
    function InSaveRcdList(sAccount, sChrName: string): Boolean;
    procedure AddChangeGoldList(sGameMasterName, sGetGoldUserName: string; nGold: Integer);
    procedure AddToLoadRcdList(sAccount, sChrName, sIPaddr: string; boFlag: Boolean; nSessionID: Integer; nPayMent, nPayMode, nSoftVersionDate, nSocket, nGSocketIdx, nGateIdx: Integer);
    procedure AddToSaveRcdList(SaveRcd: pTSaveRcd);
  end;

implementation
uses
  M2Share, RunDB, ObjBase;
{ TFrontEngine }

constructor TFrontEngine.Create(CreateSuspended: Boolean);
begin
  inherited;
  InitializeCriticalSection(m_UserCriticalSection);
  m_LoadRcdList := TList.Create;
  m_SaveRcdList := TList.Create;
  m_ChangeGoldList := TList.Create;
  m_LoadRcdTempList := TList.Create;
  m_SaveRcdTempList := TList.Create;
  //  FreeOnTerminate:=True;
  //AddToProcTable(@TFrontEngine.ProcessGameDate, 'TFrontEngine.ProcessGameDatea');
end;

destructor TFrontEngine.Destroy;
begin
  m_LoadRcdList.Free;
  m_SaveRcdList.Free;
  m_ChangeGoldList.Free;
  m_LoadRcdTempList.Free;
  m_SaveRcdTempList.Free;
  DeleteCriticalSection(m_UserCriticalSection);
  inherited;
end;
//004B5148
procedure TFrontEngine.Execute;
resourcestring
  sExceptionMsg = '[Exception] TFrontEngine::Execute';
begin
  while not Terminated do begin
    try
      Run();
    except
      MainOutMessage(sExceptionMsg);
    end;
    Sleep(1);
  end;
end;

procedure TFrontEngine.GetGameTime; //004B50AC
var
  Hour, Min, Sec, MSec: Word;
begin
  DecodeTime(Time, Hour, Min, Sec, MSec);
  case Hour of
    5, 6, 7, 8, 9, 10, 16, 17, 18, 19, 20, 21, 22: g_nGameTime := 1;
    11, 23: g_nGameTime := 2;
    4, 15: g_nGameTime := 0;
    0, 1, 2, 3, 12, 13, 14: g_nGameTime := 3;
  end;
end;

function TFrontEngine.IsIdle: Boolean;
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    if m_SaveRcdList.Count = 0 then Result := True;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.SaveListCount: Integer;
begin
  Result := 0;
  EnterCriticalSection(m_UserCriticalSection);
  try
    Result := m_SaveRcdList.Count;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.ProcessGameDate;
var
  i: Integer;
  ii: Integer;
  TempList: TList;
  ChangeGoldList: TList;
  LoadDBInfo: pTLoadDBInfo;
  SaveRcd: pTSaveRcd;
  GoldChangeInfo: pTGoldChangeInfo;
  boReTryLoadDB: Boolean;
begin
  ChangeGoldList := nil;
  EnterCriticalSection(m_UserCriticalSection);
  try
    for i := 0 to m_SaveRcdList.Count - 1 do begin
      m_SaveRcdTempList.Add(m_SaveRcdList.Items[i]);
    end;

    TempList := m_LoadRcdTempList;
    m_LoadRcdTempList := m_LoadRcdList;
    m_LoadRcdList := TempList;

    if m_ChangeGoldList.Count > 0 then begin
      ChangeGoldList := TList.Create;
      for i := 0 to m_ChangeGoldList.Count - 1 do begin
        ChangeGoldList.Add(m_ChangeGoldList.Items[i]);
      end;
    end;
    m_ChangeGoldList.Clear;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
  if DBSocketConnected then begin
    for i := 0 to m_SaveRcdTempList.Count - 1 do begin
      SaveRcd := m_SaveRcdTempList.Items[i];
      if SaveRcd = nil then Continue;
      if SaveHumRcdToDB(SaveRcd.sAccount, SaveRcd.sChrName, SaveRcd.nSessionID, SaveRcd.HumanRcd) or (SaveRcd.nReTryCount > 50) then begin
        //MainOutMessage('SaveHumRcdToDB =true');
        if SaveRcd.PlayObject <> nil then begin
          TPlayObject(SaveRcd.PlayObject).m_boRcdSaved := True;
        end;
        EnterCriticalSection(m_UserCriticalSection);
        try
          for ii := 0 to m_SaveRcdList.Count - 1 do begin
            if m_SaveRcdList.Items[ii] = SaveRcd then begin
              m_SaveRcdList.Delete(ii);
              DisPose(SaveRcd);
              break;
            end;
          end;
        finally
          LeaveCriticalSection(m_UserCriticalSection);
        end;
      end else begin
        //�޸����߹һ����ﲻ���˳�������
        //MainOutMessage('SaveHumRcdToDB =FALSE');
        if g_boExitServer then begin
          if SaveRcd.PlayObject <> nil then begin
            TPlayObject(SaveRcd.PlayObject).m_boRcdSaved := True;
          end;
          EnterCriticalSection(m_UserCriticalSection);
          try
            for ii := 0 to m_SaveRcdList.Count - 1 do begin
              if m_SaveRcdList.Items[ii] = SaveRcd then begin
                m_SaveRcdList.Delete(ii);
                DisPose(SaveRcd);
                break;
              end;
            end;
          finally
            LeaveCriticalSection(m_UserCriticalSection);
          end;
        end;
        Inc(SaveRcd.nReTryCount);
      end;
    end;
  end else begin //���DB�Ѿ��رգ����ڱ���
    //MainOutMessage('not DBSocketConnected');
    EnterCriticalSection(m_UserCriticalSection);
    try
      for i := 0 to m_SaveRcdList.Count - 1 do begin
        if m_SaveRcdList.Items[i] <> nil then
        DisPose(m_SaveRcdList.Items[i]);
      end;
    finally
      LeaveCriticalSection(m_UserCriticalSection);
    end;
    m_SaveRcdList.Clear;
  end;
  m_SaveRcdTempList.Clear;

  for i := 0 to m_LoadRcdTempList.Count - 1 do begin
    LoadDBInfo := m_LoadRcdTempList.Items[i];
    if LoadDBInfo = nil then Continue;
    if not LoadHumFromDB(LoadDBInfo, boReTryLoadDB) then begin
      RunSocket.CloseUser(LoadDBInfo.nGateIdx, LoadDBInfo.nSocket);
    end else begin
      if not boReTryLoadDB then begin
        DisPose(LoadDBInfo);
      end else begin //�����ȡ��������ʧ��(���ݻ�û�б���),�����¼������
        EnterCriticalSection(m_UserCriticalSection);
        try
          m_LoadRcdList.Add(LoadDBInfo);
        finally
          LeaveCriticalSection(m_UserCriticalSection);
        end;
      end;
    end;
  end;
  m_LoadRcdTempList.Clear;
  if ChangeGoldList <> nil then begin
    for i := 0 to ChangeGoldList.Count - 1 do begin
      GoldChangeInfo := ChangeGoldList.Items[i];
      if GoldChangeInfo = nil then Continue;
      ChangeUserGoldInDB(GoldChangeInfo);
      DisPose(GoldChangeInfo);
    end;
    ChangeGoldList.Free;
  end;
end;

function TFrontEngine.IsFull: Boolean; //004B4988
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    if m_SaveRcdList.Count >= 1000 then begin
      Result := True;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.AddToLoadRcdList(sAccount, sChrName, sIPaddr: string;
  boFlag: Boolean; nSessionID, nPayMent, nPayMode, nSoftVersionDate, nSocket, nGSocketIdx, nGateIdx: Integer);
//004B46A0
var
  LoadRcdInfo: pTLoadDBInfo;
begin
  New(LoadRcdInfo);
  LoadRcdInfo.sAccount := sAccount;
  LoadRcdInfo.sCharName := sChrName;
  LoadRcdInfo.sIPaddr := sIPaddr;
  //LoadRcdInfo.boClinetFlag     := boFlag;
  LoadRcdInfo.nSessionID := nSessionID;
  LoadRcdInfo.nSoftVersionDate := nSoftVersionDate;
  LoadRcdInfo.nPayMent := nPayMent;
  LoadRcdInfo.nPayMode := nPayMode;
  LoadRcdInfo.nSocket := nSocket;
  LoadRcdInfo.nGSocketIdx := nGSocketIdx;
  LoadRcdInfo.nGateIdx := nGateIdx;
  LoadRcdInfo.dwNewUserTick := GetTickCount();
  LoadRcdInfo.PlayObject := nil;
  LoadRcdInfo.nReLoadCount := 0;

  EnterCriticalSection(m_UserCriticalSection);
  try
    m_LoadRcdList.Add(LoadRcdInfo);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.LoadHumFromDB(LoadUser: pTLoadDBInfo; var boReTry: Boolean): Boolean; //004B4B10
var
  HumanRcd: THumDataInfo;
  UserOpenInfo: pTUserOpenInfo;
  PlayObject: TPlayObject;
resourcestring
  sReLoginFailMsg = '[�Ƿ���¼] ȫ�ֻỰ��֤ʧ��(%s/%s/%s/%d)';
begin
  Result := False;
  boReTry := False;
  if InSaveRcdList(LoadUser.sAccount, LoadUser.sCharName) then begin
    boReTry := True; //����TRUE,�����¼������
    Exit;
  end;
  if (UserEngine.GetPlayObjectEx(LoadUser.sAccount, LoadUser.sCharName) <> nil) then begin
    UserEngine.KickPlayObjectEx(LoadUser.sAccount, LoadUser.sCharName);
    boReTry := True; //����TRUE,�����¼������
    Exit;
  end;
  if not LoadHumRcdFromDB(LoadUser.sAccount, LoadUser.sCharName, LoadUser.sIPaddr, HumanRcd, LoadUser.nSessionID) then begin
    RunSocket.SendOutConnectMsg(LoadUser.nGateIdx, LoadUser.nSocket, LoadUser.nGSocketIdx);
  end else begin
    New(UserOpenInfo);
    UserOpenInfo.sAccount := LoadUser.sAccount;
    UserOpenInfo.sChrName := LoadUser.sCharName;
    UserOpenInfo.LoadUser := LoadUser^;
    UserOpenInfo.HumanRcd := HumanRcd;
    UserEngine.AddUserOpenInfo(UserOpenInfo);
    Result := True;
  end;
end;

function TFrontEngine.InSaveRcdList(sAccount, sChrName: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  EnterCriticalSection(m_UserCriticalSection);
  try
    for i := 0 to m_SaveRcdList.Count - 1 do begin
      if (pTSaveRcd(m_SaveRcdList.Items[i]).sAccount = sAccount) and
        (pTSaveRcd(m_SaveRcdList.Items[i]).sChrName = sChrName) then begin
        Result := True;
        break;
      end;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.AddChangeGoldList(sGameMasterName, sGetGoldUserName: string;
  nGold: Integer); //004B4828
var
  GoldInfo: pTGoldChangeInfo;
begin
  New(GoldInfo);
  GoldInfo.sGameMasterName := sGameMasterName;
  GoldInfo.sGetGoldUser := sGetGoldUserName;
  GoldInfo.nGold := nGold;
  m_ChangeGoldList.Add(GoldInfo);
end;

procedure TFrontEngine.AddToSaveRcdList(SaveRcd: pTSaveRcd); //004B49EC
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    m_SaveRcdList.Add(SaveRcd);
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

procedure TFrontEngine.DeleteHuman(nGateIndex, nSocket: Integer); //004B45EC
var
  i: Integer;
  LoadRcdInfo: pTLoadDBInfo;
begin
  EnterCriticalSection(m_UserCriticalSection);
  try
    for i := m_LoadRcdList.Count - 1 downto 0 do begin
      if m_LoadRcdList.Count <= 0 then break;
      LoadRcdInfo := m_LoadRcdList.Items[i];
      if LoadRcdInfo = nil then Continue;
      if (LoadRcdInfo.nGateIdx = nGateIndex) and (LoadRcdInfo.nSocket = nSocket) then begin
        DisPose(LoadRcdInfo);
        m_LoadRcdList.Delete(i);
        break;
      end;
    end;
  finally
    LeaveCriticalSection(m_UserCriticalSection);
  end;
end;

function TFrontEngine.ChangeUserGoldInDB(GoldChangeInfo: pTGoldChangeInfo): Boolean;
var
  HumanRcd: THumDataInfo;
begin
  Result := False;
  if LoadHumRcdFromDB('1', GoldChangeInfo.sGetGoldUser, '1', HumanRcd, 1) then begin
    if ((HumanRcd.Data.nGold + GoldChangeInfo.nGold) > 0) and ((HumanRcd.Data.nGold + GoldChangeInfo.nGold) < 2000000000) then begin
      Inc(HumanRcd.Data.nGold, GoldChangeInfo.nGold);
      if SaveHumRcdToDB('1', GoldChangeInfo.sGetGoldUser, 1, HumanRcd) then begin
        UserEngine.sub_4AE514(GoldChangeInfo);
        Result := True;
      end;
    end;
  end;
end;

procedure TFrontEngine.Run;
begin
  ProcessGameDate();
  GetGameTime();
end;

end.

