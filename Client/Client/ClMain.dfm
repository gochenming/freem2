object frmMain: TfrmMain
  Left = 194
  Top = 143
  BorderStyle = bsSingle
  Caption = 'Jacky,sMir5'
  ClientHeight = 441
  ClientWidth = 649
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Courier New'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnKeyUp = FormKeyUp
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 15
  object DXDraw: TDXDraw
    Left = 0
    Top = 0
    Width = 649
    Height = 441
    AutoInitialize = True
    AutoSize = False
    Color = clBtnFace
    Display.FixedBitCount = True
    Display.FixedRatio = True
    Display.FixedSize = False
    Display.Height = 600
    Display.Width = 800
    Options = [doAllowReboot, doWaitVBlank, doAllowPalette256, doSystemMemory, doCenter]
    SurfaceHeight = 428
    SurfaceWidth = 663
    OnFinalize = DXDrawFinalize
    OnInitialize = DXDrawInitialize
    Align = alClient
    TabOrder = 0
    OnClick = DXDrawClick
    OnDblClick = DXDrawDblClick
    OnMouseDown = DXDrawMouseDown
    OnMouseMove = DXDrawMouseMove
    OnMouseUp = DXDrawMouseUp
  end
  object CSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = CSocketConnect
    OnDisconnect = CSocketDisconnect
    OnRead = CSocketRead
    OnError = CSocketError
    Top = 296
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Top = 328
  end
  object MouseTimer: TTimer
    Interval = 50
    OnTimer = MouseTimerTimer
    Top = 360
  end
  object WaitMsgTimer: TTimer
    Enabled = False
    Interval = 1
    OnTimer = WaitMsgTimerTimer
    Top = 408
  end
  object SelChrWaitTimer: TTimer
    Enabled = False
    Interval = 500
    OnTimer = SelChrWaitTimerTimer
    Left = 32
    Top = 296
  end
  object CmdTimer: TTimer
    Enabled = False
    OnTimer = CmdTimerTimer
    Left = 32
    Top = 328
  end
  object MinTimer: TTimer
    Interval = 500
    OnTimer = MinTimerTimer
    Left = 32
    Top = 360
  end
  object SpeedHackTimer: TTimer
    Interval = 250
    OnTimer = SpeedHackTimerTimer
    Left = 32
    Top = 408
  end
  object WMonImg: TWMImages
    FileName = 'Data\Mon1.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 104
    Top = 296
  end
  object WMon2Img: TWMImages
    FileName = 'Data\Mon2.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 136
    Top = 296
  end
  object WMon3Img: TWMImages
    FileName = 'Data\Mon3.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 168
    Top = 296
  end
  object WMon4Img: TWMImages
    FileName = 'Data\Mon4.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 200
    Top = 296
  end
  object WMon5Img: TWMImages
    FileName = 'Data\Mon5.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 232
    Top = 296
  end
  object WMon6Img: TWMImages
    FileName = 'Data\Mon6.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 264
    Top = 296
  end
  object WMon7Img: TWMImages
    FileName = 'Data\Mon7.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 296
    Top = 296
  end
  object WMon8Img: TWMImages
    FileName = 'Data\Mon8.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 328
    Top = 296
  end
  object WMon9Img: TWMImages
    FileName = 'Data\Mon9.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 360
    Top = 296
  end
  object WMon10Img: TWMImages
    FileName = 'Data\Mon10.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 392
    Top = 296
  end
  object WMon11Img: TWMImages
    FileName = 'Data\Mon11.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 104
    Top = 328
  end
  object WMon12Img: TWMImages
    FileName = 'Data\Mon12.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 136
    Top = 328
  end
  object WMon13Img: TWMImages
    FileName = 'Data\Mon13.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 168
    Top = 328
  end
  object WMon14Img: TWMImages
    FileName = 'Data\Mon14.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 200
    Top = 328
  end
  object WMon15Img: TWMImages
    FileName = 'Data\Mon15.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 232
    Top = 328
  end
  object WMon16Img: TWMImages
    FileName = 'Data\Mon16.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 264
    Top = 328
  end
  object WMon17Img: TWMImages
    FileName = 'Data\Mon17.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 296
    Top = 328
  end
  object WMon18Img: TWMImages
    FileName = 'Data\Mon18.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 328
    Top = 328
  end
  object WMon19Img: TWMImages
    FileName = 'Data\Mon19.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 360
    Top = 328
  end
  object WMon20Img: TWMImages
    FileName = 'Data\Mon20.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 392
    Top = 328
  end
  object WMon21Img: TWMImages
    FileName = 'Data\Mon21.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 104
    Top = 360
  end
  object WMon22Img: TWMImages
    FileName = 'Data\Mon22.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 136
    Top = 360
  end
  object WMon50Img: TWMImages
    FileName = 'Data\Mon50.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 104
    Top = 392
  end
  object WMon51Img: TWMImages
    FileName = 'Data\Mon51.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 136
    Top = 392
  end
  object WMon52Img: TWMImages
    FileName = 'Data\Mon52.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 168
    Top = 392
  end
  object WMon53Img: TWMImages
    FileName = 'Data\Mon53.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 200
    Top = 392
  end
  object WMon54Img: TWMImages
    FileName = 'Data\Mon54.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 232
    Top = 392
  end
  object WMon23Img: TWMImages
    FileName = 'Data\Mon23.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 168
    Top = 360
  end
  object WEffectImg: TWMImages
    FileName = 'Data\Effect.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 472
    Top = 296
  end
  object WDragonImg: TWMImages
    FileName = 'Data\Dragon.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 472
    Top = 328
  end
  object WPrgUse3: TWMImages
    FileName = 'Data\PrgUse3.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 264
    Top = 392
  end
  object AutoRunTimer: TTimer
    Enabled = False
    Interval = 50
    OnTimer = AutoRunTimerTimer
    Left = 312
    Top = 392
  end
  object WMon24Img: TWMImages
    FileName = 'Data\Mon24.wil'
    DxDraw = DXDraw
    LibType = ltUseCache
    MaxMemorySize = 1024000
    Appr = 0
    Left = 200
    Top = 360
  end
  object WMon25Img: TWMImages
    FileName = 'Data\Mon25.wil'
    DxDraw = DXDraw
    LibType = ltLoadBmp
    MaxMemorySize = 1024000
    Appr = 0
    Left = 232
    Top = 360
  end
  object WMon26Img: TWMImages
    FileName = 'Data\Mon26.wil'
    DxDraw = DXDraw
    LibType = ltLoadBmp
    MaxMemorySize = 1024000
    Appr = 0
    Left = 264
    Top = 360
  end
  object WMon27Img: TWMImages
    FileName = 'Data\Mon27.wil'
    DxDraw = DXDraw
    LibType = ltLoadBmp
    MaxMemorySize = 1024000
    Appr = 0
    Left = 296
    Top = 360
  end
  object WMon28Img: TWMImages
    FileName = 'Data\Mon28.wil'
    DxDraw = DXDraw
    LibType = ltLoadBmp
    MaxMemorySize = 1024000
    Appr = 0
    Left = 328
    Top = 360
  end
  object WMon29Img: TWMImages
    FileName = 'Data\Mon29.wil'
    DxDraw = DXDraw
    LibType = ltLoadBmp
    MaxMemorySize = 1024000
    Appr = 0
    Left = 360
    Top = 360
  end
end
