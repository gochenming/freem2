//=============================================================================
//���ú���˵��:
//   �������ֵ����������̨��:
//     procedure MainOutMessasge(sMsg:String;nMode:integer)
//     sMsg ΪҪ���͵��ı�����
//     nMode Ϊ����ģʽ��0Ϊ�����ڿ���̨����ʾ��1Ϊ������ʾ���У��Ժ���ʾ
//
//   ȡ��0-255���������ɫ
//     function GetRGB(bt256:Byte):TColor;
//     bt256 Ҫ��ѯ����
//     ����ֵ Ϊ�������ɫ
//
//   ���͹㲥���֣�
//     procedure SendBroadCastMsg(sMsg:String;MsgType:TMsgType);
//     sMsg Ҫ���͵�����
//     MsgType ��������
//=============================================================================
unit PlugMain;

interface
uses
  Windows, Graphics, SysUtils, Des, IniFiles;
procedure InitPlug(AppHandle: THandle; boLoadSucced: Boolean);
procedure UnInitPlug();
function DeCodeText(sText: string): string;
function SearchIPLocal(sIPaddr: string): string;
function DecodeString_3des(Source, Key: string): string;
function EncodeString_3des(Source, Key: string): string;
function StartRegisterLicense(sRegisterCode: string): Boolean;
function CheckLicense(sRegisterCode: string): Boolean;
procedure Open();
function GetRegisterName(): string;
implementation

uses Module, QQWry, DESTR, Share, DiaLogMain, HardInfo, MD5EncodeStr;
function DecodeString_3des(Source, Key: string): string;
var
  Decode: TDCP_3des;
begin
  try
    Result := '';
    Decode := TDCP_3des.Create(nil);
    Decode.InitStr(Key);
    Decode.Reset;
    Result := Decode.DecryptString(Source);
    Decode.Reset;
    Decode.Free;
  except
    Result := '';
  end;
end;

function EncodeString_3des(Source, Key: string): string;
var
  Encode: TDCP_3des;
begin
  try
    Result := '';
    Encode := TDCP_3des.Create(nil);
    Encode.InitStr(Key);
    Encode.Reset;
    Result := Encode.EncryptString(Source);
    Encode.Reset;
    Encode.Free;
  except
    Result := '';
  end;
end;
//=============================================================================
//���ز��ģ��ʱ���õĳ�ʼ������
//������Apphandle Ϊ��������
//=============================================================================
function GetRegisterName(): string;
var
  sRegisterName, Str: string;
  n64: Int64;
begin
  sRegisterName := '';
  Str := '';
  if sRegisterName = '' then begin
    try
      sRegisterName := Trim(HardInfo.GetScsisn); //Ӳ�����к�
    except
      sRegisterName := '';
    end;
  end;

  if sRegisterName = '' then begin
    try
      sRegisterName := Trim(HardInfo.GetCPUInfo_); //CPU���к�
    except
      sRegisterName := '';
    end;
  end;

  if sRegisterName = '' then begin
    try
      sRegisterName := Trim(HardInfo.GetAdapterMac(0)); //������ַ
    except
      sRegisterName := '';
    end;
  end;

  if sRegisterName <> '' then begin
    Str := EncodeString_3des(sRegisterName, sDecryKey);
    Result := RivestStr(Str);
  end else Result := '';
end;

function CheckLicense(sRegisterCode: string): Boolean;
var
  sTempStr: string;
begin
  Result := False;
  if m_sRegisterName <> '' then begin
    sTempStr := EncodeString_3des(m_sRegisterName, sDecryKey);
    sTempStr := RivestStr(sTempStr);
    if CompareText(sTempStr, sRegisterCode) = 0 then Result := True;
  end;
end;

function StartRegisterLicense(sRegisterCode: string): Boolean;
var
  Config: TInifile;
  sTempStr: string;
  sFileName: string;
begin
  Result := False;
  if CheckLicense(sRegisterCode) then begin
    sFileName := ExtractFilePath(Paramstr(0)) + '!Setup.txt';
    Config := TInifile.Create(sFileName);
    if Config <> nil then begin
      Config.WriteString('Reg', 'RegisterName', m_sRegisterName);
      Config.WriteString('Reg', 'RegisterCode', sRegisterCode);
      Config.Free;
      Result := True;
    end;
  end;
end;

function GetLicense(sRegisterName: string): Integer;
var
  Config: TInifile;
  sFileName: string;
  sRegisterCode: string;
begin
  Result := 0;
  sFileName := ExtractFilePath(Paramstr(0)) + '!Setup.txt';
  if FileExists(sFileName) then begin
    Config := TInifile.Create(sFileName);
    if Config <> nil then begin
      sRegisterCode := Config.ReadString('Reg', 'RegisterCode', '');
      if sRegisterCode <> '' then begin
        if CheckLicense(sRegisterCode) then Result := 1000;
      end;
      Config.Free;
    end;
  end;
end;

procedure Open();
begin
  FrmDiaLog := TFrmDiaLog.Create(nil);
  FrmDiaLog.Open;
  FrmDiaLog.Free;
end;

procedure InitPlug(AppHandle: THandle; boLoadSucced: Boolean);
var
  boRegister: Boolean;
begin
  boRegister := False;
  nRegister := 0;
  m_sRegisterName := GetRegisterName();
  if GetLicense(m_sRegisterName) = 1000 then begin
    nRegister := 1000;
  end else begin
    Open();
    nRegister := GetLicense(m_sRegisterName);
  end;
  if boLoadSucced and (nRegister = 1000) then
    MainOutMessasge(sStartLoadPlugSucced, 0)
  else MainOutMessasge(sStartLoadPlugFail, 0);
end;
//=============================================================================
//�˳����ģ��ʱ���õĽ�������
//=============================================================================
procedure UnInitPlug();
begin
  {
    д����Ӧ�������;
  }
  MainOutMessasge(sUnLoadPlug, 0);
end;

//=============================================================================
//��Ϸ�ı�������Ϣ���뺯��(һ�����ڼӽ��ܽű�)
//������sText ΪҪ������ַ���
//����ֵ�����ؽ������ַ���(���ص��ַ������Ȳ��ܳ���1024�ֽڣ��������������)
//=============================================================================
function DeCodeScript(sText: string): string;
begin
  try
    Result := DecodeString_3des(DecryStrHex(sText, sDecryKey), sDecryKey);
  except
    Result := '';
  end;
end;

function DeCodeText(sText: string): string;
begin
  Result := '';
  if (sText <> '') and (sText[1] <> ';') and (nCheckCode = 5) and (nRegister = 1000) then begin
    Result := DeCodeScript(sText);
  end;
  //Result:='����ֵ�����ؽ������ַ���';
end;

//=============================================================================
//IP���ڵز�ѯ����
//������sIPaddr ΪҪ��ѯ��IP��ַ
//����ֵ������IP���ڵ��ı���Ϣ(���ص��ַ������Ȳ��ܳ���255�ֽڣ������ᱻ�ض�)
//=============================================================================

function SearchIPLocal(sIPaddr: string): string;
var
  QQWry: TQQWry;
  s02, s03: string;
begin
  try
    QQWry := TQQWry.Create(sIPFileName);
    s02 := QQWry.GetIPMsg(QQWry.GetIPRecordID(sIPaddr))[2];
    s03 := QQWry.GetIPMsg(QQWry.GetIPRecordID(sIPaddr))[3];
    Result := Format('%s%s', [s02, s03]);
    QQWry.Free;
  except
    Result := '';
  end;
end;

end.

