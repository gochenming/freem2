library zPlugOfEngine;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  Windows,
  SysUtils,
  Classes,
  PlugMain in 'PlugMain.pas',
  PlayUserCmd in 'PlayUserCmd.pas',
  NpcScriptCmd in 'NpcScriptCmd.pas',
  PlugShare in 'PlugShare.pas',
  PlayUser in 'PlayUser.pas',
  FunctionConfig in 'FunctionConfig.pas' {FrmFunctionConfig},
  HUtil32 in '..\..\PlugInCommon\HUtil32.pas',
  EngineAPI in '..\..\PlugInCommon\EngineAPI.pas',
  EngineType in '..\..\PlugInCommon\EngineType.pas',
  Common in '..\..\Common\Common.pas';

{$R *.res}
{const
  SuperUser = 240621028; //ƮƮ����
  UserKey1 = 13677866; //�ɶ�����
  UserKey2 = 987355; //��������ҵ��
  UserKey3 = 548262; //��������
  UserKey4 = 19639454; //������
  UserKey5 = 240272; //�����Ƽ�
  UserKey6 = 137792942;//������
  UserKey7 = 635455;//�������
  UserKey8 = 240621028; //ƮƮ����
  UserKey9 = 240621028; //ƮƮ����
  UserKey10 = 240621028; //ƮƮ����
  Version = UserKey7; }
const
{$IF Version = SuperUser}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey1}
  PlugName = '�ɶ��������湦�ܲ�� (2006/10/05)';
  LoadPlus = '���طɶ��������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�طɶ��������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey2}
  PlugName = '�����������湦�ܲ�� (2006/10/05)';
  LoadPlus = '���������������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�������������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey3}
  PlugName = '�����������湦�ܲ�� (2006/10/05)';
  LoadPlus = '���غ����������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�غ����������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey4}
  PlugName = '���������湦�ܲ�� (2006/10/06)';
  LoadPlus = '���ط��������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�ط��������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey5}
  PlugName = '�����Ƽ����湦�ܲ�� (2006/10/06)';
  LoadPlus = '���������Ƽ����湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�������Ƽ����湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey6}
  PlugName = '���������湦�ܲ�� (2006/10/06)';
  LoadPlus = '���ط��������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�ط��������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey7}
  PlugName = '����������湦�ܲ�� (2006/10/06)';
  LoadPlus = '��������������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж������������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey8}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey9}
  PlugName = '��Խ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '���ط�Խ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�ط�Խ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey10}
  PlugName = '�����������湦�ܲ�� (2006/10/05)';
  LoadPlus = '���ر����������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�ر����������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey11}
  PlugName = '���˿Ƽ����湦�ܲ�� (2006/10/05)';
  LoadPlus = '�������˿Ƽ����湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�����˿Ƽ����湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey12}
  PlugName = '���ڿƼ����湦�ܲ�� (2006/10/05)';
  LoadPlus = '���ر��ڿƼ����湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж�ر��ڿƼ����湦�ܲ���ɹ�...';

{$ELSEIF Version = UserKey13}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey14}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey15}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey16}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey17}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey18}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey19}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$ELSEIF Version = UserKey20}
  PlugName = 'ƮƮ�������湦�ܲ�� (2006/10/05)';
  LoadPlus = '����ƮƮ�������湦�ܲ���ɹ�...';
  UnLoadPlus = 'ж��ƮƮ�������湦�ܲ���ɹ�...';
{$IFEND}

  nFindObj = 5;
  nPlugHandle = 6;
  nStartPlug = 8;
type
  TMsgProc = procedure(Msg: PChar; nMsgLen: Integer; nMode: Integer); stdcall;
  TFindProc = function(sProcName: PChar; nNameLen: Integer): Pointer; stdcall;
  TFindObj = function(sObjName: PChar; nNameLen: Integer): TObject; stdcall;
  TSetProc = function(ProcAddr: Pointer; ProcName: PChar; nNameLen: Integer): Boolean; stdcall;
  TStartPlug = function(): Boolean; stdcall;
  TGetFunAddr = function(nIndex: Integer): Pointer; stdcall;
  TSetStartPlug = function(StartPlug: TStartPlug): Boolean; stdcall;
var
  OutMessage: TMsgProc;

function Start(): Boolean; stdcall;
begin
  Result := StartPlug;
end;

function Init(AppHandle: HWnd; MsgProc: TMsgProc; FindProc: TFindProc; SetProc: TSetProc; GetFunAddr: TGetFunAddr): PChar; stdcall;
var
  FindObj: TFindObj;
  SetStartPlug: TSetStartPlug;
begin
  PlugHandle := 0;
  OutMessage := MsgProc;
  MsgProc(LoadPlus, length(LoadPlus), 0);
  PlugHandle := PInteger(GetFunAddr(nPlugHandle))^;
  FindObj := TFindObj(GetFunAddr(nFindObj));
  SetStartPlug := TSetStartPlug(GetFunAddr(nStartPlug));
  SetStartPlug(Start);
  InitPlug();
  Result := PlugName;
end;

procedure MainOutMessasge(Msg: string; nMode: Integer);
begin
  if Assigned(OutMessage) then begin
    OutMessage(PChar(Msg), length(Msg), nMode);
  end;
end;

procedure UnInit(); stdcall;
begin
  UnInitPlug();
end;

procedure Config(); stdcall;
begin
  FrmFunctionConfig := TFrmFunctionConfig.Create(nil);
  FrmFunctionConfig.Open();
  FrmFunctionConfig.Free;
end;

exports
  Init, UnInit, Config;
begin

end.

