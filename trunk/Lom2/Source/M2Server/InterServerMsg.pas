unit InterServerMsg;

interface

uses
  svn, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JSocket,ObjBase;

type
  TServerMsgInfo = record
    Socket    :TCustomWinSocket;
    s2E0      :String;
  end;
  pTServerMsgInfo = ^TServerMsgInfo;
  TFrmSrvMsg = class(TForm)
    MsgServer: TServerSocket;
    procedure MsgServerClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MsgServerClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure MsgServerClientError(Sender: TObject;
      Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
      var ErrorCode: Integer);
    procedure MsgServerClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
  private
    PlayObject:TPlayObject;
    SrvArray :array[0..9] of TServerMsgInfo;
    procedure DecodeSocStr;
    procedure MsgGetUserServerChange;
    procedure SendSocket(Socket: TCustomWinSocket;sMsg:String);
    { Private declarations }
  public
    constructor Create();
    destructor Destroy; override;
    procedure SendSocketMsg(sMsg:String);
    procedure StartMsgServer();
    procedure Run();
    { Public declarations }
  end;

var
  FrmSrvMsg: TFrmSrvMsg;

implementation

uses
  M2Share, Grobal2;

{$R *.dfm}

{ TFrmSrvMsg }

procedure TFrmSrvMsg.Run;//004975C8
begin
{  if IsDebuggerPresent then
    Application.Terminate;}
end;

procedure TFrmSrvMsg.StartMsgServer;//004966B0
ResourceString
  sExceptionMsg = '[Exception] TFrmSrvMsg::StartMsgServer';
begin
try
  MsgServer.Active:=False;
  MsgServer.Address:=g_Config.sMsgSrvAddr;
  MsgServer.Port:=g_Config.nMsgSrvPort;
  MsgServer.Active:=True;
except
  on e: Exception do begin
    MainOutMessage(sExceptionMsg);
    MainOutMessage(E.Message);
  end;
end;
end;
procedure TFrmSrvMsg.DecodeSocStr;//00496A0C
begin

end;
procedure TFrmSrvMsg.MsgGetUserServerChange;//00496D10
begin

end;

procedure TFrmSrvMsg.SendSocket(Socket: TCustomWinSocket;sMsg:String);//0049685C
begin
  if Socket.Connected then
    Socket.SendText('(' + sMsg + ')');    
end;

procedure TFrmSrvMsg.SendSocketMsg(sMsg: String);
var
  I: Integer;
  ServerMsgInfo:pTServerMsgInfo;
begin
  for I := Low(SrvArray) to High(SrvArray) do begin
    ServerMsgInfo:=@SrvArray[I];
    if ServerMsgInfo.Socket <> nil then
      SendSocket(ServerMsgInfo.Socket,sMsg);      
  end;
end;

constructor TFrmSrvMsg.Create;
begin
  FillChar(SrvArray,SizeOf(SrvArray),0);
  PlayObject:=TPlayObject.Create;
end;

destructor TFrmSrvMsg.Destroy;
begin
  PlayObject.Free;
  inherited;
end;

procedure TFrmSrvMsg.MsgServerClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
  ServerMsgInfo:pTServerMsgInfo;
begin
  for I := Low(SrvArray) to High(SrvArray) do begin
    ServerMsgInfo:=@SrvArray[I];
    if ServerMsgInfo.Socket = nil then begin
      ServerMsgInfo.Socket:=Socket;
      ServerMsgInfo.s2E0:='';
      Socket.nIndex:=I;
    end;      
  end;
end;

procedure TFrmSrvMsg.MsgServerClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  I: Integer;
  ServerMsgInfo:pTServerMsgInfo;
begin
  for I := Low(SrvArray) to High(SrvArray) do begin
    ServerMsgInfo:=@SrvArray[I];
    if ServerMsgInfo.Socket = Socket then begin
      ServerMsgInfo.Socket:=nil;
      ServerMsgInfo.s2E0:='';
    end;      
  end;
end;

procedure TFrmSrvMsg.MsgServerClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode:=0;
end;

procedure TFrmSrvMsg.MsgServerClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  nC:Integer;
begin
  nC:=Socket.nIndex;
  if (nC <= High(SrvArray)) and (SrvArray[nC].Socket = Socket) then begin
    SrvArray[nC].s2E0:=SrvArray[nC].s2E0 + Socket.ReceiveText;
  end;
    
end;

{---- Adjust global SVN revision ----}
initialization
  SVNRevision('$Id: InterServerMsg.pas 517 2006-12-15 14:54:40Z damian $');
end.
