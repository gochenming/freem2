unit InterMsgClient;

interface

uses
  svn, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, JSocket;

type
  TFrmMsgClient = class(TForm)
    MsgClient: TClientSocket;
    procedure MsgClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure MsgClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure MsgClientRead(Sender: TObject; Socket: TCustomWinSocket);
  private
    dw2D4Tick:LongWord;
    sRecvMsg:String; //0x2D8
    procedure DecodeSocStr;
    { Private declarations }
  public
    procedure SendSocket(sMsg:String);
    procedure ConnectMsgServer();
    procedure Run();
    { Public declarations }
  end;

var
  FrmMsgClient: TFrmMsgClient;

implementation

uses M2Share, HUtil32, EDcode, Grobal2;

{$R *.dfm}

{ TFrmMsgClient }

procedure TFrmMsgClient.ConnectMsgServer; //00495E68
begin
  MsgClient.Active:=False;
  MsgClient.Address:=g_Config.sMsgSrvAddr;
  MsgClient.Port:=g_Config.nMsgSrvPort;
  dw2D4Tick:=GetTickCount();
end;

procedure TFrmMsgClient.Run;//00496360
begin
  if MsgClient.Socket.Connected then begin
    DecodeSocStr();
  end else begin
    if GetTickCount - dw2D4Tick > 20 * 1000 then begin
      dw2D4Tick:=GetTickCount();
      MsgClient.Active:=True;
    end;
  end;
{  if IsDebuggerPresent then
    Application.Terminate;}
end;
procedure TFrmMsgClient.DecodeSocStr;//00496020
var
  sData,sC,s10,s14,s18:String;
  n1C,n20:Integer;
ResourceString
  sExceptionMsg = '[Exception] FrmIdSoc::DecodeSocStr';
begin
  try
  if Pos(')',sRecvMsg) <= 0 then exit;
  sData:=sRecvMsg;
  sRecvMsg:='';
  while (True) do begin
    sData:=ArrestStringEx(sData,'(',')',sC);
    if sC = '' then break;
    s14:=GetValidStr3(sC,s10,['/']);
    s14:=GetValidStr3(s14,s18,['/']);
    n1C:=Str_ToInt(s10,0);
    n20:=Str_ToInt(DecodeString(s18),-1);
    case n1C of    //
      SS_200: ;
      SS_201: ;
      SS_202: ;
      SS_WHISPER: ;
      SS_204: ;
      SS_205: ;
      SS_206: ;
      SS_207: ;
      SS_208: ;
      SS_209: ;
      SS_210: ;
      SS_211: ;
      SS_212: ;
      SS_213: ;
      SS_214: ;
    end;
    if Pos(')',sData) <= 0 then break;      
  end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TFrmMsgClient.SendSocket(sMsg:String);//00495F74
begin
  if MsgClient.Socket.Connected then
    MsgClient.Socket.SendText('(' + sMsg + ')');    
end;
procedure TFrmMsgClient.MsgClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  sRecvMsg:='';
end;

procedure TFrmMsgClient.MsgClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Socket.Close;
  ErrorCode:=0;
end;

procedure TFrmMsgClient.MsgClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  sRecvMsg:=sRecvMsg + Socket.ReceiveText;
end;

{---- Adjust global SVN revision ----}
initialization
  SVNRevision('$Id: InterMsgClient.pas 327 2006-08-24 20:30:52Z Dataforce $');
end.