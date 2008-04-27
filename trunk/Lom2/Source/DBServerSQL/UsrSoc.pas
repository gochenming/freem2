unit UsrSoc;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, JSocket,
  SyncObjs, IniFiles, Grobal2, DBShare;

type
  //  TServerInfo = record
  //    nGateCount    :Integer;
  //    sSelGateIP    :String;  //0x2EC
  //    sGameGateIP1  :String;  //0x2F0
  //    nGameGatePort1:Integer; //0x2F4
  //    sGameGateIP2  :String;  //0x2F8
  //    nGameGatePort2:Integer; //0x2FC
  //    sGameGateIP3  :String;  //0x300
  //    nGameGatePort3:Integer; //0x304
  //    sGameGateIP4  :String;  //0x308
  //    nGameGatePort4:Integer; //0x30C
  //    sGameGateIP5  :String;
  //    nGameGatePort5:Integer;
  //    sGameGateIP6  :String;
  //    nGameGatePort6:Integer;
  //    sGameGateIP7  :String;
  //    nGameGatePort7:Integer;
  //    sGameGateIP8  :String;
  //    nGameGatePort8:Integer;
  //  end;

  TFrmUserSoc = class(TForm)
    UserSocket: TServerSocket;
    Timer1:     TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UserSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure UserSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure UserSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure UserSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    dwKeepAliveTick: longword;        //0x10
    CS_GateSession: TCriticalSection; //0x2D8
    GateList: TList;         //0x2E8
    CurGate:  pTGateInfo;    //0x51C
    MapList:  TStringList;

    function LoadChrNameList(sFileName: string): boolean;
    function LoadClearMakeIndexList(sFileName: string): boolean;
    procedure ProcessGateMsg(var GateInfo: pTGateInfo);
    procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
    procedure ProcessUserMsg(var UserInfo: pTUserInfo);
    procedure CloseUser(sID: string; var GateInfo: pTGateInfo);
    procedure OpenUser(sID, sIP: string; var GateInfo: pTGateInfo);
    procedure DeCodeUserMsg(sData: string; var UserInfo: pTUserInfo);
    function QueryChr(sData: string; var UserInfo: pTUserInfo): boolean;
    procedure DelChr(sData: string; var UserInfo: pTUserInfo);
    procedure OutOfConnect(const UserInfo: pTUserInfo);
    procedure NewChr(sData: string; var UserInfo: pTUserInfo);
    function SelectChr(sData: string; var UserInfo: pTUserInfo): boolean;
    procedure SendUserSocket(Socket: TCustomWinSocket;
      sSessionID, sSendMsg: string);
    function GetMapIndex(sMap: string): integer;

    function GateRoutePort(sGateIP: string): integer;
    function CheckDenyChrName(sChrName: string): boolean;
    { Private declarations }
  public
    function GateRouteIP(sGateIP: string; var nPort: integer): string;
    procedure LoadServerInfo();
    function NewChrData(sUserID, sChrName: string; nSex, nJob, nHair: integer): boolean;
    function GetUserCount(): integer;
    { Public declarations }
  end;

var
  FrmUserSoc: TFrmUserSoc;

implementation

uses
  HumDB, HUtil32, IDSocCli, EDcode, MudUtil, DBSMain;

{$R *.DFM}

procedure TFrmUserSoc.UserSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
//0x004A2A10
var
  GateInfo: pTGateInfo;
  sIPaddr:  string;
begin
  sIPaddr := Socket.RemoteAddress;
  if not CheckServerIP(sIPaddr) then begin
    OutMainMessage('Invalid connection: ' + sIPaddr);
    Socket.Close;
    exit;
  end;
  if not boOpenDBBusy then begin
    New(GateInfo);
    GateInfo.Socket    := Socket;
    GateInfo.sGateaddr := sIPaddr;
    GateInfo.sText     := '';
    GateInfo.UserList  := TList.Create;
    GateInfo.dwTick10  := GetTickCount();
    GateInfo.nGateID   := GetGateID(sIPaddr);
    try
      CS_GateSession.Enter;
      GateList.Add(GateInfo);
    finally
      CS_GateSession.Leave;
    end;
  end else begin
    Socket.Close;
  end;
end;

procedure TFrmUserSoc.UserSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
//0x004A2B08
var
  i, ii:    integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
begin
  try
    CS_GateSession.Enter;
    for i := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      if GateInfo <> nil then begin
        for ii := 0 to GateInfo.UserList.Count - 1 do begin
          UserInfo := GateInfo.UserList.Items[ii];
          Dispose(UserInfo);
        end;
        GateInfo.UserList.Free;
      end;
      GateList.Delete(i);
      break;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.UserSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: integer);
//0x004A2C10
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmUserSoc.UserSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  i: integer;
  sReviceMsg: string;
  GateInfo: pTGateInfo;
begin
  try
    CS_GateSession.Enter;
    for i := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      if GateInfo.Socket = Socket then begin
        CurGate    := GateInfo;
        sReviceMsg := Socket.ReceiveText;
        GateInfo.sText := GateInfo.sText + sReviceMsg;
        if Length(GateInfo.sText) < 81920 then begin
          if Pos('$', GateInfo.sText) > 1 then begin
            ProcessGateMsg(GateInfo);
          end;
        end else begin
          GateInfo.sText := '';
        end;
      end;
    end;
  finally
    CS_GateSession.Leave;
  end;
end;

procedure TFrmUserSoc.FormCreate(Sender: TObject);
//0x004A2898
begin
  CS_GateSession := TCriticalSection.Create;
  GateList := TList.Create;
  MapList  := TStringList.Create;
  UserSocket.Port := g_nGatePort;
  UserSocket.Address := g_sGateAddr;
  UserSocket.Active := True;
  LoadServerInfo();
  LoadChrNameList('DenyChrName.txt');
  LoadClearMakeIndexList('ClearMakeIndex.txt');
end;

procedure TFrmUserSoc.FormDestroy(Sender: TObject);
//ox004A2954
var
  i, ii:    integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
begin
  for i := 0 to GateList.Count - 1 do begin
    GateInfo := GateList.Items[i];
    if GateInfo <> nil then begin
      for ii := 0 to GateInfo.UserList.Count - 1 do begin
        UserInfo := GateInfo.UserList.Items[ii];
        Dispose(UserInfo);
      end;
      GateInfo.UserList.Free;
    end;
    GateList.Delete(i);
    break;
  end;
  GateList.Free;
  MapList.Free;
  CS_GateSession.Free;
end;

procedure TFrmUserSoc.Timer1Timer(Sender: TObject);
//0x004A4EFC
var
  n8: integer;
begin
  n8 := g_nQueryChrCount + nHackerNewChrCount + nHackerDelChrCount +
    nHackerSelChrCount + n4ADC1C + n4ADC20 + n4ADC24 + n4ADC28;
  if n4ADBB8 <> n8 then begin
    n4ADBB8 := n8;
    OutMainMessage('H-QyChr=' + IntToStr(g_nQueryChrCount) + ' ' +
      'H-NwChr=' + IntToStr(nHackerNewChrCount) + ' ' + 'H-DlChr=' +
      IntToStr(nHackerDelChrCount) + ' ' + 'Dubl-Sl=' +
      IntToStr(nHackerSelChrCount) + ' ' + 'H-Er-P1=' + IntToStr(n4ADC1C) +
      ' ' + 'Dubl-P2=' + IntToStr(n4ADC20) + ' ' + 'Dubl-P3=' +
      IntToStr(n4ADC24) + ' ' + 'Dubl-P4=' + IntToStr(n4ADC28));
  end;
end;

function TFrmUserSoc.GetUserCount(): integer;
var
  i: integer;
  GateInfo: pTGateInfo;
  nUserCount: integer;
begin
  nUserCount := 0;
  try
    CS_GateSession.Enter;
    for I := 0 to GateList.Count - 1 do begin
      GateInfo := GateList.Items[i];
      Inc(nUserCount, GateInfo.UserList.Count);
    end;
  finally
    CS_GateSession.Leave;
  end;
  Result := nUserCount;
end;


function TFrmUserSoc.NewChrData(sUserID, sChrName: string; nSex, nJob, nHair: integer): boolean;
var
  ChrRecord: THumDataInfo;
begin
  Result := False;
  FillChar(ChrRecord, SizeOf(THumDataInfo), #0);
  try
    if HumDataDB.Open and (HumDataDB.Index(sChrName) = -1) then begin
      ChrRecord.Header.sAccount  := sUserID;
      ChrRecord.Header.sChrName  := sChrName;
      ChrRecord.Data.sAccount := sUserID;
      ChrRecord.Data.sChrName := sChrName;
      ChrRecord.Data.btSex    := nSex;
      ChrRecord.Data.btJob    := nJob;
      ChrRecord.Data.btHair   := nHair;
      HumDataDB.Add(ChrRecord);
      Result := True;
    end;
  finally
    HumDataDB.Close;
  end;
end;


procedure TFrmUserSoc.LoadServerInfo;
//0x004A2018
var
  I:    integer;
  LoadList: TStringList;
  nRouteIdx, nGateIdx, nServerIndex: integer;
  sLineText, sSelGateIPaddr, sGameGateIPaddr, sGameGate, sGameGatePort,
  sMapName, sMapInfo, sServerIndex: string;
  Conf: TIniFile;
begin
  try
    LoadList := TStringList.Create;
    FillChar(g_RouteInfo, SizeOf(g_RouteInfo), #0);
    LoadList.LoadFromFile(sGateConfFileName);
    nRouteIdx := 0;
    nGateIdx  := 0;
    for I := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[I]);
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sGameGate := GetValidStr3(sLineText, sSelGateIPaddr, [' ', #9]);
        if (sGameGate = '') or (sSelGateIPaddr = '') then Continue;
        g_RouteInfo[nRouteIdx].sSelGateIP := Trim(sSelGateIPaddr);
        g_RouteInfo[nRouteIdx].nGateCount := 0;
        nGateIdx := 0;
        while (sGameGate <> '') do begin
          sGameGate := GetValidStr3(sGameGate, sGameGateIPaddr, [' ', #9]);
          sGameGate := GetValidStr3(sGameGate, sGameGatePort, [' ', #9]);
          g_RouteInfo[nRouteIdx].sGameGateIP[nGateIdx] := Trim(sGameGateIPaddr);
          g_RouteInfo[nRouteIdx].nGameGatePort[nGateIdx] := Str_ToInt(sGameGatePort, 0);
          Inc(nGateIdx);
        end;
        g_RouteInfo[nRouteIdx].nGateCount := nGateIdx;
        Inc(nRouteIdx);
      end;
    end;


    Conf     := TIniFile.Create(sConfFileName);
    sMapFile := Conf.ReadString('Setup', 'MapFile', sMapFile);
    Conf.Free;
    MapList.Clear;
    if FileExists(sMapFile) then begin
      LoadList.Clear;
      LoadList.LoadFromFile(sMapFile);
      for I := 0 to LoadList.Count - 1 do begin
        sLineText := LoadList.Strings[I];
        if (sLineText <> '') and (sLineText[1] = '[') then begin
          sLineText    := ArrestStringEx(sLineText, '[', ']', sMapName);
          sMapInfo     := GetValidStr3(sMapName, sMapName, [#32, #9]);
          sServerIndex := Trim(GetValidStr3(sMapInfo, sMapInfo, [#32, #9]));
          nServerIndex := Str_ToInt(sServerIndex, 0);
          MapList.AddObject(sMapName, TObject(nServerIndex));
        end;
      end;
    end;
    LoadList.Free;
  finally
  end;
end;




function TFrmUserSoc.LoadChrNameList(sFileName: string): boolean;
  //0x0045C1A0
var
  i: integer;
begin
  Result := False;
  if FileExists(sFileName) then begin
    DenyChrNameList.LoadFromFile(sFileName);
    i := 0;
    while (True) do begin
      if DenyChrNameList.Count <= i then break;
      if Trim(DenyChrNameList.Strings[i]) = '' then begin
        DenyChrNameList.Delete(i);
        Continue;
      end;
      Inc(i);
    end;
    Result := True;
  end;

end;

function TFrmUserSoc.LoadClearMakeIndexList(sFileName: string): boolean;
  //0x0045C1A0
var
  i:      integer;
  nIndex: integer;
  sLineText: string;
begin
  Result := False;
  if FileExists(sFileName) then begin
    g_ClearMakeIndex.LoadFromFile(sFileName);
    i := 0;
    while (True) do begin
      if g_ClearMakeIndex.Count <= i then break;
      sLineText := g_ClearMakeIndex.Strings[I];
      nIndex    := Str_ToInt(sLineText, -1);
      if nIndex < 0 then begin
        g_ClearMakeIndex.Delete(i);
        Continue;
      end;
      g_ClearMakeIndex.Objects[I] := TObject(nIndex);
      Inc(i);
    end;
    Result := True;
  end;
end;

procedure TFrmUserSoc.ProcessGateMsg(var GateInfo: pTGateInfo);
//0x004A3350
var
  s0C: string;
  s10: string;
  s19: char;
  i:   integer;
  UserInfo: pTUserInfo;
begin
  while (True) do begin
    if Pos('$', GateInfo.sText) <= 0 then break;
    GateInfo.sText := ArrestStringEx(GateInfo.sText, '%', '$', s10);
    if s10 <> '' then begin
      s19 := s10[1];
      s10 := Copy(s10, 2, Length(s10) - 1);
      case Ord(s19) of
        Ord('-'): begin
          SendKeepAlivePacket(GateInfo.Socket);
          dwKeepAliveTick := GetTickCount();
        end;
        Ord('A'): begin
          s10 := GetValidStr3(s10, s0C, ['/']);
          for i := 0 to GateInfo.UserList.Count - 1 do begin
            UserInfo := GateInfo.UserList.Items[i];
            if UserInfo <> nil then begin
              if UserInfo.sConnID = s0C then begin
                UserInfo.s2C := UserInfo.s2C + s10;
                if Pos('!', s10) < 1 then Continue;
                ProcessUserMsg(UserInfo);
                break;
              end;
            end;
          end;
        end;
        Ord('O'): begin
          s10 := GetValidStr3(s10, s0C, ['/']);
          OpenUser(s0C, s10, GateInfo);
        end;
        Ord('X'): begin
          CloseUser(s10, GateInfo);
        end;
      end;
    end;//004A3587
  end;
end;

procedure TFrmUserSoc.SendKeepAlivePacket(Socket: TCustomWinSocket);
begin
  if Socket.Connected then Socket.SendText('%++$');
end;

procedure TFrmUserSoc.ProcessUserMsg(var UserInfo: pTUserInfo);
var
  s10: string;
  nC:  integer;
begin
  nC := 0;
  while (True) do begin
    if TagCount(UserInfo.s2C, '!') <= 0 then break;
    UserInfo.s2C := ArrestStringEx(UserInfo.s2C, '#', '!', s10);
    if s10 <> '' then begin
      s10 := Copy(s10, 2, Length(s10) - 1);
      if Length(s10) >= DEFBLOCKSIZE then begin
        DeCodeUserMsg(s10, UserInfo);
      end else
        Inc(n4ADC20);
    end else begin
      Inc(n4ADC1C);
      if nC >= 1 then begin
        UserInfo.s2C := '';
      end;
      Inc(nC);
    end;
  end;
end;

procedure TFrmUserSoc.OpenUser(sID, sIP: string; var GateInfo: pTGateInfo);
var
  I: integer;
  UserInfo: pTUserInfo;
  sUserIPaddr: string;
  sGateIPaddr: string;
begin
  sGateIPaddr := GetValidStr3(sIP, sUserIPaddr, ['/']);
  for I := 0 to GateInfo.UserList.Count - 1 do begin
    UserInfo := GateInfo.UserList.Items[I];
    if (UserInfo <> nil) and (UserInfo.sConnID = sID) then begin
      exit;
    end;
  end;
  New(UserInfo);
  UserInfo.sAccount := '';
  UserInfo.sUserIPaddr := sUserIPaddr;
  UserInfo.sGateIPaddr := sGateIPaddr;
  UserInfo.sConnID  := sID;
  UserInfo.nSessionID := 0;
  UserInfo.Socket   := GateInfo.Socket;
  UserInfo.s2C      := '';
  UserInfo.dwTick34 := GetTickCount();
  UserInfo.dwChrTick := GetTickCount();
  UserInfo.boChrSelected := False;
  UserInfo.boChrQueryed := False;
  UserInfo.nSelGateID := GateInfo.nGateID;
  GateInfo.UserList.Add(UserInfo);
end;
//004A30B8
procedure TFrmUserSoc.CloseUser(sID: string; var GateInfo: pTGateInfo);
var
  I: integer;
  UserInfo: pTUserInfo;
begin
  for I := 0 to GateInfo.UserList.Count - 1 do begin
    UserInfo := GateInfo.UserList.Items[I];
    if (UserInfo <> nil) and (UserInfo.sConnID = sID) then begin
      if not FrmIDSoc.GetGlobaSessionStatus(UserInfo.nSessionID) then begin
        FrmIDSoc.SendSocketMsg(SS_SOFTOUTSESSION, UserInfo.sAccount +
          '/' + IntToStr(UserInfo.nSessionID));
        FrmIDSoc.CloseSession(UserInfo.sAccount, UserInfo.nSessionID);
      end;
      Dispose(UserInfo);
      GateInfo.UserList.Delete(I);
      break;
    end;
  end;
end;

procedure TFrmUserSoc.DeCodeUserMsg(sData: string; var UserInfo: pTUserInfo);//004A48E0
var
  sDefMsg, s18: string;
  Msg: TDefaultMessage;
begin
  sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
  s18     := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
  Msg     := DecodeMessage(sDefMsg);
  case Msg.Ident of
    CM_QUERYCHR: begin
      if not UserInfo.boChrQueryed or ((GetTIckCount - UserInfo.dwChrTick) > 200) then
      begin
        UserInfo.dwChrTick := GetTickCount();
        if QueryChr(s18, UserInfo) then begin
          UserInfo.boChrQueryed := True;
        end;
      end else begin
        Inc(g_nQueryChrCount);
        OutMainMessage('[Hacker Attack] _QUERYCHR ' + UserInfo.sUserIPaddr);
      end;
    end;
    CM_NEWCHR: begin
      if (GetTickCount - UserInfo.dwChrTick) > 1000 then begin
        UserInfo.dwChrTick := GetTickCount();
        if (UserInfo.sAccount <> '') and FrmIDSoc.CheckSession(
          UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
          NewChr(s18, UserInfo);
          UserInfo.boChrQueryed := False;
        end else begin
          OutOfConnect(UserInfo);
        end;
      end else begin
        Inc(nHackerNewChrCount);
        OutMainMessage('[Hacker Attack] _NEWCHR ' + UserInfo.sAccount +
          '/' + UserInfo.sUserIPaddr);
      end;
    end;
    CM_DELCHR: begin
      if (GetTickCount - UserInfo.dwChrTick) > 1000 then begin
        UserInfo.dwChrTick := GetTickCount();
        if (UserInfo.sAccount <> '') and FrmIDSoc.CheckSession(
          UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
          DelChr(s18, UserInfo);
          UserInfo.boChrQueryed := False;
        end else begin
          OutOfConnect(UserInfo);
        end;
      end else begin
        Inc(nHackerDelChrCount);
        OutMainMessage('[Hacker Attack] _DELCHR ' + UserInfo.sAccount +
          '/' + UserInfo.sUserIPaddr);
      end;
    end;
    CM_SELCHR: begin
      if not UserInfo.boChrQueryed then begin
        if (UserInfo.sAccount <> '') and FrmIDSoc.CheckSession(
          UserInfo.sAccount, UserInfo.sUserIPaddr, UserInfo.nSessionID) then begin
          if SelectChr(s18, UserInfo) then begin
            UserInfo.boChrSelected := True;
          end;
        end else begin  //004A4D69
          OutOfConnect(UserInfo);
        end;
      end else begin//004A4D79
        Inc(nHackerSelChrCount);
        OutMainMessage('Double send _SELCHR ' + UserInfo.sAccount +
          '/' + UserInfo.sUserIPaddr);
      end;
    end;
    else begin
      Inc(n4ADC24);
    end;
  end;
end;
//004A3620
function TFrmUserSoc.QueryChr(sData: string; var UserInfo: pTUserInfo): boolean;
var
  sAccount: string;
  sSessionID: string;
  nSessionID: integer;
  nChrCount: integer;
  ChrList: TStringList;
  I:      integer;
  nIndex: integer;
  QueryChrRcd: TQueryChr;
  HumRecord: THumInfo;
  QuickID: pTQuickID;
  btSex:  byte;
  sChrName: string;
  sJob:   string;
  sHair:  string;
  sLevel: string;
  sBuf:    string;
begin
  Result     := False;
  sSessionID := GetValidStr3(DecodeString(sData), sAccount, ['/']);
  nSessionID := Str_ToInt(sSessionID, -2);
  UserInfo.nSessionID := nSessionID;
  nChrCount  := 0;

  if FrmIDSoc.CheckSession(sAccount, UserInfo.sUserIPaddr, nSessionID) then begin
    FrmIDSoc.SetGlobaSessionNoPlay(nSessionID);
    UserInfo.sAccount := sAccount;
    ChrList := TStringList.Create;
    try
      if HumChrDB.Open and (HumChrDB.FindByAccount(sAccount, ChrList) >= 0) then begin
        try
          if HumDataDB.Open then begin
            for I := 0 to ChrList.Count - 1 do begin
              QuickID := pTQuickID(ChrList.Objects[I]);
              //���ѡ��ID����,������
              if QuickID.nSelectID <> UserInfo.nSelGateID then Continue;

              if HumChrDB.GetBy(QuickID.nIndex, HumRecord) and (not HumRecord.boDeleted) then begin
                sChrName := QuickID.sChrName;
                nIndex   := HumDataDB.Index(sChrName);
                if (nIndex < 0) or (nChrCount >= g_nMaxCreateChar) then Continue;
                if HumDataDB.GetQryChar(nIndex, QueryChrRcd) >= 0 then begin
                  btSex  := QueryChrRcd.btGender;
                  sJob   := IntToStr(QueryChrRcd.btClass);
                  sHair  := IntToStr(QueryChrRcd.btHair);
                  sLevel := IntToStr(QueryChrRcd.btLevel);
                  if HumRecord.boSelected then sBuf := sBuf + '*';
                  sBuf := sBuf + sChrName + '/' + sJob + '/' + sHair +
                    '/' + sLevel + '/' + IntToStr(btSex) + '/';
                  Inc(nChrCount);
                end;
              end;
            end;
          end;
        finally
          HumDataDB.Close;
        end;
      end;
    finally
      HumChrDB.Close;
    end;
    ChrList.Free;
    SendUserSocket(UserInfo.Socket,
      UserInfo.sConnID,
      EncodeMessage(MakeDefaultMsg(SM_QUERYCHR, nChrCount, 0, 1, 0)) +
      EncodeString(sBuf));
    //*ChrName/sJob/sHair/sLevel/sSex/
  end else begin
    SendUserSocket(UserInfo.Socket,
      UserInfo.sConnID,
      EncodeMessage(MakeDefaultMsg(SM_QUERYCHR_FAIL, nChrCount, 0, 1, 0)));
    CloseUser(UserInfo.sConnID, CurGate);
  end;
end;

procedure TFrmUserSoc.OutOfConnect(const UserInfo: pTUserInfo);
//004A4844
var
  Msg:  TDefaultMessage;
  sMsg: string;
begin
  Msg  := MakeDefaultMsg(SM_OUTOFCONNECTION, 0, 0, 0, 0);
  sMsg := EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket, sMsg, UserInfo.sConnID);
end;

procedure TFrmUserSoc.DelChr(sData: string; var UserInfo: pTUserInfo);
//004A424C
var
  sChrName: string;
  boCheck:  boolean;
  Msg:      TDefaultMessage;
  sMsg:     string;
  nIndex:   integer;
  HumRecord: THumInfo;
begin
  g_CheckCode.dwThread0 := 1000300;
  sChrName := DecodeString(sData);
  boCheck  := False;
  g_CheckCode.dwThread0 := 1000301;
  try
    if HumChrDB.Open then begin
      nIndex := HumChrDB.Index(sChrName);
      if nIndex >= 0 then begin
        HumChrDB.Get(nIndex, HumRecord);
        if HumRecord.sAccount = UserInfo.sAccount then begin
          HumRecord.boDeleted := True;
          HumRecord.dModDate := Now();
          boCheck := HumChrDB.Update(nIndex, HumRecord);
        end;
      end;
    end;
  finally
    HumChrDB.Close;
  end;
  g_CheckCode.dwThread0 := 1000302;
  if boCheck then Msg := MakeDefaultMsg(SM_DELCHR_SUCCESS, 0, 0, 0, 0)
  else
    Msg := MakeDefaultMsg(SM_DELCHR_FAIL, 0, 0, 0, 0);

  sMsg := EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket, UserInfo.sConnID, sMsg);
  g_CheckCode.dwThread0 := 1000303;
end;

procedure TFrmUserSoc.NewChr(sData: string; var UserInfo: pTUserInfo);//004A3C08
var
  Data, sAccount, sChrName, sHair, sJob, sSex: string;
  nCode: integer;
  Msg:   TDefaultMessage;
  sMsg:  string;
  HumRecord: THumInfo;
  i:     integer;
begin
  nCode := -1;
  Data  := DecodeString(sData);
  Data  := GetValidStr3(Data, sAccount, ['/']);
  Data  := GetValidStr3(Data, sChrName, ['/']);
  Data  := GetValidStr3(Data, sHair, ['/']);
  Data  := GetValidStr3(Data, sJob, ['/']);
  Data  := GetValidStr3(Data, sSex, ['/']);
  if Trim(Data) <> '' then nCode := 0;
  sChrName := Trim(sChrName);
  if length(sChrName) < 3 then nCode := 0;
  if g_boEnglishNames and not IsEnglishStr(sChrName) then nCode := 0;
  if not CheckDenyChrName(sChrName) then nCode := 2;
  if not CheckChrName(sChrName) then nCode := 0;
  for I := 1 to length(sChrName) do begin
    if (sChrName[i] = #$A1) or (sChrName[i] = ' ') or (sChrName[i] = '/') or
      (sChrName[i] = '@') or (sChrName[i] = '?') or (sChrName[i] = '''') or
      (sChrName[i] = '"') or (sChrName[i] = '\') or (sChrName[i] = '.') or
      (sChrName[i] = ',') or (sChrName[i] = ':') or (sChrName[i] = ';') or
      (sChrName[i] = '`') or (sChrName[i] = '~') or (sChrName[i] = '!') or
      (sChrName[i] = '#') or (sChrName[i] = '$') or (sChrName[i] = '%') or
      (sChrName[i] = '^') or (sChrName[i] = '&') or (sChrName[i] = '*') or
      (sChrName[i] = '(') or (sChrName[i] = ')') or (sChrName[i] = '-') or
      (sChrName[i] = '_') or (sChrName[i] = '+') or (sChrName[i] = '=') or
      (sChrName[i] = '|') or (sChrName[i] = '[') or (sChrName[i] = '{') or
      (sChrName[i] = ']') or (sChrName[i] = '}') then nCode := 0;
  end;

  if nCode = -1 then begin
    try
      HumDataDB.Lock;
      if HumDataDB.Index(sChrName) >= 0 then nCode := 2;
    finally
      HumDataDB.UnLock;
    end;
    FillChar(HumRecord, SizeOf(THumInfo), #0);

    try
      if HumChrDB.Open then begin
        if HumChrDB.ChrCountOfAccount(sAccount) < g_nMaxCreateChar then begin
          HumRecord.sChrName     := sChrName;
          HumRecord.sAccount     := sAccount;
          HumRecord.boDeleted    := False;
          HumRecord.btCount      := 0;
          HumRecord.Header.sChrName  := sChrName;
          HumRecord.Header.nSelectID := UserInfo.nSelGateID;
          if HumRecord.sChrName <> '' then
            if not HumChrDB.Add(HumRecord) then nCode := 2;
        end else
          nCode := 3;
      end;
    finally
      HumChrDB.Close;
    end;

    if nCode = -1 then begin
      if NewChrData(sAccount, sChrName, Str_ToInt(sSex, 0), Str_ToInt(sJob, 0),
        Str_ToInt(sHair, 0)) then nCode := 1;
    end else begin
      FrmDBSrv.DelHum(sChrName);
      nCode := 4;
    end;
  end;
  if nCode = 1 then begin
    Msg := MakeDefaultMsg(SM_NEWCHR_SUCCESS, 0, 0, 0, 0);
  end else begin
    Msg := MakeDefaultMsg(SM_NEWCHR_FAIL, nCode, 0, 0, 0);
  end;
  sMsg := EncodeMessage(Msg);
  SendUserSocket(UserInfo.Socket, UserInfo.sConnID, sMsg);
end;
//004A440C
function TFrmUserSoc.SelectChr(sData: string; var UserInfo: pTUserInfo): boolean;
var
  sAccount: string;
  sChrName: string;
  ChrList: TStringList;
  HumRecord: THumInfo;
  I:      integer;
  nIndex: integer;
  nMapIndex: integer;
  QuickID: pTQuickID;
  sCurMap: string;
  boDataOK: boolean;
  sDefMsg: string;
  sRouteMsg: string;
  sRouteIP: string;
  nRoutePort: integer;
begin
  Result   := False;
  sChrName := GetValidStr3(DecodeString(sData), sAccount, ['/']);
  boDataOK := False;
  if UserInfo.sAccount = sAccount then begin
    try
      if HumChrDB.Open then begin
        ChrList := TStringList.Create;
        if HumChrDB.FindByAccount(sAccount, ChrList) >= 0 then begin
          for I := 0 to ChrList.Count - 1 do begin
            QuickID := pTQuickID(ChrList.Objects[i]);
            nIndex  := QuickID.nIndex;
            if HumChrDB.GetBy(nIndex, HumRecord) then begin
              if HumRecord.sChrName = sChrName then begin
                HumRecord.boSelected := True;
                HumChrDB.UpdateBy(nIndex, HumRecord);
              end else begin
                if HumRecord.boSelected then begin
                  HumRecord.boSelected := False;
                  HumChrDB.UpdateBy(nIndex, HumRecord);
                end;
              end;
            end;
          end;
        end;
        ChrList.Free;
      end;
    finally
      HumChrDB.Close;
    end;
    try
      if HumDataDB.Open then begin
        nIndex := HumDataDB.Index(sChrName);
        if nIndex >= 0 then begin
          sCurMap  := HumDataDB.GetUserCurMap(nIndex);
          boDataOK := True;
        end;
      end;
    finally
      HumDataDB.Close;
    end;
  end;
  if boDataOK then begin
    nMapIndex := GetMapIndex(sCurMap);
    sDefMsg   := EncodeMessage(MakeDefaultMsg(SM_STARTPLAY, 0, 0, 0, 0));
    sRouteIP  := GateRouteIP(CurGate.sGateaddr, nRoutePort);
    if g_boDynamicIPMode then sRouteIP := UserInfo.sGateIPaddr; //ʹ�ö�̬IP

    sRouteMsg := EncodeString(sRouteIP + '/' + IntToStr(nRoutePort + nMapIndex));
    SendUserSocket(UserInfo.Socket,
      UserInfo.sConnID,
      sDefMsg + sRouteMsg);
    FrmIDSoc.SetGlobaSessionPlay(UserInfo.nSessionID);
    Result := True;
  end else begin
    SendUserSocket(UserInfo.Socket,
      UserInfo.sConnID,
      EncodeMessage(MakeDefaultMsg(SM_STARTFAIL, 0, 0, 0, 0)));
  end;
end;

function TFrmUserSoc.GateRoutePort(sGateIP: string): integer;//004A2724
begin
  Result := 7200;
end;

function TFrmUserSoc.GateRouteIP(sGateIP: string; var nPort: integer): string;
  //0x004A258C

  function GetRoute(RouteInfo: pTRouteInfo; var nGatePort: integer): string;
  var
    nGateIndex: integer;
  begin
    nGateIndex := Random(RouteInfo.nGateCount);
    Result     := RouteInfo.sGameGateIP[nGateIndex];
    nGatePort  := RouteInfo.nGameGatePort[nGateIndex];
  end;

var
  I: integer;
  RouteInfo: pTRouteInfo;
begin
  nPort  := 0;
  Result := '';
  for I := Low(g_RouteInfo) to High(g_RouteInfo) do begin
    RouteInfo := @g_RouteInfo[I];
    if RouteInfo.sSelGateIP = sGateIP then begin
      Result := GetRoute(RouteInfo, nPort);
      break;
    end;
  end;
end;

function TFrmUserSoc.GetMapIndex(sMap: string): integer;//0x004A24D4
var
  i: integer;
begin
  Result := 0;
  for I := 0 to MapList.Count - 1 do begin
    if MapList.Strings[i] = sMap then begin
      Result := integer(MapList.Objects[i]);
      break;
    end;
  end;
end;

procedure TFrmUserSoc.SendUserSocket(Socket: TCustomWinSocket;
  sSessionID, sSendMsg: string);
//004A2E18
begin
  Socket.SendText('%' + sSessionID + '/#' + sSendMsg + '!$');
end;
//0045C2C0
function TFrmUserSoc.CheckDenyChrName(sChrName: string): boolean;
var
  i: integer;
begin
  Result := True;
  g_CheckCode.dwThread0 := 1000700;
  for I := 0 to DenyChrNameList.Count - 1 do begin
    g_CheckCode.dwThread0 := 1000701;
    if CompareText(sChrName, DenyChrNameList.Strings[i]) = 0 then begin
      g_CheckCode.dwThread0 := 1000702;
      Result := False;
      break;
    end;
  end;
  g_CheckCode.dwThread0 := 1000703;
end;

end.
