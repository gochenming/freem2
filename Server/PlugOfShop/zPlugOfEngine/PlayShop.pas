unit PlayShop;

interface
uses
  Windows, SysUtils, ExtCtrls, Classes, EngineAPI, EngineType;
const
  //商铺相关
  CM_OPENSHOP = 8001;
  CM_BUYSHOPITEM = 8002;
  RM_OPENSHOP = 30001;
  RM_BUYSHOPITEM_SUCCESS = 30002;
  RM_BUYSHOPITEM_FAIL = 30003;
  SM_SENGSHOPITEMS = 9001; // SERIES 7 每页的数量    wParam 总页数
  BUFFERSIZE = 10000;
procedure LoadShopItemList();
procedure UnLoadShopItemList();
procedure InitPlayShop();
procedure UnInitPlayShop();

procedure ClientGetShopItemList(PlayObject: TPlayObject; nPage: Integer; MsgObject: TObject);
function PlayObjectOperateMessage(BaseObject: TObject;
  wIdent: Word;
  wParam: Word;
  nParam1: Integer;
  nParam2: Integer;
  nParam3: Integer;
  MsgObject: TObject;
  dwDeliveryTime: LongWord;
  pszMsg: PChar;
  var boReturn: Boolean): Boolean; stdcall;

var
  OldPlayOperateMessage: _TOBJECTOPERATEMESSAGE;
implementation
uses PlugShare, HUtil32;
procedure InitPlayShop();
begin
  OldPlayOperateMessage := TPlayObject_GetHookPlayOperateMessage();
  TPlayObject_SetHookPlayOperateMessage(PlugHandle, PlayObjectOperateMessage);
end;

procedure UnInitPlayShop();
begin
  TPlayObject_SetHookPlayOperateMessage(PlugHandle, OldPlayOperateMessage);
  UnLoadShopItemList();
end;

function MakeDefaultMsg(wIdent: Word; nRecog: Integer; wParam, wTag, wSeries: Word): _TDEFAULTMESSAGE;
begin
  Result.nRecog := nRecog;
  Result.wIdent := wIdent;
  Result.wParam := wParam;
  Result.wTag := wTag;
  Result.wSeries := wSeries;
end;

procedure ClientGetShopItemList(PlayObject: TPlayObject; nPage: Integer; MsgObject: TObject);
  function GetPageCount(nItemListCount: Integer): Integer;
  begin
    Result := 0;
    if nItemListCount > 0 then begin
      Result := nItemListCount div 7;
      if (nItemListCount mod 7) > 0 then Inc(Result);
    end;
  end;
var
  I: Integer;
  n01: Integer;
  sSendStr: string;
  s01: string;
  pShopInfo: pTShopInfo;
  ShopInfo: TShopInfo;
  nPageCount: Integer;
  pszDest: array[0..BUFFERSIZE - 1] of Char;
begin
  if g_ShopItemList = nil then Exit;
  n01 := 0;
  sSendStr := '';
  nPageCount := GetPageCount(g_ShopItemList.Count);
  if nPage > 0 then begin
    if g_ShopItemList.Count >= nPage * 7 then begin
      for I := nPage * 7 to g_ShopItemList.Count - 1 do begin
        Inc(n01);
        pShopInfo := pTShopInfo(g_ShopItemList.Items[I]);
        ShopInfo := pShopInfo^;
        EDcode_EncodeBuffer(@ShopInfo, SizeOf(TShopInfo), pszDest);
        sSendStr := sSendStr + StrPas(@pszDest);
        if n01 >= 7 then break;
      end;
    end;
  end else begin
    for I := 0 to g_ShopItemList.Count - 1 do begin
      Inc(n01);
      pShopInfo := pTShopInfo(g_ShopItemList.Items[I]);
      ShopInfo := pShopInfo^;
      EDcode_EncodeBuffer(@ShopInfo, SizeOf(TShopInfo), pszDest);
      sSendStr := sSendStr + StrPas(@pszDest);
      if n01 >= 7 then break;
    end;
  end;
  if sSendStr <> '' then begin
    TBaseObject_SendMsg(PlayObject, MsgObject, RM_OPENSHOP, 0, nPageCount, nPage + 1, n01, PChar(sSendStr));
  end;
end;

function GetStdItem(sItemName: string): _LPTSTDITEM; //004AC348
var
  I: Integer;
  ShopInfo: pTShopInfo;
begin
  Result := nil;
  if sItemName = '' then Exit;
  for I := 0 to g_ShopItemList.Count - 1 do begin
    ShopInfo := g_ShopItemList.Items[I];
    if CompareText(ShopInfo.StdItem.szName, sItemName) = 0 then begin
      Result := @ShopInfo.StdItem;
      break;
    end;
  end;
end;

procedure ClientBuyShopItem(PlayObject: TPlayObject; MsgObject: TObject; pszMsg: PChar);
var
  sItemName: string;
  I: Integer;
  ShopInfo: pTShopInfo;
  StdItem: _LPTSTDITEM;
  AddStdItem: _LPTSTDITEM;
  nGameGold: Integer;
  UserItem: _LPTUSERITEM;
  nPrice: Integer;
  pszDest: array[0..BUFFERSIZE - 1] of Char;
begin
  EDcode_DeCodeString(pszMsg, pszDest);
  sItemName := StrPas(@pszDest);
  StdItem := GetStdItem(sItemName);
  if StdItem <> nil then begin
    nGameGold := TPlayObject_nGameGold(PlayObject)^;
    nPrice := StdItem.nPrice div 100;
    if (nGameGold >= nPrice) and (nPrice >= 0) then begin
      if TPlayObject_IsEnoughBag(PlayObject) then begin
        New(UserItem);
        TUserEngine_CopyToUserItemFromName(PChar(sItemName), UserItem);
        if TBaseObject_AddItemToBag(PlayObject, UserItem) then begin
          TPlayObject_DecGameGold(PlayObject, nPrice);
          TPlayObject_SendAddItem(PlayObject, UserItem);
          TBaseObject_SendMsg(PlayObject, TPlayObject(MsgObject), RM_BUYSHOPITEM_SUCCESS, 0, 0, 0, 0, PChar(sItemName));
        end;
        DisPose(UserItem);
      end else begin
        TBaseObject_SendMsg(PlayObject, TPlayObject(MsgObject), RM_BUYSHOPITEM_FAIL, 0, 3, 0, 0, PChar(sItemName)); //包裹满
      end;
    end else begin
      TBaseObject_SendMsg(PlayObject, TPlayObject(MsgObject), RM_BUYSHOPITEM_FAIL, 0, 1, 0, 0, PChar(sItemName));
    end;
  end else begin
    TBaseObject_SendMsg(PlayObject, TPlayObject(MsgObject), RM_BUYSHOPITEM_FAIL, 0, 2, 0, 0, PChar(sItemName));
  end;
end;

function PlayObjectOperateMessage(BaseObject: TObject;
  wIdent: Word;
  wParam: Word;
  nParam1: Integer;
  nParam2: Integer;
  nParam3: Integer;
  MsgObject: TObject;
  dwDeliveryTime: LongWord;
  pszMsg: PChar;
  var boReturn: Boolean): Boolean; stdcall;
var
  m_DefMsg: _TDEFAULTMESSAGE;
  GameGoldName: _LPTSHORTSTRING;
  szGameGoldName: array[0..256] of Char;
  sGameGoldName: string;
  dwClientTick: LongWord;
begin
  Result := TRUE;
  case wIdent of
    CM_OPENSHOP: begin
        dwClientTick := TPlayObject_GetPlayObjectTick(BaseObject, 0)^;
        if GetTickCount - dwClientTick >= 1000 then begin
          TPlayObject_SetPlayObjectTick(BaseObject, 0);
          ClientGetShopItemList(TPlayObject(BaseObject), nParam2, MsgObject);
        end;
      end;
    CM_BUYSHOPITEM: begin
        dwClientTick := TPlayObject_GetPlayObjectTick(BaseObject, 1)^;
        if GetTickCount - dwClientTick >= 1000 * 3 then begin
          TPlayObject_SetPlayObjectTick(BaseObject, 1);
          ClientBuyShopItem(BaseObject, MsgObject, pszMsg);
        end;
      end;
    RM_BUYSHOPITEM_SUCCESS: begin
        TBaseObject_GameGoldChanged(BaseObject);
      end;
    RM_BUYSHOPITEM_FAIL: begin
        case nParam1 of
          1: begin
              GameGoldName := GetGameGoldName;
              ShortStringToPChar(GameGoldName, szGameGoldName);
              sGameGoldName := szGameGoldName;
              TBaseObject_SysMsg(BaseObject, PChar('你的 ' + sGameGoldName + ' 不够无法购买 ' + pszMsg), mc_Red, mt_Hint);
            end;
          2: TBaseObject_SysMsg(BaseObject, PChar('你的包裹已满，请清理后在购买 ' + pszMsg), mc_Red, mt_Hint);
          3: TBaseObject_SysMsg(BaseObject, PChar('没有找到 ' + pszMsg), mc_Red, mt_Hint);
        end;
      end;
    RM_OPENSHOP: begin
        m_DefMsg := MakeDefaultMsg(SM_SENGSHOPITEMS, wParam, nParam1, nParam2, nParam3);
        TPlayObject_SendSocket(BaseObject, @m_DefMsg, pszMsg);
      end;
    else begin
        if Assigned(OldPlayOperateMessage) then begin
          Result := OldPlayOperateMessage(BaseObject,
            wIdent,
            wParam,
            nParam1,
            nParam2,
            nParam3,
            MsgObject,
            dwDeliveryTime,
            pszMsg,
            boReturn);
          if not Result then boReturn := TRUE;
        end else begin
          boReturn := TRUE;
          Result := False;
        end;
      end;
  end;
end;

procedure LoadShopItemList();
var
  I: Integer;
  sFileName: string;
  LoadList: Classes.TStringList;
  sLineText: string;
  sItemName: string;
  sPrice: string;
  sIntroduce: string;
  nPrice: Integer;
  StdItem: _LPTSTDITEM;
  ShopInfo: pTShopInfo;
  sName: string;
begin
  if g_ShopItemList <> nil then begin
    UnLoadShopItemList();
  end;
  g_ShopItemList := Classes.TList.Create();
  sFileName := '.\BuyItemList.txt';
  if not FileExists(sFileName) then begin
    LoadList := Classes.TStringList.Create();
    LoadList.Add(';引擎插件商铺配置文件');
    LoadList.Add(';物品名称'#9'出售价格'#9'描述');
    LoadList.SaveToFile(sFileName);
    LoadList.Free;
    Exit;
  end;
  g_ShopItemList.Clear;
  LoadList := Classes.TStringList.Create();
  LoadList.LoadFromFile(sFileName);
  for I := 0 to LoadList.Count - 1 do begin
    sLineText := LoadList.Strings[I];
    if (sLineText <> '') and (sLineText[1] <> ';') then begin
      SetLength(sIntroduce, 50);
      sLineText := GetValidStr3(sLineText, sItemName, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sPrice, [' ', #9]);
      sLineText := GetValidStr3(sLineText, sIntroduce, [' ', #9]);
      nPrice := Str_ToInt(sPrice, -1);
      if (sItemName <> '') and (nPrice >= 0) and (sIntroduce <> '') then begin
        StdItem := TUserEngine_GetStdItemByName(PChar(sItemName));
        if StdItem <> nil then begin
          New(ShopInfo);
          ShopInfo.StdItem := StdItem^;
          ShopInfo.StdItem.nPrice := nPrice * 100;
          FillChar(ShopInfo.sIntroduce, SizeOf(ShopInfo.sIntroduce), 0);
          Move(sIntroduce[1], ShopInfo.sIntroduce, Length(sIntroduce));
          g_ShopItemList.Add(ShopInfo);
        end;
      end;
    end;
  end;
  LoadList.Free;
end;

procedure UnLoadShopItemList();
var
  I: Integer;
  ShopInfo: pTShopInfo;
begin
  if g_ShopItemList <> nil then begin
    for I := 0 to g_ShopItemList.Count - 1 do begin
      ShopInfo := pTShopInfo(g_ShopItemList.Items[I]);
      if ShopInfo <> nil then
        DisPose(ShopInfo);
    end;
    g_ShopItemList.Free;
    g_ShopItemList := nil;
  end;
end;

end.

