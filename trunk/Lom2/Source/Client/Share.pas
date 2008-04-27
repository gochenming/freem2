unit Share;

interface

uses svn;

const
  RUNLOGINCODE       = 0; //������Ϸ״̬��,Ĭ��Ϊ0 ����Ϊ 9

  STDCLIENT          = 0;
  RMCLIENT           = 99;
  CLIENTTYPE         = RMCLIENT; //��ͨ��Ϊ0 ,99 Ϊ����ͻ���

  RMCLIENTTITLE      = 'rXyNKR^xVArFr_dx^`PS>xSRCsX';

  DEBUG         = 0;
  SWH800        = 0;
  SWH1024       = 1;
  SWH           = SWH800;

  CUSTOMLIBFILE = 0; //�Զ���ͼ��λ��

{$IF SWH = SWH800}
   SCREENWIDTH = 800;
   SCREENHEIGHT = 600;
{$ELSEIF SWH = SWH1024}
   SCREENWIDTH = 1024;
   SCREENHEIGHT = 768;
{$IFEND}

   MAPSURFACEWIDTH = SCREENWIDTH;
   MAPSURFACEHEIGHT = SCREENHEIGHT- 50;

   WINLEFT = 42;
   WINTOP  = 42;
   WINRIGHT = SCREENWIDTH-42;
   BOTTOMEDGE = SCREENHEIGHT-5;  // Bottom WINBOTTOM

   MAPDIR             = 'Map\'; //��ͼ�ļ�����Ŀ¼
   CONFIGFILE         = 'Config\%s.ini';
{$IF CUSTOMLIBFILE = 1}
   EFFECTIMAGEDIR     = 'Graphics\Effect\';
   MAINIMAGEFILE      = 'Graphics\FrmMain\Main.wil';
   MAINIMAGEFILE2     = 'Graphics\FrmMain\Main2.wil';
   MAINIMAGEFILE3     = 'Graphics\FrmMain\Main3.wil';
{$ELSE}
   MAINIMAGEFILE      = 'Data\Prguse.wil';
   MAINIMAGEFILE2     = 'Data\Prguse2.wil';
   MAINIMAGEFILE3     = 'Data\Prguse3.wil';
   EFFECTIMAGEDIR     = 'Data\';
{$IFEND}

   CHRSELIMAGEFILE    = 'Data\ChrSel.wil';
   MINMAPIMAGEFILE    = 'Data\mmap.wil';
   TITLESIMAGEFILE    = 'Data\Tiles.wil';
   SMLTITLESIMAGEFILE = 'Data\SmTiles.wil';
   HUMWINGIMAGESFILE  = 'Data\HumEffect.wil';
   MAGICONIMAGESFILE  = 'Data\MagIcon.wil';
   HUMIMGIMAGESFILE   = 'Data\Hum.wil';
   HUM2IMGIMAGESFILE  = 'Data\Hum2.wil';
   HAIRIMGIMAGESFILE  = 'Data\Hair.wil';
   HORSEIMAGEFILE     = 'Data\Horse.wil';
   HELMETIMAGEFILE    = 'Data\Helmet.wil';
   TRANSFORMIMAGEFILE = 'Data\TransForm.wil';
   WEAPONIMAGESFILE   = 'Data\Weapon.wil';
   NPCIMAGESFILE      = 'Data\Npc.wil';
   MAGICIMAGESFILE    = 'Data\Magic.wil';
   MAGIC2IMAGESFILE   = 'Data\Magic2.wil';
   MAGIC3IMAGESFILE   = 'Data\magic3.wil';
   MAGIC4IMAGESFILE   = 'Data\magic4.wil';
   EVENTEFFECTIMAGESFILE = EFFECTIMAGEDIR + 'Event.wil';
   BAGITEMIMAGESFILE   = 'Data\Items.wil';
   STATEITEMIMAGESFILE = 'Data\StateItem.wil';
   DNITEMIMAGESFILE    = 'Data\DnItems.wil';
   OBJECTIMAGEFILE     = 'Data\Objects.wil';
   OBJECTIMAGEFILE1    = 'Data\Objects%d.wil';
   MONIMAGEFILE        = 'Data\Mon%d.wil';
   DRAGONIMAGEFILE     = 'Data\Dragon.wil';
   DECOIMAGEFILE       = 'Data\Deco.wil';
   EFFECTIMAGEFILE     = 'Data\Effect.wil';

   MONIMAGEFILEEX      = 'Graphics\Monster\%d.wil';
   MONPMFILE           = 'Graphics\Monster\%d.pm';
   
  MAXX = SCREENWIDTH div 20;
  MAXY = SCREENWIDTH div 20;

  DEFAULTCURSOR = 0; //ϵͳĬ�Ϲ��
  IMAGECURSOR   = 1; //ͼ�ι��

  USECURSOR     = DEFAULTCURSOR; //ʹ��ʲô���͵Ĺ��

  MAXBAGITEMCL = 52;
  MAXSTORAGEITEMCL = 80;
  MAXFONT = 8;
  ENEMYCOLOR = 69;

  HAM_ALL      = 0;
  HAM_PEACE    = 1;
  HAM_DEAR     = 2;
  HAM_MASTER   = 3;
  HAM_GROUP    = 4;
  HAM_GUILD    = 5;
  HAM_PKATTACK = 6;
implementation

{---- Adjust global SVN revision ----}
initialization
  SVNRevision('$Id: Share.pas 502 2006-11-02 08:10:23Z sean $');
end.
