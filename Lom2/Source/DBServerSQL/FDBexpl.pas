unit FDBexpl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Buttons, Grobal2;

type
  TFrmFDBExplore = class(TForm)
    ListBox1:   TListBox;
    EdFind:     TEdit;
    Label1:     TLabel;
    BtnAdd:     TButton;
    BtnDel:     TButton;
    ListBox2:   TListBox;
    BtnRebuild: TButton;
    BtnBlankCount: TButton;
    GroupBox1:  TGroupBox;
    BtnAutoClean: TButton;
    Timer1:     TTimer;
    BtnCopyRcd: TButton;
    BtnCopyNew: TButton;
    CkLv1:      TCheckBox;
    CkLv7:      TCheckBox;
    CkLv14:     TCheckBox;

    procedure ListBox1Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnRebuildClick(Sender: TObject);
    procedure BtnBlankCountClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnAddFromFileClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnAutoCleanClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure BtnCopyRcdClick(Sender: TObject);
    procedure BtnCopyNewClick(Sender: TObject);
    procedure EdFindKeyPress(Sender: TObject; var Key: char);
    procedure FormDestroy(Sender: TObject);
  private
    //    nClearIndex:Integer; //0x324
    //    nClearCount:Integer;//0x328
    SList_320: TStringList;
    function ClearHumanItem(var ChrRecord: THumDataInfo): boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmFDBExplore: TFrmFDBExplore;

implementation

uses
  HumDB, newchr, UsrSoc, frmcpyrcd, DBSMain, DBShare;

{$R *.DFM}

procedure TFrmFDBExplore.EdFindKeyPress(Sender: TObject; var Key: char);
//0x004A55F4
var
  I: integer;
  sChrName: string;
begin
  if Key <> #13 then exit;
  sChrName := Trim(EdFind.Text);
  if sChrName = '' then exit;
  ListBox1.Clear;
  ListBox2.Clear;

  try
    if HumDataDB.Open then begin
      HumDataDB.Find(sChrName, ListBox1.Items);
      for I := 0 to ListBox1.Items.Count - 1 do begin
        ListBox2.Items.Add(IntToStr(integer(ListBox1.Items.Objects[i])));
      end;
    end;
  finally
    HumDataDB.Close;
  end;
end;

procedure TFrmFDBExplore.ListBox1Click(Sender: TObject);
//0x004A5790
begin
  ListBox2.ItemIndex := ListBox1.ItemIndex;
(*


***** TRY
|
004A57BB   64FF30                 push    dword ptr fs:[eax]
004A57BE   648920                 mov     fs:[eax], esp

* Reference to FrmFDBExplore
|
004A57C1   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TFrmFDBExplore.ListBox1 : TListBox
|
004A57C4   8B80D0020000           mov     eax, [eax+$02D0]

* Reference to: stdctrls.TCustomListBox.GetItemIndex(TCustomListBox):Integer;
|
004A57CA   E87966F8FF             call    0042BE48
004A57CF   8BD0                   mov     edx, eax

* Reference to FrmFDBExplore
|
004A57D1   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TFrmFDBExplore.ListBox2 : TListBox
|
004A57D4   8B80E8020000           mov     eax, [eax+$02E8]

* Reference to: stdctrls.TCustomListBox.SetItemIndex(TCustomListBox;Integer);
|
004A57DA   E8A566F8FF             call    0042BE84
004A57DF   C745F8FFFFFFFF         mov     dword ptr [ebp-$08], $FFFFFFFF

* Reference to pointer to GlobalVar_004ADBD4
|
004A57E6   A1F8C24A00             mov     eax, dword ptr [$004AC2F8]
004A57EB   8B00                   mov     eax, [eax]

* Reference to: Unit_0048A084.Proc_0048A304
|
004A57ED   E8124BFEFF             call    0048A304
004A57F2   84C0                   test    al, al
004A57F4   0F848A000000           jz      004A5884

* Reference to FrmFDBExplore
|
004A57FA   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TFrmFDBExplore.ListBox1 : TListBox
|
004A57FD   8B80D0020000           mov     eax, [eax+$02D0]

* Reference to: stdctrls.TCustomListBox.GetItemIndex(TCustomListBox):Integer;
|
004A5803   E84066F8FF             call    0042BE48
004A5808   8BD0                   mov     edx, eax
004A580A   8D8D90F3FFFF           lea     ecx, [ebp+$FFFFF390]

* Reference to FrmFDBExplore
|
004A5810   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TFrmFDBExplore.ListBox1 : TListBox
|
004A5813   8B80D0020000           mov     eax, [eax+$02D0]

* Reference to field TListBox.Items : TStrings
|
004A5819   8B80F0010000           mov     eax, [eax+$01F0]
004A581F   8B18                   mov     ebx, [eax]

* Reference to method TStrings.Strings  [ Index()
|
004A5821   FF530C                 call    dword ptr [ebx+$0C]
004A5824   8B9590F3FFFF           mov     edx, [ebp+$FFFFF390]

* Reference to pointer to GlobalVar_004ADBD4
|
004A582A   A1F8C24A00             mov     eax, dword ptr [$004AC2F8]
004A582F   8B00                   mov     eax, [eax]

* Reference to: Unit_0048A084.Proc_0048B534
|
004A5831   E8FE5CFEFF             call    0048B534
004A5836   8945F8                 mov     [ebp-$08], eax
004A5839   837DF800               cmp     dword ptr [ebp-$08], +$00
004A583D   7C39                   jl      004A5878
004A583F   8D8D94F3FFFF           lea     ecx, [ebp+$FFFFF394]

* Reference to pointer to GlobalVar_004ADBD4
|
004A5845   A1F8C24A00             mov     eax, dword ptr [$004AC2F8]
004A584A   8B00                   mov     eax, [eax]
004A584C   8B55F8                 mov     edx, [ebp-$08]

* Reference to: Unit_0048A084.Proc_0048B320
|
004A584F   E8CC5AFEFF             call    0048B320

* Reference to FrmFDBExplore
|
004A5854   8B45FC                 mov     eax, [ebp-$04]
004A5857   8DB5B0F3FFFF           lea     esi, [ebp+$FFFFF3B0]

* Reference to field TFrmFDBExplore.OFFS_032C
|
004A585D   8DB82C030000           lea     edi, [eax+$032C]
004A5863   B910030000             mov     ecx, $00000310
004A5868   F3                     rep
004A5869   A5                     movsd
004A586A   8D45F4                 lea     eax, [ebp-$0C]
004A586D   8D95A0F3FFFF           lea     edx, [ebp+$FFFFF3A0]

* Reference to: system.@LStrFromString(String;String;ShortString;ShortString);
|           or: system.@WStrFromString(WideString;WideString;ShortString;ShortString);
|
004A5873   E8ACE5F5FF             call    00403E24

* Reference to pointer to GlobalVar_004ADBD4
|
004A5878   A1F8C24A00             mov     eax, dword ptr [$004AC2F8]
004A587D   8B00                   mov     eax, [eax]

* Reference to: Unit_0048A084.Proc_0048A400
|
004A587F   E87C4BFEFF             call    0048A400

* Reference to TFrmFDBViewer instance
|
004A5884   A1ECBF4A00             mov     eax, dword ptr [$004ABFEC]
004A5889   8B00                   mov     eax, [eax]

* Reference to field TFrmFDBViewer.Visible : Boolean
|
004A588B   80784700               cmp     byte ptr [eax+$47], $00
004A588F   747D                   jz      004A590E
004A5891   837DF800               cmp     dword ptr [ebp-$08], +$00
004A5895   7C77                   jl      004A590E

* Reference to TFrmFDBViewer instance
|
004A5897   A1ECBF4A00             mov     eax, dword ptr [$004ABFEC]
004A589C   8B00                   mov     eax, [eax]
004A589E   8B55F8                 mov     edx, [ebp-$08]

* Reference to field TFrmFDBViewer.OFFS_02F8
|
004A58A1   8990F8020000           mov     [eax+$02F8], edx

* Reference to FrmFDBExplore
|
004A58A7   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TFrmFDBExplore.ListBox1 : TListBox
|
004A58AA   8B80D0020000           mov     eax, [eax+$02D0]

* Reference to: stdctrls.TCustomListBox.GetItemIndex(TCustomListBox):Integer;
|
004A58B0   E89365F8FF             call    0042BE48
004A58B5   8BD0                   mov     edx, eax
004A58B7   8D8D8CF3FFFF           lea     ecx, [ebp+$FFFFF38C]

* Reference to FrmFDBExplore
|
004A58BD   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TFrmFDBExplore.ListBox1 : TListBox
|
004A58C0   8B80D0020000           mov     eax, [eax+$02D0]

* Reference to field TListBox.Items : TStrings
|
004A58C6   8B80F0010000           mov     eax, [eax+$01F0]
004A58CC   8B18                   mov     ebx, [eax]

* Reference to method TStrings.Strings  [ Index()
|
004A58CE   FF530C                 call    dword ptr [ebx+$0C]
004A58D1   8B958CF3FFFF           mov     edx, [ebp+$FFFFF38C]

* Reference to TFrmFDBViewer instance
|
004A58D7   A1ECBF4A00             mov     eax, dword ptr [$004ABFEC]
004A58DC   8B00                   mov     eax, [eax]
004A58DE   05FC020000             add     eax, +$000002FC

* Reference to: system.@LStrAsg;
|
004A58E3   E86CE3F5FF             call    00403C54

* Reference to TFrmFDBViewer instance
|
004A58E8   A1ECBF4A00             mov     eax, dword ptr [$004ABFEC]
004A58ED   8B00                   mov     eax, [eax]

* Reference to field TFrmFDBViewer.OFFS_0300
|
004A58EF   8DB800030000           lea     edi, [eax+$0300]
004A58F5   8DB594F3FFFF           lea     esi, [ebp+$FFFFF394]
004A58FB   B917030000             mov     ecx, $00000317
004A5900   F3                     rep
004A5901   A5                     movsd

* Reference to TFrmFDBViewer instance
|
004A5902   A1ECBF4A00             mov     eax, dword ptr [$004ABFEC]
004A5907   8B00                   mov     eax, [eax]

* Reference to : TFrmFDBViewer._PROC_0049A054()
|
004A5909   E84647FFFF             call    0049A054
004A590E   33C0                   xor     eax, eax
004A5910   5A                     pop     edx
004A5911   59                     pop     ecx
004A5912   59                     pop     ecx
004A5913   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]Ë�U��Ĝ���VW�E����J'
|
004A5916   683B594A00             push    $004A593B
004A591B   8D858CF3FFFF           lea     eax, [ebp+$FFFFF38C]
004A5921   BA02000000             mov     edx, $00000002

* Reference to: system.@LStrArrayClr;
|
004A5926   E8F9E2F5FF             call    00403C24
004A592B   8D45F4                 lea     eax, [ebp-$0C]

* Reference to: system.@LStrClr(String;String);
|
004A592E   E8CDE2F5FF             call    00403C00
004A5933   C3                     ret


* Reference to: system.@HandleFinally;
|
004A5934   E9DBDCF5FF             jmp     00403614
004A5939   EBE0                   jmp     004A591B

****** END
|
004A593B   5F                     pop     edi
004A593C   5E                     pop     esi
004A593D   5B                     pop     ebx
004A593E   8BE5                   mov     esp, ebp
004A5940   5D                     pop     ebp
004A5941   C3                     ret

*)
end;

procedure TFrmFDBExplore.BtnDelClick(Sender: TObject);
//0x004A5A44
var
  nIndex: integer;
begin
  if ListBox1.ItemIndex <= -1 then exit;
  nIndex := integer(ListBox1.Items.Objects[ListBox1.ItemIndex]);
  if MessageDlg('�Ƿ�ȷ��ɾ���������� ' + IntToStr(nIndex) + ' ��',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    try
      if HumDataDB.Open then begin
        HumDataDB.Delete(nIndex);
      end;
    finally
      HumChrDB.Close;
    end;
  end;
end;

procedure TFrmFDBExplore.BtnRebuildClick(Sender: TObject);//0x004A5B64
begin
  if MessageDlg('���ؽ����ݿ�����У����ݿ��������ֹͣ�������Ƿ�ȷ�ϼ�����',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin
    boAutoClearDB := False;
    HumDataDB.Rebuild();
    MessageDlg('���ݿ��ؽ���ɣ�����', mtInformation, [mbOK], 0);
  end;
end;

procedure TFrmFDBExplore.BtnBlankCountClick(Sender: TObject);
//0x004A5C40
begin
  ListBox1.Clear;
  ListBox2.Clear;
end;

procedure TFrmFDBExplore.BtnAddClick(Sender: TObject);
var
  sChrName: string;
begin
  FrmNewChr.sub_49BD60(sChrName);
//  FrmUserSoc.NewChrData(sChrName, 0, 0, 0);  //Damian
end;

procedure TFrmFDBExplore.BtnAddFromFileClick(Sender: TObject);
begin
(*
004A5D30   55                     push    ebp
004A5D31   8BEC                   mov     ebp, esp
004A5D33   83C4F8                 add     esp, -$08
004A5D36   8955F8                 mov     [ebp-$08], edx
004A5D39   8945FC                 mov     [ebp-$04], eax
004A5D3C   59                     pop     ecx
004A5D3D   59                     pop     ecx
004A5D3E   5D                     pop     ebp
004A5D3F   C3                     ret

*)
end;

procedure TFrmFDBExplore.FormCreate(Sender: TObject);
//0x004A55B8
begin
  Timer1.Interval := dwInterval;
  Timer1.Enabled := True;
  SList_320     := TStringList.Create;
  g_nClearIndex := 0;
  g_nClearCount := 0;
  g_nClearItemIndexCount := 0;
end;

procedure TFrmFDBExplore.BtnAutoCleanClick(Sender: TObject);
//0x004A5D40
begin
  boAutoClearDB := not boAutoClearDB;
  if boAutoClearDB then BtnAutoClean.Caption := 'Cleaning On'
  else
    BtnAutoClean.Caption := 'Cleaning Off';
end;

procedure TFrmFDBExplore.Timer1Timer(Sender: TObject);
//0x004A5EDC
  function GetDateTime(wM, wD: word): TDateTime;
  var
    Year, Month, Day: word;
    i: integer;
  begin
    DecodeDate(Now, Year, Month, Day);
    for I := 0 to wM - 1 do begin
      if Month > 1 then Dec(Month)
      else begin
        Month := 12;
        Dec(Year);
      end;
    end;
    for I := 0 to wD - 1 do begin
      if Day > 1 then Dec(Day)
      else begin
        Day := 28;
        if Month > 1 then Dec(Month)
        else begin
          Month := 12;
          Dec(Year);
        end;
      end;
    end;
    Result := EncodeDate(Year, Month, Day);
  end;

var
  w32, wDayCount1, wLevel1, w38, wDayCount7, wLevel7, w3E, wDayCount14, wLevel14: word;
  dt20, dt28, dt30: TDateTime;
  n8, n10: integer;

  sHumName:  string;
  ChrRecord: THumDataInfo;
begin
  if not boAutoClearDB then exit;
  w32      := 0;
  w38      := 0;
  w3E      := 0;
  wDayCount1 := 0;
  wDayCount7 := 0;
  wDayCount14 := 0;
  wLevel1  := 0;
  wLevel7  := 0;
  wLevel14 := 0;
  if CkLv1.Checked then begin
    w32     := nMonth1;
    wDayCount1 := nDay1;
    wLevel1 := nLevel1;
  end;
  if CkLv7.Checked then begin
    w38     := nMonth2;
    wDayCount7 := nDay2;
    wLevel7 := nLevel2;
  end;
  if CkLv14.Checked then begin
    w3E      := nMonth3;
    wDayCount14 := nDay3;
    wLevel14 := nLevel3;
  end;
  dt20     := GetDateTime(w32, wDayCount1);
  dt28     := GetDateTime(w38, wDayCount7);
  dt30     := GetDateTime(w3E, wDayCount14);
  g_nClearRecordCount := 0;
  sHumName := '';
  try
    if HumDataDB.Open then begin
      g_nClearRecordCount := HumDataDB.Count;
      if g_nClearIndex < g_nClearRecordCount then begin
        n8 := HumDataDB.Get(g_nClearIndex, ChrRecord);
        if n8 >= 0 then begin
          if ((ChrRecord.Header.CreateDate < dt20) and
            (ChrRecord.Data.Abil.Level <= wLevel1)) or
            ((ChrRecord.Header.CreateDate < dt28) and
            (ChrRecord.Data.Abil.Level <= wLevel7)) or
            ((ChrRecord.Header.CreateDate < dt30) and
            (ChrRecord.Data.Abil.Level <= wLevel14)) then begin
            n10      := n8;
            sHumName := ChrRecord.Header.sChrName;
            HumDataDB.Delete(n10);
            Inc(g_nClearCount);
          end else begin
            if ClearHumanItem(ChrRecord) then begin
              HumDataDB.Update(g_nClearIndex, ChrRecord);
            end;
          end;
          Inc(g_nClearIndex);
        end;
      end else
        g_nClearIndex := 0;
    end;
  finally
    HumDataDB.Close;
  end;
  if sHumName <> '' then begin
    FrmDBSrv.DelHum(sHumName);
  end;
  //  FrmDBSrv.LbAutoClean.Caption:=IntToStr(g_nClearIndex) + '/' + IntToStr(g_nClearCount) + '/' + IntToStr(g_nClearRecordCount);
end;

function TFrmFDBExplore.ClearHumanItem(var ChrRecord: THumDataInfo): boolean;
var
  I:    integer;
  HumItems: pTHumItems;
  UserItem: pTUserItem;
  Item: pTUserItem;
  SaveList: TStringList;
  ClearList: TList;
  sFileName: string;
  sMsg: string;
begin
  Result    := False;
  ClearList := nil;

  HumItems := @ChrRecord.Data.HumItems;
  for I := Low(THumItems) to high(THumItems) do begin
    UserItem := @HumItems[I];
    if UserItem.wIndex <= 0 then Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then ClearList := TList.Create;
      New(Item);
      Item^ := UserItem^;
      ClearList.Add(Item);
      UserItem.wIndex := 0;
      Result := True;
    end;
  end;
  for I := Low(TBagItems) to high(TBagItems) do begin
    UserItem := @ChrRecord.Data.BagItems[I];
    if UserItem.wIndex <= 0 then Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then ClearList := TList.Create;
      New(Item);
      Item^ := UserItem^;
      ClearList.Add(Item);
      UserItem.wIndex := 0;
      Result := True;
    end;
  end;
  for I := Low(TStorageItems) to high(TStorageItems) do begin
    UserItem := @ChrRecord.Data.StorageItems[I];
    if UserItem.wIndex <= 0 then Continue;
    if InClearMakeIndexList(UserItem.MakeIndex) then begin
      if ClearList = nil then ClearList := TList.Create;
      New(Item);
      Item^ := UserItem^;
      ClearList.Add(Item);

      UserItem.wIndex := 0;
      Result := True;
    end;
  end;
  if Result then begin
    Inc(g_nClearItemIndexCount, ClearList.Count);

    SaveList  := TStringList.Create;
    sFileName := 'ClearItemLog.txt';
    if FileExists(sFileName) then begin
      SaveList.LoadFromFile(sFileName);
    end;
    for I := 0 to ClearList.Count - 1 do begin
      UserItem := ClearList.Items[I];
      sMsg     := ChrRecord.Data.sChrName + #9 + IntToStr(UserItem.wIndex) +
        #9 + IntToStr(UserItem.MakeIndex);
      SaveList.Insert(0, sMsg);
      Dispose(UserItem);
    end;
    SaveList.SaveToFile(sFileName);
    SaveList.Free;
  end;
  if ClearList <> nil then ClearList.Free;
end;

procedure TFrmFDBExplore.BtnCopyRcdClick(Sender: TObject);
//0x004A6220
var
  sSrcChrName, sDestChrName, sUserID: string;
begin
  if not FrmCopyRcd.sub_49C09C then exit;
  sSrcChrName  := FrmCopyRcd.sSrcCharName;
  sDestChrName := FrmCopyRcd.sDestCharName;
  sUserID      := FrmCopyRcd.sUserID;
  if FrmDBSrv.CopyHumData(sSrcChrName, sDestChrName, sUserID) then
    ShowMessage(sSrcChrName + ' -> ' + sDestChrName + ' ���Ƴɹ�������');
end;

procedure TFrmFDBExplore.BtnCopyNewClick(Sender: TObject);
//0x004A631C
var
  sSrcChrName, sDestChrName, sUserID: string;
begin
  if not FrmCopyRcd.sub_49C09C then exit;
  sSrcChrName  := FrmCopyRcd.sSrcCharName;
  sDestChrName := FrmCopyRcd.sDestCharName;
  sUserID      := FrmCopyRcd.sUserID;
  if FrmUserSoc.NewChrData(sUserID, sDestChrName, 0, 0, 0) and
    FrmDBSrv.CopyHumData(sSrcChrName, sDestChrName, sUserID) then
    ShowMessage(sSrcChrName + ' -> ' + sDestChrName + ' ���Ƴɹ�������');
end;


procedure TFrmFDBExplore.FormDestroy(Sender: TObject);
begin
  SList_320.Free;
end;

end.
