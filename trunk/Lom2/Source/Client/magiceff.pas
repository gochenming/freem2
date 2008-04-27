unit magiceff;

interface

uses
  svn, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grobal2, DxDraws, CliUtil, ClFunc, HUtil32, WIl;

const
   MG_READY       = 10;
   MG_FLY         = 6;
   MG_EXPLOSION   = 10;
   READYTIME  = 120;
   EXPLOSIONTIME = 100;
   FLYBASE = 10;
   EXPLOSIONBASE = 170;
   //EFFECTFRAME = 260;
   MAXMAGIC = 10;
   FLYOMAAXEBASE = 447;
   THORNBASE = 2967;
   ARCHERBASE = 2607;
   ARCHERBASE2 = 272; //2609;
   TDBBASE = 210;
   FLYFORSEC = 500;
   FIREGUNFRAME = 6;

   MAXEFFECT = 58;

  EffectBase: array[0..MAXEFFECT-1] of integer = (
    0,{1}
    200,{2}
    400,{3}
    600,{4}
    0,{5}
    900,{6}
    920,{7}
    940,{8}
    20,{9}
    940,{10}
    940,{11}
    940,{12}
    0,{13}
    1380,{14}
    1500,{15}
    1520,{16}
    940,{17}
    1560,{18}
    1590,{19}
    1620,{20}
    1650,{21}
    1680,{22}
    0,{23}
    0,{24}
    0,{25}
    3960,{26}
    1790,{27}
    0,{28}
    3880,{29}
    3920,{30}
    3840,{31}
    0,{32}
    40,{33}
    130, {34}
    160,{35}
    190,{36}
    0,{37}
    210,{38}
    400,{39}
    600,{40}
    1500,{41}
    650,{42}
    710,{43}
    740,{44}
    910,{45}
    940,{46}
    990,{47}
    1040,{48}
    1110, {49}
    1510, {50}
    1520, {51}
    1540, {52}
    1590, {53}
    1680, {54}
    940, {55}
    1700, {56}
    940, {57}
    1880 {58}
    );
   MAXHITEFFECT = 9;
  HitEffectBase: array[0..MAXHITEFFECT-1] of integer = (
    800,
    1410,
    1700,
    3480,
    3390,
    40,
    220,
    740,
    1700
    );
   MAXMAGICTYPE = 18;

type
   TMagicType = (mtReady,           mtFly,            mtExplosion,
                 mtFlyAxe,          mtFireWind,       mtFireGun,
                 mtLightingThunder, mtThunder,        mtExploBujauk,
                 mtBujaukGroundEffect, mtKyulKai,     mtFlyArrow,
                 mt12,              mt13,             mt14,
                 mt15,              mt16,             mtRedThunder,
                 mtLava,            mtRedFoxThunder,  mtRedFoxFire,
                 mtIceSickle,       mtFoxAnnoy,       mtFoxThunder
                 );

   TUseMagicInfo = record
      ServerMagicCode: integer;
      MagicSerial: integer;
      MimicSerial: integer;
      Target: integer; //recogcode
      EffectType: TMagicType;
      EffectNumber: integer;
      TargX: integer;
      TargY: integer;
      Recusion: Boolean;
      AniTime: integer;
   end;
   PTUseMagicInfo = ^TUseMagicInfo;

   TMagicEff = class//Size 0xC8
      m_boActive: Boolean;           //0x04
      ServerMagicId: integer;    //0x08
      magnumber: integer;
      MagOwner: TObject;         //0x0C
      TargetActor: TObject;      //0x10
      ImgLib: TWMImages;         //0x14
      EffectBase: integer;       //0x18
      MagExplosionBase: integer; //0x1C
      px, py: integer;           //0x20 0x24
      RX, RY: integer;           //0x28 0x2C
      Dir16, OldDir16: byte;        //0x30  0x31
      TargetX, TargetY: integer;    //0x34 0x38
      TargetRx, TargetRy: integer;  //0x3C 0x40
      FlyX, FlyY, OldFlyX, OldFlyY: integer; //0x44 0x48 0x4C 0x50
      FlyXf, FlyYf: Real;        //0x54 0x5C
      Repetition: Boolean;       //0x64
      FixedEffect: Boolean;      //0x65
      MagicType: integer;        //0x68
      NextEffect: TMagicEff;     //0x6C
      ExplosionFrame: integer;   //0x70
      NextFrameTime: integer;    //0x74
      Light: integer;            //0x78
      n7C:Integer;
      bt80:Byte;
      bt81:Byte;
      start: integer;        //0x84
      curframe: integer;     //0x88
      frame: integer;        //0x8C
   private

      m_dwFrameTime: longword;   //0x90
      m_dwStartTime:  longword;  //0x94
      repeattime: longword;  //0x98
      steptime: longword;    //0x9C
      fireX, fireY: integer; //0xA0 0xA4
      firedisX, firedisY: integer;   //0xA8 0xAC
      newfiredisX, newfiredisY: integer;//0xB0 0xB4
      FireMyselfX, FireMyselfY: integer;//0xB8 0xBC
      prevdisx, prevdisy: integer; //0xC0 0xC4
   protected
      procedure GetFlyXY (ms: integer; var fx, fy: integer);
   public
      constructor Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
      destructor Destroy; override;
      function  Run: Boolean; dynamic; //false
      function  Shift: Boolean; dynamic;
      procedure DrawEff (surface: TDirectDrawSurface); dynamic;
   end;

   TFlyingAxe = class (TMagicEff)
      FlyImageBase: integer;
      ReadyFrame: integer;
   public
      constructor Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TFlyingBug = class (TMagicEff)//Size 0xD0
      FlyImageBase: integer;//0xC8
      ReadyFrame: integer;//0xCC
   public
      constructor Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TFlyingArrow = class (TFlyingAxe)
   public
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;
   TFlyingFireBall = class (TFlyingAxe) //0xD0
   public
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;
   TCharEffect = class (TMagicEff)
   public
      constructor Create (effbase, effframe: integer; target: TObject);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TMapEffect = class (TMagicEff)
   public
      RepeatCount: integer;
      constructor Create (effbase, effframe: integer; x, y: integer);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TScrollHideEffect = class (TMapEffect)
   public
      constructor Create (effbase, effframe: integer; x, y: integer; target: TObject);
      function  Run: Boolean; override;
   end;

   TLightingEffect = class (TMagicEff)
   public
      constructor Create (effbase, effframe: integer; x, y: integer);
      function  Run: Boolean; override;
   end;

   TFireNode = record
      x: integer;
      y: integer;
      firenumber: integer;
   end;

   TFireGunEffect = class (TMagicEff)
   public
      OutofOil: Boolean;
      firetime: longword;
      FireNodes: array[0..FIREGUNFRAME-1] of TFireNode;
      constructor Create (effbase, sx, sy, tx, ty: integer);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TThuderEffect = class (TMagicEff)
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TLightingThunder = class (TMagicEff)
   public
      constructor Create (effbase, sx, sy, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TIceSickle = class (TMagicEff)
   public
      constructor Create (effbase, sx, sy, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TExploBujaukEffect = class (TMagicEff)
   public
      constructor Create (effbase, sx, sy, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TBujaukGroundEffect = class (TMagicEff)//Size  0xD0
   public
      MagicNumber: integer;       //0xC8
      BoGroundEffect: Boolean;    //0xCC
      constructor Create (effbase, magicnumb, sx, sy, tx, ty: integer);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;
   TNormalDrawEffect = class (TMagicEff)//Size 0xCC
     boC8:Boolean;
   public
      constructor Create(XX,YY:Integer;WmImage:TWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   THumanEffects = class (TMagicEff)//Size 0xCC
     boC8:Boolean;
   public
      constructor Create(XX,YY:Integer;WmImage:TWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
      function  Run: Boolean; override;
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TObjectEffects = class (TMagicEff)
     ObjectID : TObject;
     boC8:Boolean;
   public
     constructor Create(ObjectiD2:TObject;WmImage:TWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
     function  Run: Boolean; override;
     procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TRedThunderEffect = class (TMagicEff)
    n0:integer;
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;
   TFoxAnnoyEffect = class (TMagicEff)
    n0:integer;
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;
   TFoxThunderEffect = class (TMagicEff)
    n0:integer;
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TLavaEffect = class (TMagicEff)
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TRedFoxThunderEffect = class (TMagicEff)
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   TRedFoxFireEffect = class (TMagicEff)
   public
      constructor Create (effbase, tx, ty: integer; target: TObject);
      procedure DrawEff (surface: TDirectDrawSurface); override;
   end;

   procedure GetEffectBase (mag, mtype: integer; var wimg: TWMImages; var idx: integer);

implementation

uses
   ClMain, Actor, SoundUtil, MShare;

procedure GetEffectBase (mag, mtype: integer; var wimg: TWMImages; var idx: integer);
begin
   wimg := nil;
   idx := 0;

   case mtype of
      0: begin
            case mag of
               8,27,33..35,37..39,41..42,43,44,45,46,47,48,49,50..54,55,57: begin

                 wimg := g_WMagic2Images;
                 if mag in [0..MAXEFFECT-1] then
                   idx := EffectBase[mag];
               end;
               31: begin
                 wimg := FrmMain.WMon21Img;
                 if mag in [0..MAXEFFECT-1] then
                   idx := EffectBase[mag];
               end;
               36: begin
                 wimg := FrmMain.WMon22Img;
                 if mag in [0..MAXEFFECT-1] then
                   idx := EffectBase[mag];
               end;
               80..82: begin
                 wimg := FrmMain.WDragonImg;
                 if mag = 80 then begin
                   if g_Myself.m_nCurrX >= 84 then begin
                     idx:=130;
                   end else begin
                     idx:=140;
                   end;
                 end;
                 if mag = 81 then begin
                   if (g_Myself.m_nCurrX >= 78) and (g_Myself.m_nCurrY >= 48) then begin
                     idx:=150;
                   end else begin
                     idx:=160;
                   end;
                 end;
                 if mag = 82 then begin
                   idx:=180;
                 end;                   
               end;
               89: begin
                 wimg := FrmMain.WDragonImg;
                 idx:=350;
               end;
               90: begin
                  wimg:=FrmMain.WDragonImg;
                  idx:=440
               end;
               91: begin
                  wimg:=FrmMain.WDragonImg;
                  idx:=470
               end;
               92: begin
                  wimg:= g_WMagic2Images;
                  idx:= 1250;
               end;
               else begin
                 wimg := g_WMagicImages;
                 if mag in [0..MAXEFFECT-1] then
                   idx := EffectBase[mag];
               end;
            end;
         end;
      1: begin
        wimg := g_WMagicImages;
        if mag in [0..MAXHITEFFECT-1] then begin
         if mag <> 740 then begin//bladeava û�л���Ч��ͼ��
          idx := HitEffectBase[mag];
         end;
         if mag <> 1700 then begin
          idx := HitEffectBase[mag];
         end;
        end;
        if mag >= 5 then wimg := g_WMagic2Images;
      end;
   end;
end;

constructor TMagicEff.Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
var
   tax, tay: integer;
begin
   ImgLib := g_WMagicImages;
   case mtype of
     mtFly,mtBujaukGroundEffect,mtExploBujauk: begin
       start:=0;
       frame:=6;
       curframe:=start;
       FixedEffect:=False;
       Repetition:=Recusion;
       ExplosionFrame:=10;
       if id = 38 then frame:=10;
       if id = 39 then begin
         frame:=4;
         ExplosionFrame:=8;
       end;
       if id = 44 then begin
       ExplosionFrame:=16;//16
       end;
       {if id = 56 then begin
       ExplosionFrame:=16;
       end;}
       if (id = 81) or (id = 82) or (id = 83)  then begin
         bt80:=1;
         Repetition:=True;
         if id = 81 then begin
         ImgLib:=FrmMain.WDragonImg;
           if g_MySelf.m_nCurrX >= 84 then begin
             EffectBase:=130;
           end else begin
             EffectBase:=140;
           end;
           bt81:=1;
         end;
         if id = 82 then begin
         ImgLib:=FrmMain.WDragonImg;
           if (g_MySelf.m_nCurrX >= 78) and (g_MySelf.m_nCurrY >= 48) then begin
             EffectBase:=150;
           end else begin
             EffectBase:=160;
           end;
           bt81:=2;
         end;
         if id = 83 then begin
         ImgLib:=FrmMain.WDragonImg;
           EffectBase:=180;
           bt81:=3;
         end;
         start:=0;
         frame:=10;
         MagExplosionBase:=200;
         ExplosionFrame:=10;
       end;
     end;
     mt12: begin
       start:=0;
       frame:=6;
       curframe:=start;
       FixedEffect:=False;
       Repetition:=Recusion;
       ExplosionFrame:=1;
     end;
     mt13: begin
       start:=0;
       frame:=20;
       curframe:=start;
       FixedEffect:=True;
       Repetition:=False;
       ExplosionFrame:=20;
       ImgLib:=FrmMain.WMon21Img;
     end;
     mtFoxAnnoy: begin
       start:=0;
       frame:=20;
       curframe:=start;
       FixedEffect:=True;
       Repetition:=False;
       ExplosionFrame:=20;
       ImgLib:=FrmMain.WMon24Img;
     end;
     mtFoxThunder: begin
       start:=0;
       frame:=20;
       curframe:=start;
       FixedEffect:=True;
       Repetition:=False;
       ExplosionFrame:=20;
       ImgLib:=FrmMain.WMon24Img;
     end;
     mtExplosion,mtThunder,mtLightingThunder,mtRedThunder,mtLava,mtRedFoxThunder,mtRedFoxFire,mtIceSickle: begin
       start := 0;
       frame := -1;
       ExplosionFrame := 10;
       curframe := start;
       FixedEffect := TRUE;
       Repetition := FALSE;
       if id = 91 then begin
        bt80:=2;
        frame:=20;
        EffectBase:=440;
        //MagExplosionBase:=470;
        //ExplosionFrame:=20;
        //EffectFrame:=10;
       end;
       if id = 80 then begin
         bt80:=2;
         case Random(6) of
           0:begin
             EffectBase:=230;
           end;
           1:begin
             EffectBase:=240;
           end;
           2:begin
             EffectBase:=250;
           end;
           3:begin
             EffectBase:=260;
           end;
           4:begin
             EffectBase:=270;
           end;
           5:begin
             EffectBase:=280;
           end;
         end;
         Light:=4;
         ExplosionFrame:=5;
         frame:=5;
       end;
       if id = 70 then begin
         bt80:=3;
         case Random(3) of
           0:begin
             EffectBase:=400;
           end;
           1:begin
             EffectBase:=410;
           end;
           2:begin
             EffectBase:=420;
           end;
         end;
         Light:=4;
         ExplosionFrame:=5;
       end;
       if id = 71 then begin
         bt80:=3;
         ExplosionFrame:=20;
       end;
       if id = 72 then begin
         bt80:=3;
         Light:=3;
         ExplosionFrame:=10;
       end;
       if id = 73 then begin
         bt80:=3;
         Light:=5;
         ExplosionFrame:=20;
       end;
       if id = 74 then begin
         bt80:=3;
         Light:=4;
         ExplosionFrame:=35;
       end;
       if id = 90 then begin
       ImgLib:=FrmMain.WDragonImg;
         EffectBase:=350;
         MagExplosionBase:=350;
         ExplosionFrame:=34;
         bt80:=1;
       end;
       if id = 92 then begin
         bt80:=2;
         frame:=-1;
         ImgLib:=g_WMagic2Images;
         EffectBase:=0;
         MagExplosionBase:=1250;
         ExplosionFrame:=14;
       end;
       if id = 93 then begin
         bt80:=2;
         frame:=-1;
         ImgLib:=g_WMagic2Images;
         EffectBase:=0;
         MagExplosionBase:=1280;
         ExplosionFrame:=10;
       end;
     end;
     mt14: begin
       start:=0;
       frame:=-1;
       curframe:=start;
       FixedEffect:=True;
       Repetition:=False;
       ImgLib:=g_WMagic2Images;
     end;
     mtFlyAxe: begin
       start := 0;
       frame := 3;
       curframe := start;
       FixedEffect := FALSE;
       Repetition := Recusion;
       ExplosionFrame := 3;
     end;
     mtFlyArrow: begin
       start := 0;
       frame := 1;
       curframe := start;
       FixedEffect := FALSE;
       Repetition := Recusion;
       ExplosionFrame := 1;
     end;
     mt15: begin
       start := 0;
       frame := 6;
       curframe := start;
       FixedEffect := FALSE;
       Repetition := Recusion;
       ExplosionFrame := 2;
     end;
     mt16: begin
       start := 0;
       frame := 1;
       curframe := start;
       FixedEffect := FALSE;
       Repetition := Recusion;
       ExplosionFrame := 1;
     end;
   end;
   n7C:=0;

   ServerMagicId := id; //ID
   EffectBase := effnum; //MagicDB - Effect
   TargetX := tx;   // "   target x
   TargetY := ty;   // "   target y

   if bt80 =1 then begin
   {
     if id = 81 then begin
       dec(sx,14);
       inc(sy,20);
     end;
     if id = 81 then begin
       dec(sx,70);
       dec(sy,10);
     end;
     if id = 83 then begin
       dec(sx,60);
       dec(sy,70);
     end;
     }
     PlaySound(8208);
   end;
   fireX := sx;     //
   fireY := sy;     //
   FlyX := sx;      //
   FlyY := sy;
   OldFlyX := sx;
   OldFlyY := sy;
   FlyXf := sx;
   FlyYf := sy;
   FireMyselfX := g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX;
   FireMyselfY := g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY;
   if bt80 = 0 then begin
     MagExplosionBase := EffectBase + EXPLOSIONBASE;
   end;

   light := 1;

   if fireX <> TargetX then tax := abs(TargetX-fireX)
   else tax := 1;
   if fireY <> TargetY then tay := abs(TargetY-fireY)
   else tay := 1;
   if abs(fireX-TargetX) > abs(fireY-TargetY) then begin
      firedisX := Round((TargetX-fireX) * (500 / tax));
      firedisY := Round((TargetY-fireY) * (500 / tax));
   end else begin
      firedisX := Round((TargetX-fireX) * (500 / tay));
      firedisY := Round((TargetY-fireY) * (500 / tay));
   end;

   NextFrameTime := 50;
   m_dwFrameTime := GetTickCount;
   m_dwStartTime := GetTickCount;
   steptime := GetTickCount;
   RepeatTime := anitime;
   Dir16 := GetFlyDirection16 (sx, sy, tx, ty);
   OldDir16 := Dir16;
   NextEffect := nil;
   m_boActive := TRUE;
   prevdisx := 99999;
   prevdisy := 99999;
end;

destructor TMagicEff.Destroy;
begin
   inherited Destroy;
end;

function  TMagicEff.Shift: Boolean;
   function OverThrough (olddir, newdir: integer): Boolean;
   begin
      Result := FALSE;
      if abs(olddir-newdir) >= 2 then begin
         Result := TRUE;
         if ((olddir=0) and (newdir=15)) or ((olddir=15) and (newdir=0)) then
            Result := FALSE;
      end;
   end;
var
   i, rrx, rry, ms, stepx, stepy, newstepx, newstepy, nn: integer;
   tax, tay, shx, shy, passdir16: integer;
   crash: Boolean;
   stepxf, stepyf: Real;
begin
   Result := TRUE;
   if Repetition then begin
      if GetTickCount - steptime > longword(NextFrameTime) then begin
         steptime := GetTickCount;
         Inc (curframe);
         if curframe > start+frame-1 then
            curframe := start;
      end;
   end else begin
      if (frame > 0) and (GetTickCount - steptime > longword(NextFrameTime)) then begin
         steptime := GetTickCount;
         Inc (curframe);
         if curframe > start+frame-1 then begin
            curframe := start+frame-1;
            Result := FALSE;
         end;
      end;
   end;
   if (not FixedEffect) then begin

      crash := FALSE;
      if TargetActor <> nil then begin
         ms := GetTickCount - m_dwFrameTime;
         m_dwFrameTime := GetTickCount;
         //TargetX, TargetY
         PlayScene.ScreenXYfromMCXY (TActor(TargetActor).m_nRx,
                                     TActor(TargetActor).m_nRy,
                                     TargetX,
                                     TargetY);
         shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
         shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;
         TargetX := TargetX + shx;
         TargetY := TargetY + shy;

         if FlyX <> TargetX then tax := abs(TargetX-FlyX)
         else tax := 1;
         if FlyY <> TargetY then tay := abs(TargetY-FlyY)
         else tay := 1;
         if abs(FlyX-TargetX) > abs(FlyY-TargetY) then begin
            newfiredisX := Round((TargetX-FlyX) * (500 / tax));
            newfiredisY := Round((TargetY-FlyY) * (500 / tax));
         end else begin
            newfiredisX := Round((TargetX-FlyX) * (500 / tay));
            newfiredisY := Round((TargetY-FlyY) * (500 / tay));
         end;

         if firedisX < newfiredisX then firedisX := firedisX + _MAX(1, (newfiredisX - firedisX) div 10);
         if firedisX > newfiredisX then firedisX := firedisX - _MAX(1, (firedisX - newfiredisX) div 10);
         if firedisY < newfiredisY then firedisY := firedisY + _MAX(1, (newfiredisY - firedisY) div 10);
         if firedisY > newfiredisY then firedisY := firedisY - _MAX(1, (firedisY - newfiredisY) div 10);

         stepxf := (firedisX/700) * ms;
         stepyf := (firedisY/700) * ms;
         FlyXf := FlyXf + stepxf;
         FlyYf := FlyYf + stepyf;
         FlyX := Round (FlyXf);
         FlyY := Round (FlyYf);

       //  Dir16 := GetFlyDirection16 (OldFlyX, OldFlyY, FlyX, FlyY);
         OldFlyX := FlyX;
         OldFlyY := FlyY;

         passdir16 := GetFlyDirection16 (FlyX, FlyY, TargetX, TargetY);

         DebugOutStr (IntToStr(prevdisx) + ' ' + IntToStr(prevdisy) + ' / ' + IntToStr(abs(TargetX-FlyX)) + ' ' + IntToStr(abs(TargetY-FlyY)) + '   ' +
                      IntToStr(firedisX) + '.' + IntToStr(firedisY) + ' ' +
                      IntToStr(FlyX) + '.' + IntToStr(FlyY) + ' ' +
                      IntToStr(TargetX) + '.' + IntToStr(TargetY));
         if ((abs(TargetX-FlyX) <= 15) and (abs(TargetY-FlyY) <= 15)) or
            ((abs(TargetX-FlyX) >= prevdisx) and (abs(TargetY-FlyY) >= prevdisy)) or
            OverThrough(OldDir16, passdir16) then begin
            crash := TRUE;
         end else begin
            prevdisx := abs(TargetX-FlyX);
            prevdisy := abs(TargetY-FlyY);
            //if (prevdisx <= 5) and (prevdisy <= 5) then crash := TRUE;
         end;
         OldDir16 := passdir16;

      end else begin
         ms := GetTickCount - m_dwFrameTime;

         rrx := TargetX - fireX;
         rry := TargetY - fireY;

         stepx := Round ((firedisX/900) * ms);
         stepy := Round ((firedisY/900) * ms);
         FlyX := fireX + stepx;
         FlyY := fireY + stepy;
      end;

      PlayScene.CXYfromMouseXY (FlyX, FlyY, Rx, Ry);

      if crash and (TargetActor <> nil) then begin
         FixedEffect := TRUE;
         start := 0;
         frame := ExplosionFrame;
         curframe := start;
         Repetition := FALSE;

         PlaySound (TActor(MagOwner).m_nMagicExplosionSound);

      end;
      //if not Map.CanFly (Rx, Ry) then
      //   Result := FALSE;
   end;
   if FixedEffect then begin
      if frame = -1 then frame := ExplosionFrame;
      if TargetActor = nil then begin
         FlyX := TargetX - ((g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX);
         FlyY := TargetY - ((g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY);
         PlayScene.CXYfromMouseXY (FlyX, FlyY, Rx, Ry);
      end else begin
         Rx := TActor(TargetActor).m_nRx;
         Ry := TActor(TargetActor).m_nRy;
         PlayScene.ScreenXYfromMCXY (Rx, Ry, FlyX, FlyY);
         FlyX := FlyX + TActor(TargetActor).m_nShiftX;
         FlyY := FlyY + TActor(TargetActor).m_nShiftY;
      end;
   end;
end;

procedure TMagicEff.GetFlyXY (ms: integer; var fx, fy: integer);
var
   rrx, rry, stepx, stepy: integer;
begin
   rrx := TargetX - fireX;
   rry := TargetY - fireY;

   stepx := Round ((firedisX/900) * ms);
   stepy := Round ((firedisY/900) * ms);
   fx := fireX + stepx;
   fy := fireY + stepy;
end;

function  TMagicEff.Run: Boolean;
begin
   Result := Shift;
   if Result then
      if GetTickCount - m_dwStartTime > 10000 then //2000 then
         Result := FALSE
      else Result := TRUE;
end;

procedure TMagicEff.DrawEff (surface: TDirectDrawSurface);
var
  img: integer;
  d: TDirectDrawSurface;
  shx, shy: integer;
begin

   if m_boActive and ((Abs(FlyX-fireX) > 15) or (Abs(FlyY-fireY) > 15) or FixedEffect) then begin

      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         if (ServerMagicid = 81) or (ServerMagicid = 82) or (ServerMagicid = 83) or (magnumber = 47) then begin
           img := EffectBase;
          d := ImgLib.GetCachedImage (img + curframe, px, py);
         end else begin
         img := EffectBase + FLYBASE + Dir16 * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         end;
         if d <> nil then begin
            DrawBlend (surface,
                       FlyX + px - UNITX div 2 - shx,
                       FlyY + py - UNITY div 2 - shy,
                       d, 1);
         end;
      end else begin

         img := MagExplosionBase + curframe; //EXPLOSIONBASE;
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            DrawBlend (surface,
                       FlyX + px - UNITX div 2,
                       FlyY + py - UNITY div 2,
                       d, 1);
         end;
      end;
   end;
end;


{------------------------------------------------------------}

//      TFlyingAxe

{------------------------------------------------------------}


constructor TFlyingAxe.Create (id, effnum, sx, sy, tx, ty: integer; mtype: TMagicType; Recusion: Boolean; anitime: integer);
begin
   inherited Create (id, effnum, sx, sy, tx, ty, mtype, Recusion, anitime);
   FlyImageBase := FLYOMAAXEBASE;
   ReadyFrame := 65;
end;

procedure TFlyingAxe.DrawEff (surface: TDirectDrawSurface);
var
   img: integer;
   d: TDirectDrawSurface;
   shx, shy: integer;
begin
   if m_boActive and ((Abs(FlyX-fireX) > ReadyFrame) or (Abs(FlyY-fireY) > ReadyFrame)) then begin

      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         img := FlyImageBase + Dir16 * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
      end else begin
         {img := FlyImageBase + Dir16 * 10;
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2,
                          FlyY + py - UNITY div 2,
                          d.ClientRect, d, TRUE);
         end;  }
      end;
   end;
end;


{------------------------------------------------------------}

//      TFlyingArrow :

{------------------------------------------------------------}


procedure TFlyingArrow.DrawEff (surface: TDirectDrawSurface);
var
   img: integer;
   d: TDirectDrawSurface;
   shx, shy: integer;
begin
   if m_boActive and ((Abs(FlyX-fireX) > 40) or (Abs(FlyY-fireY) > 40)) then begin
//   if Active then begin //and ((Abs(FlyX-fireX) > 65) or (Abs(FlyY-fireY) > 65)) then begin
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         img := FlyImageBase + Dir16; // * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy - 46,
                          d.ClientRect, d, TRUE);
         end;
{
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
}
      end;
   end;
end;


{--------------------------------------------------------}

constructor TCharEffect.Create (effbase, effframe: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     TActor(target).m_nCurrX, TActor(target).m_nCurrY,
                     TActor(target).m_nCurrX, TActor(target).m_nCurrY,
                     mtExplosion,
                     FALSE,
                     0);
   TargetActor := target;
   frame := effframe;
   NextFrameTime := 30;

end;

function  TCharEffect.Run: Boolean;
begin
   Result := TRUE;
   if GetTickCount - steptime > longword(NextFrameTime) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start+frame-1;
         Result := FALSE;
      end;
   end;
end;

procedure TCharEffect.DrawEff (surface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   if TargetActor <> nil then begin
      Rx := TActor(TargetActor).m_nRx;
      Ry := TActor(TargetActor).m_nRy;
      PlayScene.ScreenXYfromMCXY (Rx, Ry, FlyX, FlyY);
      FlyX := FlyX + TActor(TargetActor).m_nShiftX;
      FlyY := FlyY + TActor(TargetActor).m_nShiftY;
      d := ImgLib.GetCachedImage (EffectBase + curframe, px, py);
      if d <> nil then begin
         DrawBlend (surface,
                    FlyX + px - UNITX div 2,
                    FlyY + py - UNITY div 2,
                    d, 1);
      end;
   end;
end;


{--------------------------------------------------------}

constructor TMapEffect.Create (effbase, effframe: integer; x, y: integer);
begin
   inherited Create (111, effbase,
                     x, y,
                     x, y,
                     mtExplosion,
                     FALSE,
                     0);
   TargetActor := nil;
   frame := effframe;
   NextFrameTime := 30;
   RepeatCount := 0;
end;

function  TMapEffect.Run: Boolean;
begin
   Result := TRUE;
   if GetTickCount - steptime > longword(NextFrameTime) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start+frame-1;
         if RepeatCount > 0 then begin
            Dec (RepeatCount);
            curframe := start;
         end else
            Result := FALSE;
      end;
   end;
end;

procedure TMapEffect.DrawEff (surface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
   Rx := TargetX;
   Ry := TargetY;
   PlayScene.ScreenXYfromMCXY (Rx, Ry, FlyX, FlyY);
   d := ImgLib.GetCachedImage (EffectBase + curframe, px, py);
   if d <> nil then begin
      DrawBlend (surface,
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
   end;
end;


{--------------------------------------------------------}

constructor TScrollHideEffect.Create (effbase, effframe: integer; x, y: integer; target: TObject);
begin
   inherited Create (effbase, effframe, x, y);
   //TargetCret := TActor(target);//�ڳ������������֮��ʱ��������Ŀ��
end;

function  TScrollHideEffect.Run: Boolean;
begin
   Result := inherited Run;
   if frame = 7 then
      if g_TargetCret <> nil then
         PlayScene.DeleteActor (g_TargetCret.m_nRecogId);
end;


{--------------------------------------------------------}


constructor TLightingEffect.Create (effbase, effframe: integer; x, y: integer);
begin

end;

function  TLightingEffect.Run: Boolean;
begin
  Result:=False;
end;


{--------------------------------------------------------}


constructor TFireGunEffect.Create (effbase, sx, sy, tx, ty: integer);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtFireGun,
                     TRUE,
                     0);
   NextFrameTime := 50;
   FillChar (FireNodes, sizeof(TFireNode)*FIREGUNFRAME, #0);
   OutofOil := FALSE;
   firetime := GetTickCount;
end;

function  TFireGunEffect.Run: Boolean;
var
   i, fx, fy: integer;
   allgone: Boolean;
begin
   Result := TRUE;
   if GetTickCount - steptime > longword(NextFrameTime) then begin
      Shift;
      steptime := GetTickCount;
      //if not FixedEffect then begin
      if not OutofOil then begin
         if (abs(RX-TActor(MagOwner).m_nRx) >= 5) or (abs(RY-TActor(MagOwner).m_nRy) >= 5) or (GetTickCount - firetime > 800) then
            OutofOil := TRUE;
         for i:=FIREGUNFRAME-2 downto 0 do begin
            FireNodes[i].FireNumber := FireNodes[i].FireNumber + 1;
            FireNodes[i+1] := FireNodes[i];
         end;
         FireNodes[0].FireNumber := 1;
         FireNodes[0].x := FlyX;
         FireNodes[0].y := FlyY;
      end else begin
         allgone := TRUE;
         for i:=FIREGUNFRAME-2 downto 0 do begin
            if FireNodes[i].FireNumber <= FIREGUNFRAME then begin
               FireNodes[i].FireNumber := FireNodes[i].FireNumber + 1;
               FireNodes[i+1] := FireNodes[i];
               allgone := FALSE;
            end;
         end;
         if allgone then Result := FALSE;
      end;
   end;
end;

procedure TFireGunEffect.DrawEff (surface: TDirectDrawSurface);
var
   i, num, shx, shy, firex, firey, prx, pry, img: integer;
   d: TDirectDrawSurface;
begin
   prx := -1;
   pry := -1;
   for i:=0 to FIREGUNFRAME-1 do begin
      if (FireNodes[i].FireNumber <= FIREGUNFRAME) and (FireNodes[i].FireNumber > 0) then begin
         shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
         shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

         img := EffectBase + (FireNodes[i].FireNumber - 1);
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            firex := FireNodes[i].x + px - UNITX div 2 - shx;
            firey := FireNodes[i].y + py - UNITY div 2 - shy;
            if (firex <> prx) or (firey <> pry) then begin
               prx := firex;
               pry := firey;
               DrawBlend (surface, firex, firey, d, 1);
            end;
         end;
      end;
   end;
end;

{--------------------------------------------------------}

constructor TThuderEffect.Create (effbase, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtThunder,
                     FALSE,
                     0);
   TargetActor := target;

end;

procedure TThuderEffect.DrawEff (surface: TDirectDrawSurface);
var
   img, px, py: integer;
   d: TDirectDrawSurface;
begin
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + curframe, px, py);
   if d <> nil then begin
      DrawBlend (surface,
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
   end;
end;


{--------------------------------------------------------}

constructor TLightingThunder.Create (effbase, sx, sy, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtLightingThunder,
                     FALSE,
                     0);
   TargetActor := target;
end;

procedure TLightingThunder.DrawEff (surface: TDirectDrawSurface);
var
   img, sx, sy, px, py, shx, shy: integer;
   d: TDirectDrawSurface;
begin
   img := EffectBase + Dir16 * 10;
   if curframe < 6 then begin

      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      d := ImgLib.GetCachedImage (img + curframe, px, py);
      if d <> nil then begin
         PlayScene.ScreenXYfromMCXY (TActor(MagOwner).m_nRx,
                                     TActor(MagOwner).m_nRy,
                                     sx,
                                     sy);
         DrawBlend (surface,
                    sx + px - UNITX div 2,
                    sy + py - UNITY div 2,
                    d, 1);
      end;
   end;
   {if (curframe < 10) and (TargetActor <> nil) then begin
      d := ImgLib.GetCachedImage (EffectBase + 17*10 + curframe, px, py);
      if d <> nil then begin
         PlayScene.ScreenXYfromMCXY (TActor(TargetActor).RX,
                                     TActor(TargetActor).RY,
                                     sx,
                                     sy);
         DrawBlend (surface,
                    sx + px - UNITX div 2,
                    sy + py - UNITY div 2,
                    d, 1);
      end;
   end;}
end;

constructor TIceSickle.Create (effbase, sx, sy, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtIceSickle,
                     FALSE,
                     0);
   TargetActor := target;
end;

procedure TIceSickle.DrawEff (surface: TDirectDrawSurface);
var
   img, sx, sy, px, py, shx, shy: integer;
   d: TDirectDrawSurface;
begin
   img := EffectBase + Dir16 * 10;
   if curframe < 6 then begin

      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      d := ImgLib.GetCachedImage (img + curframe, px, py);
      if d <> nil then begin
         PlayScene.ScreenXYfromMCXY (TActor(MagOwner).m_nRx,
                                     TActor(MagOwner).m_nRy,
                                     sx,
                                     sy);
         DrawBlend (surface,
                    sx + px - UNITX div 2,
                    sy + py - UNITY div 2,
                    d, 1);
      end;
   end;
end;
{--------------------------------------------------------}

constructor TExploBujaukEffect.Create (effbase, sx, sy, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty,
                     mtExploBujauk,
                     TRUE,
                     0);
   frame := 3;
   TargetActor := target;
   NextFrameTime := 50;
end;

procedure TExploBujaukEffect.DrawEff (surface: TDirectDrawSurface);
var
   img: integer;
   d: TDirectDrawSurface;
   shx, shy: integer;
   meff: TMapEffect;
begin

   if m_boActive and ((Abs(FlyX-fireX) > 30) or (Abs(FlyY-fireY) > 30) or FixedEffect) then begin

      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         img := EffectBase + Dir16 * 10;
         d := g_WMagicImages.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
      end else begin
         img := MagExplosionBase + curframe;
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            DrawBlend (surface,
                       FLyX + px - UNITX div 2,
                       FlyY + py - UNITY div 2,
                       d, 1);
         end;
      end;
   end;
end;

{--------------------------------------------------------}

constructor TBujaukGroundEffect.Create (effbase, magicnumb, sx, sy, tx, ty: integer);
begin
   inherited Create (111, effbase,
                     sx, sy,
                     tx, ty,
                     mtBujaukGroundEffect,
                     TRUE,
                     0);
   frame := 3;
   MagicNumber := magicnumb;
   BoGroundEffect := FALSE;
   NextFrameTime := 50;
end;

function  TBujaukGroundEffect.Run: Boolean;
begin
   Result := inherited Run;
   if not FixedEffect then begin
      if ((abs(TargetX-FlyX) <= 15) and (abs(TargetY-FlyY) <= 15)) or
         ((abs(TargetX-FlyX) >= prevdisx) and (abs(TargetY-FlyY) >= prevdisy)) then begin
         FixedEffect := TRUE;
         start := 0;
         frame := ExplosionFrame;
         curframe := start;
         Repetition := FALSE;
         PlaySound (TActor(MagOwner).m_nMagicExplosionSound);
         Result := TRUE;
      end else begin
         prevdisx := abs(TargetX-FlyX);
         prevdisy := abs(TargetY-FlyY);
      end;
   end;
end;

procedure TBujaukGroundEffect.DrawEff (surface: TDirectDrawSurface);
var
   img: integer;
   d: TDirectDrawSurface;
   shx, shy: integer;
   meff: TMapEffect;
begin
   if m_boActive and ((Abs(FlyX-fireX) > 30) or (Abs(FlyY-fireY) > 30) or FixedEffect) then begin

      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         img := EffectBase + Dir16 * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
      end else begin
         if MagicNumber = 11 then
            img := EffectBase + 16 * 10 + curframe
         else                      //
            img := EffectBase + 18 * 10 + curframe;
         if MagicNumber = 46 then begin
           GetEffectBase (MagicNumber -1 , 0,ImgLib,img);
           img := img + 10 + curframe;
         end;

         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            DrawBlend (surface,
                       FLyX + px - UNITX div 2, // - shx,
                       FlyY + py - UNITY div 2, // - shy,
                       d, 1);
         end;

         {if not BoGroundEffect and (curframe = 8) then begin
            BoGroundEffect := TRUE;
            meff := TMapEffect.Create (img+2, 6, TargetRx, TargetRy);
            meff.NextFrameTime := 100;
            //meff.RepeatCount := 1;
            PlayScene.GroundEffectList.Add (meff);
         end; }
      end;
   end;
end;


{ TNormalDrawEffect }

constructor TNormalDrawEffect.Create(XX,YY:Integer;WmImage:TWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
begin
  inherited Create (111,effbase, XX, YY, XX, YY,mtReady,TRUE,0);
  ImgLib:=WmImage;
  EffectBase:=effbase;
  start:=0;
  curframe:=0;
  frame:=nX;
  NextFrameTime:=frmTime;
  boC8:=boFlag;
end;

procedure TNormalDrawEffect.DrawEff(surface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   nRx,nRy,nPx,nPy:integer;
begin
  d := ImgLib.GetCachedImage (EffectBase + curframe, nPx, nPy);
   if d <> nil then begin
     PlayScene.ScreenXYfromMCXY (FlyX, FlyY, nRx, nRy);
     if boC8 then begin
       DrawBlend (surface,nRx + nPx - UNITX div 2,nRy + nPy - UNITY div 2,d, 1);
     end else begin
       surface.Draw (nRx + nPx - UNITX div 2,nRy + nPy - UNITY div 2,d.ClientRect, d, TRUE);
     end;  
   end;  
end;

function TNormalDrawEffect.Run: Boolean;
begin
   Result := TRUE;
   if m_boActive and (GetTickCount - steptime > longword(NextFrameTime)) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start;
         Result := FALSE;
      end;
   end;
end;

{ TNormalDrawEffect }

constructor THumanEffects.Create(XX,YY:Integer;WmImage:TWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
begin
  inherited Create (111,effbase, XX, YY, XX, YY,mtReady,TRUE,0);
  ImgLib:=WmImage;
  EffectBase:=effbase;
  start:=0;
  curframe:=0;
  frame:=nX;
  NextFrameTime:=frmTime;
  boC8:=boFlag;
end;

procedure THumanEffects.DrawEff(surface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   Rx,Ry,nRx,nRy,nPx,nPy,shx,shy:integer;
begin
  d := ImgLib.GetCachedImage (EffectBase + curframe, nPx, nPy);
   if d <> nil then begin
      Rx := TActor(g_Myself).m_nRx;
      Ry := TActor(g_Myself).m_nRy;
     PlayScene.ScreenXYfromMCXY (Rx, Ry, nRx, nRy);
      nRx := nRx + TActor(g_Myself).m_nShiftX;
      nRy := nRy + TActor(g_Myself).m_nShiftY;
     if boC8 then begin
              DrawBlend (surface,
                    nRx + npx - UNITX div 2,
                    nRy + npy - UNITY div 2,
                    d, 1);
     end else begin
       surface.Draw (nRx + nPx - UNITX div 2,nRy + nPy - UNITY div 2,d.ClientRect, d, TRUE);
     end;
   end;
end;



function THumanEffects.Run: Boolean;
begin
   Result := TRUE;
   if m_boActive and (GetTickCount - steptime > longword(NextFrameTime)) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start;
         Result := FALSE;
      end;
   end;
end;

{ TobjectEffect}
constructor TObjectEffects.Create(ObjectID2:TObject;WmImage:TWMImages;effbase,nX:Integer;frmTime:LongWord;boFlag:Boolean);
begin
  inherited Create (111,effbase, 0, 0, 0, 0,mtReady,TRUE,0);
  ImgLib:=WmImage;
  EffectBase:=effbase;
  start:=0;
  curframe:=0;
  frame:=nX;
  NextFrameTime:=frmTime;
  boC8:=boFlag;
  ObjectID:=ObjectID2;
end;

procedure TObjectEffects.DrawEff(surface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
   Rx,Ry,nRx,nRy,nPx,nPy,shx,shy:integer;
begin
  d := ImgLib.GetCachedImage (EffectBase + curframe, nPx, nPy);
   if (d <> nil) and (ObjectID <> nil) then begin
      Rx := TActor(ObjectID).m_nRx;
      Ry := TActor(ObjectID).m_nRy;
     PlayScene.ScreenXYfromMCXY (Rx, Ry, nRx, nRy);
      nRx := nRx + TActor(ObjectID).m_nShiftX;
      nRy := nRy + TActor(ObjectID).m_nShiftY;
     if boC8 then begin
              DrawBlend (surface,
                    nRx + npx - UNITX div 2,
                    nRy + npy - UNITY div 2,
                    d, 1);
     end else begin
       surface.Draw (nRx + nPx - UNITX div 2,nRy + nPy - UNITY div 2,d.ClientRect, d, TRUE);
     end;
   end;
end;

function TObjectEffects.Run: Boolean;
begin
   Result := TRUE;
   if m_boActive and (GetTickCount - steptime > longword(NextFrameTime)) then begin
      steptime := GetTickCount;
      Inc (curframe);
      if curframe > start+frame-1 then begin
         curframe := start;
         Result := FALSE;
      end;
   end;
end;


{ TFlyingBug }

constructor TFlyingBug.Create(id, effnum, sx, sy, tx, ty: integer;
  mtype: TMagicType; Recusion: Boolean; anitime: integer);
begin
   inherited Create (id, effnum, sx, sy, tx, ty, mtype, Recusion, anitime);
   FlyImageBase := FLYOMAAXEBASE;
   ReadyFrame := 65;
end;

procedure TFlyingBug.DrawEff(surface: TDirectDrawSurface);
var
   img: integer;
   d: TDirectDrawSurface;
   shx, shy: integer;
begin
  if m_boActive and ((Abs(FlyX-fireX) > ReadyFrame) or (Abs(FlyY-fireY) > ReadyFrame)) then begin
      shx := (g_MySelf.m_nRx * UNITX + g_MySelf.m_nShiftX) - FireMyselfX;
      shy := (g_MySelf.m_nRy * UNITY + g_MySelf.m_nShiftY) - FireMyselfY;

      if not FixedEffect then begin
         img := FlyImageBase + (Dir16 div 2) * 10;
         d := ImgLib.GetCachedImage (img + curframe, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2 - shx,
                          FlyY + py - UNITY div 2 - shy,
                          d.ClientRect, d, TRUE);
         end;
      end else begin
         img := curframe + MagExplosionBase;
         d := ImgLib.GetCachedImage (img, px, py);
         if d <> nil then begin
            surface.Draw (FlyX + px - UNITX div 2,
                          FlyY + py - UNITY div 2,
                          d.ClientRect, d, TRUE);
         end;
      end;
   end;
end;

{ TFlyingFireBall }

procedure TFlyingFireBall.DrawEff(surface: TDirectDrawSurface);
var
   d: TDirectDrawSurface;
begin
  if m_boActive and ((Abs(FlyX-fireX) > ReadyFrame) or (Abs(FlyY-fireY) > ReadyFrame)) then begin
    d := ImgLib.GetCachedImage (FlyImageBase + (GetFlyDirection (FlyX, FlyY, TargetX, TargetY) * 10) + curframe, px, py);
    if d <> nil then
      DrawBlend (surface,
                 FLyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
  end;
end;

{--------------------------------------------------------}

constructor TFoxThunderEffect.Create (effbase, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtFoxThunder,
                     FALSE,
                     0);
   TargetActor := target;
   n0:=random(7);
end;

procedure TFoxThunderEffect.DrawEff (surface: TDirectDrawSurface);
var
   img, px, py: integer;
   d: TDirectDrawSurface;
begin
   ImgLib:=FrmMain.WMon24Img;
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + (7 * n0) + curframe, px, py);
   if d <> nil then begin
      DrawBlend (surface,
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
   end;
end;

constructor TFoxAnnoyEffect.Create (effbase, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtFoxAnnoy,
                     FALSE,
                     0);
   TargetActor := target;
   n0:=random(7);
end;

procedure TFoxAnnoyEffect.DrawEff (surface: TDirectDrawSurface);
var
   img, px, py: integer;
   d: TDirectDrawSurface;
begin
   ImgLib:=FrmMain.WMon24Img;
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + (7 * n0) + curframe, px, py);
   if d <> nil then begin
      DrawBlend (surface,
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
   end;
end;

constructor TRedThunderEffect.Create (effbase, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtRedThunder,
                     FALSE,
                     0);
   TargetActor := target;
   n0:=random(7);
end;

procedure TRedThunderEffect.DrawEff (surface: TDirectDrawSurface);
var
   img, px, py: integer;
   d: TDirectDrawSurface;
begin
   ImgLib:=FrmMain.WDragonImg;
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + (7 * n0) + curframe, px, py);
   if d <> nil then begin
      DrawBlend (surface,
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
   end;
end;

constructor TLavaEffect.Create (effbase, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtLava,
                     FALSE,
                     0);
   TargetActor := target;
   frame :=20;
end;

procedure TLavaEffect.DrawEff (surface: TDirectDrawSurface);
var
   img, px, py: integer;
   d: TDirectDrawSurface;
begin
ImgLib:=FrmMain.WDragonImg;
//draw explosion
  if curframe < 10 then begin
   img := 470;
   d := ImgLib.GetCachedImage (img + curframe, px, py);
   if d <> nil then begin
      DrawBlend (surface,
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
   end;
  end;
  //draw the rest
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + curframe, px, py);
   if d <> nil then begin
      DrawBlend (surface,
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
   end;
end;

constructor TRedFoxThunderEffect.Create (effbase, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtRedFoxThunder,
                     FALSE,
                     0);
   TargetActor := target;
   frame :=10;
end;

procedure TRedFoxThunderEffect.DrawEff (surface: TDirectDrawSurface);
var
   img, px, py: integer;
   d: TDirectDrawSurface;
begin
   ImgLib:=FrmMain.WMon24Img;
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + curframe, px, py);
   if d <> nil then begin
      DrawBlend (surface,
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
   end;
end;

constructor TRedFoxFireEffect.Create (effbase, tx, ty: integer; target: TObject);
begin
   inherited Create (111, effbase,
                     tx, ty,
                     tx, ty, //TActor(target).XX, TActor(target).m_nCurrY,
                     mtRedFoxFire,
                     FALSE,
                     0);
   TargetActor := target;
   frame :=10;
end;

procedure TRedFoxFireEffect.DrawEff (surface: TDirectDrawSurface);
var
   img, px, py: integer;
   d: TDirectDrawSurface;
begin
   ImgLib:=FrmMain.WMon24Img;
   img := EffectBase;
   d := ImgLib.GetCachedImage (img + curframe, px, py);
   if d <> nil then begin
      DrawBlend (surface,
                 FlyX + px - UNITX div 2,
                 FlyY + py - UNITY div 2,
                 d, 1);
   end;
end;

{---- Adjust global SVN revision ----}
initialization
  SVNRevision('$Id: magiceff.pas 501 2006-11-01 22:15:59Z sean $');
end.

