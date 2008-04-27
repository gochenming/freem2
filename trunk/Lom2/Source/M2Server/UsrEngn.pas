unit UsrEngn;

interface
uses
  svn, Windows, Classes, SysUtils, StrUtils, Forms, ObjBase, MudUtil, ObjNpc, Envir,
  ItmUnit, Grobal2, SDK;

type
  TUserEngine = class
    m_LoadPlaySection         :TRTLCriticalSection;
    m_LoadPlayList            :TStringList;       //��DB��ȡ��������
    m_PlayObjectList          :TStringList;       //0x8
    m_PlayObjectFreeList      :TList;      //0x10
    m_ChangeHumanDBGoldList   :TList;      //0x14
    dwShowOnlineTick          :LongWord; //0x18
    dwSendOnlineHumTime       :LongWord; //0x1C
    dwProcessMapDoorTick      :LongWord; //0x20
    dwProcessEffectsTick      :LongWord;
    dwProcessMissionsTime     :LongWord; //0x24
    dwRegenMonstersTick       :LongWord; //0x28
    dwProcessUsrLogTick       :LongWord;
    CalceTime                 :LongWord; //0x2C
    m_dwProcessLoadPlayTick   :LongWord; //0x30
    dwTime_34                 :LongWord; //0x34
    m_nCurrMonGen             :Integer;  //0x38
    m_nMonGenListPosition     :Integer; //0x3C
    m_nMonGenCertListPosition :Integer;  //0x40
    m_nProcHumIDx             :Integer;   //0x44 �������￪ʼ������ÿ�δ������������ƣ�
    nProcessHumanLoopTime     :Integer;
    nMerchantPosition         :Integer; //0x4C
    nNpcPosition              :Integer; //0x50
    StdItemList               :TList;     //List_54
    MonsterList               :TList;     //List_58
    m_MonGenList              :TList;     //List_5C
    m_MonFreeList             :TList;
    m_MagicList               :TList;     //List_60
    m_AdminList               :TGList;     //List_64
    m_MerchantList            :TGList;     //List_68
    QuestNPCList              :TList;     //0x6C
    List_70                   :TList;
    m_ChangeServerList        :TList;
    m_MagicEventList          :TList;    //0x78
    nMonsterCount             :Integer; //��������
    nMonsterProcessPostion    :Integer; //0x80�����������λ�ã����ڼ����������
    n84                       :Integer;
    nMonsterProcessCount      :Integer; //0x88���������������ͳ�ƴ���������
    boItemEvent               :Boolean;  //ItemEvent
    n90                       :Integer;
    dwProcessMonstersTick     :LongWord;
    dwProcessMerchantTimeMin  :Integer;
    dwProcessMerchantTimeMax  :Integer;
    dwProcessNpcTimeMin       :LongWord;
    dwProcessNpcTimeMax       :LongWord;
    m_NewHumanList            :TList;
    m_ListOfGateIdx           :TList;
    m_ListOfSocket            :TList;
    OldMagicList              :TList;
    EffectList                :TList;
  private
    procedure ProcessHumans();
    procedure ProcessMonsters();
    procedure ProcessMerchants();
    procedure ProcessNpcs();
    procedure ProcessMissions();
    procedure ProcessEvents();
    procedure ProcessMapDoor();
    procedure ProcessEffects(); //lava/thunder on map
    procedure SaveUsrLog();
    procedure NPCinitialize;
    procedure MerchantInitialize;
    procedure GTMerchant(Merchant:TMerchant);

    procedure EffectTarget(x,y:Integer;Envir:TEnvirnoment);//lava/thunder hitting this coord
    function  FindNearbyTarget(x,y:Integer;Envir:TEnvirnoment):TBaseObject;
    function  RegenMonsters(MonGen:pTMonGenInfo;nCount:integer): Boolean;
    procedure WriteShiftUserData;
    function  GetGenMonCount(MonGen:pTMonGenInfo):Integer;
    function  AddBaseObject(sMapName:String;nX,nY:Integer;nMonRace:Integer;sMonName:String):TBaseObject;
    function  AddBaseObjectEX(Map:TEnvirnoment;nX,nY:Integer;nMonRace:Integer;sMonName:String):TBaseObject;
    procedure GenShiftUserData();
    procedure KickOnlineUser(sChrName:String);
    function  SendSwitchData(PlayObject:TPlayObject;nServerIndex:Integer):Boolean;
    procedure SendChangeServer(PlayObject:TPlayObject;nServerIndex:Integer);
    procedure SaveHumanRcd(PlayObject:TPlayObject);
    procedure AddToHumanFreeList(PlayObject:TPlayObject);

    procedure GetHumData(PlayObject:TPlayObject;var HumanRcd:THumData);
    function  GetHomeInfo(nJob:Integer; var nX:Integer;var nY:Integer):String;
    function  GetRandHomeX(PlayObject:TPlayObject):Integer;
    function  GetRandHomeY(PlayObject:TPlayObject):Integer;
    function  GetSwitchData(sChrName:String;nCode:Integer):pTSwitchDataInfo;
    procedure LoadSwitchData(SwitchData:pTSwitchDataInfo;var PlayObject:TPlayObject);
    procedure DelSwitchData(SwitchData:pTSwitchDataInfo);
    procedure MonInitialize(BaseObject:TBaseObject;sMonName:String);
    function  MapRageHuman(sMapName:String;nMapX,nMapY,nRage:Integer):Boolean;
    function  GetOnlineHumCount():Integer;
    function  GetUserCount(): Integer;
    function  GetLoadPlayCount():Integer;

  public
    constructor Create();
    destructor Destroy; override;
    procedure Initialize();
    procedure ClearItemList();virtual;
    procedure SwitchMagicList();

    procedure Run();
    procedure PrcocessData();
    function  MonGetRandomItems(mon: TBaseObject): integer;
    function  RegenMonsterByName(sMap:String;nX,nY:Integer;sMonName:String):TBaseObject;overload;
    function  RegenMonsterByName(pEnvir:TEnvirnoment;nX,nY:Integer;sMonName:String):TBaseObject;overload;
    function  GetStdItem(nItemIdx:Integer):TItem;overload;
    function  GetStdItem(sItemName:String):TItem;overload;
    function  GetStdItemWeight(nItemIdx:Integer):Integer;
    function  GetStdItemName(nItemIdx:Integer):String;
    function  GetStdItemIdx(sItemName:String):Integer;
    function  FindOtherServerUser(sName:String;var nServerIndex):Boolean;
    procedure CryCry(wIdent:Word;pMap:TEnvirnoment;nX,nY,nWide:Integer;btFColor,btBColor:Byte;sMsg:String);
    procedure ProcessUserMessage(PlayObject:TPlayObject;DefMsg:pTDefaultMessage;Buff:PChar);
    procedure SendServerGroupMsg(nCode,nServerIdx:Integer;sMsg:String);
    function  GetMonRace(sMonName: String): Integer;
    function  GetPlayObject(sName:String):TPlayObject;
    function  GetPlayObjectEx(sName:String):TPlayObject;
    procedure KickPlayObjectEx(sName:String);
    function  FindMerchant(Merchant:TObject):TMerchant;
    function  FindNPC(GuildOfficial:TObject):TGuildOfficial;
    function  CopyToUserItemFromName(sItemName: String;Item:pTUserItem): Boolean;
    function  GetMapOfRangeHumanCount(Envir:TEnvirnoment;nX,nY,nRange:integer):Integer;
    function  GetHumPermission(sUserName:String;var sIPaddr:String; var btPermission:Byte):Boolean;
    procedure AddUserOpenInfo(UserOpenInfo:pTUserOpenInfo);
    function  OpenDoor(Envir:TEnvirnoment;nX,nY:Integer):Boolean;
    function  CloseDoor(Envir: TEnvirnoment; Door:pTDoorInfo):Boolean;
    procedure SendDoorStatus(Envir: TEnvirnoment; nX, nY: Integer; wIdent, wX: Word; nDoorX, nDoorY, nA: Integer;sStr:String);
    function  FindMagic(sMagicName:String):pTMagic;OverLoad;
    function  FindMagic(nMagIdx:Integer):pTMagic;OverLoad;
    procedure AddMerchant(Merchant:TMerchant);
    function  GetMerchantList(Envir:TEnvirnoment;nX,nY,nRange:Integer;TmpList:TList):Integer;
    function  GetNpcList(Envir:TEnvirnoment;nX,nY,nRange:Integer;TmpList:TList):Integer;
    procedure ReloadMerchantList();
    procedure ReloadNpcList();
    procedure HumanExpire(sAccount:String);
    function  GetMapMonster(Envir:TEnvirnoment;List:TList):Integer;
    function  GetMapRangeMonster(Envir:TEnvirnoment;nX,nY,nRange:Integer;List:TList):Integer;
    function  GetMapHuman(sMapName:String):Integer;
    function  GetMapRageHuman(Envir:TEnvirnoment;nRageX,nRageY,nRage:Integer;List:TList):Integer;
    procedure SendBroadCastMsg(sMsg:String;MsgType:TMsgType);
    procedure SendBroadCastMsgExt(sMsg:String;MsgType:TMsgType);
    procedure sub_4AE514(GoldChangeInfo: pTGoldChangeInfo);
    procedure ClearMonSayMsg();
    procedure SendQuestMsg(sQuestName:String);
    procedure ClearMerchantData();
    property  MonsterCount:Integer read nMonsterCount;
    property  OnlinePlayObject:Integer read GetOnlineHumCount;
    property  PlayObjectCount:Integer read GetUserCount;
    property  LoadPlayCount:Integer read GetLoadPlayCount;
  end;
var
  g_dwEngineTick:LongWord;
  g_dwEngineRunTime:LongWord;

implementation

uses
  HUtil32, IdSrvClient, Guild, ObjMon, M2Share, EDcode, ObjGuard, ObjAxeMon,
  ObjMon2, ObjMon3, Event, InterMsgClient, InterServerMsg, ObjRobot, Castle,
  svMain;

{ TUserEngine }

constructor TUserEngine.Create();
begin
  InitializeCriticalSection(m_LoadPlaySection);
  m_LoadPlayList            := TStringList.Create;
  m_PlayObjectList          := TStringList.Create;
  m_PlayObjectFreeList      := TList.Create;
  m_ChangeHumanDBGoldList   := TList.Create;
  dwShowOnlineTick          := GetTickCount;
  dwSendOnlineHumTime       := GetTickCount;
  dwProcessMapDoorTick      := GetTickCount;
  dwProcessEffectsTick      := GetTickCount;
  dwProcessMissionsTime     := GetTickCount;
  dwProcessMonstersTick     := GetTickCount;
  dwProcessUsrLogTick       := GetTickCount;
  dwRegenMonstersTick       := GetTickCount;
  m_dwProcessLoadPlayTick   := GetTickCount;
  dwTime_34                 := GetTickCount;
  m_nCurrMonGen             := 0;
  m_nMonGenListPosition     := 0;
  m_nMonGenCertListPosition := 0;
  m_nProcHumIDx             := 0;
  nProcessHumanLoopTime     := 0;
  nMerchantPosition         := 0;
  nNpcPosition              := 0;
  StdItemList               := TList.Create;     //List_54
  MonsterList               := TList.Create;
  m_MonGenList              := TList.Create;
  m_MonFreeList             := TList.Create;
  m_MagicList               := TList.Create;
  m_AdminList               := TGList.Create;
  m_MerchantList            := TGList.Create;
  QuestNPCList              := TList.Create;
  List_70                   := TList.Create;
  m_ChangeServerList        := TList.Create;
  m_MagicEventList          := TList.Create;
  boItemEvent               := False;
  n90                       := 1800000;
  dwProcessMerchantTimeMin  := 0;
  dwProcessMerchantTimeMax  := 0;
  dwProcessNpcTimeMin       := 0;
  dwProcessNpcTimeMax       := 0;
  m_NewHumanList            := TList.Create;
  m_ListOfGateIdx           := TList.Create;
  m_ListOfSocket            := TList.Create;
  OldMagicList              := TList.Create;
  Effectlist                := TList.Create;
end;

destructor TUserEngine.Destroy;
var
  I          :Integer;
  II         :Integer;
  MonInfo    :pTMonInfo;
  MonGenInfo :pTMonGenInfo;
  MagicEvent :pTMagicEvent;
  tmpList    :TList;
begin
  for I := 0 to m_LoadPlayList.Count - 1 do begin
    Dispose(pTUserOpenInfo(m_LoadPlayList.Objects[I]));
  end;
  m_LoadPlayList.Free;
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    TPlayObject(m_PlayObjectList.Objects[I]).Free;
  end;
  m_PlayObjectList.Free;

  for I := 0 to m_PlayObjectFreeList.Count - 1 do begin
    TPlayObject(m_PlayObjectFreeList.Items[I]).Free;
  end;
  m_PlayObjectFreeList.Free;

  for I := 0 to m_ChangeHumanDBGoldList.Count - 1 do begin
    Dispose(pTGoldChangeInfo(m_ChangeHumanDBGoldList.Items[I]));
  end;
  m_ChangeHumanDBGoldList.Free;

  for I := 0 to StdItemList.Count - 1 do begin
    Dispose(pTStdItem(StdItemList.Items[i]));
  end;
  StdItemList.Free;

  for I := 0 to MonsterList.Count - 1 do begin
    MonInfo:=MonsterList.Items[I];
    if MonInfo.ItemList <> nil then begin
      for II := 0 to MonInfo.ItemList.Count - 1 do begin
        Dispose(pTMonItem(MonInfo.ItemList.Items[II]));
      end;
      MonInfo.ItemList.Free;
    end;
    Dispose(MonInfo);
  end;
  MonsterList.Free;
  
  for I := 0 to m_MonGenList.Count - 1 do begin
    MonGenInfo:=m_MonGenList.Items[I];
    for II := 0 to MonGenInfo.CertList.Count - 1 do begin
      TBaseObject(MonGenInfo.CertList.Items[II]).Free;
    end;
    Dispose(pTMonGenInfo(m_MonGenList.Items[I]));
  end;
  m_MonGenList.Free;
  
  for I := 0 to m_MonFreeList.Count - 1 do begin
    TBaseObject(m_MonFreeList.Items[I]).Free;
  end;
  m_MonFreeList.Free;

  for I := 0 to m_MagicList.Count - 1 do begin
    Dispose(pTMagic(m_MagicList.Items[i]));
  end;
  m_MagicList.Free;
  m_AdminList.Free;
  for I := 0 to m_MerchantList.Count - 1 do begin
    TMerchant(m_MerchantList.Items[i]).Free;
  end;
  m_MerchantList.Free;
  for I := 0 to QuestNPCList.Count - 1 do begin
    TNormNpc(QuestNPCList.Items[i]).Free;
  end;
  QuestNPCList.Free;
  List_70.Free;
  for I := 0 to m_ChangeServerList.Count - 1 do begin
    Dispose(pTSwitchDataInfo(m_ChangeServerList.Items[i]));
  end;
  m_ChangeServerList.Free;
  for I := 0 to m_MagicEventList.Count - 1 do begin
    MagicEvent:=m_MagicEventList.Items[I];
    if MagicEvent.BaseObjectList <> nil then MagicEvent.BaseObjectList.Free;

    Dispose(MagicEvent);
  end;
  m_MagicEventList.Free;
  m_NewHumanList.Free;
  m_ListOfGateIdx.Free;
  m_ListOfSocket.Free;
  for I := 0 to OldMagicList.Count - 1 do begin
    tmpList:=TList(OldMagicList.Items[I]);
    for II := 0 to tmpList.Count - 1 do begin
      Dispose(pTMagic(tmpList.Items[II]));
    end;
    tmpList.Free;
  end;   
  OldMagicList.Free;
  DeleteCriticalSection(m_LoadPlaySection);
  inherited;
end;

procedure TUserEngine.Initialize; //004B200C
var
  i:Integer;
  MonGen:pTMonGenInfo;
begin
  MerchantInitialize();
  NPCinitialize();
  for i:=0 to m_MonGenList.Count -1 do begin
    MonGen:=m_MonGenList.Items[i];
    if MonGen <> nil then begin
      MonGen.nRace:= GetMonRace(MonGen.sMonName);
    end;
  end;
end;

function TUserEngine.GetMonRace(sMonName:String):Integer;//004ACDD8
var
  i:integer;
  MonInfo:pTMonInfo;
begin
  Result:= -1;
    for i:=0 to MonsterList.Count -1 do begin
      MonInfo:=MonsterList.Items[i];
      if CompareText(MonInfo.sName,sMonName) = 0 then begin
        Result:=MonInfo.btRace;
        break;
      end;
    end;
end;
procedure TUserEngine.MerchantInitialize; //004AC96C
var
  I: Integer;
  Merchant:TMerchant;
  sCaption:String;
begin
  sCaption:=FrmMain.Caption;
  m_MerchantList.Lock;
  try
    for I := m_MerchantList.Count - 1 downto 0 do begin
      Merchant:=TMerchant(m_MerchantList.Items[i]);
      Merchant.m_PEnvir:=g_MapManager.FindMap(Merchant.m_sMapName);
      if Merchant.m_PEnvir <> nil then begin
        if Merchant.m_PEnvir.Flag.nGuildTerritory > 0 then
          GTMerchant(Merchant);
        Merchant.Initialize;
        if Merchant.m_boAddtoMapSuccess and (not Merchant.m_boIsHide) then begin
          MainOutMessage('���˳�ʼ��ʧ��...' + Merchant.m_sCharName + ' ' + Merchant.m_sMapName + '(' + IntToStr(Merchant.m_nCurrX) + ':' + IntToStr(Merchant.m_nCurrY) + ')');
          m_MerchantList.Delete(i);
          Merchant.Free;
        end else begin
          Merchant.LoadNPCScript();
          Merchant.LoadNPCData();
        end;
      end else begin
        MainOutMessage(Merchant.m_sCharName + ' - ���˳�ʼ��ʧ��... (m.PEnvir=nil)');
        m_MerchantList.Delete(i);
        Merchant.Free;
      end;
      FrmMain.Caption:=sCaption + '[���ڳ�ʼ��NPC(' + IntToStr(m_MerchantList.Count-I) + '/' + IntToStr(m_MerchantList.Count) + ')]';
      // Do Not UnComment!
//      Application.ProcessMessages;
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;
procedure TUserEngine.NPCinitialize; //004ACC24
var
  I: Integer;
  NormNpc:TNormNpc;
begin
  for I := QuestNPCList.Count - 1 downto 0 do begin
    NormNpc:=TNormNpc(QuestNPCList.Items[i]);
    NormNpc.m_PEnvir:=g_MapManager.FindMap(NormNpc.m_sMapName);
    if NormNpc.m_PEnvir <> nil then begin
      NormNpc.Initialize;//FFFE
      if NormNpc.m_boAddtoMapSuccess and (not NormNpc.m_boIsHide) then begin
        MainOutMessage(NormNpc.m_sCharName + ' Npc��ʼ��ʧ��... ');
        QuestNPCList.Delete(i);
        NormNpc.Free;
      end else begin
        NormNpc.LoadNPCScript();
      end;
    end else begin
      MainOutMessage(NormNpc.m_sCharName + ' Npc��ʼ��ʧ��... (npc.PEnvir=nil) ');
      QuestNPCList.Delete(i);
      NormNpc.Free;
    end;
      
  end;
end;

procedure TUserEngine.GTMerchant(Merchant:TMerchant); //004AC96C
var
  i:integer;
  Merchant2:TMerchant;
  Envir:TEnvirnoment;
begin
  for i:=0 to g_MapManager.Count -1 do begin
    Envir:=TEnvirnoment(g_MapManager.Items[I]);
    if (Envir.sMapName = Merchant.m_PEnvir.sMapName) and (Envir.Flag.nGuildTerritory <> Merchant.m_PEnvir.Flag.nGuildTerritory) then begin
      Merchant2:=TMerchant.Create;
      Merchant2.m_sScript      := Merchant.m_sScript;
      Merchant2.m_sMapName     := Merchant.m_sMapName;
      Merchant2.m_nCurrX       := Merchant.m_nCurrX;
      Merchant2.m_nCurrY       := Merchant.m_nCurrY;
      Merchant2.m_sCharName    := Merchant.m_sCharName;
      Merchant2.m_nFlag        := Merchant.m_nFlag;
      Merchant2.m_wAppr        := Merchant.m_wAppr;
      Merchant2.m_boCastle     := Merchant.m_boCastle;
      Merchant2.m_boCanMove    := Merchant.m_boCanMove;
      Merchant2.m_dwMoveTime   := Merchant.m_dwMoveTime;
      Merchant2.m_PEnvir       := Envir;
      Merchant2.Initialize;
      if Merchant2.m_boAddtoMapSuccess and (not Merchant2.m_boIsHide) then begin
        MainOutMessage('GT Merchant Initalize fail...' + Merchant2.m_sCharName + ' ' + Merchant2.m_sMapName + '(' + IntToStr(Merchant2.m_nCurrX) + ':' + IntToStr(Merchant2.m_nCurrY) + ')');
        Merchant2.Free;
      end else begin
        UserEngine.m_MerchantList.Lock;
        try
          UserEngine.m_MerchantList.Add(Merchant2);
        finally
          UserEngine.m_MerchantList.UnLock;
        end;
        Merchant2.LoadNPCScript();
        Merchant2.LoadNPCData();
      end;
    end;
  end;
end;

function TUserEngine.GetLoadPlayCount: Integer;//004AE7F0
begin
  Result:= m_LoadPlayList.Count;
end;

function TUserEngine.GetOnlineHumCount: Integer;//004AE7F0
begin
  Result:= m_PlayObjectList.Count;
end;

function TUserEngine.GetUserCount: Integer; //004AE7C0
begin
  Result:= m_PlayObjectList.Count;
end;

procedure TUserEngine.ProcessHumans;
  function IsLogined(sChrName:String):Boolean;//004AFC68
  var
    i:Integer;
  begin
    Result:=False;
    if FrontEngine.InSaveRcdList(sChrName) then begin
      Result:=True;
    end else begin
      for i:= 0 to m_PlayObjectList.Count - 1 do begin
        if CompareText(m_PlayObjectList.Strings[i], sChrName) = 0 then begin
          Result:=True;
          break;
        end;
      end;
    end;
  end;
  function MakeNewHuman(UserOpenInfo:pTUserOpenInfo):TPlayObject;  //004AFD28
  var
    PlayObject:TPlayObject;
    Abil:pTAbility;
    Envir:TEnvirnoment;
    nC:integer;
    SwitchDataInfo:pTSwitchDataInfo;
    Castle:TUserCastle;
  ResourceString
    sExceptionMsg      = '[Exception] TUserEngine::MakeNewHuman';
    sChangeServerFail1 = 'chg-server-fail-1 [%d] -> [%d] [%s]';
    sChangeServerFail2 = 'chg-server-fail-2 [%d] -> [%d] [%s]';
    sChangeServerFail3 = 'chg-server-fail-3 [%d] -> [%d] [%s]';
    sChangeServerFail4 = 'chg-server-fail-4 [%d] -> [%d] [%s]';
    sErrorEnvirIsNil   = '[Error] PlayObject.PEnvir = nil';
  label
    ReGetMap;
  begin
    Result:=nil;
    try
      PlayObject:=TPlayObject.Create;

      if not g_Config.boVentureServer then begin
        UserOpenInfo.sChrName:='';
        UserOpenInfo.LoadUser.nSessionID:=0;
        SwitchDataInfo:=GetSwitchData(UserOpenInfo.sChrName,UserOpenInfo.LoadUser.nSessionID);
      end else SwitchDataInfo:=nil;//004AFD95
      
      SwitchDataInfo:=nil;

      if SwitchDataInfo = nil then begin
        GetHumData(PlayObject,UserOpenInfo.HumanRcd);
        PlayObject.m_btRaceServer:= RC_PLAYOBJECT;
        if PlayObject.m_sHomeMap = '' then begin
          ReGetMap:
            PlayObject.m_sHomeMap:=GetHomeInfo(PlayObject.m_btJob,PlayObject.m_nHomeX,PlayObject.m_nHomeY);
            PlayObject.m_sMapName:=PlayObject.m_sHomeMap;
            PlayObject.m_nCurrX:=GetRandHomeX(PlayObject);
            PlayObject.m_nCurrY:=GetRandHomeY(PlayObject);
            if PlayObject.m_Abil.Level = 0 then begin
              Abil:=@PlayObject.m_Abil;
              Abil.Level:=1;
              Abil.AC:=0;
              Abil.MAC:=0;
              Abil.DC:=MakeLong(1,2);
              Abil.MC:=MakeLong(1,2);
              Abil.SC:=MakeLong(1,2);
              Abil.MP:=15;
              Abil.HP:=15;
              Abil.MaxHP:=15;
              Abil.MaxMP:=15;
              Abil.Exp:=0;
              Abil.MaxExp:=100;
              Abil.Weight:=0;
              Abil.MaxWeight:=30;
              PlayObject.m_boNewHuman:=True;
            end;
        end;


        Envir:=g_MapManager.GetMapInfo(nServerIndex,PlayObject.m_sMapName);
        if Envir <> nil then begin
          if Envir.Flag.boFight3Zone then begin //�Ƿ����л�ս����ͼ����
            if (PlayObject.m_Abil.HP <= 0) and (PlayObject.m_nFightZoneDieCount < 3) then begin
              PlayObject.m_Abil.HP:=PlayObject.m_Abil.MaxHP;
              PlayObject.m_Abil.MP:=PlayObject.m_Abil.MaxMP;
              PlayObject.m_boDieInFight3Zone:=True;
            end else PlayObject.m_nFightZoneDieCount:=0;
          end;
        end;

        PlayObject.m_MyGuild:=g_GuildManager.MemberOfGuild(PlayObject.m_sCharName);
        Castle:=g_CastleManager.InCastleWarArea(Envir,PlayObject.m_nCurrX,PlayObject.m_nCurrY);
        {
        if (Envir <> nil) and ((UserCastle.m_MapPalace = Envir) or
          (UserCastle.m_boUnderWar and UserCastle.InCastleWarArea(PlayObject.m_PEnvir,PlayObject.m_nCurrX,PlayObject.m_nCurrY))) then begin
        }
        if (Envir <> nil) and (Castle <> nil) and ((Castle.m_MapPalace = Envir) or Castle.m_boUnderWar) then begin
          Castle:=g_CastleManager.IsCastleMember(PlayObject);

          //if not UserCastle.IsMember(PlayObject) then begin
          if Castle = nil then begin            
            PlayObject.m_sMapName:=PlayObject.m_sHomeMap;
            PlayObject.m_nCurrX:=PlayObject.m_nHomeX - 2 + Random(5);
            PlayObject.m_nCurrY:=PlayObject.m_nHomeY - 2 + Random(5);
          end else begin
            {
            if UserCastle.m_MapPalace = Envir then begin
              PlayObject.m_sMapName:=UserCastle.GetMapName();
              PlayObject.m_nCurrX:=UserCastle.GetHomeX;
              PlayObject.m_nCurrY:=UserCastle.GetHomeY;
            end;
            }
            if Castle.m_MapPalace = Envir then begin
              PlayObject.m_sMapName:=Castle.GetMapName();
              PlayObject.m_nCurrX:=Castle.GetHomeX;
              PlayObject.m_nCurrY:=Castle.GetHomeY;
            end;
              
          end;
        end; //004B00C0

        if (PlayObject.nC4 <= 1) and (PlayObject.m_Abil.Level >= 1) then
          PlayObject.nC4:=2;
        if g_MapManager.FindMap(PlayObject.m_sMapName) = nil then
          PlayObject.m_Abil.HP:=0;
        if PlayObject.m_Abil.HP <= 0 then begin
          PlayObject.ClearStatusTime();
          if PlayObject.PKLevel < 2 then begin
            Castle:=g_CastleManager.IsCastleMember(PlayObject);
//            if UserCastle.m_boUnderWar and (UserCastle.IsMember(PlayObject)) then begin
            if (Castle <> nil) and Castle.m_boUnderWar then begin
              PlayObject.m_sMapName:=Castle.m_sHomeMap;
              PlayObject.m_nCurrX:=Castle.GetHomeX;
              PlayObject.m_nCurrY:=Castle.GetHomeY;
            end else begin
              PlayObject.m_sMapName:=PlayObject.m_sHomeMap;
              PlayObject.m_nCurrX:=PlayObject.m_nHomeX - 2 + Random(5);
              PlayObject.m_nCurrY:=PlayObject.m_nHomeY - 2 + Random(5);
            end;
          end else begin //004B0201
            PlayObject.m_sMapName:=g_Config.sRedDieHomeMap{'3'};
            PlayObject.m_nCurrX:=Random(13) + g_Config.nRedDieHomeX{839};
            PlayObject.m_nCurrY:=Random(13) + g_Config.nRedDieHomeY{668};
          end;
          PlayObject.m_Abil.HP:=14;
        end; //004B023D

        PlayObject.AbilCopyToWAbil();
        Envir:=g_MapManager.GetMapInfo(nServerIndex,PlayObject.m_sMapName);
        if Envir <> nil then begin
          if Envir.Flag.nGuildTerritory > 0 then begin
            if (PlayObject.m_MyGuild <> nil) and (g_GuildTerritory.FindGuildTerritory(TGuild(PlayObject.m_MyGuild).sGuildName) <> nil) then begin
              Envir:= g_MapManager.GetMapInfoEx(nServerIndex,g_GuildTerritory.FindGuildTerritory(TGuild(PlayObject.m_MyGuild).sGuildName).TerritoryNumber,PlayObject.m_sMapName);
            end else begin
              PlayObject.m_sMapName:=g_Config.sHomeMap;
              Envir:=g_MapManager.FindMap(g_Config.sHomeMap);
              PlayObject.m_nCurrX:=g_Config.nHomeX;
              PlayObject.m_nCurrY:=g_Config.nHomeY;
            end;
          end;
        end;
        if Envir = nil then begin
          PlayObject.m_nSessionID:=UserOpenInfo.LoadUser.nSessionID;
          PlayObject.m_nSocket:=UserOpenInfo.LoadUser.nSocket;
          PlayObject.m_nGateIdx:=UserOpenInfo.LoadUser.nGateIdx;
          PlayObject.m_nGSocketIdx:=UserOpenInfo.LoadUser.nGSocketIdx;
          PlayObject.m_WAbil:=PlayObject.m_Abil;
          PlayObject.m_nServerIndex:=g_MapManager.GetMapOfServerIndex(PlayObject.m_sMapName);
          if PlayObject.m_Abil.HP <> 14 then begin
            MainOutMessage(format(sChangeServerFail1,[nServerIndex,PlayObject.m_nServerIndex,PlayObject.m_sMapName]));
            {MainOutMessage('chg-server-fail-1 [' +
                           IntToStr(nServerIndex) +
                           '] -> [' +
                           IntToStr(PlayObject.m_nServerIndex) +
                           '] [' +
                           PlayObject.m_sMapName +
                           ']');}
          end;
          SendSwitchData(PlayObject,PlayObject.m_nServerIndex);
          SendChangeServer(PlayObject,PlayObject.m_nServerIndex);
          PlayObject.Free;
          exit;
        end;
        nC:=0;
        while (True) do begin  //004B03CC
          if Envir.CanWalk(PlayObject.m_nCurrX,PlayObject.m_nCurrY,True) then break;
          PlayObject.m_nCurrX:=PlayObject.m_nCurrX - 3 + Random(6);
          PlayObject.m_nCurrY:=PlayObject.m_nCurrY - 3 + Random(6);

          Inc(nC);
          if nC >= 5 then break;
        end;

        if not Envir.CanWalk(PlayObject.m_nCurrX,PlayObject.m_nCurrY,True) then begin
          MainOutMessage(format(sChangeServerFail2,[nServerIndex,PlayObject.m_nServerIndex,PlayObject.m_sMapName]));
          {  MainOutMessage('chg-server-fail-2 [' +
                           IntToStr(nServerIndex) +
                           '] -> [' +
                           IntToStr(PlayObject.m_nServerIndex) +
                           '] [' +
                           PlayObject.m_sMapName +
                           ']');}
          PlayObject.m_sMapName:=g_Config.sHomeMap;
          Envir:=g_MapManager.FindMap(g_Config.sHomeMap);
          PlayObject.m_nCurrX:=g_Config.nHomeX;
          PlayObject.m_nCurrY:=g_Config.nHomeY;
        end;

        PlayObject.m_PEnvir:=Envir;
        if PlayObject.m_PEnvir = nil then begin
          MainOutMessage(sErrorEnvirIsNil);
          goto ReGetMap;
        end else begin
          PlayObject.m_boReadyRun:=False;
        end;
      end else begin //004B0561
        GetHumData(PlayObject,UserOpenInfo.HumanRcd);
        PlayObject.m_sMapName:=SwitchDataInfo.sMap;
        PlayObject.m_nCurrX:=SwitchDataInfo.wX;
        PlayObject.m_nCurrY:=SwitchDataInfo.wY;
        PlayObject.m_Abil:=SwitchDataInfo.Abil;
        PlayObject.m_WAbil:=SwitchDataInfo.Abil;
        LoadSwitchData(SwitchDataInfo,PlayObject);
        DelSwitchData(SwitchDataInfo);
        Envir:=g_MapManager.GetMapInfo(nServerIndex,PlayObject.m_sMapName);
        if Envir <> nil then begin
          MainOutMessage(format(sChangeServerFail3,[nServerIndex,PlayObject.m_nServerIndex,PlayObject.m_sMapName]));
            {MainOutMessage('chg-server-fail-3 [' +
                           IntToStr(nServerIndex) +
                           '] -> [' +
                           IntToStr(PlayObject.m_nServerIndex) +
                           '] [' +
                           PlayObject.m_sMapName +
                           ']');}
          PlayObject.m_sMapName:=g_Config.sHomeMap;
          Envir:=g_MapManager.FindMap(g_Config.sHomeMap);
          PlayObject.m_nCurrX:=g_Config.nHomeX;
          PlayObject.m_nCurrY:=g_Config.nHomeY;
        end else begin
          if not Envir.CanWalk(PlayObject.m_nCurrX,PlayObject.m_nCurrY,True) then begin
            MainOutMessage(format(sChangeServerFail4,[nServerIndex,PlayObject.m_nServerIndex,PlayObject.m_sMapName]));
            {MainOutMessage('chg-server-fail-4 [' +
                           IntToStr(nServerIndex) +
                           '] -> [' +
                           IntToStr(PlayObject.m_nServerIndex) +
                           '] [' +
                           PlayObject.m_sMapName +
                           ']');}
            PlayObject.m_sMapName:=g_Config.sHomeMap;
            Envir:=g_MapManager.FindMap(g_Config.sHomeMap);
            PlayObject.m_nCurrX:=g_Config.nHomeX;
            PlayObject.m_nCurrY:=g_Config.nHomeY;
          end;
          PlayObject.AbilCopyToWAbil();
          PlayObject.m_PEnvir:=Envir;
          if PlayObject.m_PEnvir = nil then begin
            MainOutMessage(sErrorEnvirIsNil);
            goto ReGetMap;
          end else begin
            PlayObject.m_boReadyRun:=False;
            PlayObject.m_boLoginNoticeOK:=True;
            PlayObject.bo6AB:=True;
          end;
        end;
      end;//004B085C
      PlayObject.m_sUserID:=UserOpenInfo.LoadUser.sAccount;
      PlayObject.m_sIPaddr:=UserOpenInfo.LoadUser.sIPaddr;
      PlayObject.m_sIPLocal:=GetIPLocal(PlayObject.m_sIPaddr);
      PlayObject.m_nSocket:=UserOpenInfo.LoadUser.nSocket;
      PlayObject.m_nGSocketIdx:=UserOpenInfo.LoadUser.nGSocketIdx;
      PlayObject.m_nGateIdx:=UserOpenInfo.LoadUser.nGateIdx;
      PlayObject.m_nSessionID:=UserOpenInfo.LoadUser.nSessionID;
      PlayObject.m_nPayMent:=UserOpenInfo.LoadUser.nPayMent;
      PlayObject.m_nPayMode:=UserOpenInfo.LoadUser.nPayMode;
      PlayObject.m_dwLoadTick:=UserOpenInfo.LoadUser.dwNewUserTick;
//      PlayObject.m_nSoftVersionDate:=UserOpenInfo.HumInfo.nSoftVersionDate;
      PlayObject.m_nSoftVersionDateEx:=GetExVersionNO(UserOpenInfo.LoadUser.nSoftVersionDate,PlayObject.m_nSoftVersionDate);
      Result:=PlayObject;
    except
      MainOutMessage(sExceptionMsg);
    end;
  end;
var
  dwUsrRotTime     :LongWord;
  dwCheckTime      :LongWord;  //0x10
  dwCurTick        :LongWord;
  nCheck30         :Integer; //0x30
  boCheckTimeLimit :Boolean; //0x31
  nIdx             :Integer;
  PlayObject       :TPlayObject;
  I                :Integer;
  UserOpenInfo     :pTUserOpenInfo;
  GoldChangeInfo   :pTGoldChangeInfo;
  LineNoticeMsg    :String;
ResourceString
  sExceptionMsg1 = '[Exception] TUserEngine::ProcessHumans -> Ready, Save, Load... Code:=%d';
  sExceptionMsg2 = '[Exception] TUserEngine::ProcessHumans ClosePlayer.Delete - Free';
  sExceptionMsg3 = '[Exception] TUserEngine::ProcessHumans ClosePlayer.Delete';
  sExceptionMsg4 = '[Exception] TUserEngine::ProcessHumans RunNotice';
  sExceptionMsg5 = '[Exception] TUserEngine::ProcessHumans Human.Operate Code: %d';
  sExceptionMsg6 = '[Exception] TUserEngine::ProcessHumans Human.Finalize Code: %d';
  sExceptionMsg7 = '[Exception] TUserEngine::ProcessHumans RunSocket.CloseUser Code: %d';
  sExceptionMsg8 = '[Exception] TUserEngine::ProcessHumans';
begin
  nCheck30:=0;
  dwCheckTime:=GetTickCount();
  
  if (GetTickCount - m_dwProcessLoadPlayTick) > 200 then begin
    m_dwProcessLoadPlayTick:=GetTickCount();
    try
      EnterCriticalSection(m_LoadPlaySection);
      try

        for i:=0 to m_LoadPlayList.Count -1 do begin
          if not FrontEngine.IsFull and not IsLogined(m_LoadPlayList.Strings[i]) then begin
            UserOpenInfo:=pTUserOpenInfo(m_LoadPlayList.Objects[i]);

            PlayObject:=MakeNewHuman(UserOpenInfo);


            if PlayObject <> nil then begin
              //PlayObject.m_boClientFlag:=UserOpenInfo.LoadUser.boClinetFlag; //���ͻ��˱�־��������������
              m_PlayObjectList.AddObject(m_LoadPlayList.Strings[i],PlayObject);
              SendServerGroupMsg(SS_201,nServerIndex,PlayObject.m_sCharName);
              m_NewHumanList.Add(PlayObject);
            end;

          end else begin//004B0BF9
            KickOnlineUser(m_LoadPlayList.Strings[i]);
            UserOpenInfo:=pTUserOpenInfo(m_LoadPlayList.Objects[i]);
            m_ListOfGateIdx.Add(Pointer(UserOpenInfo.LoadUser.nGateIdx)); //004B0C39
            m_ListOfSocket.Add(Pointer(UserOpenInfo.LoadUser.nSocket));
          end;
          Dispose(pTUserOpenInfo(m_LoadPlayList.Objects[I]));
        end;//004B0C96
        m_LoadPlayList.Clear;
        for I:=0 to m_ChangeHumanDBGoldList.Count -1 do begin
          GoldChangeInfo:=m_ChangeHumanDBGoldList.Items[I];
          PlayObject:=GeTPlayObject(GoldChangeInfo.sGameMasterName);
          if PlayObject <> nil then begin
            PlayObject.GoldChange(GoldChangeInfo.sGetGoldUser,GoldChangeInfo.nGold);
          end;
          Dispose(GoldChangeInfo);
        end;
        m_ChangeHumanDBGoldList.Clear;
      finally
        LeaveCriticalSection(m_LoadPlaySection);
      end;

      //004B0D4A
      for I:=0 to m_NewHumanList.Count -1 do begin
         PlayObject:=TPlayObject(m_NewHumanList.Items[I]);

        RunSocket.SetGateUserList(PlayObject.m_nGateIdx,PlayObject.m_nSocket,PlayObject);

      end;
      m_NewHumanList.Clear;
      

      for i:=0 to m_ListOfGateIdx.Count -1 do begin

        RunSocket.CloseUser(Integer(m_ListOfGateIdx.Items[i]),Integer(m_ListOfSocket.Items[i]));//GateIdx,nSocket

      end;
      m_ListOfGateIdx.Clear;
      m_ListOfSocket.Clear;
    except
      on e: Exception do begin
        MainOutMessage(format(sExceptionMsg1,[0]));
        MainOutMessage(E.Message);
      end;
    end;
  end;//004B0E1E
  

  try
    for I := 0 to m_PlayObjectFreeList.Count - 1 do begin
      PlayObject:=TPlayObject(m_PlayObjectFreeList.Items[i]);
      if (GetTickCount - PlayObject.m_dwGhostTick) > g_Config.dwHumanFreeDelayTime {5 * 60 * 1000} then begin
        try
          TPlayObject(m_PlayObjectFreeList.Items[i]).Free;
        except
          MainOutMessage(sExceptionMsg2);
        end;
        
        m_PlayObjectFreeList.Delete(i);
        break;
      end else begin
        if PlayObject.m_boSwitchData and (PlayObject.m_boRcdSaved) then begin
          if SendSwitchData(PlayObject,PlayObject.m_nServerIndex) or (PlayObject.m_nWriteChgDataErrCount > 20) then begin
            PlayObject.m_boSwitchData:=False;
            PlayObject.m_boSwitchDataSended:=True;
            PlayObject.m_dwChgDataWritedTick:=GetTickCount();
          end else Inc(PlayObject.m_nWriteChgDataErrCount);
        end;
        if PlayObject.m_boSwitchDataSended and ((GetTickCount - PlayObject.m_dwChgDataWritedTick) > 100) then begin
          PlayObject.m_boSwitchDataSended:=False;
          SendChangeServer(PlayObject,PlayObject.m_nServerIndex);
        end;
      end;
    end;
  except
    MainOutMessage(sExceptionMsg3);
  end;//004B0F91


  boCheckTimeLimit:=False;//004B0F91
  try
    dwCurTick:=GetTickCount();
    nIdx:=m_nProcHumIDx;
     while True do begin
       if m_PlayObjectList.Count <= nIdx then break;
       PlayObject:=TPlayObject(m_PlayObjectList.Objects[nIdx]);
       if Integer(dwCurTick - PlayObject.m_dwRunTick) > PlayObject.m_nRunTime then begin
         PlayObject.m_dwRunTick:=dwCurTick;
         if not PlayObject.m_boGhost then begin
           if not PlayObject.m_boLoginNoticeOK then begin
{$IF CATEXCEPTION = TRYEXCEPTION}
             try
{$IFEND}
               PlayObject.RunNotice();
{$IF CATEXCEPTION = TRYEXCEPTION}
             except
               MainOutMessage(sExceptionMsg4);
             end;
{$IFEND}             
           end else begin//004B1058
             try
               if not PlayObject.m_boReadyRun then begin
                 PlayObject.m_boReadyRun:=True;//004B1075
                 PlayObject.UserLogon; //BaseObject.0FFFEh;
               end else begin
                 if (GetTickCount() - PlayObject.m_dwSearchTick) > PlayObject.m_dwSearchTime then begin
                   PlayObject.m_dwSearchTick:=GetTickCount();
                   PlayObject.SearchViewRange;
                   PlayObject.GameTimeChanged;
                 end;//004B10C4

                 if (GetTickCount() - PlayObject.m_dwShowLineNoticeTick) > g_Config.dwShowLineNoticeTime then begin
                   PlayObject.m_dwShowLineNoticeTick:=GetTickCount();
                   if LineNoticeList.Count > PlayObject.m_nShowLineNoticeIdx then begin

                     LineNoticeMsg:=g_ManageNPC.GetLineVariableText(PlayObject,LineNoticeList.Strings[PlayObject.m_nShowLineNoticeIdx]);

                     //PlayObject.SysMsg(g_Config.sLineNoticePreFix + ' '+ LineNoticeList.Strings[PlayObject.m_nShowLineNoticeIdx],g_nLineNoticeColor);

                     case LineNoticeMsg[1] of  
                       'R': PlayObject.SysMsg(Copy(LineNoticeMsg,2,length(LineNoticeMsg) - 1),c_Red,t_Notice);
                       'G': PlayObject.SysMsg(Copy(LineNoticeMsg,2,length(LineNoticeMsg) - 1),c_Green,t_Notice);
                       'B': PlayObject.SysMsg(Copy(LineNoticeMsg,2,length(LineNoticeMsg) - 1),c_Blue,t_Notice);
                       else begin
                         PlayObject.SysMsg(LineNoticeMsg,TMsgColor(g_Config.nLineNoticeColor){c_Blue},t_Notice);
                       end;
                     end;
                   end;
                   Inc(PlayObject.m_nShowLineNoticeIdx);
                   if (LineNoticeList.Count <= PlayObject.m_nShowLineNoticeIdx) then
                     PlayObject.m_nShowLineNoticeIdx:=0;
                 end;

                 PlayObject.Run();

                 if not FrontEngine.IsFull and((GetTickCount() - PlayObject.m_dwSaveRcdTick) > g_Config.dwSaveHumanRcdTime) then begin
                   PlayObject.m_dwSaveRcdTick:=GetTickCount();

                   PlayObject.DealCancelA();

                   SaveHumanRcd(PlayObject);

                 end;
               end;//004B119F
             except
               on e: Exception do begin
                 MainOutMessage(format(sExceptionMsg5,[0]));
                 MainOutMessage(E.Message);
               end;
             end;
           end;
         end else begin//if not PlayObject.boIsGhost then begin  //CODE:004B11C5
           try
             m_PlayObjectList.Delete(nIdx);
             nCheck30:=2;

             PlayObject.Disappear();

             nCheck30:=3;
           except
             on e: Exception do begin
               MainOutMessage(format(sExceptionMsg6,[nCheck30]));
               MainOutMessage(E.Message);
             end;
           end;//004B1232
           try

             AddToHumanFreeList(PlayObject);

             nCheck30:=4;
             PlayObject.DealCancelA();

             SaveHumanRcd(PlayObject);

             RunSocket.CloseUser(PlayObject.m_nGateIdx,PlayObject.m_nSocket);

           except
             MainOutMessage(format(sExceptionMsg7,[nCheck30]));
           end;//004B12BA

           SendServerGroupMsg(SS_202,nServerIndex,PlayObject.m_sCharName);
           Continue;
         end;
       end;//if (dwTime14 - PlayObject.dw368) > PlayObject.dw36C then begin
       Inc(nIdx);//004B12E6
       if (GetTickCount - dwCheckTime) > g_dwHumLimit then begin
         boCheckTimeLimit:=True;
         m_nProcHumIDx:=nIdx;
         break;
       end;
     end;//while True do begin
     if not boCheckTimeLimit then m_nProcHumIDx:=0;
  except
    MainOutMessage(sExceptionMsg8);
  end;
  Inc(nProcessHumanLoopTime);
  g_nProcessHumanLoopTime:=nProcessHumanLoopTime;
  if m_nProcHumIDx = 0 then begin
    nProcessHumanLoopTime:=0;
    g_nProcessHumanLoopTime:=nProcessHumanLoopTime;
    dwUsrRotTime:=GetTickCount - g_dwUsrRotCountTick;
    dwUsrRotCountMin:=dwUsrRotTime;
    g_dwUsrRotCountTick:=GetTickCount();
    if dwUsrRotCountMax < dwUsrRotTime then dwUsrRotCountMax:=dwUsrRotTime;
  end;
  g_nHumCountMin:=GetTickCount - dwCheckTime;
  if g_nHumCountMax < g_nHumCountMin then g_nHumCountMax:=g_nHumCountMin;
end;

procedure TUserEngine.ProcessMerchants;//004B1B8C
var
  dwRunTick,dwCurrTick:LongWord;
  i:integer;
  MerchantNPC:TMerchant;
  boProcessLimit:Boolean;
ResourceString
  sExceptionMsg = '[Exception] TUserEngine::ProcessMerchants';
begin
  dwRunTick:=GetTickCount();
  boProcessLimit:=False;
  try
    dwCurrTick:=GetTickCount();
    m_MerchantList.Lock;
    try
      for i:=nMerchantPosition to m_MerchantList.Count -1 do begin
        MerchantNPC:=m_MerchantList.Items[i];
        if not MerchantNPC.m_boGhost then begin
          if Integer(dwCurrTick - MerchantNPC.m_dwRunTick) > MerchantNPC.m_nRunTime then begin
            if (GetTickCount - MerchantNPC.m_dwSearchTick) > MerchantNPC.m_dwSearchTime then begin
              MerchantNPC.m_dwSearchTick:=GetTickCount();
              MerchantNPC.SearchViewRange();
            end;//004B1C3C
            if Integer(dwCurrTick - MerchantNPC.m_dwRunTick) > MerchantNPC.m_nRunTime then begin
              MerchantNPC.m_dwRunTick:=dwCurrTick;
              MerchantNPC.Run;  {FFFFB}
            end;
          end;//004B1C6B
        end else begin//004B1C6B
          if (GetTickCount - MerchantNPC.m_dwGhostTick) > 60 * 1000 then begin
            MerchantNPC.Free;
            m_MerchantList.Delete(i);
            break;
          end;
        end;
        if (GetTickCount - dwRunTick) > g_dwNpcLimit then begin
          nMerchantPosition:=i;
          boProcessLimit:=True;
          Break;
        end;//004B1C8C
      end;//004B1C98
    finally
      m_MerchantList.UnLock;
    end;
    if not boProcessLimit then begin
      nMerchantPosition:=0;
    end;//004B1CA6
  except
    MainOutMessage(sExceptionMsg);
  end;
  dwProcessMerchantTimeMin:=GetTickCount - dwRunTick;
  if dwProcessMerchantTimeMin > dwProcessMerchantTimeMax then dwProcessMerchantTimeMax:=dwProcessMerchantTimeMin;
  if dwProcessNpcTimeMin > dwProcessNpcTimeMax then dwProcessNpcTimeMax:=dwProcessNpcTimeMin;
end;

procedure TUserEngine.ProcessMissions;
begin

end;

procedure TUserEngine.ProcessMonsters;
  function GetZenTime(dwTime:LongWord):LongWord;
  var
    r:Real;
  begin
    if dwTime < 30 * 60 * 1000 then begin
      r := (GetUserCount - g_Config.nUserFull) / g_Config.nZenFastStep;
      if r > 0 then begin
        if r > 6 then r := 6;
        Result:= dwTime - Round((dwTime / 10) * r)
      end else
        Result:=dwTime;
    end else
      Result:=dwTime;
  end;
//004B1638
var
  dwCurrentTick    :LongWord;
  dwRunTick        :LongWord;
  dwMonProcTick    :LongWord;
  MonGen           :pTMonGenInfo;
  nGenCount        :Integer;
  nGenModCount     :Integer;
  boProcessLimit   :Boolean;
  boRegened        :Boolean;
  I                :Integer;
  nProcessPosition :Integer;
  Monster          :TAnimalObject;
  tCode            :Integer;
ResourceString
  sExceptionMsg = '[Exception] TUserEngine::ProcessMonsters %d';
begin
  tCode     := 0;
  dwRunTick := GetTickCount();
  try
    tCode          := 0;
    boProcessLimit := False;
    dwCurrentTick  := GetTickCount();
    MonGen         := nil;
    //ˢ�¹��￪ʼ

    if ((GetTickCount - dwRegenMonstersTick) > g_Config.dwRegenMonstersTime) then begin
      dwRegenMonstersTick:=GetTickCount();
      if m_nCurrMonGen < m_MonGenList.Count then begin
        MonGen:=m_MonGenList.Items[m_nCurrMonGen];
      end;

      if m_nCurrMonGen < m_MonGenList.Count - 1 then begin
        Inc(m_nCurrMonGen);
      end else begin
        m_nCurrMonGen:=0;
      end;//004B1718

      if (MonGen <> nil) and (MonGen.sMonName <> '') and not g_Config.boVentureServer then begin
        if (MonGen.dwStartTick = 0) or ((GetTickCount - MonGen.dwStartTick) > GetZenTime(MonGen.dwZenTime)) then begin
          nGenCount:=GetGenMonCount(MonGen);
          boRegened:=True;
          //if MonGen.nCount > tGenCount then begin
          //if (MonGen.nCount <= g_nMonGenRate) or (MonGen.nCount div g_nMonGenRate > tGenCount) then begin //0806 ���� ����ˢ����������
          nGenModCount:=_MAX(1,ROUND(_MAX(1,MonGen.nCount) / (g_Config.nMonGenRate / 10)));
          if nGenModCount > nGenCount then begin //0806 ���� ����ˢ����������
            boRegened:=RegenMonsters(MonGen,nGenModCount - nGenCount);
          end;//004B1798
          if boRegened then begin
            MonGen.dwStartTick:=GetTickCount();
          end;
        end;//004B17A9
        g_sMonGenInfo1:=MonGen.sMonName + ',' + IntToStr(m_nCurrMonGen) + '/' + IntToStr(m_MonGenList.Count);
      end;//004B1851

    end;//004B1851

    g_nMonGenTime:=GetTickCount - dwCurrentTick;
    if g_nMonGenTime > g_nMonGenTimeMin then g_nMonGenTimeMin:=g_nMonGenTime;
    if g_nMonGenTime > g_nMonGenTimeMax then g_nMonGenTimeMax:=g_nMonGenTime;

    //ˢ�¹������

      dwMonProcTick:=GetTickCount();
      nMonsterProcessCount:=0;
      tCode:=1;
      //004B187B
      for I:= m_nMonGenListPosition to m_MonGenList.Count -1 do begin
        MonGen:=m_MonGenList.Items[I];
        tCode:=11;
        if m_nMonGenCertListPosition < MonGen.CertList.Count then begin
          nProcessPosition:=m_nMonGenCertListPosition;
        end else begin//4B18A8
          nProcessPosition:=0;
        end;
        m_nMonGenCertListPosition:=0;
        //4B18B5
        while (True) do begin
          if nProcessPosition >= MonGen.CertList.Count then break;
          tcode:=15;
          Monster:=MonGen.CertList.Items[nProcessPosition];
          tCode:=12;
          if not Monster.m_boGhost then begin
            if Integer(dwCurrentTick - Monster.m_dwRunTick) > Monster.m_nRunTime then begin
              Monster.m_dwRunTick:=dwRunTick;
              if (dwCurrentTick - Monster.m_dwSearchTick) > Monster.m_dwSearchTime then begin
                Monster.m_dwSearchTick:=GetTickCount();
                tCode:=13;
                Monster.SearchViewRange();
              end;
              tCode:=14;

{$IF PROCESSMONSTMODE = OLDMONSTERMODE}
                Monster.Run;
{$ELSE}
              if not Monster.m_boIsVisibleActive and (Monster.m_nProcessRunCount < g_Config.nProcessMonsterInterval) then begin
                Inc(Monster.m_nProcessRunCount);
              end else begin
                Monster.m_nProcessRunCount:=0;
                Monster.Run;
              end;
{$IFEND}
              Inc(nMonsterProcessCount);
            end;
            Inc(nMonsterProcessPostion);
          end else begin
            if (GetTickCount - Monster.m_dwGhostTick) > 5 * 60 * 1000 then begin
              tcode:=16;
              MonGen.CertList.Delete(nProcessPosition);
              Monster.Free;
              Continue;
            end;
          end;
          tcode:=17;
          Inc(nProcessPosition);
          if (GetTickCount - dwMonProcTick) > g_dwMonLimit then begin
            g_sMonGenInfo2:=Monster.m_sCharName + '/' + IntToStr(I) + '/' + IntToStr(nProcessPosition);
            boProcessLimit:=True;
            m_nMonGenCertListPosition:=nProcessPosition;
            break;
          end;
        end; //while (True) do begin
        if boProcessLimit then break;
      end;//for I:= m_nMonGenListPosition to MonGenList.Count -1 do begin
      //004B1A5D

      tCode:=2;
      if m_MonGenList.Count <= I then begin
        m_nMonGenListPosition:=0;
        nMonsterCount:=nMonsterProcessPostion;
        nMonsterProcessPostion:=0;
        n84:=(n84 + nMonsterProcessCount) div 2;
      end;//4B1AAF

      if not boProcessLimit then begin
        m_nMonGenListPosition:=0;
      end else begin
        m_nMonGenListPosition:=I;
      end;
      g_nMonProcTime:=GetTickCount - dwMonProcTick;
      if g_nMonProcTime > g_nMonProcTimeMin then g_nMonProcTimeMin:=g_nMonProcTime;
      if g_nMonProcTime > g_nMonProcTimeMax then g_nMonProcTimeMax:=g_nMonProcTime;

  except
    on e: Exception do begin
      MainOutMessage(format(sExceptionMsg,[tCode]));
      MainOutMessage(E.Message);
    end;
  end;
  g_nMonTimeMin:=GetTickCount - dwRunTick;
  if g_nMonTimeMax < g_nMonTimeMin then g_nMonTimeMax:=g_nMonTimeMin;
end;
function TUserEngine.GetGenMonCount(MonGen:pTMonGenInfo):Integer;//4AE19C
var
  I          :Integer;
  nCount     :Integer;
  BaseObject :TBaseObject;
begin
  nCount:=0;
  for I:=0 to MonGen.CertList.Count -1 do begin
    BaseObject:=TBaseObject(MonGen.CertList.Items[I]);
    if not BaseObject.m_boDeath and not BaseObject.m_boGhost then Inc(nCount);
  end;
  Result:=nCount;
end;

procedure TUserEngine.ProcessNpcs;
var
  dwRunTick,dwCurrTick:LongWord;
  i:integer;
  NPC:TNormNpc;
  boProcessLimit:Boolean;
begin
  dwRunTick:=GetTickCount();
  boProcessLimit:=False;
  try
    dwCurrTick:=GetTickCount();
    for i:=nNpcPosition to QuestNPCList.Count -1 do begin
      NPC:=QuestNPCList.Items[i];
      if not NPC.m_boGhost then begin
        if Integer(dwCurrTick - NPC.m_dwRunTick) > NPC.m_nRunTime then begin
          if (GetTickCount - NPC.m_dwSearchTick) > NPC.m_dwSearchTime then begin
            NPC.m_dwSearchTick:=GetTickCount();
            NPC.SearchViewRange();
          end;
          if Integer(dwCurrTick - NPC.m_dwRunTick) > NPC.m_nRunTime then begin
            NPC.m_dwRunTick:=dwCurrTick;
            NPC.Run;  {FFFFB}
          end;
        end;
      end else begin
        if (GetTickCount - NPC.m_dwGhostTick) > 60 * 1000 then begin
          NPC.Free;
          QuestNPCList.Delete(i);
          break;
        end;
      end;
      if (GetTickCount - dwRunTick) > g_dwNpcLimit then begin
        nNpcPosition:=i;
        boProcessLimit:=True;
        Break;
      end;
    end;
    if not boProcessLimit then begin
      nNpcPosition:=0;
    end;
  except
    MainOutMessage('[Exceptioin] TUserEngine.ProcessNpcs');
  end;
  dwProcessNpcTimeMin:=GetTickCount - dwRunTick;
  if dwProcessNpcTimeMin > dwProcessNpcTimeMax then dwProcessNpcTimeMax:=dwProcessNpcTimeMin;
end;
//004ADE3C
function TUserEngine.RegenMonsterByName(sMap: String; nX, nY: Integer;
  sMonName: String):TBaseObject;
var
  nRace:Integer;
  BaseObject:TBaseObject;
  n18:Integer;
  MonGen:pTMonGenInfo;
begin
  nRace:=GetMonRace(sMonName);
  BaseObject:=AddBaseObject(sMap,nX,nY,nRace,sMonName);
  if BaseObject <> nil then begin
    n18:=m_MonGenList.Count - 1;
    if n18 < 0 then n18:=0;
    MonGen:=m_MonGenList.Items[n18];
    MonGen.CertList.Add(BaseObject);
    BaseObject.m_PEnvir.AddObject(BaseObject);
    BaseObject.m_boAddToMaped:=True;
//    MainOutMessage(format('MonGet Count:%d',[MonGen.CertList.Count]));
  end;

  Result:=BaseObject;
end;
function TUserEngine.RegenMonsterByName(pEnvir:TEnvirnoment; nX, nY: Integer;
  sMonName: String):TBaseObject;
var
  nRace:Integer;
  BaseObject:TBaseObject;
  n18:Integer;
  MonGen:pTMonGenInfo;
begin
  nRace:=GetMonRace(sMonName);
  BaseObject:=AddBaseObjectEx(pEnvir,nX,nY,nRace,sMonName);
  if BaseObject <> nil then begin
    n18:=m_MonGenList.Count - 1;
    if n18 < 0 then n18:=0;
    MonGen:=m_MonGenList.Items[n18];
    MonGen.CertList.Add(BaseObject);
    BaseObject.m_PEnvir.AddObject(BaseObject);
    BaseObject.m_boAddToMaped:=True;
//    MainOutMessage(format('MonGet Count:%d',[MonGen.CertList.Count]));
  end;

  Result:=BaseObject;
end;

procedure TUserEngine.Run; //004B20B8
//var
//  i:integer;
//  dwProcessTick:LongWord;
ResourceString
  sExceptionMsg = '[Exception] TUserEngine::Run';
begin
    CalceTime:=GetTickCount;
    try
      {
      ProcessHumans();
      if (GetTickCount() - dwProcessMonstersTick) > g_dwProcessMonstersTime then begin
        dwProcessMonstersTick:=GetTickCount();
        ProcessMonsters();
      end;
      dwProcessTick:=GetTickCount();
      ProcessMerchants();
      dwProcessMerchantTimeMin:=GetTickCount - dwProcessTick;
      dwProcessTick:=GetTickCount();
      ProcessNpcs();
      dwProcessNpcTimeMin:=GetTickCount - dwProcessTick;
      if (GetTickCount() - dwProcessMissionsTime) > 1000 then begin
        dwProcessMissionsTime:=GetTickCount();
        ProcessMissions();
        Process4AECFC();
        ProcessEvents();
      end;
      if (GetTickCount() - dwProcessMapDoorTick) > 500 then begin
        dwProcessMapDoorTick:=GetTickCount();
        ProcessMapDoor();
      end;
      }
      if (GetTickCount() - dwShowOnlineTick) > g_Config.dwConsoleShowUserCountTime then begin
//      if (GetTickCount() - dwShowOnlineTime) > 5000 then begin
        dwShowOnlineTick:=GetTickCount();
        NoticeManager.LoadingNotice;
//        MainOutMessage(TimeToStr(Now) + ' ������: ' + IntToStr(GetUserCount));
        MainOutMessage('��������: ' + IntToStr(GetUserCount));
//        UserCastle.Save;
        g_CastleManager.Save;
      end;
      if (GetTickCount() - dwSendOnlineHumTime) > 10000 then begin
        dwSendOnlineHumTime:=GetTickCount();
        FrmIDSoc.SendOnlineHumCountMsg(GetOnlineHumCount);
//        GuildManager.Run;
//        UserCastle.Run;
//        for i:=0 to DenySayMsgList.Count - 1 do begin
//          //
//        end;
      end;
    except
     on e: Exception do begin
      MainOutMessage(sExceptionMsg);
      MainOutMessage(E.Message);
     end;
    end;
//    dwUsrTimeMin:=GetTickCount() - CalceTime;
//    if dwUsrTimeMax < dwUsrTimeMin then dwUsrTimeMax:=dwUsrTimeMin;
      
end;

function TUserEngine.GetStdItem(nItemIdx: Integer): TItem; //004AC2F8
begin
  Result:=nil;
    Dec(nItemIdx);
    if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then begin
      Result:=StdItemList.Items[nItemIdx];
      if Result.Name = '' then Result:=nil;
    end;
end;
function TUserEngine.GetStdItem(sItemName:String): TItem; //004AC348
var
  I: Integer;
  StdItem:TItem;
begin
  Result:=nil;
  if sItemName = '' then exit;
    for I := 0 to StdItemList.Count - 1 do begin
      StdItem:=StdItemList.Items[i];
      if CompareText(StdItem.Name,sItemName) = 0 then begin
        Result:=StdItem;
        break;
      end;
    end;
end;

function TUserEngine.GetStdItemWeight(nItemIdx: Integer): Integer; //004AC2B0
var
  StdItem:TItem;
begin
    Dec(nItemIdx);
    if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then begin
      StdItem:=StdItemList.Items[nItemIdx];
      Result:=StdItem.Weight;
    end else begin
      Result:=0;
    end;
end;

function TUserEngine.GetStdItemName(nItemIdx: Integer): String;//004AC1AC
begin
  Result:='';
  Dec(nItemIdx);
    if (nItemIdx >= 0) and (StdItemList.Count > nItemIdx) then begin
      Result:=TItem(StdItemList.Items[nItemIdx]).Name;

    end else Result:='';
end;

function TUserEngine.FindOtherServerUser(sName: String;
  var nServerIndex): Boolean;
begin
  Result:=False;
end;

//004AEA00
procedure TUserEngine.CryCry(wIdent: Word; pMap: TEnvirnoment; nX, nY,
  nWide: Integer;btFColor,btBColor:Byte; sMsg: String);
var
  i:integer;
  PlayObject:TPlayObject;
begin
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject:=TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boGhost and
      (PlayObject.m_PEnvir = pMap) and
      (PlayObject.m_boBanShout) and
      (abs(PlayObject.m_nCurrX - nX) < nWide) and
      (abs(PlayObject.m_nCurrY - nY) < nWide) then begin

      //PlayObject.SendMsg(nil,wIdent,0,0,$FFFF,0,sMsg);
      PlayObject.SendMsg(nil,wIdent,0,btFColor,btBColor,0,sMsg);
    end;
  end;
end;

function  TUserEngine.MonGetRandomItems (mon: TBaseObject):Integer;//004AD2E8
var
   i: integer;
   ItemList:TList;
   iname: string;
   MonItem:pTMonItem;
   UserItem:pTUserItem;
   StdItem:TItem;
   Monster:pTMonInfo;
begin
   ItemList:= nil;
     for i:=0 to MonsterList.Count-1 do begin
       Monster:=MonsterList.Items[i];
       if CompareText(Monster.sName, mon.m_sCharName) = 0 then begin
         ItemList:=Monster.Itemlist;
         break;
       end;
     end;
   if ItemList <> nil then begin
      for i:=0 to ItemList.Count-1 do begin
         MonItem:=pTMonItem(ItemList[i]);
         if Random(MonItem.MaxPoint) <= MonItem.SelPoint then begin
           if CompareText(MonItem.ItemName, sSTRING_GOLDNAME) = 0 then begin
             mon.m_nGold := mon.m_nGold + (MonItem.Count div 2) + Random(MonItem.Count);
            end else begin
               //����ũ ������ �̺�Ʈ....
               iname := '';
               ////if (BoUniqueItemEvent) and (not mon.BoAnimal) then begin
               ////   if GetUniqueEvnetItemName (iname, numb) then begin
                     //numb; //iname
               ////   end;
               ////end;
               if iname = '' then
                  iname := MonItem.ItemName;

               New(UserItem);
               if CopyToUserItemFromName (iname, UserItem) then begin
                  UserItem.Dura := Round ((UserItem.DuraMax / 100) * (20+Random(80)));

                  StdItem:=GetStdItem(UserItem.wIndex);
                  ////if pstd <> nil then
                  ////   if pstd.StdMode = 50 then begin  //��ǰ��
                  ////      pu.Dura := numb;
                  ////   end;
                  if Random(g_Config.nMonRandomAddValue{10}) = 0 then
                     StdItem.RandomUpgradeItem(UserItem);
                  if StdItem.StdMode in [15,19,20,21,22,23,24,26] then begin
                    if (StdItem.Shape = 130) or (StdItem.Shape = 131) or (StdItem.Shape = 132) then begin
                      StdItem.RandomUpgradeUnknownItem(UserItem);
                    end;                      
                  end;                      
                  mon.m_ItemList.Add(UserItem)
               end else
                  Dispose(UserItem);
            end;
         end;
      end;
   end;
   Result:= 1;
end;

//004AC404
function TUserEngine.CopyToUserItemFromName(sItemName:String;Item:pTUserItem):Boolean;
var
  I: Integer;
  StdItem:TItem;
begin
  Result:=False;
    if sItemName <> '' then begin
      for I := 0 to StdItemList.Count - 1 do begin
        StdItem:=StdItemList.Items[i];
        if CompareText(StdItem.Name,sItemName) = 0 then begin
          FillChar(Item^,SizeOf(TUserItem),#0);
          Item.wIndex:=i + 1;
          Item.MakeIndex:=GetItemNumber();
          Item.Dura:=StdItem.DuraMax;
          Item.DuraMax:=StdItem.DuraMax;
          Item.Amount:=1;
          Result:=True;
          break;
        end;
      end;
    end;
end;

procedure TUserEngine.ProcessUserMessage(PlayObject:TPlayObject;DefMsg:pTDefaultMessage;Buff:PChar); //004B232C
var
  sMsg:String;
ResourceString
  sExceptionMsg = '[Exception] TUserEngine::ProcessUserMessage..';
begin
  if (DefMsg = nil) then exit;
  try
    if Buff = nil then sMsg:=''
    else sMsg:=StrPas(Buff);

    case DefMsg.Ident of
      CM_SPELL: begin //3017
        //if PlayObject.GetSpellMsgCount <=2 then  //����������г�������ħ���������򲻼������
        if g_Config.boSpellSendUpdateMsg then begin //ʹ��UpdateMsg ���Է�ֹ��Ϣ�������ж������
          PlayObject.SendUpdateMsg(PlayObject,
                            DefMsg.Ident,
                            DefMsg.Tag,
                            LoWord(DefMsg.Recog),
                            HiWord(DefMsg.Recog),
                            MakeLong(DefMsg.Param,
                            DefMsg.Series),
                            '');
        end else begin
          PlayObject.SendMsg(PlayObject,
                            DefMsg.Ident,
                            DefMsg.Tag,
                            LoWord(DefMsg.Recog),
                            HiWord(DefMsg.Recog),
                            MakeLong(DefMsg.Param,
                            DefMsg.Series),
                            '');
        end;
      end;

      CM_QUERYUSERNAME: begin//80
        PlayObject.SendMsg(PlayObject,DefMsg.Ident,0,DefMsg.Recog,DefMsg.Param{x},DefMsg.Tag{y},'');
      end;

      CM_ADDBADFRIEND,
      CM_ADDFRIEND: begin
         PlayObject.SendMsg(PlayObject,
                          DefMsg.Ident,
                          0,
                          DefMsg.Recog,
                          0,
                          0,
                          DecodeString(sMsg));
      end;

      CM_DELFRIEND: begin
         PlayObject.SendMsg(PlayObject,
                          DefMsg.Ident,
                          0,
                          0,
                          0,
                          0,
                          DecodeString(sMsg));
      end;

      CM_UPDATEMEMOFRIEND: begin
         PlayObject.SendMsg(PlayObject, DefMsg.Ident, 0, 0, 0, 0, DecodeString(sMsg));
      end;

      CM_REQMEMOFRIEND: begin
         PlayObject.SendMsg(PlayObject, DefMsg.Ident, 0, 0, 0, 0, DecodeString(sMsg));
      end;

      CM_REQUESTMAILLIST,
      CM_SENDMAIL,
      CM_READMAIL,
      CM_DELETEMAIL,
      CM_SETMAILSTATUS,
      CM_REQUESTBLOCKLIST,
      CM_ADDBLOCK,
      CM_DELBLOCK: begin
        PlayObject.SendMsg(PlayObject, DefMsg.Ident, DefMsg.Series, DefMsg.Recog, DefMsg.Param, DefMsg.Tag, DecodeString(sMsg));
      end;


      CM_DROPITEM,
      CM_TAKEONITEM,
      CM_TAKEOFFITEM,
      CM_1005,

      CM_MERCHANTDLGSELECT,
      CM_MERCHANTQUERYSELLPRICE,
      CM_USERSELLITEM,
      CM_USERBUYITEM,
      CM_USERGETDETAILITEM,

      CM_CREATEGROUP,
      CM_ADDGROUPMEMBER,
      CM_DELGROUPMEMBER,
      CM_USERREPAIRITEM,
      CM_MERCHANTQUERYREPAIRCOST,
      CM_DEALTRY,
      CM_DEALADDITEM,
      CM_DEALDELITEM,

      CM_USERSTORAGEITEM,
      CM_USERTAKEBACKSTORAGEITEM,
      CM_USERMAKEDRUGITEM,

//      CM_GUILDHOME,
      CM_GUILDADDMEMBER,
      CM_GUILDDELMEMBER,
      CM_GUILDUPDATENOTICE,
      CM_GUILDUPDATERANKINFO: begin
        PlayObject.SendMsg(PlayObject,
                          DefMsg.Ident,
                          DefMsg.Series,
                          DefMsg.Recog,
                          DefMsg.Param,
                          DefMsg.Tag,
                          DecodeString(sMsg));
      end;
      CM_PASSWORD,
      CM_CHGPASSWORD,
      CM_SETPASSWORD: begin
        PlayObject.SendMsg(PlayObject,
                          DefMsg.Ident,
                          DefMsg.Param,
                          DefMsg.Recog,
                          DefMsg.Series,
                          DefMsg.Tag,
                          DecodeString(sMsg));
      end;
      CM_ADJUST_BONUS: begin //1043
        PlayObject.SendMsg(PlayObject,
                          DefMsg.Ident,
                          DefMsg.Series,
                          DefMsg.Recog,
                          DefMsg.Param,
                          DefMsg.Tag,
                          sMsg);
      end;
    {  CM_GEMSYSTEM: begin
      mainoutmessage('gemsss');
      PlayObject.CreateGem(sMsg);
      end; }

      CM_HORSERUN,
      CM_TURN,
      CM_WALK,
      CM_SITDOWN,
      CM_RUN,
      CM_HIT,
      CM_HEAVYHIT,
      CM_BIGHIT,

      CM_POWERHIT,
      CM_LONGHIT,
      CM_CRSHIT,
      CM_TWINHIT,
      CM_WIDEHIT,
      CM_FIREHIT: begin
        if g_Config.boActionSendActionMsg then begin //ʹ��UpdateMsg ���Է�ֹ��Ϣ�������ж������
          PlayObject.SendActionMsg(PlayObject,
                          DefMsg.Ident,
                          DefMsg.Tag,
                          LoWord(DefMsg.Recog),{x}
                          HiWord(DefMsg.Recog),{y}
                          0,
                          '');
        end else begin
          PlayObject.SendMsg(PlayObject,
                          DefMsg.Ident,
                          DefMsg.Tag,
                          LoWord(DefMsg.Recog),{x}
                          HiWord(DefMsg.Recog),{y}
                          0,
                          '');
        end;
      end;

{      CM_BUYGAMESHOPITEM: begin
          PlayObject.SendUpdateMsg(PlayObject,
            DefMsg.Ident,
            DefMsg.Series,
            DefMsg.Recog,
            DefMsg.Param,
            DefMsg.Tag,
            DeCodeString(sMsg));
        end;  }
        
      CM_SAY: begin
        PlayObject.SendMsg(PlayObject,CM_SAY,0,0,0,0,DecodeString(sMsg));
      end;
      else begin
        PlayObject.SendMsg(PlayObject,
                          DefMsg.Ident,
                          DefMsg.Series,
                          DefMsg.Recog,
                          DefMsg.Param,
                          DefMsg.Tag,
                          sMsg);
      end;
    end;
    if PlayObject.m_boReadyRun then begin
      case DefMsg.Ident of
        CM_TURN,CM_WALK,CM_SITDOWN,CM_RUN,CM_HIT,CM_HEAVYHIT,CM_BIGHIT,
        CM_POWERHIT,CM_LONGHIT,
        CM_WIDEHIT,CM_FIREHIT,CM_CRSHIT,CM_TWINHIT: begin
          Dec(PlayObject.m_dwRunTick,100);
        end;
      end;
    end;      
  except
    MainOutMessage(sExceptionMsg);
  end;
end;
//004AF728
procedure TUserEngine.SendServerGroupMsg(nCode, nServerIdx: Integer;
  sMsg: String);
begin
  if nServerIndex = 0 then begin
    FrmSrvMsg.SendSocketMsg(IntToStr(nCode) + '/' + EncodeString(IntToStr(nServerIdx)) + '/' + EncodeString(sMsg));
  end else begin
    FrmMsgClient.SendSocket(IntToStr(nCode) + '/' + EncodeString(IntToStr(nServerIdx)) + '/' + EncodeString(sMsg));
  end;    
end;
function TUserEngine.AddBaseObject(sMapName:String;nX,nY:Integer;nMonRace:Integer;sMonName:String):TBaseObject;//004AD56C
var
Map:TEnvirnoment;
begin
  Map:=g_MapManager.FindMap(sMapName);
  result:=AddBaseObjectEx(map,nx,ny,nMonRace,sMonName);
end;
function TUserEngine.AddBaseObjectEx(Map:TEnvirnoment;nX,nY:Integer;nMonRace:Integer;sMonName:String):TBaseObject;//004AD56C
var
  Cert:TBaseObject;
  n1C,n20,n24:Integer;
  p28:Pointer;
begin
  Result:=nil;
  Cert:=nil;
  

  if Map = nil then exit;    
  case nMonRace of
    SUPREGUARD: Cert:=TSuperGuard.Create;
    PETSUPREGUARD: Cert:=TPetSuperGuard.Create;
    ARCHER_POLICE: Cert:=TArcherPolice.Create;
    ANIMAL_CHICKEN: begin
      Cert:=TMonster.Create;
      Cert.m_boAnimal:=True;
      Cert.m_nMeatQuality:=Random(3500) + 3000;
      Cert.m_nBodyLeathery:=50;
    end;
    ANIMAL_DEER: begin
      if Random(30) = 0 then begin
        Cert:=TChickenDeer.Create;
        Cert.m_boAnimal:=True;
        Cert.m_nMeatQuality:=Random(20000) + 10000;
        Cert.m_nBodyLeathery:=150;
      end else begin
        Cert:=TMonster.Create;
        Cert.m_boAnimal:=True;
        Cert.m_nMeatQuality:=Random(8000) + 8000;
        Cert.m_nBodyLeathery:=150;
      end;
    end;
    ANIMAL_WOLF: begin
      Cert:=TATMonster.Create;
      Cert.m_boAnimal:=True;
      Cert.m_nMeatQuality:=Random(8000) + 8000;
      Cert.m_nBodyLeathery:=150;
    end;
    TRAINER: begin
      Cert:=TTrainer.Create;
    end;
    MONSTER_OMA: Cert:=TMonster.Create;
    MONSTER_OMAKNIGHT: Cert:=TATMonster.Create;
    MONSTER_SPITSPIDER: Cert:=TSpitSpider.Create;
    83: Cert:=TSlowATMonster.Create;
    84: Cert:=TScorpion.Create;
    MONSTER_STICK: Cert:=TStickMonster.Create;
    86: Cert:=TATMonster.Create;
    MONSTER_DUALAXE: Cert:=TDualAxeMonster.Create;
    88: Cert:=TATMonster.Create;
    89: Cert:=TATMonster.Create;
    90: Cert:=TGasAttackMonster.Create;
    91: Cert:=TMagCowMonster.Create;
    92: Cert:=TCowKingMonster.Create;
    MONSTER_THONEDARK: Cert:=TThornDarkMonster.Create;
    MONSTER_LIGHTZOMBI: Cert:=TLightingZombi.Create;
    MONSTER_DIGOUTZOMBI: begin
      Cert:=TDigOutZombi.Create;
      if Random(2) = 0 then Cert.bo2BA:=True;
    end;
    MONSTER_ZILKINZOMBI: begin
      Cert:=TZilKinZombi.Create;
      if Random(4) = 0 then Cert.bo2BA:=True;
    end;
    97: begin
      Cert:=TCowMonster.Create;
      if Random(2) = 0 then Cert.bo2BA:=True;
    end;

    MONSTER_WHITESKELETON: Cert:=TWhiteSkeleton.Create;
    MONSTER_SCULTURE: begin
      Cert:=TScultureMonster.Create;
      Cert.bo2BA:=True;
    end;
    MONSTER_SCULTUREKING: Cert:=TScultureKingMonster.Create;
    MONSTER_BEEQUEEN: Cert:=TBeeQueen.Create;
    104: Cert:=TArcherMonster.Create;
    105: Cert:=TGasMothMonster.Create;//Ш��
    106: Cert:=TGasDungMonster.Create;
    107: Cert:=TCentipedeKingMonster.Create;
    110: Cert:=TCastleDoor.Create;
    111: Cert:=TWallStructure.Create;
    MONSTER_ARCHERGUARD: Cert:=TArcherGuard.Create;
    MONSTER_ELFMONSTER: Cert:=TElfMonster.Create;
    MONSTER_ELFWARRIOR: Cert:=TElfWarriorMonster.Create;
    115: Cert:=TBigHeartMonster.Create;
    116: Cert:=TSpiderHouseMonster.Create;
    117: Cert:=TExplosionSpider.Create;
    118: Cert:=THighRiskSpider.Create;
    119: Cert:=TBigPoisionSpider.Create;
    120: Cert:=TSoccerBall.Create;
    130: Cert:=TDoubleCriticalMonster.Create;
    131: Cert:=TRonObject.Create;
    132: Cert:=TSandMobObject.Create;
    133: Cert:=TMagicMonObject.Create;
    134: Cert:=TBoneKingMonster.Create;
    135: Cert:=TBamTreeMonster.Create;
    136: Cert:=TNodeMonster.Create;
    137: Cert:=TOmaKing.Create;
    138: Cert:=TEvilMir.Create;
    139: Cert:=TDragonStatue.Create;
    140: Cert:=TDragonPart.Create;
    141: Cert:=THolyDeva.Create;
    MONSTER_CLONE: Cert:=TClone.create;    //142
    143: Cert:=TRedThunderZuma.Create;
    144: Cert:=TCrystalSpider.Create;
    145: Cert:=TYimoogi.Create;
    146: Cert:=TYimoogiMaster.Create;
    148: Cert:=TBlackFox.Create;
    151: Cert:=TRedFox.Create;
    152: Cert:=TWhiteFox.Create;
    155: Cert:=TFoxOrbSpirit.Create;
    156: Cert:=TGuardianRock.Create;
    160: Cert:=THellGuard.Create;
    161: Cert:=TNewMonsterBoss.Create;

    200: Cert:=TElectronicScolpionMon.Create;


    202: Cert:=TDDevil.Create;
    203: Cert:=TTeleMonster.Create;
    206: Cert:=TKhazard.Create;
    208: Cert:=TGreenMonster.Create;
    209: Cert:=TRedMonster.Create;
    210: Cert:=TFrostTiger.Create;
    214: Cert:=TFireMonster.Create;
    215: Cert:=TFireBallMonster.Create;

    70: Cert:=TMinoGuard.Create;
    71: Cert:=TMinotaurKing.Create;

    MONSTER_STONE: Cert := TStoneMonster.Create;
  end;

  if Cert <> nil then begin
    MonInitialize(Cert,sMonName);
    Cert.m_PEnvir:=Map;
    Cert.m_sMapName:=Map.sMapName;
    Cert.m_nCurrX:=nX;
    Cert.m_nCurrY:=nY;
    Cert.m_btDirection:=Random(8);
    Cert.m_sCharName:=sMonName;
    Cert.m_WAbil:=Cert.m_Abil;
    if Random(100) < Cert.m_btCoolEye then Cert.m_boCoolEye:=True;
    MonGetRandomItems(Cert); //ȡ�ù��ﱬ��Ʒ����
    Cert.Initialize(); //004ADC97 $0FFFE
    if Cert.m_boAddtoMapSuccess then begin
      p28:=nil;
      if Cert.m_PEnvir.Header.wWidth < 50 then  n20:=2
      else n20:=3;
      if (Cert.m_PEnvir.Header.wHeight < 250) then begin
        if (Cert.m_PEnvir.Header.wHeight < 30) then  n24:=2
        else n24:=20;
      end else n24:=50;

      n1C:=0;
      while (True) do begin
        if not Cert.m_PEnvir.CanWalk(Cert.m_nCurrX,Cert.m_nCurrY,False) then begin
          if (Cert.m_PEnvir.Header.wWidth - n24 -1) > Cert.m_nCurrX then begin
            Inc(Cert.m_nCurrX,n20);
          end else begin //004ADD9D
            Cert.m_nCurrX:=Random(Cert.m_PEnvir.Header.wWidth div 2) + n24;
            if Cert.m_PEnvir.Header.wHeight - n24 -1 > Cert.m_nCurrY then begin
              Inc(Cert.m_nCurrY,n20);
            end else begin //004ADDBE
              Cert.m_nCurrY:=Random(Cert.m_PEnvir.Header.wHeight div 2) + n24;
            end;
          end;
        end else begin //004ADDC0
          p28:=Cert.m_PEnvir.AddToMap(Cert.m_nCurrX,Cert.m_nCurrY,OS_MOVINGOBJECT,Cert);
          break;
        end;
        Inc(n1C);
        if n1C >= 31 then break;
      end;

      if p28 = nil then begin
        Cert.Free;
        Cert:=nil;
      end;
    end;
  end;
  
  Result:=Cert;
end;
//====================================================
//����:�����������
//����ֵ����ָ��ʱ���ڴ���������򷵼�TRUE���������ָ��ʱ���򷵻�FALSE
//====================================================

procedure TUserEngine.EffectTarget(x,y:Integer;Envir:TEnvirnoment);
var
  Target,BaseObject:TBaseObject;
  xTargetList:TList;
  Dmg,magpwr:Integer;
  i:Integer;
  freshbaseobject:TBaseObject;
begin
  Target:=FindNearbyTarget(x,y,Envir);
  if Target = nil then begin
    exit; //if there's nobody in the area then the spell cant do dmg
  end;
  FreshBaseObject:=tbaseobject.Create();
  if Random(5) = 0 then begin //20% chance the effect gets attracted by the nearest player :p
    x:=Target.m_nCurrX;
    y:=Target.m_nCurrY;
  end;

  xTargetList := TList.Create;
  If Envir.Flag.nThunder <> 0 then begin
    Target.SendRefMsg(RM_10205,0,x,y,10,''); //need to get it so the tbolt shows on everyones screen
    Dmg:=Envir.Flag.nThunder;
    Envir.GetBaseObjects(x,y,True,xTargetList);
  end;
  if Envir.Flag.nLava <> 0 then begin
    Target.SendRefMsg(RM_10205,0,x,y,11,''); //need to get it so the lava shows on everyones screen
    Dmg:=Envir.Flag.nLava;
    Envir.GetRangeBaseObject(x,y,1,True,xTargetList)
  end;

	if (xTargetList.Count>0) then begin
    for i:=xTargetList.Count-1 downto 0 do begin
      BaseObject := TBaseObject(xTargetList.Items[i]);

      if (BaseObject<>nil) then begin
      if Target.IsProperFriend(BaseObject) or (Target = BaseObject) then begin //since target = the neareset HUMAN player it's simple to just check if whatever we are about to hit = friend of the human
          magpwr:=Random(Dmg);
          BaseObject.SendDelayMsg (FreshBaseObject, RM_MAGSTRUCK, 0, magpwr, 1, 0, '', 600);
      end;
        xTargetList.Delete(i);
		  end;
    end;
	end;
  xTargetList.Free;
  FreshBaseObject.Destroy;
end;

function TUserEngine.FindNearbyTarget(x,y:Integer;Envir:TEnvirnoment): TBaseObject;
var
  xTargetList:TList;
  dist:Integer;
  BaseObject:TBaseObject;
  nRage:Integer;
  i:Integer;
begin
  dist:=999;
  nRage:=12;

  result:=nil;
  BaseObject:=nil;
  //first lets find us a victim that we can abuse to send the effect through (basicaly find the person closest to the effect and use his sendrefmsg code)
  xTargetList := TList.Create;
  Envir.GetRangeBaseObject(x,y,nRage,False,xTargetList);
  for i:=0 to xTargetList.count - 1 do begin
    BaseObject:= TBaseObject(xTargetList.Items[i]);
    if BaseObject.m_btRaceServer = RC_PLAYOBJECT then begin //no point sending effect if there's no players nearby
      if abs(abs(BaseObject.m_nCurrX - x)+(abs(BaseObject.m_nCurrY - y))) < dist then begin
        dist := abs(abs(BaseObject.m_nCurrX - x)+(abs(BaseObject.m_nCurrY - y)));
        result:= BaseObject; //this target is closer to our point then last one was
        if (BaseObject.m_nCurrX = x) and (BaseObject.m_nCurrY = y) then
          exit; //cant get any closer the the exact spot
      end;

    end;
  end;
  xTargetList.Free;
end;

function TUserEngine.RegenMonsters(MonGen:pTMonGenInfo;nCount:integer): Boolean;//004ADF04
var
  dwStartTick:LongWord;

  nX:Integer;
  nY:Integer;
  i:Integer;
  Cert:TBaseObject;
ResourceString
  sExceptionMsg = '[Exception] TUserEngine::RegenMonsters';
begin
  Result:=True;
  dwStartTick:=GetTickCount();
  try
    if MonGen.nRace > 0 then begin
      if Random(100) < MonGen.nMissionGenRate then begin
        nX:=(MonGen.nX - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
        nY:=(MonGen.nY - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
        for i:=0 to nCount -1 do begin
          Cert:=AddBaseObject(MonGen.sMapName,((nX - 10) + Random(20)),((nY - 10) + Random(20)),MonGen.nRace,MonGen.sMonName);
          if Cert <> nil then MonGen.CertList.Add(Cert);
          if (GetTickCount - dwStartTick) > g_dwZenLimit then begin
            Result:=False;
            Break;
          end;
        end;//4AE058
      end else begin//004AE063
        for i:=0 to nCount -1 do begin
          nX:=(MonGen.nX - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
          nY:=(MonGen.nY - MonGen.nRange) + Random(MonGen.nRange * 2 + 1);
          Cert:=AddBaseObject(MonGen.sMapName,nX,nY,MonGen.nRace,MonGen.sMonName);
          if Cert <> nil then MonGen.CertList.Add(Cert);
          if (GetTickCount - dwStartTick) > g_dwZenLimit then begin
            Result:=False;
            break;
          end;
        end;
      end;
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;
procedure TUserEngine.WriteShiftUserData();
//004AF510
begin

end;
function TUserEngine.GetPlayObject(sName: String): TPlayObject;//004AE640
var
  i:Integer;
  PlayObject:TPlayObject;
begin
  Result:=nil;
  for i:=0 to m_PlayObjectList.Count -1 do begin
    if CompareText(m_PlayObjectList.Strings[i],sName) = 0 then begin
      PlayObject:=TPlayObject(m_PlayObjectList.Objects[i]);
      if not PlayObject.m_boGhost then begin
       if not (PlayObject.m_boPasswordLocked and PlayObject.m_boObMode and PlayObject.m_boAdminMode) then
        Result:=PlayObject;
      end;
      Break;
    end;
  end;
end;
procedure TUserEngine.KickPlayObjectEx(sName:String);
var
  i:Integer;
  PlayObject:TPlayObject;
begin
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
  for i:=0 to m_PlayObjectList.Count -1 do begin
    if CompareText(m_PlayObjectList.Strings[i],sName) = 0 then begin
      PlayObject:=TPlayObject(m_PlayObjectList.Objects[i]);
      PlayObject.m_boEmergencyClose:=True;
      Break;
    end;
  end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;  
end;
function TUserEngine.GetPlayObjectEx(sName: String): TPlayObject;//004AE640
var
  I          :Integer;
begin
  Result:=nil;
  EnterCriticalSection(ProcessHumanCriticalSection);
  try
    for I:=0 to m_PlayObjectList.Count -1 do begin
      if CompareText(m_PlayObjectList.Strings[I],sName) = 0 then begin
        Result:=TPlayObject(m_PlayObjectList.Objects[I]);
        Break;
      end;
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

function TUserEngine.FindMerchant(Merchant:TObject):TMerchant;//004AC858
var
  I: Integer;
begin
  Result:=nil;
  m_MerchantList.Lock;
  try
    for I := 0 to m_MerchantList.Count - 1 do begin
      if TObject(m_MerchantList.Items[i]) = Merchant then begin
        Result:=TMerchant(m_MerchantList.Items[i]);
        break;
      end;
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;

function TUserEngine.FindNPC(GuildOfficial:TObject):TGuildOfficial;//004ACB24
var
  I: Integer;
begin
  Result:=nil;
  for I := 0 to QuestNPCList.Count - 1 do begin
    if TObject(QuestNPCList.Items[i]) = GuildOfficial then begin
      Result:=TGuildOfficial(QuestNPCList.Items[i]);
      break;
    end;
  end;
end;

//4AE810
function TUserEngine.GetMapOfRangeHumanCount(Envir: TEnvirnoment; nX, nY,
  nRange: integer): Integer;
var
  I: Integer;
  PlayObject:TPlayObject;
begin
  Result:=0;
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject:=TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boGhost and (PlayObject.m_PEnvir = Envir) then begin
      if (abs(PlayObject.m_nCurrX - nX) < nRange) and (abs(PlayObject.m_nCurrY - nY) < nRange) then Inc(Result);
    end;
  end;
end;

function TUserEngine.GetHumPermission(sUserName:String;var sIPaddr:String; var btPermission:Byte):Boolean;//4AE590
var
  I         :Integer;
  AdminInfo :pTAdminInfo;
begin
  Result:=False;
  btPermission:=g_Config.nStartPermission;
  m_AdminList.Lock;
  try
    for I := 0 to m_AdminList.Count - 1 do begin
      AdminInfo:=m_AdminList.Items[I];
      if CompareText(AdminInfo.sChrName,sUserName) = 0 then begin
        btPermission := AdminInfo.nLv;
        sIPaddr      := AdminInfo.sIPaddr;
        Result       := True;
        break;
      end;
    end;
  finally
    m_AdminList.UnLock;
  end;
end;

procedure TUserEngine.GenShiftUserData;
//004AEF6C
begin

end;

//004AE3FC
procedure TUserEngine.AddUserOpenInfo(UserOpenInfo: pTUserOpenInfo);
begin
  EnterCriticalSection(m_LoadPlaySection);
  try
    m_LoadPlayList.AddObject(UserOpenInfo.sChrName,Tobject(UserOpenInfo));
  finally
    LeaveCriticalSection(m_LoadPlaySection);
  end;
end;

//004AEB80
procedure TUserEngine.KickOnlineUser(sChrName: String);
var
  I: Integer;
  PlayObject:TPlayObject;
begin
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject:=TPlayObject(m_PlayObjectList.Objects[I]);
    if CompareText(PlayObject.m_sCharName,sChrName) = 0 then begin
      PlayObject.m_boKickFlag:=True;
      break;
    end;
  end;
end;
//004AF85C
function TUserEngine.SendSwitchData(PlayObject: TPlayObject;nServerIndex: Integer): Boolean;
begin
  Result:=True;
end;
//004AF988
procedure TUserEngine.SendChangeServer(PlayObject: TPlayObject;nServerIndex: Integer);
var
  sIPaddr:String;
  nPort:Integer;
ResourceString
  sMsg = '%s/%d';
begin
  if GetMultiServerAddrPort(nServerIndex,sIPaddr,nPort) then begin
    PlayObject.SendDefMessage(SM_RECONNECT,0,0,0,0,format(sMsg,[sIPaddr,nPort]));
  end;
end;

procedure TUserEngine.SaveHumanRcd(PlayObject: TPlayObject); //004AE488
var
  SaveRcd:pTSaveRcd;
begin
  New(SaveRcd);
  FillChar(SaveRcd^,SizeOf(TSaveRcd),#0);
  SaveRcd.sAccount:=PlayObject.m_sUserID;
  SaveRcd.sChrName:=PlayObject.m_sCharName;
  SaveRcd.nSessionID:=PlayObject.m_nSessionID;
  SaveRcd.PlayObject:=PlayObject;
  PlayObject.MakeSaveRcd(SaveRcd.HumanRcd);
  FrontEngine.AddToSaveRcdList(SaveRcd);
end;

procedure TUserEngine.AddToHumanFreeList(PlayObject: TPlayObject);//004AE45C
begin
  PlayObject.m_dwGhostTick:=GetTickCount();
  m_PlayObjectFreeList.Add(PlayObject);
end;
//004AEE98
function TUserEngine.GetSwitchData(sChrName: String; nCode: Integer): pTSwitchDataInfo;
var
  i:integer;
  SwitchData:pTSwitchDataInfo;
begin
  Result:=nil;
  for I := 0 to m_ChangeServerList.Count - 1 do begin
    SwitchData:=m_ChangeServerList.Items[i];
    if (CompareText(SwitchData.sChrName,sChrName) = 0) and (SwitchData.nCode = nCode) then begin
      Result:=SwitchData;
      break;
    end;
  end;
end;

procedure TUserEngine.GetHumData(PlayObject: TPlayObject;
  var HumanRcd: THumData); //004B3050
var
  HumItems      :pTHumItems;
  BagItems      :pTBagItems;
  UserItem      :PTUserItem;
  HumMagic      :pTHumMagic;
  UserMagic     :pTUserMagic;
  MagicInfo     :pTMagic;
  StorageItems  :pTStorageItems;
  I             :integer;
begin
  PlayObject.m_sCharName          := HumanRcd.sChrName;
  PlayObject.m_sMapName           := HumanRcd.sCurMap;
  PlayObject.m_nCurrX             := HumanRcd.wCurX;
  PlayObject.m_nCurrY             := HumanRcd.wCurY;
  PlayObject.m_btDirection        := HumanRcd.btDir;
  PlayObject.m_btHair             := HumanRcd.btHair;
  PlayObject.m_btGender           := HumanRcd.btSex;
  PlayObject.m_btJob              := HumanRcd.btJob;
  PlayObject.m_nGold              := HumanRcd.nGold;

  PlayObject.m_Abil.Level         := HumanRcd.Abil.Level;
  PlayObject.m_Abil.HP            := HumanRcd.Abil.HP;
  PlayObject.m_Abil.MP            := HumanRcd.Abil.MP;
  PlayObject.m_Abil.MaxHP         := HumanRcd.Abil.MaxHP;
  PlayObject.m_Abil.MaxMP         := HumanRcd.Abil.MaxMP;
  PlayObject.m_Abil.Exp           := HumanRcd.Abil.Exp;
  PlayObject.m_Abil.MaxExp        := HumanRcd.Abil.MaxExp;
  PlayObject.m_Abil.Weight        := HumanRcd.Abil.Weight;
  PlayObject.m_Abil.MaxWeight     := HumanRcd.Abil.MaxWeight;
  PlayObject.m_Abil.WearWeight    := HumanRcd.Abil.WearWeight;
  PlayObject.m_Abil.MaxWearWeight := HumanRcd.Abil.MaxWearWeight;
  PlayObject.m_Abil.HandWeight    := HumanRcd.Abil.HandWeight;
  PlayObject.m_Abil.MaxHandWeight := HumanRcd.Abil.MaxHandWeight;

  //PlayObject.m_Abil:=HumanRcd.Abil;

  PlayObject.m_wStatusTimeArr     := HumanRcd.wStatusTimeArr;
  PlayObject.m_sHomeMap           := HumanRcd.sHomeMap;
  PlayObject.m_nHomeX             := HumanRcd.wHomeX;
  PlayObject.m_nHomeY             := HumanRcd.wHomeY;
  PlayObject.m_BonusAbil          := HumanRcd.BonusAbil;// 08/09
  PlayObject.m_nBonusPoint        := HumanRcd.nBonusPoint;// 08/09
  PlayObject.m_btCreditPoint      := HumanRcd.btCreditPoint;
  PlayObject.m_btReLevel          := HumanRcd.btReLevel;

  PlayObject.m_sMasterName        := HumanRcd.sMasterName;
  PlayObject.m_boMaster           := HumanRcd.boMaster;
  PlayObject.m_sDearName          := HumanRcd.sDearName;

  PlayObject.m_xLoveInfo          := HumanRcd.xLoveInfo;

  PlayObject.m_sStoragePwd        := HumanRcd.sStoragePwd;
  if PlayObject.m_sStoragePwd <> '' then
    PlayObject.m_boPasswordLocked := True;

  PlayObject.m_nGameGold          := HumanRcd.nGameGold;
  PlayObject.m_nBankGold          := HumanRcd.nBankGold;
  PlayObject.m_nGamePoint         := HumanRcd.nGamePoint;
  PlayObject.m_nPayMentPoint      := HumanRcd.nPayMentPoint;

  PlayObject.m_nPkPoint           := HumanRcd.nPkPoint;
  if HumanRcd.btAllowGroup > 0 then PlayObject.m_boAllowGroup:=True
  else PlayObject.m_boAllowGroup  := False;
  PlayObject.btB2                 := HumanRcd.btF9;
  PlayObject.m_btAttatckMode      := HumanRcd.btAttatckMode;
  PlayObject.m_nIncHealth         := HumanRcd.btIncHealth;
  PlayObject.m_nIncSpell          := HumanRcd.btIncSpell;
  PlayObject.m_nIncHealing        := HumanRcd.btIncHealing;
  PlayObject.m_nFightZoneDieCount := HumanRcd.btFightZoneDieCount;
  PlayObject.m_sUserID            := HumanRcd.sAccount;
  PlayObject.nC4                  := HumanRcd.btEE;
  PlayObject.m_boLockLogon        := HumanRcd.boLockLogon;

  PlayObject.m_wContribution      := HumanRcd.wContribution;
  PlayObject.btC8                 := HumanRcd.btEF;
  PlayObject.m_nHungerStatus      := HumanRcd.nHungerStatus;
  PlayObject.m_boAllowGuildReCall := HumanRcd.boAllowGuildReCall;
  PlayObject.m_wGroupRcallTime    := HumanRcd.wGroupRcallTime;
  PlayObject.m_dBodyLuck          := HumanRcd.dBodyLuck;
  PlayObject.m_boAllowGroupReCall := HumanRcd.boAllowGroupReCall;
  PlayObject.m_QuestUnitOpen      := HumanRcd.QuestUnitOpen;
  PlayObject.m_QuestUnit          := HumanRcd.QuestUnit;
  PlayObject.m_QuestFlag          := HumanRcd.QuestFlag;

  HumItems                           := @HumanRcd.HumItems;
  PlayObject.m_UseItems[U_DRESS]     := HumItems[U_DRESS];
  PlayObject.m_UseItems[U_WEAPON]    := HumItems[U_WEAPON];
  PlayObject.m_UseItems[U_RIGHTHAND] := HumItems[U_RIGHTHAND];
  PlayObject.m_UseItems[U_NECKLACE]  := HumItems[U_HELMET];
  PlayObject.m_UseItems[U_HELMET]    := HumItems[U_NECKLACE];
  PlayObject.m_UseItems[U_ARMRINGL]  := HumItems[U_ARMRINGL];
  PlayObject.m_UseItems[U_ARMRINGR]  := HumItems[U_ARMRINGR];
  PlayObject.m_UseItems[U_RINGL]     := HumItems[U_RINGL];
  PlayObject.m_UseItems[U_RINGR]     := HumItems[U_RINGR];
  PlayObject.m_UseItems[U_BUJUK]     := HumItems[U_BUJUK];
  PlayObject.m_UseItems[U_BELT]      := HumItems[U_BELT];
  PlayObject.m_UseItems[U_BOOTS]     := HumItems[U_BOOTS];
  PlayObject.m_UseItems[U_CHARM]     := HumItems[U_CHARM];
  
  BagItems:=@HumanRcd.BagItems;
  for I := Low(TBagItems) to high(TBagItems) do begin
    if BagItems[i].wIndex > 0 then begin
      New(UserItem);
      UserItem^:=BagItems[i];
      PlayObject.m_ItemList.Add(UserItem);
    end;
  end;
  HumMagic:=@HumanRcd.Magic;
  for I := Low(THumMagic) to high(THumMagic) do begin
    MagicInfo:=UserEngine.FindMagic(HumMagic[i].wMagIdx);
    if MagicInfo <> nil then begin
      New(UserMagic);
      UserMagic.MagicInfo  := MagicInfo;
      UserMagic.wMagIdx    := HumMagic[i].wMagIdx;
      UserMagic.btLevel    := HumMagic[i].btLevel;
      UserMagic.btKey      := HumMagic[i].btKey;
      UserMagic.nTranPoint := HumMagic[i].nTranPoint;
      PlayObject.m_MagicList.Add(UserMagic);
    end;
  end;
  StorageItems:=@HumanRcd.StorageItems;
  for I := Low(TStorageItems) to high(TStorageItems) do begin
    if StorageItems[I].wIndex > 0 then begin
      New(UserItem);
      UserItem^:=StorageItems[I];
      PlayObject.m_StorageItemList.Add(UserItem);
    end;
  end;
end;
//004B1E50
function TUserEngine.GetHomeInfo(nJob:Integer; var nX, nY: Integer): String;
var
  I   :Integer;
  Point:pTStartPoint;
begin
  if g_Config.boJobHomePoint then begin
    case nJob of
      jWarr:begin
        Result := g_Config.sWarriorHomeMap;
        nX     := g_Config.nWarriorHomeX;
        nY     := g_Config.nWarriorHomeY;
      end;
      jWizard:begin
        Result := g_Config.sWizardHomeMap;
        nX     := g_Config.nWizardHomeX;
        nY     := g_Config.nWizardHomeY;
      end;
      jTaos:begin
        Result := g_Config.sTaoistHomeMap;
        nX     := g_Config.nTaoistHomeX;
        nY     := g_Config.nTaoistHomeY;
      end;
      else begin
        Result := g_Config.sHomeMap;
        nX     := g_Config.nHomeX;
        nY     := g_Config.nHomeY;
      end;
    end;
  end else begin
    g_StartPoint.Lock;
    try
      if g_StartPoint.Count > 0 then begin
        if g_StartPoint.Count > 1 then I:=Random(g_Config.nStartPointSize{2})
        else I:=0;
        Point:=g_StartPoint.Items[I];
        Result := Point.sMapName;
        nX     := Point.nX;
        nY     := Point.nY;
      end else begin
        Result := g_Config.sHomeMap;
        nX     := g_Config.nHomeX;
        nX     := g_Config.nHomeY;
      end;
    finally
      g_StartPoint.UnLock;
    end;
  end;
end;
//004DA6DC
function TUserEngine.GetRandHomeX(PlayObject: TPlayObject): Integer;
begin
  Result:=Random(3) + (PlayObject.m_nHomeX - 2) ;
end;
//004DA708
function TUserEngine.GetRandHomeY(PlayObject: TPlayObject): Integer;
begin
  Result:=Random(3) + (PlayObject.m_nHomeY - 2) ;
end;
//004AF2DC
procedure TUserEngine.LoadSwitchData(SwitchData: pTSwitchDataInfo;var
  PlayObject: TPlayObject);
var
  nCount:Integer;
  SlaveInfo: pTSlaveInfo;
begin
  if SwitchData.boC70 then begin

  end;
  
  PlayObject.m_boBanShout     := SwitchData.boBanShout;
  PlayObject.m_boHearWhisper  := SwitchData.boHearWhisper;
  PlayObject.m_boBanGuildChat := SwitchData.boBanGuildChat;
  PlayObject.m_boBanGuildChat := SwitchData.boBanGuildChat;
  PlayObject.m_boAdminMode    := SwitchData.boAdminMode;
  PlayObject.m_boObMode       := SwitchData.boObMode;
  
  nCount:=0;
  while (True) do begin
    if SwitchData.BlockWhisperArr[nCount] = '' then break;
    PlayObject.m_BlockWhisperList.Add(SwitchData.BlockWhisperArr[nCount]);
    Inc(nCount);
    if nCount >= High(SwitchData.BlockWhisperArr) then break;
  end;

  nCount:=0;
  while (True) do begin //004AF3CA
    if SwitchData.SlaveArr[nCount].sSlaveName = '' then break;
    New(SlaveInfo);
    SlaveInfo^:=SwitchData.SlaveArr[nCount];
    PlayObject.SendDelayMsg(PlayObject,RM_10401,0,Integer(SlaveInfo),0,0,'',500);
    Inc(nCount);
    if nCount >= 5 then break;
  end;

  nCount:=0;
  while (True) do begin //004AF3CA
    PlayObject.m_wStatusArrValue[nCount]:=SwitchData.StatusValue[nCount];
    PlayObject.m_dwStatusArrTimeOutTick[nCount]:=SwitchData.StatusTimeOut[nCount];
    Inc(nCount);
    if nCount >= 6 then break;
  end;
end;
//004AF4A4 
procedure TUserEngine.DelSwitchData(SwitchData: pTSwitchDataInfo);
var
  I: Integer;
  SwitchDataInfo: pTSwitchDataInfo;
begin
  for I := 0 to m_ChangeServerList.Count - 1 do begin
    SwitchDataInfo:=m_ChangeServerList.Items[i];
    if SwitchDataInfo = SwitchData then begin
      Dispose(SwitchDataInfo);
      m_ChangeServerList.Delete(I);
      break;
    end;
  end;    // for
end;

//004AE398
function TUserEngine.FindMagic(nMagIdx: Integer): pTMagic;
var
  I: Integer;
  Magic:pTMagic;
begin
  Result:=nil;
    for I := 0 to m_MagicList.Count - 1 do begin
      Magic:=m_MagicList.Items[i];
      if Magic.wMagicId = nMagIdx then begin
        Result:=Magic;
        break;
      end;
    end;
end;

//004ACE94
procedure TUserEngine.MonInitialize(BaseObject: TBaseObject; sMonName: String);
var
  I: Integer;
  Monster:pTMonInfo;
begin
    for I := 0 to MonsterList.Count - 1 do begin
      Monster:=MonsterList.Items[i];
      if CompareText(Monster.sName,sMonName) = 0 then begin
        BaseObject.m_btRaceServer:=Monster.btRace;
        BaseObject.m_btRaceImg:=Monster.btRaceImg;
        BaseObject.m_wAppr:=Monster.wAppr;
        BaseObject.m_Abil.Level:=Monster.wLevel;
        BaseObject.m_btLifeAttrib:=Monster.btLifeAttrib ;
        BaseObject.m_btCoolEye:=Monster.wCoolEye ;
        BaseObject.m_dwFightExp:=Monster.dwExp;
        BaseObject.m_Abil.HP:=Monster.wHP;
        BaseObject.m_Abil.MaxHP:=Monster.wHP;
        BaseObject.m_btMonsterWeapon:=LoByte(Monster.wMP);
        //BaseObject.m_Abil.MP:=Monster.wMP;
        BaseObject.m_Abil.MP:=0;
        BaseObject.m_Abil.MaxMP:=Monster.wMP;
        BaseObject.m_Abil.AC:=MakeLong(Monster.wAC,Monster.wAC);
        BaseObject.m_Abil.MAC:=MakeLong(Monster.wMAC,Monster.wMAC);
        BaseObject.m_Abil.DC:=MakeLong(Monster.wDC,Monster.wMaxDC);
        BaseObject.m_Abil.MC:=MakeLong(Monster.wMC,Monster.wMC);
        BaseObject.m_Abil.SC:=MakeLong(Monster.wSC,Monster.wSC);
        BaseObject.m_btSpeedPoint:=Monster.wSpeed;
        BaseObject.m_btHitPoint:=Monster.wHitPoint;
        BaseObject.m_nWalkSpeed:=Monster.wWalkSpeed;
        BaseObject.m_nWalkStep:=Monster.wWalkStep;
        BaseObject.m_dwWalkWait:=Monster.wWalkWait;
        BaseObject.m_nNextHitTime:=Monster.wAttackSpeed;
        BaseObject.m_boNastyMode:=Monster.boAggro;
        BaseObject.m_boNoTame:=Monster.boTame;
        break;
      end;
    end;
end;

function TUserEngine.OpenDoor(Envir: TEnvirnoment; nX,
  nY: Integer): Boolean; //004AC698
var
  Door:pTDoorInfo;
begin
  Result:=False;
  Door:=Envir.GetDoor(nX,nY);
  if (Door <> nil) and not Door.Status.boOpened and not Door.Status.bo01 then begin
    Door.Status.boOpened:=True;
    Door.Status.dwOpenTick:=GetTickCount();
    SendDoorStatus(Envir,nX,nY,RM_DOOROPEN,0,nX,nY,0,'');
    Result:=True;
  end;    
end;
function TUserEngine.CloseDoor(Envir: TEnvirnoment; Door:pTDoorInfo): Boolean; //004AC77B
begin
  Result:=False;
  if (Door <> nil) and (Door.Status.boOpened) then begin
    Door.Status.boOpened:=False;
    SendDoorStatus(Envir,Door.nX,Door.nY,RM_DOORCLOSE,0,Door.nX,Door.nY,0,'');
    Result:=True;
  end;
end;

procedure TUserEngine.SendDoorStatus(Envir: TEnvirnoment; nX, nY: Integer;
  wIdent, wX: Word; nDoorX, nDoorY, nA: Integer;sStr:String);  //004AC518
var
  I: Integer;
  n10,n14: Integer;
  n1C,n20,n24,n28:Integer;
  MapCellInfo:pTMapCellinfo;
  OSObject:pTOSObject;
  BaseObject:TBaseObject;
begin
  n1C:=nX - 12;
  n24:=nX + 12;
  n20:=nY - 12;
  n28:=nY + 12;
  for n10:= n1C to n24 do begin
    for n14:= n20 to n28 do begin
      if Envir.GetMapCellInfo(n10,n14,MapCellInfo) and (MapCellInfo.ObjList <> nil) then begin
        for I := 0 to MapCellInfo.ObjList.Count - 1 do begin
          OSObject:=MapCellInfo.ObjList.Items[i];
          if (OSObject <> nil) and (OSObject.btType = OS_MOVINGOBJECT) then begin
            BaseObject:=TBaseObject(OSObject.CellObj);
            if (BaseObject <> nil) and
               (not BaseObject.m_boGhost) and
               (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
              BaseObject.SendMsg(BaseObject,wIdent,wX,nDoorX,nDoorY,nA,sStr);
            end;
          end;            
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessMapDoor; //004AC78C
var
  I     :Integer;
  II    :Integer;
  Envir :TEnvirnoment;
  Door  :pTDoorInfo;
begin
  for I:= 0 to g_MapManager.Count - 1 do begin
    Envir:=TEnvirnoment(g_MapManager.Items[I]);
    for II:= 0 to Envir.m_DoorList.Count - 1 do begin
      Door:=Envir.m_DoorList.Items[II];
      if Door.Status.boOpened then begin
        if (GetTickCount - Door.Status.dwOpenTick) > 5 * 1000 then
          CloseDoor(Envir,Door);
      end;
    end;
  end;
end;

procedure TUserEngine.ProcessEffects; //004AC78C
var
  I     :Integer;
  II    :Integer;
  III   :Integer;
  x,y   :Integer;
  Envir :TEnvirnoment;
  Amount:Integer;
begin
  for I:= 0 to EffectList.Count - 1 do begin
    Envir:=TEnvirnoment(EffectList.Items[I]);
    Amount:=GetMapHuman(Envir.sMapName);//thedeath: need to configure this
    Amount:=(Amount * 2) * ((Envir.Header.wWidth * Envir.Header.wHeight) div 2500);

    for II:= 0 to Amount do begin
      x:= Random(Envir.Header.wWidth);
      y:= Random(Envir.Header.wHeight);
      III:=0;
      while (Envir.CanWalk(x,y,TRUE) = TRUE) and (III <= 10) do
      begin
        inc(III);
      end;

      EffectTarget(x,y,Envir);

    end;

  end;
  envir:=nil;
end;

procedure TUserEngine.SaveUsrLog();
var
  i:Integer;
  sTxt:String;
  LogFile :TextFile;
  PlayObject:TPlayObject;
ResourceString
  sExceptionMsg = '[Exception] TUserEngine::SaveUsrLog()';
begin
  try
    if (GetTickCount() - dwProcessUsrLogTick) > 8*60*1000 {8 mins} then begin
      dwProcessUsrLogTick:=GetTickCount();

      AssignFile(LogFile, sUsrLogFileName);
      Rewrite(LogFile);

      WriteLn(LogFile, ';����, �Ա�, Class, ����ģʽ, �ȼ�, ��ͼ, Co-Ord, �û�ID, IP, GM');

      try
        EnterCriticalSection(ProcessHumanCriticalSection);
        for i := 0 to m_PlayObjectList.Count - 1 do begin
          PlayObject := m_PlayObjectList.Objects[i] as TPlayObject;

          sTxt := Format('%s,%d,%d,%d,%d,%s,%d-%d,%s,%s,%d',
                         [PlayObject.m_sCharName,PlayObject.m_btGender,PlayObject.m_btJob,
                         PlayObject.m_btAttatckMode,PlayObject.m_Abil.Level,PlayObject.m_sMapName,PlayObject.m_nCurrX,PlayObject.m_nCurrY,
                         PlayObject.m_sUserID,PlayObject.m_sIPaddr,PlayObject.m_btPermission]);

          WriteLn(LogFile, sTxt);
        end;
      finally
        LeaveCriticalSection(ProcessHumanCriticalSection);
      end;

      CloseFile(LogFile);
    end;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

procedure TUserEngine.ProcessEvents; //004AED70
var
  I,II,III   :Integer;
  MagicEvent :pTMagicEvent;
  BaseObject :TBaseObject;
begin
  for I := m_MagicEventList.Count - 1 downto 0 do begin
    MagicEvent:=m_MagicEventList.Items[I];
    if MagicEvent <> nil then begin
      for II := MagicEvent.BaseObjectList.Count - 1 downto 0 do begin
        BaseObject:=TBaseObject(MagicEvent.BaseObjectList.Items[II]);
        if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (not BaseObject.m_boHolySeize) then begin
          MagicEvent.BaseObjectList.Delete(II);
        end;
      end;
      if (MagicEvent.BaseObjectList.Count <= 0) or
         ((GetTickCount - MagicEvent.dwStartTick) > MagicEvent.dwTime) or
         ((GetTickCount - MagicEvent.dwStartTick) > 180000) then begin
        MagicEvent.BaseObjectList.Free;
        III:=0;
        while (True) do begin
          if MagicEvent.Events[III] <> nil then begin
            MagicEvent.Events[III].Close();
          end;
          Inc(III);
          if III >= 8 then break;
        end;
        Dispose(MagicEvent);
        m_MagicEventList.Delete(I);
      end;
    end;      
  end;
end;

function TUserEngine.FindMagic(sMagicName: String): pTMagic; //004AE2E4
var
  I: Integer;
  Magic:pTMagic;
begin
  Result:=nil;
    for I := 0 to m_MagicList.Count - 1 do begin
      Magic:=m_MagicList.Items[i];
      if CompareText(Magic.sMagicName,sMagicName) = 0 then begin
        Result:=Magic;
        break;
      end;
    end;
end;
function TUserEngine.GetMapRangeMonster(Envir:TEnvirnoment;nX,nY,nRange:Integer;List:TList):Integer;
var
  I,II: Integer;
  MonGen:pTMonGenInfo;
  BaseObject:TBaseObject;
begin
  Result:=0;
  if Envir = nil then exit;
  for I := 0 to m_MonGenList.Count - 1 do begin
    MonGen:=m_MonGenList.Items[I];
    if (MonGen = nil) then Continue;
    if (MonGen.Envir <> nil) and (MonGen.Envir <> Envir) then Continue;

    for II := 0 to MonGen.CertList.Count - 1 do begin
      BaseObject:=TBaseObject(MonGen.CertList.Items[II]);
      if not BaseObject.m_boDeath and not BaseObject.m_boGhost and (BaseObject.m_PEnvir = Envir) and (abs(BaseObject.m_nCurrX - nX) <= nRange) and (abs(BaseObject.m_nCurrY - nY) <= nRange) then begin
        if List <> nil then List.Add(BaseObject);
        Inc(Result);
      end;
    end;
  end;
end;

procedure TUserEngine.AddMerchant(Merchant:TMerchant);
begin
  UserEngine.m_MerchantList.Lock;
  try
    UserEngine.m_MerchantList.Add(Merchant);
  finally
    UserEngine.m_MerchantList.UnLock;
  end;
end;

function TUserEngine.GetMerchantList(Envir: TEnvirnoment; nX, nY,
  nRange: Integer; TmpList: TList): Integer; //004ACB84
var
  I: Integer;
  Merchant:TMerchant;
begin
  m_MerchantList.Lock;
  try
    for I := 0 to m_MerchantList.Count - 1 do begin
      Merchant:=TMerchant(m_MerchantList.Items[i]);
      if (Merchant.m_PEnvir = Envir) and
         (abs(Merchant.m_nCurrX - nX) <= nRange) and
         (abs(Merchant.m_nCurrY - nY) <= nRange) then begin

        TmpList.Add(Merchant);
      end;
    end;    // for
  finally
    m_MerchantList.UnLock;
  end;
  Result:=TmpList.Count
end;
function TUserEngine.GetNpcList(Envir: TEnvirnoment; nX, nY,
  nRange: Integer; TmpList: TList): Integer;
var
  I: Integer;
  Npc:TNormNpc;
begin
  for I := 0 to QuestNPCList.Count - 1 do begin
    Npc:=TNormNpc(QuestNPCList.Items[i]);
    if (Npc.m_PEnvir = Envir) and
       (abs(Npc.m_nCurrX - nX) <= nRange) and
       (abs(Npc.m_nCurrY - nY) <= nRange) then begin

      TmpList.Add(Npc);
    end;
  end;    // for
  Result:=TmpList.Count
end;
procedure TUserEngine.ReloadMerchantList();
var
  I: Integer;
  Merchant:TMerchant;
begin
  m_MerchantList.Lock;
  try
    for I := 0 to m_MerchantList.Count - 1 do begin
      Merchant:=TMerchant(m_MerchantList.Items[i]);
      if not Merchant.m_boGhost then begin
        Merchant.ClearScript;
        Merchant.LoadNPCScript;
      end;
    end;    // for
  finally
    m_MerchantList.UnLock;
  end;
end;
procedure TUserEngine.ReloadNpcList();
var
  I: Integer;
  Npc:TNormNpc;
begin
  for I := 0 to QuestNPCList.Count - 1 do begin
    Npc:=TNormNpc(QuestNPCList.Items[i]);
    Npc.ClearScript;
    Npc.LoadNPCScript;
  end; 
end;
function TUserEngine.GetMapMonster(Envir: TEnvirnoment; List: TList): Integer; //004AE20C
var
  I,II: Integer;
  MonGen:pTMonGenInfo;
  BaseObject:TBaseObject;
begin
  Result:=0;
  if Envir = nil then exit;
  for I := 0 to m_MonGenList.Count - 1 do begin
    MonGen:=m_MonGenList.Items[I];
    if MonGen = nil then Continue;
    for II := 0 to MonGen.CertList.Count - 1 do begin
      BaseObject:=TBaseObject(MonGen.CertList.Items[II]);
      if not BaseObject.m_boDeath and not BaseObject.m_boGhost and (BaseObject.m_PEnvir = Envir) then begin
        if List <> nil then List.Add(BaseObject);
        Inc(Result);
      end;
    end;
  end;
end;

procedure TUserEngine.HumanExpire(sAccount: String);//004AFBB0
var
  I          :Integer;
  PlayObject :TPlayObject;
begin
  if not g_Config.boKickExpireHuman then exit;    
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject:=TPlayObject(m_PlayObjectList.Objects[I]);
    if CompareText(PlayObject.m_sUserID,sAccount) = 0  then begin
      PlayObject.m_boExpire:=True;
      break;
    end;
  end;
end;

function TUserEngine.GetMapHuman(sMapName: String): Integer; //004AE954
var
  I: Integer;
  Envir: TEnvirnoment;
  PlayObject:TPlayObject;
begin
  Result:=0;
  Envir:=g_MapManager.FindMap(sMapName);
  if Envir = nil then exit;
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject:=TPlayObject(m_PlayObjectList.Objects[I]);
    if not PlayObject.m_boDeath and not PlayObject.m_boGhost and
      (PlayObject.m_PEnvir = Envir)then
      Inc(Result);
  end;
end;

function TUserEngine.GetMapRageHuman(Envir: TEnvirnoment; nRageX,
  nRageY,nRage:Integer;List: TList): Integer; //004AE8AC
var
  I: Integer;
  PlayObject:TPlayObject;
begin
  Result:=0;
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject:=TPlayObject(m_PlayObjectList.Objects[I]);
    if not PlayObject.m_boDeath and
       not PlayObject.m_boGhost and
       (PlayObject.m_PEnvir = Envir) and
       (abs(PlayObject.m_nCurrX - nRageX) <= nRage) and
       (abs(PlayObject.m_nCurrY - nRageY) <= nRage) then begin
      List.Add(PlayObject);
      Inc(Result);
    end;
  end;
end;

function TUserEngine.GetStdItemIdx(sItemName: String): Integer;
var
  I: Integer;
  Item:TItem;
begin
  Result:= -1;
  if sItemName = '' then exit;
    for I := 0 to StdItemList.Count - 1 do begin
      Item:=StdItemList.Items[i];
      if CompareText(Item.Name,sItemName) = 0 then begin
        Result:= I + 1;
        break;
      end;
    end;
end;
//==========================================
//��ÿ�����﷢����Ϣ
//�̰߳�ȫ
//==========================================
procedure TUserEngine.SendBroadCastMsgExt(sMsg: String;MsgType:TMsgType); //004AEAF0
var
  I: Integer;
  PlayObject:TPlayObject;
begin
  try
    EnterCriticalSection(ProcessHumanCriticalSection);
    for I := 0 to m_PlayObjectList.Count - 1 do begin
      PlayObject:=TPlayObject(m_PlayObjectList.Objects[I]);
      if not PlayObject.m_boGhost then
        PlayObject.SysMsg(sMsg,c_Red,MsgType);
    end;
  finally
    LeaveCriticalSection(ProcessHumanCriticalSection);
  end;
end;

procedure TUserEngine.SendBroadCastMsg(sMsg: String;MsgType:TMsgType); //004AEAF0
var
  I: Integer;
  PlayObject:TPlayObject;
begin
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject:=TPlayObject(m_PlayObjectList.Objects[i]);
    if not PlayObject.m_boGhost then
      PlayObject.SysMsg(sMsg,c_Red,MsgType);
  end;
end;


procedure TUserEngine.sub_4AE514(GoldChangeInfo: pTGoldChangeInfo); //004AE514
var
  GoldChange:pTGoldChangeInfo;
begin
  New(GoldChange);
  GoldChange^:=GoldChangeInfo^;
  EnterCriticalSection(m_LoadPlaySection);
  try
    m_ChangeHumanDBGoldList.Add(GoldChange);
  finally
    LeaveCriticalSection(m_LoadPlaySection);
  end;
end;
procedure TUserEngine.ClearMonSayMsg;
var
  I,II: Integer;
  MonGen:pTMonGenInfo;
  MonBaseObject:TBaseObject;
begin
  for I := 0 to m_MonGenList.Count - 1 do begin
    MonGen:=m_MonGenList.Items[I];
    for II := 0 to MonGen.CertList.Count - 1 do begin
      MonBaseObject:=TBaseObject(MonGen.CertList.Items[II]);
      MonBaseObject.m_SayMsgList:=nil;
    end;
  end;
end;

procedure TUserEngine.PrcocessData;
var
  dwUsrTimeTick:LongWord;
  sMsg:String;
ResourceString
  sExceptionMsg = '[Exception] TUserEngine::ProcessData';
begin
  try
    dwUsrTimeTick:=GetTickCount();

    ProcessHumans();
    if g_Config.boSendOnlineCount and (GetTickCount - g_dwSendOnlineTick > g_Config.dwSendOnlineTime) then begin
      g_dwSendOnlineTick:=GetTickCount();
      sMsg:=AnsiReplaceText(g_sSendOnlineCountMsg,'%c',IntToStr(ROUND(GetOnlineHumCount * (g_Config.nSendOnlineCountRate / 10))));
      SendBroadCastMsg(sMsg,t_System)
    end;

//      ProcessMonsters();

//      if (GetTickCount() - dwProcessMonstersTick) > g_Config.dwProcessMonstersTime then begin
//        dwProcessMonstersTick:=GetTickCount();
        ProcessMonsters();
//      end;


      ProcessMerchants();

      ProcessNpcs();

      if (GetTickCount() - dwProcessMissionsTime) > 1000 then begin
        dwProcessMissionsTime:=GetTickCount();
        ProcessMissions();
        ProcessEvents();
      end;

      if (GetTickCount() - dwProcessMapDoorTick) > 500 then begin
        dwProcessMapDoorTick:=GetTickCount();
        ProcessMapDoor();
      end;
      if (GetTickCount() - dwProcessEffectsTick) > 1000 then begin
        dwProcessEffectsTick:=GetTickCount();
        ProcessEffects();
      end;

      SaveUsrLog;

    g_nUsrTimeMin:=GetTickCount() - dwUsrTimeTick;
    if g_nUsrTimeMax < g_nUsrTimeMin then g_nUsrTimeMax:=g_nUsrTimeMin;
  except
    MainOutMessage(sExceptionMsg);
  end;
end;

function TUserEngine.MapRageHuman(sMapName: String; nMapX, nMapY,
  nRage: Integer): Boolean;
var
  nX,nY:Integer;
  Envir:TEnvirnoment;
begin
  Result:=False;
  Envir:=g_MapManager.FindMap(sMapName);
  if Envir <> nil then begin
    for nX:= nMapX - nRage to nMapX + nRage do begin
      for nY:= nMapY - nRage to nMapY + nRage do begin
        if Envir.GetXYHuman(nMapX, nMapY) then begin
          Result:=True;
          exit;
        end;
      end;
    end;
  end;
end;

procedure TUserEngine.SendQuestMsg(sQuestName:String);
var
  I:Integer;
  PlayObject:TPlayObject;
begin
  for I := 0 to m_PlayObjectList.Count - 1 do begin
    PlayObject:=TPlayObject(m_PlayObjectList.Objects[I]);
    if not PlayObject.m_boDeath and not PlayObject.m_boGhost then
      g_ManageNPC.GotoLable(PlayObject,sQuestName,False);
  end;
end;
procedure TUserEngine.ClearItemList();
var
  I: Integer;
begin
  I:=0;
  while (True) do begin
    StdItemList.Exchange(Random(StdItemList.Count),StdItemList.Count -1);
    Inc(I);
    if I >= StdItemList.Count then break;
  end;
  ClearMerchantData();
end;
procedure TUserEngine.SwitchMagicList();
begin
  if m_MagicList.Count > 0 then begin
    OldMagicList.Add(m_MagicList);
    m_MagicList:=TList.Create;
  end;
end;
procedure TUserEngine.ClearMerchantData();
var
  I: Integer;
  Merchant:TMerchant;
begin
  m_MerchantList.Lock;
  try
    for I := 0 to m_MerchantList.Count - 1 do begin
      Merchant:=TMerchant(m_MerchantList.Items[I]);
      Merchant.ClearData();
    end;
  finally
    m_MerchantList.UnLock;
  end;
end;
initialization
begin
  {---- Adjust global SVN revision ----}
  SVNRevision('$Id: UsrEngn.pas 596 2007-04-11 00:14:13Z sean $');
end;
finalization
begin

end;

end.
