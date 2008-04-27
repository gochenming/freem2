unit Event;

interface

uses
  svn, Windows,Classes,SysUtils,SyncObjs,ObjBase,Envir,mudutil,Grobal2,SDK;
type
  TEvent = class;

  pTMagicEvent=^TMagicEvent;
  TMagicEvent=record
    BaseObjectList:TList;
    dwStartTick:DWord;
    dwTime:DWord;
    Events:Array[0..7] of TEvent;
  end;

  TEvent = class   //0x40
    nVisibleFlag      :Integer; //0x04
    m_Envir           :TEnvirnoment;
    m_nX              :Integer;//0x0C
    m_nY              :Integer; //0x10
    m_nEventType      :Integer; //0x14
    m_nEventParam     :Integer; //0x18
    m_dwOpenStartTick :LongWord; //0x1C
    m_dwContinueTime  :LongWord;   //0x20  ��ʾʱ�䳤��
    m_dwCloseTick     :LongWord;  //0x24
    m_boClosed        :Boolean;   //0x28
    m_nDamage         :Integer;  ///0x2C
    m_OwnBaseObject   :TBaseObject;      //0x30
    m_dwRunStart      :LongWord;  //0x34
    m_dwRunTick       :LongWord;   //0x38
    m_boVisible       :Boolean; //0x3C
    m_boActive        :Boolean; //0x3D
  public
    constructor Create(tEnvir: TEnvirnoment; ntX, ntY, nType, dwETime: Integer;boVisible:Boolean);
    destructor Destroy; override;
    procedure Run();virtual;
    procedure Close();
  end;
  TStoneMineEvent = class(TEvent) //0x4C
    m_nMineCount           :Integer; //0x40
    m_nAddStoneCount       :Integer; //0x44
    m_dwAddStoneMineTick   :LongWord;//0x48
  public
    constructor Create(Envir:TEnvirnoment;nX,nY:Integer;nType:Integer);
    destructor Destroy; override;
    procedure AddStoneMine();
  end;
  TPileStones = class(TEvent) //0x40
  public
    constructor Create(Envir:TEnvirnoment;nX,nY:Integer;nType,nTime:Integer);
    destructor Destroy; override;
    procedure  AddEventParam();
  end;
  THolyCurtainEvent = class(TEvent) //0x40
  public
    constructor Create(Envir:TEnvirnoment;nX,nY:Integer;nType,nTime:Integer);
    destructor Destroy; override;
  end;
  TFireBurnEvent = class(TEvent) //0x44
    m_dwRunTick    :LongWord;
  public
    constructor Create(Creat:TBaseObject;nX,nY:Integer;nType:Integer;nTime,nDamage:Integer);
    destructor Destroy; override;
    procedure Run();override;
  end;

  TFireBurnEvent2 = class(TEvent)
    m_dwRunTick    :LongWord;
  public
    constructor Create(Creat:TBaseObject;nX,nY:Integer;nType:Integer;nTime,nPower:Integer);
    destructor Destroy; override;
    procedure Run();override;
  end;
  TEventManager = class  //0x0C
    m_EventList       :TGList;
    m_ClosedEventList :TGList;
  public
    constructor Create();
    destructor Destroy; override;
    function   GetEvent(Envir:TEnvirnoment;nX,nY:Integer;nType:Integer):TEvent;
    procedure  AddEvent(Event:TEvent);
    procedure  Run();
  end;
implementation

uses M2Share;

{ TStoneMineEvent }

constructor TStoneMineEvent.Create(Envir: TEnvirnoment; nX, nY,
  nType: Integer); //004A7D0C
begin
  inherited Create(Envir,nX,nY,nType,0,False);
  m_Envir.AddToMapMineEvent(nX,nY,OS_EVENTOBJECT,Self);
  m_boVisible:=False;
  m_nMineCount:=Random(200);
  m_dwAddStoneMineTick:=GetTickCount();
  m_boActive:=False;
  m_nAddStoneCount:=Random(80);
end;

destructor TStoneMineEvent.Destroy;
begin

  inherited;
end;
{ TEventManager }
procedure TEventManager.Run; //004A8190
var
  i: Integer;
  Event:TEvent;
begin
  m_EventList.Lock;
  try
    for i := m_EventList.Count -1 downto 0 do begin
      Event:=TEvent(m_EventList.Items[i]);
      if Event.m_boActive and ((GetTickCount - Event.m_dwRunStart) > Event.m_dwRunTick) then begin
        Event.m_dwRunStart:=GetTickcount();
        Event.Run();

        if Event.m_boClosed then begin
          m_ClosedEventList.Lock;
          try
            m_ClosedEventList.Add(Event);
          finally
            m_ClosedEventList.UnLock;
          end;
          m_EventList.Delete(i);
        end;
      end;
    end;
  finally
    m_EventList.UnLock;
  end;


  m_ClosedEventList.Lock;
  try
    for i := m_ClosedEventList.Count -1 downto 0 do begin
      Event:=TEvent(m_ClosedEventList.Items[i]);
      if (GetTickCount - Event.m_dwCloseTick) > 5 * 60 * 1000 then begin
        m_ClosedEventList.Delete(i);
        Event.Free;
      end;
    end;
  finally
    m_ClosedEventList.UnLock;
  end;
end;

function TEventManager.GetEvent(Envir: TEnvirnoment; nX, nY,
  nType: Integer): TEvent; //004A810C
var
  I: Integer;
  Event:TEvent;
begin
  Result:=nil;
  m_EventList.Lock;
  try
    for I := 0 to m_EventList.Count - 1 do begin
      Event:=TEvent(m_EventList.Items[i]);
      if (Event.m_Envir = Envir) and
         (Event.m_nX = nX) and
         (Event.m_nY = nY) and
         (Event.m_nEventType = nType) then begin

        Result:=Event;
        break;
      end;
    end;
  finally
    m_EventList.UnLock;
  end;
end;

procedure TEventManager.AddEvent(Event: TEvent); //004A80EC
begin
  m_EventList.Lock;
  try
    m_EventList.Add(Event);
  finally
    m_EventList.UnLock;
  end;
end;

constructor TEventManager.Create(); //004A8014
begin
  m_EventList:=TGList.Create;
  m_ClosedEventList:=TGList.Create;
end;

destructor TEventManager.Destroy;
var
  I: Integer;
begin
  for I := 0 to m_EventList.Count - 1 do begin
    TEvent(m_EventList.Items[i]).Free;
  end;
  m_EventList.Free;
  for I := 0 to m_ClosedEventList.Count - 1 do begin
    TEvent(m_ClosedEventList.Items[i]).Free;
  end;
  m_ClosedEventList.Free;
  inherited;
end;


{ THolyCurtainEvent }

constructor THolyCurtainEvent.Create(Envir: TEnvirnoment; nX, nY, nType,  nTime: Integer); //004A7E60
begin
  inherited Create(Envir,nX,nY,nType,nTime,True);
end;

destructor THolyCurtainEvent.Destroy;
begin

  inherited;
end;

{ TFireBurnEvent }

constructor TFireBurnEvent.Create(Creat: TBaseObject; nX, nY, nType, nTime,nDamage: Integer); //004A7EBC
begin
  inherited Create(Creat.m_PEnvir,nX,nY,nType,nTime,True);
  m_nDamage:=nDamage;
  m_OwnBaseObject:=Creat;
end;

destructor TFireBurnEvent.Destroy;
begin

  inherited;
end;

procedure TFireBurnEvent.Run; //004A7F30
var
  I: Integer;
  BaseObjectList:TList;
  TargeTBaseObject:TBaseObject;
begin
  if (GetTickCount - m_dwRunTick) > 3000 then begin
    m_dwRunTick:=GetTickCount();
    BaseObjectList:=TList.Create;
    if m_Envir <> nil then begin
      m_Envir.GeTBaseObjects(m_nX,m_nY,True,BaseObjectList);
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject:=TBaseObject(BaseObjectList.Items[i]);
        if (TargeTBaseObject <> nil) and (m_OwnBaseObject <> nil) and (m_OwnBaseObject.IsProperTarget(TargeTBaseObject)) then begin
          TargeTBaseObject.SendMsg(m_OwnBaseObject,RM_MAGSTRUCK_MINE,0,m_nDamage,0,0,'');
        end;
      end;
    end;
    BaseObjectList.Free;
  end;    
  inherited; 
end;

{ TFireBurnEvent2 }

constructor TFireBurnEvent2.Create(Creat: TBaseObject; nX, nY, nType, nTime,nPower: Integer); //004A7EBC
begin
  inherited Create(Creat.m_PEnvir,nX,nY,nType,nTime,True);
  m_nDamage:=nPower;
  m_OwnBaseObject:=Creat;
end;

destructor TFireBurnEvent2.Destroy;
begin

  inherited;
end;
procedure TFireBurnEvent2.Run; //004A7F30
var
  I: Integer;
  BaseObjectList:TList;
  TargeTBaseObject:TBaseObject;
  PlayObject: TBaseObject;
  WAbil:pTAbility;
  nPower: Integer;
    nTime2: Integer;
begin
  if (GetTickCount - m_dwRunTick) > 3000 then begin
    m_dwRunTick:=GetTickCount();
    BaseObjectList:=TList.Create;
    if m_Envir <> nil then begin
      m_Envir.GeTBaseObjects(m_nX,m_nY,True,BaseObjectList);
      for I := 0 to BaseObjectList.Count - 1 do begin
        TargeTBaseObject:=TBaseObject(BaseObjectList.Items[i]);
        if (TargeTBaseObject <> nil) and (m_OwnBaseObject <> nil) and (m_OwnBaseObject.IsProperTarget(TargeTBaseObject)) then begin
          TargeTBaseObject.SendMsg(m_OwnBaseObject,RM_MAGSTRUCK_MINE,0,m_nDamage,0,0,'');
           if playObject.m_WAbil.SC > 90 then begin
          TargeTBaseObject.SendDelayMsg(PlayObject,RM_POISON,POISON_DECHEALTH,nTime2 + PlayObject.m_nPoisonIncrease,Integer(PlayObject),ROUND(g_Config.nAmyOunsulPoint),'',1000);
          nTime2 :=(Random(SmallInt(HiWord(WAbil.SC) - (HiWord(WAbil.SC) - 20))));
          TargeTBaseObject.MakePosion(POISON_DECHEALTH,nTime2,1);
          end else
          TargeTBaseObject.MakePosion(POISON_DECHEALTH,10,1);


        end;
      end;
    BaseObjectList.Free;
  end;
  inherited;
end;
end;

{ TEvent }

constructor TEvent.Create(tEnvir: TEnvirnoment; ntX, ntY, nType, dwETime: Integer;boVisible:Boolean); //004A7B68
begin
  m_dwOpenStartTick:=GetTickCount();
  m_nEventType:=nType;
  m_nEventParam:=0;
  m_dwContinueTime:=dwETime;
  m_boVisible:=boVisible;
  m_boClosed:=False;
  m_Envir:=tEnvir;
  m_nX:=ntX;
  m_nY:=ntY;
  m_boActive:=True;
  m_nDamage:=0;
  m_OwnBaseObject:=nil;
  m_dwRunStart:=GetTickCount();
  m_dwRunTick:=500;
  if (m_Envir <> nil) and (m_boVisible) then begin
    m_Envir.AddToMap(m_nX,m_nY,OS_EVENTOBJECT,Self);
  end else m_boVisible:=False;
  //EventCheck.Add(Self);
end;

destructor TEvent.Destroy;
begin

  inherited;
end;

procedure TEvent.Run; //004A7CE0
begin
  if (GetTickCount - m_dwOpenStartTick) > m_dwContinueTime then begin
    m_boClosed:=True;
    Close();
  end;
  if (m_OwnBaseObject <> nil) and (m_OwnBaseObject.m_boGhost or (m_OwnBaseObject.m_boDeath)) then
    m_OwnBaseObject:=nil;
end;

procedure TEvent.Close; //004A7C8C
begin
  m_dwCloseTick:=GetTickCount();
  if m_boVisible then begin
    m_boVisible:=False;
    if m_Envir <> nil then begin
      m_Envir.DeleteFromMap(m_nX,m_nY,OS_EVENTOBJECT,Self);
    end;
    m_Envir:=nil;
  end;
end;


{ TPileStones }

constructor TPileStones.Create(Envir: TEnvirnoment; nX, nY, nType,
  nTime: Integer); //004A7DDC
begin
  inherited Create(Envir,nX,nY,nType,nTime,True);
  m_nEventParam:=1;
end;

destructor TPileStones.Destroy;
begin

  inherited;
end;

procedure TPileStones.AddEventParam;//sub_4A7E44;
begin
  if m_nEventParam < 5 then Inc(m_nEventParam);    
end;

procedure TStoneMineEvent.AddStoneMine; //004A7DB8
begin
  m_nMineCount:=m_nAddStoneCount;
  m_dwAddStoneMineTick:=GetTickCount();
end;


{---- Adjust global SVN revision ----}
initialization
  SVNRevision('$Id: Event.pas 517 2006-12-15 14:54:40Z damian $');
end.
