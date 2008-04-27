unit Magic;

interface
uses
  Windows, Classes, Grobal2, ObjBase, SysUtils;
type
  TMagicManager = class
  private


  public
    constructor Create();
    destructor Destroy; override;
    function MagMakePrivateTransparent(BaseObject: TBaseObject; nHTime: Integer): Boolean;
    function IsWarrSkill(wMagIdx: Integer): Boolean;
    function DoSpell(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;

    function MagBigHealing(PlayObject: TBaseObject; nPower, nX, nY: Integer): Boolean;
    function MagPushArround(PlayObject: TBaseObject; nPushLevel: Integer): Integer;
    function MagTurnUndead(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nLevel: Integer): Boolean;
    function MagMakeHolyCurtain(BaseObject: TBaseObject; nPower: Integer; nX, nY: Integer): Integer;
    function MagMakeGroupTransparent(BaseObject: TBaseObject; nX, nY: Integer; nHTime: Integer): Boolean;
    function MagTamming(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY: Integer; nMagicLevel: Integer): Boolean;
    function MagSaceMove(BaseObject: TBaseObject; nLevel: Integer): Boolean;
    function MagMakeFireCross(PlayObject: TPlayObject; nDamage, nHTime, nX, nY: Integer): Integer;
    function MagBigExplosion(BaseObject: TBaseObject; nPower, nX, nY: Integer; nRage: Integer): Boolean;
    function MagElecBlizzard(BaseObject: TBaseObject; nPower: Integer): Boolean;
    function MabMabe(BaseObject, TargeTBaseObject: TBaseObject; nPower, nLevel, nTargetX, nTargetY: Integer): Boolean;
    function MagMakeSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
    function MagMakeSelf(BaseObject, TargeTBaseObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
    function MagMakeSinSuSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
    function MagWindTebo(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
    function MagGroupLightening(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
    function MagGroupAmyounsul(PlayObject: TBaseObject {�޸� TBaseObject}; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagGroupDeDing(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagGroupMb(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagHbFireBall(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagReturn(BaseObject, TargeTBaseObject: TBaseObject; nTargetX, nTargetY, nMagicLevel: Integer): Boolean;
    function MagMakeSlave_(PlayObject: TPlayObject; UserMagic: pTUserMagic; sMonName: string; nCount, nHumLevel, nMonLevel: Integer): Boolean;
    function MagLightening(PlayObject: TBaseObject {�޸� TBaseObject}; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
    function MagMakeSuperFireCross(PlayObject: TPlayObject; nDamage, nHTime, nX, nY: Integer; nCount: Integer): Integer;

    function MagMakeFireball(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagTreatment(PlayObject: TPlayObject; UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeHellFire(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeQuickLighting(PlayObject: TPlayObject; UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeLighting(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeFireCharm(PlayObject: TBaseObject { �޸� TBaseObject}; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeUnTreatment(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeLivePlayObject(PlayObject: TPlayObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeArrestObject(PlayObject: TPlayObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
    function MagChangePosition(PlayObject: TPlayObject; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
    function MagMakeFireDay(PlayObject: TPlayObject; UserMagic: pTUserMagic; nTargetX, nTargetY: Integer; var TargeTBaseObject: TBaseObject): Boolean;

  end;
function MPow(UserMagic: pTUserMagic): Integer;
function GetPower(nPower: Integer; UserMagic: pTUserMagic): Integer;
function GetPower13(nInt: Integer; UserMagic: pTUserMagic): Integer;
function GetRPow(wInt: Integer): Word;
function CheckAmulet(PlayObject: TBaseObject { �޸� TBaseObject}; nCount: Integer; nType: Integer; var Idx: Integer): Boolean;
procedure UseAmulet(PlayObject: TBaseObject { �޸� TBaseObject}; nCount: Integer; nType: Integer; var Idx: Integer);

implementation

uses HUtil32, M2Share, Event, Envir, PlugOfEngine;

function MPow(UserMagic: pTUserMagic): Integer;
begin
  Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
end;
function GetPower(nPower: Integer; UserMagic: pTUserMagic): Integer;
begin
  Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
end;

function GetPower13(nInt: Integer; UserMagic: pTUserMagic): Integer;
var
  d10: Double;
  d18: Double;
begin
  d10 := nInt / 3.0;
  d18 := nInt - d10;
  Result := ROUND(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)));
end;
function GetRPow(wInt: Integer): Word;
begin
  if HiWord(wInt) > LoWord(wInt) then begin
    Result := Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt);
  end else Result := LoWord(wInt);
end;
//nType Ϊָ������ 1 Ϊ����� 2 Ϊ��ҩ
function CheckAmulet(PlayObject: TBaseObject {�޸� TBaseObject}; nCount: Integer; nType: Integer; var Idx: Integer): Boolean;
var
  AmuletStdItem: pTStdItem;
begin
  Result := False;
  Idx := 0;
  if PlayObject.m_UseItems[U_ARMRINGL].wIndex > 0 then begin
    AmuletStdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[U_ARMRINGL].wIndex);
    if (AmuletStdItem <> nil) and (AmuletStdItem.StdMode = 25) then begin
      case nType of
        1: begin
            if (AmuletStdItem.Shape = 5) and (ROUND(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
              Idx := U_ARMRINGL;
              Result := True;
              Exit;
            end;
          end;
        2: begin
            if (AmuletStdItem.Shape <= 2) and (ROUND(PlayObject.m_UseItems[U_ARMRINGL].Dura / 100) >= nCount) then begin
              Idx := U_ARMRINGL;
              Result := True;
              Exit;
            end;
          end;
      end;
    end;
  end;

  if PlayObject.m_UseItems[U_BUJUK].wIndex > 0 then begin
    AmuletStdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[U_BUJUK].wIndex);
    if (AmuletStdItem <> nil) and (AmuletStdItem.StdMode = 25) then begin
      case nType of //
        1: begin
            if (AmuletStdItem.Shape = 5) and (ROUND(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
              Idx := U_BUJUK;
              Result := True;
              Exit;
            end;
          end;
        2: begin
            if (AmuletStdItem.Shape <= 2) and (ROUND(PlayObject.m_UseItems[U_BUJUK].Dura / 100) >= nCount) then begin
              Idx := U_BUJUK;
              Result := True;
              Exit;
            end;
          end;
      end;
    end;
  end;
end;
//nType Ϊָ������ 1 Ϊ����� 2 Ϊ��ҩ
procedure UseAmulet(PlayObject: TBaseObject; nCount: Integer; nType: Integer; var Idx: Integer);
begin
  if PlayObject.m_UseItems[Idx].Dura > nCount * 100 then begin
    Dec(PlayObject.m_UseItems[Idx].Dura, nCount * 100);
    PlayObject.SendMsg(PlayObject, RM_DURACHANGE, Idx, PlayObject.m_UseItems[Idx].Dura, PlayObject.m_UseItems[Idx].DuraMax, 0, '');
  end else begin
    PlayObject.m_UseItems[Idx].Dura := 0;
    if PlayObject.m_btRaceServer = RC_PLAYOBJECT then
      TPlayObject(PlayObject).SendDelItems(@PlayObject.m_UseItems[Idx]);
    PlayObject.m_UseItems[Idx].wIndex := 0;
  end;
end;

function TMagicManager.MagPushArround(PlayObject: TBaseObject; nPushLevel: Integer): Integer; //00492204
var
  i, nDir, levelgap, push: Integer;
  BaseObject: TBaseObject;
begin
  Result := 0;
  for i := 0 to PlayObject.m_VisibleActors.Count - 1 do begin
    BaseObject := TBaseObject(pTVisibleBaseObject(PlayObject.m_VisibleActors[i]).BaseObject);
    if (abs(PlayObject.m_nCurrX - BaseObject.m_nCurrX) <= 1) and (abs(PlayObject.m_nCurrY - BaseObject.m_nCurrY) <= 1) then begin
      if (not BaseObject.m_boDeath) and (BaseObject <> PlayObject) then begin
        if (PlayObject.m_Abil.Level >= BaseObject.m_Abil.Level) and (not BaseObject.m_boStickMode) then begin
          levelgap := PlayObject.m_Abil.Level - BaseObject.m_Abil.Level;
          if (Random(20) < 6 + nPushLevel * 3 + levelgap) then begin
            if PlayObject.IsProperTarget(BaseObject) then begin
              push := 1 + _MAX(0, nPushLevel - 1) + Random(2);
              nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, BaseObject.m_nCurrX, BaseObject.m_nCurrY);
              BaseObject.CharPushed(nDir, push);
              Inc(Result);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TMagicManager.MagBigHealing(PlayObject: TBaseObject; nPower, nX, nY: Integer): Boolean; //00492E50
var
  i: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nX, nY, 1, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    BaseObject := TBaseObject(BaseObjectList[i]);
    if PlayObject.IsProperFriend(BaseObject) then begin
      if BaseObject.m_WAbil.HP < BaseObject.m_WAbil.MaxHP then begin
        BaseObject.SendDelayMsg(PlayObject, RM_MAGHEALING, 0, nPower, 0, 0, '', 800);
        //BaseObject.SendMsg(PlayObject, RM_MAGHEALING, 0, nPower, 0, 0, '');
        Result := True;
      end;
      if PlayObject.m_boAbilSeeHealGauge then begin
        PlayObject.SendMsg(BaseObject, RM_10414, 0, 0, 0, 0, ''); //?? RM_INSTANCEHEALGUAGE
      end;
    end;
  end;
  BaseObjectList.Free;
end;

constructor TMagicManager.Create;
begin

end;

destructor TMagicManager.Destroy;
begin

  inherited;
end;
{����}
function TMagicManager.MagMakeFireball(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
begin
  Result := False;
  if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin
      if (TargeTBaseObject.m_nAntiMagic <= Random(10)) and (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 1) then begin
        with PlayObject do begin
          nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC),
            SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
        end;
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
        //PlayObject.SendMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '');
        if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then Result := True;
      end else
        TargeTBaseObject := nil;
    end else
      TargeTBaseObject := nil;
  end else
    TargeTBaseObject := nil;
end;

{������}
function TMagicManager.MagTreatment(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer;
  var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
begin
  Result := False;
  if TargeTBaseObject = nil then begin
    TargeTBaseObject := PlayObject;
    nTargetX := PlayObject.m_nCurrX;
    nTargetY := PlayObject.m_nCurrY;
  end;
  if PlayObject.IsProperFriend(TargeTBaseObject) then begin
    nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC) * 2,
      SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) * 2 + 1);
    if TargeTBaseObject.m_WAbil.HP < TargeTBaseObject.m_WAbil.MaxHP then begin
      TargeTBaseObject.SendDelayMsg(PlayObject, RM_MAGHEALING, 0, nPower, 0, 0, '', 800);
      //TargeTBaseObject.SendMsg(PlayObject, RM_MAGHEALING, 0, nPower, 0, 0, '');
      Result := True;
    end;
    if PlayObject.m_boAbilSeeHealGauge then
      PlayObject.SendMsg(TargeTBaseObject, RM_10414, 0, 0, 0, 0, '');
  end;
end;

{�����}
function TMagicManager.MagMakeHellFire(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  n1C: Integer;
  n14, n18: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
begin
  Result := False;
  n1C := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, nTargetX, nTargetY);
  if PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 1, n14, n18) then begin
    PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 5, nTargetX, nTargetY);
    nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
      SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
    if PlayObject.MagPassThroughMagic(n14, n18, nTargetX, nTargetY, n1C, nPower, False) > 0 then
      Result := True;
  end;
end;

{�����Ӱ}
function TMagicManager.MagMakeQuickLighting(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; var nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  n1C: Integer;
  n14, n18: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
begin
  Result := False;
  n1C := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, nTargetX, nTargetY);
  if PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 1, n14, n18) then begin
    PlayObject.m_PEnvir.GetNextPosition(PlayObject.m_nCurrX, PlayObject.m_nCurrY, n1C, 8, nTargetX, nTargetY);
    nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
      SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
    if PlayObject.MagPassThroughMagic(n14, n18, nTargetX, nTargetY, n1C, nPower, True) > 0 then
      Result := True;
  end;
end;

{�׵���}
function TMagicManager.MagMakeLighting(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
begin
  Result := False;
  if PlayObject.IsProperTarget(TargeTBaseObject) then begin
    if (Random(10) >= TargeTBaseObject.m_nAntiMagic) then begin
      nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
        SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
      if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
        nPower := ROUND(nPower * 1.5);
      PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
      //PlayObject.SendMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '');
      if PlayObject.m_btRaceServer = RC_PLAYMOSTER then Result := True
      else if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
    end else TargeTBaseObject := nil
  end else TargeTBaseObject := nil;
end;


{�����}
function TMagicManager.MagMakeFireCharm(PlayObject: TBaseObject; {�޸� TBaseObject}
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
begin
  Result := False;
  if PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin
    if PlayObject.IsProperTarget(TargeTBaseObject) then begin
      if Random(10) >= TargeTBaseObject.m_nAntiMagic then begin
        if (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 1) then begin
          nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC),
            SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
          PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 1200);
          //PlayObject.SendMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '');
          if PlayObject.m_btRaceServer = RC_PLAYMOSTER then Result := True
          else if (PlayObject.m_btRaceServer = RC_PLAYOBJECT) and (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then Result := True;

        end;
      end;
    end;
  end else TargeTBaseObject := nil;
end;

{�����}
function TMagicManager.MagMakeFireDay(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  function MPow(UserMagic: pTUserMagic): Integer;
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower: Integer): Integer;
  begin
    Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
begin
  Result := False;
  if PlayObject.IsProperTarget(TargeTBaseObject) then begin
    if (Random(10) >= TargeTBaseObject.m_nAntiMagic) then begin
      nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
        SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
      if TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD then
        nPower := ROUND(nPower * 1.5);
      PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
      //PlayObject.SendMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '');
      if g_Config.boPlayObjectReduceMP then TargeTBaseObject.DamageSpell(nPower);
      if PlayObject.m_btRaceServer = RC_PLAYMOSTER then Result := True
      else if TargeTBaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
    end else TargeTBaseObject := nil
  end else TargeTBaseObject := nil;
end;

{�ⶾ��}
function TMagicManager.MagMakeUnTreatment(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  var TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := False;
  if TargeTBaseObject = nil then begin
    TargeTBaseObject := PlayObject;
    nTargetX := PlayObject.m_nCurrX;
    nTargetY := PlayObject.m_nCurrY;
  end;
  if PlayObject.IsProperFriend {0FFF3}(TargeTBaseObject) then begin
    if Random(7) - (UserMagic.btLevel + 1) < 0 then begin
      if TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH] <> 0 then begin
        TargeTBaseObject.m_wStatusTimeArr[POISON_DECHEALTH] := 1;
        Result := True;
      end;
      if TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] <> 0 then begin
        TargeTBaseObject.m_wStatusTimeArr[POISON_DAMAGEARMOR] := 1;
        Result := True;
      end;
      if TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] <> 0 then begin
        TargeTBaseObject.m_wStatusTimeArr[POISON_STONE] := 1;
        Result := True;
      end;
    end;
  end;
end;

{������}
function TMagicManager.MagMakeLivePlayObject(PlayObject: TPlayObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
begin
  Result := False;
  if PlayObject.IsProperTargetSKILL_57(TargeTBaseObject) then begin
    if (Random(10 + UserMagic.btLevel) + UserMagic.btLevel) >= 8 then begin
      TPlayObject(TargeTBaseObject).ReAlive;
      TPlayObject(TargeTBaseObject).m_WAbil.HP := TPlayObject(TargeTBaseObject).m_WAbil.MaxHP;
      TPlayObject(TargeTBaseObject).SendMsg(TPlayObject(TargeTBaseObject), RM_ABILITY, 0, 0, 0, 0, '');
      Result := True;
    end;
  end;
end;

{������}
function TMagicManager.MagMakeArrestObject(PlayObject: TPlayObject; UserMagic: pTUserMagic; TargeTBaseObject: TBaseObject): Boolean;
var
  nX, nY: Integer;
begin
  Result := False;
  if PlayObject.IsProperTargetSKILL_55(PlayObject.m_WAbil.Level, TargeTBaseObject) then begin
    if (Random(10 + UserMagic.btLevel) + UserMagic.btLevel) >= 5 then begin
      PlayObject.GetFrontPosition(nX, nY);
      TargeTBaseObject.SpaceMove(TargeTBaseObject.m_PEnvir.sMapName, nX, nY, 0);
      TargeTBaseObject.SendRefMsg(RM_MONMOVE, 0, nX, nY, 0, '');
      Result := True;
    end;
  end;
end;
{���л�λ}
function TMagicManager.MagChangePosition(PlayObject: TPlayObject; nTargetX, nTargetY: Integer; TargeTBaseObject: TBaseObject): Boolean;
var
  i, nX, nY, olddir, oldx, oldy, nBackDir, nDir: Integer;
  n01: Integer;
begin
  Result := False;
  n01 := 0;
  if not PlayObject.m_boOnHorse then begin
    if PlayObject.IsProperTargetSKILL_56(TargeTBaseObject, nTargetX, nTargetY) then begin
      nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, nTargetX, nTargetY);
      PlayObject.SendRefMsg(RM_SPACEMOVE_FIRE, 0, 0, 0, 0, '');
      PlayObject.SpaceMove(PlayObject.m_PEnvir.sMapName, nTargetX, nTargetY, 0);
      Result := True;
      {olddir := PlayObject.m_btDirection;
      oldx := PlayObject.m_nCurrX;
      oldy := PlayObject.m_nCurrY;
      PlayObject.m_btDirection := nDir;
      nBackDir := PlayObject.GetBackDir(nDir);
      for i := 0 to 100 do begin
        Inc(n01);
        PlayObject.GetFrontPosition(nX, nY);
        if PlayObject.m_PEnvir.CanWalk(nX, nY, False) then begin
          if PlayObject.m_PEnvir.MoveToMovingObject(PlayObject.m_nCurrX, PlayObject.m_nCurrY, PlayObject, nX, nY, False) > 0 then begin
            PlayObject.m_nCurrX := nX;
            PlayObject.m_nCurrY := nY;
            //SendRefMsg(RM_PUSH, GetBackDir(ndir), m_nCurrX, m_nCurrY, 0, '');
            PlayObject.SendRefMsg(RM_PUSH, nBackDir, PlayObject.m_nCurrX, PlayObject.m_nCurrY, 0, '');
            if (PlayObject.m_nCurrX = nTargetX) and (PlayObject.m_nCurrY = nTargetY) then begin
              Result := True;
              break;
            end;
            if n01 > 30 then begin
              Result := True;
              break;
            end;
          end else break;
        end else break;
      end;
      PlayObject.m_btDirection := nBackDir;  }
    end;
  end;
end;

function TMagicManager.IsWarrSkill(wMagIdx: Integer): Boolean; //�Ƿ���սʿ����
begin
  Result := False;
  if wMagIdx in [SKILL_ONESWORD {3}, SKILL_ILKWANG {4}, SKILL_YEDO {7}, SKILL_ERGUM {12}, SKILL_BANWOL {25}, SKILL_FIRESWORD {26}, SKILL_MOOTEBO {27}] then
    Result := True;
end;

function TMagicManager.DoSpell(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  boTrain: Boolean;
  boSpellFail: Boolean;
  boSpellFire: Boolean;
  n14: Integer;
  n18: Integer;
  n1C: Integer;
  nPower: Integer;
  StdItem: pTStdItem;
  nAmuletIdx: Integer;
  nX: Integer;
  nY: Integer;
  function MPow(UserMagic: pTUserMagic): Integer; //004921C8
  begin
    Result := UserMagic.MagicInfo.wPower + Random(UserMagic.MagicInfo.wMaxPower - UserMagic.MagicInfo.wPower);
  end;
  function GetPower(nPower: Integer): Integer; //00493314
  begin
    Result := ROUND(nPower / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1)) + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower));
  end;
  function GetPower13(nInt: Integer): Integer; //0049338C
  var
    d10: Double;
    d18: Double;
  begin
    d10 := nInt / 3.0;
    d18 := nInt - d10;
    Result := ROUND(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)));
  end;
  function GetRPow(wInt: Integer): Word;
  begin
    if HiWord(wInt) > LoWord(wInt) then begin
      Result := Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt);
    end else Result := LoWord(wInt);
  end;
  procedure sub_4934B4(PlayObject: TPlayObject);
  begin
    if PlayObject.m_UseItems[U_ARMRINGL].Dura < 100 then begin
      PlayObject.m_UseItems[U_ARMRINGL].Dura := 0;
      PlayObject.SendDelItems(@PlayObject.m_UseItems[U_ARMRINGL]);
      PlayObject.m_UseItems[U_ARMRINGL].wIndex := 0;
    end;
  end;

begin
  Result := False;
  if IsWarrSkill(UserMagic.wMagIdx) then Exit;
  if (abs(PlayObject.m_nCurrX - nTargetX) > g_Config.nMagicAttackRage) or (abs(PlayObject.m_nCurrY - nTargetY) > g_Config.nMagicAttackRage) then begin
    Exit;
  end;
  PlayObject.SendRefMsg(RM_SPELL, UserMagic.MagicInfo.btEffect, nTargetX, nTargetY, UserMagic.MagicInfo.wMagicId, '');
  if (TargeTBaseObject <> nil) and (TargeTBaseObject.m_boDeath) and (UserMagic.MagicInfo.wMagicId <> SKILL_57) and (UserMagic.MagicInfo.wMagicId < 100) then TargeTBaseObject := nil;

  boTrain := False;
  boSpellFail := False;
  boSpellFire := True;
  nPower := 0;
  if (PlayObject.m_nSoftVersionDateEx = 0) and (PlayObject.m_dwClientTick = 0) and (UserMagic.MagicInfo.wMagicId > 40) then Exit;
  case UserMagic.MagicInfo.wMagicId of //
    SKILL_FIREBALL {1},
    SKILL_FIREBALL2 {5}: begin //������ �����
        if MagMakeFireball(PlayObject,
          UserMagic,
          nTargetX,
          nTargetY,
          TargeTBaseObject) then boTrain := True;
      end;
    SKILL_HEALLING {2}: begin
        if MagTreatment(PlayObject,
          UserMagic,
          nTargetX,
          nTargetY,
          TargeTBaseObject) then boTrain := True;
      end;
    SKILL_AMYOUNSUL {6}: begin //ʩ����
        if MagLightening(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFail) then
          boTrain := True;
      end;
    SKILL_FIREWIND {8}: begin //���ܻ�  00493754
        if MagPushArround(PlayObject, UserMagic.btLevel) > 0 then boTrain := True;
      end;
    SKILL_FIRE {9}: begin //������ 00493778
        if MagMakeHellFire(PlayObject,
          UserMagic,
          nTargetX,
          nTargetY,
          TargeTBaseObject) then boTrain := True;

      end;
    SKILL_SHOOTLIGHTEN {10}: begin //�����Ӱ 0049386A
        if MagMakeQuickLighting(PlayObject,
          UserMagic,
          nTargetX,
          nTargetY,
          TargeTBaseObject) then boTrain := True;
      end;
    SKILL_LIGHTENING {11}: begin //�׵��� 0049395C
        if MagMakeLighting(PlayObject,
          UserMagic,
          nTargetX,
          nTargetY,
          TargeTBaseObject) then boTrain := True;
      end;
    SKILL_FIRECHARM {13},
    SKILL_HANGMAJINBUB {14},
    SKILL_DEJIWONHO {15},
    SKILL_HOLYSHIELD {16},
    SKILL_SKELLETON {17},
    SKILL_CLOAK {18},
    SKILL_BIGCLOAK {19},
    SKILL_52, {52}
    SKILL_57: begin //004940BC
        boSpellFail := True;
        if CheckAmulet(PlayObject, 1, 1, nAmuletIdx) then begin
          UseAmulet(PlayObject, 1, 1, nAmuletIdx);
          case UserMagic.MagicInfo.wMagicId of //
            SKILL_FIRECHARM {13}: begin //����� 0049415F
                if MagMakeFireCharm(PlayObject,
                  UserMagic,
                  nTargetX,
                  nTargetY,
                  TargeTBaseObject) then boTrain := True;
              end;
            SKILL_HANGMAJINBUB {14}: begin //����� 00494277
                nPower := PlayObject.GetAttackPower(GetPower13(60) + LoWord(PlayObject.m_WAbil.SC) * 10, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                if PlayObject.MagMakeDefenceArea(nTargetX, nTargetY, 3, nPower, 1, True) > 0 then
                  boTrain := True;
              end;
            SKILL_DEJIWONHO {15}: begin //��ʥս���� 004942E5
                nPower := PlayObject.GetAttackPower(GetPower13(60) + LoWord(PlayObject.m_WAbil.SC) * 10, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                if PlayObject.MagMakeDefenceArea(nTargetX, nTargetY, 3, nPower, 0, True) > 0 then
                  boTrain := True;
              end;
            SKILL_HOLYSHIELD {16}: begin //��ħ�� 00494353
                if MagMakeHolyCurtain(PlayObject, GetPower13(40) + GetRPow(PlayObject.m_WAbil.SC) * 3, nTargetX, nTargetY) > 0 then
                  boTrain := True;
              end;
            SKILL_SKELLETON {17}: begin //�ٻ����� 004943A2
                if MagMakeSlave(PlayObject, UserMagic) then begin
                  boTrain := True;
                end;
              end;
            SKILL_CLOAK {18}: begin //������
                if MagMakePrivateTransparent(PlayObject, GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 3) then
                  boTrain := True;
              end;
            SKILL_BIGCLOAK {19}: begin //����������
                if MagMakeGroupTransparent(PlayObject, nTargetX, nTargetY, GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 3) then
                  boTrain := True;
              end;
            SKILL_52: begin //������
                nPower := PlayObject.GetAttackPower(GetPower13(20) + LoWord(PlayObject.m_WAbil.SC) * 2, SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) + 1);
                if PlayObject.MagMakeAbilityArea(nTargetX, nTargetY, 3, nPower, 0, False) > 0 then
                  boTrain := True;
              end;
            SKILL_57: begin //������
                if MagMakeLivePlayObject(PlayObject, UserMagic, TargeTBaseObject) then boTrain := True;
              end;
          end;
          boSpellFail := False;
          sub_4934B4(PlayObject);
        end;
      end;
    SKILL_TAMMING {20}: begin //�ջ�֮�� 00493A51
        if PlayObject.IsProperTarget(TargeTBaseObject) then begin
          if MagTamming(PlayObject, TargeTBaseObject, nTargetX, nTargetY, UserMagic.btLevel) then
            boTrain := True;
        end;
      end;
    SKILL_SPACEMOVE {21}: begin //˲Ϣ�ƶ� 00493ADD
        PlayObject.SendRefMsg(RM_MAGICFIRE, 0, MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect), MakeLong(nTargetX, nTargetY), Integer(TargeTBaseObject), '');
        boSpellFire := False;
        if MagSaceMove(PlayObject, UserMagic.btLevel) then
          boTrain := True;
      end;
    SKILL_EARTHFIRE {22}: begin //��ǽ  00493B40
        if MagMakeFireCross(PlayObject,
          PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC),
          SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1),
          GetPower(10) + (Word(GetRPow(PlayObject.m_WAbil.MC)) shr 1),
          nTargetX,
          nTargetY) > 0 then
          boTrain := True;
      end;
    SKILL_FIREBOOM {23}: begin //���ѻ��� 00493BD5
        if MagBigExplosion(PlayObject,
          PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1),
          nTargetX,
          nTargetY,
          g_Config.nFireBoomRage {1}) then
          boTrain := True;
      end;
    SKILL_LIGHTFLOWER {24}: begin //�����׹� 00493CB1
        if MagElecBlizzard(PlayObject, PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1)) then
          boTrain := True;
      end;
    SKILL_SHOWHP {28}: begin
        if (TargeTBaseObject <> nil) and not TargeTBaseObject.m_boShowHP then begin
          if Random(6) <= (UserMagic.btLevel + 3) then begin
            TargeTBaseObject.m_dwShowHPTick := GetTickCount();
            TargeTBaseObject.m_dwShowHPInterval := GetPower13(GetRPow(PlayObject.m_WAbil.SC) * 2 + 30) * 1000;
            TargeTBaseObject.SendDelayMsg(TargeTBaseObject, RM_DOOPENHEALTH, 0, 0, 0, 0, '', 1500);
            //TargeTBaseObject.SendMsg(TargeTBaseObject, RM_DOOPENHEALTH, 0, 0, 0, 0, '');
            boTrain := True;
          end;
        end;
      end;
    SKILL_BIGHEALLING {29}: begin //Ⱥ�������� 00493E42
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.SC) * 2,
          SmallInt(HiWord(PlayObject.m_WAbil.SC) - LoWord(PlayObject.m_WAbil.SC)) * 2 + 1);
        if MagBigHealing(PlayObject, nPower, nTargetX, nTargetY) then boTrain := True;
      end;
    SKILL_SINSU {30}: begin //00494476
        boSpellFail := True;
        if CheckAmulet(PlayObject, 5, 1, nAmuletIdx) then begin
          UseAmulet(PlayObject, 5, 1, nAmuletIdx);
          if MagMakeSinSuSlave(PlayObject, UserMagic) then begin
            boTrain := True;
          end;
          boSpellFail := False;
        end;
      end;
    SKILL_SHIELD {31}: begin //ħ���� 00493D15
        if PlayObject.MagBubbleDefenceUp(UserMagic.btLevel, GetPower(GetRPow(PlayObject.m_WAbil.MC) + 15)) then
          boTrain := True;
      end;
    SKILL_KILLUNDEAD {32}: begin //00493A97  ʥ����
        if PlayObject.IsProperTarget(TargeTBaseObject) then begin
          if MagTurnUndead(PlayObject, TargeTBaseObject, nTargetX, nTargetY, UserMagic.btLevel) then
            boTrain := True;
        end;
      end;
    SKILL_SNOWWIND {33}: begin //00493C43 ������
        if MagBigExplosion(PlayObject,
          PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1),
          nTargetX,
          nTargetY,
          g_Config.nSnowWindRange {1}) then
          boTrain := True;
      end;
    SKILL_UNAMYOUNSUL {34}: begin //�ⶾ��
        if MagMakeUnTreatment(PlayObject,
          UserMagic,
          nTargetX,
          nTargetY,
          TargeTBaseObject) then boTrain := True;
      end;
    SKILL_WINDTEBO {35}: if MagWindTebo(PlayObject, UserMagic) then boTrain := True;

    //����
    SKILL_MABE {36}: begin
        with PlayObject do begin
          nPower := GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(m_WAbil.MC),
            SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
        end;
        if MabMabe(PlayObject, TargeTBaseObject, nPower, UserMagic.btLevel, nTargetX, nTargetY) then
          boTrain := True;
      end;
    SKILL_GROUPLIGHTENING {37 Ⱥ���׵���}: begin
        if MagGroupLightening(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFire) then
          boTrain := True;
      end;
    SKILL_GROUPAMYOUNSUL {38 Ⱥ��ʩ����}: begin
        if MagGroupAmyounsul(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
          boTrain := True;
      end;
    SKILL_GROUPDEDING {39 �ض�}: begin
        if GetTickCount - PlayObject.m_dwDedingUseTick > g_Config.nDedingUseTime * 1000 then begin
          PlayObject.m_dwDedingUseTick := GetTickCount;
          if g_Config.boDedingAllowPK then begin
            if MagGroupDeDing(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
              boTrain := True;
          end else begin
            if (TargeTBaseObject <> nil) and (TargeTBaseObject.m_btRaceServer <> RC_PLAYOBJECT) and MagGroupDeDing(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
              boTrain := True;
          end;
        end;
      end;
    SKILL_40: begin //˫��ն

      end;
    SKILL_41: begin //ʨ�Ӻ�
        if MagGroupMb(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then
          boTrain := True;
      end;
    SKILL_42: begin //���ն

      end;
    SKILL_43: begin //�ƿս�

      end;
    //��ʦ
    SKILL_44: begin //�����
        if MagHbFireBall(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_45: begin //�����
        if MagMakeFireDay(PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    SKILL_46: begin //������
        if MagMakeSelf(PlayObject, TargeTBaseObject, UserMagic) then begin
          boTrain := True;
        end;
      end;
    SKILL_47: begin //��������
        if MagBigExplosion(PlayObject,
          PlayObject.GetAttackPower(GetPower(MPow(UserMagic)) + LoWord(PlayObject.m_WAbil.MC), SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1),
          nTargetX,
          nTargetY,
          g_Config.nFireBoomRage {1}) then
          boTrain := True;
      end;
    //��ʿ
    SKILL_48: begin //������
        if MagPushArround(PlayObject, UserMagic.btLevel) > 0 then boTrain := True;
      end;
    SKILL_49: begin //������
        boTrain := True;
      end;
    SKILL_50: begin //�޼�����
        if PlayObject.AbilityUp(UserMagic) then
          boTrain := True;
      end;
    SKILL_51: begin //쫷���
        boTrain := True;
      end;

    SKILL_53: begin //Ѫ��
        boTrain := True;
      end;
    SKILL_54: begin //������
        boTrain := True;
      end;

    SKILL_55: begin //������
        if MagMakeArrestObject(PlayObject, UserMagic, TargeTBaseObject) then boTrain := True;
      end;

    SKILL_56: begin //���л�λ
        if MagChangePosition(PlayObject, nTargetX, nTargetY, TargeTBaseObject) then boTrain := True;
      end;
    else begin
        if Assigned(zPlugOfEngine.SetHookDoSpell) then begin
          try
            boTrain := zPlugOfEngine.SetHookDoSpell(Self, PlayObject, UserMagic, nTargetX, nTargetY, TargeTBaseObject, boSpellFail, boSpellFire);
          except
          end;
        end;
      end;
  end;
  if boSpellFail then Exit;
  if boSpellFire then begin
    PlayObject.SendRefMsg(RM_MAGICFIRE, 0,
      MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
      MakeLong(nTargetX, nTargetY),
      Integer(TargeTBaseObject),
      '');
  end;
  if (UserMagic.btLevel < 3) and (boTrain) then begin
    if UserMagic.MagicInfo.TrainLevel[UserMagic.btLevel] <= PlayObject.m_Abil.Level then begin
      PlayObject.TrainSkill(UserMagic, Random(3) + 1);
      if not PlayObject.CheckMagicLevelup(UserMagic) then begin
        PlayObject.SendDelayMsg(PlayObject, RM_MAGIC_LVEXP, 0, UserMagic.MagicInfo.wMagicId, UserMagic.btLevel, UserMagic.nTranPoint, '', 1000);
      end;
    end;
  end;
  Result := True;
end;

function TMagicManager.MagMakePrivateTransparent(BaseObject: TBaseObject; nHTime: Integer): Boolean; //004930E8
var
  i: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  if BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] > 0 then Exit; //4930FE
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 9, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) and (TargeTBaseObject.m_TargetCret = BaseObject) then begin
      if (abs(TargeTBaseObject.m_nCurrX - BaseObject.m_nCurrX) > 1) or
        (abs(TargeTBaseObject.m_nCurrY - BaseObject.m_nCurrY) > 1) or
        (Random(2) = 0) then begin
        TargeTBaseObject.m_TargetCret := nil;
      end;
    end;
  end;
  BaseObjectList.Free;
  BaseObject.m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] := nHTime; //004931D2
  BaseObject.m_nCharStatus := BaseObject.GetCharStatus();
  BaseObject.StatusChanged();
  BaseObject.m_boHideMode := True;
  BaseObject.m_boTransparent := True;
  Result := True;
end;

function TMagicManager.MagReturn(BaseObject, TargeTBaseObject: TBaseObject;
  nTargetX, nTargetY, nMagicLevel: Integer): Boolean; //00492368
begin
  Result := False;
  TargeTBaseObject.ReAlive;
  TargeTBaseObject.m_WAbil.HP := TargeTBaseObject.m_WAbil.MaxHP;
  TargeTBaseObject.SendMsg(TargeTBaseObject, RM_ABILITY, 0, 0, 0, 0, '');

  {TargeTBaseObject.m_boGhost:=False;
  TargeTBaseObject.m_boDeath:=False;
  TargeTBaseObject.m_WAbil.HP := TargeTBaseObject.m_WAbil.MaxHP;
  TargeTBaseObject.HealthSpellChanged; }
  Result := True;
end;

function TMagicManager.MagTamming(BaseObject, TargeTBaseObject: TBaseObject;
  nTargetX, nTargetY, nMagicLevel: Integer): Boolean; //00492368
var
  n14: Integer;
begin
  Result := False;
  if (TargeTBaseObject.m_btRaceServer <> RC_PLAYOBJECT) and ((Random(4 - nMagicLevel) = 0)) then begin
    TargeTBaseObject.m_TargetCret := nil;
    if TargeTBaseObject.m_Master = BaseObject then begin
      TargeTBaseObject.OpenHolySeizeMode((nMagicLevel * 5 + 10) * 1000);
      Result := True;
    end else begin
      if Random(2) = 0 then begin
        if TargeTBaseObject.m_Abil.Level <= BaseObject.m_Abil.Level + 2 then begin
          if Random(3) = 0 then begin
            if Random((BaseObject.m_Abil.Level + 20) + (nMagicLevel * 5)) > (TargeTBaseObject.m_Abil.Level + g_Config.nMagTammingTargetLevel {10}) then begin
              if not (TargeTBaseObject.bo2C1) and
                (TargeTBaseObject.m_btLifeAttrib = 0) and
                (TargeTBaseObject.m_Abil.Level < g_Config.nMagTammingLevel {50}) and
                (BaseObject.m_SlaveList.Count < g_Config.nMagTammingCount {(nMagicLevel + 2)}) then begin
                n14 := TargeTBaseObject.m_WAbil.MaxHP div g_Config.nMagTammingHPRate {100};
                if n14 <= 2 then n14 := 2
                else Inc(n14, n14);
                if (TargeTBaseObject.m_Master <> BaseObject) and (Random(n14) = 0) then begin
                  TargeTBaseObject.BreakCrazyMode();
                  if TargeTBaseObject.m_Master <> nil then begin
                    TargeTBaseObject.m_WAbil.HP := TargeTBaseObject.m_WAbil.HP div 10;
                  end;
                  TargeTBaseObject.m_Master := BaseObject;
                  TargeTBaseObject.m_dwMasterRoyaltyTick := LongWord((Random(BaseObject.m_Abil.Level * 2) + (nMagicLevel shl 2) * 5 + 20) * 60 * 1000) + GetTickCount;
                  TargeTBaseObject.m_btSlaveMakeLevel := nMagicLevel;
                  if TargeTBaseObject.m_dwMasterTick = 0 then TargeTBaseObject.m_dwMasterTick := GetTickCount();
                  TargeTBaseObject.BreakHolySeizeMode();
                  if LongWord(1500 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nWalkSpeed) then begin
                    TargeTBaseObject.m_nWalkSpeed := 1500 - nMagicLevel * 200;
                  end;
                  if LongWord(2000 - nMagicLevel * 200) < LongWord(TargeTBaseObject.m_nNextHitTime) then begin
                    TargeTBaseObject.m_nNextHitTime := 2000 - nMagicLevel * 200;
                  end;
                  TargeTBaseObject.RefShowName();
                  BaseObject.m_SlaveList.Add(TargeTBaseObject);
                end else begin //004925F2
                  if Random(14) = 0 then TargeTBaseObject.m_WAbil.HP := 0;
                end;
              end else begin //00492615
                if (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) and (Random(20) = 0) then
                  TargeTBaseObject.m_WAbil.HP := 0;
              end;
            end else begin //00492641
              if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) and (Random(20) = 0) then
                TargeTBaseObject.OpenCrazyMode(Random(20) + 10);
            end;
          end else begin //00492674
            if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then
              TargeTBaseObject.OpenCrazyMode(Random(20) + 10); //���
          end;
        end; //004926B0
      end else begin //00492699
        TargeTBaseObject.OpenHolySeizeMode((nMagicLevel * 5 + 10) * 1000);
      end;
      Result := True;
    end;
  end else begin
    if Random(2) = 0 then Result := True;
  end;

end;

function TMagicManager.MagTurnUndead(BaseObject, TargeTBaseObject: TBaseObject;
  nTargetX, nTargetY, nLevel: Integer): Boolean; //004926D4
var
  n14: Integer;
begin
  Result := False;
  if TargeTBaseObject.m_boSuperMan or not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then Exit;
  TAnimalObject(TargeTBaseObject).Struck {FFEC}(BaseObject);
  if TargeTBaseObject.m_TargetCret = nil then begin
    TAnimalObject(TargeTBaseObject).m_boRunAwayMode := True;
    TAnimalObject(TargeTBaseObject).m_dwRunAwayStart := GetTickCount();
    TAnimalObject(TargeTBaseObject).m_dwRunAwayTime := 10 * 1000;
  end;
  BaseObject.SetTargetCreat(TargeTBaseObject);
  if (Random(2) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level then begin
    if TargeTBaseObject.m_Abil.Level < g_Config.nMagTurnUndeadLevel then begin
      n14 := BaseObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
      if Random(100) < ((nLevel shl 3) - nLevel + 15 + n14) then begin
        TargeTBaseObject.SetLastHiter(BaseObject);
        TargeTBaseObject.m_WAbil.HP := 0;
        Result := True;
      end
    end;
  end; //004927CB
end;

function TMagicManager.MagWindTebo(PlayObject: TPlayObject;
  UserMagic: pTUserMagic): Boolean;
var
  PoseBaseObject: TBaseObject;
begin
  Result := False;
  PoseBaseObject := PlayObject.GetPoseCreate;
  if (PoseBaseObject <> nil) and
    (PoseBaseObject <> PlayObject) and
    (not PoseBaseObject.m_boDeath) and
    (not PoseBaseObject.m_boGhost) and
    (PlayObject.IsProperTarget(PoseBaseObject)) and
    (not PoseBaseObject.m_boStickMode) then begin
    if (abs(PlayObject.m_nCurrX - PoseBaseObject.m_nCurrX) <= 1) and
      (abs(PlayObject.m_nCurrY - PoseBaseObject.m_nCurrY) <= 1) and
      (PlayObject.m_Abil.Level > PoseBaseObject.m_Abil.Level) then begin
      if Random(20) < UserMagic.btLevel * 6 + 6 + (PlayObject.m_Abil.Level - PoseBaseObject.m_Abil.Level) then begin
        PoseBaseObject.CharPushed(GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, PoseBaseObject.m_nCurrX, PoseBaseObject.m_nCurrY), _MAX(0, UserMagic.btLevel - 1) + 1);
        Result := True;
      end;
    end;
  end;
end;

function TMagicManager.MagSaceMove(BaseObject: TBaseObject;
  nLevel: Integer): Boolean; //04927D8
var
  Envir: TEnvirnoment;
  PlayObject: TPlayObject;
begin
  Result := False;
  if Random(11) < nLevel * 2 + 4 then begin
    BaseObject.SendRefMsg(RM_SPACEMOVE_FIRE2, 0, 0, 0, 0, '');
    if BaseObject is TPlayObject then begin
      Envir := BaseObject.m_PEnvir;
      BaseObject.MapRandomMove(BaseObject.m_sHomeMap, 1);
      if (Envir <> BaseObject.m_PEnvir) and (BaseObject.m_btRaceServer = RC_PLAYOBJECT) then begin
        PlayObject := TPlayObject(BaseObject);
        PlayObject.m_boTimeRecall := False;
      end;
    end;
    Result := True;
  end; //00492899
end;

function TMagicManager.MagGroupAmyounsul(PlayObject: TBaseObject { �޸� TBaseObject};
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  i: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
  StdItem: pTStdItem;
  nAmuletIdx: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nTargetX, nTargetY, _MAX(1, UserMagic.btLevel), BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
    if PlayObject.IsProperTarget(BaseObject) then begin
      if CheckAmulet(PlayObject, 1, 2, nAmuletIdx) then begin
        StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[nAmuletIdx].wIndex);
        if StdItem <> nil then begin
          UseAmulet(PlayObject, 1, 2, nAmuletIdx);
          if Random(BaseObject.m_btAntiPoison + 7) <= 6 then begin
            case StdItem.Shape of
              1: begin
                  nPower := GetPower13(40, UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                  BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DECHEALTH {�ж����� - �̶�}, nPower, Integer(PlayObject), ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)) {UserMagic.btLevel}, '', 1000);
                end;
              2: begin
                  nPower := GetPower13(30, UserMagic) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                  BaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DAMAGEARMOR {�ж����� - �춾}, nPower, Integer(PlayObject), ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)) {UserMagic.btLevel}, '', 1000);
                end;
            end;
            if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) or (BaseObject.m_btRaceServer >= RC_ANIMAL) then
              Result := True;
            BaseObject.SetLastHiter(PlayObject);
            PlayObject.SetTargetCreat(BaseObject);
          end;
        end;
      end;
    end;
  end;
  BaseObjectList.Free;
end;


function TMagicManager.MagGroupDeDing(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  i: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nTargetX, nTargetY, _MAX(1, UserMagic.btLevel), BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
    if PlayObject.IsProperTarget(BaseObject) then begin
      nPower := PlayObject.GetAttackPower(LoWord(PlayObject.m_WAbil.DC), SmallInt((HiWord(PlayObject.m_WAbil.DC) - LoWord(PlayObject.m_WAbil.DC))));
      if (Random(BaseObject.m_btSpeedPoint) >= PlayObject.m_btHitPoint) then begin
        nPower := 0;
      end;
      if nPower > 0 then begin
        nPower := BaseObject.GetHitStruckDamage(PlayObject, nPower);
      end;
      if nPower > 0 then begin //004C21FC
        BaseObject.StruckDamage(nPower);
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 1, Integer(BaseObject), '', 200);
        //PlayObject.SendMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 1, Integer(BaseObject), '');
      end;
      if BaseObject.m_btRaceServer >= RC_ANIMAL then
        Result := True;
    end;
    PlayObject.SendRefMsg(RM_10205, 0, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 1, '');
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagGroupLightening(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
var
  i: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
begin
  Result := False;
  boSpellFire := False;
  BaseObjectList := TList.Create;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, nTargetX, nTargetY, _MAX(1, UserMagic.btLevel), BaseObjectList);
  PlayObject.SendRefMsg(RM_MAGICFIRE, 0,
    MakeWord(UserMagic.MagicInfo.btEffectType, UserMagic.MagicInfo.btEffect),
    MakeLong(nTargetX, nTargetY),
    Integer(TargeTBaseObject),
    '');
  for i := 0 to BaseObjectList.Count - 1 do begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
    if PlayObject.IsProperTarget(BaseObject) then begin
      if (Random(10) >= BaseObject.m_nAntiMagic) then begin
        nPower := PlayObject.GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(PlayObject.m_WAbil.MC),
          SmallInt(HiWord(PlayObject.m_WAbil.MC) - LoWord(PlayObject.m_WAbil.MC)) + 1);
        if BaseObject.m_btLifeAttrib = LA_UNDEAD then
          nPower := ROUND(nPower * 1.5);

        PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 2, Integer(BaseObject), '', 600);
        //PlayObject.SendMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(BaseObject.m_nCurrX, BaseObject.m_nCurrY), 2, Integer(BaseObject), '');
        if PlayObject.m_btRaceServer = RC_PLAYMOSTER then Result := True
        else if BaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
      end;
      if (BaseObject.m_nCurrX <> nTargetX) or (BaseObject.m_nCurrY <> nTargetY) then
        PlayObject.SendRefMsg(RM_10205, 0, BaseObject.m_nCurrX, BaseObject.m_nCurrY, 4 {type}, '');
    end;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagLightening(PlayObject: TBaseObject {�޸� TBaseObject};
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject; var boSpellFire: Boolean): Boolean;
var
  boSpellFail: Boolean;
  nPower: Integer;
  StdItem: pTStdItem;
  nAmuletIdx: Integer;
  function GetPower13(nInt: Integer): Integer; //0049338C
  var
    d10: Double;
    d18: Double;
  begin
    d10 := nInt / 3.0;
    d18 := nInt - d10;
    Result := ROUND(d18 / (UserMagic.MagicInfo.btTrainLv + 1) * (UserMagic.btLevel + 1) + d10 + (UserMagic.MagicInfo.btDefPower + Random(UserMagic.MagicInfo.btDefMaxPower - UserMagic.MagicInfo.btDefPower)));
  end;
  function GetRPow(wInt: Integer): Word;
  begin
    if HiWord(wInt) > LoWord(wInt) then begin
      Result := Random(HiWord(wInt) - LoWord(wInt) + 1) + LoWord(wInt);
    end else Result := LoWord(wInt);
  end;
begin //ʩ����
  Result := False;
  boSpellFail := True;
  if PlayObject.IsProperTarget(TargeTBaseObject) then begin
    if CheckAmulet(PlayObject, 1, 2, nAmuletIdx) then begin
      StdItem := UserEngine.GetStdItem(PlayObject.m_UseItems[nAmuletIdx].wIndex);
      if StdItem <> nil then begin
        UseAmulet(PlayObject, 1, 2, nAmuletIdx);
        if Random(TargeTBaseObject.m_btAntiPoison + 7) <= 6 then begin
          case StdItem.Shape of
            1: begin
                nPower := GetPower13(40) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DECHEALTH {�ж����� - �̶�}, nPower, Integer(PlayObject), ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)) {UserMagic.btLevel}, '', 1000);
              end;
            2: begin
                nPower := GetPower13(30) + GetRPow(PlayObject.m_WAbil.SC) * 2;
                TargeTBaseObject.SendDelayMsg(PlayObject, RM_POISON, POISON_DAMAGEARMOR {�ж����� - �춾}, nPower, Integer(PlayObject), ROUND(UserMagic.btLevel / 3 * (nPower / g_Config.nAmyOunsulPoint)) {UserMagic.btLevel}, '', 1000);
              end;
          end;
          if (TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT) or (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then
            Result := True;
        end;
        PlayObject.SetTargetCreat(TargeTBaseObject);
        boSpellFail := False;
      end;
    end;
  end;
end;

function TMagicManager.MagHbFireBall(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  var TargeTBaseObject: TBaseObject): Boolean;
var
  nPower: Integer;
  nDir: Integer;
  levelgap: Integer;
  push: Integer;
begin
  Result := False;
  if not PlayObject.MagCanHitTarget(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject) then begin
    TargeTBaseObject := nil;
    Exit;
  end;
  if not PlayObject.IsProperTarget(TargeTBaseObject) then begin
    TargeTBaseObject := nil;
    Exit;
  end;
  if (TargeTBaseObject.m_nAntiMagic > Random(10)) or (abs(TargeTBaseObject.m_nCurrX - nTargetX) > 1) or (abs(TargeTBaseObject.m_nCurrY - nTargetY) > 1) then begin
    TargeTBaseObject := nil;
    Exit;
  end;
  with PlayObject do begin
    nPower := GetAttackPower(GetPower(MPow(UserMagic), UserMagic) + LoWord(m_WAbil.MC),
      SmallInt(HiWord(m_WAbil.MC) - LoWord(m_WAbil.MC)) + 1);
  end;
  PlayObject.SendDelayMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
  //PlayObject.SendMsg(PlayObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '');
  if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) then Result := True;

  if (PlayObject.m_Abil.Level > TargeTBaseObject.m_Abil.Level) and (not TargeTBaseObject.m_boStickMode) then begin
    levelgap := PlayObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
    if (Random(20) < 6 + UserMagic.btLevel * 3 + levelgap) then begin
      push := Random(UserMagic.btLevel) - 1;
      if push > 0 then begin
        nDir := GetNextDirection(PlayObject.m_nCurrX, PlayObject.m_nCurrY, TargeTBaseObject.m_nCurrX, TargeTBaseObject.m_nCurrY);
        PlayObject.SendDelayMsg(PlayObject, RM_DELAYPUSHED, nDir, MakeLong(nTargetX, nTargetY), push, Integer(TargeTBaseObject), '', 600);
        //PlayObject.SendMsg(PlayObject, RM_DELAYPUSHED, nDir, MakeLong(nTargetX, nTargetY), push, Integer(TargeTBaseObject), '');
      end;
    end;
  end;
end;

//����������״�Ļ�
function TMagicManager.MagMakeSuperFireCross(PlayObject: TPlayObject; nDamage,
  nHTime, nX, nY: Integer; nCount: Integer): Integer;
  function MagMakeSuperFireCrossOfDir(btDir: Integer): Integer;
  var
    FireBurnEvent: TFireBurnEvent;
    i, ii, x, y: Integer;
    nTime: Integer;
    x1, x2, y1, y2: string;
  begin
    Result := 0;
    nTime := 1;
    case btDir of
      DR_UP: begin
          for y := PlayObject.m_nCurrY downto PlayObject.m_nCurrY - 10 do begin
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, PlayObject.m_nCurrX, y, ET_FIRE, nHTime * nTime, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_UPRIGHT: begin
          for i := 0 to 6 do begin
            x := PlayObject.m_nCurrX + i;
            y := PlayObject.m_nCurrY - i;
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, y, ET_FIRE, nHTime * nTime * 2, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_RIGHT: begin
          for x := PlayObject.m_nCurrX to PlayObject.m_nCurrX + 10 do begin
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, PlayObject.m_nCurrY, ET_FIRE, nHTime * nTime, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_DOWNRIGHT: begin
          for i := 0 to 6 do begin
            x := PlayObject.m_nCurrX + i;
            y := PlayObject.m_nCurrY + i;
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, y, ET_FIRE, nHTime * nTime * 2, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_DOWN: begin
          for y := PlayObject.m_nCurrY to PlayObject.m_nCurrY + 10 do begin
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, PlayObject.m_nCurrX, y, ET_FIRE, nHTime * nTime, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_DOWNLEFT: begin
          for i := 0 to 6 do begin
            x := PlayObject.m_nCurrX - i;
            y := PlayObject.m_nCurrY + i;
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, y, ET_FIRE, nHTime * nTime * 2, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_LEFT: begin
          for x := PlayObject.m_nCurrX downto PlayObject.m_nCurrX - 10 do begin
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, PlayObject.m_nCurrY, ET_FIRE, nHTime * nTime, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
      DR_UPLEFT: begin
          for i := 0 to 6 do begin
            x := PlayObject.m_nCurrX - i;
            y := PlayObject.m_nCurrY - i;
            FireBurnEvent := TFireBurnEvent.Create(PlayObject, x, y, ET_FIRE, nHTime * nTime * 2, nDamage);
            g_EventManager.AddEvent(FireBurnEvent);
            Inc(nTime);
          end;
        end;
    end;
    Result := 1;
  end;
var
  i: Integer;
begin
  Result := 0;
  case nCount of
    1: begin
        Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
      end;
    3: begin
        case PlayObject.m_btDirection of
          DR_UP: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_UPRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_UPLEFT);
            end;
          DR_UPRIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
            end;
          DR_RIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_UPRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNRIGHT);
            end;
          DR_DOWNRIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
            end;
          DR_DOWN: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNRIGHT);
            end;
          DR_DOWNLEFT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
            end;
          DR_LEFT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_UPLEFT);
            end;
          DR_UPLEFT: begin
              Result := MagMakeSuperFireCrossOfDir(PlayObject.m_btDirection);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
            end;
        end;
      end;
    4: begin
        Result := MagMakeSuperFireCrossOfDir(DR_UP);
        Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
        Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
        Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
      end;
    5: begin
        case PlayObject.m_btDirection of
          DR_UP, DR_UPLEFT, DR_UPRIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
              Result := MagMakeSuperFireCrossOfDir(DR_UPRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_UPLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
            end;
          DR_LEFT: begin
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
              Result := MagMakeSuperFireCrossOfDir(DR_UPLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNLEFT);
            end;
          DR_RIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(DR_UP);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
              Result := MagMakeSuperFireCrossOfDir(DR_UPRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNRIGHT);
            end;
          DR_DOWN, DR_DOWNLEFT, DR_DOWNRIGHT: begin
              Result := MagMakeSuperFireCrossOfDir(DR_DOWN);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNRIGHT);
              Result := MagMakeSuperFireCrossOfDir(DR_DOWNLEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_LEFT);
              Result := MagMakeSuperFireCrossOfDir(DR_RIGHT);
            end;
        end;
      end;
    8: begin
        for i := DR_UP to DR_UPLEFT do
          Result := MagMakeSuperFireCrossOfDir(i);
      end;
  end;
end;

//��ǽ
function TMagicManager.MagMakeFireCross(PlayObject: TPlayObject; nDamage,
  nHTime, nX, nY: Integer): Integer; //00492C9C
var
  FireBurnEvent: TFireBurnEvent;
resourcestring
  sDisableInSafeZoneFireCross = '��ȫ��������ʹ��...';
  sDisableInSafeZoneFireCross1 = '��ǰ��ͼ������ʹ��...';
begin
  Result := 0;
  if g_Config.boDisableInSafeZoneFireCross and PlayObject.InSafeZone(PlayObject.m_PEnvir, nX, nY) then begin
    PlayObject.SysMsg(sDisableInSafeZoneFireCross, c_Red, t_Notice);
    Exit;
  end;

  if PlayObject.m_PEnvir.m_boUnAllowFireMagic then begin
    PlayObject.SysMsg(sDisableInSafeZoneFireCross1, c_Red, t_Notice);
    Exit;
  end;

  if PlayObject.m_PEnvir.GetEvent(nX, nY - 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY - 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //0492CFC   x
  if PlayObject.m_PEnvir.GetEvent(nX - 1, nY) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX - 1, nY, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //0492D4D
  if PlayObject.m_PEnvir.GetEvent(nX, nY) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //00492D9C
  if PlayObject.m_PEnvir.GetEvent(nX + 1, nY) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX + 1, nY, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //00492DED
  if PlayObject.m_PEnvir.GetEvent(nX, nY + 1) = nil then begin
    FireBurnEvent := TFireBurnEvent.Create(PlayObject, nX, nY + 1, ET_FIRE, nHTime * 1000, nDamage);
    g_EventManager.AddEvent(FireBurnEvent);
  end; //00492E3E
  Result := 1;
end;

function TMagicManager.MagBigExplosion(BaseObject: TBaseObject; nPower, nX,
  nY: Integer; nRage: Integer): Boolean; //00492F4C
var
  i: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, nX, nY, nRage, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.IsProperTarget(TargeTBaseObject) then begin
      BaseObject.SetTargetCreat(TargeTBaseObject);
      TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, nPower, 0, 0, '');
      Result := True;
    end;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagElecBlizzard(BaseObject: TBaseObject;
  nPower: Integer): Boolean; //00493010
var
  i: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  nPowerPoint: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, BaseObject.m_nCurrX, BaseObject.m_nCurrY, g_Config.nElecBlizzardRange {2}, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if not (TargeTBaseObject.m_btLifeAttrib = LA_UNDEAD) then begin
      nPowerPoint := nPower div 10;
    end else nPowerPoint := nPower;

    if BaseObject.IsProperTarget(TargeTBaseObject) then begin
      //BaseObject.SetTargetCreat(TargeTBaseObject);
      TargeTBaseObject.SendMsg(BaseObject, RM_MAGSTRUCK, 0, nPowerPoint, 0, 0, '');
      Result := True;
    end;
  end;
  BaseObjectList.Free;
end;

function TMagicManager.MagMakeHolyCurtain(BaseObject: TBaseObject; nPower: Integer; nX, nY: Integer): Integer; //004928C0
var
  i: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
  MagicEvent: pTMagicEvent;
  HolyCurtainEvent: THolyCurtainEvent;
begin
  Result := 0;
  if BaseObject.m_PEnvir.CanWalk(nX, nY, True) then begin
    BaseObjectList := TList.Create;
    MagicEvent := nil;
    BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, nX, nY, 1, BaseObjectList);
    for i := 0 to BaseObjectList.Count - 1 do begin
      TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
      if (TargeTBaseObject.m_btRaceServer >= RC_ANIMAL) and
        ((Random(4) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level) and
        {(TargeTBaseObject.m_Abil.Level < 50) and}
      (TargeTBaseObject.m_Master = nil) then begin
        TargeTBaseObject.OpenHolySeizeMode(nPower * 1000);
        if MagicEvent = nil then begin
          New(MagicEvent);
          FillChar(MagicEvent^, SizeOf(TMagicEvent), #0);
          MagicEvent.BaseObjectList := TList.Create;
          MagicEvent.dwStartTick := GetTickCount();
          MagicEvent.dwTime := nPower * 1000;
        end;
        MagicEvent.BaseObjectList.Add(TargeTBaseObject);
        Inc(Result);
      end else begin //00492A02
        Result := 0;
      end;
    end;
    BaseObjectList.Free;
    if (Result > 0) and (MagicEvent <> nil) then begin
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 1, nY - 2, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[0] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 1, nY - 2, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[1] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 2, nY - 1, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[2] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 2, nY - 1, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[3] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 2, nY + 1, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[4] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 2, nY + 1, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[5] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX - 1, nY + 2, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[6] := HolyCurtainEvent;
      HolyCurtainEvent := THolyCurtainEvent.Create(BaseObject.m_PEnvir, nX + 1, nY + 2, ET_HOLYCURTAIN, nPower * 1000);
      g_EventManager.AddEvent(HolyCurtainEvent);
      MagicEvent.Events[7] := HolyCurtainEvent;
      UserEngine.m_MagicEventList.Add(MagicEvent);
    end else begin
      if MagicEvent <> nil then begin
        MagicEvent.BaseObjectList.Free;
        DisPose(MagicEvent);
      end;
    end;
  end;
end;

function TMagicManager.MagMakeGroupTransparent(BaseObject: TBaseObject; nX, nY,
  nHTime: Integer): Boolean; //0049320C
var
  i: Integer;
  BaseObjectList: TList;
  TargeTBaseObject: TBaseObject;
begin
  Result := False;
  BaseObjectList := TList.Create;
  BaseObject.GetMapBaseObjects(BaseObject.m_PEnvir, nX, nY, 1, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    TargeTBaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.IsProperFriend(TargeTBaseObject) then begin
      if TargeTBaseObject.m_wStatusTimeArr[STATE_TRANSPARENT {0x70}] = 0 then begin //00493287
        TargeTBaseObject.SendDelayMsg(TargeTBaseObject, RM_TRANSPARENT, 0, nHTime, 0, 0, '', 800);
        //TargeTBaseObject.SendMsg(TargeTBaseObject, RM_TRANSPARENT, 0, nHTime, 0, 0, '');
        Result := True;
      end;
    end
  end;
  BaseObjectList.Free;
end;
//=====================================================================================
//���ƣ�
//���ܣ�
//������
//     BaseObject       ħ��������
//     TargeTBaseObject �ܹ�����ɫ
//     nPower           ħ������С
//     nLevel           ���������ȼ�
//     nTargetX         Ŀ������X
//     nTargetY         Ŀ������Y
//����ֵ��
//=====================================================================================
function TMagicManager.MabMabe(BaseObject, TargeTBaseObject: TBaseObject; nPower, nLevel,
  nTargetX, nTargetY: Integer): Boolean;
var
  nLv: Integer;
begin
  Result := False;
  if BaseObject.MagCanHitTarget(BaseObject.m_nCurrX, BaseObject.m_nCurrY, TargeTBaseObject) then begin
    if BaseObject.IsProperTarget(TargeTBaseObject) and (BaseObject <> TargeTBaseObject) then begin
      if (TargeTBaseObject.m_nAntiMagic <= Random(10)) and (abs(TargeTBaseObject.m_nCurrX - nTargetX) <= 1) and (abs(TargeTBaseObject.m_nCurrY - nTargetY) <= 1) then begin
        BaseObject.SendDelayMsg(BaseObject, RM_DELAYMAGIC, nPower div 3, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
        if (Random(2) + (BaseObject.m_Abil.Level - 1)) > TargeTBaseObject.m_Abil.Level then begin
          nLv := BaseObject.m_Abil.Level - TargeTBaseObject.m_Abil.Level;
          if (Random(g_Config.nMabMabeHitRandRate {100}) < _MAX(g_Config.nMabMabeHitMinLvLimit, (nLevel * 8) - nLevel + 15 + nLv)) {or (Random(abs(nLv))} then begin
            // if (Random(100) < ((nLevel shl 3) - nLevel + 15 + nLv)) {or (Random(abs(nLv))} then begin
            if (Random(g_Config.nMabMabeHitSucessRate {21}) < nLevel * 2 + 4) then begin
              if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
                BaseObject.SetPKFlag(BaseObject);
                BaseObject.SetTargetCreat(TargeTBaseObject);
              end;
              TargeTBaseObject.SetLastHiter(BaseObject);
              nPower := TargeTBaseObject.GetMagStruckDamage(BaseObject, nPower);
              BaseObject.SendDelayMsg(BaseObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '', 600);
              //BaseObject.SendMsg(BaseObject, RM_DELAYMAGIC, nPower, MakeLong(nTargetX, nTargetY), 2, Integer(TargeTBaseObject), '');
              if not TargeTBaseObject.m_boUnParalysis then
                TargeTBaseObject.SendDelayMsg(BaseObject, RM_POISON, POISON_STONE {�ж����� - ���}, nPower div g_Config.nMabMabeHitMabeTimeRate {20} + Random(nLevel), Integer(BaseObject), nLevel, '', 650);
              //TargeTBaseObject.SendDelayMsg(BaseObject, RM_POISON, POISON_STONE {�ж����� - ���}, nPower div g_Config.nMabMabeHitMabeTimeRate {20} + Random(nLevel), Integer(BaseObject), nLevel, '', 10);
              Result := True;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TMagicManager.MagMakeSinSuSlave(PlayObject: TPlayObject;
  UserMagic: pTUserMagic): Boolean;
var
  i: Integer;
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
begin
  Result := False;
  if not PlayObject.sub_4DD704 then begin
    sMonName := g_Config.sDogz;
    nMakeLevel := UserMagic.btLevel;
    nExpLevel := UserMagic.btLevel;
    nCount := g_Config.nDogzCount;
    dwRoyaltySec := 10 * 24 * 60 * 60;
    for i := Low(g_Config.DogzArray) to High(g_Config.DogzArray) do begin
      if g_Config.DogzArray[i].nHumLevel = 0 then break;
      if PlayObject.m_Abil.Level >= g_Config.DogzArray[i].nHumLevel then begin
        sMonName := g_Config.DogzArray[i].sMonName;
        nExpLevel := g_Config.DogzArray[i].nLevel;
        nCount := g_Config.DogzArray[i].nCount;
      end;
    end;

    if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
      Result := True;
  end;
  //          if PlayObject.MakeSlave(g_Config.sDogz,UserMagic.btLevel,1,10 * 24 * 60 * 60) <> nil then
  //            boTrain:=True;
end;

function TMagicManager.MagMakeSlave(PlayObject: TPlayObject; UserMagic: pTUserMagic): Boolean;
var
  i: Integer;
  sMonName: string;
  nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
begin
  Result := False;
  if not PlayObject.sub_4DD704 then begin
    sMonName := g_Config.sBoneFamm;
    nMakeLevel := UserMagic.btLevel;
    nExpLevel := UserMagic.btLevel;
    nCount := g_Config.nBoneFammCount;
    dwRoyaltySec := 10 * 24 * 60 * 60;
    for i := Low(g_Config.BoneFammArray) to High(g_Config.BoneFammArray) do begin
      if g_Config.BoneFammArray[i].nHumLevel = 0 then break;
      if PlayObject.m_Abil.Level >= g_Config.BoneFammArray[i].nHumLevel then begin
        sMonName := g_Config.BoneFammArray[i].sMonName;
        nExpLevel := g_Config.BoneFammArray[i].nLevel;
        nCount := g_Config.BoneFammArray[i].nCount;
      end;
    end;
    if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
      Result := True;
  end;
end;

function TMagicManager.MagMakeSlave_(PlayObject: TPlayObject; UserMagic: pTUserMagic; sMonName: string; nCount, nHumLevel, nMonLevel: Integer): Boolean;
var
  nMakeLevel, nExpLevel: Integer;
  dwRoyaltySec: LongWord;
begin
  Result := False;
  if not PlayObject.sub_4DD704 then begin
    nMakeLevel := UserMagic.btLevel;
    nExpLevel := UserMagic.btLevel;
    nCount := g_Config.nBoneFammCount;
    dwRoyaltySec := 10 * 24 * 60 * 60;
    if PlayObject.m_Abil.Level >= nHumLevel then begin
      nExpLevel := nMonLevel;
    end;
  end;
  if PlayObject.MakeSlave(sMonName, nMakeLevel, nExpLevel, nCount, dwRoyaltySec) <> nil then
    Result := True;
end;

function TMagicManager.MagMakeSelf(BaseObject, TargeTBaseObject: TBaseObject; UserMagic: pTUserMagic): Boolean;
var
  sMonName: string;
  //nMakeLevel, nExpLevel: Integer;
  nCount: Integer;
  dwRoyaltySec: LongWord;
  boboAllowReCallMob: Boolean;
  BaseObject01: TBaseObject;
begin
  Result := False;
  boboAllowReCallMob := False;
  BaseObject01 := nil;
  if not BaseObject.sub_4DD704 then begin
    if g_Config.boAddMasterName then begin
      sMonName := BaseObject.m_sCharName + g_Config.sCopyHumName;
    end else begin
      sMonName := g_Config.sCopyHumName;
    end;
    nCount := g_Config.nAllowCopyHumanCount;
    dwRoyaltySec := 10 * 24 * 60 * 60;
    if g_Config.boAllowReCallMobOtherHum then begin
      if (TargeTBaseObject <> nil) and (not TargeTBaseObject.m_boDeath) then begin
        if TargeTBaseObject.m_btRaceServer = RC_PLAYOBJECT then begin
          BaseObject01 := TargeTBaseObject;
          boboAllowReCallMob := True;
        end;
      end else begin
        BaseObject01 := BaseObject;
        boboAllowReCallMob := True;
      end;
      if g_Config.boNeedLevelHighTarget and (TargeTBaseObject <> nil) and (BaseObject.m_Abil.Level < TargeTBaseObject.m_Abil.Level) then boboAllowReCallMob := False;
    end else begin
      BaseObject01 := BaseObject;
      boboAllowReCallMob := True;
    end;
    if boboAllowReCallMob then begin
      if BaseObject.MakeSelf(BaseObject01, sMonName, nCount, dwRoyaltySec) <> nil then
        Result := True;
    end;
  end;
end;

{for i:=0 to g_BindItemTypeList.Count-1 do begin

  MainOutMessage(pTBindItem(g_BindItemTypeList.Items[i]).sUnbindItemName);
end;}


function TMagicManager.MagGroupMb(PlayObject: TPlayObject;
  UserMagic: pTUserMagic; nTargetX, nTargetY: Integer;
  TargeTBaseObject: TBaseObject): Boolean;
var
  i: Integer;
  BaseObjectList: TList;
  BaseObject: TBaseObject;
  nPower: Integer;
  StdItem: pTStdItem;
  nTime: Integer;
begin
  Result := False;
  BaseObjectList := TList.Create;
  nTime := 5 * UserMagic.btLevel + 1;
  PlayObject.GetMapBaseObjects(PlayObject.m_PEnvir, PlayObject.m_nCurrX, PlayObject.m_nCurrY, UserMagic.btLevel + 2, BaseObjectList);
  for i := 0 to BaseObjectList.Count - 1 do begin
    BaseObject := TBaseObject(BaseObjectList.Items[i]);
    if BaseObject.m_boDeath or (BaseObject.m_boGhost) or (PlayObject = BaseObject) then Continue;
    if (BaseObject.m_btRaceServer = RC_PLAYOBJECT) and (not g_Config.boGroupMbAttackPlayObject) then Continue;
    if (BaseObject.m_btRaceServer <> RC_PLAYOBJECT) and (BaseObject.m_Master <> nil) and (not g_Config.boGroupMbAttackSlave) then Continue;
    if PlayObject.IsProperTarget(BaseObject) then begin
      if not BaseObject.m_boUnParalysis and (Random(BaseObject.m_btAntiPoison) = 0) then begin
        if (BaseObject.m_Abil.Level < PlayObject.m_Abil.Level) or (Random(PlayObject.m_Abil.Level - BaseObject.m_Abil.Level) = 0) then begin
          BaseObject.MakePosion(POISON_STONE, nTime, 0);
          BaseObject.m_boFastParalysis := True;
        end;
      end;
    end;
    if PlayObject.m_btRaceServer = RC_PLAYMOSTER then Result := True
    else if BaseObject.m_btRaceServer >= RC_ANIMAL then Result := True;
  end;
  BaseObjectList.Free;
end;

end.

