unit AddrEdit;

interface

uses
  svn, Windows, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, Spin, Buttons, ExtCtrls, Grids;
type
  TFrmEditAddr=class(TForm)
    AddrGrid: TStringGrid;
    Panel1: TPanel;
    BtnApplyAndClose: TButton;
    ERowCount: TSpinEdit;
    Label1: TLabel;
    BtnApplyRow: TSpeedButton;
    procedure FormCreate(Sender : TObject);
    procedure BtnApplyRowClick(Sender : TObject);
    procedure BtnApplyAndCloseClick(Sender : TObject);
    procedure Open();
  private
    procedure sub_4A6864();
    { Private declarations }
  public
    { Public declarations }
  end ;

var
  FrmEditAddr: TFrmEditAddr;

{This file is generated by DeDe Ver 3.50.02 Copyright (c) 1999-2002 DaFixer}

implementation

uses HUtil32, DBShare;

{$R *.DFM}

procedure TFrmEditAddr.FormCreate(Sender : TObject);
begin
  ERowCount.Value:=8;
  AddrGrid.Cells[0,0]:='Server Address';
  AddrGrid.Cells[1,0]:='Gate Address';
  AddrGrid.Cells[2,0]:='Port';
  AddrGrid.Cells[3,0]:='Gate Address';
  AddrGrid.Cells[4,0]:='Port';
  AddrGrid.Cells[5,0]:='Gate Address';
  AddrGrid.Cells[6,0]:='Port';
  AddrGrid.Cells[7,0]:='Gate Address';
  AddrGrid.Cells[8,0]:='Port';
end;

procedure TFrmEditAddr.BtnApplyRowClick(Sender : TObject);
begin
  if ERowCount.Value < 1 then ERowCount.Value:=1;
  AddrGrid.RowCount:=ERowCount.Value + 1;
end;

procedure TFrmEditAddr.BtnApplyAndCloseClick(Sender : TObject);
var
  I,II: Integer;
  SaveList:TStringList;
  s14:String;
begin
  SaveList:=TStringList.Create;
  for I := 1 to AddrGrid.RowCount - 1 do begin
    s14:=Trim(AddrGrid.Cells[0,i]);
    if s14 <> '' then begin
      s14:= s14 + ' ';
      for II := 1 to AddrGrid.ColCount - 1 do begin
        s14:=s14 + Trim(AddrGrid.Cells[ii,i]) + ' ';
      end;
    end;
    SaveList.Add(s14);
  end;
  try
    SaveList.SaveToFile(sGateConfFileName);
  except
    ShowMessage(sGateConfFileName + ' has failed to save!');
  end;
  Self.Close;
end;

procedure TFrmEditAddr.sub_4A6864();
var
  i,ii:Integer;
begin
  for i := 1 to AddrGrid.RowCount - 1 do begin
    for ii := 0 to AddrGrid.ColCount - 1 do begin
      AddrGrid.Cells[ii,i]:='';
    end;
  end;
end;

procedure TFrmEditAddr.Open();
var
  LoadList:TStringList;
  i,n18,n1C:Integer;
  sStr:String;
  sStr1:String;
begin
  sub_4A6864();
  LoadList:=TStringList.Create;
  try
    LoadList.LoadFromFile(sGateConfFileName);
  except
    ShowMessage(sGateConfFileName + ' has failed to load!');
  end;
  n1C:=1;
  for I := 0 to LoadList.Count - 1 do begin
    sStr:=Trim(LoadList.Strings[i]);
    if (sStr <> '') and (sStr[1] <> ';') then begin
      sStr:=GetValidStr3(sStr,sStr1,[#32,#9]);
      AddrGrid.Cells[0,n1C]:=sStr1;
      n18:=0;
      while (true) do begin
        if sStr <> '' then begin
          sStr:=GetValidStr3(sStr,sStr1,[#32,#9]);
          AddrGrid.Cells[n18 * 2 +1,n1C]:=sStr1;
          sStr:=GetValidStr3(sStr,sStr1,[#32,#9]);
          AddrGrid.Cells[n18 * 2 +2,n1C]:=sStr1;
          Inc(n18);
          if n18 <=4 then Continue;
        end;
        Inc(n1C);
        if AddrGrid.RowCount <= n1C then
          AddrGrid.RowCount:=AddrGrid.RowCount + 1;
        break;
      end;
    end;
  end;
  LoadList.Free;
  Self.ShowModal;
(*


* Reference to FrmEditAddr
|
004A6A82   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TFrmEditAddr.AddrGrid : TStringGrid
|
004A6A85   8B80D0020000           mov     eax, [eax+$02D0]

* Reference to field TStringGrid.RowCount : Longint
|
004A6A8B   8B8034020000           mov     eax, [eax+$0234]
004A6A91   3B45E4                 cmp     eax, [ebp-$1C]
004A6A94   7F12                   jnle    004A6AA8
004A6A96   8B55E4                 mov     edx, [ebp-$1C]
004A6A99   42                     inc     edx

* Reference to FrmEditAddr
|
004A6A9A   8B45FC                 mov     eax, [ebp-$04]

* Reference to control TFrmEditAddr.AddrGrid : TStringGrid
|
004A6A9D   8B80D0020000           mov     eax, [eax+$02D0]

* Reference to: grids.TCustomGrid.SetRowCount(TCustomGrid;Longint);
|
004A6AA3   E850E6FEFF             call    004950F8
004A6AA8   FF45EC                 inc     dword ptr [ebp-$14]
004A6AAB   FF4DE0                 dec     dword ptr [ebp-$20]
004A6AAE   0F85BCFEFFFF           jnz     004A6970
004A6AB4   8B45F8                 mov     eax, [ebp-$08]

* Reference to: system.TObject.Free(TObject);
|
004A6AB7   E8F8C3F5FF             call    00402EB4

* Reference to FrmEditAddr
|
004A6ABC   A1C8DB4A00             mov     eax, dword ptr [$004ADBC8]

* Reference to: forms.TCustomForm.Show(TCustomForm);
|
004A6AC1   E8B662FAFF             call    0044CD7C
004A6AC6   33C0                   xor     eax, eax
004A6AC8   5A                     pop     edx
004A6AC9   59                     pop     ecx
004A6ACA   59                     pop     ecx
004A6ACB   648910                 mov     fs:[eax], edx

****** FINALLY
|

* Possible String Reference to: '_^[��]�'
|
004A6ACE   68026B4A00             push    $004A6B02
004A6AD3   8D45CC                 lea     eax, [ebp-$34]
004A6AD6   BA02000000             mov     edx, $00000002

* Reference to: system.@LStrArrayClr;
|
004A6ADB   E844D1F5FF             call    00403C24
004A6AE0   8D45D8                 lea     eax, [ebp-$28]
004A6AE3   BA02000000             mov     edx, $00000002

* Reference to: system.@LStrArrayClr;
|
004A6AE8   E837D1F5FF             call    00403C24
004A6AED   8D45F0                 lea     eax, [ebp-$10]
004A6AF0   BA02000000             mov     edx, $00000002

* Reference to: system.@LStrArrayClr;
|
004A6AF5   E82AD1F5FF             call    00403C24
004A6AFA   C3                     ret


* Reference to: system.@HandleFinally;
|
004A6AFB   E914CBF5FF             jmp     00403614
004A6B00   EBD1                   jmp     004A6AD3

****** END
|
004A6B02   5F                     pop     edi
004A6B03   5E                     pop     esi
004A6B04   5B                     pop     ebx
004A6B05   8BE5                   mov     esp, ebp
004A6B07   5D                     pop     ebp
004A6B08   C3                     ret

*)
end;

{---- Adjust global SVN revision ----}
initialization
  SVNRevision('$Id: AddrEdit.pas 121 2006-08-06 01:10:41Z Dataforce $');
end.
