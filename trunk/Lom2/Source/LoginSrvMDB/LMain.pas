unit LMain;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, JSocket, SyncObjs,
  Grids, Buttons, IniFiles, MudUtil, SDK, Parse,
  Menus, Grobal2, LSShare, ComCtrls;

type
  TConnInfo = record      //Size 0x20 Address: 0x00468601
    sAccount: string;     //0x00
    sIPaddr:  string;     //0x04
    sServerName: string;  //0x08
    nSessionID: integer;  //0x0C
    boPayCost: boolean;   //0x10
    dwKickTick: longword; //0x14
    dwStartTick: longword;//0x18
    boKicked: boolean;    //0x1C
    nLockCount: integer;
  end;
  pTConnInfo = ^TConnInfo;

  pTGateInfo = ^TGateInfo;
  TGateInfo = record //Size 0x14 Address: 0x004686A0
    Socket:      TCustomWinSocket; //0x00
    sIPaddr:     string;           //0x04
    sReceiveMsg: string;           //0x08
    UserList:    TList;            //0x0C
    dwKeepAliveTick: longword;         //0x10
  end;

  pTUserInfo = ^TUserInfo;
  TUserInfo = record //Size 0x68 Address: 0x004686C8
    sAccount:  string;            //0x00
    sUserIPaddr: string;            //0x0B
    sGateIPaddr: string;            //�û����ӵ����أ����ص�����IP
    sSockIndex: string;            //0x20
    nVersionDate: integer;           //0x24
    boCertificationOK: boolean;           //0x28
    bo29:      boolean;           //0x29
    bo2A:      boolean;           //0x2A
    bo2B:      boolean;           //0x2B
    nSessionID: integer;           //0x2C
    boPayCost: boolean;           //0x30
    nIDDay:    integer;           //0x34
    nIDHour:   integer;           //0x38
    nIPDay:    integer;           //0x3C
    nIPHour:   integer;           //0x40
    dtDateTime: TDateTime;         //0x48
    boSelServer: boolean;           //0x50
    bo51:      boolean;           //0x51
    Socket:    TCustomWinSocket;  //0x54
    sReceiveMsg: string;            //0x58
    dwTime5C:  longword;          //0x5C
    bo60:      boolean;           //0x60
    bo61:      boolean;           //0x61
    bo62:      boolean;           //0x62
    bo63:      boolean;           //0x63
    dwClientTick: longword;          //0x64
    Gate:      pTGateInfo;
  end;

  TFrmMain = class(TForm)
    GSocket:    TServerSocket;
    ExecTimer:  TTimer;
    Timer1:     TTimer;
    StartTimer: TTimer;
    WebLogTimer: TTimer;
    LogTimer:   TTimer;
    CountLogTimer: TTimer;
    MonitorTimer: TTimer;
    MainMenu:   TMainMenu;
    MENU_CONTROL: TMenuItem;
    MENU_CONTROL_EXIT: TMenuItem;
    MENU_VIEW:  TMenuItem;
    MENU_OPTION: TMenuItem;
    MENU_HELP:  TMenuItem;
    MENU_HELP_ABOUT: TMenuItem;
    MENU_OPTION_ROUTE: TMenuItem;
    MENU_VIEW_SESSION: TMenuItem;
    R1: TMenuItem;
    C1: TMenuItem;
    G1: TMenuItem;
    BtnDump: TSpeedButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    MonitorGrid: TStringGrid;
    TabSheet3: TTabSheet;
    LbMasCount: TLabel;
    Label1: TLabel;
    CkLogin: TCheckBox;
    CbViewLog: TCheckBox;
    Button1: TButton;
    BtnView: TButton;
    BtnShowServerUsers: TButton;
    Button2: TButton;
    Button3: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExecTimerTimer(Sender: TObject);
    procedure Memo1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StartTimerTimer(Sender: TObject);

    procedure BtnViewClick(Sender: TObject);
    procedure CountLogTimerTimer(Sender: TObject);
    procedure BtnShowServerUsersClick(Sender: TObject);
    procedure MonitorTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure GSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure GSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure Panel2DblClick(Sender: TObject);
    procedure CbViewLogClick(Sender: TObject);
    procedure MENU_CONTROL_EXITClick(Sender: TObject);
    procedure MENU_OPTION_ROUTEClick(Sender: TObject);
    procedure MENU_VIEW_SESSIONClick(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure MENU_HELP_ABOUTClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    //sGateIPaddr     :String;      //0x334
    //GateList        :TList;  //0x338
    //SessionList     :TList; //0x33C
    //ServerNameList  :TStringList;   //0x340
    SList_0344: TStringList;   //0x344
    //AccountCostList :TQuickList;   //0x348
    //IPaddrCostList  :TQuickList;   //0x34C
    ParseList:  TThreadParseList;   //0x350
    //m_boRemoteClose :Boolean;

    procedure GameCenterGetUserAccount(sData: string);
    procedure GameCenterChangeAccountInfo(sData: string);
    procedure OpenRouteConfig();
  public
    { Public declarations }
  end;

procedure StartService(Config: pTConfig);
procedure StopService(Config: pTConfig);
procedure InitializeConfig(Config: pTConfig);
procedure UnInitializeConfig(Config: pTConfig);
procedure LoadConfig(Config: pTConfig);
procedure LoadAddrTable(Config: pTConfig);
procedure GenServerNameList(Config: pTConfig);

procedure WriteLogMsg(Config: pTConfig; sType: string; var UserEntry: TUserEntry;
  var UserAddEntry: TUserEntryAdd);
procedure SaveContLogMsg(Config: pTConfig; sLogMsg: string);

procedure SendGateMsg(Socket: TCustomWinSocket; sSockIndex, sMsg: string);
procedure SendGateKickMsg(Socket: TCustomWinSocket; sSockIndex: string);
procedure SendKeepAlivePacket(Socket: TCustomWinSocket);

procedure SessionAdd(Config: pTConfig; sAccount, sIPaddr: string;
  nSessionID: integer; boPayCost: boolean);
procedure SessionDel(Config: pTConfig; nSessionID: integer);
procedure SessionKick(Config: pTConfig; sLoginID: string);
procedure SessionUpdate(Config: pTConfig; nSessionID: integer;
  sServerName: string; boPayCost: boolean);
procedure SessionClearKick(Config: pTConfig);
function IsPayMent(Config: pTConfig; sIPaddr, sAccount: string): boolean;
procedure SessionClearNoPayMent(Config: pTConfig);
function IsLogin(Config: pTConfig; sLoginID: string): boolean; overload;
function IsLogin(Config: pTConfig; nSessionID: integer): boolean; overload;

function GetServerListInfo(): string;
procedure GetSelGateInfo(Config: pTConfig; sServerName, sIPaddr: string;
  var sSelGateIP: string; var nSelGatePort: integer);

function KickUser(Config: pTConfig; UserInfo: pTUserInfo): boolean;
procedure CloseUser(Config: pTConfig; sAccount: string; nSessionID: integer);

procedure AccountCreate(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountChangePassword(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountCheckProtocol(UserInfo: pTUserInfo; nDate: integer);
procedure AccountLogin(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountSelectServer(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountUpdateUserInfo(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
procedure AccountGetBackPassword(UserInfo: pTUserInfo; sData: string);

procedure ReceiveSendUser(Config: pTConfig; sSockIndex: string;
  GateInfo: pTGateInfo; sData: string);
procedure ReceiveOpenUser(Config: pTConfig; sSockIndex: string;
  sIPaddr: string; GateInfo: pTGateInfo);
procedure ReceiveCloseUser(Config: pTConfig; sSockIndex: string; GateInfo: pTGateInfo);

procedure ProcessUserMsg(Config: pTConfig; UserInfo: pTUserInfo; sMsg: string);

procedure DecodeGateData(Config: pTConfig; GateInfo: pTGateInfo);
procedure DecodeUserData(Config: pTConfig; UserInfo: pTUserInfo);
procedure ProcessGate(Config: pTConfig);

procedure LoadAccountCostList(Config: pTConfig; QuickList: TQuickList);
procedure LoadIPaddrCostList(Config: pTConfig; QuickList: TQuickList);

var
  FrmMain: TFrmMain;

implementation

uses
  SQLIDDB, MasSock, FrmFindId, HUtil32, EDcode, GateSet,
  FAccountView, GrobalSession, BasicSet;

{$R *.DFM}

procedure TFrmMain.OpenRouteConfig;
begin
  FrmGateSetting := TFrmGateSetting.Create(nil);
  FrmGateSetting.Open;
  FrmGateSetting.Free;
end;

{
procedure TFrmMain.OpenRouteConfig;
var
  Config  :pTConfig;
begin
  Config:=@g_Config;
  if FrmGateSetting.Open then begin
    LoadAddrTable(Config);
  end;
end;
}
procedure TFrmMain.MENU_OPTION_ROUTEClick(Sender: TObject);
begin
  OpenRouteConfig();
end;

procedure TFrmMain.MENU_VIEW_SESSIONClick(Sender: TObject);
begin
  frmGrobalSession := TfrmGrobalSession.Create(nil);
  frmGrobalSession.Open;
  frmGrobalSession.Free;
end;

procedure TFrmMain.CbViewLogClick(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  Config.boShowDetailMsg := CbViewLog.Checked;
end;

//00469778
procedure TFrmMain.GSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  GateInfo: pTGateInfo;
  Config:   pTConfig;
begin
  Config := @g_Config;
  if not ExecTimer.Enabled then begin
    Socket.Close;
    exit;
  end;
  New(GateInfo);
  GateInfo.Socket      := Socket;
  GateInfo.sIPaddr     := GetGatePublicAddr(Config, Socket.RemoteAddress);
  GateInfo.sReceiveMsg := '';
  GateInfo.UserList    := TList.Create;
  GateInfo.dwKeepAliveTick := GetTickCount();
  EnterCriticalSection(Config.GateCriticalSection);
  try
    Config.GateList.Add(GateInfo);
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;
//0x00469898
procedure TFrmMain.GSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
var
  I:      integer;
  II:     integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
  Config: pTConfig;
begin
  Config := @g_Config;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I := 0 to Config.GateList.Count - 1 do begin
      GateInfo := Config.GateList.Items[I];
      if GateInfo.Socket = Socket then begin
        for II := 0 to GateInfo.UserList.Count - 1 do begin
          UserInfo := GateInfo.UserList.Items[II];
          if Config.boShowDetailMsg then
            MainOutMessage('Close: ' + UserInfo.sUserIPaddr);
          Dispose(UserInfo);
        end;
        GateInfo.UserList.Free;
        Dispose(GateInfo);
        Config.GateList.Delete(i);
        break;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

procedure TFrmMain.GSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;
//00469A60
procedure TFrmMain.GSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
var
  I:      integer;
  GateInfo: pTGateInfo;
  Config: pTConfig;
begin
  Config := @g_Config;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I := 0 to Config.GateList.Count - 1 do begin
      GateInfo := Config.GateList.Items[I];
      if GateInfo.Socket = Socket then begin
        GateInfo.sReceiveMsg := GateInfo.sReceiveMsg + Socket.ReceiveText;
        break;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

//0046D19C
procedure LoadAddrTable(Config: pTConfig);
var
  LoadList: TStringList;
  sFileName: string;
  i: integer;
  nRouteIdx: integer;
  nSelGateIdx: integer;
  sLineText, sTitle, sServerName, sGate, sRemote, sPublic, sGatePort: string;
begin
  sFileName := '.\!addrtable.txt';
  LoadList  := TStringList.Create;
  if FileExists(sFileName) then begin
    LoadList.LoadFromFile(sFileName);
    nRouteIdx := 0;
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := LoadList.Strings[i];
      if (sLineText <> '') and (sLineText[1] <> ';') then begin
        sLineText := GetValidStr3(sLineText, sServerName, [' ']);
        sLineText := GetValidStr3(sLineText, sTitle, [' ']);
        sLineText := GetValidStr3(sLineText, sRemote, [' ']);
        sLineText := GetValidStr3(sLineText, sPublic, [' ']);
        sLineText := Trim(sLineText);
        if (sTitle <> '') and (sRemote <> '') and (sPublic <> '') and
          (nRouteIdx < 60) then begin
          Config.GateRoute[nRouteIdx].sServerName := sServerName;
          Config.GateRoute[nRouteIdx].sTitle := sTitle;
          Config.GateRoute[nRouteIdx].sRemoteAddr := sRemote;
          Config.GateRoute[nRouteIdx].sPublicAddr := sPublic;
          nSelGateIdx := 0;
          while (sLineText <> '') do begin
            if nSelGateIdx > 9 then break;
            sLineText := GetValidStr3(sLineText, sGate, [' ']);
            if sGate <> '' then begin
              if sGate[1] = '*' then begin
                sGate := Copy(sGate, 2, length(sGate) - 1);
                Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].boEnable := False;
              end else begin
                Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].boEnable := True;
              end;
              sGatePort := GetValidStr3(sGate, sGate, [':']);
              Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].sIPaddr := sGate;
              Config.GateRoute[nRouteIdx].Gate[nSelGateIdx].nPort :=
                Str_ToInt(sGatePort, 0);
              Config.GateRoute[nRouteIdx].nSelIdx := 0;
              Inc(nSelGateIdx);
            end;//0046D44B
            sLineText := Trim(sLineText);
          end;
          Inc(nRouteIdx);
        end;
      end;
    end;
    Config.nRouteCount := nRouteIdx;
  end;//0046D482
  LoadList.Free;
  GenServerNameList(Config);
end;
//00468F84
procedure TFrmMain.FormCreate(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  g_Config.boRemoteClose := False;

  AccountDB := nil;
  //  g_MainMsgList:=TStringList.Create;
  CS_DB     := TCriticalSection.Create;

  nSessionIdx := 1;
  n47328C     := 1;
  nMemoHeigh  := Memo1.Height;
  Config.GateList := TList.Create;
  Config.SessionList := TGList.Create;
  Config.ServerNameList := TStringList.Create;
  SList_0344  := TStringList.Create;
  Config.AccountCostList := TQuickList.Create;
  Config.IPaddrCostList := TQuickList.Create;
  ParseList   := TThreadParseList.Create(True);
  LoadAddrTable(Config);
  MonitorGrid.Cells[0, 0] := '��������';
  MonitorGrid.Cells[1, 0] := '�û���';
  MonitorGrid.Cells[2, 0] := '״̬';
  MonitorGrid.Cells[3, 0] := '��������';
  MonitorGrid.Cells[4, 0] := '�û���';
  MonitorGrid.Cells[5, 0] := '״̬';
end;

//00469598
procedure TFrmMain.FormDestroy(Sender: TObject);
var
  i, ii:    integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
  Config:   pTConfig;
begin
  Config := @g_Config;
  StopService(Config);
  if AccountDB <> nil then AccountDB.Free;
  for i := 0 to Config.GateList.Count - 1 do begin
    GateInfo := Config.GateList.Items[i];
    for ii := 0 to GateInfo.UserList.Count - 1 do begin
      UserInfo := GateInfo.UserList.Items[i];
      Dispose(UserInfo);
    end;
    GateInfo.UserList.Free;
    Dispose(GateInfo);
  end;
  Config.GateList.Free;
  Config.SessionList.Free;
  Config.ServerNameList.Free;
  SList_0344.Free;
  CS_DB.Free;
end;
//0046A7F4
procedure TFrmMain.ExecTimerTimer(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  if bo470D20 and not g_boDataDBReady then exit;
  bo470D20 := True;
  try
    ProcessGate(Config);
  finally
    bo470D20 := False;
  end;
end;
//0046D178
procedure TFrmMain.Memo1DblClick(Sender: TObject);
begin
  OpenRouteConfig();

end;

//0046A9BC
procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  I:      integer;
  Config: pTConfig;
begin
  Config := @g_Config;
  Label1.Caption := IntToStr(Config.dwProcessGateTime);
  CkLogin.Checked := GSocket.Socket.Connected;
  CkLogin.Caption := '���� (' + IntToStr(GSocket.Socket.ActiveConnections) + ')';
  LbMasCount.Caption := IntToStr(nOnlineCountMin) + '/' + IntToStr(nOnlineCountMax);
  if Memo1.Lines.Count > 2000 then Memo1.Clear;
  EnterCriticalSection(g_OutMessageCS);
  try
    for I := 0 to g_MainMsgList.Count - 1 do begin
      Memo1.Lines.Add(g_MainMsgList.Strings[i]);
    end;
    g_MainMsgList.Clear;
  finally
    LeaveCriticalSection(g_OutMessageCS);
  end;

  SessionClearKick(Config);
  SessionClearNoPayMent(Config);
end;

//0046A674
procedure TFrmMain.StartTimerTimer(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  StartService(Config);

  StartTimer.Enabled := False;
  Memo1.Lines.Add('1) ��������������...');
  Application.ProcessMessages;

  AccountDB := TFileIDDB.Create(g_sSQLString);
  ParseList.Resume;
  Memo1.Lines.Add('2) ���ڵȴ�����������...');
  while (True) do begin
    Application.ProcessMessages;
    if Application.Terminated then exit;
    if FrmMasSoc.CheckReadyServers then break;
    Sleep(1);
  end;
  GSocket.Active  := False;
  GSocket.Address := Config.sGateAddr;
  GSocket.Port    := Config.nGatePort;
  GSocket.Active  := True;
  Memo1.Lines.Add('3) �������������...');
  ExecTimer.Enabled := True;
end;



procedure TFrmMain.MENU_CONTROL_EXITClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
//0x0046DDB0
var
  Config: pTConfig;
resourcestring
  sExitMsg = '�Ƿ�ȷ��ֹͣ��¼������ ?';
  sExitTitle = 'ȷ����Ϣ';
begin
  Config := @g_Config;
  if Config.boRemoteClose then exit;
  if MessageBox(Handle, PChar(sExitMsg), PChar(sExitTitle), MB_YESNO +
    MB_ICONQUESTION) = mrYes then CanClose := True
  else
    CanClose := False;
end;


//0046DB40
procedure TFrmMain.BtnViewClick(Sender: TObject);
var
  Config: pTConfig;
begin
  Config := @g_Config;
  try
    CS_DB.Enter;
    FrmAccountView.ListBox1.Items := Config.AccountCostList;
    FrmAccountView.ListBox2.Items := Config.IPaddrCostList;
  finally
    CS_DB.Leave;
  end;
  FrmAccountView.ShowModal;
end;

procedure TFrmMain.CountLogTimerTimer(Sender: TObject);
var
  sLogMsg: string;
  Config:  pTConfig;
resourcestring
  sFormatMsg = '%d/%d';
begin
  Config  := @g_Config;
  sLogMsg := format(sFormatMsg, [nOnlineCountMin, nOnlineCountMax]);
  SaveContLogMsg(Config, sLogMsg);
  nOnlineCountMax := 0;
end;

procedure TFrmMain.BtnShowServerUsersClick(Sender: TObject);
var
  I: integer;
begin
  for I := 0 to nUserLimit - 1 do begin
    MainOutMessage(UserLimit[I].sServerName + ' ' +
      IntToStr(UserLimit[i].nLimitCountMin) + '/' +
      IntToStr(UserLimit[i].nLimitCountMax));
  end;
end;
//0046ECB4
procedure TFrmMain.MonitorTimerTimer(Sender: TObject);
var
  I:    integer;
  nCol: integer;
  sServerName: string;
  ServerList: TList;
  MsgServer: pTMsgServerInfo;
begin
  try
    ServerList := FrmMasSoc.m_ServerList;
    if (ServerList.Count div 2) < 2 then begin
      MonitorGrid.RowCount    := 2;
      MonitorGrid.Cells[0, 1] := '';
      MonitorGrid.Cells[1, 1] := '';
      MonitorGrid.Cells[2, 1] := '';
      MonitorGrid.Cells[3, 1] := '';
      MonitorGrid.Cells[4, 1] := '';
      MonitorGrid.Cells[5, 1] := '';
    end else begin
      MonitorGrid.RowCount := ((ServerList.Count div 2) + 1) + (ServerList.Count mod 2);
    end; //0046ED54
    for I := 0 to ServerList.Count - 1 do begin
      nCol      := (I mod 2) * 3;
      MsgServer := ServerList.Items[I];
      sServerName := MsgServer.sServerName;
      if sServerName <> '' then begin
        if MsgServer.nServerIndex = 99 then
          MonitorGrid.Cells[nCol, (I div 2 + 1)] := sServerName + ' [DB]'
        else
          MonitorGrid.Cells[nCol, (I div 2 + 1)] :=
            sServerName + ' ' + IntToStr(MsgServer.nServerIndex);
        MonitorGrid.Cells[nCol + 1, (I div 2 + 1)] := IntToStr(MsgServer.nOnlineCount);
        if (GetTickCount - MsgServer.dwKeepAliveTick) < 30000 then
          MonitorGrid.Cells[nCol + 2, (I div 2 + 1)] := '����'
        else
          MonitorGrid.Cells[nCol + 2, (I div 2 + 1)] := '��ʱ';
      end else begin //0046EEF2
        MonitorGrid.Cells[nCol, (I div 2 + 1)]     := '-';
        MonitorGrid.Cells[nCol + 1, (I div 2 + 1)] := '-';
        MonitorGrid.Cells[nCol + 2, (I div 2 + 1)] := '-';
      end;
    end;
  except
    MainOutMessage('TFrmMain.MonitorTimerTimer');
  end;
end;
//0046A178
function IsPayMent(Config: pTConfig; sIPaddr, sAccount: string): boolean;
begin
  Result := False;
  try
    CS_DB.Enter;
    if (Config.AccountCostList.GetIndex(sAccount) >= 0) or
      (Config.IPaddrCostList.GetIndex(sIPaddr) >= 0) then Result := True;
  finally
    CS_DB.Leave;
  end;
end;
//0046A23C
procedure CloseUser(Config: pTConfig; sAccount: string; nSessionID: integer);
var
  ConnInfo: pTConnInfo;
  I: integer;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count - 1 downto 0 do begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sAccount) or (ConnInfo.nSessionID = nSessionID) then
      begin
        FrmMasSoc.SendServerMsg(SS_CLOSESESSION, ConnInfo.sServerName,
          ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
        Dispose(ConnInfo);
        Config.SessionList.Delete(I);
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

procedure ProcessGate(Config: pTConfig);
var
  I:  integer;
  II: integer;
  GateInfo: pTGateInfo;
  UserInfo: pTUserInfo;
begin
  EnterCriticalSection(Config.GateCriticalSection);
  try
    Config.dwProcessGateTick := GetTickCount();
    I := 0;
    while (True) do begin
      if Config.GateList.Count <= I then break;
      GateInfo := Config.GateList.Items[I];
      if GateInfo.sReceiveMsg <> '' then begin
        DecodeGateData(Config, GateInfo);
        Config.sGateIPaddr := GateInfo.sIPaddr;
        II := 0;
        while (True) do begin
          if GateInfo.UserList.Count <= II then break;
          UserInfo := GateInfo.UserList.Items[II];
          if UserInfo.sReceiveMsg <> '' then DecodeUserData(Config, UserInfo);
          Inc(II);
        end;
      end;
      Inc(I);
    end;
    if Config.dwProcessGateTime < Config.dwProcessGateTick then
      Config.dwProcessGateTime := GetTickCount - Config.dwProcessGateTick;
    if Config.dwProcessGateTime > 100 then Dec(Config.dwProcessGateTime, 100);
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;

//0046AC08
procedure DecodeGateData(Config: pTConfig; GateInfo: pTGateInfo);
var
  nCount: integer;
  sMsg:   string;
  sSockIndex: string;
  sData:  string;
  Code:   char;
begin
  try
    nCount := 0;
    while (True) do begin
      if TagCount(GateInfo.sReceiveMsg, '$') <= 0 then break;
      GateInfo.sReceiveMsg := ArrestStringEx(GateInfo.sReceiveMsg, '%', '$', sMsg);
      if sMsg <> '' then begin
        Code := sMsg[1];
        sMsg := Copy(sMsg, 2, Length(sMsg) - 1);
        case Code of
          '-': begin
            SendKeepAlivePacket(GateInfo.Socket);
            GateInfo.dwKeepAliveTick := GetTickCount();
          end;
          'A': begin
            sData := GetValidStr3(sMsg, sSockIndex, ['/']);
            ReceiveSendUser(Config, sSockIndex, GateInfo, sData);
          end;
          'O': begin
            sData := GetValidStr3(sMsg, sSockIndex, ['/']);
            ReceiveOpenUser(Config, sSockIndex, sData, GateInfo);
          end;
          'X': begin
            sSockIndex := sMsg;
            ReceiveCloseUser(Config, sSockIndex, GateInfo);
          end;
        end;
      end else begin //0046AD85
        if nCount >= 1 then GateInfo.sReceiveMsg := '';
        Inc(nCount);
      end;
    end;
  except
    MainOutMessage('[Exception] TFrmMain.DecodeGateData');
  end;
end;
//0046A63C
procedure SendKeepAlivePacket(Socket: TCustomWinSocket);
begin
  if Socket.Connected then Socket.SendText('%++$');
end;
//0046B058
procedure ReceiveCloseUser(Config: pTConfig; sSockIndex: string; GateInfo: pTGateInfo);
var
  UserInfo: pTUserInfo;
  I: integer;
resourcestring
  sCloseMsg = 'Close: %s';
begin
  for I := 0 to GateInfo.UserList.Count - 1 do begin
    UserInfo := GateInfo.UserList.Items[I];
    if UserInfo.sSockIndex = sSockIndex then begin
      if Config.boShowDetailMsg then
        MainOutMessage(format(sCloseMsg, [UserInfo.sUserIPaddr]));
      if not UserInfo.boSelServer then SessionDel(Config, UserInfo.nSessionID);
      Dispose(UserInfo);
      GateInfo.UserList.Delete(I);
      break;
    end;
  end;
end;
//0046AE3C
procedure ReceiveOpenUser(Config: pTConfig; sSockIndex, sIPaddr: string;
  GateInfo: pTGateInfo);
var
  UserInfo: pTUserInfo;
  I: integer;
  sGateIPaddr: string;
  sUserIPaddr: string;
resourcestring
  sOpenMsg = 'Open: %s/%s';
begin
  sGateIPaddr := GetValidStr3(sIPaddr, sUserIPaddr, ['/']);
  try
    for I := 0 to GateInfo.UserList.Count - 1 do begin
      UserInfo := GateInfo.UserList.Items[I];
      if UserInfo.sSockIndex = sSockIndex then begin
        UserInfo.sUserIPaddr  := sUserIPaddr;
        UserInfo.sGateIPaddr  := sGateIPaddr;
        UserInfo.sAccount     := '';
        UserInfo.nSessionID   := 0;
        UserInfo.sReceiveMsg  := '';
        UserInfo.dwTime5C     := GetTickCount();
        UserInfo.dwClientTick := GetTickCount();
        exit;
      end;
    end;
    New(UserInfo);
    UserInfo.sAccount := '';
    UserInfo.sUserIPaddr := sUserIPaddr;
    UserInfo.sGateIPaddr := sGateIPaddr;
    UserInfo.sSockIndex := sSockIndex;
    UserInfo.nVersionDate := 0;
    UserInfo.boCertificationOK := False;
    UserInfo.nSessionID := 0;
    UserInfo.bo51     := False;
    UserInfo.Socket   := GateInfo.Socket;
    UserInfo.sReceiveMsg := '';
    UserInfo.dwTime5C := GetTickCount();
    UserInfo.dwClientTick := GetTickCount();
    UserInfo.bo60     := False;
    UserInfo.Gate     := GateInfo;
    GateInfo.UserList.Add(UserInfo);
    if Config.boShowDetailMsg then
      MainOutMessage(format(sOpenMsg, [sUserIPaddr, sGateIPaddr]));
  except
    MainOutMessage('TFrmMain.ReceiveOpenUser');
  end;
end;
//0046B1A8
procedure ReceiveSendUser(Config: pTConfig; sSockIndex: string;
  GateInfo: pTGateInfo; sData: string);
var
  UserInfo: pTUserInfo;
  I: integer;
begin
  try
    for I := 0 to GateInfo.UserList.Count - 1 do begin
      UserInfo := GateInfo.UserList.Items[I];
      if UserInfo.sSockIndex = sSockIndex then begin
        if Length(UserInfo.sReceiveMsg) < 4069 then begin
          UserInfo.sReceiveMsg := UserInfo.sReceiveMsg + sData;
        end;
        Break;
      end;
    end;
  except
    MainOutMessage('TFrmMain.ReceiveSendUser');
  end;
end;


//00469D38
procedure SessionClearKick(Config: pTConfig);
var
  I: integer;
  ConnInfo: pTConnInfo;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count - 1 downto 0 do begin
      ConnInfo := Config.SessionList.Items[I];
      if ConnInfo.boKicked and ((GetTickCount - ConnInfo.dwKickTick) > 5 * 1000) then
      begin
        Dispose(ConnInfo);
        Config.SessionList.Delete(I);
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

//0046B284
procedure DecodeUserData(Config: pTConfig; UserInfo: pTUserInfo);
var
  sMsg:   string;
  nCount: integer;
begin
  nCount := 0;
  try
    //if UserInfo = nil then nErrCode:=1;
    while (True) do begin
      if TagCount(UserInfo.sReceiveMsg, '!') <= 0 then break;
      UserInfo.sReceiveMsg := ArrestStringEx(UserInfo.sReceiveMsg, '#', '!', sMsg);
      if sMsg <> '' then begin
        ;
        if Length(sMsg) >= DEFBLOCKSIZE + 1 then begin
          sMsg := Copy(sMsg, 2, Length(sMsg) - 1);
          ProcessUserMsg(Config, UserInfo, sMsg);
        end;
      end else begin
        if nCount >= 1 then UserInfo.sReceiveMsg := '';
        Inc(nCount);
      end;
      if UserInfo.sReceiveMsg = '' then break;
    end;
  except
    MainOutMessage('[Exception] TFrmMain.DecodeUserData ');
  end;

end;
//0046A088
procedure SessionDel(Config: pTConfig; nSessionID: integer);
var
  ConnInfo: pTConnInfo;
  i: integer;
begin
  Config.SessionList.Lock;
  try
    for i := 0 to Config.SessionList.Count - 1 do begin
      ConnInfo := Config.SessionList.Items[i];
      if ConnInfo.nSessionID = nSessionID then begin
        Dispose(ConnInfo);
        Config.SessionList.Delete(i);
        break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//0046CC3C
procedure ProcessUserMsg(Config: pTConfig; UserInfo: pTUserInfo; sMsg: string);
var
  sDefMsg: string;
  sData:   string;
  DefMsg:  TDefaultMessage;
begin
  try
    sDefMsg := Copy(sMsg, 1, DEFBLOCKSIZE);
    sData   := Copy(sMsg, DEFBLOCKSIZE + 1, Length(sMsg) - DEFBLOCKSIZE);
    DefMsg  := DecodeMessage(sDefMsg);

    case DefMsg.Ident of
      CM_SELECTSERVER: begin
        if not UserInfo.boSelServer then begin
          AccountSelectServer(Config, UserInfo, sData);
        end;
      end;
      CM_PROTOCOL: begin
        AccountCheckProtocol(UserInfo, DefMsg.Recog);
      end;
      CM_IDPASSWORD: begin
        if UserInfo.sAccount = '' then begin
          AccountLogin(Config, UserInfo, sData);
        end else begin
          KickUser(Config, UserInfo);
        end;
      end;
      CM_ADDNEWUSER: begin
        if Config.boEnableMakingID then begin
          if (GetTickCount - UserInfo.dwClientTick) > 5000 then begin
            UserInfo.dwClientTick := GetTickCount();
            AccountCreate(Config, UserInfo, sData);
          end else begin
            MainOutMessage('[Hacker Attack] _ADDNEWUSER ' + '/' + UserInfo.sUserIPaddr);
          end;
        end;
      end;
      CM_CHANGEPASSWORD: begin
        if UserInfo.sAccount = '' then begin
          if (GetTickCount - UserInfo.dwClientTick) > 5000 then begin
            UserInfo.dwClientTick := GetTickCount();
            AccountChangePassword(Config, UserInfo, sData);
          end else begin
            MainOutMessage('[Hacker Attack] _CHANGEPASSWORD ' + '/' +
              UserInfo.sUserIPaddr);
          end;
        end else
          UserInfo.sAccount := '';
      end;
      CM_UPDATEUSER: begin
        if (GetTickCount - UserInfo.dwClientTick) > 5000 then begin
          UserInfo.dwClientTick := GetTickCount();
          AccountUpdateUserInfo(Config, UserInfo, sData);
        end else begin
          MainOutMessage('[Hacker Attack] _UPDATEUSER ' + '/' + UserInfo.sUserIPaddr);
        end;
      end;
      CM_GETBACKPASSWORD: begin
        if (GetTickCount - UserInfo.dwClientTick) > 5000 then begin
          UserInfo.dwClientTick := GetTickCount();
          AccountGetBackPassword(UserInfo, sData);
        end else begin
          MainOutMessage('[Hacker Attack] _GETBACKPASSWORD ' + '/' +
            UserInfo.sUserIPaddr);
        end;
      end;
    end;
  except
    MainOutMessage('[Exception] TFrmMain.ProcessUserMsg ' + 'wIdent: ' +
      IntToStr(DefMsg.Ident) + ' sData: ' + sData);
  end;
end;

procedure AccountCreate(Config: pTConfig; UserInfo: pTUserInfo; sData: string);//0046C244
var
  UserEntry: TUserEntry;
  UserAddEntry: TUserEntryAdd;
  DBRecord: TAccountDBRecord;
  nLen:     integer;
  sUserEntryMsg: string;
  sUserAddEntryMsg: string;
  nErrCode: integer;
  DefMsg:   TDefaultMessage;
  bo21:     boolean;
  nIndex:      integer;

resourcestring
  sAddNewuserFail = '[ID Creation Failed] %s/%s';
  sLogFlag = 'new';

begin
  try
    nErrCode := -1;
    FillChar(UserEntry, SizeOf(TUserEntry), #0);
    FillChar(UserAddEntry, SizeOf(TUserEntryAdd), #0);
    nLen := GetCodeMsgSize(SizeOf(TUserEntry) * 4 / 3);
    bo21 := False;
    sUserEntryMsg := Copy(sData, 1, nLen);
    sUserAddEntryMsg := Copy(sData, nLen + 1, Length(sData) - nLen);
    if (sUserEntryMsg <> '') and (sUserAddEntryMsg <> '') then begin
      DecodeBuffer(sUserEntryMsg, @UserEntry, SizeOf(TUserEntry));
      DecodeBuffer(sUserAddEntryMsg, @UserAddEntry, SizeOf(TUserEntryAdd));
      if CheckAccountName(UserEntry.sAccount) then bo21 := True;
      if bo21 then begin
        try
          if AccountDB.Open then begin
            nIndex := AccountDB.Index(UserEntry.sAccount);
            if nIndex < 0 then begin
              FillChar(DBRecord, SizeOf(TAccountDBRecord), #0);
              DBRecord.UserEntry    := UserEntry;
              DBRecord.UserEntryAdd := UserAddEntry;
              if UserEntry.sAccount <> '' then
                if AccountDB.Add(DBRecord) then nErrCode := 1;
            end else
              nErrCode := 0;
          end;
        finally
          AccountDB.Close;
        end;
      end else begin
        MainOutMessage(format(sAddNewuserFail, [UserEntry.sAccount,
          UserAddEntry.sQuiz2]));
      end; //0046C480
    end;
    if nErrCode = 1 then begin
      WriteLogMsg(Config, sLogFlag, UserEntry, UserAddEntry);
      DefMsg := MakeDefaultMsg(SM_NEWID_SUCCESS, 0, 0, 0, 0);
    end else begin
      DefMsg := MakeDefaultMsg(SM_NEWID_FAIL, nErrCode, 0, 0, 0);
    end;
    SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
  except
    MainOutMessage('TFrmMain.AddNewUser');
  end;
end;
//0046C814
procedure AccountChangePassword(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
var
  sMsg:     string;
  sLoginID: string;
  sOldPassword: string;
  sNewPassword: string;
  DefMsg:   TDefaultMessage;
  nCode:    integer;
  n10:      integer;
  DBRecord: TAccountDBRecord;
resourcestring
  sChgMsg = 'chg';
begin
  try
    sMsg  := DecodeString(sData);
    sMsg  := GetValidStr3(sMsg, sLoginID, [#9]);
    sNewPassword := GetValidStr3(sMsg, sOldPassword, [#9]);
    nCode := 0;

    try
      if AccountDB.Open and (Length(sNewPassword) >= 3) then begin
        n10 := AccountDB.Index(sLoginID);
        if (n10 >= 0) and (AccountDB.Get(n10, DBRecord) >= 0) then begin
          //if (DBRecord.nErrorCount >= 5) or ((GetTickCount - DBRecord.dwActionTick) > 180000) then begin
          if (DBRecord.nErrorCount < 5) or
            ((GetTickCount - DBRecord.dwActionTick) > 180000) then begin
            if DBRecord.UserEntry.sPassword = sOldPassword then begin
              DBRecord.nErrorCount := 0;
              DBRecord.UserEntry.sPassword := sNewPassword;
              nCode := 1;
            end else begin
              Inc(DBRecord.nErrorCount);
              DBRecord.dwActionTick := GetTickCount();
              nCode := -1;
            end;
            AccountDB.Update(n10, DBRecord);
          end else begin
            nCode := -2;
            if GetTickCount < DBRecord.dwActionTick then begin
              DBRecord.dwActionTick := GetTickCount();
              AccountDB.Update(n10, DBRecord);
            end;
          end;
        end;
      end;
    finally
      AccountDB.Close;
    end;

    if nCode = 1 then begin
      DefMsg := MakeDefaultMsg(SM_CHGPASSWD_SUCCESS, 0, 0, 0, 0);
      WriteLogMsg(Config, sChgMsg, DBRecord.UserEntry, DBRecord.UserEntryAdd);
    end else begin
      DefMsg := MakeDefaultMsg(SM_CHGPASSWD_FAIL, nCode, 0, 0, 0);
    end;
    SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
  except
    MainOutMessage('TFrmMain.ChangePassword');
  end;
end;

procedure AccountCheckProtocol(UserInfo: pTUserInfo; nDate: integer);
var
  DefMsg: TDefaultMessage;
begin
  if nDate < nVersionDate then begin
    DefMsg := MakeDefaultMsg(SM_CERTIFICATION_FAIL, 0, 0, 0, 0);
  end else begin
    DefMsg := MakeDefaultMsg(SM_CERTIFICATION_SUCCESS, 0, 0, 0, 0);
    UserInfo.nVersionDate := nDate;
    UserInfo.boCertificationOK := True;
  end;
  SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
end;
//0046A368
function KickUser(Config: pTConfig; UserInfo: pTUserInfo): boolean;
var
  I:    integer;
  II:   integer;
  GateInfo: pTGateInfo;
  User: pTUserInfo;
resourcestring
  sKickMsg = 'Kick: %s';
begin
  Result := False;
  EnterCriticalSection(Config.GateCriticalSection);
  try
    for I := 0 to Config.GateList.Count - 1 do begin
      GateInfo := Config.GateList.Items[I];
      for II := 0 to GateInfo.UserList.Count - 1 do begin
        User := GateInfo.UserList.Items[II];
        if User = UserInfo then begin
          if Config.boShowDetailMsg then
            MainOutMessage(format(sKickMsg, [UserInfo.sUserIPaddr]));
          SendGateKickMsg(GateInfo.Socket, UserInfo.sSockIndex);
          Dispose(UserInfo);
          GateInfo.UserList.Delete(II);
          Result := True;
          exit;
        end;
      end;
    end;
  finally
    LeaveCriticalSection(Config.GateCriticalSection);
  end;
end;
//0046B400
procedure AccountLogin(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
var
  sLoginID: string;
  sPassword: string;
  nCode: integer;
  boNeedUpdate: boolean;
  DefMsg: TDefaultMessage;
  UserEntry: TUserEntry;
  nIDCost: integer;
  nIPCost: integer;
  nIDCostIndex: integer;
  nIPCostIndex: integer;
  DBRecord: TAccountDBRecord;
  n10: integer;
  boPayCost: boolean;
  sServerName: string;
begin
  try
    sPassword := GetValidStr3(DecodeString(sData), sLoginID, ['/']);
    nCode     := 0;
    boNeedUpdate := False;

    try
      if AccountDB.Open then begin
        n10 := AccountDB.Index(sLoginID);
        if (n10 >= 0) and (AccountDB.Get(n10, DBRecord) >= 0) then begin
          if (DBRecord.nErrorCount < 5) or
            ((GetTickCount - DBRecord.dwActionTick) > 60000) then begin
            if DBRecord.UserEntry.sPassword = sPassword then begin
              DBRecord.nErrorCount := 0;
              if (DBRecord.UserEntry.sUserName = '') or
                (DBRecord.UserEntryAdd.sQuiz2 = '') then begin
                UserEntry    := DBRecord.UserEntry;
                boNeedUpdate := True;
              end;
              DBRecord.Header.CreateDate := UserInfo.dtDateTime;
              nCode := 1;
            end else begin
              Inc(DBRecord.nErrorCount);
              DBRecord.dwActionTick := GetTickCount();
              nCode := -1;
            end;
            AccountDB.Update(n10, DBRecord);
          end else begin
            nCode := -2;
            DBRecord.dwActionTick := GetTickCount();
            AccountDB.Update(n10, DBRecord);
          end;
        end;
      end;
    finally
      AccountDB.Close;
    end;

    if (nCode = 1) and IsLogin(Config, sLoginID) then begin
      SessionKick(Config, sLoginID);
      nCode := -3;
    end;
    if boNeedUpdate then begin
      DefMsg := MakeDefaultMsg(SM_NEEDUPDATE_ACCOUNT, 0, 0, 0, 0);
      SendGateMsg(UserInfo.Socket,
        UserInfo.sSockIndex,
        EncodeMessage(DefMsg) + EncodeBuffer(@UserEntry, SizeOf(TUserEntry)));
    end;
    if nCode = 1 then begin
      UserInfo.sAccount    := sLoginID;
      UserInfo.nSessionID  := GetSessionID();
      UserInfo.boSelServer := False;
      try
        CS_DB.Enter;
        nIDCostIndex := Config.AccountCostList.GetIndex(UserInfo.sAccount);
        nIPCostIndex := Config.IPaddrCostList.GetIndex(UserInfo.sUserIPaddr);
        nIDCost      := 0;
        nIPCost      := 0;
        boPayCost    := False;
        if nIDCostIndex >= 0 then
          nIDCost := integer(Config.AccountCostList.Objects[nIDCostIndex]);
        if nIPCostIndex >= 0 then begin
          nIPCost   := integer(Config.IPaddrCostList.Objects[nIPCostIndex]);
          boPayCost := True;
        end;
      finally
        CS_DB.Leave;
      end;
      if (nIDCost >= 0) or (nIPCost >= 0) then UserInfo.boPayCost := True
      else
        UserInfo.boPayCost := False;
      UserInfo.nIDDay := LoWord(nIDCost);
      UserInfo.nIDHour := HiWord(nIDCost);
      UserInfo.nIPDay  := LoWord(nIPCost);
      UserInfo.nIPHour := HiWord(nIPCost);
      if not UserInfo.boPayCost then begin
        DefMsg := MakeDefaultMsg(SM_PASSOK_SELECTSERVER, 0, 0, 0,
          Config.ServerNameList.Count);
      end else begin
        DefMsg := MakeDefaultMsg(SM_PASSOK_SELECTSERVER, nIDCost,
          Loword(nIPCost), HiWord(nIPCost), Config.ServerNameList.Count);
      end;
      sServerName := GetServerListInfo;
      SendGateMsg(UserInfo.Socket,
        UserInfo.sSockIndex,
        EncodeMessage(DefMsg) + EncodeString(sServerName));
      SessionAdd(Config,
        UserInfo.sAccount,
        UserInfo.sUserIPaddr,
        UserInfo.nSessionID,
        UserInfo.boPayCost);
      //CODE:0046B857                 call    sub_46C150
    end else begin
      DefMsg := MakeDefaultMsg(SM_PASSWD_FAIL, nCode, 0, 0, 0);
      SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
    end;
  except
    MainOutMessage('TFrmMain.LoginUser');
  end;
end;
//0046D890
procedure GetSelGateInfo(Config: pTConfig; sServerName, sIPaddr: string;
  var sSelGateIP: string; var nSelGatePort: integer);
var
  I: integer;
  nGateIdx: integer;
  nGateCount: integer;
  nSelIdx: integer;
  boSelected: boolean;
begin
  try
    sSelGateIP   := '';
    nSelGatePort := 0;
    for I := 0 to Config.nRouteCount - 1 do begin
      if Config.boDynamicIPMode or ((Config.GateRoute[I].sServerName = sServerName) and
        (Config.GateRoute[I].sPublicAddr = sIPaddr)) then begin
        nGateCount := 0;
        nGateIdx   := 0;
        while (True) do begin
          if (Config.GateRoute[I].Gate[nGateIdx].sIPaddr <> '') and
            (Config.GateRoute[I].Gate[nGateIdx].boEnable) then
            Inc(nGateCount);
          Inc(nGateIdx);
          if nGateIdx >= 10 then break;
        end;//0046D956
        if nGateCount <= 0 then break;//���û���������IP���ã�������

        nSelIdx    := Config.GateRoute[I].nSelIdx;
        boSelected := False;
        for nGateIdx := nSelIdx + 1 to 9 do begin
          if (Config.GateRoute[I].Gate[nGateIdx].sIPaddr <> '') and
            (Config.GateRoute[I].Gate[nGateIdx].boEnable) then begin
            Config.GateRoute[I].nSelIdx := nGateIdx;
            boSelected := True;
            break;
          end;
        end;
        if not boSelected then begin
          for nGateIdx := 0 to nSelIdx - 1 do begin
            if (Config.GateRoute[I].Gate[nGateIdx].sIPaddr <> '') and
              (Config.GateRoute[I].Gate[nGateIdx].boEnable) then begin
              Config.GateRoute[I].nSelIdx := nGateIdx;
              break;
            end;
          end;
        end;//0046DA2B
        nSelIdx      := Config.GateRoute[I].nSelIdx;
        sSelGateIP   := Config.GateRoute[I].Gate[nSelIdx].sIPaddr;
        nSelGatePort := Config.GateRoute[I].Gate[nSelIdx].nPort;
        break;
      end;//0046DA72
    end;//0046DA7E
  except
    MainOutMessage('TFrmMain.GetSelGateInfo');
  end;
end;

function GetServerListInfo: string;
var
  sServerInfo: string;
  I:      integer;
  sServerName: string;
  Config: pTConfig;
begin
  Config := @g_Config;
  try
    for I := 0 to Config.ServerNameList.Count - 1 do begin
      sServerName := Config.ServerNameList.Strings[I];
      if sServerName <> '' then
        sServerInfo := sServerInfo + sServerName + '/' +
          IntToStr(FrmMasSoc.ServerStatus(sServerName)) + '/';
    end;
  {
  for I := 0 to n473290 - 1 do begin
    if (GateRoute[i].sServerName <> '') then begin
      sServerInfo:=sServerInfo + GateRoute[i].sServerName + '/' + IntToStr(FrmMasSoc.ServerStatus(GateRoute[i].sServerName)) + '/';
    end;
  end;
  }
    Result := sServerInfo;
  except
    MainOutMessage('TFrmMain.GetServerListInfo');
  end;
end;

procedure AccountSelectServer(Config: pTConfig; UserInfo: pTUserInfo;
  sData: string);//0046B908
var
  sServerName: string;
  DefMsg:      TDefaultMessage;
  boPayCost:   boolean;
  nPayMode:    integer;
  sSelGateIP:  string;
  nSelGatePort: integer;
resourcestring
  sSelServerMsg = 'Server: %s/%s-%s:%d';
begin
  sServerName := DecodeString(sData);
  if (UserInfo.sAccount <> '') and (sServerName <> '') and
    IsLogin(Config, UserInfo.nSessionID) then begin
    GetSelGateInfo(Config, sServerName, Config.sGateIPaddr, sSelGateIP, nSelGatePort);

    if (sSelGateIP <> '') and (nSelGatePort > 0) then begin
      if Config.boDynamicIPMode then sSelGateIP := UserInfo.sGateIPaddr;
      //����֧��̬IP

      if Config.boShowDetailMsg then
        MainOutMessage(format(sSelServerMsg, [sServerName, Config.sGateIPaddr,
          sSelGateIP, nSelGatePort]));

      UserInfo.boSelServer := True;
      boPayCost := False;
      nPayMode  := 5;
      if UserInfo.nIDHour > 0 then nPayMode := 2;
      if UserInfo.nIPHour > 0 then nPayMode := 4;
      if UserInfo.nIPDay > 0 then nPayMode := 3;
      if UserInfo.nIDDay > 0 then nPayMode := 1;
      if FrmMasSoc.IsNotUserFull(sServerName) then begin
        SessionUpdate(Config, UserInfo.nSessionID, sServerName, boPayCost);
        FrmMasSoc.SendServerMsg(SS_OPENSESSION, sServerName,
          UserInfo.sAccount + '/' + IntToStr(UserInfo.nSessionID) +
          '/' + IntToStr(integer(UserInfo.boPayCost)) + '/' +
          IntToStr(nPayMode) + '/' + UserInfo.sUserIPaddr);
        DefMsg := MakeDefaultMsg(SM_SELECTSERVER_OK, UserInfo.nSessionID, 0, 0, 0);

        SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg) +
          EncodeString(sSelGateIP + '/' + IntToStr(nSelGatePort) +
          '/' + IntToStr(UserInfo.nSessionID)));
      end else begin
        UserInfo.boSelServer := False;
        SessionDel(Config, UserInfo.nSessionID);
        DefMsg := MakeDefaultMsg(SM_STARTFAIL, 0, 0, 0, 0);
        SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
      end;
    end;
  end;
end;
//0046C570
procedure AccountUpdateUserInfo(Config: pTConfig; UserInfo: pTUserInfo; sData: string);
var
  UserEntry: TUserEntry;
  UserAddEntry: TUserEntryAdd;
  DBRecord: TAccountDBRecord;
  nLen:   integer;
  sUserEntryMsg: string;
  sUserAddEntryMsg: string;
  nCode:  integer;
  DefMsg: TDefaultMessage;
  n10:    integer;
begin
  try
    FillChar(UserEntry, SizeOf(TUserEntry), #0);
    FillChar(UserAddEntry, SizeOf(TUserEntryAdd), #0);
    nLen := GetCodeMsgSize(SizeOf(TUserEntry) * 4 / 3);
    sUserEntryMsg := Copy(sData, 1, nLen);
    sUserAddEntryMsg := Copy(sData, nLen + 1, Length(sData) - nLen);
    DecodeBuffer(sUserEntryMsg, @UserEntry, SizeOf(TUserEntry));
    DecodeBuffer(sUserAddEntryMsg, @UserAddEntry, SizeOf(TUserEntryAdd));
    nCode := -1;
    if (UserInfo.sAccount = UserEntry.sAccount) and
      CheckAccountName(UserEntry.sAccount) then begin

      try
        if AccountDB.Open then begin
          n10 := AccountDB.Index(UserEntry.sAccount);
          if (n10 >= 0) then begin
            if (AccountDB.Get(n10, DBRecord) >= 0) then begin
              DBRecord.UserEntry    := UserEntry;
              DBRecord.UserEntryAdd := UserAddEntry;
              AccountDB.Update(n10, DBRecord);
              nCode := 1;
            end;
          end else
            nCode := 0;
        end;
      finally
        AccountDB.Close;
      end;
    end; //0046C74B

    if nCode = 1 then begin
      WriteLogMsg(Config, 'upg', UserEntry, UserAddEntry);
      DefMsg := MakeDefaultMsg(SM_UPDATEID_SUCCESS, 0, 0, 0, 0);
    end else begin
      DefMsg := MakeDefaultMsg(SM_UPDATEID_FAIL, nCode, 0, 0, 0);
    end;
    SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
  except
    MainOutMessage('TFrmMain.UpdateUserInfo');
  end;
end;

procedure AccountGetBackPassword(UserInfo: pTUserInfo; sData: string);
var
  sMsg:      string;
  sAccount:  string;
  sQuest1:   string;
  sAnswer1:  string;
  sQuest2:   string;
  sAnswer2:  string;
  sPassword: string;
  sBirthDay: string;
  nCode:     integer;
  nIndex:    integer;
  DefMsg:    TDefaultMessage;
  DBRecord:  TAccountDBRecord;
begin
  sMsg := DecodeString(sData);
  sMsg := GetValidStr3(sMsg, sAccount, [#9]);
  sMsg := GetValidStr3(sMsg, sQuest1, [#9]);
  sMsg := GetValidStr3(sMsg, sAnswer1, [#9]);
  sMsg := GetValidStr3(sMsg, sQuest2, [#9]);
  sMsg := GetValidStr3(sMsg, sAnswer2, [#9]);
  sMsg := GetValidStr3(sMsg, sBirthDay, [#9]);

  nCode := 0;

  try
    if (sAccount <> '') and AccountDB.Open then begin
      nIndex := AccountDB.Index(sAccount);
      if (nIndex >= 0) and (AccountDB.Get(nIndex, DBRecord) >= 0) then begin
        if (DBRecord.nErrorCount < 5) or
          ((GetTickCount - DBRecord.dwActionTick) > 180000) then begin
          nCode := -1;
          if (DBRecord.UserEntry.sQuiz = sQuest1) then begin
            nCode := -3;
            if DBRecord.UserEntry.sAnswer = sAnswer1 then begin
              if DBRecord.UserEntryAdd.sBirthDay = sBirthDay then begin
                nCode := 1;
              end;
            end;
          end;
          if nCode <> 1 then begin
            if (DBRecord.UserEntryAdd.sQuiz2 = sQuest2) then begin
              nCode := -3;
              if DBRecord.UserEntryAdd.sAnswer2 = sAnswer2 then begin
                if DBRecord.UserEntryAdd.sBirthDay = sBirthDay then begin
                  nCode := 1;
                end;
              end;
            end;
          end;
          if nCode = 1 then begin
            sPassword := DBRecord.UserEntry.sPassword;
          end else begin
            Inc(DBRecord.nErrorCount);
            DBRecord.dwActionTick := GetTickCount();
            AccountDB.Update(nIndex, DBRecord);
          end;
        end else begin
          nCode := -2;
          if GetTickCount < DBRecord.dwActionTick then begin
            DBRecord.dwActionTick := GetTickCount();
            AccountDB.Update(nIndex, DBRecord);
          end;
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;

  if nCode = 1 then begin
    DefMsg := MakeDefaultMsg(SM_GETBACKPASSWD_SUCCESS, 0, 0, 0, 0);
    SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg) +
      EncodeString(sPassword));
  end else begin
    DefMsg := MakeDefaultMsg(SM_GETBACKPASSWD_FAIL, nCode, 0, 0, 0);
    SendGateMsg(UserInfo.Socket, UserInfo.sSockIndex, EncodeMessage(DefMsg));
  end;
end;

//0046A500
procedure SendGateMsg(Socket: TCustomWinSocket; sSockIndex, sMsg: string);
var
  sSendMsg: string;
begin
  sSendMsg := '%' + sSockIndex + '/#' + sMsg + '!$';
  Socket.SendText(sSendMsg);
end;
//0046A104
function IsLogin(Config: pTConfig; nSessionID: integer): boolean;
var
  ConnInfo: pTConnInfo;
  I: integer;
begin
  Result := False;
  Config.SessionList.Lock;
  try
    for I := 0 to Config.SessionList.Count - 1 do begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.nSessionID = nSessionID) then begin
        Result := True;
        break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//00469B54
function IsLogin(Config: pTConfig; sLoginID: string): boolean;
var
  ConnInfo: pTConnInfo;
  I: integer;
begin
  Result := False;
  Config.SessionList.Lock;
  try
    for I := 0 to Config.SessionList.Count - 1 do begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sLoginID) then begin
        Result := True;
        break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//00469BE8
procedure SessionKick(Config: pTConfig; sLoginID: string);
var
  ConnInfo: pTConnInfo;
  I: integer;
begin
  Config.SessionList.Lock;
  try
    for I := 0 to Config.SessionList.Count - 1 do begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.sAccount = sLoginID) and not ConnInfo.boKicked then begin
        FrmMasSoc.SendServerMsg(SS_CLOSESESSION, ConnInfo.sServerName,
          ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
        ConnInfo.dwKickTick := GetTickCount();
        ConnInfo.boKicked   := True;

        break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;

//00469F00
procedure SessionAdd(Config: pTConfig; sAccount, sIPaddr: string;
  nSessionID: integer; boPayCost: boolean);
var
  ConnInfo: pTConnInfo;
begin
  New(ConnInfo);
  ConnInfo.sAccount := sAccount;
  ConnInfo.sIPaddr  := sIPaddr;
  ConnInfo.nSessionID := nSessionID;
  ConnInfo.boPayCost := boPayCost;
  ConnInfo.dwKickTick := GetTickCount();
  ConnInfo.dwStartTick := GetTickCount();
  ConnInfo.boKicked := False;
  Config.SessionList.Lock;
  try
    Config.SessionList.Add(ConnInfo);
  finally
    Config.SessionList.UnLock;
  end;
end;
//0046A5AC
procedure SendGateKickMsg(Socket: TCustomWinSocket; sSockIndex: string);
var
  sSendMsg: string;
begin
  sSendMsg := '%+-' + sSockIndex + '$';
  Socket.SendText(sSendMsg);
end;

procedure SessionUpdate(Config: pTConfig; nSessionID: integer;
  sServerName: string; boPayCost: boolean);
var
  ConnInfo: pTConnInfo;
  I: integer;
begin
  Config.SessionList.Lock;
  try
    for I := 0 to Config.SessionList.Count - 1 do begin
      ConnInfo := Config.SessionList.Items[I];
      if (ConnInfo.nSessionID = nSessionID) then begin
        ConnInfo.sServerName := sServerName;
        ConnInfo.boPayCost := boPayCost;
        break;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//00469694
procedure GenServerNameList(Config: pTConfig);
var
  I, II: integer;
  boD:   boolean;
begin
  try
    Config.ServerNameList.Clear;
    for I := 0 to Config.nRouteCount - 1 do begin
      boD := True;
      for II := 0 to Config.ServerNameList.Count - 1 do begin
        if Config.ServerNameList.Strings[II] = Config.GateRoute[I].sServerName then
          boD := False;
      end;
      if boD then Config.ServerNameList.Add(Config.GateRoute[I].sServerName);
    end;
  except
    MainOutMessage('TFrmMain.GenServerNameList');
  end;
end;
//00469DB4
procedure SessionClearNoPayMent(Config: pTConfig);
var
  I: integer;
  ConnInfo: pTConnInfo;
begin
  Config.SessionList.Lock;
  try
    for I := Config.SessionList.Count - 1 downto 0 do begin
      ConnInfo := Config.SessionList.Items[I];
      if not ConnInfo.boKicked and not Config.boTestServer and not ConnInfo.boPayCost then
      begin
        if (GetTickCount - ConnInfo.dwStartTick) > 60 * 60 * 1000 then begin
          ConnInfo.dwStartTick := GetTickCount();
          if not IsPayMent(Config, ConnInfo.sIPaddr, ConnInfo.sAccount) then
          begin
            FrmMasSoc.SendServerMsg(SS_KICKUSER, ConnInfo.sServerName,
              ConnInfo.sAccount + '/' + IntToStr(ConnInfo.nSessionID));
            Dispose(ConnInfo);
            Config.SessionList.Delete(I);
          end;
        end;
      end;
    end;
  finally
    Config.SessionList.UnLock;
  end;
end;
//0046DD38
procedure LoadIPaddrCostList(Config: pTConfig; QuickList: TQuickList);
begin
  try
    CS_DB.Enter;
    Config.IPaddrCostList.Clear;
    Config.IPaddrCostList.AddStrings(QuickList);
  finally
    CS_DB.Leave;
  end;
end;
//0046DCD0
procedure LoadAccountCostList(Config: pTConfig; QuickList: TQuickList);
begin
  try
    CS_DB.Enter;
    Config.AccountCostList.Clear;
    Config.AccountCostList.AddStrings(QuickList);
  finally
    CS_DB.Leave;
  end;
end;



procedure TFrmMain.Panel2DblClick(Sender: TObject);
begin
  MainOutMessage(GetServerListInfo);
end;


procedure TFrmMain.GameCenterGetUserAccount(sData: string);
var
  DBRecord: TAccountDBRecord;
  nIndex:   integer;
  nCode:    integer;
  DefMsg:   TDefaultMessage;
begin
  try
    nCode := -1;
    if AccountDB.Open then begin
      nIndex := AccountDB.Index(sData);
      if (nIndex >= 0) and (AccountDB.Get(nIndex, DBRecord) >= 0) then begin
        nCode := 1;
      end;
    end;
  finally
    AccountDB.Close;
  end;

  if nCode > 0 then begin
    DefMsg := MakeDefaultMsg(0, nCode, 0, 0, 0);
  end else begin
    DefMsg := MakeDefaultMsg(SG_USERACCOUNTNOTFOUND, nCode, 0, 0, 0);
  end;
end;

procedure TFrmMain.GameCenterChangeAccountInfo(sData: string);
var
  NewRecord, DBRecord: TAccountDBRecord;
  DefMsg:  TDefaultMessage;
  sDefMsg: string;
  nCode, nIndex: integer;
begin
  if Length(sData) < DEFBLOCKSIZE then exit;
  sDefMsg := Copy(sData, 1, DEFBLOCKSIZE);
  sData   := Copy(sData, DEFBLOCKSIZE + 1, Length(sData) - DEFBLOCKSIZE);
  DefMsg  := DecodeMessage(sDefMsg);
  DecodeBuffer(sData, @NewRecord, SizeOf(NewRecord));
  nCode := -1;

  try
    if AccountDB.Open then begin
      nIndex := AccountDB.Index(NewRecord.UserEntry.sAccount);
      if (nIndex >= 0) and (AccountDB.Get(nIndex, DBRecord) >= 0) then begin
        if DBRecord.UserEntry.sAccount = NewRecord.UserEntry.sAccount then begin
          DBRecord.nErrorCount  := 0;
          DBRecord.dwActionTick := 0;
          DBRecord.UserEntry    := NewRecord.UserEntry;
          DBRecord.UserEntryAdd := NewRecord.UserEntryAdd;
          AccountDB.Update(nIndex, DBRecord);
          nCode := 1;
        end else begin
          nCode := 2;
        end;
      end;
    end;
  finally
    AccountDB.Close;
  end;

  DefMsg := MakeDefaultMsg(0, nCode, 0, 0, 0);
end;


procedure SaveContLogMsg(Config: pTConfig; sLogMsg: string);
var
  Year, Month, Day, Hour, Min, Sec, MSec: word;
  sLogDir, sLogFileName: string;
  LogFile: TextFile;
begin
  if sLogMsg = '' then exit;

  DecodeDate(Date, Year, Month, Day);
  DecodeTime(Time, Hour, Min, Sec, MSec);
  if not DirectoryExists(Config.sCountLogDir) then begin
    CreateDir(Config.sCountLogDir);
  end;
  sLogDir := Config.sCountLogDir + IntToStr(Year) + '-' + IntToStr2(Month);
  if not DirectoryExists(sLogDir) then begin
    CreateDirectory(PChar(sLogDir), nil);
  end;
  sLogFileName := sLogDir + '\' + IntToStr(Year) + '-' + IntToStr2(Month) +
    '-' + IntToStr2(Day) + '.txt';
  AssignFile(LogFile, sLogFileName);
  if not FileExists(sLogFileName) then begin
    Rewrite(LogFile);
  end else begin
    Append(LogFile);
  end;
  sLogMsg := sLogMsg + #9 + TimeToStr(Time);

  WriteLn(LogFile, sLogMsg);
  CloseFile(LogFile);
end;

procedure WriteLogMsg(Config: pTConfig; sType: string; var UserEntry: TUserEntry;
  var UserAddEntry: TUserEntryAdd);
var
  Year, Month, Day: word;
  sLogDir, sLogFileName: string;
  LogFile: TextFile;
  sLogFormat, sLogMsg: string;
begin
  DecodeDate(Date, Year, Month, Day);
  if not DirectoryExists(Config.sChrLogDir) then begin
    CreateDir(Config.sChrLogDir);
  end;
  sLogDir := Config.sChrLogDir + IntToStr(Year) + '-' + IntToStr2(Month);
  if not DirectoryExists(sLogDir) then begin
    CreateDirectory(PChar(sLogDir), nil);
  end;
  sLogFileName := sLogDir + '\Id_' + IntToStr2(Day) + '.log';
  AssignFile(LogFile, sLogFileName);
  if not FileExists(sLogFileName) then begin
    Rewrite(LogFile);
  end else begin
    Append(LogFile);
  end;
  sLogFormat := '*%s*'#9'%s'#9'"%s"'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'%s'#9'[%s]';
  sLogMsg    := format(sLogFormat, [sType, UserEntry.sAccount,
    UserEntry.sPassword, UserEntry.sUserName, UserEntry.sSSNo,
    UserEntry.sQuiz, UserEntry.sAnswer, UserEntry.sEMail, UserAddEntry.sQuiz2,
    UserAddEntry.sAnswer2, UserAddEntry.sBirthDay, UserAddEntry.sMobilePhone,
    TimeToStr(Now)]);

  //sLogMsg:= UserAddEntry.sQuiz2 + UserAddEntry.sAnswer2 + UserAddEntry.sBirthDay + UserAddEntry.sMobilePhone + '[' + TimeToStr(Now) + ']';

  WriteLn(LogFile, sLogMsg);
  CloseFile(LogFile);
end;

procedure StartService(Config: pTConfig);
begin
  InitializeConfig(Config);
  LoadConfig(Config);
//  LoadDBSetup;
end;

procedure StopService(Config: pTConfig);
begin
  UnInitializeConfig(Config);
end;

procedure InitializeConfig(Config: pTConfig);
resourcestring
  sConfigFile = '.\Logsrv.ini';
begin
  Config.IniConf := TIniFile.Create(sConfigFile);
  InitializeCriticalSection(Config.GateCriticalSection);
end;

procedure UnInitializeConfig(Config: pTConfig);
begin
  Config.IniConf.Free;
  DeleteCriticalSection(Config.GateCriticalSection);
end;

procedure LoadConfig(Config: pTConfig);

  function LoadConfigString(sSection, sIdent, sDefault: string): string;
  var
    sString: string;
  begin
    sString := Config.IniConf.ReadString(sSection, sIdent, '');
    if sString = '' then begin
      Config.IniConf.WriteString(sSection, sIdent, sDefault);
      Result := sDefault;
    end else begin
      Result := sString;
    end;
  end;

  function LoadConfigInteger(sSection, sIdent: string; nDefault: integer): integer;
  var
    nLoadInteger: integer;
  begin
    nLoadInteger := Config.IniConf.ReadInteger(sSection, sIdent, -1);
    if nLoadInteger < 0 then begin
      Config.IniConf.WriteInteger(sSection, sIdent, nDefault);
      Result := nDefault;
    end else begin
      Result := nLoadInteger;
    end;
  end;

  function LoadConfigBoolean(sSection, sIdent: string; boDefault: boolean): boolean;
  var
    nLoadInteger: integer;
  begin
    nLoadInteger := Config.IniConf.ReadInteger(sSection, sIdent, -1);
    if nLoadInteger < 0 then begin
      Config.IniConf.WriteBool(sSection, sIdent, boDefault);
      Result := boDefault;
    end else begin
      Result := nLoadInteger = 1;
    end;
  end;

begin
  Config.sDBServer  := LoadConfigString('Server', 'DBServer', Config.sDBServer);
  Config.sFeeServer := LoadConfigString('Server', 'FeeServer', Config.sFeeServer);
  Config.sLogServer := LoadConfigString('Server', 'LogServer', Config.sLogServer);

  Config.sGateAddr   := LoadConfigString('Server', 'GateAddr', Config.sGateAddr);
  Config.nGatePort   := LoadConfigInteger('Server', 'GatePort', Config.nGatePort);
  Config.sServerAddr := LoadConfigString('Server', 'ServerAddr', Config.sServerAddr);
  Config.nServerPort := LoadConfigInteger('Server', 'ServerPort', Config.nServerPort);
  Config.sMonAddr    := LoadConfigString('Server', 'MonAddr', Config.sMonAddr);
  Config.nMonPort    := LoadConfigInteger('Server', 'MonPort', Config.nMonPort);

  Config.nDBSPort      := LoadConfigInteger('Server', 'DBSPort', Config.nDBSPort);
  Config.nFeePort      := LoadConfigInteger('Server', 'FeePort', Config.nFeePort);
  Config.nLogPort      := LoadConfigInteger('Server', 'LogPort', Config.nLogPort);
  Config.nReadyServers := LoadConfigInteger('Server', 'ReadyServers', Config.nReadyServers);
  Config.boEnableMakingID := LoadConfigBoolean('Server', 'TestServer', Config.boEnableMakingID);
  Config.boDynamicIPMode := LoadConfigBoolean('Server', 'DynamicIPMode', Config.boDynamicIPMode);

  Config.sWebLogDir  := LoadConfigString('DB', 'WebLogDir', Config.sWebLogDir);
  Config.sCountLogDir := LoadConfigString('DB', 'CountLogDir', Config.sCountLogDir);
  Config.sFeedIDList := LoadConfigString('DB', 'FeedIDList', Config.sFeedIDList);
  Config.sFeedIPList := LoadConfigString('DB', 'FeedIPList', Config.sFeedIPList);
end;

procedure TFrmMain.R1Click(Sender: TObject);
var
  Config: pTConfig;
  I, II: Integer;
begin
  Config := @g_Config;
  Config.ServerNameList.Clear;
  for I := Low(Config.GateRoute) to High(Config.GateRoute) do begin
    Config.GateRoute[I].sServerName := '';
    Config.GateRoute[I].sTitle := '';
    Config.GateRoute[I].sRemoteAddr := '';
    Config.GateRoute[I].sPublicAddr := '';
    Config.GateRoute[I].nSelIdx := 0;
    for II := Low(Config.GateRoute[I].Gate) to High(Config.GateRoute[I].Gate) do begin
      Config.GateRoute[I].Gate[II].sIPaddr := '';
      Config.GateRoute[I].Gate[II].nPort := 0;
      Config.GateRoute[I].Gate[II].boEnable := False;
    end;
  end;
  LoadAddrTable(Config);
  MainOutMessage('����·���б����...');
end;

procedure TFrmMain.C1Click(Sender: TObject);
var
  I: Integer;
begin
  for I := Low(ServerAddr) to High(ServerAddr) do begin
    ServerAddr[I] := '';
  end;
  FrmMasSoc.LoadServerAddr();
  for I := Low(UserLimit) to High(UserLimit) do begin
    UserLimit[I].sServerName := '';
    UserLimit[I].sName := '';
    UserLimit[I].nLimitCountMin := 3000;
    UserLimit[I].nLimitCountMax := 0;
  end;
//  FrmMasSoc.LoadUserLimit();
  MainOutMessage('���������ļ����...');
end;

procedure TFrmMain.Button1Click(Sender: TObject);
begin
  FrmFindUserId.Show;
end;

procedure TFrmMain.G1Click(Sender: TObject);
begin
  FrmBasicSet := TFrmBasicSet.Create(Owner);
  FrmBasicSet.Top := Top;
  FrmBasicSet.Left := Left;
  FrmBasicSet.OpenBasicSet();
  FrmBasicSet.Free;
end;

procedure TFrmMain.MENU_HELP_ABOUTClick(Sender: TObject);
begin
  Memo1.Lines.Add(DecodeString(g_sVersion));
  Memo1.Lines.Add(DecodeString(g_sUpDateTime));
  Memo1.Lines.Add(DecodeString(g_sProgram));
  Memo1.Lines.Add(DecodeString(g_sWebSite));
end;

procedure TFrmMain.Button2Click(Sender: TObject);
begin
  FrmBasicSet := TFrmBasicSet.Create(Owner);
  FrmBasicSet.Top := Top;
  FrmBasicSet.Left := Left;
  FrmBasicSet.OpenBasicSet();
  FrmBasicSet.Free;
end;

procedure TFrmMain.Button3Click(Sender: TObject);
begin
  OpenRouteConfig();
end;

end.
