unit GateShare;

interface
uses
  svn, Windows, Messages, Classes, SysUtils, JSocket, WinSock, SyncObjs;

type
  TBlockIPMethod = (mDisconnect,mBlock,mBlockList);
  TSockaddr = record
    nIPaddr        :Integer;
    nCount         :Integer;
    dwIPCountTick1 :LongWord;
    nIPCount1      :Integer;
    dwIPCountTick2 :LongWOrd;
    nIPCount2      :Integer;
    dwDenyTick     :LongWord;
    nIPDenyCount   :Integer; 
  end;
  pTSockaddr = ^TSockaddr;
  
  procedure LoadBlockIPFile();
  procedure SendGameCenterMsg(wIdent:Word;sSendMsg:String);
  procedure SaveBlockIPList();
var
  CS_MainLog            :TCriticalSection;
  CS_FilterMsg          :TCriticalSection;
  MainLogMsgList        :TStringList;
  BlockIPList           :TList;
  TempBlockIPList       :TList;
  CurrIPaddrList        :TList;
  nIPCountLimit1        :Integer = 20;
  nIPCountLimit2        :Integer = 40;
  nShowLogLevel         :Integer = 3;

  StringList456A14      :TStringList;


  
  GateClass             :String = 'LoginGate';
  GateName              :String = 'LoginGate';

  TitleName             :String  = '��֮����';
  ServerPort            :Integer = 5500;
  ServerAddr            :String  = '127.0.0.1';
  GatePort              :Integer = 7000;
  GateAddr              :String  = '0.0.0.0';

  boGateReady           :Boolean = False;
  boShowMessage         :Boolean;
  boStarted             :Boolean = False;
  boClose               :Boolean = False;
  boServiceStart        :Boolean = False;
  dwKeepAliveTick       :LongWord;
  boKeepAliveTimcOut    :Boolean = False;
  nSendMsgCount         :Integer;
  n456A2C               :Integer;
  n456A30               :Integer;
  boSendHoldTimeOut     :Boolean;
  dwSendHoldTick        :LongWord;
  boDecodeLock          :Boolean;

  nMaxConnOfIPaddr      :Integer = 10;
  BlockMethod           :TBlockIPMethod = mDisconnect;
  dwKeepConnectTimeOut  :LongWord = 60 * 1000;
  g_boDynamicIPDisMode  :Boolean = False; //���ڶ�̬IP���ֻ����õ�¼�����ã��򿪴�ģʽ�����ؽ�������ӵ�¼��������IP��ַ����Ϊ������IP��������¼���������ͻ��˽�ֱ��ʹ�ô�IP���ӽ�ɫ����

  g_dwGameCenterHandle  :THandle;
  g_sNowStartGate       :String = '����������¼ǰ�÷�����...';
  g_sNowStartOK         :String = '������¼ǰ�÷��������...';
  PosFile               :String  = '.\Positions.ini';  

implementation

uses Grobal2;


procedure LoadBlockIPFile();
var
  I: Integer;
  sFileName:String;
  LoadList:TStringList;
  sIPaddr:String;
  nIPaddr:Integer;
  IPaddr  :pTSockaddr;
begin
  sFileName:='.\BlockIPList.txt';
  if FileExists(sFileName) then begin
    LoadList:=TStringList.Create;
    LoadList.LoadFromFile(sFileName);
    for I := 0 to LoadList.Count - 1 do begin
      sIPaddr:=Trim(LoadList.Strings[0]);
      if sIPaddr = '' then Continue;
      nIPaddr:=inet_addr(PChar(sIPaddr));
      if nIPaddr = INADDR_NONE then Continue;
      New(IPaddr);
      FillChar(IPaddr^,SizeOf(TSockaddr),0);
      IPaddr.nIPaddr:=nIPaddr;
      BlockIPList.Add(IPaddr);
    end;
    LoadList.Free;
  end;
end;
procedure SaveBlockIPList();
var
  I:Integer;
  SaveList:TStringList;
begin
  SaveList:=TStringList.Create;
  for I := 0 to BlockIPList.Count - 1 do begin
    SaveList.Add(StrPas(inet_ntoa(TInAddr(pTSockaddr(BlockIPList.Items[I]).nIPaddr))));
  end; 
  SaveList.SaveToFile('.\BlockIPList.txt');
  SaveList.Free;
end;
procedure SendGameCenterMsg(wIdent:Word;sSendMsg:String);
var
  SendData:TCopyDataStruct;
  nParam:Integer;
begin
  nParam:=MakeLong(Word(tLoginGate),wIdent);
  SendData.cbData:=Length (sSendMsg) + 1;
  GetMem(SendData.lpData,SendData.cbData);
  StrCopy (SendData.lpData, PChar(sSendMsg));
  SendMessage(g_dwGameCenterHandle,WM_COPYDATA,nParam,Cardinal(@SendData));
  FreeMem(SendData.lpData);
end;

initialization
begin
  {---- Adjust global SVN revision ----}
  SVNRevision('$Id: GateShare.pas 258 2006-08-16 14:18:46Z Dataforce $');
  CS_MainLog:=TCriticalSection.Create;
  CS_FilterMsg:=TCriticalSection.Create;

  StringList456A14:=TStringList.Create;
  MainLogMsgList:=TStringList.Create;
end;

finalization
begin
  StringList456A14.Free;
  MainLogMsgList.Free;
  CS_MainLog.Free;
  CS_FilterMsg.Free;
end;

end.
