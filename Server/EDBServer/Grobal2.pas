unit Grobal2;

interface
uses
  Windows;
const
  DEFBLOCKSIZE = 16;
  BUFFERSIZE = 10000;

  GS_QUIT = 2000;
  GS_USERACCOUNT = 1111;
  GS_CHANGEACCOUNTINFO = 1112;

  SG_USERACCOUNT = 1113;
  SG_USERACCOUNTNOTFOUND = 114;
  SG_USERACCOUNTCHANGESTATUS = 115;

  {UNKNOWMSG =1050;

  SS_OPENSESSION = 1000;
  SS_CLOSESESSION = 1010;
  SS_SOFTOUTSESSION =1020;
  SS_SERVERINFO =1030;
  SS_KEEPALIVE =1040;

  SS_KICKUSER = 1110;
  SS_SERVERLOAD =1130;

  SG_CHECKCODEADDR =1006;

  DBR_FAIL=1;

  DB_LOADHUMANRCD = 1000;
  DB_SAVEHUMANRCD =1010;
  DB_SAVEHUMANRCDEX =1020;

  DBR_LOADHUMANRCD = 1100;
  DBR_SAVEHUMANRCD =1101; }


  CM_QUERYCHR = 100;
  CM_NEWCHR = 101;
  CM_DELCHR = 102;
  CM_SELCHR = 103;
  CM_SELECTSERVER = 104;

  SM_QUERYCHR = 520;
  SM_NEWCHR_SUCCESS = 521;
  SM_NEWCHR_FAIL = 522;
  SM_DELCHR_SUCCESS = 523;
  SM_DELCHR_FAIL = 524;
  SM_STARTPLAY = 525;
  SM_STARTFAIL = 526; //SM_USERFULL
  SM_QUERYCHR_FAIL = 527;
  SM_OUTOFCONNECTION = 528; //?
type
  TDefaultMessage = record
    Recog: Integer;
    Ident: Word;
    Param: Word;
    Tag: Word;
    Series: Word;
  end;

  TGlobaSessionInfo = record
    sAccount: string;
    sIPaddr: string;
    nSessionID: Integer;
    n24: Integer;
    boLoadRcd: Boolean;
    boStartPlay: Boolean;
    dwAddTick: LongWord;
    dAddDate: TDateTime;
  end;
  pTGlobaSessionInfo = ^TGlobaSessionInfo;

  TChrMsg = record
    Ident: Integer;
    X: Integer;
    Y: Integer;
    Dir: Integer;
    State: Integer;
    feature: Integer;
    saying: string;
    sound: Integer;
  end;
  PTChrMsg = ^TChrMsg;
  TStdItem = record //OK
    Name: string[14];
    StdMode: Byte; //0x0F
    Shape: Byte; //0x10
    Weight: Byte; //0x11
    AniCount: Byte; //0x12
    Source: ShortInt; //0x13
    Reserved: Byte; //0x14
    NeedIdentify: Byte; //0x15
    Looks: Word; //0x16
    DuraMax: Word; //0x18
    AC: Integer; //0x1A
    MAC: Integer; //0x1C
    DC: Integer; //0x1E
    MC: Integer; //0x20
    SC: Integer; //0x22
    Need: Integer; //0x24
    NeedLevel: Integer; //0x25
    Price: Integer; //0x28
  end;
  pTStdItem = ^TStdItem;
  TMagicInfo = record
    wMagicId: Word;
    sMagicName: string[12];
    btEffectType: Byte;
    btEffect: Byte;
    wSpell: Word;
    wPower: Word;
    TrainLevel: array[0..3] of Byte;
    MaxTrain: array[0..3] of Integer;
    btTrainLv: Byte;
    btJob: Byte;
    dwDelayTime: Integer;
    btDefSpell: Byte;
    btDefPower: Byte;
    wMaxPower: Byte;
    btDefMaxPower: Word;
    sDescr: string[14];
  end;
  pTMagicInfo = ^TMagicInfo;

  TClientItem = record //OK
    S: TStdItem;
    MakeIndex: Integer;
    Dura: Word;
    DuraMax: Word;
  end;
  PTClientItem = ^TClientItem;
  TUserStateInfo = record //OK
    feature: Integer;
    Username: string[19];
    GuildName: string[14];
    GuildRankName: string[14];
    NameColor: Word;
    UseItems: array[0..8] of TClientItem;
  end;
  TUserCharacterInfo = record
    Name: string[19];
    Job: Byte;
    Hair: Byte;
    Level: Byte;
    m_btSex: Byte;
  end;
  TUserEntry = packed record
    sAccount: string[10];
    sPassword: string[10];
    sUsername: string[20];
    sSSNo: string[14];
    sPhone: string[14];
    sQuiz: string[20];
    sAnswer: string[12];
    sEMail: string[40];
  end;
  TUserEntryAdd = packed record
    sQuiz2: string[20];
    sAnswer2: string[12];
    sBirthDay: string[10];
    sMobilePhone: string[13];
    sMemo: string[20];
    sMemo2: string[20];
  end;

  TUserItem = record
    wIndex: Word;
    MakeIndex: LongWord;
    Dura: Word;
    DuraMax: Word;
    btValue: array[0..13] of Byte;
  end;
  pTUserItem = ^TUserItem;

  TDropItem = record
    X: Integer;
    Y: Integer;
    Id: Integer;
    Looks: Integer;
    Name: string;
    FlashTime: DWORD;
    FlashStepTime: DWORD;
    FlashStep: Integer;
    BoFlash: Boolean;
  end;
  PTDropItem = ^TDropItem;

  TMagic = record //+
    MagicId: Word;
    MagicName: string[12];
    EffectType: Byte;
    Effect: Byte;
    xx: Byte;
    Spell: Word;
    DefSpell: Word;
    TrainLevel: array[0..2] of Byte;
    TrainLeveX: array[0..2] of Byte;
    MaxTrain: array[0..2] of Integer;
    DelayTime: Integer;
  end;

  TClientMagic = record //84
    Key: Char;
    Level: Byte;
    CurTrain: Integer;
    Def: TMagic;
  end;
  PTClientMagic = ^TClientMagic;

  TNakedAbility = record
    DC: Word;
    MC: Word;
    SC: Word;
    AC: Word;
    MAC: Word;
    HP: Word;
    MP: Word;
    Hit: Byte;
    Speed: Integer;
  end;

  TAbility = record //OK    //Size 40
    Level: Word; //0x198
    AC: Word; //0x19A
    MAC: Word; //0x19C
    DC: Word; //0x19E
    MC: Word; //0x1A0
    SC: Word; //0x1A2
    HP: Word; //0x1A4
    MP: Word; //0x1A6
    MaxHP: Word; //0x1A8
    MaxMP: Word; //0x1AA
    dw1AC: DWORD; //0x1AC
    Exp: DWORD; //0x1B0
    MaxExp: DWORD; //0x1B4
    Weight: Word; //0x1B8
    MaxWeight: Word; //0x1BA
    WearWeight: Byte; //0x1BC
    MaxWearWeight: Byte; //0x1BD
    HandWeight: Byte; //0x1BE
    MaxHandWeight: Byte; //0x1BF
  end;

  TShortMessage = record
    Ident: Word;
    wMsg: Word;
  end;

  TMessageBodyW = record
    Param1: Word;
    Param2: Word;
    Tag1: Word;
    Tag2: Word;
  end;

  TMessageBodyWL = record //16  0x10
    lParam1: Integer;
    lParam2: Integer;
    lTag1: Integer;
    lTag2: Integer;
  end;

  TCharDesc = record
    feature: Integer;
    Status: Integer;
  end;
  TClientGoods = record
    Name: string;
    SubMenu: Integer;
    Price: Integer;
    Stock: Integer;
    Grade: Integer;
  end;
  pTClientGoods = ^TClientGoods;
  //ResourceString
function APPRfeature(cfeature: Integer): Word;
function RACEfeature(cfeature: Integer): Byte;
function HAIRfeature(cfeature: Integer): Byte;
function DRESSfeature(cfeature: Integer): Byte;
function WEAPONfeature(cfeature: Integer): Byte;
implementation

function WEAPONfeature(cfeature: Integer): Byte;
begin
  Result := HiByte(cfeature);
end;
function DRESSfeature(cfeature: Integer): Byte;
begin
  Result := HiByte(HiWord(cfeature));
end;
function APPRfeature(cfeature: Integer): Word;
begin
  Result := HiWord(cfeature);
end;
function HAIRfeature(cfeature: Integer): Byte;
begin
  Result := HiWord(cfeature);
end;
function RACEfeature(cfeature: Integer): Byte;
begin
  Result := cfeature;
end;

end.
