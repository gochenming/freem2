unit GateShare;

interface
uses
  Windows, SysUtils, Classes, JSocket, WinSock, SyncObjs, IniFiles, Grobal2, Common;
const
  g_sVersion = '����汾: 1.00 Build 20060910';
  g_sUpDateTime = '��������: 2006/09/12';
  g_sProgram = '��������: Ҷ���Ʈ QQ:240621028';
  g_sWebSite = '�ٷ���վ: http://www.51ggame.com';
  GATEMAXSESSION = 1000;
  MSGMAXLENGTH = 20000;
  SENDCHECKSIZE = 512;
  SENDCHECKSIZEMAX = 2048;
type
  TGList = class(TList)
  private
    GLock: TRTLCriticalSection;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  TBlockIPMethod = (mDisconnect, mBlock, mBlockList);
  TSockaddr = record
    nIPaddr: Integer;
    dwStartAttackTick: LongWord;
    nAttackCount: Integer;
  end;
  pTSockaddr = ^TSockaddr;

  TSessionInfo = record
    Socket: TCustomWinSocket; //45AA8C
    sSocData: string; //45AA90
    sSendData: string; //45AA94
    nUserListIndex: Integer; //45AA98
    nPacketIdx: Integer; //45AA9C
    nPacketErrCount: Integer; //45AAA0  //���ݰ�����ظ��������ͻ����÷���������ݼ�⣩
    boStartLogon: Boolean; //45AAA4
    boSendLock: Boolean; //45AAA5
    boOverNomSize: Boolean;
    nOverNomSizeCount: ShortInt;
    dwSendLatestTime: LongWord; //45AAA8
    nCheckSendLength: Integer; //45AAAC
    boSendAvailable: Boolean; //45AAB0
    boSendCheck: Boolean; //45AAB1
    dwTimeOutTime: LongWord; //0x28
    nReceiveLength: Integer; //45AAB8
    dwReceiveLengthTick: LongWord;
    dwReceiveTick: LongWord; //45AABC Tick
    nSckHandle: Integer; //45AAC0
    sRemoteAddr: string; //45AAC4
    dwSayMsgTick: LongWord; //���Լ������
    dwHitTick: LongWord; //����ʱ��
  end;

  pTSessionInfo = ^TSessionInfo;
  TSendUserData = record
    nSocketIdx: Integer; //0x00
    nSocketHandle: Integer; //0x04
    sMsg: string; //0x08
  end;
  pTSendUserData = ^TSendUserData;
procedure AddMainLogMsg(Msg: string; nLevel: Integer);
procedure LoadAbuseFile();
procedure LoadBlockIPFile();
procedure SaveBlockIPList();
var
  CS_MainLog: TCriticalSection;
  CS_FilterMsg: TCriticalSection;
  MainLogMsgList: TStringList;
  nShowLogLevel: Integer = 3;
  GateClass: string = 'Server';
  GateName: string = '��Ϸ����';
  TitleName: string = 'ƮƮ����';
  ServerAddr: string = '127.0.0.1';
  ServerPort: Integer = 5000;
  GateAddr: string = '0.0.0.0';
  GatePort: Integer = 7200;
  boStarted: Boolean = False;
  boClose: Boolean = False;
  boShowBite: Boolean = True; //��ʾB �� KB
  boServiceStart: Boolean = False;
  boGateReady: Boolean = False; //0045AA74 �����Ƿ����
  boCheckServerFail: Boolean = False; //���� <->��Ϸ������֮�����Ƿ�ʧ�ܣ���ʱ��
  //  dwCheckServerTimeOutTime    :LongWord = 60 * 1000 ;//���� <->��Ϸ������֮���ⳬʱʱ�䳤��
  dwCheckServerTimeOutTime: LongWord = 3 * 60 * 1000; //���� <->��Ϸ������֮���ⳬʱʱ�䳤��
  AbuseList: TStringList; //004694F4
  SessionArray: array[0..GATEMAXSESSION - 1] of TSessionInfo;
  SessionCount: Integer; //0x32C ���ӻỰ��
  boShowSckData: Boolean; //0x324 �Ƿ���ʾSOCKET���յ���Ϣ

  sReplaceWord: string = '*';
  ReviceMsgList: TList; //0x45AA64
  SendMsgList: TList; //0x45AA68
  nCurrConnCount: Integer;
  boSendHoldTimeOut: Boolean;
  dwSendHoldTick: LongWord;
  n45AA80: Integer;
  n45AA84: Integer;
  dwCheckRecviceTick: LongWord;
  dwCheckRecviceMin: LongWord;
  dwCheckRecviceMax: LongWord;

  dwCheckServerTick: LongWord;
  dwCheckServerTimeMin: LongWord;
  dwCheckServerTimeMax: LongWord;
  SocketBuffer: PChar; //45AA5C
  nBuffLen: Integer; //45AA60
  List_45AA58: TList;
  boDecodeMsgLock: Boolean;
  dwProcessReviceMsgTimeLimit: LongWord;
  dwProcessSendMsgTimeLimit: LongWord;

  BlockIPList: TGList; //��ֹ����IP�б�
  TempBlockIPList: TGList; //��ʱ��ֹ����IP�б�
  CurrIPaddrList: TGList;
  AttackIPaddrList: TGList; //����IP��ʱ�б�

  nMaxConnOfIPaddr: Integer = 50;
  nMaxClientPacketSize: Integer = 7000;
  nNomClientPacketSize: Integer = 200;
  dwClientCheckTimeOut: LongWord = 50; {3000}
  nMaxOverNomSizeCount: Integer = 2;
  nMaxClientMsgCount: Integer = 20;
  nCheckServerFail: Integer = 0;
  dwAttackTick: LongWord = 200;
  nAttackCount: Integer = 10;

  BlockMethod: TBlockIPMethod = mDisconnect;
  bokickOverPacketSize: Boolean = True;

  //  nClientSendBlockSize        :Integer = 250; //���͸��ͻ������ݰ���С����
  nClientSendBlockSize: Integer = 1000; //���͸��ͻ������ݰ���С����
  dwClientTimeOutTime: LongWord = 5000; //�ͻ������ӻỰ��ʱ(ָ��ʱ����δ�����ݴ���)
  Conf: TIniFile;
  sConfigFileName: string = '.\RunGate.ini';
  nSayMsgMaxLen: Integer = 70; //�����ַ�����
  dwSayMsgTime: LongWord = 1000; //�������ʱ��
  dwHitTime: LongWord = 300; //�������ʱ��
  dwSessionTimeOutTime: LongWord = 60 * 60 * 1000;


implementation

procedure AddMainLogMsg(Msg: string; nLevel: Integer);
var
  tMsg: string;
begin
  try
    CS_MainLog.Enter;
    if nLevel <= nShowLogLevel then begin
      tMsg := '[' + TimeToStr(Now) + '] ' + Msg;
      MainLogMsgList.Add(tMsg);
    end;
  finally
    CS_MainLog.Leave;
  end;
end;
procedure LoadAbuseFile();
var
  sFileName: string;
begin
  AddMainLogMsg('���ڼ������ֹ���������Ϣ...', 4);
  sFileName := '.\WordFilter.txt';
  if FileExists(sFileName) then begin
    try
      CS_FilterMsg.Enter;
      AbuseList.LoadFromFile(sFileName);
    finally
      CS_FilterMsg.Leave;
    end;
  end;
  AddMainLogMsg('���ֹ�����Ϣ�������...', 4);
end;

procedure LoadBlockIPFile();
var
  I: Integer;
  sFileName: string;
  LoadList: TStringList;
  sIPaddr: string;
  nIPaddr: Integer;
  IPaddr: pTSockaddr;
begin
  AddMainLogMsg('���ڼ���IP����������Ϣ...', 4);
  sFileName := '.\BlockIPList.txt';
  if FileExists(sFileName) then begin
    LoadList := TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sIPaddr := Trim(LoadList.Strings[0]);
      if sIPaddr = '' then Continue;
      nIPaddr := inet_addr(PChar(sIPaddr));
      if nIPaddr = INADDR_NONE then Continue;
      New(IPaddr);
      FillChar(IPaddr^, SizeOf(TSockaddr), 0);
      IPaddr.nIPaddr := nIPaddr;
      BlockIPList.Add(IPaddr);
    end;
    LoadList.Free;
  end;
  AddMainLogMsg('IP����������Ϣ�������...', 4);
end;

procedure SaveBlockIPList();
var
  I: Integer;
  SaveList: TStringList;
begin
  SaveList := TStringList.Create;
  for I := 0 to BlockIPList.Count - 1 do begin
    SaveList.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(BlockIPList.Items[I]).nIPaddr))));
  end;
  SaveList.SaveToFile('.\BlockIPList.txt');
  SaveList.Free;
end;

constructor TGList.Create;
begin
  inherited Create;
  InitializeCriticalSection(GLock);
end;

destructor TGList.Destroy;
begin
  DeleteCriticalSection(GLock);
  inherited;
end;

procedure TGList.Lock;
begin
  EnterCriticalSection(GLock);
end;

procedure TGList.UnLock;
begin
  LeaveCriticalSection(GLock);
end;

initialization
  begin
    Conf := TIniFile.Create(sConfigFileName);
    nShowLogLevel := Conf.ReadInteger(GateClass, 'ShowLogLevel', nShowLogLevel);
    CS_MainLog := TCriticalSection.Create;
    CS_FilterMsg := TCriticalSection.Create;
    MainLogMsgList := TStringList.Create;
    AbuseList := TStringList.Create;
    ReviceMsgList := TList.Create;
    SendMsgList := TList.Create;
    List_45AA58 := TList.Create;
    boShowSckData := False;
  end;

finalization
  begin
    List_45AA58.Free;
    ReviceMsgList.Free;
    SendMsgList.Free;
    AbuseList.Free;
    MainLogMsgList.Free;
    CS_MainLog.Free;
    CS_FilterMsg.Free;
    Conf.Free;
  end;

end.

