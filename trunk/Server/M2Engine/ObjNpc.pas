unit ObjNpc;

interface
uses
  Windows, Classes, SysUtils, StrUtils, ObjBase, Grobal2, SDK, IniFiles;
type
  TUpgradeInfo = record //0x40
    sUserName: string[14]; //0x00
    UserItem: TUserItem; //0x10
    btDc: Byte; //0x28
    btSc: Byte; //0x29
    btMc: Byte; //0x2A
    btDura: Byte; //0x2B
    n2C: Integer;
    dtTime: TDateTime; //0x30
    dwGetBackTick: LongWord; //0x38
    n3C: Integer;
  end;
  pTUpgradeInfo = ^TUpgradeInfo;
  TItemPrice = record
    wIndex: Word;
    nPrice: Integer;
  end;
  pTItemPrice = ^TItemPrice;
  TGoods = record //0x1C
    sItemName: string[14];
    nCount: Integer;
    dwRefillTime: LongWord;
    dwRefillTick: LongWord;
  end;
  pTGoods = ^TGoods;

  TSellItemPrice = record
    wIndex: Word;
    nPrice: Integer;
  end;
  pTSellItemPrice = ^TSellItemPrice;

  TQuestActionInfo = record //0x1C
    nCMDCode: Integer; //0x00
    sParam1: string; //0x04
    nParam1: Integer; //0x08
    sParam2: string; //0x0C
    nParam2: Integer; //0x10
    sParam3: string; //0x14
    nParam3: Integer; //0x18
    sParam4: string;
    nParam4: Integer;
    sParam5: string;
    nParam5: Integer;
    sParam6: string;
    nParam6: Integer;
  end;
  pTQuestActionInfo = ^TQuestActionInfo;
  TQuestConditionInfo = record //0x14
    nCMDCode: Integer; //0x00
    sParam1: string; //0x04
    nParam1: Integer; //0x08
    sParam2: string; //0x0C
    nParam2: Integer; //0x10
    sParam3: string;
    nParam3: Integer;
    sParam4: string;
    nParam4: Integer;
    sParam5: string;
    nParam5: Integer;
    sParam6: string;
    nParam6: Integer;
  end;
  pTQuestConditionInfo = ^TQuestConditionInfo;
  TSayingProcedure = record //0x14
    ConditionList: TList; //0x00
    ActionList: TList; //0x04
    sSayMsg: string; //0x08
    ElseActionList: TList; //0x0C
    sElseSayMsg: string; //0x10
  end;
  pTSayingProcedure = ^TSayingProcedure;
  TSayingRecord = record //0x08
    sLabel: string;
    ProcedureList: TList; //0x04
    boExtJmp: Boolean; //�Ƿ������ⲿ��ת
  end;
  pTSayingRecord = ^TSayingRecord;
  TNormNpc = class(TAnimalObject) //0x564
    n54C: Integer; //0x54C
    m_nFlag: ShortInt; //0x550 //���ڱ�ʶ��NPC�Ƿ���Ч���������¼���NPC�б�(-1 Ϊ��Ч)
    m_ScriptList: TList; //0x554
    m_sFilePath: string; //0x558 �ű��ļ�����Ŀ¼
    m_boIsHide: Boolean; //0x55C ��NPC�Ƿ������صģ�����ʾ�ڵ�ͼ��
    m_boIsQuest: Boolean; //0x55D NPC����Ϊ��ͼ�����͵ģ����ؽű�ʱ�Ľű��ļ���Ϊ ��ɫ��-��ͼ��.txt
    m_sPath: string; //0x560
    m_boNpcAutoChangeColor: Boolean;
    m_dwNpcAutoChangeColorTick: LongWord;
    m_dwNpcAutoChangeColorTime: LongWord;
    m_nNpcAutoChangeIdx: Integer;

  private
    procedure ScriptActionError(PlayObject: TPlayObject; sErrMsg: string; QuestActionInfo: pTQuestActionInfo; sCmd: string);
    procedure ScriptConditionError(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo; sCmd: string);

    procedure ExeAction(PlayObject: TPlayObject; sParam1, sParam2, sParam3: string; nParam1, nParam2, nParam3: Integer);
    procedure ActionOfChangeLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUnMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUnMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGiveItem(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfGetMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGetMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelNoJobSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAddSkill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSkillLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangePkPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeCreditPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeJob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRecallGroupMembers(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearNameList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMapTing(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMobPlace(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nX, nY, nCount, nRange: Integer);
    procedure ActionOfSetMemberType(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetMemberLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGamePoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAutoAddGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
    procedure ActionOfAutoSubGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
    procedure ActionOfChangeHairStyle(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfLineMsg(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeNameColor(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearPassword(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfReNewLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeGender(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKillSlave(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKillMonExpRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfPowerRate(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangeMode(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfChangePerMission(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKill(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKick(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfBonusPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRestReNewLevel(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelMarry(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelMaster(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearNeedItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearMakeItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUpgradeItems(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUpgradeItemsEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMonGenEx(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfClearMapMon(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfSetMapMode(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfPkZone(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRestBonusPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfTakeCastleGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfHumanHP(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfHumanMP(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildBuildPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildAuraePoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildstabilityPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildFlourishPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfOpenMagicBox(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetRankLevelName(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGmExecute(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfGuildChiefItemCount(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAddNameDateList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDelNameDateList(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMobFireBurn(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfMessageBox(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSetScriptFlag(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfAutoGetExp(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfRecallmob(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfLoadVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfSaveVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfCalcVar(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);

    procedure ActionOfNotLineAddPiont(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfKickNotLineAddPiont(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);


    procedure ActionOfCommendGameGold(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfStartTakeGold(PlayObject: TPlayObject);

    procedure ActionOfAnsiReplaceText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfEncodeText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfDecodeText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
    procedure ActionOfUseBonusPoint(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);


    function ConditionOfCheckGroupCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseDir(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseGender(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseMarry(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckLevelEx(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSlaveCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckBonusPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckAccountIPList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNameIPList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMarry(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMarryCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfHaveMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfPoseHaveMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckIsMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPoseIsMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckHaveGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsGuildMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsCastleaGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsCastleMaster(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMemberType(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMemBerLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGameGold(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGamePoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNameListPostion(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGuildList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckReNewLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSlaveLevel(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSlaveName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;


    function ConditionOfCheckCreditPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckOfGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPayMent(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckUseItem(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckBagSize(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckListCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckDC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSC(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckHP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMP(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckItemType(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckExp(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleGold(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckPasswordErrorCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfIsLockPassword(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfIsLockStorage(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGuildBuildPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckGuildAuraePoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckStabilityPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckFlourishPoint(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckContribution(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckRangeMonCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckItemAddValue(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckInMapRange(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsAttackGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsDefenseGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleDoorStatus(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsAttackAllyGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckIsDefenseAllyGuild(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleChageDay(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckCastleWarDay(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckOnlineLongMin(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckChiefItemCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckNameDateList(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMapHumanCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckMapMonCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckVar(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckServerName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function ConditionOfCheckMapName(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSafeZone(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCheckSkill(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;

    function GetDynamicVarList(PlayObject: TPlayObject; sType: string; var sName: string): TList;

    function ConditionOfGetValValue(PlayObject: TPlayObject; sMsg: string; var sValue: string): Boolean; overload;
    function ConditionOfGetValValue(PlayObject: TPlayObject; sMsg: string; var nValue: Integer): Boolean; overload;

    function ConditionOfAnsiContainsText(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
    function ConditionOfCompareText(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;


    function ConditionOfCheckMonMapCount(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Initialize(); override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
    procedure Click(PlayObject: TPlayObject); virtual;
    procedure UserSelect(PlayObject: TPlayObject; sData: string); virtual;
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); virtual; //FFE9
    function GetLineVariableText(PlayObject: TPlayObject; sMsg: string): string;
    procedure GotoLable(PlayObject: TPlayObject; sLabel: string; boExtJmp: Boolean);
    function sub_49ADB8(sMsg, sStr, sText: string): string;
    procedure LoadNpcScript();
    procedure ClearScript(); virtual;
    procedure SendMsgToUser(PlayObject: TPlayObject; sMsg: string);
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); virtual;
  end;
  TMerchant = class(TNormNpc) //0x594
    m_sScript: string; //0x568
    n56C: Integer;
    m_nPriceRate: Integer; //0x570   ��Ʒ�۸��� Ĭ��Ϊ 100%
    bo574: Boolean;
    m_boCastle: Boolean; //0x575
    dwRefillGoodsTick: LongWord; //0x578
    dwClearExpreUpgradeTick: LongWord; //0x57C
    m_ItemTypeList: TList; //0x580  NPC������Ʒ�����б��ű���ǰ��� +1 +30 ֮���
    m_RefillGoodsList: TList; //0x584
    m_GoodsList: TList; //0x588
    m_ItemPriceList: TList; //0x58C

    m_UpgradeWeaponList: TList;
    m_boCanMove: Boolean;
    m_dwMoveTime: LongWord;
    m_dwMoveTick: LongWord;
    m_boBuy: Boolean;
    m_boSell: Boolean;
    m_boMakeDrug: Boolean;
    m_boPrices: Boolean;
    m_boStorage: Boolean;
    m_boGetback: Boolean;
    m_boBigStorage: Boolean;
    m_boBigGetback: Boolean;

    m_boGetNextPage: Boolean;
    m_boGetPreviousPage: Boolean;

    m_boUpgradenow: Boolean;
    m_boGetBackupgnow: Boolean;
    m_boRepair: Boolean;
    m_boS_repair: Boolean;
    m_boSendmsg: Boolean;
    m_boGetMarry: Boolean;
    m_boGetMaster: Boolean;
    m_boUseItemName: Boolean;

    m_boGetSellGold: Boolean;
    m_boSellOff: Boolean;
    m_boBuyOff: Boolean;
    m_boofflinemsg: Boolean;
    m_boDealGold: Boolean;
  private
    procedure ClearExpreUpgradeListData();

    function GetRefillList(nIndex: Integer): TList;
    procedure AddItemPrice(nIndex, nPrice: Integer);

    function GetSellItemPrice(nPrice: Integer): Integer;
    function AddItemToGoodsList(UserItem: pTUserItem): Boolean;
    procedure GetBackupgWeapon(User: TPlayObject);
    procedure UpgradeWapon(User: TPlayObject);
    procedure ChangeUseItemName(PlayObject: TPlayObject; sLabel, sItemName: string);
    procedure SaveUpgradingList;
    procedure GetMarry(PlayObject: TPlayObject; sDearName: string);
    procedure GetMaster(PlayObject: TPlayObject; sMasterName: string);

  public
    constructor Create(); override;
    destructor Destroy; override;
    function GetItemPrice(nIndex: Integer): Integer;
    function GetUserPrice(PlayObject: TPlayObject; nPrice: Integer): Integer;
    function CheckItemType(nStdMode: Integer): Boolean;
    procedure CheckItemPrice(nIndex: Integer);
    function GetUserItemPrice(UserItem: pTUserItem): Integer;


    function Operate(ProcessMsg: pTProcessMessage): Boolean; override;
    procedure Run; override;
    procedure UserSelect(PlayObject: TPlayObject; sData: string); override;
    procedure LoadNPCData();
    procedure SaveNPCData();
    procedure LoadUpgradeList();
    procedure RefillGoods();
    procedure LoadNpcScript();
    procedure Click(PlayObject: TPlayObject); override;
    procedure ClearScript(); override;
    procedure ClearData();
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); override; //FFE9
    procedure ClientBuyItem(PlayObject: TPlayObject; sItemName: string; nInt: Integer);
    procedure ClientGetDetailGoodsList(PlayObject: TPlayObject; sItemName: string; nInt: Integer);
    procedure ClientQuerySellPrice(PlayObject: TPlayObject; UserItem: pTUserItem);
    function ClientSellItem(PlayObject: TPlayObject; UserItem: pTUserItem): Boolean;
    procedure ClientMakeDrugItem(PlayObject: TPlayObject; sItemName: string);
    procedure ClientQueryRepairCost(PlayObject: TPlayObject; UserItem: pTUserItem);
    function ClientRepairItem(PlayObject: TPlayObject; UserItem: pTUserItem): Boolean;
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); override;

    procedure ClientGetDetailSellGoodsList(PlayObject: TPlayObject; sItemName: string; nInt: Integer); //004A26F0
    function ClientSellOffItem(PlayObject: TPlayObject; SellOffInfo: pTSellOffInfo; sName: string): Boolean; //004A1CD8
    procedure ClientBuySellOffItem(PlayObject: TPlayObject; sItemName: string; nInt: Integer); //004A2334

  end;
  TGuildOfficial = class(TNormNpc) //0x568
  private
    function ReQuestBuildGuild(PlayObject: TPlayObject;
      sGuildName: string): Integer;
    function ReQuestGuildWar(PlayObject: TPlayObject;
      sGuildName: string): Integer;
    procedure DoNate(PlayObject: TPlayObject);
    procedure ReQuestCastleWar(PlayObject: TPlayObject; sIndex: string);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); override; //FFE9
    procedure Run; override; //FFFB
    procedure Click(PlayObject: TPlayObject); override; //FFEB
    procedure UserSelect(PlayObject: TPlayObject; sData: string); override; //FFEA
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); override;
  end;
  TTrainer = class(TNormNpc) //0x574
    n564: Integer;
    m_dw568: LongWord;
    n56C: Integer;
    n570: Integer;
  private
  public
    constructor Create(); override;
    destructor Destroy; override;
    function Operate(ProcessMsg: pTProcessMessage): Boolean; override; //FFFC
    procedure Run; override;
  end;
  //  TCastleManager = class(TMerchant)
  TCastleOfficial = class(TMerchant)
  private
    procedure HireArcher(sIndex: string; PlayObject: TPlayObject);
    procedure HireGuard(sIndex: string; PlayObject: TPlayObject);
    procedure RepairDoor(PlayObject: TPlayObject);
    procedure RepairWallNow(nWallIndex: Integer; PlayObject: TPlayObject);
  public
    constructor Create(); override;
    destructor Destroy; override;
    procedure Click(PlayObject: TPlayObject); override; //FFEB
    procedure UserSelect(PlayObject: TPlayObject; sData: string); override; //FFEA
    procedure GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); override; //FFE9
    procedure SendCustemMsg(PlayObject: TPlayObject; sMsg: string); override;
  end;
implementation

uses Castle, M2Share, HUtil32, LocalDB, Envir, Guild, EDcode, ObjMon2,
  Event, PlugOfEngine, ObjPlayMon;

procedure TCastleOfficial.Click(PlayObject: TPlayObject); //004A4588
begin
  if m_Castle = nil then begin
    PlayObject.SysMsg('NPC�����ڳǱ�������', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).IsMasterGuild(TGUild(PlayObject.m_MyGuild)) or (PlayObject.m_btPermission >= 3) then
    inherited;
end;

procedure TCastleOfficial.GetVariableText(PlayObject: TPlayObject;
  var sMsg: string; sVariable: string);
var
  i: Integer;
  sText: string;
  CastleDoor: TCastleDoor;
  List: TStringList;
begin
  inherited;
  if m_Castle = nil then begin
    sMsg := '????';
    Exit;
  end;
  if sVariable = '$CASTLEGOLD' then begin
    sText := IntToStr(TUserCastle(m_Castle).m_nTotalGold);
    sMsg := sub_49ADB8(sMsg, '<$CASTLEGOLD>', sText);
  end else
    if sVariable = '$TODAYINCOME' then begin
    sText := IntToStr(TUserCastle(m_Castle).m_nTodayIncome);
    sMsg := sub_49ADB8(sMsg, '<$TODAYINCOME>', sText);
  end else
    if sVariable = '$CASTLEDOORSTATE' then begin
    CastleDoor := TCastleDoor(TUserCastle(m_Castle).m_MainDoor.BaseObject);
    if CastleDoor.m_boDeath then sText := '��'
    else if CastleDoor.m_boOpened then sText := '����'
    else sText := '�ر�';
    sMsg := sub_49ADB8(sMsg, '<$CASTLEDOORSTATE>', sText);
  end else
    if sVariable = '$REPAIRDOORGOLD' then begin
    sText := IntToStr(g_Config.nRepairDoorPrice);
    sMsg := sub_49ADB8(sMsg, '<$REPAIRDOORGOLD>', sText);
  end else
    if sVariable = '$REPAIRWALLGOLD' then begin
    sText := IntToStr(g_Config.nRepairWallPrice);
    sMsg := sub_49ADB8(sMsg, '<$REPAIRWALLGOLD>', sText);
  end else
    if sVariable = '$GUARDFEE' then begin
    sText := IntToStr(g_Config.nHireGuardPrice);
    sMsg := sub_49ADB8(sMsg, '<$GUARDFEE>', sText);
  end else
    if sVariable = '$ARCHERFEE' then begin
    sText := IntToStr(g_Config.nHireArcherPrice);
    sMsg := sub_49ADB8(sMsg, '<$ARCHERFEE>', sText);
  end else
    if sVariable = '$GUARDRULE' then begin
    sText := '��Ч';
    sMsg := sub_49ADB8(sMsg, '<$GUARDRULE>', sText);
  end;
end;

procedure TCastleOfficial.UserSelect(PlayObject: TPlayObject; sData: string);
var
  s18, s20, sMsg, sLabel: string;
  boCanJmp: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TCastleManager::UserSelect... ';
begin
  inherited;
  try
    //    PlayObject.m_nScriptGotoCount:=0;
    if m_Castle = nil then begin
      PlayObject.SysMsg('NPC�����ڳǱ�������', c_Red, t_Hint);
      Exit;
    end;
    if (sData <> '') and (sData[1] = '@') then begin
      sMsg := GetValidStr3(sData, sLabel, [#13]);
      s18 := '';
      PlayObject.m_sScriptLable := sData;
      if TUserCastle(m_Castle).IsMasterGuild(TGUild(PlayObject.m_MyGuild)) and (PlayObject.IsGuildMaster) then begin
        boCanJmp := PlayObject.LableIsCanJmp(sLabel);
        if CompareText(sLabel, sSL_SENDMSG) = 0 then begin
          if sMsg = '' then Exit;
        end;
        GotoLable(PlayObject, sLabel, not boCanJmp);
        //GotoLable(PlayObject,sLabel,not PlayObject.LableIsCanJmp(sLabel));
        if not boCanJmp then Exit;
        if CompareText(sLabel, sSL_SENDMSG) = 0 then begin
          SendCustemMsg(PlayObject, sMsg);
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
        end else
          if CompareText(sLabel, sCASTLENAME) = 0 then begin
          sMsg := Trim(sMsg);
          if sMsg <> '' then begin
            TUserCastle(m_Castle).m_sName := sMsg;
            TUserCastle(m_Castle).Save;
            TUserCastle(m_Castle).m_MasterGuild.RefMemberName;
            s18 := '�Ǳ����Ƹ��ĳɹ�...';
          end else begin
            s18 := '�Ǳ����Ƹ���ʧ�ܣ�����';
          end;
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
        end else
          if CompareText(sLabel, sWITHDRAWAL) = 0 then begin
          case TUserCastle(m_Castle).WithDrawalGolds(PlayObject, Str_ToInt(sMsg, 0)) of
            -4: s18 := '����Ľ��������ȷ������';
            -3: s18 := '���޷�Я������Ķ����ˡ�';
            -2: s18 := '�ó���û����ô����.';
            -1: s18 := 'ֻ���л� ' + TUserCastle(m_Castle).m_sOwnGuild + ' �������˲���ʹ�ã�����';
            1: GotoLable(PlayObject, sMAIN, False);
          end;
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
        end else
          if CompareText(sLabel, sRECEIPTS) = 0 then begin
          case TUserCastle(m_Castle).ReceiptGolds(PlayObject, Str_ToInt(sMsg, 0)) of
            -4: s18 := '����Ľ��������ȷ������';
            -3: s18 := '���Ѿ��ﵽ�ڳ��ڴ�Ż���������ˡ�';
            -2: s18 := '��û����ô����.';
            -1: s18 := 'ֻ���л� ' + TUserCastle(m_Castle).m_sOwnGuild + ' �������˲���ʹ�ã�����';
            1: GotoLable(PlayObject, sMAIN, False);
          end;
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
        end else
          if CompareText(sLabel, sOPENMAINDOOR) = 0 then begin
          TUserCastle(m_Castle).MainDoorControl(False);
        end else
          if CompareText(sLabel, sCLOSEMAINDOOR) = 0 then begin
          TUserCastle(m_Castle).MainDoorControl(True);
        end else
          if CompareText(sLabel, sREPAIRDOORNOW) = 0 then begin
          RepairDoor(PlayObject);
          GotoLable(PlayObject, sMAIN, False);
        end else
          if CompareText(sLabel, sREPAIRWALLNOW1) = 0 then begin
          RepairWallNow(1, PlayObject);
          GotoLable(PlayObject, sMAIN, False);
        end else
          if CompareText(sLabel, sREPAIRWALLNOW2) = 0 then begin
          RepairWallNow(2, PlayObject);
          GotoLable(PlayObject, sMAIN, False);
        end else
          if CompareText(sLabel, sREPAIRWALLNOW3) = 0 then begin
          RepairWallNow(3, PlayObject);
          GotoLable(PlayObject, sMAIN, False);
        end else
          if CompareLStr(sLabel, sHIREGUARDNOW, Length(sHIREGUARDNOW)) then begin
          s20 := Copy(sLabel, Length(sHIREGUARDNOW) + 1, Length(sLabel));
          HireGuard(s20, PlayObject);
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, '');
          //GotoLable(PlayObject,sHIREGUARDOK,False);
        end else
          if CompareLStr(sLabel, sHIREARCHERNOW, Length(sHIREARCHERNOW)) then begin
          s20 := Copy(sLabel, Length(sHIREARCHERNOW) + 1, Length(sLabel));
          HireArcher(s20, PlayObject);
          PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, '');
        end else
          if CompareText(sLabel, sEXIT) = 0 then begin
          PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
        end else
          if CompareText(sLabel, sBACK) = 0 then begin
          if PlayObject.m_sScriptGoBackLable = '' then PlayObject.m_sScriptGoBackLable := sMAIN;
          GotoLable(PlayObject, PlayObject.m_sScriptGoBackLable, False);
        end;
      end else begin
        s18 := '��û��Ȩ��ʹ��';
        PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(Self), 0, 0, s18);
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
  //  inherited;
end;

procedure TCastleOfficial.HireGuard(sIndex: string; PlayObject: TPlayObject);
var
  n10: Integer;
  ObjUnit: pTObjUnit;
begin
  if m_Castle = nil then begin
    PlayObject.SysMsg('NPC�����ڳǱ�������', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nHireGuardPrice then begin
    n10 := Str_ToInt(sIndex, 0) - 1;
    if n10 <= MAXCALSTEGUARD then begin
      if TUserCastle(m_Castle).m_Guard[n10].BaseObject = nil then begin
        if not TUserCastle(m_Castle).m_boUnderWar then begin
          ObjUnit := @TUserCastle(m_Castle).m_Guard[n10];
          ObjUnit.BaseObject := UserEngine.RegenMonsterByName(TUserCastle(m_Castle).m_sMapName,
            ObjUnit.nX,
            ObjUnit.nY,
            ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then begin
            Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nHireGuardPrice);
            ObjUnit.BaseObject.m_Castle := TUserCastle(m_Castle);
            TGuardUnit(ObjUnit.BaseObject).m_nX550 := ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554 := ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_nDirection := 3;
            PlayObject.SysMsg('��Ӷ�ɹ�.', c_Green, t_Hint);
          end;
        end else begin
          PlayObject.SysMsg('�����޷���Ӷ������', c_Red, t_Hint);
        end;
      end
    end else begin
      PlayObject.SysMsg('ָ����󣡣���', c_Red, t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�����ʽ��㣡����', c_Red, t_Hint);
  end;
  {
  if UserCastle.m_nTotalGold >= g_Config.nHireGuardPrice then begin
    n10:=Str_ToInt(sIndex,0) - 1;
    if n10 <= MAXCALSTEGUARD then begin
      if UserCastle.m_Guard[n10].BaseObject = nil then begin
        if not UserCastle.m_boUnderWar then begin
          ObjUnit:=@UserCastle.m_Guard[n10];
          ObjUnit.BaseObject:=UserEngine.RegenMonsterByName(UserCastle.m_sMapName,
                                                          ObjUnit.nX,
                                                          ObjUnit.nY,
                                                          ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then begin
            Dec(UserCastle.m_nTotalGold,g_Config.nHireGuardPrice);
            ObjUnit.BaseObject.m_Castle:=UserCastle;
            TGuardUnit(ObjUnit.BaseObject).m_nX550:=ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554:=ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_n558:=3;
            PlayObject.SysMsg('��Ӷ�ɹ�.',c_Green,t_Hint);
          end;

        end else begin
          PlayObject.SysMsg('�����޷���Ӷ������',c_Red,t_Hint);
        end;
      end
    end else begin
      PlayObject.SysMsg('ָ����󣡣���',c_Red,t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�����ʽ��㣡����',c_Red,t_Hint);
  end;
  }
end;

procedure TCastleOfficial.HireArcher(sIndex: string; PlayObject: TPlayObject);
var
  n10: Integer;
  ObjUnit: pTObjUnit;
begin
  if m_Castle = nil then begin
    PlayObject.SysMsg('NPC�����ڳǱ�������', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nHireArcherPrice then begin
    n10 := Str_ToInt(sIndex, 0) - 1;
    if n10 <= MAXCASTLEARCHER then begin
      if TUserCastle(m_Castle).m_Archer[n10].BaseObject = nil then begin
        if not TUserCastle(m_Castle).m_boUnderWar then begin
          ObjUnit := @TUserCastle(m_Castle).m_Archer[n10];
          ObjUnit.BaseObject := UserEngine.RegenMonsterByName(TUserCastle(m_Castle).m_sMapName,
            ObjUnit.nX,
            ObjUnit.nY,
            ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then begin
            Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nHireArcherPrice);
            ObjUnit.BaseObject.m_Castle := TUserCastle(m_Castle);
            TGuardUnit(ObjUnit.BaseObject).m_nX550 := ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554 := ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_nDirection := 3;
            PlayObject.SysMsg('��Ӷ�ɹ�.', c_Green, t_Hint);
          end;
        end else begin
          PlayObject.SysMsg('�����޷���Ӷ������', c_Red, t_Hint);
        end;
      end else begin
        PlayObject.SysMsg('���ѹ�Ӷ������', c_Red, t_Hint);
      end;
    end else begin
      PlayObject.SysMsg('ָ����󣡣���', c_Red, t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�����ʽ��㣡����', c_Red, t_Hint);
  end;
  {
  if UserCastle.m_nTotalGold >= g_Config.nHireArcherPrice then begin
    n10:=Str_ToInt(sIndex,0) - 1;
    if n10 <= MAXCASTLEARCHER then begin
      if UserCastle.m_Archer[n10].BaseObject = nil then begin
        if not UserCastle.m_boUnderWar then begin
          ObjUnit:=@UserCastle.m_Archer[n10];
          ObjUnit.BaseObject:=UserEngine.RegenMonsterByName(UserCastle.m_sMapName,
                                                          ObjUnit.nX,
                                                          ObjUnit.nY,
                                                          ObjUnit.sName);
          if ObjUnit.BaseObject <> nil then begin
            Dec(UserCastle.m_nTotalGold,g_Config.nHireArcherPrice);
            ObjUnit.BaseObject.m_Castle:=UserCastle;
            TGuardUnit(ObjUnit.BaseObject).m_nX550:=ObjUnit.nX;
            TGuardUnit(ObjUnit.BaseObject).m_nY554:=ObjUnit.nY;
            TGuardUnit(ObjUnit.BaseObject).m_n558:=3;
            PlayObject.SysMsg('��Ӷ�ɹ�.',c_Green,t_Hint);
          end;

        end else begin
          PlayObject.SysMsg('�����޷���Ӷ������',c_Red,t_Hint);
        end;
      end else begin
        PlayObject.SysMsg('���ѹ�Ӷ������',c_Red,t_Hint);
      end;
    end else begin
      PlayObject.SysMsg('ָ����󣡣���',c_Red,t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�����ʽ��㣡����',c_Red,t_Hint);
  end;
  }
end;
{ TMerchant }

procedure TMerchant.AddItemPrice(nIndex: Integer; nPrice: Integer);
var
  ItemPrice: pTItemPrice;
begin
  New(ItemPrice);
  ItemPrice.wIndex := nIndex;
  ItemPrice.nPrice := nPrice;
  m_ItemPriceList.Add(ItemPrice);
  FrmDB.SaveGoodPriceRecord(Self, m_sScript + '-' + m_sMapName);
end;

procedure TMerchant.CheckItemPrice(nIndex: Integer);
var
  i: Integer;
  ItemPrice: pTItemPrice;
  n10: Integer;
  StdItem: pTStdItem;
begin
  for i := 0 to m_ItemPriceList.Count - 1 do begin
    ItemPrice := m_ItemPriceList.Items[i];
    if ItemPrice = nil then Continue;
    if ItemPrice.wIndex = nIndex then begin
      n10 := ItemPrice.nPrice;
      if ROUND(n10 * 1.1) > n10 then begin
        n10 := ROUND(n10 * 1.1);
      end else Inc(n10);
      Exit;
    end;
  end;
  StdItem := UserEngine.GetStdItem(nIndex);
  if StdItem <> nil then begin
    AddItemPrice(nIndex, ROUND(StdItem.Price * 1.1));
  end;
end;

function TMerchant.GetRefillList(nIndex: Integer): TList;
var
  i: Integer;
  List: TList;
begin
  Result := nil;
  if nIndex <= 0 then Exit;
  for i := 0 to m_GoodsList.Count - 1 do begin
    List := TList(m_GoodsList.Items[i]);
    if List = nil then Continue;
    if List.Count > 0 then begin
      if pTUserItem(List.Items[0]).wIndex = nIndex then begin
        Result := List;
        break;
      end;
    end;
  end;
end;

procedure TMerchant.RefillGoods;
  procedure RefillItems(var List: TList; sItemName: string; nInt: Integer);
  var
    i: Integer;
    UserItem: pTUserItem;
  begin
    if List = nil then begin
      List := TList.Create;
      m_GoodsList.Add(List);
    end;
    for i := 0 to nInt - 1 do begin
      New(UserItem);
      if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
        List.Insert(0, UserItem);
      end else DisPose(UserItem);
    end;
  end;
  procedure DelReFillItem(var List: TList; nInt: Integer);
  var
    i: Integer;
  begin
    for i := List.Count - 1 downto 0 do begin
      if nInt <= 0 then break;
      if pTUserItem(List.Items[i]) <> nil then begin
        DisPose(pTUserItem(List.Items[i]));
      end;
      List.Delete(i);
      Dec(nInt);
    end;
  end;
var
  i, ii: Integer;
  Goods: pTGoods;
  nIndex, nRefillCount: Integer;
  RefillList, RefillList20: TList;
  bo21: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TMerchant::RefillGoods %s/%d:%d [%s] Code:%d';
begin
  try
    for i := 0 to m_RefillGoodsList.Count - 1 do begin
      Goods := m_RefillGoodsList.Items[i];
      if Goods = nil then Continue;
      if (GetTickCount - Goods.dwRefillTick) > Goods.dwRefillTime * 60 * 1000 then begin
        Goods.dwRefillTick := GetTickCount();
        nIndex := UserEngine.GetStdItemIdx(Goods.sItemName);
        if nIndex >= 0 then begin
          RefillList := GetRefillList(nIndex);
          nRefillCount := 0;
          if RefillList <> nil then nRefillCount := RefillList.Count;
          if Goods.nCount > nRefillCount then begin
            CheckItemPrice(nIndex);
            RefillItems(RefillList, Goods.sItemName, Goods.nCount - nRefillCount);
            FrmDB.SaveGoodRecord(Self, m_sScript + '-' + m_sMapName);
            FrmDB.SaveGoodPriceRecord(Self, m_sScript + '-' + m_sMapName);
          end;
          if Goods.nCount < nRefillCount then begin
            DelReFillItem(RefillList, nRefillCount - Goods.nCount);
            FrmDB.SaveGoodRecord(Self, m_sScript + '-' + m_sMapName);
            FrmDB.SaveGoodPriceRecord(Self, m_sScript + '-' + m_sMapName);
          end;
        end;
      end;
    end;
    for i := 0 to m_GoodsList.Count - 1 do begin
      RefillList20 := TList(m_GoodsList.Items[i]);
      if RefillList20 = nil then Continue;
      if RefillList20.Count > 1000 then begin
        bo21 := False;
        for ii := 0 to m_RefillGoodsList.Count - 1 do begin
          Goods := m_RefillGoodsList.Items[ii];
          if Goods = nil then Continue;
          nIndex := UserEngine.GetStdItemIdx(Goods.sItemName);
          if (pTItemPrice(RefillList20.Items[0]) <> nil) and (pTItemPrice(RefillList20.Items[0]).wIndex = nIndex) then begin
            bo21 := True;
            break;
          end;
        end;
        if not bo21 then begin
          DelReFillItem(RefillList20, RefillList20.Count - 1000);
        end else begin
          DelReFillItem(RefillList20, RefillList20.Count - 5000);
        end;
      end;
    end;
  except
    on E: Exception do
      MainOutMessage(format(sExceptionMsg, [m_sCharName, m_nCurrX, m_nCurrY, E.Message, nCHECK]));
  end;
end;

function TMerchant.CheckItemType(nStdMode: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  for i := 0 to m_ItemTypeList.Count - 1 do begin
    if Integer(m_ItemTypeList.Items[i]) = nStdMode then begin
      Result := True;
      break;
    end;
  end;
end;

function TMerchant.GetItemPrice(nIndex: Integer): Integer;
var
  i: Integer;
  ItemPrice: pTItemPrice;
  StdItem: pTStdItem;
begin
  Result := -1;
  for i := 0 to m_ItemPriceList.Count - 1 do begin
    ItemPrice := m_ItemPriceList.Items[i];
    if ItemPrice = nil then Continue;
    if ItemPrice.wIndex = nIndex then begin
      Result := ItemPrice.nPrice;
      break;
    end;
  end; // for
  if Result < 0 then begin
    StdItem := UserEngine.GetStdItem(nIndex);
    if StdItem <> nil then begin
      if CheckItemType(StdItem.StdMode) then
        Result := StdItem.Price;
    end;
  end;
end;

procedure TMerchant.SaveUpgradingList();
begin
  try
    //FrmDB.SaveUpgradeWeaponRecord(m_sCharName,m_UpgradeWeaponList);
    FrmDB.SaveUpgradeWeaponRecord(m_sScript + '-' + m_sMapName, m_UpgradeWeaponList);
  except
    MainOutMessage('Failure in saving upgradinglist - ' + m_sCharName);
  end;
end;

procedure TMerchant.UpgradeWapon(User: TPlayObject); //004A0920
  procedure sub_4A0218(ItemList: TList; var btDc: Byte; var btSc: Byte; var btMc: Byte; var btDura: Byte);
  var
    i, ii: Integer;
    DuraList: TList;
    UserItem: pTUserItem;
    StdItem: pTStdItem;
    StdItem80: TStdItem;
    DelItemList: TStringList;
    nDc, nSc, nMc, nDcMin, nDcMax, nScMin, nScMax, nMcMin, nMcMax, nDura, nItemCount: Integer;
  begin
    nDcMin := 0;
    nDcMax := 0;
    nScMin := 0;
    nScMax := 0;
    nMcMin := 0;
    nMcMax := 0;
    nDura := 0;
    nItemCount := 0;
    DelItemList := nil;
    DuraList := TList.Create;
    for i := ItemList.Count - 1 downto 0 do begin
      UserItem := ItemList.Items[i];
      if UserItem = nil then Continue;
      if UserEngine.GetStdItemName(UserItem.wIndex) = g_Config.sBlackStone then begin
        DuraList.Add(Pointer(ROUND(UserItem.Dura / 1.0E3)));
        if DelItemList = nil then DelItemList := TStringList.Create;
        DelItemList.AddObject(g_Config.sBlackStone, TObject(UserItem.MakeIndex));
        DisPose(UserItem);
        ItemList.Delete(i);
      end else begin
        if IsUseItem(UserItem.wIndex) then begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          if StdItem <> nil then begin
            StdItem80 := StdItem^;
            ItemUnit.GetItemAddValue(UserItem, StdItem80);
            nDc := 0;
            nSc := 0;
            nMc := 0;
            case StdItem80.StdMode of
              19, 20, 21: begin //004A0421
                  nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC);
                  nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC);
                  nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC);
                end;
              22, 23: begin //004A046E
                  nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC);
                  nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC);
                  nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC);
                end;
              24, 26: begin
                  nDc := HiWord(StdItem80.DC) + LoWord(StdItem80.DC) + 1;
                  nSc := HiWord(StdItem80.SC) + LoWord(StdItem80.SC) + 1;
                  nMc := HiWord(StdItem80.MC) + LoWord(StdItem80.MC) + 1;
                end;
            end;
            if nDcMin < nDc then begin
              nDcMax := nDcMin;
              nDcMin := nDc;
            end else begin
              if nDcMax < nDc then nDcMax := nDc;
            end;
            if nScMin < nSc then begin
              nScMax := nScMin;
              nScMin := nSc;
            end else begin
              if nScMax < nSc then nScMax := nSc;
            end;
            if nMcMin < nMc then begin
              nMcMax := nMcMin;
              nMcMin := nMc;
            end else begin
              if nMcMax < nMc then nMcMax := nMc;
            end;
            if DelItemList = nil then DelItemList := TStringList.Create;
            DelItemList.AddObject(StdItem.Name, TObject(UserItem.MakeIndex));
            //004A06DB
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('26' + #9 +
                User.m_sMapName + #9 +
                IntToStr(User.m_nCurrX) + #9 +
                IntToStr(User.m_nCurrY) + #9 +
                User.m_sCharName + #9 +
                //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                '0');
            DisPose(UserItem);
            ItemList.Delete(i);
          end;
        end;
      end;
    end; // for
    for i := 0 to DuraList.Count - 1 do begin
      if DuraList.Count <= 0 then break;
      for ii := DuraList.Count - 1 downto i + 1 do begin
        if Integer(DuraList.Items[ii]) > Integer(DuraList.Items[ii - 1]) then
          DuraList.Exchange(ii, ii - 1);
      end; // for
    end; // for
    for i := 0 to DuraList.Count - 1 do begin
      nDura := nDura + Integer(DuraList.Items[i]);
      Inc(nItemCount);
      if nItemCount >= 5 then break;
    end;
    btDura := ROUND(_MIN(5, nItemCount) + _MIN(5, nItemCount) * ((nDura / nItemCount) / 5.0));
    btDc := nDcMin div 5 + nDcMax div 3;
    btSc := nScMin div 5 + nScMax div 3;
    btMc := nMcMin div 5 + nMcMax div 3;
    if DelItemList <> nil then
      User.SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(DelItemList), 0, 0, '');
    if DuraList <> nil then DuraList.Free;
  end;
var
  i: Integer;
  bo0D: Boolean;
  UpgradeInfo: pTUpgradeInfo;
  StdItem: pTStdItem;
begin
  bo0D := False;
  for i := 0 to m_UpgradeWeaponList.Count - 1 do begin
    UpgradeInfo := m_UpgradeWeaponList.Items[i];
    if UpgradeInfo = nil then Continue;
    if UpgradeInfo.sUserName = User.m_sCharName then begin
      GotoLable(User, sUPGRADEING, False);
      Exit;
    end;
  end;
  if (User.m_UseItems[U_WEAPON].wIndex <> 0) and (User.m_nGold >= g_Config.nUpgradeWeaponPrice) and
    (User.CheckItems(g_Config.sBlackStone) <> nil) then begin
    User.DecGold(g_Config.nUpgradeWeaponPrice);
    //    if m_boCastle or g_Config.boGetAllNpcTax then UserCastle.IncRateGold(g_Config.nUpgradeWeaponPrice);
    if m_boCastle or g_Config.boGetAllNpcTax then begin
      if m_Castle <> nil then begin
        TUserCastle(m_Castle).IncRateGold(g_Config.nUpgradeWeaponPrice);
      end else
        if g_Config.boGetAllNpcTax then begin
        g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
      end;
    end;
    User.GoldChanged();
    New(UpgradeInfo);
    UpgradeInfo.sUserName := User.m_sCharName;
    UpgradeInfo.UserItem := User.m_UseItems[U_WEAPON];
    StdItem := UserEngine.GetStdItem(User.m_UseItems[U_WEAPON].wIndex);

    if StdItem.NeedIdentify = 1 then
      AddGameDataLog('25' + #9 +
        User.m_sMapName + #9 +
        IntToStr(User.m_nCurrX) + #9 +
        IntToStr(User.m_nCurrY) + #9 +
        User.m_sCharName + #9 +
        //UserEngine.GetStdItemName(User.m_UseItems[U_WEAPON].wIndex) + #9 +
        StdItem.Name + #9 +
        IntToStr(User.m_UseItems[U_WEAPON].MakeIndex) + #9 +
        '1' + #9 +
        '0');
    User.SendDelItems(@User.m_UseItems[U_WEAPON]);
    User.m_UseItems[U_WEAPON].wIndex := 0;
    User.RecalcAbilitys();
    User.FeatureChanged();
    User.SendMsg(User, RM_ABILITY, 0, 0, 0, 0, '');
    sub_4A0218(User.m_ItemList, UpgradeInfo.btDc, UpgradeInfo.btSc, UpgradeInfo.btMc, UpgradeInfo.btDura);
    UpgradeInfo.dtTime := Now();
    UpgradeInfo.dwGetBackTick := GetTickCount();
    m_UpgradeWeaponList.Add(UpgradeInfo);
    SaveUpgradingList();
    bo0D := True;
  end;
  if bo0D then GotoLable(User, sUPGRADEOK, False)
  else GotoLable(User, sUPGRADEFAIL, False);
end;

procedure TMerchant.GetBackupgWeapon(User: TPlayObject); //004A0CB8
var
  i: Integer;
  UpgradeInfo: pTUpgradeInfo;
  n10, n14, n18, n1C, n90: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  n18 := 0;
  UpgradeInfo := nil;
  if not User.IsEnoughBag then begin
    //    User.SysMsg('��ı����Ѿ����ˣ��޷���Я���κ���Ʒ�ˣ�����',0);
    GotoLable(User, sGETBACKUPGFULL, False);
    Exit;
  end;
  for i := m_UpgradeWeaponList.Count - 1 downto 0 do begin //for i := 0 to m_UpgradeWeaponList.Count - 1 do begin
    if m_UpgradeWeaponList.Count <= 0 then break;
    if pTUpgradeInfo(m_UpgradeWeaponList.Items[i]).sUserName = User.m_sCharName then begin
      n18 := 1;
      if ((GetTickCount - pTUpgradeInfo(m_UpgradeWeaponList.Items[i]).dwGetBackTick) > g_Config.dwUPgradeWeaponGetBackTime) or (User.m_btPermission >= 4) then begin
        UpgradeInfo := m_UpgradeWeaponList.Items[i];
        m_UpgradeWeaponList.Delete(i);
        SaveUpgradingList();
        n18 := 2;
        break;
      end;
    end;
  end;
  if UpgradeInfo <> nil then begin
    case UpgradeInfo.btDura of //
      0..8: begin //004A0DE5
          //       n14:=_MAX(3000,UpgradeInfo.UserItem.DuraMax shr 1);
          if UpgradeInfo.UserItem.DuraMax > 3000 then begin
            Dec(UpgradeInfo.UserItem.DuraMax, 3000);
          end else begin
            UpgradeInfo.UserItem.DuraMax := UpgradeInfo.UserItem.DuraMax shr 1;
          end;
          if UpgradeInfo.UserItem.Dura > UpgradeInfo.UserItem.DuraMax then
            UpgradeInfo.UserItem.Dura := UpgradeInfo.UserItem.DuraMax;
        end;
      9..15: begin //004A0E41
          if Random(UpgradeInfo.btDura) < 6 then begin
            if UpgradeInfo.UserItem.DuraMax > 1000 then
              Dec(UpgradeInfo.UserItem.DuraMax, 1000);
            if UpgradeInfo.UserItem.Dura > UpgradeInfo.UserItem.DuraMax then
              UpgradeInfo.UserItem.Dura := UpgradeInfo.UserItem.DuraMax;
          end;
        end;
      18..255: begin
          case Random(UpgradeInfo.btDura - 18) of
            1..4: Inc(UpgradeInfo.UserItem.DuraMax, 1000);
            5..7: Inc(UpgradeInfo.UserItem.DuraMax, 2000);
            8..255: Inc(UpgradeInfo.UserItem.DuraMax, 4000)
          end;
        end;
    end; // case
    if (UpgradeInfo.btDc = UpgradeInfo.btMc) and (UpgradeInfo.btMc = UpgradeInfo.btSc) then begin
      n1C := Random(3);
    end else begin
      n1C := -1;
    end;
    if ((UpgradeInfo.btDc >= UpgradeInfo.btMc) and (UpgradeInfo.btDc >= UpgradeInfo.btSc)) or
      (n1C = 0) then begin
      n90 := _MIN(11, UpgradeInfo.btDc);
      n10 := _MIN(85, n90 shl 3 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);
      //      n10:=_MIN(85,n90 * 8 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);

      if Random(g_Config.nUpgradeWeaponDCRate) < n10 then begin //if Random(100) < n10 then begin
        UpgradeInfo.UserItem.btValue[10] := 10;

        if (n10 > 63) and (Random(g_Config.nUpgradeWeaponDCTwoPointRate) = 0) then //if (n10 > 63) and (Random(30) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 11;

        if (n10 > 79) and (Random(g_Config.nUpgradeWeaponDCThreePointRate) = 0) then //if (n10 > 79) and (Random(200) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 12;
      end else UpgradeInfo.UserItem.btValue[10] := 1; //004A0F89
    end;
    if ((UpgradeInfo.btMc >= UpgradeInfo.btDc) and (UpgradeInfo.btMc >= UpgradeInfo.btSc)) or
      (n1C = 1) then begin
      n90 := _MIN(11, UpgradeInfo.btMc);
      n10 := _MIN(85, n90 shl 3 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);

      if Random(g_Config.nUpgradeWeaponMCRate) < n10 then begin //if Random(100) < n10 then begin
        UpgradeInfo.UserItem.btValue[10] := 20;

        if (n10 > 63) and (Random(g_Config.nUpgradeWeaponMCTwoPointRate) = 0) then //if (n10 > 63) and (Random(30) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 21;

        if (n10 > 79) and (Random(g_Config.nUpgradeWeaponMCThreePointRate) = 0) then //if (n10 > 79) and (Random(200) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 22;
      end else UpgradeInfo.UserItem.btValue[10] := 1;
    end;
    if ((UpgradeInfo.btSc >= UpgradeInfo.btMc) and (UpgradeInfo.btSc >= UpgradeInfo.btDc)) or
      (n1C = 2) then begin
      n90 := _MIN(11, UpgradeInfo.btMc);
      n10 := _MIN(85, n90 shl 3 - n90 + 10 + UpgradeInfo.UserItem.btValue[3] - UpgradeInfo.UserItem.btValue[4] + User.m_nBodyLuckLevel);

      if Random(g_Config.nUpgradeWeaponSCRate) < n10 then begin //if Random(100) < n10 then begin
        UpgradeInfo.UserItem.btValue[10] := 30;

        if (n10 > 63) and (Random(g_Config.nUpgradeWeaponSCTwoPointRate) = 0) then //if (n10 > 63) and (Random(30) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 31;

        if (n10 > 79) and (Random(g_Config.nUpgradeWeaponSCThreePointRate) = 0) then //if (n10 > 79) and (Random(200) = 0) then
          UpgradeInfo.UserItem.btValue[10] := 32;
      end else UpgradeInfo.UserItem.btValue[10] := 1;
    end;
    New(UserItem);
    UserItem^ := UpgradeInfo.UserItem;
    DisPose(UpgradeInfo);
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    //004A120E
    if StdItem.NeedIdentify = 1 then
      AddGameDataLog('24' + #9 +
        User.m_sMapName + #9 +
        IntToStr(User.m_nCurrX) + #9 +
        IntToStr(User.m_nCurrY) + #9 +
        User.m_sCharName + #9 +
        //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
        StdItem.Name + #9 +
        IntToStr(UserItem.MakeIndex) + #9 +
        '1' + #9 +
        '0');
    User.AddItemToBag(UserItem);
    User.SendAddItem(UserItem);
  end;
  case n18 of //
    0: GotoLable(User, sGETBACKUPGFAIL, False);
    1: GotoLable(User, sGETBACKUPGING, False);
    2: GotoLable(User, sGETBACKUPGOK, False);
  end; // case
end;

function TMerchant.GetUserPrice(PlayObject: TPlayObject; nPrice: Integer): Integer; //0049F6E0
var
  n14: Integer;
begin
  {
  if m_boCastle then begin
    if UserCastle.IsMasterGuild(TGuild(PlayObject.m_MyGuild)) then begin
      n14:=_MAX(60,ROUND(m_nPriceRate * 8.0000000000000000001e-1));//80%
      Result:=ROUND(nPrice / 1.0e2 * n14); //100
    end else begin
      Result:=ROUND(nPrice / 1.0e2 * m_nPriceRate);
    end;
  end else begin
    Result:=ROUND(nPrice / 1.0e2 * m_nPriceRate);
  end;
  }
  if m_boCastle then begin
    //    if UserCastle.IsMasterGuild(TGuild(PlayObject.m_MyGuild)) then begin
    if (m_Castle <> nil) and TUserCastle(m_Castle).IsMasterGuild(TGUild(PlayObject.m_MyGuild)) then begin
      n14 := _MAX(60, ROUND(m_nPriceRate * (g_Config.nCastleMemberPriceRate / 100))); //80%
      Result := ROUND(nPrice / 100 * n14); //100
    end else begin
      Result := ROUND(nPrice / 100 * m_nPriceRate);
    end;
  end else begin
    Result := ROUND(nPrice / 100 * m_nPriceRate);
  end;
end;

procedure TMerchant.UserSelect(PlayObject: TPlayObject; sData: string);
  procedure SuperRepairItem(User: TPlayObject);
  begin
    User.SendMsg(Self, RM_SENDUSERSREPAIR, 0, Integer(Self), 0, 0, '');
  end;
  procedure BuyItem(User: TPlayObject; nInt: Integer);
  var
    i, n10, nStock, nPrice: Integer;
    nSubMenu: ShortInt;
    sSENDMSG, sName: string;
    UserItem: pTUserItem;
    StdItem: pTStdItem;
    List14: TList;
    sUserItemName: string;
  begin
    sSENDMSG := '';
    n10 := 0;
    for i := 0 to m_GoodsList.Count - 1 do begin
      List14 := TList(m_GoodsList.Items[i]);
      if List14 = nil then Continue;
      UserItem := List14.Items[0];
      if UserItem = nil then Continue;
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then begin
        //ȡ�Զ�����Ʒ����
        sName := '';
        if UserItem.btValue[13] = 1 then
          sName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
        if sName = '' then
          sName := StdItem.Name;

        nPrice := GetUserPrice(User, GetItemPrice(UserItem.wIndex));
        nStock := List14.Count;
        if (StdItem.StdMode <= 4) or
          (StdItem.StdMode = 42) or
          (StdItem.StdMode = 31) then nSubMenu := 0
        else nSubMenu := 1;
        sSENDMSG := sSENDMSG + sName + '/' + IntToStr(nSubMenu) + '/' + IntToStr(nPrice) + '/' + IntToStr(nStock) + '/';
        Inc(n10);
      end;
    end; // for
    User.SendMsg(Self, RM_SENDGOODSLIST, 0, Integer(Self), n10, 0, sSENDMSG);
  end;

  procedure BuySellItem(User: TPlayObject); //������Ʒ�б�
  var
    i, n18, nStock, nSubMenu, nSellGold: Integer;
    List20: TList;
    s1C, sName: string;
    SellOffInfo: pTSellOffInfo;
    StdItem: pTStdItem;
  begin
    s1C := '';
    n18 := 0;
    List20 := TList.Create;
    g_SellOffGoodList.GetSellOffGoodList(List20);
    for i := 0 to List20.Count - 1 do begin
      if List20.Count <= 0 then break;
      SellOffInfo := List20.Items[i];
      if SellOffInfo = nil then Continue;
      StdItem := UserEngine.GetStdItem(SellOffInfo.UseItems.wIndex);
      if StdItem <> nil then begin
        //ȡ�Զ�����Ʒ����
        sName := '';
        if SellOffInfo.UseItems.btValue[13] = 1 then
          sName := ItemUnit.GetCustomItemName(SellOffInfo.UseItems.MakeIndex, SellOffInfo.UseItems.wIndex);
        if sName = '' then
          sName := StdItem.Name;
        nStock := List20.Count;
        if (StdItem.StdMode <= 4) or
          (StdItem.StdMode = 42) or
          (StdItem.StdMode = 31) then nSubMenu := 0
        else nSubMenu := 1;
        if CompareText(SellOffInfo.sCharName, User.m_sCharName) = 0 then nSellGold := -SellOffInfo.nSellGold else nSellGold := SellOffInfo.nSellGold;
        s1C := s1C + sName + '/' + IntToStr(nSubMenu) + '/' + IntToStr(nSellGold) + '/' + IntToStr(nStock) + '/';
        Inc(n18);
      end;
    end;
    User.SendMsg(Self, RM_SENDSELLOFFGOODSLIST, 0, Integer(Self), n18, 0, s1C);
    List20.Free;
  end;

  procedure GetSellGold(User: TPlayObject);
  var
    i: Integer;
    nSellGold: Integer;
    nRate: Integer;
    nSellGoldCount: Integer;
    nRateCount: Integer;
    s1C: string;
    SellOffInfo: pTSellOffInfo;
    n18: Integer;
    List20: TList;
    bo01: Boolean;
  begin
    nSellGoldCount := 0;
    nRateCount := 0;
    s1C := '';
    List20 := TList.Create;
    g_SellOffGoldList.GetUserSellOffGoldListByChrName(User.m_sCharName, List20);
    for i := 0 to List20.Count - 1 do begin
      if List20.Count <= 0 then break;
      SellOffInfo := pTSellOffInfo(List20.Items[i]);
      if SellOffInfo = nil then Continue;
      if g_Config.nUserSellOffTax > 0 then begin
        nRate := SellOffInfo.nSellGold * g_Config.nUserSellOffTax div 100;
        nSellGold := SellOffInfo.nSellGold - nRate;
      end else begin
        nSellGold := SellOffInfo.nSellGold;
        nRate := 0;
      end;
      s1C := '��Ʒ:' + UserEngine.GetStdItemName(SellOffInfo.UseItems.wIndex) + ' ���:' + IntToStr(nSellGold) + ' ˰:' + IntToStr(nRate) + g_Config.sGameGoldName + ' ��������:' + DateTimeToStr(SellOffInfo.dSellDateTime);
      User.SysMsg(s1C, c_Green, t_Hint);
      Inc(User.m_nGameGold, nSellGold);
      Inc(nSellGoldCount, nSellGold);
      User.GameGoldChanged;
      Inc(nRateCount, nRate);
      Inc(n18);
      g_SellOffGoldList.DelSellOffGoldItem(SellOffInfo.UseItems.MakeIndex);
    end;
    if n18 > 0 then begin
      s1C := '�ܽ��:' + IntToStr(nSellGoldCount) + ' ˰:' + IntToStr(nRateCount) + g_Config.sGameGoldName;
      User.SysMsg(s1C, c_Green, t_Hint);
    end;
    //g_SellOffGoldList.SaveSellOffGoldList();
    //MainOutMessage('List20.Count:'+IntToStr(List20.Count));
    List20.Free;
  end;

  procedure RemoteMsg(User: TPlayObject; sLabel, sMsg: string); //���ܸ���
  var
    s01, s02, s03: string;
    sSENDMSG: string;
    TargetObject: TPlayObject;
  begin
    sMsg := Trim(sMsg);
    if sMsg <> '' then begin
      TargetObject := UserEngine.GetPlayObject(sMsg);
      if TargetObject <> nil then begin
        if TargetObject.m_boRemoteMsg then begin
          sLabel := Copy(sLabel, 2, Length(sLabel) - 1);
          sSENDMSG := '��ĺ��� ' + User.m_sCharName + ' ���㷢������\ \<���Ÿ���/' + sLabel + '>\';
          SendMsgToUser(TargetObject, sSENDMSG);
        end else begin
          User.SysMsg(sMsg + '��ĺ��� ' + TargetObject.m_sCharName + ' �ܾ����ܸ���������', c_Red, t_Hint);
        end;
      end else begin
        User.SysMsg(sMsg + g_sUserNotOnLine {'  û�����ߣ�����'}, c_Red, t_Hint);
      end;
    end;
  end;

  procedure AutoGetExp(User: TPlayObject; sMsg: string);
  begin
    User.m_sAutoSendMsg := sMsg;
    //User.SysMsg('�һ��ɹ�������', c_Red, t_Hint);
  end;

  procedure DealGold(User: TPlayObject; sMsg: string);
  var
    PoseHuman: TPlayObject;
    nGameGold: Integer;
  begin
    nGameGold := Str_ToInt(sMsg, -1);
    if User.m_nDealGoldPose <> 1 then begin
      GotoLable(User, '@dealgoldPlayError', False);
      Exit;
    end;
    User.m_nDealGoldPose := 2;
    if nGameGold <= 0 then begin
      GotoLable(User, '@dealgoldInputFail', False);
    end else begin
      if User.m_nGameGold >= nGameGold then begin
        PoseHuman := TPlayObject(User.GetPoseCreate());
        if (PoseHuman <> nil) and (TPlayObject(PoseHuman.GetPoseCreate) = User) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
          Inc(PoseHuman.m_nGameGold, nGameGold);
          Dec(User.m_nGameGold, nGameGold);
          PoseHuman.GameGoldChanged;
          User.GameGoldChanged;
          SendMsgToUser(User, 'ת�ʳɹ���' + #10 + 'ת��' + g_Config.sGameGoldName + '��' + IntToStr(nGameGold) + #9 + '��ǰ' + g_Config.sGameGoldName + '��' + IntToStr(User.m_nGameGold));
          SendMsgToUser(PoseHuman, 'ת�ʳɹ���' + #10 + '����' + g_Config.sGameGoldName + '��' + IntToStr(nGameGold) + #9 + '��ǰ' + g_Config.sGameGoldName + '��' + IntToStr(PoseHuman.m_nGameGold));
        end else begin
          GotoLable(User, '@dealgoldpost', False);
        end;
      end else begin
        GotoLable(User, '@dealgoldFail', False);
      end;
    end;
  end;

  procedure SellItem(User: TPlayObject); //004A1544
  begin
    User.SendMsg(Self, RM_SENDUSERSELL, 0, Integer(Self), 0, 0, '');
  end;
  procedure SellSellItem(User: TPlayObject); //004A1544
  begin
    User.SendMsg(Self, RM_SENDUSERSELLOFFITEM, 0, Integer(Self), 0, 0, '');
  end;

  procedure RepairItem(User: TPlayObject); //004A1570
  begin
    User.SendMsg(Self, RM_SENDUSERREPAIR, 0, Integer(Self), 0, 0, '');
  end;
  procedure MakeDurg(User: TPlayObject); //004A16A0
  var
    i: Integer;
    List14: TList;
    UserItem: pTUserItem;
    StdItem: pTStdItem;
    sSENDMSG: string;
    nSubMenu: Integer;
    nPrice: Integer;
    nStock: Integer;
  begin
    sSENDMSG := '';
    for i := 0 to m_GoodsList.Count - 1 do begin
      List14 := TList(m_GoodsList.Items[i]);
      if List14.Count <= 0 then Continue; //0807 ���ӣ���ֹ����ҩ��Ʒ�б�Ϊ��ʱ����
      UserItem := List14.Items[0];
      if UserItem = nil then Continue;
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem <> nil then begin
        sSENDMSG := sSENDMSG + StdItem.Name + '/' + IntToStr(0) + '/' + IntToStr(g_Config.nMakeDurgPrice) + '/' + IntToStr(1) + '/';
      end;
    end;
    if sSENDMSG <> '' then
      User.SendMsg(Self, RM_USERMAKEDRUGITEMLIST, 0, Integer(Self), 0, 0, sSENDMSG);
  end;
  procedure ItemPrices(User: TPlayObject); //
  begin

  end;
  procedure Storage(User: TPlayObject); //004A1648
  begin
    User.SendMsg(Self, RM_USERSTORAGEITEM, 0, Integer(Self), 0, 0, '');
  end;
  procedure GetBack(User: TPlayObject); //004A1674
  begin
    User.SendMsg(Self, RM_USERGETBACKITEM, 0, Integer(Self), 0, 0, '');
  end;
  procedure BigStorage(User: TPlayObject); //004A1648
  begin
    User.SendMsg(Self, RM_USERSTORAGEITEM, 0, Integer(Self), 0, 0, '');
  end;
  procedure BigGetBack(User: TPlayObject);
  begin
    User.m_nBigStoragePage := 0;
    User.SendMsg(Self, RM_USERBIGGETBACKITEM, User.m_nBigStoragePage, Integer(Self), 0, 0, '');
  end;
  procedure GetPreviousPage(User: TPlayObject);
  begin
    if User.m_nBigStoragePage > 0 then
      Dec(User.m_nBigStoragePage)
    else User.m_nBigStoragePage := 0;
    User.SendMsg(Self, RM_USERBIGGETBACKITEM, User.m_nBigStoragePage, Integer(Self), 0, 0, '');
  end;
  procedure GetNextPage(User: TPlayObject);
  begin
    Inc(User.m_nBigStoragePage);
    User.SendMsg(Self, RM_USERBIGGETBACKITEM, User.m_nBigStoragePage, Integer(Self), 0, 0, '');
  end;
var
  sLabel, s18, s19, sMsg: string;
  boCanJmp: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TMerchant::UserSelect... Data: %s';
begin
  inherited;
  if not (ClassNameIs(TMerchant.ClassName)) then Exit; //����������� TMerchant ��ִ�����´�����
  try
    if not m_boCastle or not ((m_Castle <> nil) and TUserCastle(m_Castle).m_boUnderWar) and (PlayObject <> nil) then begin
      if not PlayObject.m_boDeath and (sData <> '') and (sData[1] = '@') then begin
        sMsg := GetValidStr3(sData, sLabel, [#13]);
        s18 := '';
        PlayObject.m_sScriptLable := sData;
        boCanJmp := PlayObject.LableIsCanJmp(sLabel);
        if CompareText(sLabel, sSL_SENDMSG) = 0 then begin
          if sMsg = '' then Exit;
        end;
        GotoLable(PlayObject, sLabel, not boCanJmp);
        if not boCanJmp then Exit;
        s18 := Copy(sLabel, 1, Length(sRMST));
        if CompareText(sLabel, sSL_SENDMSG) = 0 then begin
          if m_boSendmsg then SendCustemMsg(PlayObject, sMsg);
        end else
          if CompareText(sLabel, sSUPERREPAIR) = 0 then begin
          if m_boS_repair then SuperRepairItem(PlayObject);
        end else
          if CompareText(sLabel, sBUY) = 0 then begin
          if m_boBuy then BuyItem(PlayObject, 0);
        end else
          if CompareText(s18, sRMST) = 0 then begin //���ܸ���
          if m_boofflinemsg then RemoteMsg(PlayObject, sLabel, sMsg);
        end else
          if CompareText(sLabel, sofflinemsg) = 0 then begin //���߹һ�
          if m_boofflinemsg then AutoGetExp(PlayObject, sMsg);
        end else
          if CompareText(sLabel, sGETSELLGOLD) = 0 then begin
          if m_boGetSellGold then GetSellGold(PlayObject);
        end else
          if CompareText(sLabel, sBUYOFF) = 0 then begin
          if m_boBuyOff then BuySellItem(PlayObject);
        end else
          if CompareText(sLabel, sSELLOFF) = 0 then begin
          if m_boBuyOff then SellSellItem(PlayObject);
        end else
          if CompareText(sLabel, sdealgold) = 0 then begin
          if m_boDealGold then DealGold(PlayObject, sMsg);
        end else
          if CompareText(sLabel, sSELL) = 0 then begin
          if m_boSell then SellItem(PlayObject);
        end else
          if CompareText(sLabel, sREPAIR) = 0 then begin
          if m_boRepair then RepairItem(PlayObject);
        end else
          if CompareText(sLabel, sMAKEDURG) = 0 then begin
          if m_boMakeDrug then MakeDurg(PlayObject);
        end else
          if CompareText(sLabel, sPRICES) = 0 then begin
          if m_boPrices then ItemPrices(PlayObject);
        end else
          if CompareText(sLabel, sSTORAGE) = 0 then begin
          if m_boStorage then Storage(PlayObject);
        end else
          if CompareText(sLabel, sGETBACK) = 0 then begin
          if m_boGetback then GetBack(PlayObject);
        end else
          if CompareText(sLabel, sBIGSTORAGE) = 0 then begin
          if m_boBigStorage then BigStorage(PlayObject);
        end else
          if CompareText(sLabel, sBIGGETBACK) = 0 then begin
          if m_boBigGetback then BigGetBack(PlayObject);
        end else

          if CompareText(sLabel, sGETPREVIOUSPAGE) = 0 then begin
          if m_boBigGetback then GetPreviousPage(PlayObject);
        end else
          if CompareText(sLabel, sGETNEXTPAGE) = 0 then begin
          if m_boBigGetback then GetNextPage(PlayObject);
        end else

          if CompareText(sLabel, sUPGRADENOW) = 0 then begin
          if m_boUpgradenow then UpgradeWapon(PlayObject);
        end else
          if CompareText(sLabel, sGETBACKUPGNOW) = 0 then begin
          if m_boGetBackupgnow then GetBackupgWeapon(PlayObject);
        end else
          if CompareText(sLabel, sGETMARRY) = 0 then begin
          if m_boGetMarry then GetBackupgWeapon(PlayObject);
        end else
          if CompareText(sLabel, sGETMASTER) = 0 then begin
          if m_boGetMaster then GetBackupgWeapon(PlayObject);
        end else
          if CompareLStr(sLabel, sUSEITEMNAME, Length(sUSEITEMNAME)) then begin
          if m_boUseItemName then ChangeUseItemName(PlayObject, sLabel, sMsg);
        end else
          if CompareText(sLabel, sEXIT) = 0 then begin
          PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
        end else
          if CompareText(sLabel, sBACK) = 0 then begin
          if PlayObject.m_sScriptGoBackLable = '' then PlayObject.m_sScriptGoBackLable := sMAIN;
          GotoLable(PlayObject, PlayObject.m_sScriptGoBackLable, False);
        end else begin
          if Assigned(zPlugOfEngine.PlayObjectUserSelect) then begin
            try
              zPlugOfEngine.PlayObjectUserSelect(Self, PlayObject, PChar(sLabel), PChar(sMsg));
            except
            end;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(format(sExceptionMsg, [sData]));
  end;
end;

procedure TMerchant.Run();
var
  nCheckCode: Integer;
resourcestring
  sExceptionMsg1 = '[Exception] TMerchant::Run... Code = %d';
  sExceptionMsg2 = '[Exception] TMerchant::Run -> Move Code = %d';
begin
  nCheckCode := 0;
  try
    if (GetTickCount - dwRefillGoodsTick) > 30000 then begin
      //if (GetTickCount - dwTick578) > 3000 then begin
      dwRefillGoodsTick := GetTickCount();
      RefillGoods();
    end;

    nCheckCode := 1;
    if (GetTickCount - dwClearExpreUpgradeTick) > 10 * 60 * 1000 then begin
      dwClearExpreUpgradeTick := GetTickCount();
      ClearExpreUpgradeListData();
    end;
    nCheckCode := 2;
    if Random(50) = 0 then begin
      TurnTo(Random(8));
    end else begin
      if Random(50) = 0 then
        SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
    end;
    nCheckCode := 3;
    //    if m_boCastle and (UserCastle.m_boUnderWar)then begin
    if m_boCastle and (m_Castle <> nil) and TUserCastle(m_Castle).m_boUnderWar then begin
      if not m_boFixedHideMode then begin
        SendRefMsg(RM_DISAPPEAR, 0, 0, 0, 0, '');
        m_boFixedHideMode := True;
      end;
    end else begin
      if m_boFixedHideMode then begin
        m_boFixedHideMode := False;
        SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
      end;
    end;
    nCheckCode := 4;
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg1, [nCheckCode]));
      MainOutMessage(E.Message);
    end;
  end;
  try
    if m_boCanMove and (GetTickCount - m_dwMoveTick > m_dwMoveTime * 1000) then begin
      m_dwMoveTick := GetTickCount();
      SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
      MapRandomMove(m_sMapName, 0);
    end;
  except
    on E: Exception do begin
      MainOutMessage(format(sExceptionMsg2, [nCheckCode]));
      MainOutMessage(E.Message);
    end;
  end;
  inherited;
end;

function TMerchant.Operate(ProcessMsg: pTProcessMessage): Boolean;
begin
  Result := inherited Operate(ProcessMsg);
end;

procedure TMerchant.LoadNPCData;
var
  sFile: string;
begin
  sFile := m_sScript + '-' + m_sMapName;
  FrmDB.LoadGoodRecord(Self, sFile);
  FrmDB.LoadGoodPriceRecord(Self, sFile);
  LoadUpgradeList();
end;

procedure TMerchant.SaveNPCData;
var
  sFile: string;
begin
  sFile := m_sScript + '-' + m_sMapName;
  FrmDB.SaveGoodRecord(Self, sFile);
  FrmDB.SaveGoodPriceRecord(Self, sFile);
end;

constructor TMerchant.Create; //0049EC70
begin
  inherited;
  m_btRaceImg := RCC_MERCHANT;
  m_wAppr := 0;
  m_nPriceRate := 100;
  m_boCastle := False;
  m_ItemTypeList := TList.Create;
  m_RefillGoodsList := TList.Create;
  m_GoodsList := TList.Create;
  m_ItemPriceList := TList.Create;
  m_UpgradeWeaponList := TList.Create;

  dwRefillGoodsTick := GetTickCount();
  dwClearExpreUpgradeTick := GetTickCount();
  m_boBuy := False;
  m_boSell := False;
  m_boMakeDrug := False;
  m_boPrices := False;
  m_boStorage := False;
  m_boGetback := False;
  m_boBigStorage := False;
  m_boBigGetback := False;
  m_boGetNextPage := False;
  m_boGetPreviousPage := False;

  m_boUpgradenow := False;
  m_boGetBackupgnow := False;
  m_boRepair := False;
  m_boS_repair := False;
  m_boGetMarry := False;
  m_boGetMaster := False;
  m_boUseItemName := False;

  m_boGetSellGold := False;
  m_boSellOff := False;
  m_boBuyOff := False;
  m_boofflinemsg := False;
  m_boDealGold := False;
  m_dwMoveTick := GetTickCount();
end;

destructor TMerchant.Destroy; //0049ED70
var
  i: Integer;
  ii: Integer;
  List: TList;
begin
  m_ItemTypeList.Free;
  for i := 0 to m_RefillGoodsList.Count - 1 do begin
    DisPose(pTGoods(m_RefillGoodsList.Items[i]));
  end;
  m_RefillGoodsList.Free;
  for i := 0 to m_GoodsList.Count - 1 do begin
    List := TList(m_GoodsList.Items[i]);
    for ii := 0 to List.Count - 1 do begin
      DisPose(pTUserItem(List.Items[ii]));
    end;
    List.Free;
  end;
  m_GoodsList.Free;

  for i := 0 to m_ItemPriceList.Count - 1 do begin
    DisPose(pTItemPrice(m_ItemPriceList.Items[i]));
  end;
  m_ItemPriceList.Free;
  for i := 0 to m_UpgradeWeaponList.Count - 1 do begin
    DisPose(pTUpgradeInfo(m_UpgradeWeaponList.Items[i]));
  end;
  m_UpgradeWeaponList.Free;

  inherited;
end;

procedure TMerchant.ClearExpreUpgradeListData; //004A01A0
var
  i: Integer;
  UpgradeInfo: pTUpgradeInfo;
begin
  for i := m_UpgradeWeaponList.Count - 1 downto 0 do begin
    if m_UpgradeWeaponList.Count <= 0 then break;
    UpgradeInfo := m_UpgradeWeaponList.Items[i];
    if UpgradeInfo = nil then Continue;
    if Integer(ROUND(Now - UpgradeInfo.dtTime)) >= g_Config.nClearExpireUpgradeWeaponDays then begin
      DisPose(UpgradeInfo);
      m_UpgradeWeaponList.Delete(i);
    end;
  end;
end;

procedure TMerchant.LoadNpcScript;
var
  SC: string;
begin
  m_ItemTypeList.Clear;
  m_sPath := sMarket_Def;
  SC := m_sScript + '-' + m_sMapName;
  FrmDB.LoadScriptFile(Self, sMarket_Def, SC, True);
  //  call    sub_49ABE0
end;

procedure TMerchant.Click(PlayObject: TPlayObject); //0049FF24
begin
  //  GotoLable(PlayObject,'@main');
  inherited;
end;

procedure TMerchant.GetVariableText(PlayObject: TPlayObject;
  var sMsg: string; sVariable: string); //0049FD04
var
  sText, s14: string;
  n18: Integer;
begin
  inherited;
  if sVariable = '$PRICERATE' then begin
    sText := IntToStr(m_nPriceRate);
    sMsg := sub_49ADB8(sMsg, '<$PRICERATE>', sText);
  end;
  if sVariable = '$UPGRADEWEAPONFEE' then begin
    sText := IntToStr(g_Config.nUpgradeWeaponPrice);
    sMsg := sub_49ADB8(sMsg, '<$UPGRADEWEAPONFEE>', sText);
  end;
  if sVariable = '$USERWEAPON' then begin
    if PlayObject.m_UseItems[U_WEAPON].wIndex <> 0 then begin
      sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_WEAPON].wIndex);
    end else begin
      sText := '��';
    end;
    sMsg := sub_49ADB8(sMsg, '<$USERWEAPON>', sText);
  end;
end;

function TMerchant.GetUserItemPrice(UserItem: pTUserItem): Integer;
var
  n10: Integer;
  StdItem: pTStdItem;
  n20: real;
  nC: Integer;
  n14: Integer;
begin
  n10 := GetItemPrice(UserItem.wIndex);
  if n10 > 0 then begin
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and
      (StdItem.StdMode > 4) and
      (StdItem.DuraMax > 0) and
      (UserItem.DuraMax > 0) then begin
      if StdItem.StdMode = 40 then begin //��
        if UserItem.Dura <= UserItem.DuraMax then begin
          n20 := (n10 / 2.0 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
          n10 := _MAX(2, ROUND(n10 - n20));
        end else begin
          n10 := n10 + ROUND(n10 / UserItem.DuraMax * 2.0 * (UserItem.DuraMax - UserItem.Dura));
        end;
      end;
      if (StdItem.StdMode = 43) then begin
        if UserItem.DuraMax < 10000 then UserItem.DuraMax := 10000;
        if UserItem.Dura <= UserItem.DuraMax then begin
          n20 := (n10 / 2.0 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
          n10 := _MAX(2, ROUND(n10 - n20));
        end else begin
          n10 := n10 + ROUND(n10 / UserItem.DuraMax * 1.3 * (UserItem.DuraMax - UserItem.Dura));
        end;
      end;
      if StdItem.StdMode > 4 then begin
        n14 := 0;
        nC := 0;
        while (True) do begin
          if (StdItem.StdMode = 5) or (StdItem.StdMode = 6) then begin
            if (nC <> 4) or (nC <> 9) then begin
              if nC = 6 then begin
                if UserItem.btValue[nC] > 10 then begin
                  n14 := n14 + (UserItem.btValue[nC] - 10) * 2;
                end;
              end else begin
                n14 := n14 + UserItem.btValue[nC];
              end;
            end;
          end else begin
            Inc(n14, UserItem.btValue[nC]);
          end;
          Inc(nC);
          if nC >= 8 then break;
        end;
        if n14 > 0 then begin
          n10 := n10 div 5 * n14;
        end;
        n10 := ROUND(n10 / StdItem.DuraMax * UserItem.DuraMax);
        n20 := (n10 / 2.0 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
        n10 := _MAX(2, ROUND(n10 - n20));
      end;
    end;
  end;
  Result := n10;
end;

procedure TMerchant.ClientBuyItem(PlayObject: TPlayObject; sItemName: string;
  nInt: Integer);
var
  i, ii: Integer;
  bo29: Boolean;
  List20: TList;
  ItemPrice: pTItemPrice;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  n1C, nPrice: Integer;
  sUserItemName: string;
begin
  bo29 := False;
  n1C := 1;
  i := 0;
  while True do begin //for i := 0 to m_GoodsList.Count - 1 do begin
    if i >= m_GoodsList.Count then break;
    if m_GoodsList.Count <= 0 then break;
    if bo29 or (bo574) then break;
    List20 := TList(m_GoodsList.Items[i]);
    if List20 = nil then Continue;
    if List20.Count <= 0 then Continue;
    UserItem := List20.Items[0];
    //ȡ�Զ�����Ʒ����
    sUserItemName := '';
    if UserItem.btValue[13] = 1 then
      sUserItemName := ItemUnit.GetCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
    if sUserItemName = '' then
      sUserItemName := UserEngine.GetStdItemName(UserItem.wIndex);

    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if StdItem <> nil then begin
      if PlayObject.IsAddWeightAvailable(StdItem.Weight) then begin
        if sUserItemName = sItemName then begin
          ii := 0;
          while True do begin //for ii := 0 to List20.Count - 1 do begin
            if ii >= List20.Count then break;
            if List20.Count <= 0 then break;
            UserItem := List20.Items[ii];
            if (StdItem.StdMode <= 4) or
              (StdItem.StdMode = 42) or
              (StdItem.StdMode = 31) or
              (UserItem.MakeIndex = nInt) then begin

              nPrice := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
              if (PlayObject.m_nGold >= nPrice) and (nPrice > 0) then begin
                if PlayObject.AddItemToBag(UserItem) then begin
                  Dec(PlayObject.m_nGold, nPrice);
                  if m_boCastle or g_Config.boGetAllNpcTax then begin
                    if m_Castle <> nil then begin
                      TUserCastle(m_Castle).IncRateGold(nPrice);
                    end else
                      if g_Config.boGetAllNpcTax then begin
                      g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
                    end;
                  end;
                  {
                  if m_boCastle or g_Config.boGetAllNpcTax then
                    UserCastle.IncRateGold(nPrice);
                  }
                  PlayObject.SendAddItem(UserItem);
                  //004A25DC
                  if StdItem.NeedIdentify = 1 then
                    AddGameDataLog('9' + #9 +
                      PlayObject.m_sMapName + #9 +
                      IntToStr(PlayObject.m_nCurrX) + #9 +
                      IntToStr(PlayObject.m_nCurrY) + #9 +
                      PlayObject.m_sCharName + #9 +
                      //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                      StdItem.Name + #9 +
                      IntToStr(UserItem.MakeIndex) + #9 +
                      '1' + #9 +
                      m_sCharName);

                  List20.Delete(ii);
                  if List20.Count <= 0 then begin
                    List20.Free;
                    m_GoodsList.Delete(i);
                  end;
                  n1C := 0;
                end else n1C := 2;
              end else n1C := 3;
              bo29 := True;
              break;
            end;
            Inc(ii);
          end;
        end;
      end else n1C := 2; //004A2639
    end;
    Inc(i);
  end; // for
  if n1C = 0 then begin
    PlayObject.SendMsg(Self, RM_BUYITEM_SUCCESS, 0, PlayObject.m_nGold, nInt, 0, '');
  end else begin
    PlayObject.SendMsg(Self, RM_BUYITEM_FAIL, 0, n1C, 0, 0, '');
  end;
end;

procedure TMerchant.ClientGetDetailGoodsList(PlayObject: TPlayObject; sItemName: string;
  nInt: Integer);
var
  i, ii, n18: Integer;
  List20: TList;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  s1C: string;
begin
  if Assigned(zPlugOfEngine.MerchantClientGetDetailGoodsList) then begin
    zPlugOfEngine.MerchantClientGetDetailGoodsList(Self, PlayObject, PChar(sItemName), nInt);
  end else begin
    if PlayObject.m_nSoftVersionDateEx = 0 then begin
      n18 := 0;
      for i := 0 to m_GoodsList.Count - 1 do begin
        List20 := TList(m_GoodsList.Items[i]);
        if List20 = nil then Continue;
        if List20.Count <= 0 then Continue;
        UserItem := List20.Items[0];
        if UserItem = nil then Continue;
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if (StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0) then begin
          if (List20.Count - 1) < nInt then begin
            nInt := _MAX(0, List20.Count - 10);
          end;
          for ii := List20.Count - 1 downto 0 do begin
            if List20.Count <= 0 then break;
            UserItem := List20.Items[ii];
            if UserItem <> nil then begin
              CopyStdItemToOStdItem(StdItem, @OClientItem.s);
              OClientItem.Dura := UserItem.Dura;
              OClientItem.DuraMax := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
              OClientItem.MakeIndex := UserItem.MakeIndex;
              s1C := s1C + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
              Inc(n18);
              if n18 >= 10 then break;
            end;
          end;
          break;
        end;
      end;
      PlayObject.SendMsg(Self, RM_SENDDETAILGOODSLIST, 0, Integer(Self), n18, nInt, s1C);
    end else begin
      n18 := 0;
      for i := 0 to m_GoodsList.Count - 1 do begin
        List20 := TList(m_GoodsList.Items[i]);
        if List20 = nil then Continue;
        if List20.Count <= 0 then Continue;
        UserItem := List20.Items[0];
        if UserItem = nil then Continue;
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if (StdItem <> nil) and (StdItem.Name = sItemName) then begin
          if (List20.Count - 1) < nInt then begin
            nInt := _MAX(0, List20.Count - 10);
          end;
          for ii := List20.Count - 1 downto 0 do begin
            if List20.Count <= 0 then break;
            UserItem := List20.Items[ii];
            if UserItem <> nil then begin
              ClientItem.s := StdItem^;
              ClientItem.Dura := UserItem.Dura;
              ClientItem.DuraMax := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
              ClientItem.MakeIndex := UserItem.MakeIndex;
              s1C := s1C + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
              Inc(n18);
              if n18 >= 10 then break;
            end;
          end;
          break;
        end;
      end;
      PlayObject.SendMsg(Self, RM_SENDDETAILGOODSLIST, 0, Integer(Self), n18, nInt, s1C);
    end;
  end;
end;

procedure TMerchant.ClientQuerySellPrice(PlayObject: TPlayObject;
  UserItem: pTUserItem);
var
  nC: Integer;
begin
  nC := GetSellItemPrice(GetUserItemPrice(UserItem));
  if (nC >= 0) then begin
    PlayObject.SendMsg(Self, RM_SENDBUYPRICE, 0, nC, 0, 0, '');
  end else begin
    PlayObject.SendMsg(Self, RM_SENDBUYPRICE, 0, 0, 0, 0, '');
  end;
end;

function TMerchant.GetSellItemPrice(nPrice: Integer): Integer;
begin
  Result := ROUND(nPrice / 2.0);
end;

function TMerchant.ClientSellItem(PlayObject: TPlayObject;
  UserItem: pTUserItem): Boolean;
  function sub_4A1C84(UserItem: pTUserItem): Boolean;
  var
    StdItem: pTStdItem;
  begin
    Result := True;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and ((StdItem.StdMode = 25) or (StdItem.StdMode = 30)) then begin
      if UserItem.Dura < 4000 then Result := False;
    end;
  end;
var
  nPrice: Integer;
  StdItem: pTStdItem;
begin
  Result := False;
  nPrice := GetSellItemPrice(GetUserItemPrice(UserItem));
  if (nPrice > 0) and (not bo574) and
    sub_4A1C84(UserItem) then begin
    if PlayObject.IncGold(nPrice) then begin
      {
      if m_boCastle or g_Config.boGetAllNpcTax then
        UserCastle.IncRateGold(nPrice);
      }
      if m_boCastle or g_Config.boGetAllNpcTax then begin
        if m_Castle <> nil then begin
          TUserCastle(m_Castle).IncRateGold(nPrice);
        end else
          if g_Config.boGetAllNpcTax then begin
          g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
        end;
      end;
      PlayObject.SendMsg(Self, RM_USERSELLITEM_OK, 0, PlayObject.m_nGold, 0, 0, '');
      AddItemToGoodsList(UserItem);
      StdItem := UserEngine.GetStdItem(UserItem.wIndex);
      if StdItem.NeedIdentify = 1 then
        AddGameDataLog('10' + #9 +
          PlayObject.m_sMapName + #9 +
          IntToStr(PlayObject.m_nCurrX) + #9 +
          IntToStr(PlayObject.m_nCurrY) + #9 +
          PlayObject.m_sCharName + #9 +
          //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
          StdItem.Name + #9 +
          IntToStr(UserItem.MakeIndex) + #9 +
          '1' + #9 +
          m_sCharName);
      Result := True;
    end else begin
      PlayObject.SendMsg(Self, RM_USERSELLITEM_FAIL, 0, 0, 0, 0, '');
    end;
  end else begin
    PlayObject.SendMsg(Self, RM_USERSELLITEM_FAIL, 0, 0, 0, 0, '');
  end;
end;

function TMerchant.AddItemToGoodsList(UserItem: pTUserItem): Boolean;
var
  n10: Integer;
  ItemList: TList;
begin
  Result := False;
  if UserItem.Dura <= 0 then Exit;
  ItemList := GetRefillList(UserItem.wIndex);
  if ItemList = nil then begin
    ItemList := TList.Create;
    m_GoodsList.Add(ItemList);
  end;
  ItemList.Insert(0, UserItem);
  Result := True;
end;
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////����/////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
//������Ʒ���� �־��Ƿ����0  �۸�������Լ���Ϊ��  ����
procedure TMerchant.ClientGetDetailSellGoodsList(PlayObject: TPlayObject; sItemName: string;
  nInt: Integer); //004A26F0
var
  i, ii, n18: Integer;
  List20: TList;
  StdItem: pTStdItem;
  ClientItem: TClientItem;
  OClientItem: TOClientItem;
  s1C: string;
  SellOffInfo: pTSellOffInfo;
  nPrice: Integer;
begin
  if PlayObject.m_nSoftVersionDateEx = 0 then begin
    n18 := 0;
    s1C := '';
    g_SellOffGoodList.GetUserSellOffGoodListByItemName(sItemName, List20);
    if List20 <> nil then begin
      SellOffInfo := List20.Items[0];
      if SellOffInfo = nil then Exit;
      StdItem := UserEngine.GetStdItem(SellOffInfo.UseItems.wIndex);
      if StdItem <> nil then begin
        if (List20.Count - 1) < nInt then begin
          nInt := _MAX(0, List20.Count - 10);
        end;
        for ii := List20.Count - 1 downto 0 do begin
          if List20.Count <= 0 then break;
          SellOffInfo := pTSellOffInfo(List20.Items[ii]);
          if SellOffInfo = nil then Continue;
          CopyStdItemToOStdItem(StdItem, @OClientItem.s);
          if CompareText(PlayObject.m_sCharName, SellOffInfo.sCharName) = 0 then begin
            OClientItem.s.Price := -SellOffInfo.nSellGold;
          end else begin
            OClientItem.s.Price := SellOffInfo.nSellGold;
          end;
          OClientItem.Dura := SellOffInfo.UseItems.Dura;
          OClientItem.DuraMax := SellOffInfo.UseItems.DuraMax;
          OClientItem.MakeIndex := SellOffInfo.UseItems.MakeIndex;
          s1C := s1C + EncodeBuffer(@OClientItem, SizeOf(TOClientItem)) + '/';
          Inc(n18);
        end;
      end;
    end;
    PlayObject.SendMsg(Self, RM_SENDSELLOFFITEMLIST, 0, Integer(Self), n18, nInt, s1C);
  end else begin
    n18 := 0;
    s1C := '';
    g_SellOffGoodList.GetUserSellOffGoodListByItemName(sItemName, List20);
    if List20 <> nil then begin
      SellOffInfo := List20.Items[0];
      if SellOffInfo = nil then Exit;
      StdItem := UserEngine.GetStdItem(SellOffInfo.UseItems.wIndex);
      if StdItem <> nil then begin
        if (List20.Count - 1) < nInt then begin
          nInt := _MAX(0, List20.Count - 10);
        end;
        for ii := List20.Count - 1 downto 0 do begin
          if List20.Count <= 0 then break;
          SellOffInfo := List20.Items[ii];
          ClientItem.s := StdItem^;
          if SellOffInfo = nil then Continue;
          if CompareText(PlayObject.m_sCharName, SellOffInfo.sCharName) = 0 then begin
            ClientItem.s.Price := -SellOffInfo.nSellGold;
          end else begin
            ClientItem.s.Price := SellOffInfo.nSellGold;
          end;
          ClientItem.Dura := SellOffInfo.UseItems.Dura;
          ClientItem.DuraMax := SellOffInfo.UseItems.DuraMax;
          ClientItem.MakeIndex := SellOffInfo.UseItems.MakeIndex;
          s1C := s1C + EncodeBuffer(@ClientItem, SizeOf(TClientItem)) + '/';
          Inc(n18);
        end;
      end;
    end;
  end;
  PlayObject.SendMsg(Self, RM_SENDSELLOFFITEMLIST, 0, Integer(Self), n18, nInt, s1C);
end;

procedure TMerchant.ClientBuySellOffItem(PlayObject: TPlayObject; sItemName: string;
  nInt: Integer);
var
  i, ii: Integer;
  bo29: Boolean;
  List20: TList;
  ItemPrice: pTItemPrice;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  n1C, nPrice: Integer;
  sUserItemName: string;
  SellOffInfo: pTSellOffInfo;
  AddSellOffInfo: pTSellOffInfo;
  OnLinePlayObject: TPlayObject;
begin
  //n1C = 1 ��Ʒ�Ѿ�������  n1C = 2 �޷�Я���������Ʒ n1C = 3 û���㹻��Ԫ��������Ʒ
  bo29 := False;
  n1C := 1;
  if (bo29) or (bo574) then Exit;
  g_SellOffGoodList.GetUserSellOffItem(sItemName, nInt, SellOffInfo, StdItem);
  if (SellOffInfo <> nil) and (StdItem <> nil) then begin
    if PlayObject.IsAddWeightAvailable(StdItem.Weight) then begin
      if CompareText(PlayObject.m_sCharName, SellOffInfo.sCharName) = 0 then begin
        New(UserItem);
        UserItem^ := SellOffInfo.UseItems;
        {UserItem^.MakeIndex := SellOffInfo.UseItems.MakeIndex;
        UserItem^.wIndex := SellOffInfo.UseItems.MakeIndex;
        UserItem^.Dura := SellOffInfo.UseItems.Dura;
        UserItem^.DuraMax := SellOffInfo.UseItems.DuraMax;
        UserItem^.btValue := SellOffInfo.UseItems.btValue; }
        if PlayObject.AddItemToBag(UserItem) then begin
          PlayObject.SendAddItem(UserItem);
          g_SellOffGoodList.DelSellOffItem(UserItem.MakeIndex);
          bo29 := True;
          n1C := 0;
        end else n1C := 2;
      end else
        if (PlayObject.m_nGameGold >= SellOffInfo.nSellGold) and (SellOffInfo.nSellGold > 0) then begin
        New(UserItem);
        UserItem^ := SellOffInfo.UseItems;
        {UserItem.MakeIndex := SellOffInfo.UseItems.MakeIndex;
        UserItem.wIndex := SellOffInfo.UseItems.MakeIndex;
        UserItem.Dura := SellOffInfo.UseItems.Dura;
        UserItem.DuraMax := SellOffInfo.UseItems.DuraMax;
        UserItem.btValue := SellOffInfo.UseItems.btValue; }
        if PlayObject.AddItemToBag(UserItem) then begin
          Dec(PlayObject.m_nGameGold, SellOffInfo.nSellGold);
          PlayObject.SendAddItem(UserItem);
          New(AddSellOffInfo);
          AddSellOffInfo^ := SellOffInfo^;
          {AddSellOffInfo.sCharName := SellOffInfo.sCharName;
          AddSellOffInfo.dSellDateTime := SellOffInfo.dSellDateTime;
          AddSellOffInfo.nSellGold := SellOffInfo.nSellGold;
          AddSellOffInfo.n := SellOffInfo.n;
          AddSellOffInfo.UseItems := SellOffInfo.UseItems;
          AddSellOffInfo.n1 := SellOffInfo.n1;  }
          g_SellOffGoldList.AddItemToSellOffGoldList(AddSellOffInfo);
          g_SellOffGoodList.DelSellOffItem(UserItem.MakeIndex);
          PlayObject.GameGoldChanged;
          OnLinePlayObject := UserEngine.GetPlayObject(SellOffInfo.sCharName);
          if OnLinePlayObject <> nil then begin
            OnLinePlayObject.SysMsg(PlayObject.m_sCharName + ' ��������� ' + sItemName, c_Red, t_Hint);
          end;
          n1C := 0;
        end else n1C := 2;
      end else n1C := 3;
      bo29 := True;
    end else n1C := 2;
  end;
  if n1C = 0 then begin
    PlayObject.SendMsg(Self, RM_SENDBUYSELLOFFITEM_OK, 0, PlayObject.m_nGameGold, nInt, 0, '');
  end else begin
    PlayObject.SendMsg(Self, RM_SENDBUYSELLOFFITEM_FAIL, 0, n1C, 0, 0, '');
  end;
end;

function TMerchant.ClientSellOffItem(PlayObject: TPlayObject;
  SellOffInfo: pTSellOffInfo; sName: string): Boolean;
  function sub_4A1C84(UserItem: pTUserItem): Boolean;
  var
    StdItem: pTStdItem;
  begin
    Result := True;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and ((StdItem.StdMode = 25) or (StdItem.StdMode = 30)) then begin
      if UserItem.Dura < 4000 then Result := False;
    end;
  end;
var
  nPrice: Integer;
  StdItem: pTStdItem;
begin
  Result := False;
  if not CanSellOffItem(sName) then begin
    PlayObject.SendMsg(Self, RM_SENDUSERSELLOFFITEM_FAIL, 0, -4, 0, 0, ''); //����������
    DisPose(SellOffInfo);
    Exit;
  end;
  if g_SellOffGoodList.GetUserLimitSellOffCount(SellOffInfo.sCharName) then begin //������������
    PlayObject.SendMsg(Self, RM_SENDUSERSELLOFFITEM_FAIL, 0, -3, 0, 0, ''); //������������
    DisPose(SellOffInfo);
    Exit;
  end;
  if (not bo574) and sub_4A1C84(@SellOffInfo.UseItems) then begin
    if g_SellOffGoodList.AddItemToSellOffGoodsList(SellOffInfo) then begin
      PlayObject.SendMsg(Self, RM_SENDUSERSELLOFFITEM_OK, 0, 0, 0, 0, '');
      //g_SellOffGoodList.SaveSellOffGoodList();
      Result := True;
    end else begin
      PlayObject.SendMsg(Self, RM_SENDUSERSELLOFFITEM_FAIL, 0, -1, 0, 0, '');
    end;
  end else begin //004A1EA0
    PlayObject.SendMsg(Self, RM_SENDUSERSELLOFFITEM_FAIL, 0, -2, 0, 0, '');
  end;
end;
////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////����/////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

procedure TMerchant.ClientMakeDrugItem(PlayObject: TPlayObject;
  sItemName: string);
  function sub_4A28FC(PlayObject: TPlayObject; sItemName: string): Boolean;
  var
    i, ii, n1C: Integer;
    List10: TStringList;
    s20: string;
    List28: TStringList;
    UserItem: pTUserItem;
  begin
    Result := False;
    List10 := GetMakeItemInfo(sItemName);
    if List10 = nil then Exit;
    Result := True;
    for i := 0 to List10.Count - 1 do begin
      s20 := List10.Strings[i];
      n1C := Integer(List10.Objects[i]);
      for ii := 0 to PlayObject.m_ItemList.Count - 1 do begin
        if UserEngine.GetStdItemName(pTUserItem(PlayObject.m_ItemList.Items[ii]).wIndex) = s20 then
          Dec(n1C);
      end;
      if n1C > 0 then begin
        Result := False;
        break;
      end;
    end; // for
    if Result then begin
      List28 := nil;
      for i := 0 to List10.Count - 1 do begin
        s20 := List10.Strings[i];
        n1C := Integer(List10.Objects[i]);
        for ii := PlayObject.m_ItemList.Count - 1 downto 0 do begin
          if n1C <= 0 then break;
          if PlayObject.m_ItemList.Count <= 0 then break;
          UserItem := PlayObject.m_ItemList.Items[ii];
          if UserItem = nil then Continue;
          if UserEngine.GetStdItemName(UserItem.wIndex) = s20 then begin
            if List28 = nil then List28 := TStringList.Create;
            List28.AddObject(s20, TObject(UserItem.MakeIndex));
            DisPose(UserItem);
            PlayObject.m_ItemList.Delete(ii);
            Dec(n1C);
          end;
        end;
      end;
      if List28 <> nil then begin
        PlayObject.SendMsg(Self, RM_SENDDELITEMLIST, 0, Integer(List28), 0, 0, '');
      end;
    end;
  end;
var
  i: Integer;
  List1C: TList;
  MakeItem, UserItem: pTUserItem;
  StdItem: pTStdItem;
  n14: Integer;
begin
  n14 := 1;
  for i := 0 to m_GoodsList.Count - 1 do begin
    List1C := TList(m_GoodsList.Items[i]);
    if List1C = nil then Continue;
    if List1C.Count <= 0 then Continue;
    MakeItem := List1C.Items[0];
    if MakeItem = nil then Continue;
    StdItem := UserEngine.GetStdItem(MakeItem.wIndex);
    if (StdItem <> nil) and (StdItem.Name = sItemName) then begin
      if PlayObject.m_nGold >= g_Config.nMakeDurgPrice then begin
        if sub_4A28FC(PlayObject, sItemName) then begin
          New(UserItem);
          UserEngine.CopyToUserItemFromName(sItemName, UserItem);
          if PlayObject.AddItemToBag(UserItem) then begin
            Dec(PlayObject.m_nGold, g_Config.nMakeDurgPrice);
            PlayObject.SendAddItem(UserItem);
            StdItem := UserEngine.GetStdItem(UserItem.wIndex);
            if StdItem.NeedIdentify = 1 then
              AddGameDataLog('2' + #9 +
                PlayObject.m_sMapName + #9 +
                IntToStr(PlayObject.m_nCurrX) + #9 +
                IntToStr(PlayObject.m_nCurrY) + #9 +
                PlayObject.m_sCharName + #9 +
                //UserEngine.GetStdItemName(UserItem.wIndex) + #9 +
                StdItem.Name + #9 +
                IntToStr(UserItem.MakeIndex) + #9 +
                '1' + #9 +
                m_sCharName);
            n14 := 0;
            break;
          end else begin
            DisPose(UserItem);
            n14 := 2;
          end;
        end else n14 := 4;
      end else n14 := 3;
    end;
  end; // for
  if n14 = 0 then begin
    PlayObject.SendMsg(Self, RM_MAKEDRUG_SUCCESS, 0, PlayObject.m_nGold, 0, 0, '');
  end else begin
    PlayObject.SendMsg(Self, RM_MAKEDRUG_FAIL, 0, n14, 0, 0, '');
  end;
end;

procedure TMerchant.ClientQueryRepairCost(PlayObject: TPlayObject;
  UserItem: pTUserItem);
var
  nPrice, nRepairPrice: Integer;
begin
  nPrice := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
  if (nPrice > 0) and (UserItem.DuraMax > UserItem.Dura) then begin
    if UserItem.DuraMax > 0 then begin
      nRepairPrice := ROUND(nPrice div 3 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
    end else begin
      nRepairPrice := nPrice;
    end;
    if (PlayObject.m_sScriptLable = sSUPERREPAIR) then begin
      if m_boS_repair then nRepairPrice := nRepairPrice * g_Config.nSuperRepairPriceRate {3}
      else nRepairPrice := -1;
    end else begin
      if not m_boRepair then nRepairPrice := -1;
    end;
    PlayObject.SendMsg(Self, RM_SENDREPAIRCOST, 0, nRepairPrice, 0, 0, '');
  end else begin
    PlayObject.SendMsg(Self, RM_SENDREPAIRCOST, 0, -1, 0, 0, '');
  end;
end;

function TMerchant.ClientRepairItem(PlayObject: TPlayObject;
  UserItem: pTUserItem): Boolean;
var
  nPrice, nRepairPrice: Integer;
  StdItem: pTStdItem;
  boCanRepair: Boolean;
begin
  Result := False;
  boCanRepair := True;
  if (PlayObject.m_sScriptLable = sSUPERREPAIR) and not m_boS_repair then begin
    boCanRepair := False;
  end;
  if (PlayObject.m_sScriptLable <> sSUPERREPAIR) and not m_boRepair then begin
    boCanRepair := False;
  end;
  if PlayObject.m_sScriptLable = '@fail_s_repair' then begin
    SendMsgToUser(PlayObject, 'Sorry, I cant special repair this item\ \ \<Main/@main>');
    PlayObject.SendMsg(Self, RM_USERREPAIRITEM_FAIL, 0, 0, 0, 0, '');
    Exit;
  end;
  nPrice := GetUserPrice(PlayObject, GetUserItemPrice(UserItem));
  if PlayObject.m_sScriptLable = sSUPERREPAIR then begin
    nPrice := nPrice * g_Config.nSuperRepairPriceRate {3};
  end;
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if StdItem <> nil then begin
    if boCanRepair and (nPrice > 0) and (UserItem.DuraMax > UserItem.Dura) and (StdItem.StdMode <> 43) then begin
      if UserItem.DuraMax > 0 then begin
        nRepairPrice := ROUND(nPrice div 3 / UserItem.DuraMax * (UserItem.DuraMax - UserItem.Dura));
      end else begin
        nRepairPrice := nPrice;
      end;
      if PlayObject.DecGold(nRepairPrice) then begin
        //        if m_boCastle or g_Config.boGetAllNpcTax then UserCastle.IncRateGold(nRepairPrice);
        if m_boCastle or g_Config.boGetAllNpcTax then begin
          if m_Castle <> nil then begin
            TUserCastle(m_Castle).IncRateGold(nRepairPrice);
          end else
            if g_Config.boGetAllNpcTax then begin
            g_CastleManager.IncRateGold(g_Config.nUpgradeWeaponPrice);
          end;
        end;
        if PlayObject.m_sScriptLable = sSUPERREPAIR then begin
          UserItem.Dura := UserItem.DuraMax;
          PlayObject.SendMsg(Self, RM_USERREPAIRITEM_OK, 0, PlayObject.m_nGold, UserItem.Dura, UserItem.DuraMax, '');
          GotoLable(PlayObject, sSUPERREPAIROK, False);
        end else begin
          Dec(UserItem.DuraMax, (UserItem.DuraMax - UserItem.Dura) div g_Config.nRepairItemDecDura {30});
          UserItem.Dura := UserItem.DuraMax;
          PlayObject.SendMsg(Self, RM_USERREPAIRITEM_OK, 0, PlayObject.m_nGold, UserItem.Dura, UserItem.DuraMax, '');
          GotoLable(PlayObject, sREPAIROK, False);
        end;
        Result := True;
      end else PlayObject.SendMsg(Self, RM_USERREPAIRITEM_FAIL, 0, 0, 0, 0, ''); //004A2238
    end else PlayObject.SendMsg(Self, RM_USERREPAIRITEM_FAIL, 0, 0, 0, 0, ''); //004A2253
  end;
end;

procedure TMerchant.ClearScript;
begin
  m_boBuy := False;
  m_boSell := False;
  m_boMakeDrug := False;
  m_boPrices := False;
  m_boStorage := False;
  m_boGetback := False;
  m_boBigStorage := False;
  m_boBigGetback := False;
  m_boGetNextPage := False;
  m_boGetPreviousPage := False;
  m_boUpgradenow := False;
  m_boGetBackupgnow := False;
  m_boRepair := False;
  m_boS_repair := False;
  m_boGetMarry := False;
  m_boGetMaster := False;
  m_boUseItemName := False;

  m_boGetSellGold := False;
  m_boSellOff := False;
  m_boBuyOff := False;
  m_boofflinemsg := False;
  m_boDealGold := False;
  inherited;
end;

procedure TMerchant.LoadUpgradeList;
var
  i: Integer;
begin
  for i := 0 to m_UpgradeWeaponList.Count - 1 do begin
    DisPose(pTUpgradeInfo(m_UpgradeWeaponList.Items[i]));
  end; // for
  m_UpgradeWeaponList.Clear;
  try
    //FrmDB.LoadUpgradeWeaponRecord(m_sCharName,m_UpgradeWeaponList);
    FrmDB.LoadUpgradeWeaponRecord(m_sScript + '-' + m_sMapName, m_UpgradeWeaponList);
  except
    MainOutMessage('Failure in loading upgradinglist - ' + m_sCharName);
  end;
end;

procedure TMerchant.GetMarry(PlayObject: TPlayObject; sDearName: string);
var
  MarryHuman: TPlayObject;
begin
  MarryHuman := UserEngine.GetPlayObject(sDearName);
  if (MarryHuman <> nil) and
    (MarryHuman.m_PEnvir = PlayObject.m_PEnvir) and
    (abs(PlayObject.m_nCurrX - MarryHuman.m_nCurrX) < 5) and
    (abs(PlayObject.m_nCurrY - MarryHuman.m_nCurrY) < 5) then begin
    SendMsgToUser(MarryHuman, PlayObject.m_sCharName + ' ������飬���Ƿ�Ը��޸���Ϊ�ޣ�');
  end else begin
    Self.SendMsgToUser(PlayObject, sDearName + ' û��������ߣ����������Ч������');
  end;
end;

procedure TMerchant.GetMaster(PlayObject: TPlayObject; sMasterName: string);
begin

end;

procedure TMerchant.SendCustemMsg(PlayObject: TPlayObject; sMsg: string);
begin
  inherited;

end;
//�����ʱ�ļ����������׿�棬�۸��

procedure TMerchant.ClearData;
var
  i, ii: Integer;
  UserItem: pTUserItem;
  ItemList: TList;
  ItemPrice: pTItemPrice;
resourcestring
  sExceptionMsg = '[Exception] TMerchant::ClearData';
begin
  try
    for i := 0 to m_GoodsList.Count - 1 do begin
      ItemList := TList(m_GoodsList.Items[i]);
      if ItemList = nil then Continue;
      for ii := 0 to ItemList.Count - 1 do begin
        UserItem := ItemList.Items[ii];
        if UserItem <> nil then
          DisPose(UserItem);
      end;
      ItemList.Free;
    end;
    m_GoodsList.Clear;
    for i := 0 to m_ItemPriceList.Count - 1 do begin
      ItemPrice := m_ItemPriceList.Items[i];
      if ItemPrice <> nil then
        DisPose(ItemPrice);
    end;
    m_ItemPriceList.Clear;
    SaveNPCData();
  except
    on E: Exception do begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
    end;
  end;
end;

procedure TMerchant.ChangeUseItemName(PlayObject: TPlayObject;
  sLabel, sItemName: string);
var
  sWhere: string;
  btWhere: Byte;
  UserItem: pTUserItem;
  nLabelLen: Integer;
  sMsg: string;
  sItemNewName: string;
  StdItem: pTStdItem;
begin
  if not PlayObject.m_boChangeItemNameFlag then begin
    Exit;
  end;
  PlayObject.m_boChangeItemNameFlag := False;
  sWhere := Copy(sLabel, Length(sUSEITEMNAME) + 1, Length(sLabel) - Length(sUSEITEMNAME));
  btWhere := Str_ToInt(sWhere, -1);
  if btWhere in [Low(THumanUseItems)..High(THumanUseItems)] then begin
    UserItem := @PlayObject.m_UseItems[btWhere];
    if UserItem.wIndex = 0 then begin
      sMsg := format(g_sYourUseItemIsNul, [GetUseItemName(btWhere)]);
      PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, sMsg);
      Exit;
    end;
    if UserItem.btValue[13] = 1 then begin
      ItemUnit.DelCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
    end;
    if sItemName <> '' then begin
      if g_Config.boChangeUseItemNameByPlayName then begin
        ItemUnit.AddCustomItemName(UserItem.MakeIndex, UserItem.wIndex, PlayObject.m_sCharName + '��' + sItemName);
        UserItem.btValue[13] := 1;
      end else begin
        ItemUnit.AddCustomItemName(UserItem.MakeIndex, UserItem.wIndex, g_Config.sChangeUseItemName + sItemName);
        UserItem.btValue[13] := 1;
      end;
    end else begin
      ItemUnit.DelCustomItemName(UserItem.MakeIndex, UserItem.wIndex);
      UserItem.btValue[13] := 0;
    end;
    ItemUnit.SaveCustomItemName();
    PlayObject.SendMsg(PlayObject, RM_SENDUSEITEMS, 0, 0, 0, 0, '');
    PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, '');
  end;
end;

{ TTrainer }

constructor TTrainer.Create; //004A385C
begin
  inherited;
  m_dw568 := GetTickCount();
  n56C := 0;
  n570 := 0;
end;

destructor TTrainer.Destroy;
begin

  inherited;
end;

function TTrainer.Operate(ProcessMsg: pTProcessMessage): Boolean; //004A38C4
begin
  Result := False;
  if (ProcessMsg.wIdent = RM_STRUCK) or (ProcessMsg.wIdent = RM_MAGSTRUCK) then begin
    //  if (ProcessMsg.wIdent = RM_10101) or (ProcessMsg.wIdent = RM_MAGSTRUCK) then begin

    if (ProcessMsg.BaseObject = Self) { and (ProcessMsg.nParam3 <> 0)} then begin
      Inc(n56C, ProcessMsg.wParam);
      m_dw568 := GetTickCount();
      Inc(n570);
      ProcessSayMsg('�ƻ���Ϊ ' + IntToStr(ProcessMsg.wParam) + ',ƽ��ֵΪ ' + IntToStr(n56C div n570));
    end;
  end;
  if ProcessMsg.wIdent = RM_MAGSTRUCK then
    Result := inherited Operate(ProcessMsg);
end;

procedure TTrainer.Run;
begin
  m_Abil.HP := m_Abil.MaxHP;
  m_WAbil.HP := m_WAbil.MaxHP;
  if n570 > 0 then begin
    if (GetTickCount - m_dw568) > 3 * 1000 then begin
      ProcessSayMsg('���ƻ���Ϊ  ' + IntToStr(n56C) + ',ƽ��ֵΪ ' + IntToStr(n56C div n570));
      n570 := 0;
      n56C := 0;
    end;
  end;
  inherited;
end;
{ TNormNpc }

procedure TNormNpc.ActionOfAddNameDateList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  LoadList: TStringList;
  boFound: Boolean;
  sListFileName, sLineText, sHumName, sDate: string;
begin
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  LoadList := TStringList.Create;
  if FileExists(sListFileName) then begin
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessage('loading fail.... => ' + sListFileName);
    end;
  end;
  boFound := False;
  for i := 0 to LoadList.Count - 1 do begin
    sLineText := Trim(LoadList.Strings[i]);
    sLineText := GetValidStr3(sLineText, sHumName, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);
    if CompareText(sHumName, PlayObject.m_sCharName) = 0 then begin
      LoadList.Strings[i] := PlayObject.m_sCharName + #9 + DateToStr(Date);
      boFound := True;
      break;
    end;
  end;
  if not boFound then
    LoadList.Add(PlayObject.m_sCharName + #9 + DateToStr(Date));
  try
    LoadList.SaveToFile(sListFileName);
  except
    MainOutMessage('saving fail.... => ' + sListFileName);
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfDelNameDateList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  LoadList: TStringList;
  sLineText, sListFileName, sHumName, sDate: string;
  boFound: Boolean;
begin
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  LoadList := TStringList.Create;
  if FileExists(sListFileName) then begin
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessage('loading fail.... => ' + sListFileName);
    end;
  end;
  boFound := False;
  for i := 0 to LoadList.Count - 1 do begin
    sLineText := Trim(LoadList.Strings[i]);
    sLineText := GetValidStr3(sLineText, sHumName, [' ', #9]);
    sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);
    if CompareText(sHumName, PlayObject.m_sCharName) = 0 then begin
      LoadList.Delete(i);
      boFound := True;
      break;
    end;
  end;
  if boFound then begin
    try
      LoadList.SaveToFile(sListFileName);
    except
      MainOutMessage('saving fail.... => ' + sListFileName);
    end;
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfAddSkill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  nLevel: Integer;
begin
  nLevel := _MIN(3, Str_ToInt(QuestActionInfo.sParam2, 0));
  Magic := UserEngine.FindMagic(QuestActionInfo.sParam1);
  if Magic <> nil then begin
    if not PlayObject.IsTrainingSkill(Magic.wMagicId) then begin
      New(UserMagic);
      UserMagic.MagicInfo := Magic;
      UserMagic.wMagIdx := Magic.wMagicId;
      UserMagic.btKey := 0;
      UserMagic.btLevel := nLevel;
      UserMagic.nTranPoint := 0;
      PlayObject.m_MagicList.Add(UserMagic);
      PlayObject.SendAddMagic(UserMagic);
      PlayObject.RecalcAbilitys();
      if g_Config.boShowScriptActionMsg then begin
        PlayObject.SysMsg(Magic.sMagicName + '��ϰ�ɹ���', c_Green, t_Hint);
      end;
    end;
  end else begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ADDSKILL);
  end;
end;

procedure TNormNpc.ActionOfAutoAddGameGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
var
  sMsg: string;
begin
  if CompareText(QuestActionInfo.sParam1, 'START') = 0 then begin
    if (nPoint > 0) and (nTime > 0) then begin
      PlayObject.m_nIncGameGold := nPoint;
      PlayObject.m_dwIncGameGoldTime := LongWord(nTime * 1000);
      PlayObject.m_dwIncGameGoldTick := GetTickCount();
      PlayObject.m_boIncGameGold := True;
      Exit;
    end;
  end;
  if CompareText(QuestActionInfo.sParam1, 'STOP') = 0 then begin
    PlayObject.m_boIncGameGold := False;
    Exit;
  end;
  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AUTOADDGAMEGOLD);
end;

//SETAUTOGETEXP ʱ�� ���� �Ƿ�ȫ�� ��ͼ��

procedure TNormNpc.ActionOfAutoGetExp(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nTime, nPoint: Integer;
  boIsSafeZone: Boolean;
  sMAP: string;
  Envir: TEnvirnoment;
begin
  Envir := nil;
  nTime := Str_ToInt(QuestActionInfo.sParam1, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  boIsSafeZone := QuestActionInfo.sParam3[1] = '1';
  sMAP := QuestActionInfo.sParam4;
  if sMAP <> '' then begin
    Envir := g_MapManager.FindMap(sMAP);
  end;
  if (nTime <= 0) or (nPoint <= 0) or ((sMAP <> '') and (Envir = nil)) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETAUTOGETEXP);
    Exit;
  end;
  PlayObject.m_boAutoGetExpInSafeZone := boIsSafeZone;
  PlayObject.m_AutoGetExpEnvir := Envir;
  PlayObject.m_nAutoGetExpTime := nTime * 1000;
  PlayObject.m_nAutoGetExpPoint := nPoint;
end;

procedure TNormNpc.ActionOfAutoSubGameGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo; nPoint, nTime: Integer);
var
  sMsg: string;
begin
  if CompareText(QuestActionInfo.sParam1, 'START') = 0 then begin
    if (nPoint > 0) and (nTime > 0) then begin
      PlayObject.m_nDecGameGold := nPoint;
      PlayObject.m_dwDecGameGoldTime := LongWord(nTime * 1000);
      PlayObject.m_dwDecGameGoldTick := 0;
      PlayObject.m_boDecGameGold := True;
      Exit;
    end;
  end;
  if CompareText(QuestActionInfo.sParam1, 'STOP') = 0 then begin
    PlayObject.m_boDecGameGold := False;
    Exit;
  end;
  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AUTOSUBGAMEGOLD);
end;

procedure TNormNpc.ActionOfChangeCreditPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boChgOK: Boolean;
  nCreditPoint: Integer;
  nLv: Integer;
  nOldLevel: Integer;
  cMethod: Char;
  dwInt: LongWord;
begin
  boChgOK := False;
  nCreditPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nCreditPoint < 0) and (not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nCreditPoint)) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CREDITPOINT);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        if nCreditPoint >= 0 then begin
          if nCreditPoint > High(Byte) then begin
            PlayObject.m_btCreditPoint := High(Byte);
          end else begin
            PlayObject.m_btCreditPoint := nCreditPoint;
          end;
        end;
      end;
    '-': begin
        if PlayObject.m_btCreditPoint > Byte(nCreditPoint) then begin
          Dec(PlayObject.m_btCreditPoint, Byte(nCreditPoint));
        end else begin
          PlayObject.m_btCreditPoint := 0;
        end;
      end;
    '+': begin
        if PlayObject.m_btCreditPoint + Byte(nCreditPoint) > High(Byte) then begin
          PlayObject.m_btCreditPoint := High(Byte);
        end else begin
          Inc(PlayObject.m_btCreditPoint, Byte(nCreditPoint));
        end;
      end;
    else begin
        ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CREDITPOINT);
        Exit;
      end;
  end;
end;

procedure TNormNpc.ActionOfChangeExp(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boChgOK: Boolean;
  nExp: Integer;
  nLv: Integer;
  nOldLevel: Integer;
  cMethod: Char;
  dwInt: LongWord;
begin
  boChgOK := False;
  nExp := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nExp < 0) and (not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nExp)) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEEXP);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        if nExp >= 0 then begin
          PlayObject.m_Abil.Exp := LongWord(nExp);
          dwInt := LongWord(nExp);
        end;
      end;
    '-': begin
        if PlayObject.m_Abil.Exp > LongWord(nExp) then begin
          Dec(PlayObject.m_Abil.Exp, LongWord(nExp));
        end else begin
          PlayObject.m_Abil.Exp := 0;
        end;
      end;
    '+': begin
        if PlayObject.m_Abil.Exp >= LongWord(nExp) then begin
          if (PlayObject.m_Abil.Exp - LongWord(nExp)) > (High(LongWord) - PlayObject.m_Abil.Exp) then begin
            dwInt := High(LongWord) - PlayObject.m_Abil.Exp;
          end else begin
            dwInt := LongWord(nExp);
          end;
        end else begin
          if (LongWord(nExp) - PlayObject.m_Abil.Exp) > (High(LongWord) - LongWord(nExp)) then begin
            dwInt := High(LongWord) - LongWord(nExp);
          end else begin
            dwInt := LongWord(nExp);
          end;
        end;
        Inc(PlayObject.m_Abil.Exp, dwInt);
        //PlayObject.GetExp(dwInt);
        PlayObject.SendMsg(PlayObject, RM_WINEXP, 0, dwInt, 0, 0, '');
      end;
  end;
end;

procedure TNormNpc.ActionOfChangeHairStyle(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nHair: Integer;
begin
  nHair := Str_ToInt(QuestActionInfo.sParam1, -1);
  if (QuestActionInfo.sParam1 <> '') and (nHair >= 0) then begin
    PlayObject.m_btHair := nHair;
    PlayObject.FeatureChanged;
  end else begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HAIRSTYLE);
  end;
end;

procedure TNormNpc.ActionOfChangeJob(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nJob: Integer;
begin
  nJob := -1;
  if CompareLStr(QuestActionInfo.sParam1, sWARRIOR, 3) then nJob := 0;
  if CompareLStr(QuestActionInfo.sParam1, sWIZARD, 3) then nJob := 1;
  if CompareLStr(QuestActionInfo.sParam1, sTAOS, 3) then nJob := 2;

  if nJob < 0 then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEJOB);
    Exit;
  end;

  if PlayObject.m_btJob <> nJob then begin
    PlayObject.m_btJob := nJob;
    {
    PlayObject.RecalcLevelAbilitys();
    PlayObject.RecalcAbilitys();
    }
    PlayObject.HasLevelUp(0);
  end;
end;

procedure TNormNpc.ActionOfChangeLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boChgOK: Boolean;
  nLevel: Integer;
  nLv: Integer;
  nOldLevel: Integer;
  cMethod: Char;
begin
  boChgOK := False;
  nOldLevel := PlayObject.m_Abil.Level;
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nLevel < 0) and (not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nLevel)) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGELEVEL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        if (nLevel > 0) and (nLevel <= MAXLEVEL) then begin
          PlayObject.m_Abil.Level := nLevel;
          boChgOK := True;
        end;
      end;
    '-': begin
        nLv := _MAX(0, PlayObject.m_Abil.Level - nLevel);
        nLv := _MIN(MAXLEVEL, nLv);
        PlayObject.m_Abil.Level := nLv;
        boChgOK := True;
      end;
    '+': begin
        nLv := _MAX(0, PlayObject.m_Abil.Level + nLevel);
        nLv := _MIN(MAXLEVEL, nLv);
        PlayObject.m_Abil.Level := nLv;
        boChgOK := True;
      end;
  end;
  if boChgOK then
    PlayObject.HasLevelUp(nOldLevel);
end;

procedure TNormNpc.ActionOfChangePkPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nPKPOINT: Integer;
  nPoint: Integer;
  nOldPKLevel: Integer;
  cMethod: Char;
begin
  nOldPKLevel := PlayObject.PKLevel;
  nPKPOINT := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nPKPOINT < 0) and (not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nPKPOINT)) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEPKPOINT);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        if (nPKPOINT >= 0) then begin
          PlayObject.m_nPkPoint := nPKPOINT;
        end;
      end;
    '-': begin
        nPoint := _MAX(0, PlayObject.m_nPkPoint - nPKPOINT);
        PlayObject.m_nPkPoint := nPoint;
      end;
    '+': begin
        nPoint := _MAX(0, PlayObject.m_nPkPoint + nPKPOINT);
        PlayObject.m_nPkPoint := nPoint;
      end;
  end;
  if nOldPKLevel <> PlayObject.PKLevel then
    PlayObject.RefNameColor;
end;

procedure TNormNpc.ActionOfClearMapMon(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  MonList: TList;
  mon: TBaseObject;
  ii: Integer;
begin
  MonList := TList.Create;
  UserEngine.GetMapMonster(g_MapManager.FindMap(QuestActionInfo.sParam1), MonList);
  for ii := 0 to MonList.Count - 1 do begin
    mon := TBaseObject(MonList.Items[ii]);
    if mon.m_Master <> nil then Continue;
    if GetNoClearMonList(mon.m_sCharName) then Continue;

    mon.m_boNoItem := True;
    mon.MakeGhost;
  end;
  MonList.Free;
end;

procedure TNormNpc.ActionOfClearNameList(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  LoadList: TStringList;
  sListFileName: string;
begin
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam1;
  LoadList := TStringList.Create;
  {
  if FileExists(sListFileName) then begin
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessage('loading fail.... => ' + sListFileName);
    end;
  end;
  }
  LoadList.Clear;
  try
    LoadList.SaveToFile(sListFileName);
  except
    MainOutMessage('saving fail.... => ' + sListFileName);
  end;
  LoadList.Free;
end;

procedure TNormNpc.ActionOfClearSkill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  for i := PlayObject.m_MagicList.Count - 1 downto 0 do begin
    UserMagic := PlayObject.m_MagicList.Items[i];
    PlayObject.SendDelMagic(UserMagic);
    DisPose(UserMagic);
    PlayObject.m_MagicList.Delete(i);
  end;
  PlayObject.RecalcAbilitys();
end;

procedure TNormNpc.ActionOfDelNoJobSkill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  UserMagic: pTUserMagic;
begin
  for i := PlayObject.m_MagicList.Count - 1 downto 0 do begin
    if PlayObject.m_MagicList.Count <= 0 then break;
    UserMagic := PlayObject.m_MagicList.Items[i];
    if UserMagic = nil then Continue;
    if UserMagic.MagicInfo.btJob <> PlayObject.m_btJob then begin
      PlayObject.SendDelMagic(UserMagic);
      DisPose(UserMagic);
      PlayObject.m_MagicList.Delete(i);
    end;
  end;
end;

procedure TNormNpc.ActionOfDelSkill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sMagicName: string;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
begin
  sMagicName := QuestActionInfo.sParam1;
  Magic := UserEngine.FindMagic(sMagicName);
  if Magic = nil then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_DELSKILL);
    Exit;
  end;
  for i := PlayObject.m_MagicList.Count - 1 downto 0 do begin
    if PlayObject.m_MagicList.Count <= 0 then break;
    UserMagic := PlayObject.m_MagicList.Items[i];
    if UserMagic = nil then Continue;
    if UserMagic.MagicInfo = Magic then begin
      PlayObject.m_MagicList.Delete(i);
      PlayObject.SendDelMagic(UserMagic);
      DisPose(UserMagic);
      PlayObject.RecalcAbilitys();
      break;
    end;
  end;
end;

procedure TNormNpc.ActionOfGameGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGameGold: Integer;
  nOldGameGold: Integer;
  cMethod: Char;
begin
  nOldGameGold := PlayObject.m_nGameGold;
  nGameGold := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nGameGold < 0) and (not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nGameGold)) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GAMEGOLD);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        if (nGameGold >= 0) then begin
          PlayObject.m_nGameGold := nGameGold;
        end;
      end;
    '-': begin
        nGameGold := _MAX(0, PlayObject.m_nGameGold - nGameGold);
        PlayObject.m_nGameGold := nGameGold;
      end;
    '+': begin
        nGameGold := _MAX(0, PlayObject.m_nGameGold + nGameGold);
        PlayObject.m_nGameGold := nGameGold;
      end;
  end;
  //'%d'#9'%s'#9'%d'#9'%d'#9'%s'#9'%s'#9'%d'#9'%s'#9'%s'
  if g_boGameLogGameGold then begin
    AddGameDataLog(format(g_sGameLogMsg1, [LOG_GAMEGOLD,
      PlayObject.m_sMapName,
        PlayObject.m_nCurrX,
        PlayObject.m_nCurrY,
        PlayObject.m_sCharName,
        g_Config.sGameGoldName,
        nGameGold,
        cMethod,
        m_sCharName]));
  end;
  if nOldGameGold <> PlayObject.m_nGameGold then
    PlayObject.GameGoldChanged;
end;

procedure TNormNpc.ActionOfGamePoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGamePoint: Integer;
  nOldGamePoint: Integer;
  cMethod: Char;
begin
  nOldGamePoint := PlayObject.m_nGamePoint;
  nGamePoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nGamePoint < 0) and (not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nGamePoint)) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GAMEPOINT);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        if (nGamePoint >= 0) then begin
          PlayObject.m_nGamePoint := nGamePoint;
        end;
      end;
    '-': begin
        nGamePoint := _MAX(0, PlayObject.m_nGamePoint - nGamePoint);
        PlayObject.m_nGamePoint := nGamePoint;
      end;
    '+': begin
        nGamePoint := _MAX(0, PlayObject.m_nGamePoint + nGamePoint);
        PlayObject.m_nGamePoint := nGamePoint;
      end;
  end;
  //'%d'#9'%s'#9'%d'#9'%d'#9'%s'#9'%s'#9'%d'#9'%s'#9'%s'
  if g_boGameLogGamePoint then begin
    AddGameDataLog(format(g_sGameLogMsg1, [LOG_GAMEPOINT,
      PlayObject.m_sMapName,
        PlayObject.m_nCurrX,
        PlayObject.m_nCurrY,
        PlayObject.m_sCharName,
        g_Config.sGamePointName,
        nGamePoint,
        cMethod,
        m_sCharName]));
  end;
  if nOldGamePoint <> PlayObject.m_nGamePoint then
    PlayObject.GameGoldChanged;
end;

procedure TNormNpc.ActionOfGetMarry(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseBaseObject: TBaseObject;
begin
  PoseBaseObject := PlayObject.GetPoseCreate();
  if (PoseBaseObject <> nil) and (PoseBaseObject.m_btRaceServer = RC_PLAYOBJECT) and (PoseBaseObject.m_btGender <> PlayObject.m_btGender) then begin
    PlayObject.m_sDearName := PoseBaseObject.m_sCharName;
    PlayObject.RefShowName;
    PoseBaseObject.RefShowName;
  end else begin
    GotoLable(PlayObject, '@MarryError', False);
  end;
end;

procedure TNormNpc.ActionOfGetMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseBaseObject: TBaseObject;
begin
  PoseBaseObject := PlayObject.GetPoseCreate();
  if (PoseBaseObject <> nil) and (PoseBaseObject.m_btRaceServer = RC_PLAYOBJECT) and (PoseBaseObject.m_btGender <> PlayObject.m_btGender) then begin
    PlayObject.m_sMasterName := PoseBaseObject.m_sCharName;
    PlayObject.RefShowName;
    PoseBaseObject.RefShowName;
  end else begin
    GotoLable(PlayObject, '@MasterError', False);
  end;
end;

procedure TNormNpc.ActionOfLineMsg(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  sMsg: string;
  sParam2: string;
begin
  sParam2 := QuestActionInfo.sParam2;
  ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, sParam2);
  sMsg := GetLineVariableText(PlayObject, sParam2);
  sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
  sMsg := AnsiReplaceText(sMsg, '%x', IntToStr(PlayObject.m_nCurrX));
  sMsg := AnsiReplaceText(sMsg, '%y', IntToStr(PlayObject.m_nCurrY));
  if PlayObject.m_PEnvir <> nil then
    sMsg := AnsiReplaceText(sMsg, '%m', PlayObject.m_PEnvir.sMapDesc)
  else sMsg := AnsiReplaceText(sMsg, '%m', '????');
  sMsg := AnsiReplaceText(sMsg, '%d', m_sCharName);
  case QuestActionInfo.nParam1 of
    0: UserEngine.SendBroadCastMsg(sMsg, t_System);
    1: UserEngine.SendBroadCastMsg('(*) ' + sMsg, t_System);
    2: UserEngine.SendBroadCastMsg('[' + m_sCharName + ']' + sMsg, t_System);
    3: UserEngine.SendBroadCastMsg('[' + PlayObject.m_sCharName + ']' + sMsg, t_System);
    4: ProcessSayMsg(sMsg);
    5: PlayObject.SysMsg(sMsg, c_Red, t_Say);
    6: PlayObject.SysMsg(sMsg, c_Green, t_Say);
    7: PlayObject.SysMsg(sMsg, c_Blue, t_Say);
    else begin
        ScriptActionError(PlayObject, '', QuestActionInfo, sSENDMSG);
      end;
  end;
end;

procedure TNormNpc.ActionOfMapTing(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin

end;

procedure TNormNpc.ActionOfMarry(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  sSayMsg: string;
begin
  if PlayObject.m_sDearName <> '' then Exit;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate());
  if PoseHuman = nil then begin
    GotoLable(PlayObject, '@MarryCheckDir', False);
    Exit;
  end;
  if QuestActionInfo.sParam1 = '' then begin
    if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then begin
      GotoLable(PlayObject, '@HumanTypeErr', False);
      Exit;
    end;
    if PoseHuman.GetPoseCreate = PlayObject then begin
      if PlayObject.m_btGender <> PoseHuman.m_btGender then begin
        GotoLable(PlayObject, '@StartMarry', False);
        GotoLable(PoseHuman, '@StartMarry', False);
        if (PlayObject.m_btGender = 0) and (PoseHuman.m_btGender = 1) then begin
          sSayMsg := AnsiReplaceText(g_sStartMarryManMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sStartMarryManAskQuestionMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        end else if (PlayObject.m_btGender = 1) and (PoseHuman.m_btGender = 0) then begin
          sSayMsg := AnsiReplaceText(g_sStartMarryWoManMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sStartMarryWoManAskQuestionMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        end;
        PlayObject.m_boStartMarry := True;
        PoseHuman.m_boStartMarry := True;
      end else begin
        GotoLable(PoseHuman, '@MarrySexErr', False);
        GotoLable(PlayObject, '@MarrySexErr', False);
      end;
    end else begin
      GotoLable(PlayObject, '@MarryDirErr', False);
      GotoLable(PoseHuman, '@MarryCheckDir', False);
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'REQUESTMARRY' {sREQUESTMARRY}) = 0 then begin
    if PlayObject.m_boStartMarry and PoseHuman.m_boStartMarry then begin
      if (PlayObject.m_btGender = 0) and (PoseHuman.m_btGender = 1) then begin
        sSayMsg := AnsiReplaceText(g_sMarryManAnswerQuestionMsg, '%n', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
        UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        sSayMsg := AnsiReplaceText(g_sMarryManAskQuestionMsg, '%n', m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
        sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
        UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        GotoLable(PlayObject, '@WateMarry', False);
        GotoLable(PoseHuman, '@RevMarry', False);
      end;
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'RESPONSEMARRY' {sRESPONSEMARRY}) = 0 then begin
    if (PlayObject.m_btGender = 1) and (PoseHuman.m_btGender = 0) then begin
      if CompareText(QuestActionInfo.sParam2, 'OK') = 0 then begin
        if PlayObject.m_boStartMarry and PoseHuman.m_boStartMarry then begin
          sSayMsg := AnsiReplaceText(g_sMarryWoManAnswerQuestionMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sMarryWoManGetMarryMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          GotoLable(PlayObject, '@EndMarry', False);
          GotoLable(PoseHuman, '@EndMarry', False);
          PlayObject.m_boStartMarry := False;
          PoseHuman.m_boStartMarry := False;
          PlayObject.m_sDearName := PoseHuman.m_sCharName;
          PlayObject.m_DearHuman := PoseHuman;
          PoseHuman.m_sDearName := PlayObject.m_sCharName;
          PoseHuman.m_DearHuman := PlayObject;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
        end;
      end else begin
        if PlayObject.m_boStartMarry and PoseHuman.m_boStartMarry then begin
          GotoLable(PlayObject, '@EndMarryFail', False);
          GotoLable(PoseHuman, '@EndMarryFail', False);
          PlayObject.m_boStartMarry := False;
          PoseHuman.m_boStartMarry := False;
          sSayMsg := AnsiReplaceText(g_sMarryWoManDenyMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
          sSayMsg := AnsiReplaceText(g_sMarryWoManCancelMsg, '%n', m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%s', PlayObject.m_sCharName);
          sSayMsg := AnsiReplaceText(sSayMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sSayMsg, t_Say);
        end;
      end;
    end;
    Exit;
  end;
end;

procedure TNormNpc.ActionOfMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  sSayMsg: string;
begin
  if PlayObject.m_sMasterName <> '' then Exit;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate());
  if PoseHuman = nil then begin
    GotoLable(PlayObject, '@MasterCheckDir', False);
    Exit;
  end;
  if QuestActionInfo.sParam1 = '' then begin
    if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then begin
      GotoLable(PlayObject, '@HumanTypeErr', False);
      Exit;
    end;
    if PoseHuman.GetPoseCreate = PlayObject then begin
      GotoLable(PlayObject, '@StartGetMaster', False);
      GotoLable(PoseHuman, '@StartMaster', False);
      PlayObject.m_boStartMaster := True;
      PoseHuman.m_boStartMaster := True;
    end else begin
      GotoLable(PlayObject, '@MasterDirErr', False);
      GotoLable(PoseHuman, '@MasterCheckDir', False);
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'REQUESTMASTER') = 0 then begin
    if PlayObject.m_boStartMaster and PoseHuman.m_boStartMaster then begin
      PlayObject.m_PoseBaseObject := PoseHuman;
      PoseHuman.m_PoseBaseObject := PlayObject;
      GotoLable(PlayObject, '@WateMaster', False);
      GotoLable(PoseHuman, '@RevMaster', False);
    end;
    Exit;
  end;
  if CompareText(QuestActionInfo.sParam1, 'RESPONSEMASTER') = 0 then begin
    if CompareText(QuestActionInfo.sParam2, 'OK') = 0 then begin
      if (PlayObject.m_PoseBaseObject = PoseHuman) and (PoseHuman.m_PoseBaseObject = PlayObject) then begin
        if PlayObject.m_boStartMaster and PoseHuman.m_boStartMaster then begin
          GotoLable(PlayObject, '@EndMaster', False);
          GotoLable(PoseHuman, '@EndMaster', False);
          PlayObject.m_boStartMaster := False;
          PoseHuman.m_boStartMaster := False;
          if PlayObject.m_sMasterName = '' then begin
            PlayObject.m_sMasterName := PoseHuman.m_sCharName;
            PlayObject.m_boMaster := True;
          end;
          PlayObject.m_MasterList.Add(PoseHuman);
          PoseHuman.m_sMasterName := PlayObject.m_sCharName;
          PoseHuman.m_boMaster := False;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
        end;
      end;
    end else begin
      if PlayObject.m_boStartMaster and PoseHuman.m_boStartMaster then begin
        GotoLable(PlayObject, '@EndMasterFail', False);
        GotoLable(PoseHuman, '@EndMasterFail', False);
        PlayObject.m_boStartMaster := False;
        PoseHuman.m_boStartMaster := False;
      end;
    end;
    Exit;
  end;
end;

procedure TNormNpc.ActionOfMessageBox(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  sParam1: string;
begin
  sParam1 := QuestActionInfo.sParam1;
  ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, sParam1);
  PlayObject.SendMsg(Self, RM_MENU_OK, 0, Integer(PlayObject), 0, 0, GetLineVariableText(PlayObject, sParam1));
end;

procedure TNormNpc.ActionOfMission(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  if (QuestActionInfo.sParam1 <> '') and (QuestActionInfo.nParam2 > 0) and (QuestActionInfo.nParam3 > 0) then begin
    g_sMissionMap := QuestActionInfo.sParam1;
    g_nMissionX := QuestActionInfo.nParam2;
    g_nMissionY := QuestActionInfo.nParam3;
  end else begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MISSION);
  end;
end;

//MOBFIREBURN MAP X Y TYPE TIME POINT

procedure TNormNpc.ActionOfMobFireBurn(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  sMAP: string;
  nX, nY, nType, nTime, nPoint: Integer;
  FireBurnEvent: TFireBurnEvent;
  Envir: TEnvirnoment;
  OldEnvir: TEnvirnoment;
begin
  sMAP := QuestActionInfo.sParam1;
  nX := Str_ToInt(QuestActionInfo.sParam2, -1);
  nY := Str_ToInt(QuestActionInfo.sParam3, -1);
  nType := Str_ToInt(QuestActionInfo.sParam4, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam5, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam6, -1);
  if (sMAP = '') or (nX < 0) or (nY < 0) or (nType < 0) or (nTime < 0) or (nPoint < 0) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MOBFIREBURN);
    Exit;
  end;
  Envir := g_MapManager.FindMap(sMAP);
  if Envir <> nil then begin
    OldEnvir := PlayObject.m_PEnvir;
    PlayObject.m_PEnvir := Envir;
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, nType, nTime * 1000, nPoint);
    g_EventManager.AddEvent(FireBurnEvent);
    PlayObject.m_PEnvir := OldEnvir;
    Exit;
  end;
  ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MOBFIREBURN);
end;

procedure TNormNpc.ActionOfMobPlace(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo; nX, nY, nCount, nRange: Integer);
var
  i: Integer;
  nRandX, nRandY: Integer;
  mon: TBaseObject;
begin
  for i := 0 to nCount - 1 do begin
    nRandX := Random(nRange * 2 + 1) + (nX - nRange);
    nRandY := Random(nRange * 2 + 1) + (nY - nRange);
    mon := UserEngine.RegenMonsterByName(g_sMissionMap, nRandX, nRandY, QuestActionInfo.sParam1);
    if mon <> nil then begin
      mon.m_boMission := True;
      mon.m_nMissionX := g_nMissionX;
      mon.m_nMissionY := g_nMissionY;
    end else begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MOBPLACE);
      break;
    end;
  end;
end;

procedure TNormNpc.ActionOfRecallGroupMembers(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin

end;

procedure TNormNpc.ActionOfSetRankLevelName(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  DynamicVar: pTDynamicVar;
  DynamicVarList: TList;
  sName: string;
  boVarFound: Boolean;
  sRankLevelName: string;
  n10: Integer;
resourcestring
  sVarFound = '����%s�����ڣ���������:%s';
  sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
begin
  sRankLevelName := QuestActionInfo.sParam1;
  if sRankLevelName = '' then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SKILLLEVEL);
    Exit;
  end;
  if QuestActionInfo.sParam2 <> '' then begin
    boVarFound := False;
    DynamicVarList := GetDynamicVarList(PlayObject, sRankLevelName, sName);
    if DynamicVarList = nil then begin
      DisPose(DynamicVar);
      ScriptActionError(PlayObject, format(sVarTypeError, [sRankLevelName]), QuestActionInfo, sSC_SETRANKLEVELNAME);
      Exit;
    end;
    for i := 0 to DynamicVarList.Count - 1 do begin
      DynamicVar := DynamicVarList.Items[i];
      if CompareText(DynamicVar.sName, QuestActionInfo.sParam2) = 0 then begin
        case DynamicVar.VarType of
          vInteger: begin
            end;
          vString: begin
              sRankLevelName := DynamicVar.sString;
            end;
        end;
        boVarFound := True;
        break;
      end;
    end;
    if not boVarFound then begin
      ScriptActionError(PlayObject, format(sVarFound, [QuestActionInfo.sParam2, QuestActionInfo.sParam1]), QuestActionInfo, sSC_SETRANKLEVELNAME);
      Exit;
    end;
  end else begin
    n10 := GetValNameNo(sRankLevelName);
    if n10 >= 0 then begin
      case n10 of
        600..699: begin
            sRankLevelName := PlayObject.m_sString[n10 - 600];
          end;
        700..799: begin
            sRankLevelName := g_Config.GlobalAVal[n10 - 700];
          end;
      end;
    end;
  end;
  if sRankLevelName = '' then begin
    sRankLevelName := g_sRankLevelName;
  end else
    if (UpCase(sRankLevelName[1]) <> '%') and (UpCase(sRankLevelName[2]) <> 's') then begin
    sRankLevelName := '%s\' + sRankLevelName;
  end;
  PlayObject.m_sRankLevelName := sRankLevelName;
  PlayObject.RefShowName;
end;

procedure TNormNpc.ActionOfSetScriptFlag(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boFlag: Boolean;
  nWhere: Integer;
begin
  nWhere := Str_ToInt(QuestActionInfo.sParam1, -1);
  boFlag := Str_ToInt(QuestActionInfo.sParam2, -1) = 1;
  case nWhere of
    0: begin
        PlayObject.m_boSendMsgFlag := boFlag;
      end;
    1: begin
        PlayObject.m_boChangeItemNameFlag := boFlag;
      end;
    else begin
        ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETSCRIPTFLAG);
      end;
  end;
end;

procedure TNormNpc.ActionOfSkillLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  Magic: pTMagic;
  UserMagic: pTUserMagic;
  nLevel: Integer;
  cMethod: Char;
begin
  nLevel := Str_ToInt(QuestActionInfo.sParam3, 0);
  if nLevel < 0 then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SKILLLEVEL);
    Exit;
  end;
  cMethod := QuestActionInfo.sParam2[1];
  Magic := UserEngine.FindMagic(QuestActionInfo.sParam1);
  if Magic <> nil then begin
    for i := 0 to PlayObject.m_MagicList.Count - 1 do begin
      UserMagic := PlayObject.m_MagicList.Items[i];
      if UserMagic.MagicInfo = Magic then begin
        case cMethod of
          '=': begin
              if nLevel >= 0 then begin
                nLevel := _MAX(3, nLevel);
                UserMagic.btLevel := nLevel;
              end;
            end;
          '-': begin
              if UserMagic.btLevel >= nLevel then begin
                Dec(UserMagic.btLevel, nLevel);
              end else begin
                UserMagic.btLevel := 0;
              end;
            end;
          '+': begin
              if UserMagic.btLevel + nLevel <= 3 then begin
                Inc(UserMagic.btLevel, nLevel);
              end else begin
                UserMagic.btLevel := 3;
              end;
            end;
        end;
        PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, 0, UserMagic.MagicInfo.wMagicId, UserMagic.btLevel, UserMagic.nTranPoint, '', 100);
        break;
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfTakeCastleGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGold: Integer;
begin
  nGold := Str_ToInt(QuestActionInfo.sParam1, -1);
  if nGold < 0 then
    ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, nGold);
  if (nGold < 0) or (m_Castle = nil) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_TAKECASTLEGOLD);
    Exit;
  end;
  if nGold <= TUserCastle(m_Castle).m_nTotalGold then begin
    Dec(TUserCastle(m_Castle).m_nTotalGold, nGold);
  end else begin
    TUserCastle(m_Castle).m_nTotalGold := 0;
  end;
end;

procedure TNormNpc.ActionOfNotLineAddPiont(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo); //���߹һ�
var
  dwAutoGetExpTime: LongWord;
  nAutoGetExpPoint: Integer;
begin
  //MainOutMessage('ActionOfNotLineAddPiont: QuestActionInfo.sParam1:'+QuestActionInfo.sParam1+' QuestActionInfo.sParam2: '+QuestActionInfo.sParam2);
  if not PlayObject.m_boNotOnlineAddExp then begin
    dwAutoGetExpTime := Str_ToInt(QuestActionInfo.sParam1, 0);
    nAutoGetExpPoint := Str_ToInt(QuestActionInfo.sParam2, 0);
    PlayObject.m_dwNotOnlineAddExpTime := dwAutoGetExpTime * 60 * 1000;
    PlayObject.m_nNotOnlineAddExpPoint := nAutoGetExpPoint;
    PlayObject.m_boNotOnlineAddExp := True;
    PlayObject.m_boStartAutoAddExpPoint := True;
    PlayObject.m_dwAutoAddExpPointTimeTick := GetTickCount;
    PlayObject.m_dwAutoAddExpPointTick := GetTickCount; //GetTickCount;
    PlayObject.m_boKickAutoAddExpUser := False;
  end;
end;

procedure TNormNpc.ActionOfKickNotLineAddPiont(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  if PlayObject.m_boNotOnlineAddExp then begin
    PlayObject.m_boPlayOffLine := False;
    PlayObject.m_boReconnection := False;
    PlayObject.m_boSoftClose := True;
  end;
end;

procedure TNormNpc.ActionOfUnMarry(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  LoadList: TStringList;
  sUnMarryFileName: string;
begin
  if PlayObject.m_sDearName = '' then begin
    GotoLable(PlayObject, '@ExeMarryFail', False);
    Exit;
  end;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate);
  if PoseHuman = nil then begin
    GotoLable(PlayObject, '@UnMarryCheckDir', False);
  end;
  if PoseHuman <> nil then begin
    if QuestActionInfo.sParam1 = '' then begin
      if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then begin
        GotoLable(PlayObject, '@UnMarryTypeErr', False);
        Exit;
      end;
      if PoseHuman.GetPoseCreate = PlayObject then begin
        if (PlayObject.m_sDearName = PoseHuman.m_sCharName) {and (PosHum.AddInfo.sDearName = Hum.sName)} then begin
          GotoLable(PlayObject, '@StartUnMarry', False);
          GotoLable(PoseHuman, '@StartUnMarry', False);
          Exit;
        end;
      end;
    end;
  end;
  if (CompareText(QuestActionInfo.sParam1, 'REQUESTUNMARRY' {sREQUESTUNMARRY}) = 0) then begin
    if (QuestActionInfo.sParam2 = '') then begin
      if PoseHuman <> nil then begin
        PlayObject.m_boStartUnMarry := True;
        if PlayObject.m_boStartUnMarry and PoseHuman.m_boStartUnMarry then begin
          UserEngine.SendBroadCastMsg('[' + m_sCharName + ']: ' + '������' {sUnMarryMsg8} + PoseHuman.m_sCharName + ' ' + '��' {sMarryMsg0} + PlayObject.m_sCharName + ' ' + ' ' + '��ʽ������޹�ϵ��' {sUnMarryMsg9}, t_Say);
          PlayObject.m_sDearName := '';
          PoseHuman.m_sDearName := '';
          Inc(PlayObject.m_btMarryCount);
          Inc(PoseHuman.m_btMarryCount);
          PlayObject.m_boStartUnMarry := False;
          PoseHuman.m_boStartUnMarry := False;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
          GotoLable(PlayObject, '@UnMarryEnd', False);
          GotoLable(PoseHuman, '@UnMarryEnd', False);
        end else begin
          GotoLable(PlayObject, '@WateUnMarry', False);
          //          GotoLable(PoseHuman,'@RevUnMarry',False);
        end;
      end;
      Exit;
    end else begin
      //ǿ�����
      if (CompareText(QuestActionInfo.sParam2, 'FORCE') = 0) then begin
        UserEngine.SendBroadCastMsg('[' + m_sCharName + ']: ' + '������' {sUnMarryMsg8} + PlayObject.m_sCharName + ' ' + '��' {sMarryMsg0} + PlayObject.m_sDearName + ' ' + ' ' + '�Ѿ���ʽ������޹�ϵ������' {sUnMarryMsg9}, t_Say);
        PoseHuman := UserEngine.GetPlayObject(PlayObject.m_sDearName);
        if PoseHuman <> nil then begin
          PoseHuman.m_sDearName := '';
          Inc(PoseHuman.m_btMarryCount);
          PoseHuman.RefShowName;
        end else begin
          sUnMarryFileName := g_Config.sEnvirDir + 'UnMarry.txt';
          LoadList := TStringList.Create;
          if FileExists(sUnMarryFileName) then begin
            LoadList.LoadFromFile(sUnMarryFileName);
          end;
          LoadList.Add(PlayObject.m_sDearName);
          LoadList.SaveToFile(sUnMarryFileName);
          LoadList.Free;
        end;
        PlayObject.m_sDearName := '';
        Inc(PlayObject.m_btMarryCount);
        GotoLable(PlayObject, '@UnMarryEnd', False);
        PlayObject.RefShowName;
      end;
      Exit;
    end;
  end;
end;

procedure TNormNpc.ActionOfCommendGameGold(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin

end;

procedure TNormNpc.ActionOfStartTakeGold(PlayObject: TPlayObject);
var
  PoseHuman: TPlayObject;
begin
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate());
  if (PoseHuman <> nil) and (PoseHuman.GetPoseCreate = PlayObject) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
    PlayObject.m_nDealGoldPose := 1;
    GotoLable(PlayObject, '@startdealgold', False);
  end else begin
    GotoLable(PlayObject, '@dealgoldpost', False);
  end;
end;

procedure TNormNpc.ClearScript;
var
  III, IIII: Integer;
  i, ii: Integer;
  Script: pTScript;
  SayingRecord: pTSayingRecord;
  SayingProcedure: pTSayingProcedure;
begin
  for i := 0 to m_ScriptList.Count - 1 do begin
    Script := m_ScriptList.Items[i];
    for ii := 0 to Script.RecordList.Count - 1 do begin
      SayingRecord := Script.RecordList.Items[ii];
      for III := 0 to SayingRecord.ProcedureList.Count - 1 do begin
        SayingProcedure := SayingRecord.ProcedureList.Items[III];
        for IIII := 0 to SayingProcedure.ConditionList.Count - 1 do begin
          DisPose(pTQuestConditionInfo(SayingProcedure.ConditionList.Items[IIII]));
        end;
        for IIII := 0 to SayingProcedure.ActionList.Count - 1 do begin
          DisPose(pTQuestActionInfo(SayingProcedure.ActionList.Items[IIII]));
        end;
        for IIII := 0 to SayingProcedure.ElseActionList.Count - 1 do begin
          DisPose(pTQuestActionInfo(SayingProcedure.ElseActionList.Items[IIII]));
        end;
        SayingProcedure.ConditionList.Free;
        SayingProcedure.ActionList.Free;
        SayingProcedure.ElseActionList.Free;
        DisPose(SayingProcedure);
      end; // for
      SayingRecord.ProcedureList.Free;
      DisPose(SayingRecord);
    end; // for
    Script.RecordList.Free;
    DisPose(Script);
  end; // for
  m_ScriptList.Clear;
end;

procedure TNormNpc.Click(PlayObject: TPlayObject); //0049EC18
begin
  PlayObject.m_nScriptGotoCount := 0;
  PlayObject.m_sScriptGoBackLable := '';
  PlayObject.m_sScriptCurrLable := '';
  GotoLable(PlayObject, '@main', False);
end;

function TNormNpc.ConditionOfCheckAccountIPList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sCharName: string;
  sCharAccount: string;
  sCharIPaddr: string;
  sLine: string;
  sName: string;
  sIPaddr: string;
begin
  Result := False;
  try
    sCharName := PlayObject.m_sCharName;
    sCharAccount := PlayObject.m_sUserID;
    sCharIPaddr := PlayObject.m_sIPaddr;
    LoadList := TStringList.Create;
    if FileExists(g_Config.sEnvirDir + QuestConditionInfo.sParam1) then begin
      LoadList.LoadFromFile(g_Config.sEnvirDir + QuestConditionInfo.sParam1);
      for i := 0 to LoadList.Count - 1 do begin
        sLine := LoadList.Strings[i];
        if sLine[1] = ';' then Continue;
        sIPaddr := GetValidStr3(sLine, sName, [' ', '/', #9]);
        sIPaddr := Trim(sIPaddr);
        if (sName = sCharAccount) and (sIPaddr = sCharIPaddr) then begin
          Result := True;
          break;
        end;
      end;
    end else begin
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKACCOUNTIPLIST);
    end;
  finally
    LoadList.Free
  end;
end;

function TNormNpc.ConditionOfCheckBagSize(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nSize: Integer;
begin
  Result := False;
  if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, nSize) then begin //���ӱ���֧��
    nSize := QuestConditionInfo.nParam1;
  end;
  if (nSize <= 0) or (nSize > MAXBAGITEM) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKBAGSIZE);
    Exit;
  end;
  if PlayObject.m_ItemList.Count + nSize <= MAXBAGITEM then
    Result := True;
end;


function TNormNpc.ConditionOfCheckBonusPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nTotlePoint, nCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nTotlePoint := PlayObject.m_BonusAbil.DC +
    PlayObject.m_BonusAbil.MC +
    PlayObject.m_BonusAbil.SC +
    PlayObject.m_BonusAbil.AC +
    PlayObject.m_BonusAbil.MAC +
    PlayObject.m_BonusAbil.HP +
    PlayObject.m_BonusAbil.MP +
    PlayObject.m_BonusAbil.Hit +
    PlayObject.m_BonusAbil.Speed +
    PlayObject.m_BonusAbil.X2;
  nTotlePoint := nTotlePoint + PlayObject.m_nBonusPoint;
  cMethod := QuestConditionInfo.sParam1[1];
  if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nCount) then begin //���ӱ���֧��
    nCount := QuestConditionInfo.nParam2;
  end;
  case cMethod of
    '=': if nTotlePoint = nCount then Result := True;
    '>': if nTotlePoint > nCount then Result := True;
    '<': if nTotlePoint < nCount then Result := True;
    else if nTotlePoint >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckHP(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=': begin
          if PlayObject.m_WAbil.MaxHP = nMax then begin
            Result := True;
          end;
        end;
      '>': begin
          if PlayObject.m_WAbil.MaxHP > nMax then begin
            Result := True;
          end;
        end;
      '<': begin
          if PlayObject.m_WAbil.MaxHP < nMax then begin
            Result := True;
          end;
        end;
      else begin
          if PlayObject.m_WAbil.MaxHP >= nMax then begin
            Result := True;
          end;
        end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if nMIN < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nMIN); //���ӱ���֧��
  end;
  if nMax < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam4, nMax); //���ӱ���֧��
  end;
  if (nMIN < 0) or (nMax < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKHP);
    Exit;
  end;

  case cMethodMin of
    '=': begin
        if (m_WAbil.HP = nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '>': begin
        if (PlayObject.m_WAbil.HP > nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '<': begin
        if (PlayObject.m_WAbil.HP < nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    else begin
        if (PlayObject.m_WAbil.HP >= nMIN) then begin
          Result := CheckHigh;
        end;
      end;
  end;
end;

function TNormNpc.ConditionOfCheckMP(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=': begin
          if PlayObject.m_WAbil.MaxMP = nMax then begin
            Result := True;
          end;
        end;
      '>': begin
          if PlayObject.m_WAbil.MaxMP > nMax then begin
            Result := True;
          end;
        end;
      '<': begin
          if PlayObject.m_WAbil.MaxMP < nMax then begin
            Result := True;
          end;
        end;
      else begin
          if PlayObject.m_WAbil.MaxMP >= nMax then begin
            Result := True;
          end;
        end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if nMIN < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nMIN); //���ӱ���֧��
  end;
  if nMax < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam4, nMax); //���ӱ���֧��
  end;
  if (nMIN < 0) or (nMax < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMP);
    Exit;
  end;
  case cMethodMin of
    '=': begin
        if (m_WAbil.MP = nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '>': begin
        if (PlayObject.m_WAbil.MP > nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '<': begin
        if (PlayObject.m_WAbil.MP < nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    else begin
        if (PlayObject.m_WAbil.MP >= nMIN) then begin
          Result := CheckHigh;
        end;
      end;
  end;
end;

function TNormNpc.ConditionOfCheckDC(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=': begin
          if HiWord(PlayObject.m_WAbil.DC) = nMax then begin
            Result := True;
          end;
        end;
      '>': begin
          if HiWord(PlayObject.m_WAbil.DC) > nMax then begin
            Result := True;
          end;
        end;
      '<': begin
          if HiWord(PlayObject.m_WAbil.DC) < nMax then begin
            Result := True;
          end;
        end;
      else begin
          if HiWord(PlayObject.m_WAbil.DC) >= nMax then begin
            Result := True;
          end;
        end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if nMIN < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nMIN); //���ӱ���֧��
  end;
  if nMax < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam4, nMax); //���ӱ���֧��
  end;
  if (nMIN < 0) or (nMax < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKDC);
    Exit;
  end;
  case cMethodMin of
    '=': begin
        if (LoWord(PlayObject.m_WAbil.DC) = nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '>': begin
        if (LoWord(PlayObject.m_WAbil.DC) > nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '<': begin
        if (LoWord(PlayObject.m_WAbil.DC) < nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    else begin
        if (LoWord(PlayObject.m_WAbil.DC) >= nMIN) then begin
          Result := CheckHigh;
        end;
      end;
  end;
  Result := False;
end;

function TNormNpc.ConditionOfCheckMC(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=': begin
          if HiWord(PlayObject.m_WAbil.MC) = nMax then begin
            Result := True;
          end;
        end;
      '>': begin
          if HiWord(PlayObject.m_WAbil.MC) > nMax then begin
            Result := True;
          end;
        end;
      '<': begin
          if HiWord(PlayObject.m_WAbil.MC) < nMax then begin
            Result := True;
          end;
        end;
      else begin
          if HiWord(PlayObject.m_WAbil.MC) >= nMax then begin
            Result := True;
          end;
        end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if nMIN < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nMIN); //���ӱ���֧��
  end;
  if nMax < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam4, nMax); //���ӱ���֧��
  end;
  if (nMIN < 0) or (nMax < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMC);
    Exit;
  end;

  case cMethodMin of
    '=': begin
        if (LoWord(PlayObject.m_WAbil.MC) = nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '>': begin
        if (LoWord(PlayObject.m_WAbil.MC) > nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '<': begin
        if (LoWord(PlayObject.m_WAbil.MC) < nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    else begin
        if (LoWord(PlayObject.m_WAbil.MC) >= nMIN) then begin
          Result := CheckHigh;
        end;
      end;
  end;
end;

function TNormNpc.ConditionOfCheckSC(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethodMin, cMethodMax: Char;
  nMIN, nMax: Integer;
  function CheckHigh(): Boolean;
  begin
    Result := False;
    case cMethodMax of
      '=': begin
          if HiWord(PlayObject.m_WAbil.SC) = nMax then begin
            Result := True;
          end;
        end;
      '>': begin
          if HiWord(PlayObject.m_WAbil.SC) > nMax then begin
            Result := True;
          end;
        end;
      '<': begin
          if HiWord(PlayObject.m_WAbil.SC) < nMax then begin
            Result := True;
          end;
        end;
      else begin
          if HiWord(PlayObject.m_WAbil.SC) >= nMax then begin
            Result := True;
          end;
        end;
    end;
  end;
begin
  Result := False;
  cMethodMin := QuestConditionInfo.sParam1[1];
  cMethodMax := QuestConditionInfo.sParam1[3];
  nMIN := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nMax := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if nMIN < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nMIN); //���ӱ���֧��
  end;
  if nMax < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam4, nMax); //���ӱ���֧��
  end;
  if (nMIN < 0) or (nMax < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSC);
    Exit;
  end;

  case cMethodMin of
    '=': begin
        if (LoWord(PlayObject.m_WAbil.SC) = nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '>': begin
        if (LoWord(PlayObject.m_WAbil.SC) > nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    '<': begin
        if (LoWord(PlayObject.m_WAbil.SC) < nMIN) then begin
          Result := CheckHigh;
        end;
      end;
    else begin
        if (LoWord(PlayObject.m_WAbil.SC) >= nMIN) then begin
          Result := CheckHigh;
        end;
      end;
  end;
end;

function TNormNpc.ConditionOfCheckExp(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  dwExp: LongWord;
  nExp: Integer;
begin
  Result := False;
  dwExp := Str_ToInt(QuestConditionInfo.sParam2, 0);
  if dwExp = 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nExp) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKEXP);
      Exit;
    end else dwExp := nExp;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_Abil.Exp = dwExp then Result := True;
    '>': if PlayObject.m_Abil.Exp > dwExp then Result := True;
    '<': if PlayObject.m_Abil.Exp < dwExp then Result := True;
    else if PlayObject.m_Abil.Exp >= dwExp then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckFlourishPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGUild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nPoint) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKFLOURISHPOINT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nFlourishing = nPoint then Result := True;
    '>': if Guild.nFlourishing > nPoint then Result := True;
    '<': if Guild.nFlourishing < nPoint then Result := True;
    else if Guild.nFlourishing >= nPoint then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckChiefItemCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nCount: Integer;
  Guild: TGUild;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nCount) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKFLOURISHPOINT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nChiefItemCount = nCount then Result := True;
    '>': if Guild.nChiefItemCount > nCount then Result := True;
    '<': if Guild.nChiefItemCount < nCount then Result := True;
    else if Guild.nChiefItemCount >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGuildAuraePoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGUild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nPoint) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKAURAEPOINT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nAurae = nPoint then Result := True;
    '>': if Guild.nAurae > nPoint then Result := True;
    '<': if Guild.nAurae < nPoint then Result := True;
    else if Guild.nAurae >= nPoint then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGuildBuildPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGUild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nPoint) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKBUILDPOINT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nBuildPoint = nPoint then Result := True;
    '>': if Guild.nBuildPoint > nPoint then Result := True;
    '<': if Guild.nBuildPoint < nPoint then Result := True;
    else if Guild.nBuildPoint >= nPoint then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckStabilityPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nPoint: Integer;
  Guild: TGUild;
begin
  Result := False;
  nPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nPoint) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSTABILITYPOINT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if Guild.nStability = nPoint then Result := True;
    '>': if Guild.nStability > nPoint then Result := True;
    '<': if Guild.nStability < nPoint then Result := True;
    else if Guild.nStability >= nPoint then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGameGold(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGameGold: Integer;
begin
  Result := False;
  nGameGold := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nGameGold < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nGameGold) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGAMEGOLD);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nGameGold = nGameGold then Result := True;
    '>': if PlayObject.m_nGameGold > nGameGold then Result := True;
    '<': if PlayObject.m_nGameGold < nGameGold then Result := True;
    else if PlayObject.m_nGameGold >= nGameGold then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGamePoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGamePoint: Integer;
begin
  Result := False;
  nGamePoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nGamePoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nGamePoint) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGAMEPOINT);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nGamePoint = nGamePoint then Result := True;
    '>': if PlayObject.m_nGamePoint > nGamePoint then Result := True;
    '<': if PlayObject.m_nGamePoint < nGamePoint then Result := True;
    else if PlayObject.m_nGamePoint >= nGamePoint then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckGroupCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nCount: Integer;
begin
  Result := False;
  if PlayObject.m_GroupOwner = nil then Exit;

  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nCount) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKGROUPCOUNT);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_GroupOwner.m_GroupMembers.Count = nCount then Result := True;
    '>': if PlayObject.m_GroupOwner.m_GroupMembers.Count > nCount then Result := True;
    '<': if PlayObject.m_GroupOwner.m_GroupMembers.Count < nCount then Result := True;
    else if PlayObject.m_GroupOwner.m_GroupMembers.Count >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckHaveGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  //  Result:=PlayObject.m_MyGuild = nil;
  Result := PlayObject.m_MyGuild <> nil; // 01-16 �������������
end;

function TNormNpc.ConditionOfCheckInMapRange(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  sMapName: string;
  nX, nY, nRange: Integer;
begin
  Result := False;
  sMapName := QuestConditionInfo.sParam1;
  nX := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nY := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nRange := Str_ToInt(QuestConditionInfo.sParam4, -1);
  if nX < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nX); //���ӱ���֧��
  end;
  if nY < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam3, nY); //���ӱ���֧��
  end;
  if nRange < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam4, nRange); //���ӱ���֧��
  end;
  if (sMapName = '') or (nX < 0) or (nY < 0) or (nRange < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKINMAPRANGE);
    Exit;
  end;
  if CompareText(PlayObject.m_sMapName, sMapName) <> 0 then Exit;
  if (abs(PlayObject.m_nCurrX - nX) <= nRange) and (abs(PlayObject.m_nCurrY - nY) <= nRange) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsAttackGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISATTACKGUILD);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then Exit;
  Result := TUserCastle(m_Castle).IsAttackGuild(TGUild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckCastleChageDay(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nDay: Integer;
  cMethod: Char;
  nChangeDay: Integer;
begin
  Result := False;
  nDay := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nDay < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nDay); //���ӱ���֧��
  end;
  if (nDay < 0) or (m_Castle = nil) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CASTLECHANGEDAY);
    Exit;
  end;
  nChangeDay := GetDayCount(Now, TUserCastle(m_Castle).m_ChangeDate);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nChangeDay = nDay then Result := True;
    '>': if nChangeDay > nDay then Result := True;
    '<': if nChangeDay < nDay then Result := True;
    else if nChangeDay >= nDay then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckCastleWarDay(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nDay: Integer;
  cMethod: Char;
  nWarDay: Integer;
begin
  Result := False;
  nDay := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nDay < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nDay); //���ӱ���֧��
  end;
  if (nDay < 0) or (m_Castle = nil) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CASTLEWARDAY);
    Exit;
  end;
  nWarDay := GetDayCount(Now, TUserCastle(m_Castle).m_WarDate);
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nWarDay = nDay then Result := True;
    '>': if nWarDay > nDay then Result := True;
    '<': if nWarDay < nDay then Result := True;
    else if nWarDay >= nDay then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckCastleDoorStatus(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nDay: Integer;
  cMethod: Char;
  nDoorStatus: Integer;
  CastleDoor: TCastleDoor;
begin
  Result := False;
  nDay := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nDay < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nDay); //���ӱ���֧��
  end;
  nDoorStatus := -1;
  if CompareText(QuestConditionInfo.sParam1, '��') = 0 then nDoorStatus := 0;
  if CompareText(QuestConditionInfo.sParam1, '����') = 0 then nDoorStatus := 1;
  if CompareText(QuestConditionInfo.sParam1, '�ر�') = 0 then nDoorStatus := 2;

  if (nDay < 0) or (m_Castle = nil) or (nDoorStatus < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCASTLEDOOR);
    Exit;
  end;
  CastleDoor := TCastleDoor(TUserCastle(m_Castle).m_MainDoor.BaseObject);

  case nDoorStatus of
    0: if CastleDoor.m_boDeath then Result := True;
    1: if CastleDoor.m_boOpened then Result := True;
    2: if not CastleDoor.m_boOpened then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckIsAttackAllyGuild(
  PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISATTACKALLYGUILD);
    Exit;
  end;
  if PlayObject.m_MyGuild = nil then Exit;
  Result := TUserCastle(m_Castle).IsAttackAllyGuild(TGUild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckIsDefenseAllyGuild(
  PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISDEFENSEALLYGUILD);
    Exit;
  end;

  if PlayObject.m_MyGuild = nil then Exit;
  Result := TUserCastle(m_Castle).IsDefenseAllyGuild(TGUild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckIsDefenseGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if m_Castle = nil then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ISDEFENSEGUILD);
    Exit;
  end;

  if PlayObject.m_MyGuild = nil then Exit;
  Result := TUserCastle(m_Castle).IsDefenseGuild(TGUild(PlayObject.m_MyGuild));
end;

function TNormNpc.ConditionOfCheckIsCastleaGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  //  if (PlayObject.m_MyGuild <> nil) and (UserCastle.m_MasterGuild = PlayObject.m_MyGuild) then
  if g_CastleManager.IsCastleMember(PlayObject) <> nil then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsCastleMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  //if PlayObject.IsGuildMaster and (UserCastle.m_MasterGuild = PlayObject.m_MyGuild) then
  if PlayObject.IsGuildMaster and (g_CastleManager.IsCastleMember(PlayObject) <> nil) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckIsGuildMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := PlayObject.IsGuildMaster;
end;

function TNormNpc.ConditionOfCheckIsMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if (PlayObject.m_sMasterName <> '') and (PlayObject.m_boMaster) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckListCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin

end;

function TNormNpc.ConditionOfCheckItemAddValue(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  nWhere: Integer;
  nAddAllValue, nAddValue: Integer;
  UserItem: pTUserItem;
  cMethod: Char;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  if nWhere < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, nWhere); //���ӱ���֧��
  end;
  cMethod := QuestConditionInfo.sParam2[1];
  nAddValue := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if nAddValue < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam3, nAddValue); //���ӱ���֧��
  end;
  if not (nWhere in [Low(THumanUseItems)..High(THumanUseItems)]) or (nAddValue < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKITEMADDVALUE);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  if UserItem.wIndex = 0 then begin
    Exit;
  end;
  nAddAllValue := 0;
  for i := Low(UserItem.btValue) to High(UserItem.btValue) do begin
    Inc(nAddAllValue, UserItem.btValue[i]);
  end;

  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nAddAllValue = nAddValue then Result := True;
    '>': if nAddAllValue > nAddValue then Result := True;
    '<': if nAddAllValue < nAddValue then Result := True;
    else if nAddAllValue >= nAddValue then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckItemType(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nWhere: Integer;
  nType: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  nType := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nWhere < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, nWhere); //���ӱ���֧��
  end;
  if nType < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nType); //���ӱ���֧��
  end;
  if not (nWhere in [Low(THumanUseItems)..High(THumanUseItems)]) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKITEMTYPE);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  if UserItem.wIndex = 0 then Exit;
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (StdItem <> nil) and (StdItem.StdMode = nType) then begin
    Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckLevelEx(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nLevel) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKLEVELEX);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_Abil.Level = nLevel then Result := True;
    '>': if PlayObject.m_Abil.Level > nLevel then Result := True;
    '<': if PlayObject.m_Abil.Level < nLevel then Result := True;
    else if PlayObject.m_Abil.Level >= nLevel then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckNameListPostion(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sCharName: string;
  nNamePostion, nPostion: Integer;
  sLine: string;
begin
  Result := False;
  nNamePostion := -1;
  try
    sCharName := PlayObject.m_sCharName;
    LoadList := TStringList.Create;
    if FileExists(g_Config.sEnvirDir + QuestConditionInfo.sParam1) then begin
      LoadList.LoadFromFile(g_Config.sEnvirDir + QuestConditionInfo.sParam1);
      for i := 0 to LoadList.Count - 1 do begin
        sLine := Trim(LoadList.Strings[i]);
        if sLine[1] = ';' then Continue;
        if CompareText(sLine, sCharName) = 0 then begin
          nNamePostion := i;
          break;
        end;
      end;
    end else begin
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMELISTPOSITION);
    end;
  finally
    LoadList.Free
  end;
  nPostion := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nPostion < 0 then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMELISTPOSITION);
    Exit;
  end;
  if nNamePostion >= nPostion then
    Result := True;
end;

function TNormNpc.ConditionOfCheckMarry(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if PlayObject.m_sDearName <> '' then Result := True;
end;

function TNormNpc.ConditionOfCheckMarryCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nCount) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMARRYCOUNT);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btMarryCount = nCount then Result := True;
    '>': if PlayObject.m_btMarryCount > nCount then Result := True;
    '<': if PlayObject.m_btMarryCount < nCount then Result := True;
    else if PlayObject.m_btMarryCount >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if (PlayObject.m_sMasterName <> '') and (not PlayObject.m_boMaster) then
    Result := True;
end;

function TNormNpc.ConditionOfCheckMemBerLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nLevel) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMEMBERLEVEL);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nMemberLevel = nLevel then Result := True;
    '>': if PlayObject.m_nMemberLevel > nLevel then Result := True;
    '<': if PlayObject.m_nMemberLevel < nLevel then Result := True;
    else if PlayObject.m_nMemberLevel >= nLevel then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMemberType(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nType: Integer;
  cMethod: Char;
begin
  Result := False;
  nType := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nType < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nType) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMEMBERTYPE);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_nMemberType = nType then Result := True;
    '>': if PlayObject.m_nMemberType > nType then Result := True;
    '<': if PlayObject.m_nMemberType < nType then Result := True;
    else if PlayObject.m_nMemberType >= nType then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckNameIPList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sCharName: string;
  sCharAccount: string;
  sCharIPaddr: string;
  sLine: string;
  sName: string;
  sIPaddr: string;
begin
  Result := False;
  try
    sCharName := PlayObject.m_sCharName;
    sCharAccount := PlayObject.m_sUserID;
    sCharIPaddr := PlayObject.m_sIPaddr;
    LoadList := TStringList.Create;
    if FileExists(g_Config.sEnvirDir + QuestConditionInfo.sParam1) then begin
      LoadList.LoadFromFile(g_Config.sEnvirDir + QuestConditionInfo.sParam1);
      for i := 0 to LoadList.Count - 1 do begin
        sLine := LoadList.Strings[i];
        if sLine[1] = ';' then Continue;
        sIPaddr := GetValidStr3(sLine, sName, [' ', '/', #9]);
        sIPaddr := Trim(sIPaddr);
        if (sName = sCharName) and (sIPaddr = sCharIPaddr) then begin
          Result := True;
          break;
        end;
      end;
    end else begin
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMEIPLIST);
    end;
  finally
    LoadList.Free
  end;
end;

function TNormNpc.ConditionOfCheckPoseDir(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.GetPoseCreate = PlayObject) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
    case QuestConditionInfo.nParam1 of
      1: if PoseHuman.m_btGender = PlayObject.m_btGender then Result := True; //Ҫ����ͬ�Ա�
      2: if PoseHuman.m_btGender <> PlayObject.m_btGender then Result := True; //Ҫ��ͬ�Ա�
      else Result := True; //�޲���ʱ���б��Ա�
    end;
  end;
end;

function TNormNpc.ConditionOfCheckPoseGender(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
  btSex: Byte;
begin
  Result := False;
  btSex := 0;
  if CompareText(QuestConditionInfo.sParam1, 'MAN') = 0 then begin
    btSex := 0;
  end else
    if CompareText(QuestConditionInfo.sParam1, '��') = 0 then begin
    btSex := 0;
  end else
    if CompareText(QuestConditionInfo.sParam1, 'WOMAN') = 0 then begin
    btSex := 1;
  end else
    if CompareText(QuestConditionInfo.sParam1, 'Ů') = 0 then begin
    btSex := 1;
  end;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
    if PoseHuman.m_btGender = btSex then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPoseIsMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
    if (TPlayObject(PoseHuman).m_sMasterName <> '') and (TPlayObject(PoseHuman).m_boMaster) then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPoseLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  PoseHuman: TBaseObject;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nLevel) then begin //����֧�ֱ���
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKPOSELEVEL);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
    case cMethod of
      '=': if PoseHuman.m_Abil.Level = nLevel then Result := True;
      '>': if PoseHuman.m_Abil.Level > nLevel then Result := True;
      '<': if PoseHuman.m_Abil.Level < nLevel then Result := True;
      else if PoseHuman.m_Abil.Level >= nLevel then Result := True;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckPoseMarry(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
    if TPlayObject(PoseHuman).m_sDearName <> '' then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPoseMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
    if (TPlayObject(PoseHuman).m_sMasterName <> '') and not (TPlayObject(PoseHuman).m_boMaster) then
      Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckServerName(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  sServerName: string;
begin
  Result := False;
  if QuestConditionInfo.sParam1 = g_Config.sServerName then Result := True;
end;

function TNormNpc.ConditionOfCheckSlaveCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nCount) then begin
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSLAVECOUNT);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_SlaveList.Count = nCount then Result := True;
    '>': if PlayObject.m_SlaveList.Count > nCount then Result := True;
    '<': if PlayObject.m_SlaveList.Count < nCount then Result := True;
    else if PlayObject.m_SlaveList.Count >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckSafeZone(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := PlayObject.InSafeZone;
end;

function TNormNpc.ConditionOfCheckMapName(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if QuestConditionInfo.sParam1 = PlayObject.m_sMapName then Result := True;
end;

function TNormNpc.ConditionOfCheckSkill(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nSkillLevel: Integer;
  cMethod: Char;
  UserMagic: pTUserMagic;
begin
  Result := False;
  nSkillLevel := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if nSkillLevel < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam3, nSkillLevel) then begin
      ScriptConditionError(PlayObject, QuestConditionInfo, sCHECKSKILL);
      Exit;
    end;
  end;
  UserMagic := nil;
  UserMagic := TPlayObject(PlayObject).GetMagicInfo(QuestConditionInfo.sParam1);
  if UserMagic = nil then Exit;
  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if UserMagic.btLevel = nSkillLevel then Result := True;
    '>': if UserMagic.btLevel > nSkillLevel then Result := True;
    '<': if UserMagic.btLevel < nSkillLevel then Result := True;
    else if UserMagic.btLevel >= nSkillLevel then Result := True;
  end;
end;

function TNormNpc.ConditionOfAnsiContainsText(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  sValue1: string;
  sValue2: string;
begin
  Result := False;
  sValue1 := QuestConditionInfo.sParam1;
  sValue2 := QuestConditionInfo.sParam2;
  ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, sValue1);
  ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, sValue2);
  if AnsiContainsText(sValue1, sValue2) then Result := True;
end;

function TNormNpc.ConditionOfCompareText(PlayObject: TPlayObject; QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  sValue1: string;
  sValue2: string;
begin
  Result := False;
  sValue1 := QuestConditionInfo.sParam1;
  sValue2 := QuestConditionInfo.sParam2;
  ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, sValue1);
  ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, sValue2);
  if CompareText(sValue1, sValue2) = 0 then Result := True;
end;

function TNormNpc.ConditionOfGetValValue(PlayObject: TPlayObject;
  sMsg: string; var nValue: Integer): Boolean;
var
  n01: Integer;
begin
  Result := False;
  if sMsg = '' then Exit;
  n01 := GetValNameNo(sMsg);
  if n01 >= 0 then begin
    case n01 of
      0..9: begin
          nValue := PlayObject.m_nVal[n01];
          Result := True;
        end;
      100..199: begin
          nValue := g_Config.GlobalVal[n01 - 100];
          Result := True;
        end;
      200..209: begin
          nValue := PlayObject.m_DyVal[n01 - 200];
          Result := True;
        end;
      300..399: begin
          nValue := PlayObject.m_nMval[n01 - 300];
          Result := True;
        end;
      400..499: begin
          nValue := g_Config.GlobaDyMval[n01 - 400];
          Result := True;
        end;
      500..599: begin
          nValue := PlayObject.m_nInteger[n01 - 500];
          Result := True;
        end;
    end;
  end;
end;

function TNormNpc.ConditionOfGetValValue(PlayObject: TPlayObject;
  sMsg: string; var sValue: string): Boolean;
var
  n01: Integer;
begin
  Result := False;
  if sMsg = '' then Exit;
  n01 := GetValNameNo(sMsg);
  if n01 >= 0 then begin
    case n01 of
      600..699: begin
          sValue := PlayObject.m_sString[n01 - 600];
          Result := True;
        end;
      700..799: begin
          sValue := g_Config.GlobalAVal[n01 - 700];
          Result := True;
        end;
    end;
  end;
end;

procedure TNormNpc.ActionOfAnsiReplaceText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sValue1: string;
  sValue2: string;
  sValue3: string;
  n01: Integer;
begin
  sValue1 := QuestActionInfo.sParam1;
  sValue2 := QuestActionInfo.sParam2;
  sValue3 := QuestActionInfo.sParam3;
  if (sValue1 = '') or (sValue2 = '') then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ANSIREPLACETEXT);
    Exit;
  end;
  ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, sValue2);
  ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam3, sValue3);
  n01 := GetValNameNo(sValue1);
  if n01 >= 0 then begin
    case n01 of
      600..699: begin
          sValue1 := PlayObject.m_sString[n01 - 600];
          if AnsiContainsText(sValue1, sValue2) then
            PlayObject.m_sString[n01 - 600] := AnsiReplaceText(sValue1, sValue2, sValue3);
        end;
      700..799: begin
          sValue1 := g_Config.GlobalAVal[n01 - 700];
          if AnsiContainsText(sValue1, sValue2) then
            g_Config.GlobalAVal[n01 - 700] := AnsiReplaceText(sValue1, sValue2, sValue3);
        end;
      else begin
          ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ANSIREPLACETEXT);
        end;
    end;
  end else ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ANSIREPLACETEXT);
end;

procedure TNormNpc.ActionOfEncodeText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
var
  sNewValue: string;
  sValue1: string;
  sValue2: string;
  sValue3: string;
  sValue4: string;
  sValue5: string;
  sValue6: string;
  n01: Integer;
  function GetHumanInfoValue(sVariable: string; var sValue: string): Boolean;
  var
    sMsg, s10: string;
  begin
    Result := False;
    if sVariable = '' then Exit;
    sMsg := sVariable;
    ArrestStringEx(sMsg, '<', '>', s10);
    if s10 = '' then Exit;
    sVariable := s10;
    //������Ϣ
    if sVariable = '$USERNAME' then begin
      sValue := PlayObject.m_sCharName;
      Result := True;
      Exit;
    end;
    if sVariable = '$GUILDNAME' then begin
      if PlayObject.m_MyGuild <> nil then begin
        sValue := TGUild(PlayObject.m_MyGuild).sGuildName;
      end else begin
        sValue := '';
      end;
      Result := True;
      Exit;
    end;
    if sVariable = '$RANKNAME' then begin
      sValue := PlayObject.m_sGuildRankName;
      Result := True;
      Exit;
    end;
    if sVariable = '$DRESS' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_DRESS].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$WEAPON' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_WEAPON].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$RIGHTHAND' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RIGHTHAND].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$HELMET' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_HELMET].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$NECKLACE' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_NECKLACE].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$RING_R' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGR].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$RING_L' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGL].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$ARMRING_R' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGR].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$ARMRING_L' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$BUJUK' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BUJUK].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$BELT' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BELT].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$BOOTS' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BOOTS].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$CHARM' then begin
      sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_CHARM].wIndex);
      Result := True;
      Exit;
    end else
      if sVariable = '$IPADDR' then begin
      sValue := PlayObject.m_sIPaddr;
      Result := True;
      Exit;
    end else
      if sVariable = '$IPLOCAL' then begin
      sValue := PlayObject.m_sIPLocal; // GetIPLocal(PlayObject.m_sIPaddr);
      Result := True;
      Exit;
    end;
  end;
  procedure SetEncodeText(sValName, sValue: string);
  begin
    n01 := GetValNameNo(sValName);
    if n01 >= 0 then begin
      case n01 of
        600..699: begin
            PlayObject.m_sString[n01 - 600] := sValue;
          end;
        700..799: begin
            g_Config.GlobalAVal[n01 - 700] := sValue;
          end;
        else begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ENCODETEXT);
          end;
      end;
    end else ScriptActionError(PlayObject, '', QuestActionInfo, sSC_ENCODETEXT);
  end;
begin
  sValue1 := QuestActionInfo.sParam1;
  sValue2 := QuestActionInfo.sParam2;
  sValue3 := QuestActionInfo.sParam3;
  sValue4 := QuestActionInfo.sParam4;
  sValue5 := QuestActionInfo.sParam5;
  sValue6 := QuestActionInfo.sParam6;
  if (sValue2 <> '') and (sValue2[1] = '<') and (sValue2[Length(sValue2)] = '>') then begin
    GetHumanInfoValue(sValue2, sValue2);
  end else begin
    ConditionOfGetValValue(PlayObject, sValue2, sValue2);
  end;
  if (sValue3 <> '') and (sValue3[1] = '<') and (sValue3[Length(sValue3)] = '>') then begin
    GetHumanInfoValue(sValue3, sValue3);
  end else begin
    ConditionOfGetValValue(PlayObject, sValue3, sValue3);
  end;
  if (sValue4 <> '') and (sValue4[1] = '<') and (sValue4[Length(sValue4)] = '>') then begin
    GetHumanInfoValue(sValue4, sValue4);
  end else begin
    ConditionOfGetValValue(PlayObject, sValue4, sValue4);
  end;
  if (sValue5 <> '') and (sValue5[1] = '<') and (sValue5[Length(sValue5)] = '>') then begin
    GetHumanInfoValue(sValue5, sValue5);
  end else begin
    ConditionOfGetValValue(PlayObject, sValue5, sValue5);
  end;
  if (sValue6 <> '') and (sValue6[1] = '<') and (sValue6[Length(sValue6)] = '>') then begin
    GetHumanInfoValue(sValue6, sValue6);
  end else begin
    ConditionOfGetValValue(PlayObject, sValue6, sValue6);
  end;
  sNewValue := sValue2 + sValue3 + sValue4 + sValue5 + sValue6;
  SetEncodeText(sValue1, sNewValue)
end;

procedure TNormNpc.ActionOfDecodeText(PlayObject: TPlayObject; QuestActionInfo: pTQuestActionInfo);
begin

end;

constructor TNormNpc.Create; //0049AA38
begin
  inherited;
  m_boSuperMan := True;
  m_btRaceServer := RC_NPC;
  m_nLight := 2;
  m_btAntiPoison := 99;
  m_ScriptList := TList.Create;
  m_boStickMode := True;
  m_sFilePath := '';
  m_boIsHide := False;
  m_boIsQuest := True;
  m_boNpcAutoChangeColor := False;
  m_dwNpcAutoChangeColorTick := GetTickCount;
  m_dwNpcAutoChangeColorTime := 0;
  m_nNpcAutoChangeIdx := 0;
end;

destructor TNormNpc.Destroy; //0049AAE4
var
  i: Integer;
begin
  ClearScript();
  {
  for I := 0 to ScriptList.Count - 1 do begin
    Dispose(pTScript(ScriptList.Items[I]));
  end;
  }
  m_ScriptList.Free;
  inherited;
end;

procedure TNormNpc.ExeAction(PlayObject: TPlayObject; sParam1, sParam2,
  sParam3: string; nParam1, nParam2, nParam3: Integer);
var
  nInt1, nInt2, nInt3: Integer;
  dwInt: LongWord;
  BaseObject: TBaseObject;
begin
  //================================================
  //�������ﵱǰ����ֵ
  //EXEACTION CHANGEEXP 0 ������  ����Ϊָ������ֵ
  //EXEACTION CHANGEEXP 1 ������  ����ָ������
  //EXEACTION CHANGEEXP 2 ������  ����ָ������
  //================================================
  if CompareText(sParam1, 'CHANGEEXP') = 0 then begin
    nInt1 := Str_ToInt(sParam2, -1);
    case nInt1 of //
      0: begin
          if nParam3 >= 0 then begin
            PlayObject.m_Abil.Exp := LongWord(nParam3);
            PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
          end;
        end;
      1: begin
          if PlayObject.m_Abil.Exp >= LongWord(nParam3) then begin
            if (PlayObject.m_Abil.Exp - LongWord(nParam3)) > (High(LongWord) - PlayObject.m_Abil.Exp) then begin
              dwInt := High(LongWord) - PlayObject.m_Abil.Exp;
            end else begin
              dwInt := LongWord(nParam3);
            end;
          end else begin
            if (LongWord(nParam3) - PlayObject.m_Abil.Exp) > (High(LongWord) - LongWord(nParam3)) then begin
              dwInt := High(LongWord) - LongWord(nParam3);
            end else begin
              dwInt := LongWord(nParam3);
            end;
          end;
          Inc(PlayObject.m_Abil.Exp, dwInt);
          PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
        end;
      2: begin
          if PlayObject.m_Abil.Exp > LongWord(nParam3) then begin
            Dec(PlayObject.m_Abil.Exp, LongWord(nParam3));
          end else begin
            PlayObject.m_Abil.Exp := 0;
          end;
          PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
        end;
    end;
    PlayObject.SysMsg('����ǰ�������Ϊ: ' + IntToStr(PlayObject.m_Abil.Exp) + '/' + IntToStr(PlayObject.m_Abil.MaxExp), c_Green, t_Hint);
    Exit;
  end;

  //================================================
  //�������ﵱǰ�ȼ�
  //EXEACTION CHANGELEVEL 0 �ȼ���  ����Ϊָ���ȼ�
  //EXEACTION CHANGELEVEL 1 �ȼ���  ����ָ���ȼ�
  //EXEACTION CHANGELEVEL 2 �ȼ���  ����ָ���ȼ�
  //================================================
  if CompareText(sParam1, 'CHANGELEVEL') = 0 then begin
    nInt1 := Str_ToInt(sParam2, -1);
    case nInt1 of //
      0: begin
          if nParam3 >= 0 then begin
            PlayObject.m_Abil.Level := LongWord(nParam3);
            PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
          end;
        end;
      1: begin
          if PlayObject.m_Abil.Level >= LongWord(nParam3) then begin
            if (PlayObject.m_Abil.Level - LongWord(nParam3)) > (High(Word) - PlayObject.m_Abil.Level) then begin
              dwInt := High(Word) - PlayObject.m_Abil.Level;
            end else begin
              dwInt := LongWord(nParam3);
            end;
          end else begin
            if (LongWord(nParam3) - PlayObject.m_Abil.Level) > (High(Word) - LongWord(nParam3)) then begin
              dwInt := High(LongWord) - LongWord(nParam3);
            end else begin
              dwInt := LongWord(nParam3);
            end;
          end;
          Inc(PlayObject.m_Abil.Level, dwInt);
          PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
        end;
      2: begin
          if PlayObject.m_Abil.Level > LongWord(nParam3) then begin
            Dec(PlayObject.m_Abil.Level, LongWord(nParam3));
          end else begin
            PlayObject.m_Abil.Level := 0;
          end;
          PlayObject.HasLevelUp(PlayObject.m_Abil.Level - 1);
        end;
    end;
    PlayObject.SysMsg('����ǰ�ȼ�Ϊ: ' + IntToStr(PlayObject.m_Abil.Level), c_Green, t_Hint);
    Exit;
  end;

  //================================================
  //ɱ������
  //EXEACTION KILL 0 ��������,����ʾ������Ϣ
  //EXEACTION KILL 1 ��������������Ʒ,����ʾ������Ϣ
  //EXEACTION KILL 2 ��������,��ʾ������ϢΪNPC
  //EXEACTION KILL 3 ��������������Ʒ,��ʾ������ϢΪNPC
  //================================================
  if CompareText(sParam1, 'KILL') = 0 then begin
    nInt1 := Str_ToInt(sParam2, -1);
    case nInt1 of //
      1: begin
          PlayObject.m_boNoItem := True;
          PlayObject.Die;
        end;
      2: begin
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
      3: begin
          PlayObject.m_boNoItem := True;
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
      else begin
          PlayObject.Die;
        end;
    end;
    Exit;
  end;

  //================================================
  //����������
  //EXEACTION KICK
  //================================================
  if CompareText(sParam1, 'KICK') = 0 then begin
    PlayObject.m_boKickFlag := True;
    Exit;
  end;


  //==============================================================================
end;

function TNormNpc.GetLineVariableText(PlayObject: TPlayObject;
  sMsg: string): string;
var
  nC: Integer;
  s10: string;
begin
  nC := 0;
  while (True) do begin
    if TagCount(sMsg, '>') < 1 then break;
    ArrestStringEx(sMsg, '<', '>', s10);
    GetVariableText(PlayObject, sMsg, s10);
    Inc(nC);
    if nC >= 101 then break;
  end;
  Result := sMsg;
end;

procedure TNormNpc.GetVariableText(PlayObject: TPlayObject; var sMsg: string; sVariable: string); //0049AEA4
var
  sText, s14: string;
  i, ii: Integer;
  n18, n20: Integer;
  wHour: Word;
  wMinute: Word;
  wSecond: Word;
  nSecond: Integer;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;

  nSellGold: Integer;
  nRate: Integer;
  s1C: string;
  SellOffInfo: pTSellOffInfo;
  Merchant: TMerchant;
  List20: TList;
  PoseHuman: TPlayObject;
begin
  //��ʾ������
  if sVariable = '$SELLOUTGOLD' then begin
    s1C := '';
    n18 := 0;
    List20 := TList.Create;
    g_SellOffGoldList.GetUserSellOffGoldListByChrName(PlayObject.m_sCharName, List20);
    for i := 0 to List20.Count - 1 do begin
      if List20.Count <= 0 then break;
      SellOffInfo := pTSellOffInfo(List20.Items[i]);
      if g_Config.nUserSellOffTax > 0 then begin
        nRate := SellOffInfo.nSellGold * g_Config.nUserSellOffTax div 100;
        nSellGold := SellOffInfo.nSellGold - nRate;
      end else begin
        nSellGold := SellOffInfo.nSellGold;
        nRate := 0;
      end;
      s1C := s1C + '<��Ʒ:' + UserEngine.GetStdItemName(SellOffInfo.UseItems.wIndex) + ' ���:' + IntToStr(nSellGold) + ' ˰:' + IntToStr(nRate) + g_Config.sGameGoldName + ' ��������:' + DateTimeToStr(SellOffInfo.dSellDateTime) + '>\';
      Inc(n18);
      if n18 >= 7 then break;
    end;
    if s1C = '' then s1C := g_sSellOffGoldInfo;
    sMsg := sub_49ADB8(sMsg, '<$SELLOUTGOLD>', s1C);
    List20.Free;
    Exit;
  end;
  //��ʾ������Ʒ
  if sVariable = '$SELLOFFITEM' then begin
    s1C := '';
    n18 := 0;
    List20 := TList.Create;
    g_SellOffGoodList.GetUserSellOffGoodListByChrName(PlayObject.m_sCharName, List20);
    for i := 0 to List20.Count - 1 do begin
      if List20.Count <= 0 then break;
      SellOffInfo := pTSellOffInfo(List20.Items[ii]);
      s1C := s1C + '<��Ʒ:' + UserEngine.GetStdItemName(SellOffInfo.UseItems.wIndex) + ' ���:' + IntToStr(SellOffInfo.nSellGold) + g_Config.sGameGoldName + ' ��������:' + DateTimeToStr(SellOffInfo.dSellDateTime) + '>\';
      Inc(n18);
      if n18 >= 7 then break;
      //n20:=n18 div 7;
      {if n20 >= 1 then begin
        n18:=0;
        s1C := s1C + '<��һҳ/@SELLOFFITEM'+IntToStr(n20)+'>\[@SELLOFFITEM'+IntToStr(n20)+']';
      end;}
    end;
    if s1C = '' then s1C := g_sSellOffItemInfo;
    sMsg := sub_49ADB8(sMsg, '<$SELLOFFITEM>', s1C);
    List20.Free;
    Exit;
  end;
  if sVariable = '$DEALGOLDPLAY' then begin
    PoseHuman := TPlayObject(PlayObject.GetPoseCreate());
    if (PoseHuman <> nil) and (TPlayObject(PoseHuman.GetPoseCreate) = PlayObject) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
      sMsg := sub_49ADB8(sMsg, '<$DEALGOLDPLAY>', PoseHuman.m_sCharName);
    end else begin
      sMsg := sub_49ADB8(sMsg, '<$DEALGOLDPLAY>', '????');
    end;
    Exit;
  end;
  //ȫ����Ϣ
  if sVariable = '$SERVERNAME' then begin
    sMsg := sub_49ADB8(sMsg, '<$SERVERNAME>', g_Config.sServerName);
    Exit;
  end;
  if sVariable = '$SERVERIP' then begin
    sMsg := sub_49ADB8(sMsg, '<$SERVERIP>', g_Config.sServerIPaddr);
    Exit;
  end;
  if sVariable = '$WEBSITE' then begin
    sMsg := sub_49ADB8(sMsg, '<$WEBSITE>', g_Config.sWebSite);
    Exit;
  end;
  if sVariable = '$BBSSITE' then begin
    sMsg := sub_49ADB8(sMsg, '<$BBSSITE>', g_Config.sBbsSite);
    Exit;
  end;
  if sVariable = '$CLIENTDOWNLOAD' then begin
    sMsg := sub_49ADB8(sMsg, '<$CLIENTDOWNLOAD>', g_Config.sClientDownload);
    Exit;
  end;
  if sVariable = '$QQ' then begin
    sMsg := sub_49ADB8(sMsg, '<$QQ>', g_Config.sQQ);
    Exit;
  end;
  if sVariable = '$PHONE' then begin
    sMsg := sub_49ADB8(sMsg, '<$PHONE>', g_Config.sPhone);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT0' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT0>', g_Config.sBankAccount0);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT1' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT1>', g_Config.sBankAccount1);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT2' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT2>', g_Config.sBankAccount2);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT3' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT3>', g_Config.sBankAccount3);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT4' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT4>', g_Config.sBankAccount4);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT5' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT5>', g_Config.sBankAccount5);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT6' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT6>', g_Config.sBankAccount6);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT7' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT7>', g_Config.sBankAccount7);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT8' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT8>', g_Config.sBankAccount8);
    Exit;
  end;
  if sVariable = '$BANKACCOUNT9' then begin
    sMsg := sub_49ADB8(sMsg, '<$BANKACCOUNT9>', g_Config.sBankAccount9);
    Exit;
  end;
  if sVariable = '$GAMEGOLDNAME' then begin
    sMsg := sub_49ADB8(sMsg, '<$GAMEGOLDNAME>', g_Config.sGameGoldName);
    Exit;
  end;
  if sVariable = '$GAMEPOINTNAME' then begin
    sMsg := sub_49ADB8(sMsg, '<$GAMEPOINTNAME>', g_Config.sGamePointName);
    Exit;
  end;
  if sVariable = '$USERCOUNT' then begin
    sText := IntToStr(UserEngine.PlayObjectCount);
    sMsg := sub_49ADB8(sMsg, '<$USERCOUNT>', sText);
    Exit;
  end;
  if sVariable = '$MACRUNTIME' then begin
    sText := CurrToStr(GetTickCount / (24 * 60 * 60 * 1000));
    sMsg := sub_49ADB8(sMsg, '<$MACRUNTIME>', sText);
    Exit;
  end;
  if sVariable = '$SERVERRUNTIME' then begin
    nSecond := (GetTickCount() - g_dwStartTick) div 1000;
    wHour := nSecond div 3600;
    wMinute := (nSecond div 60) mod 60;
    wSecond := nSecond mod 60;
    sText := format('%d:%d:%d', [wHour, wMinute, wSecond]);
    sMsg := sub_49ADB8(sMsg, '<$SERVERRUNTIME>', sText);
    Exit;
  end;
  if sVariable = '$DATETIME' then begin
    //    sText:=DateTimeToStr(Now);
    sText := FormatDateTime('dddddd,dddd,hh:mm:nn', Now);
    sMsg := sub_49ADB8(sMsg, '<$DATETIME>', sText);
    Exit;
  end;

  if sVariable = '$HIGHLEVELINFO' then begin
    if g_HighLevelHuman <> nil then begin
      sText := TPlayObject(g_HighLevelHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHLEVELINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHPKINFO' then begin
    if g_HighPKPointHuman <> nil then begin
      sText := TPlayObject(g_HighPKPointHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHPKINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHDCINFO' then begin
    if g_HighDCHuman <> nil then begin
      sText := TPlayObject(g_HighDCHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHDCINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHMCINFO' then begin
    if g_HighMCHuman <> nil then begin
      sText := TPlayObject(g_HighMCHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHMCINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHSCINFO' then begin
    if g_HighSCHuman <> nil then begin
      sText := TPlayObject(g_HighSCHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHSCINFO>', sText);
    Exit;
  end;
  if sVariable = '$HIGHONLINEINFO' then begin
    if g_HighOnlineHuman <> nil then begin
      sText := TPlayObject(g_HighOnlineHuman).GetMyInfo;
    end else sText := '????';
    sMsg := sub_49ADB8(sMsg, '<$HIGHONLINEINFO>', sText);
    Exit;
  end;

  //������Ϣ
  if sVariable = '$USERNAME' then begin
    sMsg := sub_49ADB8(sMsg, '<$USERNAME>', PlayObject.m_sCharName);
    Exit;
  end;
  if sVariable = '$MAPNAME' then begin
    sMsg := sub_49ADB8(sMsg, '<$MAPNAME>', PlayObject.m_PEnvir.sMapDesc);
    Exit;
  end;
  if sVariable = '$GUILDNAME' then begin
    if PlayObject.m_MyGuild <> nil then begin
      sMsg := sub_49ADB8(sMsg, '<$GUILDNAME>', TGUild(PlayObject.m_MyGuild).sGuildName);
    end else begin
      sMsg := '��';
    end;
    Exit;
  end;
  if sVariable = '$RANKNAME' then begin
    sMsg := sub_49ADB8(sMsg, '<$RANKNAME>', PlayObject.m_sGuildRankName);
    Exit;
  end;

  if sVariable = '$LEVEL' then begin
    sText := IntToStr(PlayObject.m_Abil.Level);
    sMsg := sub_49ADB8(sMsg, '<$LEVEL>', sText);
    Exit;
  end;

  if sVariable = '$HP' then begin
    sText := IntToStr(PlayObject.m_WAbil.HP);
    sMsg := sub_49ADB8(sMsg, '<$HP>', sText);
    Exit;
  end;
  if sVariable = '$MAXHP' then begin
    sText := IntToStr(PlayObject.m_WAbil.MaxHP);
    sMsg := sub_49ADB8(sMsg, '<$MAXHP>', sText);
    Exit;
  end;

  if sVariable = '$MP' then begin
    sText := IntToStr(PlayObject.m_WAbil.MP);
    sMsg := sub_49ADB8(sMsg, '<$MP>', sText);
    Exit;
  end;
  if sVariable = '$MAXMP' then begin
    sText := IntToStr(PlayObject.m_WAbil.MaxMP);
    sMsg := sub_49ADB8(sMsg, '<$MAXMP>', sText);
    Exit;
  end;

  if sVariable = '$AC' then begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.AC));
    sMsg := sub_49ADB8(sMsg, '<$AC>', sText);
    Exit;
  end;
  if sVariable = '$MAXAC' then begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.AC));
    sMsg := sub_49ADB8(sMsg, '<$MAXAC>', sText);
    Exit;
  end;
  if sVariable = '$MAC' then begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.MAC));
    sMsg := sub_49ADB8(sMsg, '<$MAC>', sText);
    Exit;
  end;
  if sVariable = '$MAXMAC' then begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.MAC));
    sMsg := sub_49ADB8(sMsg, '<$MAXMAC>', sText);
    Exit;
  end;

  if sVariable = '$DC' then begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.DC));
    sMsg := sub_49ADB8(sMsg, '<$DC>', sText);
    Exit;
  end;
  if sVariable = '$MAXDC' then begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.DC));
    sMsg := sub_49ADB8(sMsg, '<$MAXDC>', sText);
    Exit;
  end;

  if sVariable = '$MC' then begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.MC));
    sMsg := sub_49ADB8(sMsg, '<$MC>', sText);
    Exit;
  end;
  if sVariable = '$MAXMC' then begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.MC));
    sMsg := sub_49ADB8(sMsg, '<$MAXMC>', sText);
    Exit;
  end;

  if sVariable = '$SC' then begin
    sText := IntToStr(LoWord(PlayObject.m_WAbil.SC));
    sMsg := sub_49ADB8(sMsg, '<$SC>', sText);
    Exit;
  end;
  if sVariable = '$MAXSC' then begin
    sText := IntToStr(HiWord(PlayObject.m_WAbil.SC));
    sMsg := sub_49ADB8(sMsg, '<$MAXSC>', sText);
    Exit;
  end;

  if sVariable = '$EXP' then begin
    sText := IntToStr(PlayObject.m_Abil.Exp);
    sMsg := sub_49ADB8(sMsg, '<$EXP>', sText);
    Exit;
  end;
  if sVariable = '$MAXEXP' then begin
    sText := IntToStr(PlayObject.m_Abil.MaxExp);
    sMsg := sub_49ADB8(sMsg, '<$MAXEXP>', sText);
    Exit;
  end;

  if sVariable = '$PKPOINT' then begin
    sText := IntToStr(PlayObject.m_nPkPoint);
    sMsg := sub_49ADB8(sMsg, '<$PKPOINT>', sText);
    Exit;
  end;
  if sVariable = '$CREDITPOINT' then begin
    sText := IntToStr(PlayObject.m_btCreditPoint);
    sMsg := sub_49ADB8(sMsg, '<$CREDITPOINT>', sText);
    Exit;
  end;

  if sVariable = '$HW' then begin
    sText := IntToStr(PlayObject.m_WAbil.HandWeight);
    sMsg := sub_49ADB8(sMsg, '<$HW>', sText);
    Exit;
  end;
  if sVariable = '$MAXHW' then begin
    sText := IntToStr(PlayObject.m_WAbil.MaxHandWeight);
    sMsg := sub_49ADB8(sMsg, '<$MAXHW>', sText);
    Exit;
  end;

  if sVariable = '$BW' then begin
    sText := IntToStr(PlayObject.m_WAbil.Weight);
    sMsg := sub_49ADB8(sMsg, '<$BW>', sText);
    Exit;
  end;
  if sVariable = '$MAXBW' then begin
    sText := IntToStr(PlayObject.m_WAbil.MaxWeight);
    sMsg := sub_49ADB8(sMsg, '<$MAXBW>', sText);
    Exit;
  end;

  if sVariable = '$WW' then begin
    sText := IntToStr(PlayObject.m_WAbil.WearWeight);
    sMsg := sub_49ADB8(sMsg, '<$WW>', sText);
    Exit;
  end;
  if sVariable = '$MAXWW' then begin
    sText := IntToStr(PlayObject.m_WAbil.MaxWearWeight);
    sMsg := sub_49ADB8(sMsg, '<$MAXWW>', sText);
    Exit;
  end;

  if sVariable = '$GOLDCOUNT' then begin
    sText := IntToStr(PlayObject.m_nGold) + '/' + IntToStr(PlayObject.m_nGoldMax);
    sMsg := sub_49ADB8(sMsg, '<$GOLDCOUNT>', sText);
    Exit;
  end;
  if sVariable = '$GAMEGOLD' then begin
    sText := IntToStr(PlayObject.m_nGameGold);
    sMsg := sub_49ADB8(sMsg, '<$GAMEGOLD>', sText);
    Exit;
  end;
  if sVariable = '$GAMEPOINT' then begin
    sText := IntToStr(PlayObject.m_nGamePoint);
    sMsg := sub_49ADB8(sMsg, '<$GAMEPOINT>', sText);
    Exit;
  end;
  if sVariable = '$HUNGER' then begin
    sText := IntToStr(PlayObject.GetMyStatus);
    sMsg := sub_49ADB8(sMsg, '<$HUNGER>', sText);
    Exit;
  end;
  if sVariable = '$LOGINTIME' then begin
    sText := DateTimeToStr(PlayObject.m_dLogonTime);
    sMsg := sub_49ADB8(sMsg, '<$LOGINTIME>', sText);
    Exit;
  end;
  if sVariable = '$LOGINLONG' then begin
    sText := IntToStr((GetTickCount - PlayObject.m_dwLogonTick) div 60000) + '����';
    sMsg := sub_49ADB8(sMsg, '<$LOGINLONG>', sText);
    Exit;
  end;
  if sVariable = '$DRESS' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_DRESS].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$DRESS>', sText);
    Exit;
  end else
    if sVariable = '$WEAPON' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_WEAPON].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$WEAPON>', sText);
    Exit;
  end else
    if sVariable = '$RIGHTHAND' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RIGHTHAND].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$RIGHTHAND>', sText);
    Exit;
  end else
    if sVariable = '$HELMET' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_HELMET].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$HELMET>', sText);
    Exit;
  end else
    if sVariable = '$NECKLACE' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_NECKLACE].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$NECKLACE>', sText);
    Exit;
  end else
    if sVariable = '$RING_R' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGR].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$RING_R>', sText);
    Exit;
  end else
    if sVariable = '$RING_L' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGL].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$RING_L>', sText);
    Exit;
  end else
    if sVariable = '$ARMRING_R' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGR].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$ARMRING_R>', sText);
    Exit;
  end else
    if sVariable = '$ARMRING_L' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$ARMRING_L>', sText);
    Exit;
  end else
    if sVariable = '$BUJUK' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BUJUK].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$BUJUK>', sText);
    Exit;
  end else
    if sVariable = '$BELT' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BELT].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$BELT>', sText);
    Exit;
  end else
    if sVariable = '$BOOTS' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BOOTS].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$BOOTS>', sText);
    Exit;
  end else
    if sVariable = '$CHARM' then begin
    sText := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_CHARM].wIndex);
    sMsg := sub_49ADB8(sMsg, '<$CHARM>', sText);
    Exit;
  end else
    if sVariable = '$IPADDR' then begin
    sText := PlayObject.m_sIPaddr;
    sMsg := sub_49ADB8(sMsg, '<$IPADDR>', sText);
    Exit;
  end else
    if sVariable = '$IPLOCAL' then begin
    sText := PlayObject.m_sIPLocal; // GetIPLocal(PlayObject.m_sIPaddr);
    sMsg := sub_49ADB8(sMsg, '<$IPLOCAL>', sText);
    Exit;
  end else
    if sVariable = '$GUILDBUILDPOINT' then begin
    if PlayObject.m_MyGuild = nil then begin
      sText := '��';
    end else begin
      sText := IntToStr(TGUild(PlayObject.m_MyGuild).nBuildPoint);
    end;
    sMsg := sub_49ADB8(sMsg, '<$GUILDBUILDPOINT>', sText);
    Exit;
  end else
    if sVariable = '$GUILDAURAEPOINT' then begin
    if PlayObject.m_MyGuild = nil then begin
      sText := '��';
    end else begin
      sText := IntToStr(TGUild(PlayObject.m_MyGuild).nAurae);
    end;
    sMsg := sub_49ADB8(sMsg, '<$GUILDAURAEPOINT>', sText);
    Exit;
  end else
    if sVariable = '$GUILDSTABILITYPOINT' then begin
    if PlayObject.m_MyGuild = nil then begin
      sText := '��';
    end else begin
      sText := IntToStr(TGUild(PlayObject.m_MyGuild).nStability);
    end;
    sMsg := sub_49ADB8(sMsg, '<$GUILDSTABILITYPOINT>', sText);
    Exit;
  end;
  if sVariable = '$GUILDFLOURISHPOINT' then begin
    if PlayObject.m_MyGuild = nil then begin
      sText := '��';
    end else begin
      sText := IntToStr(TGUild(PlayObject.m_MyGuild).nFlourishing);
    end;
    sMsg := sub_49ADB8(sMsg, '<$GUILDFLOURISHPOINT>', sText);
    Exit;
  end;

  //������Ϣ
  if sVariable = '$REQUESTCASTLEWARITEM' then begin
    sText := g_Config.sZumaPiece;
    sMsg := sub_49ADB8(sMsg, '<$REQUESTCASTLEWARITEM>', sText);
    Exit;
  end;
  if sVariable = '$REQUESTCASTLEWARDAY' then begin
    sText := g_Config.sZumaPiece;
    sMsg := sub_49ADB8(sMsg, '<$REQUESTCASTLEWARDAY>', sText);
    Exit;
  end;
  if sVariable = '$REQUESTBUILDGUILDITEM' then begin
    sText := g_Config.sWomaHorn;
    sMsg := sub_49ADB8(sMsg, '<$REQUESTBUILDGUILDITEM>', sText);
    Exit;
  end;
  if sVariable = '$OWNERGUILD' then begin
    if m_Castle <> nil then begin
      sText := TUserCastle(m_Castle).m_sOwnGuild;
      if sText = '' then sText := '��Ϸ����';
    end else begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$OWNERGUILD>', sText);
    Exit;
  end; //0049AF32

  if sVariable = '$CASTLENAME' then begin
    if m_Castle <> nil then begin
      sText := TUserCastle(m_Castle).m_sName;
    end else begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$CASTLENAME>', sText);
    Exit;
  end;
  if sVariable = '$LORD' then begin
    if m_Castle <> nil then begin
      if TUserCastle(m_Castle).m_MasterGuild <> nil then begin
        sText := TUserCastle(m_Castle).m_MasterGuild.GetChiefName();
      end else sText := '����Ա';
    end else begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$LORD>', sText);
    Exit;
  end; //0049AF32

  if sVariable = '$GUILDWARFEE' then begin
    sMsg := sub_49ADB8(sMsg, '<$GUILDWARFEE>', IntToStr(g_Config.nGuildWarPrice));
    Exit;
  end;
  if sVariable = '$BUILDGUILDFEE' then begin
    sMsg := sub_49ADB8(sMsg, '<$BUILDGUILDFEE>', IntToStr(g_Config.nBuildGuildPrice));
    Exit;
  end;

  if sVariable = '$CASTLEWARDATE' then begin
    if m_Castle = nil then begin
      m_Castle := g_CastleManager.GetCastle(0);
    end;
    if m_Castle <> nil then begin
      if not TUserCastle(m_Castle).m_boUnderWar then begin
        sText := TUserCastle(m_Castle).GetWarDate();
        if sText <> '' then begin
          sMsg := sub_49ADB8(sMsg, '<$CASTLEWARDATE>', sText);
        end else sMsg := '��ʱû���лṥ�ǣ�����\ \<����/@main>';
      end else sMsg := '�����ڹ����У�����\ \<����/@main>';
    end else begin
      sText := '????';
    end;
    Exit;
  end;

  if sVariable = '$LISTOFWAR' then begin
    if m_Castle <> nil then begin
      sText := TUserCastle(m_Castle).GetAttackWarList();
    end else begin
      sText := '????';
    end;
    if sText <> '' then begin
      sMsg := sub_49ADB8(sMsg, '<$LISTOFWAR>', sText);
    end else sMsg := '����û���л����빥��ս\ \<����/@main>';
    Exit;
  end;

  if sVariable = '$CASTLECHANGEDATE' then begin
    if m_Castle <> nil then begin
      sText := DateTimeToStr(TUserCastle(m_Castle).m_ChangeDate);
    end else begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$CASTLECHANGEDATE>', sText);
    Exit;
  end;

  if sVariable = '$CASTLEWARLASTDATE' then begin
    if m_Castle <> nil then begin
      sText := DateTimeToStr(TUserCastle(m_Castle).m_WarDate);
    end else begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$CASTLEWARLASTDATE>', sText);
    Exit;
  end;
  if sVariable = '$CASTLEGETDAYS' then begin
    if m_Castle <> nil then begin
      sText := IntToStr(GetDayCount(Now, TUserCastle(m_Castle).m_ChangeDate));
    end else begin
      sText := '????';
    end;
    sMsg := sub_49ADB8(sMsg, '<$CASTLEGETDAYS>', sText);
    Exit;
  end;

  if sVariable = '$CMD_DATE' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_DATE>', g_GameCommand.Data.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_ALLOWMSG' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_ALLOWMSG>', g_GameCommand.ALLOWMSG.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_LETSHOUT' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_LETSHOUT>', g_GameCommand.LETSHOUT.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_LETTRADE' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_LETTRADE>', g_GameCommand.LETTRADE.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_LETGUILD' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_LETGUILD>', g_GameCommand.LETGUILD.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_ENDGUILD' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_ENDGUILD>', g_GameCommand.ENDGUILD.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_BANGUILDCHAT' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_BANGUILDCHAT>', g_GameCommand.BANGUILDCHAT.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_AUTHALLY' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_AUTHALLY>', g_GameCommand.AUTHALLY.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_AUTH' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_AUTH>', g_GameCommand.AUTH.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_AUTHCANCEL' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_AUTHCANCEL>', g_GameCommand.AUTHCANCEL.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_USERMOVE' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_USERMOVE>', g_GameCommand.USERMOVE.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_SEARCHING' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_SEARCHING>', g_GameCommand.SEARCHING.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_ALLOWGROUPCALL' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_ALLOWGROUPCALL>', g_GameCommand.ALLOWGROUPCALL.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_GROUPRECALLL' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_GROUPRECALLL>', g_GameCommand.GROUPRECALLL.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_ATTACKMODE' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_ATTACKMODE>', g_GameCommand.ATTACKMODE.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_REST' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_REST>', g_GameCommand.REST.sCmd);
    Exit;
  end;

  if sVariable = '$CMD_STORAGESETPASSWORD' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_STORAGESETPASSWORD>', g_GameCommand.SETPASSWORD.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_STORAGECHGPASSWORD' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_STORAGECHGPASSWORD>', g_GameCommand.CHGPASSWORD.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_STORAGELOCK' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_STORAGELOCK>', g_GameCommand.Lock.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_STORAGEUNLOCK' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_STORAGEUNLOCK>', g_GameCommand.UNLOCKSTORAGE.sCmd);
    Exit;
  end;
  if sVariable = '$CMD_UNLOCK' then begin
    sMsg := sub_49ADB8(sMsg, '<$CMD_UNLOCK>', g_GameCommand.UnLock.sCmd);
    Exit;
  end;
  if CompareLStr(sVariable, '$HUMAN(', Length('$HUMAN(')) then begin
    ArrestStringEx(sVariable, '(', ')', s14);
    boFoundVar := False;
    for i := 0 to PlayObject.m_DynamicVarList.Count - 1 do begin
      DynamicVar := PlayObject.m_DynamicVarList.Items[i];
      if CompareText(DynamicVar.sName, s14) = 0 then begin
        case DynamicVar.VarType of
          vInteger: begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(DynamicVar.nInternet));
              boFoundVar := True;
            end;
          vString: begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', DynamicVar.sString);
              boFoundVar := True;
            end;
        end;
        break;
      end;
    end;
    if not boFoundVar then sMsg := '??';

    Exit;
  end;
  if CompareLStr(sVariable, '$GUILD(', Length('$GUILD(')) then begin
    if PlayObject.m_MyGuild = nil then Exit;
    ArrestStringEx(sVariable, '(', ')', s14);
    boFoundVar := False;
    for i := 0 to TGUild(PlayObject.m_MyGuild).m_DynamicVarList.Count - 1 do begin
      DynamicVar := TGUild(PlayObject.m_MyGuild).m_DynamicVarList.Items[i];
      if CompareText(DynamicVar.sName, s14) = 0 then begin
        case DynamicVar.VarType of
          vInteger: begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(DynamicVar.nInternet));
              boFoundVar := True;
            end;
          vString: begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', DynamicVar.sString);
              boFoundVar := True;
            end;
        end;
        break;
      end;
    end;
    if not boFoundVar then sMsg := '??';
    Exit;
  end;
  if CompareLStr(sVariable, '$GLOBAL(', Length('$GLOBAL(')) then begin
    ArrestStringEx(sVariable, '(', ')', s14);
    boFoundVar := False;
    for i := 0 to g_DynamicVarList.Count - 1 do begin
      DynamicVar := g_DynamicVarList.Items[i];
      if CompareText(DynamicVar.sName, s14) = 0 then begin
        case DynamicVar.VarType of
          vInteger: begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(DynamicVar.nInternet));
              boFoundVar := True;
            end;
          vString: begin
              sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', DynamicVar.sString);
              boFoundVar := True;
            end;
        end;
        break;
      end;
    end;
    if not boFoundVar then sMsg := '??';
    Exit;
  end;
  if CompareLStr(sVariable, '$STR(', Length('$STR(')) then begin
    ArrestStringEx(sVariable, '(', ')', s14);
    n18 := GetValNameNo(s14);
    if n18 >= 0 then begin
      case n18 of
        0..9: begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(PlayObject.m_nVal[n18]));
          end;
        100..199: begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(g_Config.GlobalVal[n18 - 100]));
          end;
        200..209: begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(PlayObject.m_DyVal[n18 - 200]));
          end;
        300..399: begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(PlayObject.m_nMval[n18 - 300]));
          end;
        400..499: begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(g_Config.GlobaDyMval[n18 - 400]));
          end;
        500..599: begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', IntToStr(PlayObject.m_nInteger[n18 - 500]));
          end;
        600..699: begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', PlayObject.m_sString[n18 - 600]);
          end;
        700..799: begin
            sMsg := sub_49ADB8(sMsg, '<' + sVariable + '>', g_Config.GlobalAVal[n18 - 700]);
          end;
      end;
    end;
  end;
end;

procedure TNormNpc.GotoLable(PlayObject: TPlayObject; sLabel: string; boExtJmp: Boolean); //0049E584
var
  i, ii, III, J: Integer;
  List1C: TStringList;
  bo11: Boolean;
  n18: Integer;
  n20: Integer;
  sSENDMSG: string;
  Script: pTScript;
  Script3C: pTScript;
  SayingRecord: pTSayingRecord;
  SayingProcedure: pTSayingProcedure;
  UserItem: pTUserItem;
  SC: string;
  function CheckQuestStatus(ScriptInfo: pTScript): Boolean; //0049BA00
  var
    i: Integer;
  begin
    Result := True;
    if not ScriptInfo.boQuest then Exit;
    i := 0;
    while (True) do begin
      if (ScriptInfo.QuestInfo[i].nRandRage > 0) and (Random(ScriptInfo.QuestInfo[i].nRandRage) <> 0) then begin
        Result := False;
        break;
      end;
      if PlayObject.GetQuestFalgStatus(ScriptInfo.QuestInfo[i].wFlag) <> ScriptInfo.QuestInfo[i].btValue then begin
        Result := False;
        break;
      end;
      Inc(i);
      if i >= 10 then break;
    end; // while
  end;
  function CheckItemW(sItemType: string; nParam: Integer): pTUserItem; //0049BA7C
  var
    nCount: Integer;
  begin
    Result := nil;
    if CompareLStr(sItemType, '[NECKLACE]', 4) then begin
      if PlayObject.m_UseItems[U_NECKLACE].wIndex > 0 then begin
        Result := @PlayObject.m_UseItems[U_NECKLACE];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[RING]', 4) then begin
      if PlayObject.m_UseItems[U_RINGL].wIndex > 0 then begin
        Result := @PlayObject.m_UseItems[U_RINGL];
      end;
      if PlayObject.m_UseItems[U_RINGR].wIndex > 0 then begin
        Result := @PlayObject.m_UseItems[U_RINGR];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[ARMRING]', 4) then begin
      if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then begin
        Result := @PlayObject.m_UseItems[U_ARMRINGL];
      end;
      if PlayObject.m_UseItems[U_ARMRINGR].wIndex > 0 then begin
        Result := @PlayObject.m_UseItems[U_ARMRINGR];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[WEAPON]', 4) then begin
      if PlayObject.m_UseItems[U_WEAPON].wIndex > 0 then begin
        Result := @PlayObject.m_UseItems[U_WEAPON];
      end;
      Exit;
    end;
    if CompareLStr(sItemType, '[HELMET]', 4) then begin
      if PlayObject.m_UseItems[U_HELMET].wIndex > 0 then begin
        Result := @PlayObject.m_UseItems[U_HELMET];
      end;
      Exit;
    end;
    Result := PlayObject.sub_4C4CD4(sItemType, nCount);
    if nCount < nParam then
      Result := nil;
  end;
  function CheckAnsiContainsTextList(sTest, sListFileName: string): Boolean;
  var
    i: Integer;
    LoadList: TStringList;
  begin
    Result := False;
    sListFileName := g_Config.sEnvirDir + sListFileName;
    if FileExists(sListFileName) then begin
      LoadList := TStringList.Create;
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessage('loading fail.... => ' + sListFileName);
      end;
      for i := 0 to LoadList.Count - 1 do begin
        if AnsiContainsText(sTest, Trim(LoadList.Strings[i])) then begin
          Result := True;
          break;
        end;
      end;
      LoadList.Free;
    end else begin
      MainOutMessage('file not found => ' + sListFileName);
    end;
  end;

  function CheckStringList(sHumName, sListFileName: string): Boolean;
  var
    i: Integer;
    LoadList: TStringList;
  begin
    Result := False;
    sListFileName := g_Config.sEnvirDir + sListFileName;
    if FileExists(sListFileName) then begin
      LoadList := TStringList.Create;
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessage('loading fail.... => ' + sListFileName);
      end;
      for i := 0 to LoadList.Count - 1 do begin
        if CompareText(Trim(LoadList.Strings[i]), sHumName) = 0 then begin
          Result := True;
          break;
        end;
      end;
      LoadList.Free;
    end else begin
      MainOutMessage('file not found => ' + sListFileName);
    end;
  end;

  function CheckVarNameNo(CheckQuestConditionInfo: pTQuestConditionInfo; var n140, n180: Integer): Boolean;
    function GetValValue(sValName: string; var nValue: Integer): Boolean;
    var
      n100: Integer;
    begin
      Result := False;
      nValue := 0;
      n100 := GetValNameNo(sValName);
      if n100 >= 0 then begin
        case n100 of
          0..9: begin
              nValue := PlayObject.m_nVal[n100];
              Result := True;
            end;
          100..199: begin
              nValue := g_Config.GlobalVal[n100 - 100];
              Result := True;
            end;
          200..209: begin
              nValue := PlayObject.m_DyVal[n100 - 200];
              Result := True;
            end;
          300..399: begin
              nValue := PlayObject.m_nMval[n100 - 300];
              Result := True;
            end;
          400..499: begin
              nValue := g_Config.GlobaDyMval[n100 - 400];
              Result := True;
            end;
          500..599: begin
              nValue := PlayObject.m_nInteger[n100 - 500];
              Result := True;
            end;
        end;
      end;
    end;

    function GetDynamicVarValue(sVarType, sValName: string; var nValue: Integer): Boolean;
    var
      n100: Integer;
      III: Integer;
      DynamicVar: pTDynamicVar;
      DynamicVarList: TList;
      sName: string;
    begin
      Result := False;
      DynamicVarList := GetDynamicVarList(PlayObject, sVarType, sName);
      if DynamicVarList = nil then begin
        DisPose(DynamicVar);
        Exit;
      end else begin
        for III := 0 to DynamicVarList.Count - 1 do begin
          DynamicVar := DynamicVarList.Items[III];
          if DynamicVar <> nil then begin
            if CompareText(DynamicVar.sName, sValName) = 0 then begin
              case DynamicVar.VarType of
                vInteger: begin
                    nValue := DynamicVar.nInternet;
                    Result := True;
                  end;
                vString: begin
                  end;
              end;
              break;
            end;
          end;
        end;
      end;
    end;
    function GetDataType: Integer; //
    var
      s10: string;
      sParam1: string;
      sParam2: string;
      sParam3: string;
    begin
      Result := -1;
      sParam1 := CheckQuestConditionInfo.sParam1;
      sParam2 := CheckQuestConditionInfo.sParam2;
      sParam3 := CheckQuestConditionInfo.sParam3;
      if IsVarNumber(sParam1) then begin
        if (sParam3 <> '') and (GetValNameNo(sParam3) >= 0) then begin
          Result := 0;
        end else
          if (sParam3 <> '') and IsStringNumber(sParam3) then begin
          Result := 1;
        end;
        Exit;
      end;
      if GetValNameNo(sParam1) >= 0 then begin
        if (sParam2 <> '') and (GetValNameNo(sParam2) >= 0) then begin
          Result := 2;
        end else
          if (sParam2 <> '') and IsVarNumber(sParam2) and (sParam3 <> '') then begin
          Result := 3;
        end else
          if (sParam2 <> '') and IsStringNumber(sParam2) then begin
          Result := 4;
        end;
      end;
    end;
  begin
    Result := False;
    n140 := -1;
    n180 := -1;
    case GetDataType of
      0: begin
          if GetDynamicVarValue(CheckQuestConditionInfo.sParam1, CheckQuestConditionInfo.sParam2, n140) and
            GetValValue(CheckQuestConditionInfo.sParam3, n180) then Result := True;
        end;
      1: begin
          n180 := CheckQuestConditionInfo.nParam3;
          if GetDynamicVarValue(CheckQuestConditionInfo.sParam1, CheckQuestConditionInfo.sParam2, n140) then Result := True;
        end;
      2: begin
          if GetValValue(CheckQuestConditionInfo.sParam1, n140) and
            GetValValue(CheckQuestConditionInfo.sParam2, n180) then Result := True;
        end;
      3: begin
          if GetValValue(CheckQuestConditionInfo.sParam1, n140) and
            GetDynamicVarValue(CheckQuestConditionInfo.sParam2, CheckQuestConditionInfo.sParam3, n180) then Result := True;
        end;
      4: begin
          n180 := CheckQuestConditionInfo.nParam2;
          if GetValValue(CheckQuestConditionInfo.sParam1, n140) then Result := True;
        end;
    end;
  end;

  function QuestCheckCondition(ConditionList: TList): Boolean;
  var
    i, ii: Integer;
    QuestConditionInfo: pTQuestConditionInfo;
    n10, n14, n18, n1C, nMaxDura, nDura: Integer;
    Hour, Min, Sec, MSec: Word;
    Envir: TEnvirnoment;
    StdItem: pTStdItem;
    s01: string;
    MonList: TList;
  begin
    Result := True;
    for i := 0 to ConditionList.Count - 1 do begin
      QuestConditionInfo := ConditionList.Items[i];
      case QuestConditionInfo.nCMDCode of
        nCHECK: begin
            n14 := Str_ToInt(QuestConditionInfo.sParam1, 0);
            n18 := Str_ToInt(QuestConditionInfo.sParam2, 0);
            n10 := PlayObject.GetQuestFalgStatus(n14);
            if n10 = 0 then begin
              if n18 <> 0 then Result := False;
            end else begin
              if n18 = 0 then Result := False;
            end;
          end;
        nRANDOM: begin
            if Random(QuestConditionInfo.nParam1) <> 0 then
              Result := False;
          end;
        nGENDER: begin
            if CompareText(QuestConditionInfo.sParam1, sMAN) = 0 then begin
              if PlayObject.m_btGender <> 0 then Result := False;
            end else begin
              if PlayObject.m_btGender <> 1 then Result := False;
            end;
          end;
        nDAYTIME: begin
            if CompareText(QuestConditionInfo.sParam1, sSUNRAISE) = 0 then begin
              if g_nGameTime <> 0 then Result := False;
            end;
            if CompareText(QuestConditionInfo.sParam1, sDAY) = 0 then begin
              if g_nGameTime <> 1 then Result := False;
            end;
            if CompareText(QuestConditionInfo.sParam1, sSUNSET) = 0 then begin
              if g_nGameTime <> 2 then Result := False;
            end;
            if CompareText(QuestConditionInfo.sParam1, sNIGHT) = 0 then begin
              if g_nGameTime <> 3 then Result := False;
            end;
          end;
        nCHECKOPEN: begin
            n14 := Str_ToInt(QuestConditionInfo.sParam1, 0);
            n18 := Str_ToInt(QuestConditionInfo.sParam2, 0);
            n10 := PlayObject.GetQuestUnitOpenStatus(n14);
            if n10 = 0 then begin
              if n18 <> 0 then Result := False;
            end else begin
              if n18 = 0 then Result := False;
            end;
          end;
        nCHECKUNIT: begin
            n14 := Str_ToInt(QuestConditionInfo.sParam1, 0);
            n18 := Str_ToInt(QuestConditionInfo.sParam2, 0);
            n10 := PlayObject.GetQuestUnitStatus(n14);
            if n10 = 0 then begin
              if n18 <> 0 then Result := False;
            end else begin
              if n18 = 0 then Result := False;
            end;
          end;
        nCHECKLEVEL: if PlayObject.m_Abil.Level < QuestConditionInfo.nParam1 then Result := False;
        nCHECKJOB: begin
            if CompareLStr(QuestConditionInfo.sParam1, sWARRIOR, 3) then begin
              if PlayObject.m_btJob <> 0 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sWIZARD, 3) then begin
              if PlayObject.m_btJob <> 1 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sTAOS, 3) then begin
              if PlayObject.m_btJob <> 2 then Result := False;
            end;
          end;
        nCHECKBBCOUNT: if PlayObject.m_SlaveList.Count < QuestConditionInfo.nParam1 then Result := False;
        nCHECKCREDITPOINT: ;
        nCHECKITEM: begin
            UserItem := PlayObject.QuestCheckItem(QuestConditionInfo.sParam1, n1C, nMaxDura, nDura);
            if n1C < QuestConditionInfo.nParam2 then
              Result := False;
          end;
        nCHECKITEMW: begin
            UserItem := CheckItemW(QuestConditionInfo.sParam1, QuestConditionInfo.nParam2);
            if UserItem = nil then
              Result := False;
          end;
        nCHECKGOLD: begin
            if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, n14) then begin //���ӱ���֧��
              n14 := QuestConditionInfo.nParam1;
            end;
            if PlayObject.m_nGold < n14 then Result := False;
          end;
        nISTAKEITEM: if SC <> QuestConditionInfo.sParam1 then Result := False;
        nCHECKDURA: begin
            UserItem := PlayObject.QuestCheckItem(QuestConditionInfo.sParam1, n1C, nMaxDura, nDura);
            if ROUND(nDura / 1000) < QuestConditionInfo.nParam2 then
              Result := False;
          end;
        nCHECKDURAEVA: begin
            UserItem := PlayObject.QuestCheckItem(QuestConditionInfo.sParam1, n1C, nMaxDura, nDura);
            if n1C > 0 then begin
              if ROUND(nMaxDura / n1C / 1000) < QuestConditionInfo.nParam2 then
                Result := False;
            end else Result := False;
          end;
        nDAYOFWEEK: begin
            if CompareLStr(QuestConditionInfo.sParam1, sSUN, Length(sSUN)) then begin
              if DayOfWeek(Now) <> 1 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sMON, Length(sMON)) then begin
              if DayOfWeek(Now) <> 2 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sTUE, Length(sTUE)) then begin
              if DayOfWeek(Now) <> 3 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sWED, Length(sWED)) then begin
              if DayOfWeek(Now) <> 4 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sTHU, Length(sTHU)) then begin
              if DayOfWeek(Now) <> 5 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sFRI, Length(sFRI)) then begin
              if DayOfWeek(Now) <> 6 then Result := False;
            end;
            if CompareLStr(QuestConditionInfo.sParam1, sSAT, Length(sSAT)) then begin
              if DayOfWeek(Now) <> 7 then Result := False;
            end;
          end;
        nHOUR: begin
            if (QuestConditionInfo.nParam1 <> 0) and (QuestConditionInfo.nParam2 = 0) then
              QuestConditionInfo.nParam2 := QuestConditionInfo.nParam1;
            DecodeTime(Time, Hour, Min, Sec, MSec);
            if (Hour < QuestConditionInfo.nParam1) or (Hour > QuestConditionInfo.nParam2) then
              Result := False;
          end;
        nMIN: begin
            if (QuestConditionInfo.nParam1 <> 0) and (QuestConditionInfo.nParam2 = 0) then
              QuestConditionInfo.nParam2 := QuestConditionInfo.nParam1;
            DecodeTime(Time, Hour, Min, Sec, MSec);
            if (Min < QuestConditionInfo.nParam1) or (Min > QuestConditionInfo.nParam2) then
              Result := False;
          end;
        nCHECKPKPOINT: begin
            if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, n14) then begin //���ӱ���֧��
              n14 := QuestConditionInfo.nParam1;
            end;
            if PlayObject.PKLevel < n14 then Result := False;
          end;

        nCHECKLUCKYPOINT: if PlayObject.m_nBodyLuckLevel < QuestConditionInfo.nParam1 then Result := False;
        nCHECKMONMAP: if not ConditionOfCheckMonMapCount(PlayObject, QuestConditionInfo) then Result := False;
        nCHECKMONAREA: ;
        nCHECKHUM: begin //0049C4CB
            if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, n14) then begin //���ӱ���֧��
              n14 := QuestConditionInfo.nParam2;
            end;
            if UserEngine.GetMapHuman(QuestConditionInfo.sParam1) < n14 then Result := False;
          end;

        nCHECKBAGGAGE: begin
            if PlayObject.IsEnoughBag then begin
              if QuestConditionInfo.sParam1 <> '' then begin
                Result := False;
                if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, s01) then begin //���ӱ���֧��
                  s01 := QuestConditionInfo.sParam1;
                end;
                StdItem := UserEngine.GetStdItem(s01);
                if StdItem <> nil then begin
                  if PlayObject.IsAddWeightAvailable(StdItem.Weight) then
                    Result := True;
                end;
              end;
            end else Result := False;
          end;
        nCHECKNAMELIST: if not CheckStringList(PlayObject.m_sCharName, m_sPath + QuestConditionInfo.sParam1) then Result := False;
        nCHECKACCOUNTLIST: if not CheckStringList(PlayObject.m_sUserID, m_sPath + QuestConditionInfo.sParam1) then Result := False;
        nCHECKIPLIST: if not CheckStringList(PlayObject.m_sIPaddr, m_sPath + QuestConditionInfo.sParam1) then Result := False;
        nEQUAL: begin
            if CheckVarNameNo(QuestConditionInfo, n14, n18) then begin
              if n14 <> n18 then Result := False;
            end else Result := False;
          end;
        nLARGE: begin
            if CheckVarNameNo(QuestConditionInfo, n14, n18) then begin
              if n14 <= n18 then Result := False;
            end else Result := False;
          end;
        nSMALL: begin
            if CheckVarNameNo(QuestConditionInfo, n14, n18) then begin
              if n14 >= n18 then Result := False;
            end else Result := False;
          end;
        nSC_ISSYSOP: if not (PlayObject.m_btPermission >= 4) then Result := False;
        nSC_ISADMIN: if not (PlayObject.m_btPermission >= 6) then Result := False;
        nSC_CHECKGROUPCOUNT: if not ConditionOfCheckGroupCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOSEDIR: if not ConditionOfCheckPoseDir(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOSELEVEL: if not ConditionOfCheckPoseLevel(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOSEGENDER: if not ConditionOfCheckPoseGender(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKLEVELEX: if not ConditionOfCheckLevelEx(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKBONUSPOINT: if not ConditionOfCheckBonusPoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMARRY: if not ConditionOfCheckMarry(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOSEMARRY: if not ConditionOfCheckPoseMarry(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMARRYCOUNT: if not ConditionOfCheckMarryCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMASTER: if not ConditionOfCheckMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_HAVEMASTER: if not ConditionOfHaveMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOSEMASTER: if not ConditionOfCheckPoseMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_POSEHAVEMASTER: if not ConditionOfPoseHaveMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKISMASTER: if not ConditionOfCheckIsMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_HASGUILD: if not ConditionOfCheckHaveGuild(PlayObject, QuestConditionInfo) then Result := False;

        nSC_ISGUILDMASTER: if not ConditionOfCheckIsGuildMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCASTLEMASTER: if not ConditionOfCheckIsCastleMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISCASTLEGUILD: if not ConditionOfCheckIsCastleaGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISATTACKGUILD: if not ConditionOfCheckIsAttackGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISDEFENSEGUILD: if not ConditionOfCheckIsDefenseGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCASTLEDOOR: if not ConditionOfCheckCastleDoorStatus(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISATTACKALLYGUILD: if not ConditionOfCheckIsAttackAllyGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISDEFENSEALLYGUILD: if not ConditionOfCheckIsDefenseAllyGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPOSEISMASTER: if not ConditionOfCheckPoseIsMaster(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKNAMEIPLIST: if not ConditionOfCheckNameIPList(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKACCOUNTIPLIST: if not ConditionOfCheckAccountIPList(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSLAVECOUNT: if not ConditionOfCheckSlaveCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISNEWHUMAN: if not PlayObject.m_boNewHuman then Result := False;
        nSC_CHECKMEMBERTYPE: if not ConditionOfCheckMemberType(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMEMBERLEVEL: if not ConditionOfCheckMemBerLevel(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKGAMEGOLD: if not ConditionOfCheckGameGold(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKGAMEPOINT: if not ConditionOfCheckGamePoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKNAMELISTPOSITION: if not ConditionOfCheckNameListPostion(PlayObject, QuestConditionInfo) then Result := False;
        //nSC_CHECKGUILDLIST:     if not ConditionOfCheckGuildList(PlayObject,QuestConditionInfo) then Result:=False;
        nSC_CHECKGUILDLIST: begin
            if PlayObject.m_MyGuild <> nil then begin
              if not CheckStringList(TGUild(PlayObject.m_MyGuild).sGuildName, m_sPath + QuestConditionInfo.sParam1) then Result := False;
            end else Result := False;
          end;
        nSC_CHECKRENEWLEVEL: if not ConditionOfCheckReNewLevel(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSLAVELEVEL: if not ConditionOfCheckSlaveLevel(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSLAVENAME: if not ConditionOfCheckSlaveName(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCREDITPOINT: if not ConditionOfCheckCreditPoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKOFGUILD: if not ConditionOfCheckOfGuild(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKPAYMENT: if not ConditionOfCheckPayMent(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKUSEITEM: if not ConditionOfCheckUseItem(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKBAGSIZE: if not ConditionOfCheckBagSize(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKLISTCOUNT: if not ConditionOfCheckListCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKDC: if not ConditionOfCheckDC(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMC: if not ConditionOfCheckMC(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSC: if not ConditionOfCheckSC(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKHP: if not ConditionOfCheckHP(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMP: if not ConditionOfCheckMP(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKITEMTYPE: if not ConditionOfCheckItemType(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKEXP: if not ConditionOfCheckExp(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCASTLEGOLD: if not ConditionOfCheckCastleGold(PlayObject, QuestConditionInfo) then Result := False;
        nSC_PASSWORDERRORCOUNT: if not ConditionOfCheckPasswordErrorCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISLOCKPASSWORD: if not ConditionOfIsLockPassword(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ISLOCKSTORAGE: if not ConditionOfIsLockStorage(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKBUILDPOINT: if not ConditionOfCheckGuildBuildPoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKAURAEPOINT: if not ConditionOfCheckGuildAuraePoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSTABILITYPOINT: if not ConditionOfCheckStabilityPoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKFLOURISHPOINT: if not ConditionOfCheckFlourishPoint(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCONTRIBUTION: if not ConditionOfCheckContribution(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKRANGEMONCOUNT: if not ConditionOfCheckRangeMonCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKITEMADDVALUE: if not ConditionOfCheckItemAddValue(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKINMAPRANGE: if not ConditionOfCheckInMapRange(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CASTLECHANGEDAY: if not ConditionOfCheckCastleChageDay(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CASTLEWARDAY: if not ConditionOfCheckCastleWarDay(PlayObject, QuestConditionInfo) then Result := False;
        nSC_ONLINELONGMIN: if not ConditionOfCheckOnlineLongMin(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKGUILDCHIEFITEMCOUNT: if not ConditionOfCheckChiefItemCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKNAMEDATELIST, nSC_CHECKUSERDATE: if not ConditionOfCheckNameDateList(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMAPHUMANCOUNT: if not ConditionOfCheckMapHumanCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKMAPMONCOUNT: if not ConditionOfCheckMapMonCount(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKVAR: if not ConditionOfCheckVar(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKSERVERNAME: if not ConditionOfCheckServerName(PlayObject, QuestConditionInfo) then Result := False;
        nCHECKMAPNAME: if not ConditionOfCheckMapName(PlayObject, QuestConditionInfo) then Result := False;
        nINSAFEZONE: if not ConditionOfCheckSafeZone(PlayObject, QuestConditionInfo) then Result := False;
        nCHECKSKILL: if not ConditionOfCheckSkill(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKCONTAINSTEXT: if not ConditionOfAnsiContainsText(PlayObject, QuestConditionInfo) then Result := False;
        nSC_COMPARETEXT: if not ConditionOfCompareText(PlayObject, QuestConditionInfo) then Result := False;
        nSC_CHECKTEXTLIST: begin
            s01 := QuestConditionInfo.sParam1;
            ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, s01);
            if not CheckStringList(s01, m_sPath + QuestConditionInfo.sParam2) then Result := False;
          end;
        nSC_ISGROUPMASTER: begin
            if PlayObject.m_GroupOwner <> nil then begin
              if PlayObject.m_GroupOwner <> PlayObject then
                Result := False;
            end else Result := False;
          end;
        nSC_CHECKCONTAINSTEXTLIST: begin
            s01 := QuestConditionInfo.sParam1;
            ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, s01);
            if not CheckAnsiContainsTextList(s01, m_sPath + QuestConditionInfo.sParam2) then Result := False;
          end;
        nSC_CHECKONLINE: begin
            s01 := QuestConditionInfo.sParam1;
            ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, s01);
            if (s01 = '') or (UserEngine.GetPlayObject(s01) = nil) then Result := False;
          end;
        nSC_ISDUPMODE: begin
            if PlayObject.m_PEnvir <> nil then begin
              if PlayObject.m_PEnvir.GetXYObjCount(PlayObject.m_nCurrX, PlayObject.m_nCurrY) >= 2 then Result := False;
            end else Result := False;
          end;
        else begin
            if Assigned(zPlugOfEngine.ConditionScriptProcess) then begin
              try
                if not zPlugOfEngine.ConditionScriptProcess(Self,
                  PlayObject,
                  QuestConditionInfo.nCMDCode,
                  PChar(QuestConditionInfo.sParam1),
                  QuestConditionInfo.nParam1,
                  PChar(QuestConditionInfo.sParam2),
                  QuestConditionInfo.nParam2,
                  PChar(QuestConditionInfo.sParam3),
                  QuestConditionInfo.nParam3,
                  PChar(QuestConditionInfo.sParam4),
                  QuestConditionInfo.nParam4,
                  PChar(QuestConditionInfo.sParam5),
                  QuestConditionInfo.nParam5,
                  PChar(QuestConditionInfo.sParam6),
                  QuestConditionInfo.nParam6) then Result := False;
              except
                Result := False;
              end;
            end;
          end;
      end;
      if not Result then break;
    end;
  end;
  function JmpToLable(sLabel: string): Boolean;
  begin
    Result := False;
    Inc(PlayObject.m_nScriptGotoCount);
    if PlayObject.m_nScriptGotoCount > g_Config.nScriptGotoCountLimit {10} then Exit;
    GotoLable(PlayObject, sLabel, False);
    Result := True;
  end;
  procedure GoToQuest(nQuest: Integer);
  var
    i: Integer;
    Script: pTScript;
  begin
    for i := 0 to m_ScriptList.Count - 1 do begin
      Script := m_ScriptList.Items[i];
      if Script.nQuest = nQuest then begin
        PlayObject.m_Script := Script;
        PlayObject.m_NPC := Self;
        GotoLable(PlayObject, sMAIN, False);
        break;
      end;
    end;
  end;

  procedure AddList(sHumName, sListFileName: string); //0049B620
  var
    i: Integer;
    LoadList: TStringList;
    s10: string;
    bo15: Boolean;
  begin
    sListFileName := g_Config.sEnvirDir + sListFileName;
    LoadList := TStringList.Create;
    if FileExists(sListFileName) then begin
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessage('loading fail.... => ' + sListFileName);
      end;
    end;
    bo15 := False;
    for i := 0 to LoadList.Count - 1 do begin
      s10 := Trim(LoadList.Strings[i]);
      if CompareText(sHumName, s10) = 0 then begin
        bo15 := True;
        break;
      end;
    end;
    if not bo15 then begin
      LoadList.Add(sHumName);
      try
        LoadList.SaveToFile(sListFileName);
      except
        MainOutMessage('saving fail.... => ' + sListFileName);
      end;
    end;

    LoadList.Free;
  end;
  procedure DelList(sHumName, sListFileName: string); //0049B7F8
  var
    i: Integer;
    LoadList: TStringList;
    s10: string;
    bo15: Boolean;
  begin
    sListFileName := g_Config.sEnvirDir + sListFileName;
    LoadList := TStringList.Create;
    if FileExists(sListFileName) then begin
      try
        LoadList.LoadFromFile(sListFileName);
      except
        MainOutMessage('loading fail.... => ' + sListFileName);
      end;
    end;
    bo15 := False;
    for i := 0 to LoadList.Count - 1 do begin
      if LoadList.Count <= 0 then break;
      s10 := Trim(LoadList.Strings[i]);
      if CompareText(sHumName, s10) = 0 then begin
        LoadList.Delete(i);
        bo15 := True;
        break;
      end;
    end;
    if bo15 then begin
      try
        LoadList.SaveToFile(sListFileName);
      except
        MainOutMessage('saving fail.... => ' + sListFileName);
      end;
    end;
    LoadList.Free;
  end;
  procedure TakeItem(sItemName: string; nItemCount: Integer; sVarNo: string); //0049C998
  var
    i: Integer;
    UserItem: pTUserItem;
    StdItem: pTStdItem;
    nCount: Integer;
    sName: string;
  begin
    nCount := nItemCount;
    sName := sItemName;
    ConditionOfGetValValue(PlayObject, sItemName, sName); //���ӱ���֧��
    ConditionOfGetValValue(PlayObject, sVarNo, nCount); //���ӱ���֧��
    if nCount <= 0 then Exit;
    if CompareText(sName, sSTRING_GOLDNAME) = 0 then begin
      PlayObject.DecGold(nCount);
      PlayObject.GoldChanged();
      //0049CADB
      if g_boGameLogGold then
        AddGameDataLog('10' + #9 +
          PlayObject.m_sMapName + #9 +
          IntToStr(PlayObject.m_nCurrX) + #9 +
          IntToStr(PlayObject.m_nCurrY) + #9 +
          PlayObject.m_sCharName + #9 +
          sSTRING_GOLDNAME + #9 +
          IntToStr(nCount) + #9 +
          '1' + #9 +
          m_sCharName);
      Exit;
    end;
    for i := PlayObject.m_ItemList.Count - 1 downto 0 do begin
      if nCount <= 0 then break;
      UserItem := PlayObject.m_ItemList.Items[i];
      if UserItem = nil then Continue;
      if CompareText(UserEngine.GetStdItemName(UserItem.wIndex), sName) = 0 then begin
        //0049CC24
        StdItem := UserEngine.GetStdItem(UserItem.wIndex);
        if StdItem.NeedIdentify = 1 then
          AddGameDataLog('10' + #9 +
            PlayObject.m_sMapName + #9 +
            IntToStr(PlayObject.m_nCurrX) + #9 +
            IntToStr(PlayObject.m_nCurrY) + #9 +
            PlayObject.m_sCharName + #9 +
            sName + #9 +
            IntToStr(UserItem.MakeIndex) + #9 +
            '1' + #9 +
            m_sCharName);
        PlayObject.SendDelItems(UserItem);
        SC := UserEngine.GetStdItemName(UserItem.wIndex);
        DisPose(UserItem);
        PlayObject.m_ItemList.Delete(i);
        Dec(nCount);
      end;
    end;
  end;

  procedure TakeWItem(sItemName: string; nItemCount: Integer); //0049CCF8
  var
    i: Integer;
    sName: string;
  begin
    if CompareLStr(sItemName, '[NECKLACE]', 4) then begin
      if PlayObject.m_UseItems[U_NECKLACE].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_NECKLACE]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_NECKLACE].wIndex);
        PlayObject.m_UseItems[U_NECKLACE].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[RING]', 4) then begin
      if PlayObject.m_UseItems[U_RINGL].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_RINGL]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGL].wIndex);
        PlayObject.m_UseItems[U_RINGL].wIndex := 0;
        Exit;
      end;
      if PlayObject.m_UseItems[U_RINGR].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_RINGR]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGR].wIndex);
        PlayObject.m_UseItems[U_RINGR].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[ARMRING]', 4) then begin
      if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_ARMRINGL]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
        PlayObject.m_UseItems[U_ARMRINGL].wIndex := 0;
        Exit;
      end;
      if PlayObject.m_UseItems[U_ARMRINGR].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_ARMRINGR]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGR].wIndex);
        PlayObject.m_UseItems[U_ARMRINGR].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[WEAPON]', 4) then begin
      if PlayObject.m_UseItems[U_WEAPON].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_WEAPON]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_WEAPON].wIndex);
        PlayObject.m_UseItems[U_WEAPON].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[HELMET]', 4) then begin
      if PlayObject.m_UseItems[U_HELMET].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_HELMET]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_HELMET].wIndex);
        PlayObject.m_UseItems[U_HELMET].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[DRESS]', 4) then begin
      if PlayObject.m_UseItems[U_DRESS].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_DRESS]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_DRESS].wIndex);
        PlayObject.m_UseItems[U_DRESS].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[U_BUJUK]', 4) then begin
      if PlayObject.m_UseItems[U_BUJUK].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_BUJUK]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BUJUK].wIndex);
        PlayObject.m_UseItems[U_BUJUK].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[U_BELT]', 4) then begin
      if PlayObject.m_UseItems[U_BELT].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_BELT]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BELT].wIndex);
        PlayObject.m_UseItems[U_BELT].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[U_BOOTS]', 4) then begin
      if PlayObject.m_UseItems[U_BOOTS].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_BOOTS]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BOOTS].wIndex);
        PlayObject.m_UseItems[U_BOOTS].wIndex := 0;
        Exit;
      end;
    end;
    if CompareLStr(sItemName, '[U_CHARM]', 4) then begin
      if PlayObject.m_UseItems[U_CHARM].wIndex > 0 then begin
        PlayObject.SendDelItems(@PlayObject.m_UseItems[U_CHARM]);
        SC := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_CHARM].wIndex);
        PlayObject.m_UseItems[U_CHARM].wIndex := 0;
        Exit;
      end;
    end;
    for i := Low(THumanUseItems) to High(THumanUseItems) do begin
      if nItemCount <= 0 then Exit;
      if PlayObject.m_UseItems[i].wIndex > 0 then begin
        sName := UserEngine.GetStdItemName(PlayObject.m_UseItems[i].wIndex);
        if CompareText(sName, sItemName) = 0 then begin
          PlayObject.SendDelItems(@PlayObject.m_UseItems[i]);
          PlayObject.m_UseItems[i].wIndex := 0;
          Dec(nItemCount);
        end;
      end;
    end;
  end;

  procedure MovData(QuestActionInfo: pTQuestActionInfo);
    function GetHumanInfoValue(sVariable: string; var sValue: string; var nValue: Integer; var nDataType: Integer): Boolean;
    var
      sMsg, s10: string;
    begin
      sValue := '';
      nValue := -1;
      nDataType := -1;
      Result := False;
      if sVariable = '' then Exit;
      sMsg := sVariable;
      ArrestStringEx(sMsg, '<', '>', s10);
      if s10 = '' then Exit;
      sVariable := s10;
      //������Ϣ
      if sVariable = '$USERNAME' then begin
        sValue := PlayObject.m_sCharName;
        nDataType := 0;
        Result := True;
        Exit;
      end;
      if sVariable = '$GUILDNAME' then begin
        if PlayObject.m_MyGuild <> nil then begin
          sValue := TGUild(PlayObject.m_MyGuild).sGuildName;
        end else begin
          sValue := '��';
        end;
        nDataType := 0;
        Result := True;
        Exit;
      end;
      if sVariable = '$RANKNAME' then begin
        sValue := PlayObject.m_sGuildRankName;
        nDataType := 0;
        Result := True;
        Exit;
      end;

      if sVariable = '$LEVEL' then begin
        nValue := PlayObject.m_Abil.Level;
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$HP' then begin
        nValue := PlayObject.m_WAbil.HP;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXHP' then begin
        nValue := PlayObject.m_WAbil.MaxHP;
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$MP' then begin
        nValue := PlayObject.m_WAbil.MP;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXMP' then begin
        nValue := PlayObject.m_WAbil.MaxMP;
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$AC' then begin
        nValue := LoWord(PlayObject.m_WAbil.AC);
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXAC' then begin
        nValue := HiWord(PlayObject.m_WAbil.AC);
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAC' then begin
        nValue := LoWord(PlayObject.m_WAbil.MAC);
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXMAC' then begin
        nValue := HiWord(PlayObject.m_WAbil.MAC);
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$DC' then begin
        nValue := LoWord(PlayObject.m_WAbil.DC);
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXDC' then begin
        nValue := HiWord(PlayObject.m_WAbil.DC);
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$MC' then begin
        nValue := LoWord(PlayObject.m_WAbil.MC);
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXMC' then begin
        nValue := HiWord(PlayObject.m_WAbil.MC);
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$SC' then begin
        nValue := LoWord(PlayObject.m_WAbil.SC);
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXSC' then begin
        nValue := HiWord(PlayObject.m_WAbil.SC);
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$EXP' then begin
        nValue := PlayObject.m_Abil.Exp;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXEXP' then begin
        nValue := PlayObject.m_Abil.MaxExp;
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$PKPOINT' then begin
        nValue := PlayObject.m_nPkPoint;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$CREDITPOINT' then begin
        nValue := PlayObject.m_btCreditPoint;
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$HW' then begin
        nValue := PlayObject.m_WAbil.HandWeight;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXHW' then begin
        nValue := PlayObject.m_WAbil.MaxHandWeight;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$BW' then begin
        nValue := PlayObject.m_WAbil.Weight;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXBW' then begin
        nValue := PlayObject.m_WAbil.MaxWeight;
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$WW' then begin
        nValue := PlayObject.m_WAbil.WearWeight;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$MAXWW' then begin
        nValue := PlayObject.m_WAbil.MaxWearWeight;
        nDataType := 1;
        Result := True;
        Exit;
      end;

      if sVariable = '$GOLDCOUNT' then begin
        nValue := PlayObject.m_nGold;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$GAMEGOLD' then begin
        nValue := PlayObject.m_nGameGold;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$GAMEPOINT' then begin
        nValue := PlayObject.m_nGamePoint;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$HUNGER' then begin
        nValue := PlayObject.GetMyStatus;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$LOGINTIME' then begin
        sValue := DateTimeToStr(PlayObject.m_dLogonTime);
        nDataType := 0;
        Result := True;
        Exit;
      end;
      if sVariable = '$DATETIME' then begin
        sValue := FormatDateTime('dddddd,dddd,hh:mm:nn', Now);
        nDataType := 0;
        Result := True;
        Exit;
      end;
      if sVariable = '$LOGINLONG' then begin
        nValue := (GetTickCount - PlayObject.m_dwLogonTick) div 60000;
        nDataType := 1;
        Result := True;
        Exit;
      end;
      if sVariable = '$DRESS' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_DRESS].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$WEAPON' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_WEAPON].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$RIGHTHAND' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RIGHTHAND].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$HELMET' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_HELMET].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$NECKLACE' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_NECKLACE].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$RING_R' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGR].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$RING_L' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_RINGL].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$ARMRING_R' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGR].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$ARMRING_L' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$BUJUK' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BUJUK].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$BELT' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BELT].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$BOOTS' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_BOOTS].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$CHARM' then begin
        sValue := UserEngine.GetStdItemName(PlayObject.m_UseItems[U_CHARM].wIndex);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$IPADDR' then begin
        sValue := PlayObject.m_sIPaddr;
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$IPLOCAL' then begin
        sValue := PlayObject.m_sIPLocal; // GetIPLocal(PlayObject.m_sIPaddr);
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$GUILDBUILDPOINT' then begin
        if PlayObject.m_MyGuild <> nil then begin
          nValue := TGUild(PlayObject.m_MyGuild).nBuildPoint;
        end;
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$GUILDAURAEPOINT' then begin
        if PlayObject.m_MyGuild <> nil then begin
          nValue := TGUild(PlayObject.m_MyGuild).nAurae;
        end;
        nDataType := 0;
        Result := True;
        Exit;
      end else
        if sVariable = '$GUILDSTABILITYPOINT' then begin
        if PlayObject.m_MyGuild <> nil then begin
          nValue := TGUild(PlayObject.m_MyGuild).nStability;
        end;
        nDataType := 0;
        Result := True;
        Exit;
      end;
      if sVariable = '$GUILDFLOURISHPOINT' then begin
        if PlayObject.m_MyGuild <> nil then begin
          nValue := TGUild(PlayObject.m_MyGuild).nFlourishing;
        end;
        nDataType := 0;
        Result := True;
        Exit;
      end;
    end;

    function SetValNameValue(sVarName: string; sValue: string; nValue: Integer; nDataType: Integer): Boolean;
    var
      n100: Integer;
    begin
      n100 := GetValNameNo(sVarName);
      if n100 >= 0 then begin
        case nDataType of
          1: begin
              case n100 of
                0..9: begin
                    PlayObject.m_nVal[n100] := nValue;
                    Result := True;
                  end;
                100..199: begin
                    g_Config.GlobalVal[n100 - 100] := nValue;
                    Result := True;
                  end;
                200..209: begin
                    PlayObject.m_DyVal[n100 - 200] := nValue;
                    Result := True;
                  end;
                300..399: begin
                    PlayObject.m_nMval[n100 - 300] := nValue;
                    Result := True;
                  end;
                400..499: begin
                    g_Config.GlobaDyMval[n100 - 400] := nValue;
                    Result := True;
                  end;
                500..599: begin
                    PlayObject.m_nInteger[n100 - 500] := nValue;
                    Result := True;
                  end;
                else begin
                    Result := False;
                  end;
              end;
            end;
          0: begin
              case n100 of
                600..699: begin
                    PlayObject.m_sString[n100 - 600] := sValue;
                    Result := True;
                  end;
                700..799: begin
                    g_Config.GlobalAVal[n100 - 700] := sValue;
                    Result := True;
                  end;
                else begin
                    Result := False;
                  end;
              end;
            end;
          3: begin
              case n100 of
                0..9: begin
                    PlayObject.m_nVal[n100] := nValue;
                    Result := True;
                  end;
                100..199: begin
                    g_Config.GlobalVal[n100 - 100] := nValue;
                    Result := True;
                  end;
                200..209: begin
                    PlayObject.m_DyVal[n100 - 200] := nValue;
                    Result := True;
                  end;
                300..399: begin
                    PlayObject.m_nMval[n100 - 300] := nValue;
                    Result := True;
                  end;
                400..499: begin
                    g_Config.GlobaDyMval[n100 - 400] := nValue;
                    Result := True;
                  end;
                500..599: begin
                    PlayObject.m_nInteger[n100 - 500] := nValue;
                    Result := True;
                  end;
                600..699: begin
                    PlayObject.m_sString[n100 - 600] := sValue;
                    Result := True;
                  end;
                700..799: begin
                    g_Config.GlobalAVal[n100 - 700] := sValue;
                    Result := True;
                  end;
                else begin
                    Result := False;
                  end;
              end;
            end;
        end;

      end else Result := False;
    end;
    function GetValNameValue(sVarName: string; var sValue: string; var nValue: Integer; var nDataType: Integer): Boolean;
    var
      n100: Integer;
    begin
      nValue := -1;
      sValue := '';
      nDataType := -1;
      n100 := GetValNameNo(sVarName);
      if n100 >= 0 then begin
        case n100 of
          0..9: begin
              nValue := PlayObject.m_nVal[n100];
              nDataType := 1;
              Result := True;
            end;
          100..199: begin
              nValue := g_Config.GlobalVal[n100 - 100];
              nDataType := 1;
              Result := True;
            end;
          200..209: begin
              nValue := PlayObject.m_DyVal[n100 - 200];
              nDataType := 1;
              Result := True;
            end;
          300..399: begin
              nValue := PlayObject.m_nMval[n100 - 300];
              nDataType := 1;
              Result := True;
            end;
          400..499: begin
              nValue := g_Config.GlobaDyMval[n100 - 400];
              nDataType := 1;
              Result := True;
            end;
          500..599: begin
              nValue := PlayObject.m_nInteger[n100 - 500];
              nDataType := 1;
              Result := True;
            end;
          600..699: begin
              sValue := PlayObject.m_sString[n100 - 600];
              nDataType := 0;
              Result := True;
            end;
          700..799: begin
              sValue := g_Config.GlobalAVal[n100 - 700];
              nDataType := 0;
              Result := True;
            end;
          else begin
              Result := False;
            end;
        end;
      end else Result := False;
    end;

    function GetDynamicVarValue(sVarType, sVarName: string; var sValue: string; var nValue: Integer; var nDataType: Integer): Boolean;
    var
      V: Integer;
      DynamicVar: pTDynamicVar;
      DynamicVarList: TList;
      sName: string;
      boVarFound: Boolean;
    begin
      boVarFound := False;
      sValue := '';
      nValue := -1;
      nDataType := -1;
      DynamicVarList := GetDynamicVarList(PlayObject, sVarType, sName);
      if DynamicVarList = nil then begin
        DisPose(DynamicVar);
        Result := False;
        Exit;
      end;
      for V := 0 to DynamicVarList.Count - 1 do begin
        DynamicVar := DynamicVarList.Items[V];
        if CompareText(DynamicVar.sName, sVarName) = 0 then begin
          case DynamicVar.VarType of
            vInteger: begin
                nValue := DynamicVar.nInternet;
                nDataType := 1;
              end;
            vString: begin
                sValue := DynamicVar.sString;
                nDataType := 0;
              end;
          end;
          boVarFound := True;
          break;
        end;
      end;
      if not boVarFound then Result := False else Result := True;
    end;

    function SetDynamicVarValue(sVarType, sVarName: string; sValue: string; nValue: Integer; nDataType: Integer): Boolean;
    var
      V: Integer;
      DynamicVar: pTDynamicVar;
      DynamicVarList: TList;
      sName: string;
      boVarFound: Boolean;
    begin
      boVarFound := False;
      DynamicVarList := GetDynamicVarList(PlayObject, sVarType, sName);
      if DynamicVarList = nil then begin
        DisPose(DynamicVar);
        Result := False;
        Exit;
      end;
      for V := 0 to DynamicVarList.Count - 1 do begin
        DynamicVar := DynamicVarList.Items[V];
        if CompareText(DynamicVar.sName, sVarName) = 0 then begin
          if nDataType = 1 then begin
            case DynamicVar.VarType of
              vInteger: begin
                  DynamicVar.nInternet := nValue;
                  boVarFound := True;
                  break;
                end;
            end;
          end else begin
            case DynamicVar.VarType of
              vString: begin
                  DynamicVar.sString := sValue;
                  boVarFound := True;
                  break;
                end;
            end;
          end;
        end;
      end;
      if not boVarFound then Result := False else Result := True;
    end;

    function GetDataType: Integer; //
    var
      s10: string;
      sParam1: string;
      sParam2: string;
      sParam3: string;
      n01: Integer;
    begin
      Result := -1;
      sParam1 := QuestActionInfo.sParam1;
      sParam2 := QuestActionInfo.sParam2;
      sParam3 := QuestActionInfo.sParam3;
      if IsVarNumber(sParam1) then begin
        if (sParam3 <> '') and (sParam3[1] = '<') and (sParam3[Length(sParam3)] = '>') {TagCount(sParam3, '>') > 0} then begin
          Result := 0;
        end else
          if (sParam3 <> '') and (GetValNameNo(sParam3) >= 0) then begin
          Result := 1;
        end else
          if (sParam3 <> '') and IsStringNumber(sParam3) then begin
          Result := 2;
        end else begin
          Result := 3;
        end;
        Exit;
      end;
      n01 := GetValNameNo(sParam1);
      if n01 >= 0 then begin
        if (sParam2 <> '') and (sParam2[1] = '<') and (sParam2[Length(sParam2)] = '>') then begin
          Result := 4;
        end else
          if (sParam2 <> '') and (GetValNameNo(sParam2) >= 0) then begin
          Result := 5;
        end else
          if (sParam2 <> '') and IsVarNumber(sParam2) then begin
          Result := 6;
        end else begin
          Result := 7;
        end;
        Exit;
      end;
    end;
  var
    sParam1: string;
    sParam2: string;
    sParam3: string;
    sString: string;
    sValue: string;
    nValue: Integer;
    nDataType: Integer;
  resourcestring
    sVarFound = '����%s�����ڣ���������:%s';
    sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
    sDataTypeError = '�������Ͳ�һ�£���������:%s %s';
  begin
    sParam1 := QuestActionInfo.sParam1;
    sParam2 := QuestActionInfo.sParam2;
    sParam3 := QuestActionInfo.sParam3;
    if sParam1 = '' then begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
      Exit;
    end;
    case GetDataType of
      0: begin
          if GetHumanInfoValue(sParam3, sValue, nValue, nDataType) then begin
            if not SetDynamicVarValue(sParam1, sParam2, sValue, nValue, nDataType) then
              ScriptActionError(PlayObject, format(sVarFound, [sParam1, sParam2]), QuestActionInfo, sMOV);
          end else begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end;
          Exit;
        end;
      1: begin
          if GetValNameValue(sParam3, sValue, nValue, nDataType) then begin
            //MainOutMessage('GetValNameValue sValue '+sValue+' nDataType '+IntToStr(nDataType));
            if not SetDynamicVarValue(sParam1, sParam2, sValue, nValue, nDataType) then
              ScriptActionError(PlayObject, format(sVarFound, [sParam1, sParam2]), QuestActionInfo, sMOV);
          end else begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end;
          Exit;
        end;
      2: begin
          if not SetDynamicVarValue(sParam1, sParam2, QuestActionInfo.sParam3, QuestActionInfo.nParam3, 1) then
            ScriptActionError(PlayObject, format(sVarFound, [sParam1, sParam2]), QuestActionInfo, sMOV);
        end;
      3: begin
          if not SetDynamicVarValue(sParam1, sParam2, QuestActionInfo.sParam3, QuestActionInfo.nParam3, 0) then
            ScriptActionError(PlayObject, format(sVarFound, [sParam1, sParam2]), QuestActionInfo, sMOV);
        end;
      //==============================================================================
      4: begin
          if GetHumanInfoValue(sParam2, sValue, nValue, nDataType) then begin
            if not SetValNameValue(sParam1, sValue, nValue, nDataType) then
              ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end else begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end;
          Exit;
        end;
      5: begin
          if GetValNameValue(sParam2, sValue, nValue, nDataType) then begin
            if not SetValNameValue(sParam1, sValue, nValue, nDataType) then
              ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end else begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end;
          Exit;
        end;
      6: begin
          if GetDynamicVarValue(sParam2, sParam3, sValue, nValue, nDataType) then begin
            if not SetValNameValue(sParam1, sValue, nValue, nDataType) then
              ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end else begin
            ScriptActionError(PlayObject, format(sVarFound, [sParam2, sParam3]), QuestActionInfo, sMOV);
          end;
          Exit;
        end;
      7: begin
          if GetValNameValue(sParam1, sValue, nValue, nDataType) then begin
            if not SetValNameValue(sParam1, QuestActionInfo.sParam2, QuestActionInfo.nParam2, nDataType) then begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
              Exit;
            end;
          end else begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end;
        end;
      {8: begin
          if not SetValNameValue(sParam1, QuestActionInfo.sParam2, QuestActionInfo.nParam2, 0) then begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end else begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          end;
          Exit;
        end;}
      else begin
          ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
        end;
    end;
  end;

  procedure ChangeInteger(QuestActionInfo: pTQuestActionInfo; nChgType: Integer);
    function SetValNameValue(sVarName: string; nValue: Integer): Boolean;
    var
      n100: Integer;
    begin
      n100 := GetValNameNo(sVarName);
      if n100 >= 0 then begin
        case n100 of
          0..9: begin
              PlayObject.m_nVal[n100] := nValue;
              Result := True;
            end;
          100..199: begin
              g_Config.GlobalVal[n100 - 100] := nValue;
              Result := True;
            end;
          200..209: begin
              PlayObject.m_DyVal[n100 - 200] := nValue;
              Result := True;
            end;
          300..399: begin
              PlayObject.m_nMval[n100 - 300] := nValue;
              Result := True;
            end;
          400..499: begin
              g_Config.GlobaDyMval[n100 - 400] := nValue;
              Result := True;
            end;
          500..599: begin
              PlayObject.m_nInteger[n100 - 500] := nValue;
              Result := True;
            end;
          else begin
              Result := False;
            end;
        end;
      end else Result := False;
    end;

    function SetDynamicVarValue(sVarType, sVarName: string; nValue: Integer): Boolean;
    var
      V: Integer;
      DynamicVar: pTDynamicVar;
      DynamicVarList: TList;
      sName: string;
      boVarFound: Boolean;
    begin
      boVarFound := False;
      DynamicVarList := GetDynamicVarList(PlayObject, sVarType, sName);
      if DynamicVarList = nil then begin
        DisPose(DynamicVar);
        Result := False;
        Exit;
      end;
      for V := 0 to DynamicVarList.Count - 1 do begin
        DynamicVar := DynamicVarList.Items[V];
        if CompareText(DynamicVar.sName, sVarName) = 0 then begin
          case DynamicVar.VarType of
            vInteger: begin
                DynamicVar.nInternet := nValue;
                boVarFound := True;
                break;
              end;
          end;
        end;
      end;
      if not boVarFound then Result := False else Result := True;
    end;

    function GetValValue(sValName: string; var nValue: Integer): Boolean;
    var
      n100: Integer;
    begin
      Result := False;
      nValue := 0;
      n100 := GetValNameNo(sValName);
      if n100 >= 0 then begin
        case n100 of
          0..9: begin
              nValue := PlayObject.m_nVal[n100];
              Result := True;
            end;
          100..199: begin
              nValue := g_Config.GlobalVal[n100 - 100];
              Result := True;
            end;
          200..209: begin
              nValue := PlayObject.m_DyVal[n100 - 200];
              Result := True;
            end;
          300..399: begin
              nValue := PlayObject.m_nMval[n100 - 300];
              Result := True;
            end;
          400..499: begin
              nValue := g_Config.GlobaDyMval[n100 - 400];
              Result := True;
            end;
          500..599: begin
              nValue := PlayObject.m_nInteger[n100 - 500];
              Result := True;
            end;
        end;
      end;
    end;

    function GetDynamicVarValue(sVarType, sValName: string; var nValue: Integer): Boolean;
    var
      n100: Integer;
      III: Integer;
      DynamicVar: pTDynamicVar;
      DynamicVarList: TList;
      sName: string;
    begin
      Result := False;
      DynamicVarList := GetDynamicVarList(PlayObject, sVarType, sName);
      if DynamicVarList = nil then begin
        DisPose(DynamicVar);
        Exit;
      end else begin
        for III := 0 to DynamicVarList.Count - 1 do begin
          DynamicVar := DynamicVarList.Items[III];
          if DynamicVar <> nil then begin
            if CompareText(DynamicVar.sName, sValName) = 0 then begin
              case DynamicVar.VarType of
                vInteger: begin
                    nValue := DynamicVar.nInternet;
                    Result := True;
                  end;
                vString: begin
                  end;
              end;
              break;
            end;
          end;
        end;
      end;
    end;
    function GetDataType: Integer; //
    var
      s10: string;
      sParam1: string;
      sParam2: string;
      sParam3: string;
    begin
      Result := -1;
      sParam1 := QuestActionInfo.sParam1;
      sParam2 := QuestActionInfo.sParam2;
      sParam3 := QuestActionInfo.sParam3;
      if IsVarNumber(sParam1) then begin
        if (sParam3 <> '') and (GetValNameNo(sParam3) >= 0) then begin
          Result := 0;
        end else
          if (sParam3 <> '') and IsStringNumber(sParam3) then begin
          Result := 1;
        end;
        Exit;
      end;
      if GetValNameNo(sParam1) >= 0 then begin
        if (sParam2 <> '') and (GetValNameNo(sParam2) >= 0) then begin
          Result := 2;
        end else
          if (sParam2 <> '') and IsVarNumber(sParam2) and (sParam3 <> '') then begin
          Result := 3;
        end else
          if (sParam2 <> '') and IsStringNumber(sParam2) then begin
          Result := 4;
        end;
      end;
    end;
  begin

  end;
  procedure IncInteger(QuestActionInfo: pTQuestActionInfo);
  var
    i, n14, n3C, n10: Integer;
    DynamicVar: pTDynamicVar;
    DynamicVarList: TList;
    sName: string;
    boVarFound: Boolean;
    sParam1: string;
    sParam2: string;
    sParam3: string;
  resourcestring
    sVarFound = '����%s�����ڣ���������:%s';
    sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
  begin
    n10 := 0;
    sParam1 := QuestActionInfo.sParam1;
    sParam2 := QuestActionInfo.sParam2;
    sParam3 := QuestActionInfo.sParam3;
    if (sParam1 = '') or (sParam2 = '') then begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
      Exit;
    end;
    if sParam3 <> '' then begin
      if (not IsVarNumber(sParam1)) and (IsVarNumber(sParam2)) then begin
        n10 := 1;
        boVarFound := False;
        DynamicVarList := GetDynamicVarList(PlayObject, sParam2, sName);
        if DynamicVarList = nil then begin
          DisPose(DynamicVar);
          ScriptActionError(PlayObject, format(sVarTypeError, [sParam2]), QuestActionInfo, sINC);
          Exit;
        end;
        for i := 0 to DynamicVarList.Count - 1 do begin
          DynamicVar := DynamicVarList.Items[i];
          if CompareText(DynamicVar.sName, sParam3) = 0 then begin
            case DynamicVar.VarType of
              vInteger: begin
                  n3C := DynamicVar.nInternet;
                end;
              vString: begin
                end;
            end;
            boVarFound := True;
            break;
          end;
        end;
        if not boVarFound then begin
          ScriptActionError(PlayObject, format(sVarFound, [sParam3, sParam2]), QuestActionInfo, sINC);
          Exit;
        end;
        n14 := GetValNameNo(sParam1);
        if n14 >= 0 then begin
          case n14 of
            0..9: begin
                if n3C > 1 then begin
                  Inc(PlayObject.m_nVal[n14], n3C);
                end else begin
                  Inc(PlayObject.m_nVal[n14]);
                end;
              end;
            100..199: begin
                if n3C > 1 then begin
                  Inc(g_Config.GlobalVal[n14 - 100], n3C);
                end else begin
                  Inc(g_Config.GlobalVal[n14 - 100]);
                end;
              end;
            200..209: begin
                if n3C > 1 then begin
                  Inc(PlayObject.m_DyVal[n14 - 200], n3C);
                end else begin
                  Inc(PlayObject.m_DyVal[n14 - 200]);
                end;
              end;
            300..399: begin
                if n3C > 1 then begin
                  Inc(PlayObject.m_nMval[n14 - 300], n3C);
                end else begin
                  Inc(PlayObject.m_nMval[n14 - 300]);
                end;
              end;
            400..499: begin
                if n3C > 1 then begin
                  Inc(g_Config.GlobaDyMval[n14 - 400], n3C);
                end else begin
                  Inc(g_Config.GlobaDyMval[n14 - 400]);
                end;
              end;
            500..599: begin
                if n3C > 1 then begin
                  Inc(PlayObject.m_nInteger[n14 - 500], n3C);
                end else begin
                  Inc(PlayObject.m_nInteger[n14 - 500]);
                end;
              end;
            else begin
                ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
                Exit;
              end;
          end;
        end else begin
          ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
          Exit;
        end;
        Exit;
      end;
      if (IsVarNumber(sParam1)) and (not IsVarNumber(sParam2)) then begin
        if (sParam3 <> '') and (not IsStringNumber(sParam3)) then begin
          n10 := 1;
          n14 := GetValNameNo(sParam3);
          if n14 >= 0 then begin
            case n14 of
              0..9: begin
                  n3C := PlayObject.m_nVal[n14];
                end;
              100..199: begin
                  n3C := g_Config.GlobalVal[n14 - 100];
                end;
              200..209: begin
                  n3C := PlayObject.m_DyVal[n14 - 200];
                end;
              300..399: begin
                  n3C := PlayObject.m_nMval[n14 - 300];
                end;
              400..499: begin
                  n3C := g_Config.GlobaDyMval[n14 - 400];
                end;
              500..599: begin
                  n3C := PlayObject.m_nInteger[n14 - 500];
                end;
              else begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
                  Exit;
                end;
            end;
          end else begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
            Exit;
          end;
        end else n3C := QuestActionInfo.nParam3;
        boVarFound := False;
        DynamicVarList := GetDynamicVarList(PlayObject, sParam1, sName);
        if DynamicVarList = nil then begin
          DisPose(DynamicVar);
          ScriptActionError(PlayObject, format(sVarTypeError, [sParam1]), QuestActionInfo, sINC);
          Exit;
        end;
        for i := 0 to DynamicVarList.Count - 1 do begin
          DynamicVar := DynamicVarList.Items[i];
          if CompareText(DynamicVar.sName, sParam2) = 0 then begin
            case DynamicVar.VarType of
              vInteger: begin
                  if n3C > 1 then begin
                    Inc(DynamicVar.nInternet, n3C);
                  end else begin
                    Inc(DynamicVar.nInternet);
                  end;
                end;
              vString: begin
                end;
            end;
            boVarFound := True;
            break;
          end;
        end;
        if not boVarFound then begin
          ScriptActionError(PlayObject, format(sVarFound, [sParam2, sParam1]), QuestActionInfo, sINC);
          Exit;
        end;
        Exit;
      end;
      if n10 = 0 then
        ScriptActionError(PlayObject, '', QuestActionInfo, sINC);
    end else begin
      if (sParam2 <> '') and (not IsStringNumber(sParam2)) then begin //��ȡ��2������ֵ
        n14 := GetValNameNo(sParam2);
        if n14 >= 0 then begin
          case n14 of
            0..9: begin
                n3C := PlayObject.m_nVal[n14];
              end;
            100..199: begin
                n3C := g_Config.GlobalVal[n14 - 100];
              end;
            200..209: begin
                n3C := PlayObject.m_DyVal[n14 - 200];
              end;
            300..399: begin
                n3C := PlayObject.m_nMval[n14 - 300];
              end;
            400..499: begin
                n3C := g_Config.GlobaDyMval[n14 - 400];
              end;
            500..599: begin
                n3C := PlayObject.m_nInteger[n14 - 500];
              end;
            else begin
                ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
                Exit;
              end;
          end;
        end else begin
          ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
          Exit;
        end;
      end else n3C := QuestActionInfo.nParam2;
      n14 := GetValNameNo(sParam1);
      if n14 >= 0 then begin
        case n14 of
          0..9: begin
              if n3C > 1 then begin
                Inc(PlayObject.m_nVal[n14], n3C);
              end else begin
                Inc(PlayObject.m_nVal[n14]);
              end;
            end;
          100..199: begin
              if n3C > 1 then begin
                Inc(g_Config.GlobalVal[n14 - 100], n3C);
              end else begin
                Inc(g_Config.GlobalVal[n14 - 100]);
              end;
            end;
          200..209: begin
              if n3C > 1 then begin
                Inc(PlayObject.m_DyVal[n14 - 200], n3C);
              end else begin
                Inc(PlayObject.m_DyVal[n14 - 200]);
              end;
            end;
          300..399: begin
              if n3C > 1 then begin
                Inc(PlayObject.m_nMval[n14 - 300], n3C);
              end else begin
                Inc(PlayObject.m_nMval[n14 - 300]);
              end;
            end;
          400..499: begin
              if n3C > 1 then begin
                Inc(g_Config.GlobaDyMval[n14 - 400], n3C);
              end else begin
                Inc(g_Config.GlobaDyMval[n14 - 400]);
              end;
            end;
          500..599: begin
              if n3C > 1 then begin
                Inc(PlayObject.m_nInteger[n14 - 500], n3C);
              end else begin
                Inc(PlayObject.m_nInteger[n14 - 500]);
              end;
            end;
          else begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
              Exit;
            end;
        end;
      end else begin
        ScriptActionError(PlayObject, '', QuestActionInfo, sMOV);
        Exit;
      end;
    end;
  end;

  procedure DecInteger(QuestActionInfo: pTQuestActionInfo);
  var
    i, n14, n3C, n10: Integer;
    DynamicVar: pTDynamicVar;
    DynamicVarList: TList;
    sName: string;
    boVarFound: Boolean;
    sParam1: string;
    sParam2: string;
    sParam3: string;
  resourcestring
    sVarFound = '����%s�����ڣ���������:%s';
    sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
  begin
    //MainOutMessage('DecInteger');
    n10 := 0;
    sParam1 := QuestActionInfo.sParam1;
    sParam2 := QuestActionInfo.sParam2;
    sParam3 := QuestActionInfo.sParam3;
    if (sParam1 = '') or (sParam2 = '') then begin
      ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
      Exit;
    end;
    if sParam3 <> '' then begin
      if (not IsVarNumber(sParam1)) and (IsVarNumber(sParam2)) then begin
        n10 := 1;
        boVarFound := False;
        DynamicVarList := GetDynamicVarList(PlayObject, sParam2, sName);
        if DynamicVarList = nil then begin
          DisPose(DynamicVar);
          ScriptActionError(PlayObject, format(sVarTypeError, [sParam2]), QuestActionInfo, sDEC);
          Exit;
        end;
        for i := 0 to DynamicVarList.Count - 1 do begin
          DynamicVar := DynamicVarList.Items[i];
          if CompareText(DynamicVar.sName, sParam3) = 0 then begin
            case DynamicVar.VarType of
              vInteger: begin
                  n3C := DynamicVar.nInternet;
                end;
              vString: begin
                end;
            end;
            boVarFound := True;
            break;
          end;
        end;
        if not boVarFound then begin
          ScriptActionError(PlayObject, format(sVarFound, [sParam3, sParam2]), QuestActionInfo, sDEC);
          Exit;
        end;
        n14 := GetValNameNo(sParam1);
        if n14 >= 0 then begin
          case n14 of
            0..9: begin
                if n3C > 1 then begin
                  Dec(PlayObject.m_nVal[n14], n3C);
                end else begin
                  Dec(PlayObject.m_nVal[n14]);
                end;
              end;
            100..199: begin
                if n3C > 1 then begin
                  Dec(g_Config.GlobalVal[n14 - 100], n3C);
                end else begin
                  Dec(g_Config.GlobalVal[n14 - 100]);
                end;
              end;
            200..209: begin
                if n3C > 1 then begin
                  Dec(PlayObject.m_DyVal[n14 - 200], n3C);
                end else begin
                  Dec(PlayObject.m_DyVal[n14 - 200]);
                end;
              end;
            300..399: begin
                if n3C > 1 then begin
                  Dec(PlayObject.m_nMval[n14 - 300], n3C);
                end else begin
                  Dec(PlayObject.m_nMval[n14 - 300]);
                end;
              end;
            400..499: begin
                if n3C > 1 then begin
                  Dec(g_Config.GlobaDyMval[n14 - 400], n3C);
                end else begin
                  Dec(g_Config.GlobaDyMval[n14 - 400]);
                end;
              end;
            500..599: begin
                if n3C > 1 then begin
                  Dec(PlayObject.m_nInteger[n14 - 500], n3C);
                end else begin
                  Dec(PlayObject.m_nInteger[n14 - 500]);
                end;
              end;
            else begin
                ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
                Exit;
              end;
          end;
        end else begin
          ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
          Exit;
        end;
        Exit;
      end;
      if (IsVarNumber(sParam1)) and (not IsVarNumber(sParam2)) then begin
        if (sParam3 <> '') and (not IsStringNumber(sParam3)) then begin
          n10 := 1;
          n14 := GetValNameNo(sParam3);
          if n14 >= 0 then begin
            case n14 of
              0..9: begin
                  n3C := PlayObject.m_nVal[n14];
                end;
              100..199: begin
                  n3C := g_Config.GlobalVal[n14 - 100];
                end;
              200..209: begin
                  n3C := PlayObject.m_DyVal[n14 - 200];
                end;
              300..399: begin
                  n3C := PlayObject.m_nMval[n14 - 300];
                end;
              400..499: begin
                  n3C := g_Config.GlobaDyMval[n14 - 400];
                end;
              500..599: begin
                  n3C := PlayObject.m_nInteger[n14 - 500];
                end;
              else begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
                  Exit;
                end;
            end;
          end else begin
            ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
            Exit;
          end;
        end else n3C := QuestActionInfo.nParam3;
        boVarFound := False;
        DynamicVarList := GetDynamicVarList(PlayObject, sParam1, sName);
        if DynamicVarList = nil then begin
          DisPose(DynamicVar);
          ScriptActionError(PlayObject, format(sVarTypeError, [sParam1]), QuestActionInfo, sDEC);
          Exit;
        end;
        for i := 0 to DynamicVarList.Count - 1 do begin
          DynamicVar := DynamicVarList.Items[i];
          if CompareText(DynamicVar.sName, sParam2) = 0 then begin
            case DynamicVar.VarType of
              vInteger: begin
                  if n3C > 1 then begin
                    Dec(DynamicVar.nInternet, n3C);
                  end else begin
                    Dec(DynamicVar.nInternet);
                  end;
                end;
              vString: begin
                end;
            end;
            boVarFound := True;
            break;
          end;
        end;
        if not boVarFound then begin
          ScriptActionError(PlayObject, format(sVarFound, [sParam2, sParam1]), QuestActionInfo, sDEC);
          Exit;
        end;
        Exit;
      end;
      if n10 = 0 then
        ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
    end else begin
      if (sParam2 <> '') and (not IsStringNumber(sParam2)) then begin //��ȡ��2������ֵ
        n14 := GetValNameNo(sParam2);
        if n14 >= 0 then begin
          case n14 of
            0..9: begin
                n3C := PlayObject.m_nVal[n14];
              end;
            100..199: begin
                n3C := g_Config.GlobalVal[n14 - 100];
              end;
            200..209: begin
                n3C := PlayObject.m_DyVal[n14 - 200];
              end;
            300..399: begin
                n3C := PlayObject.m_nMval[n14 - 300];
              end;
            400..499: begin
                n3C := g_Config.GlobaDyMval[n14 - 400];
              end;
            500..599: begin
                n3C := PlayObject.m_nInteger[n14 - 500];
              end;
            else begin
                ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
                Exit;
              end;
          end;
        end else begin
          ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
          Exit;
        end;
      end else n3C := QuestActionInfo.nParam2;
      n14 := GetValNameNo(sParam1);
      if n14 >= 0 then begin
        case n14 of
          0..9: begin
              if n3C > 1 then begin
                Dec(PlayObject.m_nVal[n14], n3C);
              end else begin
                Dec(PlayObject.m_nVal[n14]);
              end;
            end;
          100..199: begin
              if n3C > 1 then begin
                Dec(g_Config.GlobalVal[n14 - 100], n3C);
              end else begin
                Dec(g_Config.GlobalVal[n14 - 100]);
              end;
            end;
          200..209: begin
              if n3C > 1 then begin
                Dec(PlayObject.m_DyVal[n14 - 200], n3C);
              end else begin
                Dec(PlayObject.m_DyVal[n14 - 200]);
              end;
            end;
          300..399: begin
              if n3C > 1 then begin
                Dec(PlayObject.m_nMval[n14 - 300], n3C);
              end else begin
                Dec(PlayObject.m_nMval[n14 - 300]);
              end;
            end;
          400..499: begin
              if n3C > 1 then begin
                Dec(g_Config.GlobaDyMval[n14 - 400], n3C);
              end else begin
                Dec(g_Config.GlobaDyMval[n14 - 400]);
              end;
            end;
          500..599: begin
              if n3C > 1 then begin
                Dec(PlayObject.m_nInteger[n14 - 500], n3C);
              end else begin
                Dec(PlayObject.m_nInteger[n14 - 500]);
              end;
            end;
          else begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
              Exit;
            end;
        end;
      end else begin
        ScriptActionError(PlayObject, '', QuestActionInfo, sDEC);
        Exit;
      end;
    end;
  end;

  function QuestActionProcess(ActionList: TList): Boolean; //0049D660
  var
    i, ii, III: Integer;
    QuestActionInfo: pTQuestActionInfo;
    n14, n18, n1C, n28, n2C: Integer;
    n20X, n24Y, n34, n38, n3C, n40: Integer;
    s4C, s50: string;
    s34, s44, s48: string;
    Envir: TEnvirnoment;
    List58: TList;
    User: TPlayObject;
    DynamicVar: pTDynamicVar;
    DynamicVarList: TList;
    sName: string;
    OnLinePlayObject: TPlayObject;
    GuildRank: pTGuildRank;
    BaseObject: TBaseObject;
  begin
    Result := True;
    n18 := 0;
    n34 := 0;
    n38 := 0;
    n3C := 0;
    n40 := 0;
    for i := 0 to ActionList.Count - 1 do begin
      QuestActionInfo := ActionList.Items[i];
      case QuestActionInfo.nCMDCode of
        nSET: begin
            n28 := Str_ToInt(QuestActionInfo.sParam1, 0);
            n2C := Str_ToInt(QuestActionInfo.sParam2, 0);
            PlayObject.SetQuestFlagStatus(n28, n2C);
          end;
        nTAKE: TakeItem(QuestActionInfo.sParam1, QuestActionInfo.nParam2, QuestActionInfo.sParam2);
        //nGIVE: GiveItem(QuestActionInfo.sParam1,QuestActionInfo.nParam2);
        nSC_GIVE: ActionOfGiveItem(PlayObject, QuestActionInfo);
        nTAKEW: begin
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C) then begin //���ӱ���֧��
              s4C := QuestActionInfo.sParam1;
            end;
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, n14) then begin //���ӱ���֧��
              n14 := QuestActionInfo.nParam2;
            end;
            TakeWItem(s4C, n14);
          end;
        nCLOSE: PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
        nRESET: begin
            for ii := 0 to QuestActionInfo.nParam2 - 1 do begin
              PlayObject.SetQuestFlagStatus(QuestActionInfo.nParam1 + ii, 0);
            end;
          end;
        nSETOPEN: begin
            n28 := Str_ToInt(QuestActionInfo.sParam1, 0);
            n2C := Str_ToInt(QuestActionInfo.sParam2, 0);
            PlayObject.SetQuestUnitOpenStatus(n28, n2C);
          end;
        nSETUNIT: begin
            n28 := Str_ToInt(QuestActionInfo.sParam1, 0);
            n2C := Str_ToInt(QuestActionInfo.sParam2, 0);
            PlayObject.SetQuestUnitStatus(n28, n2C);
          end;
        nRESETUNIT: begin
            for ii := 0 to QuestActionInfo.nParam2 - 1 do begin
              PlayObject.SetQuestUnitStatus(QuestActionInfo.nParam1 + ii, 0);
            end;
          end;
        nBREAK: Result := False;
        nTIMERECALL: begin
            PlayObject.m_boTimeRecall := True;
            PlayObject.m_sMoveMap := PlayObject.m_sMapName;
            PlayObject.m_nMoveX := PlayObject.m_nCurrX;
            PlayObject.m_nMoveY := PlayObject.m_nCurrY;
            PlayObject.m_dwTimeRecallTick := GetTickCount + LongWord(QuestActionInfo.nParam1 * 60 * 1000);
          end;
        nSC_PARAM1: begin
            n34 := QuestActionInfo.nParam1;
            s44 := QuestActionInfo.sParam1;
          end;
        nSC_PARAM2: begin
            n38 := QuestActionInfo.nParam1;
            s48 := QuestActionInfo.sParam1;
          end;
        nSC_PARAM3: begin
            n3C := QuestActionInfo.nParam1;
            s4C := QuestActionInfo.sParam1;
          end;
        nSC_PARAM4: begin
            n40 := QuestActionInfo.nParam1;
            s50 := QuestActionInfo.sParam1;
          end;
        nSC_EXEACTION: begin
            n40 := QuestActionInfo.nParam1;
            s50 := QuestActionInfo.sParam1;
            ExeAction(PlayObject, QuestActionInfo.sParam1, QuestActionInfo.sParam2, QuestActionInfo.sParam3, QuestActionInfo.nParam1, QuestActionInfo.nParam2, QuestActionInfo.nParam3);
          end;
        nMAPMOVE: begin
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C) then begin //���ӱ���֧��
              s4C := QuestActionInfo.sParam1;
            end;
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, n14) then begin //���ӱ���֧��
              n14 := QuestActionInfo.nParam2;
            end;
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam3, n40) then begin //���ӱ���֧��
              n40 := QuestActionInfo.nParam3;
            end;
            PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            PlayObject.SpaceMove(s4C, n14, n40, 0);
            bo11 := True;
          end;
        nMAP: begin
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C) then begin //���ӱ���֧��
              s4C := QuestActionInfo.sParam1;
            end;
            PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            PlayObject.MapRandomMove(s4C, 0);
            bo11 := True;
          end;
        nTAKECHECKITEM: begin
            if UserItem <> nil then begin
              PlayObject.QuestTakeCheckItem(UserItem);
            end else begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sTAKECHECKITEM);
            end;
          end;
        nMONGEN: begin
            for ii := 0 to QuestActionInfo.nParam2 - 1 do begin
              n20X := Random(QuestActionInfo.nParam3 * 2 + 1) + (n38 - QuestActionInfo.nParam3);
              n24Y := Random(QuestActionInfo.nParam3 * 2 + 1) + (n3C - QuestActionInfo.nParam3);
              UserEngine.RegenMonsterByName(s44, n20X, n24Y, QuestActionInfo.sParam1);
            end;
          end;
        nMONCLEAR: begin
            List58 := TList.Create;
            UserEngine.GetMapMonster(g_MapManager.FindMap(QuestActionInfo.sParam1), List58);
            for ii := 0 to List58.Count - 1 do begin
              TBaseObject(List58.Items[ii]).m_boNoItem := True;
              TBaseObject(List58.Items[ii]).m_WAbil.HP := 0;
            end;
            List58.Free;
          end;
        nMOV: MovData(QuestActionInfo);
        nINC: IncInteger(QuestActionInfo);
        nDEC: DecInteger(QuestActionInfo);
        nSUM: begin
            n18 := 0;
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then begin
              case n14 of //
                0..9: begin
                    n18 := PlayObject.m_nVal[n14];
                  end;
                100..199: begin
                    n18 := g_Config.GlobalVal[n14 - 100];
                  end;
                200..209: begin
                    n18 := PlayObject.m_DyVal[n14 - 200];
                  end;
                300..399: begin
                    n18 := PlayObject.m_nMval[n14 - 300];
                  end;
                400..499: begin
                    n18 := g_Config.GlobaDyMval[n14 - 400];
                  end;
                500..599: begin
                    n18 := PlayObject.m_nInteger[n14 - 500];
                  end;
                else begin
                    ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
                  end;
              end; // case
            end else begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
            end;
            n1C := 0;
            n14 := GetValNameNo(QuestActionInfo.sParam2);
            if n14 >= 0 then begin
              case n14 of //
                0..9: begin
                    n1C := PlayObject.m_nVal[n14];
                  end;
                100..199: begin
                    n1C := g_Config.GlobalVal[n14 - 100];
                  end;
                200..209: begin
                    n1C := PlayObject.m_DyVal[n14 - 200];
                  end;
                300..399: begin
                    n1C := PlayObject.m_nMval[n14 - 300];
                  end;
                400..499: begin
                    n1C := g_Config.GlobaDyMval[n14 - 400];
                  end;
                500..599: begin
                    n1C := PlayObject.m_nInteger[n14 - 500];
                  end;
                else begin
                    ScriptActionError(PlayObject, '', QuestActionInfo, sSUM);
                  end;
              end;
            end else begin
              //ScriptActionError(PlayObject,'',QuestActionInfo,sSUM);
            end;
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then begin
              case n14 of //
                0..9: begin
                    PlayObject.m_nVal[9] := PlayObject.m_nVal[9] + n18 + n1C;
                  end;
                100..199: begin
                    g_Config.GlobalVal[99] := g_Config.GlobalVal[99] + n18 + n1C;
                  end;
                200..209: begin
                    PlayObject.m_DyVal[9] := PlayObject.m_DyVal[9] + n18 + n1C;
                  end;
                300..399: begin
                    PlayObject.m_nMval[99] := PlayObject.m_nMval[99] + n18 + n1C;
                  end;
                400..499: begin
                    g_Config.GlobaDyMval[99] := g_Config.GlobaDyMval[99] + n18 + n1C;
                  end;
                500..599: begin
                    PlayObject.m_nInteger[9] := PlayObject.m_nInteger[9] + n18 + n1C;
                  end;
              end;
            end;
          end;
        nBREAKTIMERECALL: PlayObject.m_boTimeRecall := False;

        nCHANGEMODE: begin
            case QuestActionInfo.nParam1 of
              1: PlayObject.CmdChangeAdminMode('', 10, '', Str_ToInt(QuestActionInfo.sParam2, 0) = 1);
              2: PlayObject.CmdChangeSuperManMode('', 10, '', Str_ToInt(QuestActionInfo.sParam2, 0) = 1);
              3: PlayObject.CmdChangeObMode('', 10, '', Str_ToInt(QuestActionInfo.sParam2, 0) = 1);
              else begin
                  ScriptActionError(PlayObject, '', QuestActionInfo, sCHANGEMODE);
                end;
            end;
          end;
        nPKPOINT: begin
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, n14) then begin //���ӱ���֧��
              n14 := QuestActionInfo.nParam1;
            end;
            if n14 = 0 then begin
              PlayObject.m_nPkPoint := 0;
            end else begin
              if n14 < 0 then begin
                if (PlayObject.m_nPkPoint + n14) >= 0 then begin
                  Inc(PlayObject.m_nPkPoint, n14);
                end else PlayObject.m_nPkPoint := 0;
              end else begin
                if (PlayObject.m_nPkPoint + n14) > 10000 then begin
                  PlayObject.m_nPkPoint := 10000;
                end else begin
                  Inc(PlayObject.m_nPkPoint, n14);
                end;
              end;
            end;
            PlayObject.RefNameColor();
          end;
        nCHANGEXP: begin

          end;
        nSC_RECALLMOB: ActionOfRecallmob(PlayObject, QuestActionInfo);
        {
        nSC_RECALLMOB: begin
          if QuestActionInfo.nParam3 <= 1 then begin
            PlayObject.MakeSlave(QuestActionInfo.sParam1,3,Str_ToInt(QuestActionInfo.sParam2,0),100,10 * 24 * 60 * 60);
          end else begin
            PlayObject.MakeSlave(QuestActionInfo.sParam1,3,Str_ToInt(QuestActionInfo.sParam2,0),100,QuestActionInfo.nParam3 * 60)
          end;
        end;
        }
        nKICK: begin
            PlayObject.m_boReconnection := True;
            PlayObject.m_boSoftClose := True;
          end;
        nMOVR: begin
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then begin
              case n14 of //
                0..9: begin
                    PlayObject.m_nVal[n14] := Random(QuestActionInfo.nParam2);
                  end;
                100..199: begin
                    g_Config.GlobalVal[n14 - 100] := Random(QuestActionInfo.nParam2);
                  end;
                200..209: begin
                    PlayObject.m_DyVal[n14 - 200] := Random(QuestActionInfo.nParam2);
                  end;
                300..399: begin
                    PlayObject.m_nMval[n14 - 300] := Random(QuestActionInfo.nParam2);
                  end;
                400..499: begin
                    g_Config.GlobaDyMval[n14 - 400] := Random(QuestActionInfo.nParam2);
                  end;
                500..599: begin
                    PlayObject.m_nInteger[n14 - 500] := Random(QuestActionInfo.nParam2);
                  end;
                else begin
                    ScriptActionError(PlayObject, '', QuestActionInfo, sMOVR);
                  end;
              end;
            end else begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sMOVR);
            end;
          end;
        nEXCHANGEMAP: begin
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C) then begin //���ӱ���֧��
              s4C := QuestActionInfo.sParam1;
            end;
            Envir := g_MapManager.FindMap(s4C);
            if Envir <> nil then begin
              List58 := TList.Create;
              UserEngine.GetMapRageHuman(Envir, 0, 0, 1000, List58);
              if List58.Count > 0 then begin
                User := TPlayObject(List58.Items[0]);
                User.MapRandomMove(Self.m_sMapName, 0);
              end;
              List58.Free;
              PlayObject.MapRandomMove(s4C, 0);
            end else begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sEXCHANGEMAP);
            end;

          end;
        nRECALLMAP: begin
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C) then begin //���ӱ���֧��
              s4C := QuestActionInfo.sParam1;
            end;
            Envir := g_MapManager.FindMap(s4C);
            if Envir <> nil then begin
              List58 := TList.Create;
              UserEngine.GetMapRageHuman(Envir, 0, 0, 1000, List58);
              for ii := 0 to List58.Count - 1 do begin
                User := TPlayObject(List58.Items[ii]);
                User.MapRandomMove(Self.m_sMapName, 0);
                if ii > 20 then break;
              end;
              List58.Free;
            end else begin
              ScriptActionError(PlayObject, '', QuestActionInfo, sRECALLMAP);
            end;
          end;
        nADDBATCH: List1C.AddObject(QuestActionInfo.sParam1, TObject(n18));
        nBATCHDELAY: n18 := QuestActionInfo.nParam1 * 1000;
        nBATCHMOVE: begin
            for ii := 0 to List1C.Count - 1 do begin
              PlayObject.SendDelayMsg(Self, RM_10155, 0, 0, 0, 0, List1C.Strings[ii], Integer(List1C.Objects[ii]) + n20);
              Inc(n20, Integer(List1C.Objects[ii]));
            end;
          end;
        nPLAYDICE: begin //0049E209
            PlayObject.m_sPlayDiceLabel := QuestActionInfo.sParam2;
            PlayObject.SendMsg(Self,
              RM_PLAYDICE,
              QuestActionInfo.nParam1,
              MakeLong(MakeWord(PlayObject.m_DyVal[0], PlayObject.m_DyVal[1]), MakeWord(PlayObject.m_DyVal[2], PlayObject.m_DyVal[3])),
              MakeLong(MakeWord(PlayObject.m_DyVal[4], PlayObject.m_DyVal[5]), MakeWord(PlayObject.m_DyVal[6], PlayObject.m_DyVal[7])),
              MakeLong(MakeWord(PlayObject.m_DyVal[8], PlayObject.m_DyVal[9]), 0),
              QuestActionInfo.sParam2);
            bo11 := True;
          end;

        nADDNAMELIST: AddList(PlayObject.m_sCharName, m_sPath + QuestActionInfo.sParam1);
        nDELNAMELIST: DelList(PlayObject.m_sCharName, m_sPath + QuestActionInfo.sParam1);
        nADDGUILDLIST: if PlayObject.m_MyGuild <> nil then AddList(TGUild(PlayObject.m_MyGuild).sGuildName, m_sPath + QuestActionInfo.sParam1);
        nDELGUILDLIST: if PlayObject.m_MyGuild <> nil then DelList(TGUild(PlayObject.m_MyGuild).sGuildName, m_sPath + QuestActionInfo.sParam1);
        nSC_LINEMSG, nSENDMSG: ActionOfLineMsg(PlayObject, QuestActionInfo);

        nADDACCOUNTLIST: AddList(PlayObject.m_sUserID, m_sPath + QuestActionInfo.sParam1);
        nDELACCOUNTLIST: DelList(PlayObject.m_sUserID, m_sPath + QuestActionInfo.sParam1);
        nADDIPLIST: AddList(PlayObject.m_sIPaddr, m_sPath + QuestActionInfo.sParam1);
        nDELIPLIST: DelList(PlayObject.m_sIPaddr, m_sPath + QuestActionInfo.sParam1);
        nGOQUEST: GoToQuest(QuestActionInfo.nParam1);
        nENDQUEST: PlayObject.m_Script := nil;
        nGOTO: begin
            if not JmpToLable(QuestActionInfo.sParam1) then begin
              //ScriptActionError(PlayObject,'',QuestActionInfo,sGOTO);
              MainOutMessage('[�ű���ѭ��] NPC:' + m_sCharName +
                ' λ��:' + m_sMapName + '(' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) + ')' +
                ' ����:' + sGOTO + ' ' + QuestActionInfo.sParam1);
              Result := False;
              Exit;
            end;
          end;

        nSC_HAIRCOLOR: ;
        nSC_WEARCOLOR: ;
        nSC_HAIRSTYLE: ActionOfChangeHairStyle(PlayObject, QuestActionInfo);
        nSC_MONRECALL: ;
        nSC_HORSECALL: ;
        nSC_HAIRRNDCOL: ;
        nSC_KILLHORSE: ;
        nSC_RANDSETDAILYQUEST: ;

        nSC_RECALLGROUPMEMBERS: ActionOfRecallGroupMembers(PlayObject, QuestActionInfo);
        nSC_CLEARNAMELIST: ActionOfClearNameList(PlayObject, QuestActionInfo);
        nSC_MAPTING: ActionOfMapTing(PlayObject, QuestActionInfo);
        nSC_CHANGELEVEL: ActionOfChangeLevel(PlayObject, QuestActionInfo);
        nSC_MARRY: ActionOfMarry(PlayObject, QuestActionInfo);
        nSC_MASTER: ActionOfMaster(PlayObject, QuestActionInfo);
        nSC_UNMASTER: ActionOfUnMaster(PlayObject, QuestActionInfo);
        nSC_UNMARRY: ActionOfUnMarry(PlayObject, QuestActionInfo);
        nSC_GETMARRY: ActionOfGetMarry(PlayObject, QuestActionInfo);
        nSC_GETMASTER: ActionOfGetMaster(PlayObject, QuestActionInfo);
        nSC_CLEARSKILL: ActionOfClearSkill(PlayObject, QuestActionInfo);
        nSC_DELNOJOBSKILL: ActionOfDelNoJobSkill(PlayObject, QuestActionInfo);
        nSC_DELSKILL: ActionOfDelSkill(PlayObject, QuestActionInfo);
        nSC_ADDSKILL: ActionOfAddSkill(PlayObject, QuestActionInfo);
        nSC_SKILLLEVEL: ActionOfSkillLevel(PlayObject, QuestActionInfo);
        nSC_CHANGEPKPOINT: ActionOfChangePkPoint(PlayObject, QuestActionInfo);
        nSC_CHANGEEXP: ActionOfChangeExp(PlayObject, QuestActionInfo);
        nSC_CHANGEJOB: ActionOfChangeJob(PlayObject, QuestActionInfo);
        nSC_MISSION: ActionOfMission(PlayObject, QuestActionInfo);
        nSC_MOBPLACE: ActionOfMobPlace(PlayObject, QuestActionInfo, n34, n38, n3C, n40);
        nSC_SETMEMBERTYPE: ActionOfSetMemberType(PlayObject, QuestActionInfo);
        nSC_SETMEMBERLEVEL: ActionOfSetMemberLevel(PlayObject, QuestActionInfo);
        //        nSC_SETMEMBERTYPE:   PlayObject.m_nMemberType:=Str_ToInt(QuestActionInfo.sParam1,0);
        //        nSC_SETMEMBERLEVEL:  PlayObject.m_nMemberType:=Str_ToInt(QuestActionInfo.sParam1,0);
        nSC_GAMEGOLD: ActionOfGameGold(PlayObject, QuestActionInfo);
        nSC_GAMEPOINT: ActionOfGamePoint(PlayObject, QuestActionInfo);
        nSC_AUTOADDGAMEGOLD: ActionOfAutoAddGameGold(PlayObject, QuestActionInfo, n34, n38);
        nSC_AUTOSUBGAMEGOLD: ActionOfAutoSubGameGold(PlayObject, QuestActionInfo, n34, n38);
        nSC_CHANGENAMECOLOR: ActionOfChangeNameColor(PlayObject, QuestActionInfo);
        nSC_CLEARPASSWORD: ActionOfClearPassword(PlayObject, QuestActionInfo);
        nSC_RENEWLEVEL: ActionOfReNewLevel(PlayObject, QuestActionInfo);
        nSC_KILLSLAVE: ActionOfKillSlave(PlayObject, QuestActionInfo);
        nSC_CHANGEGENDER: ActionOfChangeGender(PlayObject, QuestActionInfo);
        nSC_KILLMONEXPRATE: ActionOfKillMonExpRate(PlayObject, QuestActionInfo);
        nSC_POWERRATE: ActionOfPowerRate(PlayObject, QuestActionInfo);
        nSC_CHANGEMODE: ActionOfChangeMode(PlayObject, QuestActionInfo);
        nSC_CHANGEPERMISSION: ActionOfChangePerMission(PlayObject, QuestActionInfo);
        nSC_KILL: ActionOfKill(PlayObject, QuestActionInfo);
        nSC_KICK: ActionOfKick(PlayObject, QuestActionInfo);
        nSC_BONUSPOINT: ActionOfBonusPoint(PlayObject, QuestActionInfo);
        nSC_RESTRENEWLEVEL: ActionOfRestReNewLevel(PlayObject, QuestActionInfo);
        nSC_DELMARRY: ActionOfDelMarry(PlayObject, QuestActionInfo);
        nSC_DELMASTER: ActionOfDelMaster(PlayObject, QuestActionInfo);
        nSC_CREDITPOINT: ActionOfChangeCreditPoint(PlayObject, QuestActionInfo);
        nSC_CLEARNEEDITEMS: ActionOfClearNeedItems(PlayObject, QuestActionInfo);
        nSC_CLEARMAEKITEMS: ActionOfClearMakeItems(PlayObject, QuestActionInfo);
        nSC_SETSENDMSGFLAG: PlayObject.m_boSendMsgFlag := True;
        nSC_UPGRADEITEMS: ActionOfUpgradeItems(PlayObject, QuestActionInfo);
        nSC_UPGRADEITEMSEX: ActionOfUpgradeItemsEx(PlayObject, QuestActionInfo);
        nSC_MONGENEX: ActionOfMonGenEx(PlayObject, QuestActionInfo);
        nSC_CLEARMAPMON: ActionOfClearMapMon(PlayObject, QuestActionInfo);
        nSC_SETMAPMODE: ActionOfSetMapMode(PlayObject, QuestActionInfo);
        nSC_PKZONE: ActionOfPkZone(PlayObject, QuestActionInfo);
        nSC_RESTBONUSPOINT: ActionOfRestBonusPoint(PlayObject, QuestActionInfo);
        nSC_TAKECASTLEGOLD: ActionOfTakeCastleGold(PlayObject, QuestActionInfo);
        nSC_HUMANHP: ActionOfHumanHP(PlayObject, QuestActionInfo);
        nSC_HUMANMP: ActionOfHumanMP(PlayObject, QuestActionInfo);
        nSC_BUILDPOINT: ActionOfGuildBuildPoint(PlayObject, QuestActionInfo);
        nSC_AURAEPOINT: ActionOfGuildAuraePoint(PlayObject, QuestActionInfo);
        nSC_STABILITYPOINT: ActionOfGuildstabilityPoint(PlayObject, QuestActionInfo);
        nSC_FLOURISHPOINT: ActionOfGuildFlourishPoint(PlayObject, QuestActionInfo);
        nSC_OPENMAGICBOX: ActionOfOpenMagicBox(PlayObject, QuestActionInfo);
        nSC_SETRANKLEVELNAME: ActionOfSetRankLevelName(PlayObject, QuestActionInfo);
        nSC_GMEXECUTE: ActionOfGmExecute(PlayObject, QuestActionInfo);
        nSC_GUILDCHIEFITEMCOUNT: ActionOfGuildChiefItemCount(PlayObject, QuestActionInfo);
        nSC_ADDNAMEDATELIST, nSC_ADDUSERDATE: ActionOfAddNameDateList(PlayObject, QuestActionInfo);
        nSC_DELNAMEDATELIST, nSC_DELUSERDATE: ActionOfDelNameDateList(PlayObject, QuestActionInfo);
        nSC_MOBFIREBURN: ActionOfMobFireBurn(PlayObject, QuestActionInfo);
        nSC_MESSAGEBOX: ActionOfMessageBox(PlayObject, QuestActionInfo);
        nSC_SETSCRIPTFLAG: ActionOfSetScriptFlag(PlayObject, QuestActionInfo);
        nSC_SETAUTOGETEXP: ActionOfAutoGetExp(PlayObject, QuestActionInfo);
        nSC_VAR: ActionOfVar(PlayObject, QuestActionInfo);
        nSC_LOADVAR: ActionOfLoadVar(PlayObject, QuestActionInfo);
        nSC_SAVEVAR: ActionOfSaveVar(PlayObject, QuestActionInfo);
        nSC_CALCVAR: ActionOfCalcVar(PlayObject, QuestActionInfo);
        nOFFLINEPLAY: ActionOfNotLineAddPiont(PlayObject, QuestActionInfo);
        nKICKOFFLINE: ActionOfKickNotLineAddPiont(PlayObject, QuestActionInfo);
        nSTARTTAKEGOLD: ActionOfStartTakeGold(PlayObject);
        nDELAYGOTO: begin
            PlayObject.m_boTimeGoto := True;
            PlayObject.m_dwTimeGotoTick := GetTickCount + LongWord(QuestActionInfo.nParam1 * 1000);
            PlayObject.m_sTimeGotoLable := QuestActionInfo.sParam2;
            PlayObject.m_TimeGotoNPC := Self;
          end;
        nCLEARDELAYGOTO: begin
            PlayObject.m_boTimeGoto := False;
            PlayObject.m_sTimeGotoLable := '';
            PlayObject.m_TimeGotoNPC := nil;
          end;
        nCHANGERECOMMENDGAMEGOLD: ActionOfCommendGameGold(PlayObject, QuestActionInfo);
        nSC_ANSIREPLACETEXT: ActionOfAnsiReplaceText(PlayObject, QuestActionInfo);
        nSC_ENCODETEXT: ActionOfEncodeText(PlayObject, QuestActionInfo);
        nSC_DECODETEXT: ActionOfDecodeText(PlayObject, QuestActionInfo);
        nSC_ADDTEXTLIST: begin
            s4C := QuestActionInfo.sParam1;
            ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C);
            AddList(s4C, m_sPath + QuestActionInfo.sParam2);
          end;
        nSC_DELTEXTLIST: begin
            s4C := QuestActionInfo.sParam1;
            ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C);
            DelList(s4C, m_sPath + QuestActionInfo.sParam2);
          end;
        nSC_GROUPMOVE: begin
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C) then begin //���ӱ���֧��
              s4C := QuestActionInfo.sParam1;
            end;
            PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            PlayObject.MapRandomMove(s4C, 0);
            if PlayObject.m_GroupOwner.m_GroupMembers.Count > 0 then begin
              for ii := 0 to PlayObject.m_GroupOwner.m_GroupMembers.Count - 1 do begin
                if (not TPlayObject(PlayObject.m_GroupOwner.m_GroupMembers.Objects[ii]).m_boDeath) and
                  (not TPlayObject(PlayObject.m_GroupOwner.m_GroupMembers.Objects[ii]).m_boGhost) then begin
                  TPlayObject(PlayObject.m_GroupOwner.m_GroupMembers.Objects[ii]).MapRandomMove(s4C, 0);
                end;
              end;
            end;
            bo11 := True;
          end;
        nSC_GROUPMAPMOVE: begin
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C) then begin //���ӱ���֧��
              s4C := QuestActionInfo.sParam1;
            end;
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, n14) then begin //���ӱ���֧��
              n14 := QuestActionInfo.nParam2;
            end;
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam3, n40) then begin //���ӱ���֧��
              n40 := QuestActionInfo.nParam3;
            end;
            PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            PlayObject.SpaceMove(s4C, n14, n40, 0);
            if PlayObject.m_GroupOwner.m_GroupMembers.Count > 0 then begin
              for ii := 0 to PlayObject.m_GroupOwner.m_GroupMembers.Count - 1 do begin
                if (not TPlayObject(PlayObject.m_GroupOwner.m_GroupMembers.Objects[ii]).m_boDeath) and
                  (not TPlayObject(PlayObject.m_GroupOwner.m_GroupMembers.Objects[ii]).m_boGhost) then begin
                  TPlayObject(PlayObject.m_GroupOwner.m_GroupMembers.Objects[ii]).SpaceMove(s4C, n14, n40, 0);
                end;
              end;
            end;
            bo11 := True;
          end;
        nSC_RECALLHUMAN: begin
            s4C := QuestActionInfo.sParam1;
            ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C);
            if s4C <> '' then begin
              PlayObject.RecallHuman(s4C);
            end;
          end;
        nSC_REGOTO: begin
            s4C := QuestActionInfo.sParam1;
            ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C);
            if s4C <> '' then begin
              OnLinePlayObject := UserEngine.GetPlayObject(s4C);
              if PlayObject <> nil then begin
                PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
                PlayObject.SpaceMove(OnLinePlayObject.m_PEnvir.sMapName, OnLinePlayObject.m_nCurrX, OnLinePlayObject.m_nCurrY, 0);
                bo11 := True;
              end;
            end;
          end;
        nSC_INTTOSTR: begin
            n40 := 0;
            ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, n40);
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then begin
              case n14 of
                600..699: begin
                    PlayObject.m_sString[n14 - 600] := IntToStr(n40);
                  end;
                700..799: begin
                    g_Config.GlobalAVal[n14 - 700] := IntToStr(n40);
                  end;
                else begin
                    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_INTTOSTR);
                  end;
              end;
            end;
          end;
        nSC_STRTOINT: begin
            ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C);
            n14 := GetValNameNo(QuestActionInfo.sParam1);
            if n14 >= 0 then begin
              case n14 of
                0..9: begin
                    PlayObject.m_nVal[n14] := Str_ToInt(s4C, 0);
                  end;
                100..199: begin
                    g_Config.GlobalVal[n14 - 100] := Str_ToInt(s4C, 0);
                  end;
                200..209: begin
                    PlayObject.m_DyVal[n14 - 200] := Str_ToInt(s4C, 0);
                  end;
                300..399: begin
                    PlayObject.m_nMval[n14 - 300] := Str_ToInt(s4C, 0);
                  end;
                400..499: begin
                    g_Config.GlobaDyMval[n14 - 400] := Str_ToInt(s4C, 0);
                  end;
                500..599: begin
                    PlayObject.m_nInteger[n14 - 500] := Str_ToInt(s4C, 0);
                  end;
                else begin
                    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_STRTOINT);
                  end;
              end;
            end;
          end;
        nSC_GUILDMOVE: begin
            if PlayObject.m_MyGuild = nil then Exit;
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C) then begin //���ӱ���֧��
              s4C := QuestActionInfo.sParam1;
            end;
            PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            PlayObject.MapRandomMove(s4C, 0);
            for ii := 0 to TGUild(PlayObject.m_MyGuild).m_RankList.Count - 1 do begin
              GuildRank := TGUild(PlayObject.m_MyGuild).m_RankList.Items[ii];
              if GuildRank = nil then Continue;
              for III := 0 to GuildRank.MemberList.Count - 1 do begin
                BaseObject := TBaseObject(GuildRank.MemberList.Objects[III]);
                if BaseObject = nil then Continue;
                if (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) then
                  TPlayObject(BaseObject).MapRandomMove(s4C, 0);
              end;
            end;
            bo11 := True;
          end;
        nSC_GUILDMAPMOVE: begin
            if PlayObject.m_MyGuild = nil then Exit;
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, s4C) then begin //���ӱ���֧��
              s4C := QuestActionInfo.sParam1;
            end;
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, n14) then begin //���ӱ���֧��
              n14 := QuestActionInfo.nParam2;
            end;
            if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam3, n40) then begin //���ӱ���֧��
              n40 := QuestActionInfo.nParam3;
            end;
            PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            PlayObject.SpaceMove(s4C, n14, n40, 0);
            for ii := 0 to TGUild(PlayObject.m_MyGuild).m_RankList.Count - 1 do begin
              GuildRank := TGUild(PlayObject.m_MyGuild).m_RankList.Items[ii];
              if GuildRank = nil then Continue;
              for III := 0 to GuildRank.MemberList.Count - 1 do begin
                BaseObject := TBaseObject(GuildRank.MemberList.Objects[III]);
                if BaseObject = nil then Continue;
                if (not BaseObject.m_boDeath) and (not BaseObject.m_boGhost) then
                  TPlayObject(BaseObject).SpaceMove(s4C, n14, n40, 0);
              end;
            end;
            bo11 := True;
          end;
        nSC_RANDOMMOVE: begin
            if PlayObject.m_PEnvir = nil then Exit;
            n14 := Random(PlayObject.m_PEnvir.m_nWidth);
            n40 := Random(PlayObject.m_PEnvir.m_nHeight);
            PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
            PlayObject.SpaceMove(PlayObject.m_sMapName, n14, n40, 0);
            bo11 := True;
          end;
        nSC_USEBONUSPOINT: ActionOfUseBonusPoint(PlayObject, QuestActionInfo);
        else begin
            if Assigned(zPlugOfEngine.ActionScriptProcess) then begin
              try
                zPlugOfEngine.ActionScriptProcess(Self,
                  PlayObject,
                  QuestActionInfo.nCMDCode,
                  PChar(QuestActionInfo.sParam1),
                  QuestActionInfo.nParam1,
                  PChar(QuestActionInfo.sParam2),
                  QuestActionInfo.nParam2,
                  PChar(QuestActionInfo.sParam3),
                  QuestActionInfo.nParam3,
                  PChar(QuestActionInfo.sParam4),
                  QuestActionInfo.nParam4,
                  PChar(QuestActionInfo.sParam5),
                  QuestActionInfo.nParam5,
                  PChar(QuestActionInfo.sParam6),
                  QuestActionInfo.nParam6);
              except
              end;
            end;
          end;
      end;
    end;
  end;
  procedure SendMerChantSayMsg(sMsg: string; boFlag: Boolean); //0049E3E0
  var
    s10, s14: string;
    nC: Integer;
  begin
    s14 := sMsg;
    nC := 0;
    while (True) do begin
      if TagCount(s14, '>') < 1 then break;
      s14 := ArrestStringEx(s14, '<', '>', s10);
      GetVariableText(PlayObject, sMsg, s10);
      Inc(nC);
      if nC >= 101 then break;
    end;
    PlayObject.GetScriptLabel(sMsg);
    if boFlag then begin
      PlayObject.SendFirstMsg(Self, RM_MERCHANTSAY, 0, 0, 0, 0, m_sCharName + '/' + sMsg);
    end else begin
      PlayObject.SendMsg(Self, RM_MERCHANTSAY, 0, 0, 0, 0, m_sCharName + '/' + sMsg);
    end;
  end;
begin
  Script := nil;
  List1C := TStringList.Create;
  n18 := 1000;
  n20 := 0;
  if PlayObject.m_NPC <> Self then begin
    PlayObject.m_NPC := nil;
    PlayObject.m_Script := nil;
    FillChar(PlayObject.m_nVal, SizeOf(PlayObject.m_nVal), #0);
  end;
  if CompareText(sLabel, '@main') = 0 then begin
    for i := 0 to m_ScriptList.Count - 1 do begin
      Script3C := m_ScriptList.Items[i];
      if Script3C = nil then Continue;
      for ii := 0 to Script3C.RecordList.Count - 1 do begin
        SayingRecord := Script3C.RecordList.Items[ii];
        if SayingRecord = nil then Continue;
        if CompareText(sLabel, SayingRecord.sLabel) = 0 then begin
          Script := Script3C;
          PlayObject.m_Script := Script;
          PlayObject.m_NPC := Self;
          break;
        end;
        if Script <> nil then break;
      end;
    end;
  end;
  if (Script = nil) then begin
    if (PlayObject.m_Script <> nil) then begin
      for i := m_ScriptList.Count - 1 downto 0 do begin
        if m_ScriptList.Count <= 0 then break;
        if (m_ScriptList.Items[i] <> nil) and (m_ScriptList.Items[i] = PlayObject.m_Script) then begin
          Script := m_ScriptList.Items[i];
        end;
      end;
    end;
    if (Script = nil) then begin
      for i := m_ScriptList.Count - 1 downto 0 do begin
        if m_ScriptList.Count <= 0 then break;
        if (pTScript(m_ScriptList.Items[i]) <> nil) and CheckQuestStatus(pTScript(m_ScriptList.Items[i])) then begin
          Script := m_ScriptList.Items[i];
          PlayObject.m_Script := Script;
          PlayObject.m_NPC := Self;
        end;
      end;
    end;
  end;

  //��ת��ָ��ʾǩ��ִ��
  if (Script <> nil) then begin
    for ii := 0 to Script.RecordList.Count - 1 do begin
      SayingRecord := Script.RecordList.Items[ii];
      if SayingRecord = nil then Continue;
      if CompareText(sLabel, SayingRecord.sLabel) = 0 then begin
        //MainOutMessage('sLabel '+sLabel+' boExtJmp '+BooleanToStr(boExtJmp)+' SayingRecord.boExtJmp '+BooleanToStr(SayingRecord.boExtJmp));
        if boExtJmp and not SayingRecord.boExtJmp then break;
        sSENDMSG := '';
        for III := 0 to SayingRecord.ProcedureList.Count - 1 do begin
          SayingProcedure := SayingRecord.ProcedureList.Items[III];
          if SayingProcedure = nil then Continue;
          bo11 := False;
          if QuestCheckCondition(SayingProcedure.ConditionList) then begin
            sSENDMSG := sSENDMSG + SayingProcedure.sSayMsg;
            if not QuestActionProcess(SayingProcedure.ActionList) then break;
            if bo11 then SendMerChantSayMsg(sSENDMSG, True);
          end else begin
            sSENDMSG := sSENDMSG + SayingProcedure.sElseSayMsg;
            if not QuestActionProcess(SayingProcedure.ElseActionList) then break;
            if bo11 then SendMerChantSayMsg(sSENDMSG, True);
          end;
        end;
        if sSENDMSG <> '' then SendMerChantSayMsg(sSENDMSG, False);
        break;
      end;
    end;
  end;
  List1C.Free;
end;

procedure TNormNpc.LoadNpcScript;
var
  s08: string;
begin
  if m_boIsQuest then begin
    m_sPath := sNpc_def;
    s08 := m_sCharName + '-' + m_sMapName;
    FrmDB.LoadNpcScript(Self, m_sFilePath, s08);
  end else begin
    m_sPath := m_sFilePath;
    FrmDB.LoadNpcScript(Self, m_sFilePath, m_sCharName);
  end;
end;

function TNormNpc.Operate(ProcessMsg: pTProcessMessage): Boolean; //0049AB64
begin
  Result := inherited Operate(ProcessMsg);
end;

procedure TNormNpc.Run;
var
  nInteger: Integer;
begin
  if m_Master <> nil then m_Master := nil; //�������ٻ�Ϊ����
  //NPC��ɫ
  if (m_boNpcAutoChangeColor) and (m_dwNpcAutoChangeColorTime > 0) and (GetTickCount - m_dwNpcAutoChangeColorTick > m_dwNpcAutoChangeColorTime) then begin
    m_dwNpcAutoChangeColorTick := GetTickCount();
    case m_nNpcAutoChangeIdx of
      0: nInteger := STATE_TRANSPARENT;
      1: nInteger := POISON_STONE;
      2: nInteger := POISON_DONTMOVE;
      3: nInteger := POISON_68;
      4: nInteger := POISON_DECHEALTH;
      5: nInteger := POISON_LOCKSPELL;
      6: nInteger := POISON_DAMAGEARMOR;
      else begin
          m_nNpcAutoChangeIdx := 0;
          nInteger := STATE_TRANSPARENT;
        end;
    end;
    Inc(m_nNpcAutoChangeIdx);
    m_nCharStatus := (m_nCharStatusEx and $FFFFF) or (($80000000 shr nInteger) or 0);
    StatusChanged();
  end;
  if m_boFixColor and (m_nFixStatus <> m_nCharStatus) then begin
    case m_nFixColorIdx of
      0: nInteger := STATE_TRANSPARENT;
      1: nInteger := POISON_STONE;
      2: nInteger := POISON_DONTMOVE;
      3: nInteger := POISON_68;
      4: nInteger := POISON_DECHEALTH;
      5: nInteger := POISON_LOCKSPELL;
      6: nInteger := POISON_DAMAGEARMOR;
      else begin
          m_nFixColorIdx := 0;
          nInteger := STATE_TRANSPARENT;
        end;
    end;
    m_nCharStatus := (m_nCharStatusEx and $FFFFF) or (($80000000 shr nInteger) or 0);
    m_nFixStatus := m_nCharStatus;
    StatusChanged();
  end;
  inherited;
end;

procedure TNormNpc.ScriptActionError(PlayObject: TPlayObject; sErrMsg: string;
  QuestActionInfo: pTQuestActionInfo; sCmd: string);
var
  sMsg: string;
resourcestring
  sOutMessage = '[�ű�����] %s �ű�����:%s NPC����:%s ��ͼ:%s(%d:%d) ����1:%s ����2:%s ����3:%s ����4:%s ����5:%s ����6:%s';
begin
  sMsg := format(sOutMessage, [sErrMsg,
    sCmd,
      m_sCharName,
      m_sMapName,
      m_nCurrX,
      m_nCurrY,
      QuestActionInfo.sParam1,
      QuestActionInfo.sParam2,
      QuestActionInfo.sParam3,
      QuestActionInfo.sParam4,
      QuestActionInfo.sParam5,
      QuestActionInfo.sParam6]);
  {
  sMsg:='�ű�����:' + sCmd +
        ' NPC����:' + m_sCharName +
        ' ��ͼ:' + m_sMapName +
        ' ����:' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) +
        ' ����1:' + QuestActionInfo.sParam1 +
        ' ����2:' + QuestActionInfo.sParam2 +
        ' ����3:' + QuestActionInfo.sParam3 +
        ' ����4:' + QuestActionInfo.sParam4 +
        ' ����5:' + QuestActionInfo.sParam5 +
        ' ����6:' + QuestActionInfo.sParam6;
  }
  MainOutMessage(sMsg);
end;

procedure TNormNpc.ScriptConditionError(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo; sCmd: string);
var
  sMsg: string;
begin
  sMsg := 'Cmd:' + sCmd +
    ' NPC����:' + m_sCharName +
    ' ��ͼ:' + m_sMapName +
    ' ����:' + IntToStr(m_nCurrX) + ':' + IntToStr(m_nCurrY) +
    ' ����1:' + QuestConditionInfo.sParam1 +
    ' ����2:' + QuestConditionInfo.sParam2 +
    ' ����3:' + QuestConditionInfo.sParam3 +
    ' ����4:' + QuestConditionInfo.sParam4 +
    ' ����5:' + QuestConditionInfo.sParam5;
  MainOutMessage('[�ű���������ȷ] ' + sMsg);
end;

procedure TNormNpc.SendMsgToUser(PlayObject: TPlayObject; sMsg: string); //0049AD14
begin
  PlayObject.SendMsg(Self, RM_MERCHANTSAY, 0, 0, 0, 0, m_sCharName + '/' + sMsg);
end;

function TNormNpc.sub_49ADB8(sMsg, sStr, sText: string): string; //0049ADB8
var
  n10: Integer;
  s14, s18: string;
begin
  n10 := Pos(sStr, sMsg);
  if n10 > 0 then begin
    s14 := Copy(sMsg, 1, n10 - 1);
    s18 := Copy(sMsg, Length(sStr) + n10, Length(sMsg));
    Result := s14 + sText + s18;
  end else Result := sMsg;
end;

procedure TNormNpc.UserSelect(PlayObject: TPlayObject; sData: string); //0049EC28
var
  sMsg, sLabel: string;
begin
  PlayObject.m_nScriptGotoCount := 0;

  //==============================================
  //����ű����� @back �����ϼ���ǩ����
  if (sData <> '') and (sData[1] = '@') then begin
    sMsg := GetValidStr3(sData, sLabel, [#13]);
    if (PlayObject.m_sScriptCurrLable <> sLabel) then begin
      if (sLabel <> sBACK) then begin
        PlayObject.m_sScriptGoBackLable := PlayObject.m_sScriptCurrLable;
        PlayObject.m_sScriptCurrLable := sLabel;
      end else begin
        if PlayObject.m_sScriptCurrLable <> '' then begin
          PlayObject.m_sScriptCurrLable := '';
        end else begin
          PlayObject.m_sScriptGoBackLable := '';
        end;
      end;
    end;
  end;
  //==============================================
end;

procedure TNormNpc.ActionOfChangeNameColor(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nColor: Integer;
begin
  if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, nColor) then begin //���ӱ���֧��
    nColor := QuestActionInfo.nParam1;
  end;
  if (nColor < 0) or (nColor > 255) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGENAMECOLOR);
    Exit;
  end;
  PlayObject.m_btNameColor := nColor;
  PlayObject.RefNameColor();
end;

procedure TNormNpc.ActionOfClearPassword(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_sStoragePwd := '';
  PlayObject.m_boPasswordLocked := False;
end;
//RECALLMOB �������� �ȼ� �ѱ�ʱ�� ��ɫ(0,1) �̶���ɫ(1 - 7)
//��ɫΪ0 ʱ�̶���ɫ��������

procedure TNormNpc.ActionOfRecallmob(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  boAutoChangeColor: Boolean;
  mon: TBaseObject;
  i: Integer;
  UserItem: pTUserItem;
begin
  if QuestActionInfo.nParam3 <= 1 then begin
    mon := PlayObject.MakeSlave(QuestActionInfo.sParam1, 3, Str_ToInt(QuestActionInfo.sParam2, 0), 100, 10 * 24 * 60 * 60);
  end else begin
    mon := PlayObject.MakeSlave(QuestActionInfo.sParam1, 3, Str_ToInt(QuestActionInfo.sParam2, 0), 100, QuestActionInfo.nParam3 * 60)
  end;
  if mon <> nil then begin
    if (QuestActionInfo.sParam4 <> '') and (QuestActionInfo.sParam4[1] = '1') then begin
      mon.m_boAutoChangeColor := True;
    end else
      if QuestActionInfo.nParam5 > 0 then begin
      mon.m_boFixColor := True;
      mon.m_nFixColorIdx := QuestActionInfo.nParam5 - 1;
    end;

    if mon.m_btRaceServer = RC_PLAYMOSTER then begin //��������ι֣����Գ�ҩ�ͼ���Ʒ
      mon.m_nCopyHumanLevel := 1;
      for i := 0 to m_ItemList.Count - 1 do begin //�������
        DisPose(m_ItemList.Items[i]);
      end;
      m_ItemList.Clear;
      TPlayMonster(mon).InitializeMonster; //���¼��ع�������
    end;
  end;
end;

procedure TNormNpc.ActionOfReNewLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nReLevel, nLevel: Integer;
  nBounsuPoint: Integer;
begin
  nReLevel := Str_ToInt(QuestActionInfo.sParam1, -1);
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  nBounsuPoint := Str_ToInt(QuestActionInfo.sParam3, -1);
  if nReLevel < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, nReLevel); //���ӱ���֧��
  end;
  if nLevel < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nLevel); //���ӱ���֧��
  end;
  if nBounsuPoint < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam3, nBounsuPoint); //���ӱ���֧��
  end;
  if (nReLevel < 0) or (nLevel < 0) or (nBounsuPoint < 0) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_RENEWLEVEL);
    Exit;
  end;
  if (PlayObject.m_btReLevel + nReLevel) <= 255 then begin
    Inc(PlayObject.m_btReLevel, nReLevel);
    if nLevel > 0 then PlayObject.m_Abil.Level := nLevel;
    if g_Config.boReNewLevelClearExp then PlayObject.m_Abil.Exp := 0;
    Inc(PlayObject.m_nBonusPoint, nBounsuPoint);
    PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
    PlayObject.HasLevelUp(0);
    PlayObject.RefShowName();
  end;
end;

procedure TNormNpc.ActionOfChangeGender(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nGENDER: Integer;
begin
  nGENDER := Str_ToInt(QuestActionInfo.sParam1, -1);
  if not (nGENDER in [0, 1]) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEGENDER);
    Exit;
  end;
  PlayObject.m_btGender := nGENDER;
  PlayObject.FeatureChanged;
end;

procedure TNormNpc.ActionOfKillSlave(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  Slave: TBaseObject;
begin
  for i := 0 to PlayObject.m_SlaveList.Count - 1 do begin
    Slave := TBaseObject(PlayObject.m_SlaveList.Items[i]);
    Slave.m_WAbil.HP := 0;
  end;
end;

procedure TNormNpc.ActionOfKillMonExpRate(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nRate: Integer;
  nTime: Integer;
begin
  nRate := Str_ToInt(QuestActionInfo.sParam1, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nRate < 0) or (nTime < 0) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_KILLMONEXPRATE);
    Exit;
  end;

  PlayObject.m_nKillMonExpRate := nRate;
  //PlayObject.m_dwKillMonExpRateTime:=_MIN(High(Word),nTime);
  PlayObject.m_dwKillMonExpRateTime := LongWord(nTime);
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sChangeKillMonExpRateMsg, [PlayObject.m_nKillMonExpRate / 100, PlayObject.m_dwKillMonExpRateTime]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfMonGenEx(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sMapName, sMonName: string;
  nMapX, nMapY, nRange, nCount: Integer;
  nRandX, nRandY: Integer;
begin
  sMapName := QuestActionInfo.sParam1;
  nMapX := Str_ToInt(QuestActionInfo.sParam2, -1);
  nMapY := Str_ToInt(QuestActionInfo.sParam3, -1);
  sMonName := QuestActionInfo.sParam4;
  nRange := QuestActionInfo.nParam5;
  nCount := QuestActionInfo.nParam6;
  if (sMapName = '') or (nMapX <= 0) or (nMapY <= 0) or (sMapName = '') or (nRange <= 0) or (nCount <= 0) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_MONGENEX);
    Exit;
  end;
  for i := 0 to nCount - 1 do begin
    nRandX := Random(nRange * 2 + 1) + (nMapX - nRange);
    nRandY := Random(nRange * 2 + 1) + (nMapY - nRange);
    if UserEngine.RegenMonsterByName(sMapName, nRandX, nRandY, sMonName) = nil then begin
      //ScriptActionError(PlayObject,'',QuestActionInfo,sSC_MONGENEX);
      break;
    end;
  end;
end;

procedure TNormNpc.ActionOfOpenMagicBox(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  Monster: TBaseObject;
  sMonName: string;
  nX, nY: Integer;
begin
  sMonName := QuestActionInfo.sParam1;
  if sMonName = '' then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_OPENMAGICBOX);
    Exit;
  end;
  PlayObject.GetFrontPosition(nX, nY);
  Monster := UserEngine.RegenMonsterByName(PlayObject.m_PEnvir.sMapName, nX, nY, sMonName);
  if Monster = nil then begin
    Exit;
  end;
  Monster.Die;
end;

procedure TNormNpc.ActionOfPkZone(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nX, nY: Integer;
  FireBurnEvent: TFireBurnEvent;
  nMinX, nMaxX, nMinY, nMaxY: Integer;
  nRange, nType, nTime, nPoint: Integer;
begin
  nRange := Str_ToInt(QuestActionInfo.sParam1, -1);
  nType := Str_ToInt(QuestActionInfo.sParam2, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam3, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam4, -1);
  if (nRange < 0) or (nType < 0) or (nTime < 0) or (nPoint < 0) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_PKZONE);
    Exit;
  end;
  {
  nMinX:=PlayObject.m_nCurrX - nRange;
  nMaxX:=PlayObject.m_nCurrX + nRange;
  nMinY:=PlayObject.m_nCurrY - nRange;
  nMaxY:=PlayObject.m_nCurrY + nRange;
  }
  nMinX := m_nCurrX - nRange;
  nMaxX := m_nCurrX + nRange;
  nMinY := m_nCurrY - nRange;
  nMaxY := m_nCurrY + nRange;
  for nX := nMinX to nMaxX do begin
    for nY := nMinY to nMaxY do begin
      if ((nX < nMaxX) and (nY = nMinY)) or
        ((nY < nMaxY) and (nX = nMinX)) or
        (nX = nMaxX) or (nY = nMaxY) then begin
        FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, nType, nTime * 1000, nPoint);
        g_EventManager.AddEvent(FireBurnEvent);
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfPowerRate(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nRate: Integer;
  nTime: Integer;
begin
  nRate := Str_ToInt(QuestActionInfo.sParam1, -1);
  nTime := Str_ToInt(QuestActionInfo.sParam2, -1);
  if (nRate < 0) or (nTime < 0) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_POWERRATE);
    Exit;
  end;

  PlayObject.m_nPowerRate := nRate;
  //PlayObject.m_dwPowerRateTime:=_MIN(High(Word),nTime);
  PlayObject.m_dwPowerRateTime := LongWord(nTime);
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sChangePowerRateMsg, [PlayObject.m_nPowerRate / 100, PlayObject.m_dwPowerRateTime]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfChangeMode(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nMode: Integer;
  boOpen: Boolean;
begin
  nMode := QuestActionInfo.nParam1;
  boOpen := Str_ToInt(QuestActionInfo.sParam2, -1) = 1;
  if nMode in [1..3] then begin
    case nMode of //
      1: begin
          PlayObject.m_boAdminMode := boOpen;
          if PlayObject.m_boAdminMode then PlayObject.SysMsg(sGameMasterMode, c_Green, t_Hint)
          else PlayObject.SysMsg(sReleaseGameMasterMode, c_Green, t_Hint);
        end;
      2: begin
          PlayObject.m_boSuperMan := boOpen;
          if PlayObject.m_boSuperMan then PlayObject.SysMsg(sSupermanMode, c_Green, t_Hint)
          else PlayObject.SysMsg(sReleaseSupermanMode, c_Green, t_Hint);
        end;
      3: begin
          PlayObject.m_boObMode := boOpen;
          if PlayObject.m_boObMode then PlayObject.SysMsg(sObserverMode, c_Green, t_Hint)
          else PlayObject.SysMsg(g_sReleaseObserverMode, c_Green, t_Hint);
        end;
    end;
  end else begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEMODE);
  end;
end;

procedure TNormNpc.ActionOfChangePerMission(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nPermission: Integer;
begin
  nPermission := Str_ToInt(QuestActionInfo.sParam1, -1);
  if nPermission in [0..10] then begin
    PlayObject.m_btPermission := nPermission;
  end else begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CHANGEPERMISSION);
    Exit;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sChangePermissionMsg, [PlayObject.m_btPermission]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGiveItem(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  sItemName: string;
  nItemCount: Integer;
begin
  if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, sItemName) then begin //���ӱ���֧��
    sItemName := QuestActionInfo.sParam1;
  end;
  if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nItemCount) then begin //���ӱ���֧��
    nItemCount := QuestActionInfo.nParam2;
  end;
  if (sItemName = '') or (nItemCount <= 0) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GIVE);
    Exit;
  end;
  if nItemCount <= 0 then Exit;
  if CompareText(sItemName, sSTRING_GOLDNAME) = 0 then begin
    PlayObject.IncGold(nItemCount);
    PlayObject.GoldChanged();
    //0049D2FE
    if g_boGameLogGold then
      AddGameDataLog('9' + #9 +
        PlayObject.m_sMapName + #9 +
        IntToStr(PlayObject.m_nCurrX) + #9 +
        IntToStr(PlayObject.m_nCurrY) + #9 +
        PlayObject.m_sCharName + #9 +
        sSTRING_GOLDNAME + #9 +
        IntToStr(nItemCount) + #9 +
        '1' + #9 +
        m_sCharName);
    Exit;
  end;

  if UserEngine.GetStdItemIdx(sItemName) > 0 then begin
    //    if nItemCount > 50 then nItemCount:=50;//11.22 ����������С
    if not (nItemCount in [1..50]) then nItemCount := 1; //12.28 ����һ��
    for i := 0 to nItemCount - 1 do begin //nItemCount Ϊ0ʱ����ѭ��
      if PlayObject.IsEnoughBag then begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
          PlayObject.m_ItemList.Add((UserItem));
          PlayObject.SendAddItem(UserItem);
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          //0049D46B
          if StdItem.NeedIdentify = 1 then
            AddGameDataLog('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
        end else DisPose(UserItem);
      end else begin
        New(UserItem);
        if UserEngine.CopyToUserItemFromName(sItemName, UserItem) then begin
          StdItem := UserEngine.GetStdItem(UserItem.wIndex);
          //0049D5A5
          if StdItem.NeedIdentify = 1 then
            AddGameDataLog('9' + #9 +
              PlayObject.m_sMapName + #9 +
              IntToStr(PlayObject.m_nCurrX) + #9 +
              IntToStr(PlayObject.m_nCurrY) + #9 +
              PlayObject.m_sCharName + #9 +
              sItemName + #9 +
              IntToStr(UserItem.MakeIndex) + #9 +
              '1' + #9 +
              m_sCharName);
          PlayObject.DropItemDown(UserItem, 3, False, PlayObject, nil);
        end;
        DisPose(UserItem);
      end;
    end;
  end;
end;

procedure TNormNpc.ActionOfGmExecute(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  sData: string;
  btOldPermission: Byte;
  sParam1, sParam2, sParam3, sParam4, sParam5, sParam6: string;
begin
  sParam1 := QuestActionInfo.sParam1;
  sParam2 := QuestActionInfo.sParam2;
  sParam3 := QuestActionInfo.sParam3;
  sParam4 := QuestActionInfo.sParam4;
  sParam5 := QuestActionInfo.sParam5;
  sParam6 := QuestActionInfo.sParam6;
  if CompareText(sParam2, 'Self') = 0 then sParam2 := PlayObject.m_sCharName;

  sData := format('@%s %s %s %s %s %s', [sParam1,
    sParam2,
      sParam3,
      sParam4,
      sParam5,
      sParam6]);
  btOldPermission := PlayObject.m_btPermission;
  try
    PlayObject.m_btPermission := 10;
    PlayObject.ProcessUserLineMsg(sData);
  finally
    PlayObject.m_btPermission := btOldPermission;
  end;
end;

procedure TNormNpc.ActionOfGuildAuraePoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nAuraePoint: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nAuraePoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nAuraePoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nAuraePoint) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_AURAEPOINT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    PlayObject.SysMsg(g_sScriptGuildAuraePointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        Guild.nAurae := nAuraePoint;
      end;
    '-': begin
        if Guild.nAurae >= nAuraePoint then begin
          Guild.nAurae := Guild.nAurae - nAuraePoint;
        end else begin
          Guild.nAurae := 0;
        end;
      end;
    '+': begin
        if (High(Integer) - Guild.nAurae) >= nAuraePoint then begin
          Guild.nAurae := Guild.nAurae + nAuraePoint;
        end else begin
          Guild.nAurae := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sScriptGuildAuraePointMsg, [Guild.nAurae]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGuildBuildPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nBuildPoint: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nBuildPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nBuildPoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nBuildPoint) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_BUILDPOINT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    PlayObject.SysMsg(g_sScriptGuildBuildPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        Guild.nBuildPoint := nBuildPoint;
      end;
    '-': begin
        if Guild.nBuildPoint >= nBuildPoint then begin
          Guild.nBuildPoint := Guild.nBuildPoint - nBuildPoint;
        end else begin
          Guild.nBuildPoint := 0;
        end;
      end;
    '+': begin
        if (High(Integer) - Guild.nBuildPoint) >= nBuildPoint then begin
          Guild.nBuildPoint := Guild.nBuildPoint + nBuildPoint;
        end else begin
          Guild.nBuildPoint := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sScriptGuildBuildPointMsg, [Guild.nBuildPoint]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGuildChiefItemCount(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nItemCount: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nItemCount := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nItemCount < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nItemCount) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_GUILDCHIEFITEMCOUNT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    PlayObject.SysMsg(g_sScriptGuildFlourishPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        Guild.nChiefItemCount := nItemCount;
      end;
    '-': begin
        if Guild.nChiefItemCount >= nItemCount then begin
          Guild.nChiefItemCount := Guild.nChiefItemCount - nItemCount;
        end else begin
          Guild.nChiefItemCount := 0;
        end;
      end;
    '+': begin
        if (High(Integer) - Guild.nChiefItemCount) >= nItemCount then begin
          Guild.nChiefItemCount := Guild.nChiefItemCount + nItemCount;
        end else begin
          Guild.nChiefItemCount := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sScriptChiefItemCountMsg, [Guild.nChiefItemCount]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGuildFlourishPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nFlourishPoint: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nFlourishPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nFlourishPoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nFlourishPoint) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_FLOURISHPOINT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    PlayObject.SysMsg(g_sScriptGuildFlourishPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        Guild.nFlourishing := nFlourishPoint;
      end;
    '-': begin
        if Guild.nFlourishing >= nFlourishPoint then begin
          Guild.nFlourishing := Guild.nFlourishing - nFlourishPoint;
        end else begin
          Guild.nFlourishing := 0;
        end;
      end;
    '+': begin
        if (High(Integer) - Guild.nFlourishing) >= nFlourishPoint then begin
          Guild.nFlourishing := Guild.nFlourishing + nFlourishPoint;
        end else begin
          Guild.nFlourishing := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sScriptGuildFlourishPointMsg, [Guild.nFlourishing]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfGuildstabilityPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);

var
  nStabilityPoint: Integer;
  cMethod: Char;
  Guild: TGUild;
begin
  nStabilityPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nStabilityPoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nStabilityPoint) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_STABILITYPOINT);
      Exit;
    end;
  end;
  if PlayObject.m_MyGuild = nil then begin
    PlayObject.SysMsg(g_sScriptGuildStabilityPointNoGuild, c_Red, t_Hint);
    Exit;
  end;
  Guild := TGUild(PlayObject.m_MyGuild);

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        Guild.nStability := nStabilityPoint;
      end;
    '-': begin
        if Guild.nStability >= nStabilityPoint then begin
          Guild.nStability := Guild.nStability - nStabilityPoint;
        end else begin
          Guild.nStability := 0;
        end;
      end;
    '+': begin
        if (High(Integer) - Guild.nStability) >= nStabilityPoint then begin
          Guild.nStability := Guild.nStability + nStabilityPoint;
        end else begin
          Guild.nStability := High(Integer);
        end;
      end;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sScriptGuildStabilityPointMsg, [Guild.nStability]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfHumanHP(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nHP: Integer;
  cMethod: Char;
begin
  nHP := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nHP < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nHP) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HUMANHP);
      Exit;
    end;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        PlayObject.m_WAbil.HP := nHP;
      end;
    '-': begin
        if PlayObject.m_WAbil.HP >= nHP then begin
          Dec(PlayObject.m_WAbil.HP, nHP);
        end else begin
          PlayObject.m_WAbil.HP := 0;
        end;
      end;
    '+': begin
        Inc(PlayObject.m_WAbil.HP, nHP);
        if PlayObject.m_WAbil.HP > PlayObject.m_WAbil.MaxHP then PlayObject.m_WAbil.HP := PlayObject.m_WAbil.MaxHP;
      end;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sScriptChangeHumanHPMsg, [PlayObject.m_WAbil.MaxHP]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfHumanMP(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nMP: Integer;
  cMethod: Char;
begin
  nMP := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nMP < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nMP) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_HUMANMP);
      Exit;
    end;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        PlayObject.m_WAbil.MP := nMP;
      end;
    '-': begin
        if PlayObject.m_WAbil.MP >= nMP then begin
          Dec(PlayObject.m_WAbil.MP, nMP);
        end else begin
          PlayObject.m_WAbil.MP := 0;
        end;
      end;
    '+': begin
        Inc(PlayObject.m_WAbil.MP, nMP);
        if PlayObject.m_WAbil.MP > PlayObject.m_WAbil.MaxMP then PlayObject.m_WAbil.MP := PlayObject.m_WAbil.MaxMP;
      end;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sScriptChangeHumanMPMsg, [PlayObject.m_WAbil.MaxMP]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfUseBonusPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nPosition, nCount: Integer;
  cMethod: Char;
begin
  nPosition := Str_ToInt(QuestActionInfo.sParam1, -1);
  cMethod := QuestActionInfo.sParam2[1];
  nCount := Str_ToInt(QuestActionInfo.sParam3, -1);
  if (nPosition < 0) or (nCount < 0) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_USEBONUSPOINT);
    Exit;
  end;
  case cMethod of
    '+': begin
        case nPosition of
          1: Inc(PlayObject.m_BonusAbil.DC, nCount);
          2: Inc(PlayObject.m_BonusAbil.MC, nCount);
          3: Inc(PlayObject.m_BonusAbil.SC, nCount);
          4: Inc(PlayObject.m_BonusAbil.AC, nCount);
          5: Inc(PlayObject.m_BonusAbil.MAC, nCount);
          6: Inc(PlayObject.m_BonusAbil.HP, nCount);
          7: Inc(PlayObject.m_BonusAbil.MP, nCount);
          8: Inc(PlayObject.m_BonusAbil.Hit, nCount);
          9: Inc(PlayObject.m_BonusAbil.Speed, nCount);
        end;
      end;
    '-': begin
        case nPosition of
          1: Dec(PlayObject.m_BonusAbil.DC, nCount);
          2: Dec(PlayObject.m_BonusAbil.MC, nCount);
          3: Dec(PlayObject.m_BonusAbil.SC, nCount);
          4: Dec(PlayObject.m_BonusAbil.AC, nCount);
          5: Dec(PlayObject.m_BonusAbil.MAC, nCount);
          6: Dec(PlayObject.m_BonusAbil.HP, nCount);
          7: Dec(PlayObject.m_BonusAbil.MP, nCount);
          8: Dec(PlayObject.m_BonusAbil.Hit, nCount);
          9: Dec(PlayObject.m_BonusAbil.Speed, nCount);
        end;
      end;
    '=': begin
        case nPosition of
          1: PlayObject.m_BonusAbil.DC := nCount;
          2: PlayObject.m_BonusAbil.MC := nCount;
          3: PlayObject.m_BonusAbil.SC := nCount;
          4: PlayObject.m_BonusAbil.AC := nCount;
          5: PlayObject.m_BonusAbil.MAC := nCount;
          6: PlayObject.m_BonusAbil.HP := nCount;
          7: PlayObject.m_BonusAbil.MP := nCount;
          8: PlayObject.m_BonusAbil.Hit := nCount;
          9: PlayObject.m_BonusAbil.Speed := nCount;
        end;
      end;
  end;
  PlayObject.RecalcAbilitys();
  PlayObject.SendMsg(PlayObject, RM_ABILITY, 0, 0, 0, 0, '');
  PlayObject.SendMsg(PlayObject, RM_SUBABILITY, 0, 0, 0, 0, '');
end;

procedure TNormNpc.ActionOfKick(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_boKickFlag := True;
end;

procedure TNormNpc.ActionOfKill(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nMode: Integer;
begin
  nMode := Str_ToInt(QuestActionInfo.sParam1, -1);
  if nMode in [0..3] then begin
    case nMode of //
      1: begin
          PlayObject.m_boNoItem := True;
          PlayObject.Die;
        end;
      2: begin
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
      3: begin
          PlayObject.m_boNoItem := True;
          PlayObject.SetLastHiter(Self);
          PlayObject.Die;
        end;
      else begin
          PlayObject.Die;
        end;
    end;
  end else begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_KILL);
  end;
end;

procedure TNormNpc.ActionOfBonusPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nBonusPoint: Integer;
  nPoint: Integer;
  nOldPKLevel: Integer;
  cMethod: Char;
begin
  nBonusPoint := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nBonusPoint < 0 then begin
    ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nBonusPoint); //���ӱ���֧��
  end;
  if (nBonusPoint < 0) or (nBonusPoint > 10000) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_BONUSPOINT);
    Exit;
  end;

  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        FillChar(PlayObject.m_BonusAbil, SizeOf(TNakedAbility), #0);
        PlayObject.HasLevelUp(0);
        PlayObject.m_nBonusPoint := nBonusPoint;
        PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
      end;
    '-': begin
        if PlayObject.m_nBonusPoint >= nBonusPoint then begin
          Dec(PlayObject.m_nBonusPoint, nBonusPoint);
        end else begin
          PlayObject.m_nBonusPoint := 0;
        end;
        PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
      end;
    '+': begin
        Inc(PlayObject.m_nBonusPoint, nBonusPoint);
        PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
      end;
  end;
end;

procedure TNormNpc.ActionOfDelMarry(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_sDearName := '';
  PlayObject.RefShowName;
end;

procedure TNormNpc.ActionOfDelMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_sMasterName := '';
  PlayObject.RefShowName;
end;

procedure TNormNpc.ActionOfRestBonusPoint(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nTotleUsePoint: Integer;
begin
  nTotleUsePoint := PlayObject.m_BonusAbil.DC +
    PlayObject.m_BonusAbil.MC +
    PlayObject.m_BonusAbil.SC +
    PlayObject.m_BonusAbil.AC +
    PlayObject.m_BonusAbil.MAC +
    PlayObject.m_BonusAbil.HP +
    PlayObject.m_BonusAbil.MP +
    PlayObject.m_BonusAbil.Hit +
    PlayObject.m_BonusAbil.Speed +
    PlayObject.m_BonusAbil.X2;
  FillChar(PlayObject.m_BonusAbil, SizeOf(TNakedAbility), #0);
  Inc(PlayObject.m_nBonusPoint, nTotleUsePoint);
  PlayObject.SendMsg(PlayObject, RM_ADJUST_BONUS, 0, 0, 0, 0, '');
  PlayObject.HasLevelUp(0);
  PlayObject.SysMsg('��������Ѹ�λ������', c_Red, t_Hint);
end;

procedure TNormNpc.ActionOfRestReNewLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
begin
  PlayObject.m_btReLevel := 0;
  PlayObject.HasLevelUp(0);
end;

procedure TNormNpc.ActionOfSetMapMode(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  Envir: TEnvirnoment;
  sMapName: string;
  sMapMode, sParam1, sParam2 {,sParam3,sParam4}: string;
begin
  sMapName := QuestActionInfo.sParam1;
  sMapMode := QuestActionInfo.sParam2;
  sParam1 := QuestActionInfo.sParam3;
  sParam2 := QuestActionInfo.sParam4;
  //  sParam3:=QuestActionInfo.sParam5;
  //  sParam4:=QuestActionInfo.sParam6;

  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) or (sMapMode = '') then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETMAPMODE);
    Exit;
  end;
  if CompareText(sMapMode, 'SAFE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boSAFE := True;
    end else begin
      Envir.m_boSAFE := False;
    end;
  end else
    if CompareText(sMapMode, 'DARK') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boDARK := True;
    end else begin
      Envir.m_boDARK := False;
    end;
  end else
    if CompareText(sMapMode, 'DARK') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boDARK := True;
    end else begin
      Envir.m_boDARK := False;
    end;
  end else
    if CompareText(sMapMode, 'FIGHT') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boFightZone := True;
    end else begin
      Envir.m_boFightZone := False;
    end;
  end else
    if CompareText(sMapMode, 'FIGHT3') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boFight3Zone := True;
    end else begin
      Envir.m_boFight3Zone := False;
    end;
  end else
    if CompareText(sMapMode, 'DAY') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boDAY := True;
    end else begin
      Envir.m_boDAY := False;
    end;
  end else
    if CompareText(sMapMode, 'QUIZ') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boQUIZ := True;
    end else begin
      Envir.m_boQUIZ := False;
    end;
  end else
    if CompareText(sMapMode, 'NORECONNECT') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNORECONNECT := True;
      Envir.sNoReconnectMap := sParam1;
    end else begin
      Envir.m_boNORECONNECT := False;
    end;
  end else
    if CompareText(sMapMode, 'MUSIC') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boMUSIC := True;
      Envir.m_nMUSICID := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boMUSIC := False;
    end;
  end else
    if CompareText(sMapMode, 'EXPRATE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boEXPRATE := True;
      Envir.m_nEXPRATE := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boEXPRATE := False;
    end;
  end else
    if CompareText(sMapMode, 'PKWINLEVEL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boPKWINLEVEL := True;
      Envir.m_nPKWINLEVEL := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boPKWINLEVEL := False;
    end;
  end else
    if CompareText(sMapMode, 'PKWINEXP') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boPKWINEXP := True;
      Envir.m_nPKWINEXP := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boPKWINEXP := False;
    end;
  end else
    if CompareText(sMapMode, 'PKLOSTLEVEL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boPKLOSTLEVEL := True;
      Envir.m_nPKLOSTLEVEL := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boPKLOSTLEVEL := False;
    end;
  end else
    if CompareText(sMapMode, 'PKLOSTEXP') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boPKLOSTEXP := True;
      Envir.m_nPKLOSTEXP := Str_ToInt(sParam1, -1);
    end else begin
      Envir.m_boPKLOSTEXP := False;
    end;
  end else
    if CompareText(sMapMode, 'DECHP') = 0 then begin
    if (sParam1 <> '') and (sParam2 <> '') then begin
      Envir.m_boDECHP := True;
      Envir.m_nDECHPTIME := Str_ToInt(sParam1, -1);
      Envir.m_nDECHPPOINT := Str_ToInt(sParam2, -1);
    end else begin
      Envir.m_boDECHP := False;
    end;
  end else
    if CompareText(sMapMode, 'DECGAMEGOLD') = 0 then begin
    if (sParam1 <> '') and (sParam2 <> '') then begin
      Envir.m_boDecGameGold := True;
      Envir.m_nDECGAMEGOLDTIME := Str_ToInt(sParam1, -1);
      Envir.m_nDecGameGold := Str_ToInt(sParam2, -1);
    end else begin
      Envir.m_boDecGameGold := False;
    end;
  end else
    if CompareText(sMapMode, 'RUNHUMAN') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boRUNHUMAN := True;
    end else begin
      Envir.m_boRUNHUMAN := False;
    end;
  end else
    if CompareText(sMapMode, 'RUNMON') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boRUNMON := True;
    end else begin
      Envir.m_boRUNMON := False;
    end;
  end else
    if CompareText(sMapMode, 'NEEDHOLE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNEEDHOLE := True;
    end else begin
      Envir.m_boNEEDHOLE := False;
    end;
  end else
    if CompareText(sMapMode, 'NORECALL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNORECALL := True;
    end else begin
      Envir.m_boNORECALL := False;
    end;
  end else
    if CompareText(sMapMode, 'NOGUILDRECALL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNOGUILDRECALL := True;
    end else begin
      Envir.m_boNOGUILDRECALL := False;
    end;
  end else
    if CompareText(sMapMode, 'NODEARRECALL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNODEARRECALL := True;
    end else begin
      Envir.m_boNODEARRECALL := False;
    end;
  end else
    if CompareText(sMapMode, 'NOMASTERRECALL') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNOMASTERRECALL := True;
    end else begin
      Envir.m_boNOMASTERRECALL := False;
    end;
  end else
    if CompareText(sMapMode, 'NORANDOMMOVE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNORANDOMMOVE := True;
    end else begin
      Envir.m_boNORANDOMMOVE := False;
    end;
  end else
    if CompareText(sMapMode, 'NODRUG') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNODRUG := True;
    end else begin
      Envir.m_boNODRUG := False;
    end;
  end else
    if CompareText(sMapMode, 'MINE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boMINE := True;
    end else begin
      Envir.m_boMINE := False;
    end;
  end else
    if CompareText(sMapMode, 'NOPOSITIONMOVE') = 0 then begin
    if (sParam1 <> '') then begin
      Envir.m_boNOPOSITIONMOVE := True;
    end else begin
      Envir.m_boNOPOSITIONMOVE := False;
    end;
  end;
end;

procedure TNormNpc.ActionOfSetMemberLevel(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nLevel: Integer;
  cMethod: Char;
begin
  nLevel := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nLevel < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nLevel) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETMEMBERLEVEL);
      Exit;
    end;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        PlayObject.m_nMemberLevel := nLevel;
      end;
    '-': begin
        Dec(PlayObject.m_nMemberLevel, nLevel);
        if PlayObject.m_nMemberLevel < 0 then PlayObject.m_nMemberLevel := 0;
      end;
    '+': begin
        Inc(PlayObject.m_nMemberLevel, nLevel);
        if PlayObject.m_nMemberLevel > 65535 then PlayObject.m_nMemberLevel := 65535;
      end;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sChangeMemberLevelMsg, [PlayObject.m_nMemberLevel]), c_Green, t_Hint);
  end;
end;

procedure TNormNpc.ActionOfSetMemberType(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nType: Integer;
  cMethod: Char;
begin
  nType := Str_ToInt(QuestActionInfo.sParam2, -1);
  if nType < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nType) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SETMEMBERTYPE);
      Exit;
    end;
  end;
  cMethod := QuestActionInfo.sParam1[1];
  case cMethod of
    '=': begin
        PlayObject.m_nMemberType := nType;
      end;
    '-': begin
        Dec(PlayObject.m_nMemberType, nType);
        if PlayObject.m_nMemberType < 0 then PlayObject.m_nMemberType := 0;
      end;
    '+': begin
        Inc(PlayObject.m_nMemberType, nType);
        if PlayObject.m_nMemberType > 65535 then PlayObject.m_nMemberType := 65535;
      end;
  end;
  if g_Config.boShowScriptActionMsg then begin
    PlayObject.SysMsg(format(g_sChangeMemberTypeMsg, [PlayObject.m_nMemberType]), c_Green, t_Hint);
  end;
end;

function TNormNpc.ConditionOfCheckGuildList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
end;

function TNormNpc.ConditionOfCheckMonMapCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sMapName: string;
  nCount: Integer;
  nMapRangeCount: Integer;
  Envir: TEnvirnoment;
  MonList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  sMapName := QuestConditionInfo.sParam1;
  nCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCount < 0 then ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nCount);
  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) or (nCount < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sCHECKMONMAP);
    Exit;
  end;
  MonList := TList.Create;
  nMapRangeCount := UserEngine.GetMapMonster(Envir, MonList);
  for i := MonList.Count - 1 downto 0 do begin
    if MonList.Count <= 0 then break;
    BaseObject := TBaseObject(MonList.Items[i]);
    if (BaseObject.m_btRaceServer < RC_ANIMAL) or (BaseObject.m_btRaceServer = RC_ARCHERGUARD) or (BaseObject.m_Master <> nil) or (BaseObject.m_btRaceServer = RC_NPC) or (BaseObject.m_btRaceServer = RC_PEACENPC) then
      MonList.Delete(i);
  end;
  nMapRangeCount := MonList.Count;
  if nMapRangeCount >= nCount then Result := True;
  MonList.Free;
end;

function TNormNpc.ConditionOfCheckRangeMonCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sMapName: string;
  nX, nY, nRange, nCount: Integer;
  cMethod: Char;
  nMapRangeCount: Integer;
  Envir: TEnvirnoment;
  MonList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  sMapName := QuestConditionInfo.sParam1;
  nX := Str_ToInt(QuestConditionInfo.sParam2, -1);
  nY := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nRange := Str_ToInt(QuestConditionInfo.sParam4, -1);
  cMethod := QuestConditionInfo.sParam5[1];
  nCount := Str_ToInt(QuestConditionInfo.sParam6, -1);
  if nX < 0 then ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nX);
  if nY < 0 then ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam3, nY);
  if nRange < 0 then ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam4, nRange);
  if nCount < 0 then ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam6, nCount);
  Envir := g_MapManager.FindMap(sMapName);
  if (Envir = nil) or (nX < 0) or (nY < 0) or (nRange < 0) or (nCount < 0) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKRANGEMONCOUNT);
    Exit;
  end;
  MonList := TList.Create;
  nMapRangeCount := Envir.GetRangeBaseObject(nX, nY, nRange, True, MonList);
  for i := MonList.Count - 1 downto 0 do begin
    if MonList.Count <= 0 then break;
    BaseObject := TBaseObject(MonList.Items[i]);
    if (BaseObject.m_btRaceServer < RC_ANIMAL) or (BaseObject.m_btRaceServer = RC_ARCHERGUARD) or (BaseObject.m_Master <> nil) or (BaseObject.m_btRaceServer = RC_NPC) or (BaseObject.m_btRaceServer = RC_PEACENPC) then
      MonList.Delete(i);
  end;
  nMapRangeCount := MonList.Count;
  case cMethod of
    '=': if nMapRangeCount = nCount then Result := True;
    '>': if nMapRangeCount > nCount then Result := True;
    '<': if nMapRangeCount < nCount then Result := True;
    else if nMapRangeCount >= nCount then Result := True;
  end;
  MonList.Free;
end;

function TNormNpc.ConditionOfCheckReNewLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nLevel: Integer;
  cMethod: Char;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nLevel) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKLEVELEX);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btReLevel = nLevel then Result := True;
    '>': if PlayObject.m_btReLevel > nLevel then Result := True;
    '<': if PlayObject.m_btReLevel < nLevel then Result := True;
    else if PlayObject.m_btReLevel >= nLevel then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckSlaveLevel(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  nLevel: Integer;
  cMethod: Char;
  BaseObject: TBaseObject;
  nSlaveLevel: Integer;
begin
  Result := False;
  nLevel := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nLevel < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nLevel) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKLEVELEX);
      Exit;
    end;
  end;
  nSlaveLevel := -1;
  for i := 0 to PlayObject.m_SlaveList.Count - 1 do begin
    BaseObject := TBaseObject(PlayObject.m_SlaveList.Items[i]);
    if BaseObject.m_Abil.Level > nSlaveLevel then nSlaveLevel := BaseObject.m_Abil.Level;
  end;
  if nSlaveLevel < 0 then Exit;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nSlaveLevel = nLevel then Result := True;
    '>': if nSlaveLevel > nLevel then Result := True;
    '<': if nSlaveLevel < nLevel then Result := True;
    else if nSlaveLevel >= nLevel then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckUseItem(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nWhere: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  Result := False;
  nWhere := Str_ToInt(QuestConditionInfo.sParam1, -1);
  if nWhere < 0 then ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, nWhere);
  if (nWhere < 0) or (nWhere > High(THumanUseItems)) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKUSEITEM);
    Exit;
  end;
  if PlayObject.m_UseItems[nWhere].wIndex > 0 then
    Result := True;
end;

function TNormNpc.ConditionOfCheckVar(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sType: string;
  VarType: TVarType;
  sVarName: string;
  sVarValue: string;
  nVarValue: Integer;
  sName: string;
  sMethod: string;
  cMethod: Char;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
resourcestring
  sVarFound = '����%s�Ѵ��ڣ���������:%s';
  sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
begin
  Result := False;
  sType := QuestConditionInfo.sParam1;
  sVarName := QuestConditionInfo.sParam2;
  sMethod := QuestConditionInfo.sParam3;
  nVarValue := Str_ToInt(QuestConditionInfo.sParam4, 0);
  sVarValue := QuestConditionInfo.sParam4;

  if (sType = '') or (sVarName = '') or (sMethod = '') then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKVAR);
    Exit;
  end;
  cMethod := sMethod[1];
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then begin
    ScriptConditionError(PlayObject {,format(sVarTypeError,[sType])}, QuestConditionInfo, sSC_CHECKVAR);
    Exit;
  end else begin
    for i := 0 to DynamicVarList.Count - 1 do begin
      DynamicVar := DynamicVarList.Items[i];
      if DynamicVar <> nil then begin
        if CompareText(DynamicVar.sName, sVarName) = 0 then begin
          case DynamicVar.VarType of
            vInteger: begin
                case cMethod of
                  '=': if DynamicVar.nInternet = nVarValue then Result := True;
                  '>': if DynamicVar.nInternet > nVarValue then Result := True;
                  '<': if DynamicVar.nInternet < nVarValue then Result := True;
                  else if DynamicVar.nInternet >= nVarValue then Result := True;
                end;
              end;
            vString: ;
          end;
          boFoundVar := True;
          break;
        end;
      end;
    end;
    if not boFoundVar then
      ScriptConditionError(PlayObject, {format(sVarFound,[sVarName,sType]),} QuestConditionInfo, sSC_CHECKVAR);
  end;
end;

(*function TNormNpc.ConditionOfCheckVar(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sType: string;
  VarType: TVarType;
  sVarName: string;
  sVarValue: string;
  nVarValue: Integer;
  sVarValue2: string;
  nVarValue2: Integer;
  sName: string;
  sMethod: string;
  cMethod: Char;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
resourcestring
  sVarFound = '����%s�Ѵ��ڣ���������:%s';
  sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
begin
  Result := False;
  sType := QuestConditionInfo.sParam1;
  sVarName := QuestConditionInfo.sParam2;
  sMethod := QuestConditionInfo.sParam3;
  sVarValue := QuestConditionInfo.sParam4;
  sVarValue2 := QuestConditionInfo.sParam5;
  if (sType = '') or (sVarName = '') or (sMethod = '') then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKVAR);
    Exit;
  end;
  boFoundVar := False;
  if (sVarValue <> '') and (sVarValue2 <> '') and (not IsStringNumber(sVarValue)) and (not IsStringNumber(sVarValue2)) then begin
    DynamicVarList := GetDynamicVarList(PlayObject, sVarValue, sName);
    if DynamicVarList = nil then begin
      DisPose(DynamicVar);
      ScriptConditionError(PlayObject {,format(sVarTypeError,[sType])}, QuestConditionInfo, sSC_CHECKVAR);
      Exit;
    end else begin
      for i := 0 to DynamicVarList.Count - 1 do begin
        DynamicVar := DynamicVarList.Items[i];
        if DynamicVar <> nil then begin
          if CompareText(DynamicVar.sName, sVarValue2) = 0 then begin
            case DynamicVar.VarType of
              vInteger: begin
                  nVarValue := DynamicVar.nInternet;
                end;
              vString: begin

                end;
            end;
            boFoundVar := True;
            break;
          end;
        end;
      end;
      if not boFoundVar then begin
        ScriptConditionError(PlayObject, {format(sVarFound,[sVarName,sType]),} QuestConditionInfo, sSC_CHECKVAR);
        Exit;
      end;
    end;
  end else nVarValue := Str_ToInt(QuestConditionInfo.sParam4, 0);
  cMethod := sMethod[1];
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then begin
    ScriptConditionError(PlayObject {,format(sVarTypeError,[sType])}, QuestConditionInfo, sSC_CHECKVAR);
    Exit;
  end;
  for i := 0 to DynamicVarList.Count - 1 do begin
    DynamicVar := DynamicVarList.Items[i];
    if CompareText(DynamicVar.sName, sVarName) = 0 then begin
      case DynamicVar.VarType of
        vInteger: begin
            case cMethod of
              '=': if DynamicVar.nInternet = nVarValue then Result := True;
              '>': if DynamicVar.nInternet > nVarValue then Result := True;
              '<': if DynamicVar.nInternet < nVarValue then Result := True;
              else if DynamicVar.nInternet >= nVarValue then Result := True;
            end;
          end;
        vString: ;
      end;
      boFoundVar := True;
      break;
    end;
  end;
  if not boFoundVar then
    ScriptConditionError(PlayObject, {format(sVarFound,[sVarName,sType]),} QuestConditionInfo, sSC_CHECKVAR);
end;*)

function TNormNpc.ConditionOfHaveMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := False;
  if PlayObject.m_sMasterName <> '' then
    Result := True;
end;

function TNormNpc.ConditionOfPoseHaveMaster(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  PoseHuman: TBaseObject;
begin
  Result := False;
  PoseHuman := PlayObject.GetPoseCreate();
  if (PoseHuman <> nil) and (PoseHuman.m_btRaceServer = RC_PLAYOBJECT) then begin
    if (TPlayObject(PoseHuman).m_sMasterName <> '') then
      Result := True;
  end;
end;

procedure TNormNpc.ActionOfUnMaster(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  PoseHuman: TPlayObject;
  LoadList: TStringList;
  sUnMarryFileName: string;
  sMsg: string;
begin
  if PlayObject.m_sMasterName = '' then begin
    GotoLable(PlayObject, '@ExeMasterFail', False);
    Exit;
  end;
  PoseHuman := TPlayObject(PlayObject.GetPoseCreate);
  if PoseHuman = nil then begin
    GotoLable(PlayObject, '@UnMasterCheckDir', False);
  end;
  if PoseHuman <> nil then begin
    if QuestActionInfo.sParam1 = '' then begin
      if PoseHuman.m_btRaceServer <> RC_PLAYOBJECT then begin
        GotoLable(PlayObject, '@UnMasterTypeErr', False);
        Exit;
      end;
      if PoseHuman.GetPoseCreate = PlayObject then begin
        if (PlayObject.m_sMasterName = PoseHuman.m_sCharName) then begin
          if PlayObject.m_boMaster then begin
            GotoLable(PlayObject, '@UnIsMaster', False);
            Exit;
          end;
          if PlayObject.m_sMasterName <> PoseHuman.m_sCharName then begin
            GotoLable(PlayObject, '@UnMasterError', False);
            Exit;
          end;

          GotoLable(PlayObject, '@StartUnMaster', False);
          GotoLable(PoseHuman, '@WateUnMaster', False);
          Exit;
        end;
      end;
    end;
  end;
  if (CompareText(QuestActionInfo.sParam1, 'REQUESTUNMASTER' {sREQUESTUNMARRY}) = 0) then begin
    if (QuestActionInfo.sParam2 = '') then begin
      if PoseHuman <> nil then begin
        PlayObject.m_boStartUnMaster := True;
        if PlayObject.m_boStartUnMaster and PoseHuman.m_boStartUnMaster then begin
          sMsg := AnsiReplaceText(g_sNPCSayUnMasterOKMsg, '%n', m_sCharName);
          sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
          sMsg := AnsiReplaceText(sMsg, '%d', PoseHuman.m_sCharName);
          UserEngine.SendBroadCastMsg(sMsg, t_Say);
          PlayObject.m_sMasterName := '';
          PoseHuman.m_sMasterName := '';
          PlayObject.m_boStartUnMaster := False;
          PoseHuman.m_boStartUnMaster := False;
          PlayObject.RefShowName;
          PoseHuman.RefShowName;
          GotoLable(PlayObject, '@UnMasterEnd', False);
          GotoLable(PoseHuman, '@UnMasterEnd', False);
        end else begin
          GotoLable(PlayObject, '@WateUnMaster', False);
          GotoLable(PoseHuman, '@RevUnMaster', False);
        end;
      end;
      Exit;
    end else begin
      //ǿ�г�ʦ
      if (CompareText(QuestActionInfo.sParam2, 'FORCE') = 0) then begin
        sMsg := AnsiReplaceText(g_sNPCSayForceUnMasterMsg, '%n', m_sCharName);
        sMsg := AnsiReplaceText(sMsg, '%s', PlayObject.m_sCharName);
        sMsg := AnsiReplaceText(sMsg, '%d', PlayObject.m_sMasterName);
        UserEngine.SendBroadCastMsg(sMsg, t_Say);

        PoseHuman := UserEngine.GetPlayObject(PlayObject.m_sMasterName);
        if PoseHuman <> nil then begin
          PoseHuman.m_sMasterName := '';
          PoseHuman.RefShowName;
        end else begin
          g_UnForceMasterList.Lock;
          try
            g_UnForceMasterList.Add(PlayObject.m_sMasterName);
            SaveUnForceMasterList();
          finally
            g_UnForceMasterList.UnLock;
          end;
        end;
        PlayObject.m_sMasterName := '';
        GotoLable(PlayObject, '@UnMasterEnd', False);
        PlayObject.RefShowName;
      end;
      Exit;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckCastleGold(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nGold: Integer;
begin
  Result := False;
  nGold := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nGold < 0 then ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nGold);
  if (nGold < 0) or (m_Castle = nil) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCASTLEGOLD);
    Exit;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if TUserCastle(m_Castle).m_nTotalGold = nGold then Result := True;
    '>': if TUserCastle(m_Castle).m_nTotalGold > nGold then Result := True;
    '<': if TUserCastle(m_Castle).m_nTotalGold < nGold then Result := True;
    else if TUserCastle(m_Castle).m_nTotalGold >= nGold then Result := True;
  end;
  {
  Result:=False;
  nGold:=Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nGold < 0 then begin
    ScriptConditionError(PlayObject,QuestConditionInfo,sSC_CHECKCASTLEGOLD);
    exit;
  end;
  cMethod:=QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if UserCastle.m_nTotalGold = nGold then Result:=True;
    '>': if UserCastle.m_nTotalGold > nGold then Result:=True;
    '<': if UserCastle.m_nTotalGold < nGold then Result:=True;
    else if UserCastle.m_nTotalGold >= nGold then Result:=True;
  end;
  }
end;


function TNormNpc.ConditionOfCheckContribution(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nContribution: Integer;
  cMethod: Char;
begin
  Result := False;
  nContribution := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nContribution < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nContribution) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCONTRIBUTION);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_wContribution = nContribution then Result := True;
    '>': if PlayObject.m_wContribution > nContribution then Result := True;
    '<': if PlayObject.m_wContribution < nContribution then Result := True;
    else if PlayObject.m_wContribution >= nContribution then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckCreditPoint(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCreditPoint: Integer;
  cMethod: Char;
begin
  Result := False;
  nCreditPoint := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nCreditPoint < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nCreditPoint) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKCREDITPOINT);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btCreditPoint = nCreditPoint then Result := True;
    '>': if PlayObject.m_btCreditPoint > nCreditPoint then Result := True;
    '<': if PlayObject.m_btCreditPoint < nCreditPoint then Result := True;
    else if PlayObject.m_btCreditPoint >= nCreditPoint then Result := True;
  end;
end;

procedure TNormNpc.ActionOfClearNeedItems(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  nNeed: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  nNeed := Str_ToInt(QuestActionInfo.sParam1, -1);
  if (nNeed < 0) then begin
    if not ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, nNeed) then begin //���ӱ���֧��
      ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CLEARNEEDITEMS);
      Exit;
    end;
  end;
  for i := PlayObject.m_ItemList.Count - 1 downto 0 do begin
    if PlayObject.m_ItemList.Count <= 0 then break;
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem = nil then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and (StdItem.Need = nNeed) then begin
      PlayObject.SendDelItems(UserItem);
      DisPose(UserItem);
      PlayObject.m_ItemList.Delete(i);
    end;
  end;

  for i := PlayObject.m_StorageItemList.Count - 1 downto 0 do begin
    if PlayObject.m_StorageItemList.Count <= 0 then break;
    UserItem := PlayObject.m_StorageItemList.Items[i];
    if UserItem = nil then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if (StdItem <> nil) and (StdItem.Need = nNeed) then begin
      DisPose(UserItem);
      PlayObject.m_StorageItemList.Delete(i);
    end;
  end;
end;

procedure TNormNpc.ActionOfClearMakeItems(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  nMakeIndex: Integer;
  sItemName: string;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  boMatchName: Boolean;
begin
  sItemName := QuestActionInfo.sParam1;
  nMakeIndex := QuestActionInfo.nParam2;
  boMatchName := QuestActionInfo.sParam3 = '1';
  if (sItemName = '') or (nMakeIndex <= 0) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CLEARMAKEITEMS);
    Exit;
  end;
  for i := PlayObject.m_ItemList.Count - 1 downto 0 do begin
    if PlayObject.m_ItemList.Count <= 0 then break;
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem = nil then Continue;
    if UserItem.MakeIndex <> nMakeIndex then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if not boMatchName or ((StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0)) then begin
      PlayObject.SendDelItems(UserItem);
      DisPose(UserItem);
      PlayObject.m_ItemList.Delete(i);
    end;
  end;

  for i := PlayObject.m_StorageItemList.Count - 1 downto 0 do begin
    if PlayObject.m_StorageItemList.Count <= 0 then break;
    UserItem := PlayObject.m_ItemList.Items[i];
    if UserItem = nil then Continue;
    if UserItem.MakeIndex <> nMakeIndex then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if not boMatchName or ((StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0)) then begin
      DisPose(UserItem);
      PlayObject.m_StorageItemList.Delete(i);
    end;
  end;

  for i := Low(PlayObject.m_UseItems) to High(PlayObject.m_UseItems) do begin
    UserItem := @PlayObject.m_UseItems[i];
    if UserItem.MakeIndex <> nMakeIndex then Continue;
    StdItem := UserEngine.GetStdItem(UserItem.wIndex);
    if not boMatchName or ((StdItem <> nil) and (CompareText(StdItem.Name, sItemName) = 0)) then begin
      UserItem.wIndex := 0;
    end;
  end;
end;

procedure TNormNpc.SendCustemMsg(PlayObject: TPlayObject; sMsg: string);
begin
  if not g_Config.boSendCustemMsg then begin
    PlayObject.SysMsg(g_sSendCustMsgCanNotUseNowMsg, c_Red, t_Hint);
    Exit;
  end;
  if PlayObject.m_boSendMsgFlag then begin
    PlayObject.m_boSendMsgFlag := False;
    UserEngine.SendBroadCastMsg(PlayObject.m_sCharName + ': ' + sMsg, t_Cust);
  end else begin

  end;
end;

function TNormNpc.ConditionOfCheckOfGuild(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  sGuildName: string;
begin
  Result := False;
  if QuestConditionInfo.sParam1 = '' then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKOFGUILD);
    Exit;
  end;
  if (PlayObject.m_MyGuild <> nil) then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, sGuildName) then begin //���ӱ���֧��
      sGuildName := QuestConditionInfo.sParam1;
    end;
    if CompareText(TGUild(PlayObject.m_MyGuild).sGuildName, sGuildName) = 0 then begin
      Result := True;
    end;
  end;
end;

function TNormNpc.ConditionOfCheckOnlineLongMin(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  cMethod: Char;
  nOnlineMin: Integer;
  nOnlineTime: Integer;
begin
  Result := False;
  nOnlineMin := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nOnlineMin < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nOnlineMin) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_ONLINELONGMIN);
      Exit;
    end;
  end;
  nOnlineTime := (GetTickCount - PlayObject.m_dwLogonTick) div 60000;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if nOnlineTime = nOnlineMin then Result := True;
    '>': if nOnlineTime > nOnlineMin then Result := True;
    '<': if nOnlineTime < nOnlineMin then Result := True;
    else if nOnlineTime >= nOnlineMin then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckPasswordErrorCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nErrorCount: Integer;
  cMethod: Char;
begin
  Result := False;
  nErrorCount := Str_ToInt(QuestConditionInfo.sParam2, -1);
  if nErrorCount < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam2, nErrorCount) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_PASSWORDERRORCOUNT);
      Exit;
    end;
  end;
  cMethod := QuestConditionInfo.sParam1[1];
  case cMethod of
    '=': if PlayObject.m_btPwdFailCount = nErrorCount then Result := True;
    '>': if PlayObject.m_btPwdFailCount > nErrorCount then Result := True;
    '<': if PlayObject.m_btPwdFailCount < nErrorCount then Result := True;
    else if PlayObject.m_btPwdFailCount >= nErrorCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfIsLockPassword(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := PlayObject.m_boPasswordLocked;
end;

function TNormNpc.ConditionOfIsLockStorage(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
begin
  Result := not PlayObject.m_boCanGetBackItem;
end;

function TNormNpc.ConditionOfCheckPayMent(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nPayMent: Integer;
begin
  Result := False;
  nPayMent := Str_ToInt(QuestConditionInfo.sParam1, -1);
  if nPayMent < 1 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, nPayMent) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKPAYMENT);
      Exit;
    end;
  end;
  if PlayObject.m_nPayMent = nPayMent then Result := True;
end;

function TNormNpc.ConditionOfCheckSlaveName(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  sSlaveName: string;
  BaseObject: TBaseObject;
begin
  Result := False;
  if QuestConditionInfo.sParam1 = '' then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKSLAVENAME);
    Exit;
  end;
  if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, sSlaveName) then begin //���ӱ���֧��
    sSlaveName := QuestConditionInfo.sParam1;
  end;
  for i := 0 to PlayObject.m_SlaveList.Count - 1 do begin
    BaseObject := TBaseObject(PlayObject.m_SlaveList.Items[i]);
    if CompareText(sSlaveName, BaseObject.m_sCharName) = 0 then begin
      Result := True;
      break;
    end;
  end;
end;

procedure TNormNpc.ActionOfUpgradeItems(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nRate, nWhere, nValType, nPoint, nAddPoint: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
begin
  nWhere := Str_ToInt(QuestActionInfo.sParam1, -1);
  nRate := Str_ToInt(QuestActionInfo.sParam2, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam3, -1);
  if nWhere < 0 then ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, nWhere); //���ӱ���֧��
  if nRate < 0 then ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nRate); //���ӱ���֧��
  if nPoint < 0 then ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam3, nPoint); //���ӱ���֧��
  if (nWhere < 0) or (nWhere > High(THumanUseItems)) or (nRate < 0) or (nPoint < 0) or (nPoint > 255) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_UPGRADEITEMS);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (UserItem.wIndex <= 0) or (StdItem = nil) then begin
    PlayObject.SysMsg('������û�д�ָ����Ʒ������', c_Red, t_Hint);
    Exit;
  end;
  nRate := Random(nRate);
  nPoint := Random(nPoint);
  nValType := Random(14);
  if nRate <> 0 then begin
    PlayObject.SysMsg('װ������ʧ�ܣ�����', c_Red, t_Hint);
    Exit;
  end;
  if nValType = 14 then begin
    nAddPoint := (nPoint * 1000);
    if UserItem.DuraMax + nAddPoint > High(Word) then begin
      nAddPoint := High(Word) - UserItem.DuraMax;
    end;
    UserItem.DuraMax := UserItem.DuraMax + nAddPoint;
  end else begin
    nAddPoint := nPoint;
    if UserItem.btValue[nValType] + nAddPoint > High(Byte) then begin
      nAddPoint := High(Byte) - UserItem.btValue[nValType];
    end;
    UserItem.btValue[nValType] := UserItem.btValue[nValType] + nAddPoint;
  end;
  PlayObject.SendUpdateItem(UserItem);
  PlayObject.SysMsg('װ�������ɹ�', c_Green, t_Hint);
  PlayObject.SysMsg(StdItem.Name + ': ' +
    IntToStr(UserItem.Dura) + '/' +
    IntToStr(UserItem.DuraMax) + '/' +
    IntToStr(UserItem.btValue[0]) + '/' +
    IntToStr(UserItem.btValue[1]) + '/' +
    IntToStr(UserItem.btValue[2]) + '/' +

    IntToStr(UserItem.btValue[3]) + '/' +
    IntToStr(UserItem.btValue[4]) + '/' +
    IntToStr(UserItem.btValue[5]) + '/' +
    IntToStr(UserItem.btValue[6]) + '/' +
    IntToStr(UserItem.btValue[7]) + '/' +
    IntToStr(UserItem.btValue[8]) + '/' +
    IntToStr(UserItem.btValue[9]) + '/' +
    IntToStr(UserItem.btValue[10]) + '/' +
    IntToStr(UserItem.btValue[11]) + '/' +
    IntToStr(UserItem.btValue[12]) + '/' +
    IntToStr(UserItem.btValue[13])
    , c_Blue, t_Hint);
end;

procedure TNormNpc.ActionOfUpgradeItemsEx(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  nRate, nWhere, nValType, nPoint, nAddPoint: Integer;
  UserItem: pTUserItem;
  StdItem: pTStdItem;
  nUpgradeItemStatus: Integer;
  nRatePoint: Integer;
begin
  nWhere := Str_ToInt(QuestActionInfo.sParam1, -1);
  nValType := Str_ToInt(QuestActionInfo.sParam2, -1);
  nRate := Str_ToInt(QuestActionInfo.sParam3, -1);
  nPoint := Str_ToInt(QuestActionInfo.sParam4, -1);
  if nWhere < 0 then ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam1, nWhere); //���ӱ���֧��
  if nValType < 0 then ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam2, nValType); //���ӱ���֧��
  if nRate < 0 then ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam3, nRate); //���ӱ���֧��
  if nPoint < 0 then ConditionOfGetValValue(PlayObject, QuestActionInfo.sParam4, nPoint); //���ӱ���֧��
  nUpgradeItemStatus := Str_ToInt(QuestActionInfo.sParam5, -1);
  if (nValType < 0) or (nValType > 14) or (nWhere < 0) or (nWhere > High(THumanUseItems)) or (nRate < 0) or (nPoint < 0) or (nPoint > 255) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_UPGRADEITEMSEX);
    Exit;
  end;
  UserItem := @PlayObject.m_UseItems[nWhere];
  StdItem := UserEngine.GetStdItem(UserItem.wIndex);
  if (UserItem.wIndex <= 0) or (StdItem = nil) then begin
    PlayObject.SysMsg('������û�д�ָ����Ʒ������', c_Red, t_Hint);
    Exit;
  end;
  nRatePoint := Random(nRate * 10);
  nPoint := _MAX(1, Random(nPoint));

  if not (nRatePoint in [0..10]) then begin
    case nUpgradeItemStatus of //
      0: begin
          PlayObject.SysMsg('װ������δ�ɹ�������', c_Red, t_Hint);
        end;
      1: begin
          PlayObject.SendDelItems(UserItem);
          UserItem.wIndex := 0;
          PlayObject.SysMsg('װ�����飡����', c_Red, t_Hint);
        end;
      2: begin
          PlayObject.SysMsg('װ������ʧ�ܣ�װ�����Իָ�Ĭ�ϣ�����', c_Red, t_Hint);
          if nValType <> 14 then
            UserItem.btValue[nValType] := 0;
        end;
    end;
    Exit;
  end;
  if nValType = 14 then begin
    nAddPoint := (nPoint * 1000);
    if UserItem.DuraMax + nAddPoint > High(Word) then begin
      nAddPoint := High(Word) - UserItem.DuraMax;
    end;
    UserItem.DuraMax := UserItem.DuraMax + nAddPoint;
  end else begin
    nAddPoint := nPoint;
    if UserItem.btValue[nValType] + nAddPoint > High(Byte) then begin
      nAddPoint := High(Byte) - UserItem.btValue[nValType];
    end;
    UserItem.btValue[nValType] := UserItem.btValue[nValType] + nAddPoint;
  end;
  PlayObject.SendUpdateItem(UserItem);
  PlayObject.SysMsg('װ�������ɹ�', c_Green, t_Hint);
  PlayObject.SysMsg(StdItem.Name + ': ' +
    IntToStr(UserItem.Dura) + '/' +
    IntToStr(UserItem.DuraMax) + '-' +
    IntToStr(UserItem.btValue[0]) + '/' +
    IntToStr(UserItem.btValue[1]) + '/' +
    IntToStr(UserItem.btValue[2]) + '/' +
    IntToStr(UserItem.btValue[3]) + '/' +
    IntToStr(UserItem.btValue[4]) + '/' +
    IntToStr(UserItem.btValue[5]) + '/' +
    IntToStr(UserItem.btValue[6]) + '/' +
    IntToStr(UserItem.btValue[7]) + '/' +
    IntToStr(UserItem.btValue[8]) + '/' +
    IntToStr(UserItem.btValue[9]) + '/' +
    IntToStr(UserItem.btValue[10]) + '/' +
    IntToStr(UserItem.btValue[11]) + '/' +
    IntToStr(UserItem.btValue[12]) + '/' +
    IntToStr(UserItem.btValue[13])
    , c_Blue, t_Hint);
end;
//��������
//VAR ��������(Integer String) ����(HUMAN GUILD GLOBAL) ����ֵ

procedure TNormNpc.ActionOfVar(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  VarType: TVarType;
  sVarName: string;
  sVarValue: string;
  nVarValue: Integer;
  sName: string;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
resourcestring
  sVarFound = '����%s�Ѵ��ڣ���������:%s';
  sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
begin
  sType := QuestActionInfo.sParam2;
  sVarName := QuestActionInfo.sParam3;
  sVarValue := QuestActionInfo.sParam4;
  nVarValue := Str_ToInt(QuestActionInfo.sParam4, 0);
  VarType := vNone;
  if CompareText(QuestActionInfo.sParam1, 'Integer') = 0 then VarType := vInteger;
  if CompareText(QuestActionInfo.sParam1, 'String') = 0 then VarType := vString;

  if (sType = '') or (sVarName = '') or (VarType = vNone) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_VAR);
    Exit;
  end;
  New(DynamicVar);
  DynamicVar.sName := sVarName;
  DynamicVar.VarType := VarType;
  DynamicVar.nInternet := nVarValue;
  DynamicVar.sString := sVarValue;
  boFoundVar := False;
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then begin
    DisPose(DynamicVar);
    ScriptActionError(PlayObject, format(sVarTypeError, [sType]), QuestActionInfo, sSC_VAR);
    Exit;
  end;
  for i := 0 to DynamicVarList.Count - 1 do begin
    if CompareText(pTDynamicVar(DynamicVarList.Items[i]).sName, sVarName) = 0 then begin
      boFoundVar := True;
      break;
    end;
  end;
  if not boFoundVar then begin
    DynamicVarList.Add(DynamicVar);
  end else begin
    ScriptActionError(PlayObject, format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_VAR);
  end;
end;
//��ȡ����ֵ
//LOADVAR �������� ������ �ļ���

procedure TNormNpc.ActionOfLoadVar(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  sVarName: string;
  sFileName: string;
  sName: string;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
  IniFile: TIniFile;
resourcestring
  sVarFound = '����%s�����ڣ���������:%s';
  sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
begin
  sType := QuestActionInfo.sParam1;
  sVarName := QuestActionInfo.sParam2;
  sFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam3;
  if (sType = '') or (sVarName = '') or not FileExists(sFileName) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_LOADVAR);
    Exit;
  end;
  boFoundVar := False;
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then begin
    DisPose(DynamicVar);
    ScriptActionError(PlayObject, format(sVarTypeError, [sType]), QuestActionInfo, sSC_VAR);
    Exit;
  end else begin
    IniFile := TIniFile.Create(sFileName);
    for i := 0 to DynamicVarList.Count - 1 do begin
      DynamicVar := DynamicVarList.Items[i];
      if DynamicVar <> nil then begin
        if CompareText(DynamicVar.sName, sVarName) = 0 then begin
          case DynamicVar.VarType of
            vInteger: DynamicVar.nInternet := IniFile.ReadInteger(sName, DynamicVar.sName, 0);
            vString: DynamicVar.sString := IniFile.ReadString(sName, DynamicVar.sName, '');
          end;
          boFoundVar := True;
          break;
        end;
      end;
    end;
    if not boFoundVar then
      ScriptActionError(PlayObject, format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_LOADVAR);
    IniFile.Free;
  end;
end;

//�������ֵ
//SAVEVAR �������� ������ �ļ���

procedure TNormNpc.ActionOfSaveVar(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  sVarName: string;
  sFileName: string;
  sName: string;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
  IniFile: TIniFile;
resourcestring
  sVarFound = '����%s�����ڣ���������:%s';
  sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
begin
  sType := QuestActionInfo.sParam1;
  sVarName := QuestActionInfo.sParam2;
  sFileName := g_Config.sEnvirDir + m_sPath + QuestActionInfo.sParam3;
  if (sType = '') or (sVarName = '') or not FileExists(sFileName) then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_SAVEVAR);
    Exit;
  end;
  boFoundVar := False;
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then begin
    DisPose(DynamicVar);
    ScriptActionError(PlayObject, format(sVarTypeError, [sType]), QuestActionInfo, sSC_VAR);
    Exit;
  end else begin
    IniFile := TIniFile.Create(sFileName);
    for i := 0 to DynamicVarList.Count - 1 do begin
      DynamicVar := DynamicVarList.Items[i];
      if DynamicVar <> nil then begin
        if CompareText(DynamicVar.sName, sVarName) = 0 then begin
          case DynamicVar.VarType of
            vInteger: IniFile.WriteInteger(sName, DynamicVar.sName, DynamicVar.nInternet);
            vString: IniFile.WriteString(sName, DynamicVar.sName, DynamicVar.sString);
          end;
          boFoundVar := True;
          break;
        end;
      end;
    end;
    if not boFoundVar then
      ScriptActionError(PlayObject, format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_SAVEVAR);
    IniFile.Free;
  end;
end;
//�Ա�����������(+��-��*��/)

procedure TNormNpc.ActionOfCalcVar(PlayObject: TPlayObject;
  QuestActionInfo: pTQuestActionInfo);
var
  i: Integer;
  sType: string;
  sVarName: string;
  sName: string;
  sVarValue: string;
  sVarValue2: string;
  nVarValue: Integer;
  nVarValue2: Integer;
  sMethod: string;
  cMethod: Char;
  DynamicVar: pTDynamicVar;
  boFoundVar: Boolean;
  DynamicVarList: TList;
  sString: string;
resourcestring
  sVarFound = '����%s�����ڣ���������:%s';
  sVarTypeError = '�������ʹ��󣬴�������:%s ��ǰ֧������(HUMAN��GUILD��GLOBAL)';
begin
  sType := QuestActionInfo.sParam1;
  sVarName := QuestActionInfo.sParam2;
  sMethod := QuestActionInfo.sParam3;
  sVarValue := QuestActionInfo.sParam4;
  sVarValue2 := QuestActionInfo.sParam5;
  if (sType = '') or (sVarName = '') or (sMethod = '') then begin
    ScriptActionError(PlayObject, '', QuestActionInfo, sSC_CALCVAR);
    Exit;
  end;
  boFoundVar := False;
  if (sVarValue <> '') and (sVarValue2 <> '') and (not IsStringNumber(sVarValue)) and (not IsStringNumber(sVarValue2)) then begin
    DynamicVarList := GetDynamicVarList(PlayObject, sVarValue, sName);
    if DynamicVarList = nil then begin
      DisPose(DynamicVar);
      ScriptActionError(PlayObject, format(sVarTypeError, [sVarValue]), QuestActionInfo, sSC_CALCVAR);
      Exit;
    end;
    for i := 0 to DynamicVarList.Count - 1 do begin
      DynamicVar := DynamicVarList.Items[i];
      if CompareText(DynamicVar.sName, sVarValue2) = 0 then begin
        case DynamicVar.VarType of
          vInteger: begin
              nVarValue := DynamicVar.nInternet;
            end;
          vString: begin

            end;
        end;
        boFoundVar := True;
        break;
      end;
    end;
    if not boFoundVar then begin
      ScriptActionError(PlayObject, format(sVarFound, [sVarValue2, sVarValue]), QuestActionInfo, sSC_CALCVAR);
      Exit;
    end;
  end else nVarValue := Str_ToInt(QuestActionInfo.sParam4, 0);

  boFoundVar := False;
  cMethod := sMethod[1];
  DynamicVarList := GetDynamicVarList(PlayObject, sType, sName);
  if DynamicVarList = nil then begin
    DisPose(DynamicVar);
    ScriptActionError(PlayObject, format(sVarTypeError, [sType]), QuestActionInfo, sSC_CALCVAR);
    Exit;
  end else begin
    for i := 0 to DynamicVarList.Count - 1 do begin
      DynamicVar := DynamicVarList.Items[i];
      if DynamicVar <> nil then begin
        if CompareText(DynamicVar.sName, sVarName) = 0 then begin
          case DynamicVar.VarType of
            vInteger: begin
                case cMethod of
                  '=': DynamicVar.nInternet := nVarValue;
                  '+': DynamicVar.nInternet := DynamicVar.nInternet + nVarValue;
                  '-': DynamicVar.nInternet := DynamicVar.nInternet - nVarValue;
                  '*': DynamicVar.nInternet := DynamicVar.nInternet * nVarValue;
                  '/': DynamicVar.nInternet := DynamicVar.nInternet div nVarValue;
                end;
              end;
            vString: begin

              end;
          end;
          boFoundVar := True;
          break;
        end;
      end;
    end;
    if not boFoundVar then
      ScriptActionError(PlayObject, format(sVarFound, [sVarName, sType]), QuestActionInfo, sSC_CALCVAR);
  end;
end;

procedure TNormNpc.Initialize;
begin
  inherited;
  m_Castle := g_CastleManager.InCastleWarArea(Self);
end;

function TNormNpc.ConditionOfCheckNameDateList(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  i: Integer;
  LoadList: TStringList;
  sListFileName, sLineText, sHumName, sDate: string;
  boDeleteExprie, boNoCompareHumanName: Boolean;
  dOldDate: TDateTime;
  cMethod: Char;
  nValNo, nValNoDay, nDayCount, nDay: Integer;
begin
  Result := False;
  nDayCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  nValNo := GetValNameNo(QuestConditionInfo.sParam4);
  nValNoDay := GetValNameNo(QuestConditionInfo.sParam5);
  boDeleteExprie := CompareText(QuestConditionInfo.sParam6, '����') = 0;
  boNoCompareHumanName := CompareText(QuestConditionInfo.sParam6, '1') = 0;
  cMethod := QuestConditionInfo.sParam2[1];
  if nDayCount < 0 then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKNAMEDATELIST);
    Exit;
  end;
  sListFileName := g_Config.sEnvirDir + m_sPath + QuestConditionInfo.sParam1;
  if FileExists(sListFileName) then begin
    LoadList := TStringList.Create;
    try
      LoadList.LoadFromFile(sListFileName);
    except
      MainOutMessage('loading fail.... => ' + sListFileName);
    end;
    for i := 0 to LoadList.Count - 1 do begin
      sLineText := Trim(LoadList.Strings[i]);
      sLineText := GetValidStr3(sLineText, sHumName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sDate, [' ', #9]);
      if (CompareText(sHumName, PlayObject.m_sCharName) = 0) or boNoCompareHumanName then begin
        nDay := High(Integer);
        if TryStrToDateTime(sDate, dOldDate) then
          nDay := GetDayCount(Now, dOldDate);
        case cMethod of
          '=': if nDay = nDayCount then Result := True;
          '>': if nDay > nDayCount then Result := True;
          '<': if nDay < nDayCount then Result := True;
          else if nDay >= nDayCount then Result := True;
        end;
        if nValNo >= 0 then begin
          case nValNo of
            0..9: begin
                PlayObject.m_nVal[nValNo] := nDay;
              end;
            100..199: begin
                g_Config.GlobalVal[nValNo - 100] := nDay;
              end;
            200..209: begin
                PlayObject.m_DyVal[nValNo - 200] := nDay;
              end;
            300..399: begin
                PlayObject.m_nMval[nValNo - 300] := nDay;
              end;
            400..499: begin
                g_Config.GlobaDyMval[nValNo - 400] := nDay;
              end;
            500..599: begin
                PlayObject.m_nInteger[nValNo - 500] := nDay;
              end;
          end;
        end;

        if nValNoDay >= 0 then begin
          case nValNoDay of
            0..9: begin
                PlayObject.m_nVal[nValNoDay] := nDayCount - nDay;
              end;
            100..199: begin
                g_Config.GlobalVal[nValNoDay - 100] := nDayCount - nDay;
              end;
            200..209: begin
                PlayObject.m_DyVal[nValNoDay - 200] := nDayCount - nDay;
              end;
            300..399: begin
                PlayObject.m_nMval[nValNoDay - 300] := nDayCount - nDay;
              end;
            400..499: begin
                g_Config.GlobaDyMval[nValNo - 400] := nDayCount - nDay;
              end;
            500..599: begin
                PlayObject.m_nInteger[nValNo - 500] := nDayCount - nDay;
              end;
          end;
        end;
        if not Result then begin
          if boDeleteExprie then begin
            LoadList.Delete(i);
            try
              LoadList.SaveToFile(sListFileName);
            except
              MainOutMessage('Save fail.... => ' + sListFileName);
            end;
          end;
        end;
        break;
      end;
    end;
    LoadList.Free;
  end else begin
    MainOutMessage('file not found => ' + sListFileName);
  end;
end;
//CHECKMAPHUMANCOUNT MAP = COUNT

function TNormNpc.ConditionOfCheckMapHumanCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount, nHumanCount: Integer;
  cMethod: Char;
  sMapName: string;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  if nCount < 0 then begin
    if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam3, nCount) then begin //���ӱ���֧��
      ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMAPHUMANCOUNT);
      Exit;
    end;
  end;
  if not ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam1, sMapName) then begin //���ӱ���֧��
    sMapName := QuestConditionInfo.sParam1;
  end;
  nHumanCount := UserEngine.GetMapHuman(sMapName);
  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if nHumanCount = nCount then Result := True;
    '>': if nHumanCount > nCount then Result := True;
    '<': if nHumanCount < nCount then Result := True;
    else if nHumanCount >= nCount then Result := True;
  end;
end;

function TNormNpc.ConditionOfCheckMapMonCount(PlayObject: TPlayObject;
  QuestConditionInfo: pTQuestConditionInfo): Boolean;
var
  nCount, nMonCount: Integer;
  cMethod: Char;
  Envir: TEnvirnoment;
begin
  Result := False;
  nCount := Str_ToInt(QuestConditionInfo.sParam3, -1);
  Envir := g_MapManager.FindMap(QuestConditionInfo.sParam1);
  if nCount < 0 then ConditionOfGetValValue(PlayObject, QuestConditionInfo.sParam3, nCount);
  if (nCount < 0) or (Envir = nil) then begin
    ScriptConditionError(PlayObject, QuestConditionInfo, sSC_CHECKMAPMONCOUNT);
    Exit;
  end;
  nMonCount := UserEngine.GetMapMonster(Envir, nil);
  cMethod := QuestConditionInfo.sParam2[1];
  case cMethod of
    '=': if nMonCount = nCount then Result := True;
    '>': if nMonCount > nCount then Result := True;
    '<': if nMonCount < nCount then Result := True;
    else if nMonCount >= nCount then Result := True;
  end;
end;

function TNormNpc.GetDynamicVarList(PlayObject: TPlayObject;
  sType: string; var sName: string): TList;
begin
  Result := nil;
  if CompareLStr(sType, 'HUMAN', Length('HUMAN')) then begin
    Result := PlayObject.m_DynamicVarList;
    sName := PlayObject.m_sCharName;
  end else
    if CompareLStr(sType, 'GUILD', Length('GUILD')) then begin
    if PlayObject.m_MyGuild = nil then Exit;
    Result := TGUild(PlayObject.m_MyGuild).m_DynamicVarList;
    sName := TGUild(PlayObject.m_MyGuild).sGuildName;
  end else
    if CompareLStr(sType, 'GLOBAL', Length('GLOBAL')) then begin
    Result := g_DynamicVarList;
    sName := 'GLOBAL';
  end;
end;

{ TGuildOfficial }

procedure TGuildOfficial.Click(PlayObject: TPlayObject); //004A30F4
begin
  //  GotoLable(PlayObject,'@main');
  inherited;
end;

procedure TGuildOfficial.GetVariableText(PlayObject: TPlayObject;
  var sMsg: string; sVariable: string);
var
  i, ii: Integer;
  sText: string;
  List: TStringList;
  sStr: string;
begin
  inherited;
  if sVariable = '$REQUESTCASTLELIST' then begin
    sText := '';
    List := TStringList.Create;
    g_CastleManager.GetCastleNameList(List);
    for i := 0 to List.Count - 1 do begin
      ii := i + 1;
      if ((ii div 2) * 2 = ii) then sStr := '\'
      else sStr := '';
      sText := sText + format('<%s/@requestcastlewarnow%d> %s', [List.Strings[i], i, sStr]);
    end;
    sText := sText + '\ \';
    List.Free;
    sMsg := sub_49ADB8(sMsg, '<$REQUESTCASTLELIST>', sText);
  end;
end;

procedure TGuildOfficial.Run; //004A37F0
begin
  if Random(40) = 0 then begin
    TurnTo(Random(8));
  end else begin
    if Random(30) = 0 then
      SendRefMsg(RM_HIT, m_btDirection, m_nCurrX, m_nCurrY, 0, '');
  end;
  inherited;
end;

procedure TGuildOfficial.UserSelect(PlayObject: TPlayObject; sData: string);
var
  sMsg, sLabel: string;
  boCanJmp: Boolean;
resourcestring
  sExceptionMsg = '[Exception] TGuildOfficial::UserSelect... ';
begin
  inherited;
  try
    //    PlayObject.m_nScriptGotoCount:=0;
    if (sData <> '') and (sData[1] = '@') then begin
      sMsg := GetValidStr3(sData, sLabel, [#13]);

      boCanJmp := PlayObject.LableIsCanJmp(sLabel);

      GotoLable(PlayObject, sLabel, not boCanJmp);

      //GotoLable(PlayObject,sLabel,not PlayObject.LableIsCanJmp(sLabel));
      if not boCanJmp then Exit;
      if CompareText(sLabel, sBUILDGUILDNOW) = 0 then begin
        ReQuestBuildGuild(PlayObject, sMsg);
      end else
        if CompareText(sLabel, sSCL_GUILDWAR) = 0 then begin
        ReQuestGuildWar(PlayObject, sMsg);
      end else
        if CompareText(sLabel, sDONATE) = 0 then begin
        DoNate(PlayObject);
      end else
        {
        if CompareText(sLabel,sREQUESTCASTLEWAR) = 0 then begin
          ReQuestCastleWar(PlayObject,sMsg);
        end else
        }
        if CompareLStr(sLabel, sREQUESTCASTLEWAR, Length(sREQUESTCASTLEWAR)) then begin
        ReQuestCastleWar(PlayObject, Copy(sLabel, Length(sREQUESTCASTLEWAR) + 1, Length(sLabel) - Length(sREQUESTCASTLEWAR)));
      end else
        if CompareText(sLabel, sEXIT) = 0 then begin
        PlayObject.SendMsg(Self, RM_MERCHANTDLGCLOSE, 0, Integer(Self), 0, 0, '');
      end else
        if CompareText(sLabel, sBACK) = 0 then begin
        if PlayObject.m_sScriptGoBackLable = '' then PlayObject.m_sScriptGoBackLable := sMAIN;
        GotoLable(PlayObject, PlayObject.m_sScriptGoBackLable, False);
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
  //  inherited;
end;

function TGuildOfficial.ReQuestBuildGuild(PlayObject: TPlayObject; sGuildName: string): Integer; //004A3124
var
  UserItem: pTUserItem;
  sKey: string;
begin
  Result := 0;
  sGuildName := Trim(sGuildName);
  UserItem := nil;
  if sGuildName = '' then begin
    Result := -4;
  end;
  if PlayObject.m_MyGuild = nil then begin
    if PlayObject.m_nGold >= g_Config.nBuildGuildPrice then begin
      UserItem := PlayObject.CheckItems(g_Config.sWomaHorn);
      if UserItem = nil then begin
        Result := -3; //'��û��׼������Ҫ��ȫ����Ʒ��'
      end;
    end else Result := -2; //'ȱ�ٴ������á�'
  end else Result := -1; //'���Ѿ����������лᡣ'
  if Result = 0 then begin
    if g_GuildManager.AddGuild(sGuildName, PlayObject.m_sCharName) then begin
      UserEngine.SendServerGroupMsg(SS_205, nServerIndex, sGuildName + '/' + PlayObject.m_sCharName);
      PlayObject.SendDelItems(UserItem);
      PlayObject.DelBagItem(UserItem.MakeIndex, g_Config.sWomaHorn);
      PlayObject.DecGold(g_Config.nBuildGuildPrice);
      PlayObject.GoldChanged();
      PlayObject.m_MyGuild := g_GuildManager.MemberOfGuild(PlayObject.m_sCharName);
      if PlayObject.m_MyGuild <> nil then begin
        PlayObject.m_sGuildRankName := TGUild(PlayObject.m_MyGuild).GetRankName(PlayObject, PlayObject.m_nGuildRankNo);
        RefShowName();
      end;
    end else Result := -4;
  end;
  if Result >= 0 then begin
    PlayObject.SendMsg(Self, RM_BUILDGUILD_OK, 0, 0, 0, 0, '');
  end else begin
    PlayObject.SendMsg(Self, RM_BUILDGUILD_FAIL, 0, Result, 0, 0, '');
  end;
end;

function TGuildOfficial.ReQuestGuildWar(PlayObject: TPlayObject; sGuildName: string): Integer; //004A3368
begin
  if g_GuildManager.FindGuild(sGuildName) <> nil then begin
    if PlayObject.m_nGold >= g_Config.nGuildWarPrice then begin
      PlayObject.DecGold(g_Config.nGuildWarPrice);
      PlayObject.GoldChanged();
      PlayObject.ReQuestGuildWar(sGuildName);
    end else begin
      PlayObject.SysMsg('��û���㹻�Ľ�ң�����', c_Red, t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�л� ' + sGuildName + ' �����ڣ�����', c_Red, t_Hint);
  end;
  Result := 1;
end;

procedure TGuildOfficial.DoNate(PlayObject: TPlayObject); //004A346C
begin
  PlayObject.SendMsg(Self, RM_DONATE_OK, 0, 0, 0, 0, '');
end;

procedure TGuildOfficial.ReQuestCastleWar(PlayObject: TPlayObject; sIndex: string); //004A3498
var
  UserItem: pTUserItem;
  Castle: TUserCastle;
  nIndex: Integer;
begin
  //  if PlayObject.IsGuildMaster and
  //     (not UserCastle.IsMasterGuild(TGuild(PlayObject.m_MyGuild))) then begin
  nIndex := Str_ToInt(sIndex, -1);
  if nIndex < 0 then nIndex := 0;

  Castle := g_CastleManager.GetCastle(nIndex);
  if PlayObject.IsGuildMaster and
    not Castle.IsMember(PlayObject) then begin

    UserItem := PlayObject.CheckItems(g_Config.sZumaPiece);
    if UserItem <> nil then begin
      if Castle.AddAttackerInfo(TGUild(PlayObject.m_MyGuild)) then begin
        PlayObject.SendDelItems(UserItem);
        PlayObject.DelBagItem(UserItem.MakeIndex, g_Config.sZumaPiece);
        GotoLable(PlayObject, '~@request_ok', False);
      end else begin
        PlayObject.SysMsg('�������޷����󹥳ǣ�����', c_Red, t_Hint);
      end;
      (*{$IFEND}*)

    end else begin
      PlayObject.SysMsg('��û��' + g_Config.sZumaPiece + '������', c_Red, t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�������ȡ��������', c_Red, t_Hint);
  end;
end;

procedure TCastleOfficial.RepairDoor(PlayObject: TPlayObject); //004A3FB8
begin
  if m_Castle = nil then begin
    PlayObject.SysMsg('NPC�����ڳǱ�������', c_Red, t_Hint);
    Exit;
  end;
  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nRepairDoorPrice then begin
    if TUserCastle(m_Castle).RepairDoor then begin
      Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nRepairDoorPrice);
      PlayObject.SysMsg('����ɹ���', c_Green, t_Hint);
    end else begin
      PlayObject.SysMsg('���Ų���Ҫ��������', c_Green, t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�����ʽ��㣡����', c_Red, t_Hint);
  end;
  {
  if UserCastle.m_nTotalGold >= g_Config.nRepairDoorPrice then begin
    if UserCastle.RepairDoor then begin
      Dec(UserCastle.m_nTotalGold,g_Config.nRepairDoorPrice);
      PlayObject.SysMsg('����ɹ���',c_Green,t_Hint);
    end else begin
      PlayObject.SysMsg('���Ų���Ҫ��������',c_Green,t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�����ʽ��㣡����',c_Red,t_Hint);
  end;
  }
end;

procedure TCastleOfficial.RepairWallNow(nWallIndex: Integer;
  PlayObject: TPlayObject); //004A4074
begin
  if m_Castle = nil then begin
    PlayObject.SysMsg('NPC�����ڳǱ�������', c_Red, t_Hint);
    Exit;
  end;

  if TUserCastle(m_Castle).m_nTotalGold >= g_Config.nRepairWallPrice then begin
    if TUserCastle(m_Castle).RepairWall(nWallIndex) then begin
      Dec(TUserCastle(m_Castle).m_nTotalGold, g_Config.nRepairWallPrice);
      PlayObject.SysMsg('����ɹ���', c_Green, t_Hint);
    end else begin
      PlayObject.SysMsg('���Ų���Ҫ��������', c_Green, t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�����ʽ��㣡����', c_Red, t_Hint);
  end;
  {
  if UserCastle.m_nTotalGold >= g_Config.nRepairWallPrice then begin
    if UserCastle.RepairWall(nWallIndex) then begin
      Dec(UserCastle.m_nTotalGold,g_Config.nRepairWallPrice);
      PlayObject.SysMsg('����ɹ���',c_Green,t_Hint);
    end else begin
      PlayObject.SysMsg('���Ų���Ҫ��������',c_Green,t_Hint);
    end;
  end else begin
    PlayObject.SysMsg('�����ʽ��㣡����',c_Red,t_Hint);
  end;
  }
end;

constructor TCastleOfficial.Create;
begin
  inherited;

end;

destructor TCastleOfficial.Destroy;
begin

  inherited;
end;

constructor TGuildOfficial.Create;
begin
  inherited;
  m_btRaceImg := RCC_MERCHANT;
  m_wAppr := 8;
end;

destructor TGuildOfficial.Destroy;
begin

  inherited;
end;

procedure TGuildOfficial.SendCustemMsg(PlayObject: TPlayObject;
  sMsg: string);
begin
  inherited;

end;

procedure TCastleOfficial.SendCustemMsg(PlayObject: TPlayObject;
  sMsg: string);
begin
  if not g_Config.boSubkMasterSendMsg then begin
    PlayObject.SysMsg(g_sSubkMasterMsgCanNotUseNowMsg, c_Red, t_Hint);
    Exit;
  end;
  if PlayObject.m_boSendMsgFlag then begin
    PlayObject.m_boSendMsgFlag := False;
    UserEngine.SendBroadCastMsg(PlayObject.m_sCharName + ': ' + sMsg, t_Castle);
  end else begin

  end;
end;

end.

