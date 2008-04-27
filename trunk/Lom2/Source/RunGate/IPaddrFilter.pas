unit IPaddrFilter;

interface

uses
  svn, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JSocket, Menus, Spin, IniFiles;

type
  TfrmIPaddrFilter = class(TForm)
    GroupBoxActive: TGroupBox;
    ListBoxActiveList: TListBox;
    GroupBox1: TGroupBox;
    ListBoxTempList: TListBox;
    ListBoxBlockList: TListBox;
    LabelTempList: TLabel;
    Label1: TLabel;
    BlockListPopupMenu: TPopupMenu;
    TempBlockListPopupMenu: TPopupMenu;
    ActiveListPopupMenu: TPopupMenu;
    APOPMENU_SORT: TMenuItem;
    APOPMENU_ADDTEMPLIST: TMenuItem;
    APOPMENU_BLOCKLIST: TMenuItem;
    APOPMENU_KICK: TMenuItem;
    TPOPMENU_SORT: TMenuItem;
    TPOPMENU_BLOCKLIST: TMenuItem;
    TPOPMENU_DELETE: TMenuItem;
    BPOPMENU_ADDTEMPLIST: TMenuItem;
    BPOPMENU_SORT: TMenuItem;
    BPOPMENU_DELETE: TMenuItem;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    EditMaxConnect: TSpinEdit;
    GroupBox3: TGroupBox;
    RadioAddBlockList: TRadioButton;
    RadioAddTempList: TRadioButton;
    RadioDisConnect: TRadioButton;
    APOPMENU_REFLIST: TMenuItem;
    ButtonOK: TButton;
    Label4: TLabel;
    TPOPMENU_REFLIST: TMenuItem;
    BPOPMENU_REFLIST: TMenuItem;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    EditMaxSize: TSpinEdit;
    TPOPMENU_ADD: TMenuItem;
    BPOPMENU_ADD: TMenuItem;
    EditMaxClientMsgCount: TSpinEdit;
    Label8: TLabel;
    CheckBoxLostLine: TCheckBox;
    Label9: TLabel;
    EditClientTimeOutTime: TSpinEdit;
    EditNomSize: TSpinEdit;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ActiveListPopupMenuPopup(Sender: TObject);
    procedure APOPMENU_KICKClick(Sender: TObject);
    procedure APOPMENU_SORTClick(Sender: TObject);
    procedure APOPMENU_ADDTEMPLISTClick(Sender: TObject);
    procedure APOPMENU_BLOCKLISTClick(Sender: TObject);
    procedure TPOPMENU_SORTClick(Sender: TObject);
    procedure TPOPMENU_BLOCKLISTClick(Sender: TObject);
    procedure TPOPMENU_DELETEClick(Sender: TObject);
    procedure BPOPMENU_SORTClick(Sender: TObject);
    procedure BPOPMENU_ADDTEMPLISTClick(Sender: TObject);
    procedure BPOPMENU_DELETEClick(Sender: TObject);
    procedure TempBlockListPopupMenuPopup(Sender: TObject);
    procedure BlockListPopupMenuPopup(Sender: TObject);
    procedure EditMaxConnectChange(Sender: TObject);
    procedure RadioDisConnectClick(Sender: TObject);
    procedure RadioAddBlockListClick(Sender: TObject);
    procedure RadioAddTempListClick(Sender: TObject);
    procedure APOPMENU_REFLISTClick(Sender: TObject);
    procedure TPOPMENU_REFLISTClick(Sender: TObject);
    procedure BPOPMENU_REFLISTClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure EditMaxSizeChange(Sender: TObject);
    procedure TPOPMENU_ADDClick(Sender: TObject);
    procedure BPOPMENU_ADDClick(Sender: TObject);
    procedure EditMaxClientMsgCountChange(Sender: TObject);
    procedure CheckBoxLostLineClick(Sender: TObject);
    procedure EditClientTimeOutTimeChange(Sender: TObject);
    procedure EditNomSizeChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmIPaddrFilter: TfrmIPaddrFilter;

implementation

uses Main, GateShare, HUtil32;

{$R *.dfm}

procedure TfrmIPaddrFilter.FormCreate(Sender: TObject);
begin
  ListBoxActiveList.Clear;
  ListBoxTempList.Clear;
  ListBoxBlockList.Clear;
end;

procedure TfrmIPaddrFilter.ActiveListPopupMenuPopup(Sender: TObject);
var
  boCheck:Boolean;
begin
  APOPMENU_SORT.Enabled:= ListBoxActiveList.Items.Count > 0;

  boCheck:= (ListBoxActiveList.ItemIndex >= 0) and (ListBoxActiveList.ItemIndex < ListBoxActiveList.Items.Count);

  APOPMENU_ADDTEMPLIST.Enabled:=boCheck;
  APOPMENU_BLOCKLIST.Enabled:=boCheck;
  APOPMENU_KICK.Enabled:=boCheck;
end;

procedure TfrmIPaddrFilter.APOPMENU_KICKClick(Sender: TObject);
begin
  if (ListBoxActiveList.ItemIndex >=0) and (ListBoxActiveList.ItemIndex < ListBoxActiveList.Items.Count) then begin
    if Application.MessageBox(PChar('�Ƿ�ȷ�Ͻ������ӶϿ���'),
                              PChar('ȷ����Ϣ - ' + ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex]),MB_OKCANCEL + MB_ICONQUESTION) <> IDOK then exit;
    TCustomWinSocket(ListBoxActiveList.Items.Objects[ListBoxActiveList.ItemIndex]).Close;
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmIPaddrFilter.APOPMENU_SORTClick(Sender: TObject);
begin
  ListBoxActiveList.Sorted:=True;
end;

procedure TfrmIPaddrFilter.APOPMENU_ADDTEMPLISTClick(Sender: TObject);
var
  sIPaddr:String;
begin
  if (ListBoxActiveList.ItemIndex >=0) and (ListBoxActiveList.ItemIndex < ListBoxActiveList.Items.Count) then begin
    sIPaddr:=ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex];
    if Application.MessageBox(PChar('�Ƿ�ȷ�Ͻ���IP���붯̬�����б��У���������б�󣬴�IP�������������ӽ���ǿ���жϡ�'),
                              PChar('ȷ����Ϣ - ' + ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex]),
                              MB_OKCANCEL + MB_ICONQUESTION
                              ) <> IDOK then exit;
    ListBoxTempList.Items.Add(sIPaddr);
    TempBlockIPList.Add(sIPaddr);
    FrmMain.CloseConnect(sIPaddr);
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmIPaddrFilter.APOPMENU_BLOCKLISTClick(Sender: TObject);
var
  sIPaddr:String;
begin
  if (ListBoxActiveList.ItemIndex >=0) and (ListBoxActiveList.ItemIndex < ListBoxActiveList.Items.Count) then begin
    sIPaddr:=ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex];
    if Application.MessageBox(PChar('�Ƿ�ȷ�Ͻ���IP�������ù����б��У���������б�󣬴�IP�������������ӽ���ǿ���жϡ�'),
                              PChar('ȷ����Ϣ - ' + ListBoxActiveList.Items.Strings[ListBoxActiveList.ItemIndex]),
                              MB_OKCANCEL + MB_ICONQUESTION
                              ) <> IDOK then exit;
    ListBoxBlockList.Items.Add(sIPaddr);
    BlockIPList.Add(sIPaddr);
    FrmMain.CloseConnect(sIPaddr);
    APOPMENU_REFLISTClick(Self);
  end;
end;

procedure TfrmIPaddrFilter.TPOPMENU_SORTClick(Sender: TObject);
begin
  ListBoxTempList.Sorted:=True;
end;

procedure TfrmIPaddrFilter.TPOPMENU_BLOCKLISTClick(Sender: TObject);
var
  sIPaddr:String;
  i:Integer;
begin
  if (ListBoxTempList.ItemIndex >=0) and (ListBoxTempList.ItemIndex < ListBoxTempList.Items.Count) then begin
    sIPaddr:=ListBoxTempList.Items.Strings[ListBoxTempList.ItemIndex];
    ListBoxTempList.Items.Delete(ListBoxTempList.ItemIndex);
    for i := 0 to TempBlockIPList.Count - 1 do begin
      if TempBlockIPList.Strings[i] = sIPaddr then begin
        TempBlockIPList.Delete(i);
        break;
      end;
    end;
    ListBoxBlockList.Items.Add(sIPaddr);
    BlockIPList.Add(sIPaddr);
  end;
end;

procedure TfrmIPaddrFilter.TPOPMENU_DELETEClick(Sender: TObject);
var
  sIPaddr:String;
  i:Integer;
begin
  if (ListBoxTempList.ItemIndex >=0) and (ListBoxTempList.ItemIndex < ListBoxTempList.Items.Count) then begin
    sIPaddr:=ListBoxTempList.Items.Strings[ListBoxTempList.ItemIndex];
    ListBoxTempList.Items.Delete(ListBoxTempList.ItemIndex);
    for i := 0 to TempBlockIPList.Count - 1 do begin
      if TempBlockIPList.Strings[i] = sIPaddr then begin
        TempBlockIPList.Delete(i);
        break;
      end;
    end;
  end;
end;

procedure TfrmIPaddrFilter.BPOPMENU_SORTClick(Sender: TObject);
begin
  ListBoxBlockList.Sorted:=True;
end;

procedure TfrmIPaddrFilter.BPOPMENU_ADDTEMPLISTClick(Sender: TObject);
var
  sIPaddr:String;
  i:Integer;
begin
  if (ListBoxBlockList.ItemIndex >=0) and (ListBoxBlockList.ItemIndex < ListBoxBlockList.Items.Count) then begin
    sIPaddr:=ListBoxBlockList.Items.Strings[ListBoxBlockList.ItemIndex];
    ListBoxBlockList.Items.Delete(ListBoxBlockList.ItemIndex);
    for i := 0 to TempBlockIPList.Count - 1 do begin
      if TempBlockIPList.Strings[i] = sIPaddr then begin
        TempBlockIPList.Delete(i);
        break;
      end;
    end;
    ListBoxTempList.Items.Add(sIPaddr);
    TempBlockIPList.Add(sIPaddr);
  end;
end;

procedure TfrmIPaddrFilter.BPOPMENU_DELETEClick(Sender: TObject);
var
  sIPaddr:String;
  i:Integer;
begin
  if (ListBoxBlockList.ItemIndex >=0) and (ListBoxBlockList.ItemIndex < ListBoxBlockList.Items.Count) then begin
    sIPaddr:=ListBoxBlockList.Items.Strings[ListBoxBlockList.ItemIndex];
    ListBoxBlockList.Items.Delete(ListBoxBlockList.ItemIndex);
    for i := 0 to BlockIPList.Count - 1 do begin
      if BlockIPList.Strings[i] = sIPaddr then begin
        BlockIPList.Delete(i);
        break;
      end;
    end;
  end;
end;

procedure TfrmIPaddrFilter.TempBlockListPopupMenuPopup(Sender: TObject);
var
  boCheck:Boolean;
begin
  TPOPMENU_SORT.Enabled:= ListBoxTempList.Items.Count > 0;

  boCheck:= (ListBoxTempList.ItemIndex >= 0) and (ListBoxTempList.ItemIndex < ListBoxTempList.Items.Count);

  TPOPMENU_BLOCKLIST.Enabled:=boCheck;
  TPOPMENU_DELETE.Enabled:=boCheck;
end;

procedure TfrmIPaddrFilter.BlockListPopupMenuPopup(Sender: TObject);
var
  boCheck:Boolean;
begin
  BPOPMENU_SORT.Enabled:= ListBoxBlockList.Items.Count > 0;

  boCheck:= (ListBoxBlockList.ItemIndex >= 0) and (ListBoxBlockList.ItemIndex < ListBoxBlockList.Items.Count);

  BPOPMENU_ADDTEMPLIST.Enabled:=boCheck;
  BPOPMENU_DELETE.Enabled:=boCheck;
end;

procedure TfrmIPaddrFilter.EditMaxConnectChange(Sender: TObject);
begin
  nMaxConnOfIPaddr:= EditMaxConnect.Value;
end;

procedure TfrmIPaddrFilter.RadioDisConnectClick(Sender: TObject);
begin
  if RadioDisConnect.Checked then BlockMethod:=mDisconnect;    
end;

procedure TfrmIPaddrFilter.RadioAddBlockListClick(Sender: TObject);
begin
  if RadioAddBlockList.Checked then BlockMethod:=mBlockList;
end;

procedure TfrmIPaddrFilter.RadioAddTempListClick(Sender: TObject);
begin
  if RadioAddTempList.Checked then BlockMethod:=mBlock ;
end;

procedure TfrmIPaddrFilter.APOPMENU_REFLISTClick(Sender: TObject);
var
  i:Integer;
  sIPaddr:String;
begin
  ListBoxActiveList.Clear;
  if FrmMain.ServerSocket.Active then
    for i:= 0 to FrmMain.ServerSocket.Socket.ActiveConnections - 1 do begin
      sIPaddr:=FrmMain.ServerSocket.Socket.Connections[i].RemoteAddress;
      if sIPaddr <> '' then
        ListBoxActiveList.Items.AddObject(sIPaddr,Tobject(FrmMain.ServerSocket.Socket.Connections[i]));
    end;
end;

procedure TfrmIPaddrFilter.TPOPMENU_REFLISTClick(Sender: TObject);
var
  i:Integer;
begin
  ListBoxTempList.Clear;
  for i:= 0 to TempBlockIPList.Count - 1 do begin
      frmIPaddrFilter.ListBoxTempList.Items.Add(TempBlockIPList.Strings[i]);
  end;
end;

procedure TfrmIPaddrFilter.BPOPMENU_REFLISTClick(Sender: TObject);
var
  i:Integer;
begin
  ListBoxBlockList.Clear;
  for i:= 0 to BlockIPList.Count - 1 do begin
      frmIPaddrFilter.ListBoxBlockList.Items.Add(BlockIPList.Strings[i]);
  end;
end;

procedure TfrmIPaddrFilter.ButtonOKClick(Sender: TObject);
begin
  Conf.WriteInteger(GateClass,'MaxConnOfIPaddr',nMaxConnOfIPaddr);
  Conf.WriteInteger(GateClass,'BlockMethod',Integer(BlockMethod));
  Conf.WriteInteger(GateClass,'MaxClientPacketSize',nMaxClientPacketSize);
  Conf.WriteInteger(GateClass,'NomClientPacketSize',nNomClientPacketSize);
  Conf.WriteInteger(GateClass,'MaxClientMsgCount',nMaxClientMsgCount);
  Conf.WriteBool(GateClass,'kickOverPacket',bokickOverPacketSize);
  Conf.WriteInteger(GateClass,'ClientTimeOutTime',dwClientTimeOutTime);
  Close;
end;

procedure TfrmIPaddrFilter.EditMaxSizeChange(Sender: TObject);
begin
  nMaxClientPacketSize:=EditMaxSize.Value;
end;

procedure TfrmIPaddrFilter.TPOPMENU_ADDClick(Sender: TObject);
var
  sIPaddress:String;
begin
  sIPaddress:='';
  if not InputQuery('Enter IP','Please enter the IP adress you wish to perform action on: ',sIPaddress) then exit;
  if not IsIPaddr(sIPaddress) then begin
    Application.MessageBox('Please enter a valid IP address','Error!',MB_OK + MB_ICONERROR);
    exit;
  end;
  ListBoxTempList.Items.Add(sIPaddress);
  TempBlockIPList.Add(sIPaddress);
end;

procedure TfrmIPaddrFilter.BPOPMENU_ADDClick(Sender: TObject);
var
  sIPaddress:String;
begin
  sIPaddress:='';
  if not InputQuery('Enter IP','Please enter the IP adress you wish to perform action on: ',sIPaddress) then exit;
  if not IsIPaddr(sIPaddress) then begin
    if Application.MessageBox('Are you sure you want to permanantly block this IP?','Error!',MB_YESNO + MB_ICONQUESTION) <> ID_YES then
    exit;
  end;
  ListBoxBlockList.Items.Add(sIPaddress);
  BlockIPList.Add(sIPaddress);
end;

procedure TfrmIPaddrFilter.EditMaxClientMsgCountChange(Sender: TObject);
begin
  nMaxClientMsgCount:=EditMaxClientMsgCount.Value;
end;

procedure TfrmIPaddrFilter.CheckBoxLostLineClick(Sender: TObject);
begin
  bokickOverPacketSize:=CheckBoxLostLine.Checked;
end;

procedure TfrmIPaddrFilter.EditClientTimeOutTimeChange(Sender: TObject);
begin
  dwClientTimeOutTime:=EditClientTimeOutTime.Value * 1000;
end;

procedure TfrmIPaddrFilter.EditNomSizeChange(Sender: TObject);
begin
  nNomClientPacketSize:=EditNomSize.Value;
end;

{---- Adjust global SVN revision ----} 	 
initialization 	 
  SVNRevision('$Id: IPaddrFilter.pas 324 2006-08-24 03:38:35Z Dataforce $');
end.