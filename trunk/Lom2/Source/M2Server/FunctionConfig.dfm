object frmFunctionConfig: TfrmFunctionConfig
  Left = 245
  Top = 219
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21151#33021#35774#32622
  ClientHeight = 411
  ClientWidth = 510
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Label14: TLabel
    Left = 36
    Top = 391
    Width = 432
    Height = 12
    Caption = #35843#25972#30340#21442#25968#31435#21363#29983#25928#65292#22312#32447#26102#35831#30830#35748#27492#21442#25968#30340#20316#29992#20877#35843#25972#65292#20081#35843#25972#23558#23548#33268#28216#25103#28151#20081
    Font.Charset = ANSI_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object FunctionConfigControl: TPageControl
    Left = 8
    Top = 8
    Width = 495
    Height = 373
    ActivePage = TabSheetGeneral
    MultiLine = True
    TabOrder = 0
    OnChanging = FunctionConfigControlChanging
    object TabSheetGeneral: TTabSheet
      Caption = #22522#26412#21151#33021
      ImageIndex = 3
      object GroupBox7: TGroupBox
        Left = 161
        Top = 7
        Width = 136
        Height = 110
        Caption = #39269#39295#31995#32479
        TabOrder = 0
        object CheckBoxHungerSystem: TCheckBox
          Left = 9
          Top = 17
          Width = 100
          Height = 19
          Hint = 'Activate hunger system'
          Caption = #24320#21551#39269#39295#31995#32479
          TabOrder = 0
          OnClick = CheckBoxHungerSystemClick
        end
        object GroupBoxHunger: TGroupBox
          Left = 9
          Top = 38
          Width = 116
          Height = 62
          Caption = #35774#32622
          TabOrder = 1
          object CheckBoxHungerDecHP: TCheckBox
            Left = 9
            Top = 17
            Width = 96
            Height = 19
            Hint = 'Decrease users HP when hunger reaches 0'
            Caption = #20943#23569'HP'
            TabOrder = 1
            OnClick = CheckBoxHungerDecHPClick
          end
          object CheckBoxHungerDecPower: TCheckBox
            Left = 9
            Top = 35
            Width = 76
            Height = 18
            Hint = 'Decrease DC when hunger increases'
            Caption = #20943#23569'DC'
            TabOrder = 0
            OnClick = CheckBoxHungerDecPowerClick
          end
        end
      end
      object ButtonGeneralSave: TButton
        Left = 399
        Top = 283
        Width = 70
        Height = 27
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonGeneralSaveClick
      end
      object GroupBox34: TGroupBox
        Left = 8
        Top = 7
        Width = 145
        Height = 178
        Caption = #21517#23383#26174#31034#39068#33394
        TabOrder = 2
        object Label85: TLabel
          Left = 12
          Top = 25
          Width = 54
          Height = 12
          Caption = #25915#20987#29609#23478':'
          WordWrap = True
        end
        object LabelPKFlagNameColor: TLabel
          Left = 121
          Top = 22
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label87: TLabel
          Left = 12
          Top = 50
          Width = 54
          Height = 12
          Caption = #40644#21517#29366#24577':'
        end
        object LabelPKLevel1NameColor: TLabel
          Left = 121
          Top = 46
          Width = 10
          Height = 19
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label89: TLabel
          Left = 12
          Top = 75
          Width = 54
          Height = 12
          Caption = #32418#21517#29366#24577':'
        end
        object LabelPKLevel2NameColor: TLabel
          Left = 121
          Top = 71
          Width = 10
          Height = 19
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label91: TLabel
          Left = 12
          Top = 125
          Width = 54
          Height = 12
          Caption = #32852#30431#25112#20105':'
        end
        object LabelAllyAndGuildNameColor: TLabel
          Left = 121
          Top = 96
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label93: TLabel
          Left = 12
          Top = 100
          Width = 54
          Height = 12
          Caption = #25932#23545#25112#20105':'
        end
        object LabelWarGuildNameColor: TLabel
          Left = 121
          Top = 121
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label95: TLabel
          Left = 12
          Top = 150
          Width = 54
          Height = 12
          Caption = #25112#20105#21306#22495':'
        end
        object LabelInFreePKAreaNameColor: TLabel
          Left = 121
          Top = 146
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditPKFlagNameColor: TSpinEdit
          Left = 69
          Top = 20
          Width = 45
          Height = 21
          Hint = 'Namecolour when you hit another player'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 47
          OnChange = EditPKFlagNameColorChange
        end
        object EditPKLevel1NameColor: TSpinEdit
          Left = 69
          Top = 45
          Width = 45
          Height = 21
          Hint = 'Namecolour when PK level from 100 to 199'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 251
          OnChange = EditPKLevel1NameColorChange
        end
        object EditPKLevel2NameColor: TSpinEdit
          Left = 69
          Top = 70
          Width = 45
          Height = 21
          Hint = 'Namecolour when PK level 200+'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 249
          OnChange = EditPKLevel2NameColorChange
        end
        object EditAllyAndGuildNameColor: TSpinEdit
          Left = 69
          Top = 120
          Width = 45
          Height = 21
          Hint = 'Namecolour of an allied guild, Default=180'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 180
          OnChange = EditAllyAndGuildNameColorChange
        end
        object EditWarGuildNameColor: TSpinEdit
          Left = 69
          Top = 95
          Width = 45
          Height = 21
          Hint = 'Namecolour of a guild you are warring with, Default=69'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 69
          OnChange = EditWarGuildNameColorChange
        end
        object EditInFreePKAreaNameColor: TSpinEdit
          Left = 69
          Top = 145
          Width = 45
          Height = 21
          Hint = 'Namecolour when in an area where PK'#39'ing is allowed, Default=221'
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 221
          OnChange = EditInFreePKAreaNameColorChange
        end
      end
    end
    object PasswordSheet: TTabSheet
      Caption = #23494#30721#20445#25252
      ImageIndex = 2
      object GroupBox1: TGroupBox
        Left = 9
        Top = 11
        Width = 464
        Height = 186
        TabOrder = 0
        object CheckBoxEnablePasswordLock: TCheckBox
          Left = 9
          Top = -1
          Width = 108
          Height = 18
          Hint = 'Turn on password system'
          Caption = #21551#29992#23494#30721#38145#31995#32479
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CheckBoxEnablePasswordLockClick
        end
        object GroupBox2: TGroupBox
          Left = 9
          Top = 17
          Width = 256
          Height = 160
          Caption = #38145#23450#25511#21046
          TabOrder = 1
          object CheckBoxLockGetBackItem: TCheckBox
            Left = 9
            Top = 13
            Width = 152
            Height = 19
            Hint = 'Storage must be unlocked before items can be retrieved'
            Caption = #31105#27490#21462#20179#24211#29289#21697
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = CheckBoxLockGetBackItemClick
          end
          object GroupBox4: TGroupBox
            Left = 9
            Top = 35
            Width = 236
            Height = 114
            Caption = #30331#24405#38145#23450
            TabOrder = 1
            object CheckBoxLockWalk: TCheckBox
              Left = 9
              Top = 35
              Width = 113
              Height = 18
              Caption = #31105#27490#36208#36335
              TabOrder = 0
              OnClick = CheckBoxLockWalkClick
            end
            object CheckBoxLockRun: TCheckBox
              Left = 9
              Top = 52
              Width = 113
              Height = 18
              Caption = #31105#27490#36305#27493
              TabOrder = 1
              OnClick = CheckBoxLockRunClick
            end
            object CheckBoxLockHit: TCheckBox
              Left = 9
              Top = 69
              Width = 113
              Height = 19
              Caption = #31105#27490#25915#20987
              TabOrder = 2
              OnClick = CheckBoxLockHitClick
            end
            object CheckBoxLockSpell: TCheckBox
              Left = 9
              Top = 87
              Width = 113
              Height = 18
              Caption = #31105#27490#39764#27861
              TabOrder = 3
              OnClick = CheckBoxLockSpellClick
            end
            object CheckBoxLockSendMsg: TCheckBox
              Left = 110
              Top = 35
              Width = 114
              Height = 18
              Caption = #31105#27490#32842#22825
              TabOrder = 4
              OnClick = CheckBoxLockSendMsgClick
            end
            object CheckBoxLockInObMode: TCheckBox
              Left = 110
              Top = 17
              Width = 111
              Height = 19
              Hint = 'Lock Observer mode so a password is required to become visable'
              Caption = #38145#23450#26102#20026#38544#36523#27169#24335
              TabOrder = 5
              OnClick = CheckBoxLockInObModeClick
            end
            object CheckBoxLockLogin: TCheckBox
              Left = 9
              Top = 17
              Width = 96
              Height = 19
              Caption = #38145#23450#20154#29289#30331#24405
              TabOrder = 6
              OnClick = CheckBoxLockLoginClick
            end
            object CheckBoxLockUseItem: TCheckBox
              Left = 110
              Top = 87
              Width = 114
              Height = 18
              Caption = #31105#27490#20351#29992#21697
              TabOrder = 7
              OnClick = CheckBoxLockUseItemClick
            end
            object CheckBoxLockDropItem: TCheckBox
              Left = 110
              Top = 69
              Width = 114
              Height = 19
              Caption = #31105#27490#25172#29289#21697
              TabOrder = 8
              OnClick = CheckBoxLockDropItemClick
            end
            object CheckBoxLockDealItem: TCheckBox
              Left = 110
              Top = 52
              Width = 100
              Height = 18
              Caption = #31105#27490#20132#26131
              TabOrder = 9
              OnClick = CheckBoxLockDealItemClick
            end
          end
        end
        object GroupBox3: TGroupBox
          Left = 275
          Top = 17
          Width = 154
          Height = 71
          Caption = #23494#30721#36755#20837#38169#35823#25511#21046
          TabOrder = 2
          object Label1: TLabel
            Left = 17
            Top = 24
            Width = 54
            Height = 12
            Caption = #38169#35823#27425#25968':'
          end
          object EditErrorPasswordCount: TSpinEdit
            Left = 82
            Top = 20
            Width = 57
            Height = 21
            Hint = 'Max no of password attempts'
            EditorEnabled = False
            MaxValue = 10
            MinValue = 1
            TabOrder = 0
            Value = 3
            OnChange = EditErrorPasswordCountChange
          end
          object CheckBoxErrorCountKick: TCheckBox
            Left = 9
            Top = 43
            Width = 132
            Height = 19
            Hint = 'Kick user if incorrect X times in a row'
            Caption = #36229#36807#25351#23450#27425#25968#36386#19979#32447
            Checked = True
            State = cbChecked
            TabOrder = 1
            OnClick = CheckBoxErrorCountKickClick
          end
        end
        object ButtonPasswordLockSave: TButton
          Left = 378
          Top = 142
          Width = 70
          Height = 28
          Hint = 'Save settings'
          Caption = #20445#23384'(&S)'
          TabOrder = 3
          OnClick = ButtonPasswordLockSaveClick
        end
      end
    end
    object TabSheet33: TTabSheet
      Caption = #24072#24466#31995#32479
      ImageIndex = 5
      object GroupBox21: TGroupBox
        Left = 7
        Top = 8
        Width = 178
        Height = 166
        Caption = #24466#24351#20986#24072
        TabOrder = 0
        object GroupBox22: TGroupBox
          Left = 9
          Top = 17
          Width = 157
          Height = 53
          Caption = #20986#24072#31561#32423
          TabOrder = 0
          object Label29: TLabel
            Left = 9
            Top = 20
            Width = 30
            Height = 12
            Caption = #31561#32423':'
          end
          object EditMasterOKLevel: TSpinEdit
            Left = 74
            Top = 16
            Width = 57
            Height = 21
            Hint = 'Minimum level you must be before being a master'
            MaxValue = 65535
            MinValue = 1
            TabOrder = 0
            Value = 10
            OnChange = EditMasterOKLevelChange
          end
        end
        object GroupBox23: TGroupBox
          Left = 9
          Top = 78
          Width = 157
          Height = 79
          Caption = #24072#29238#25152#24471
          TabOrder = 1
          object Label30: TLabel
            Left = 9
            Top = 20
            Width = 54
            Height = 12
            Caption = #22768#26395#28857#25968':'
          end
          object Label31: TLabel
            Left = 9
            Top = 46
            Width = 54
            Height = 12
            Caption = #20998#37197#28857#25968':'
          end
          object EditMasterOKCreditPoint: TSpinEdit
            Left = 74
            Top = 16
            Width = 57
            Height = 21
            Hint = 'Level before earning master credits'
            MaxValue = 100
            MinValue = 0
            TabOrder = 0
            Value = 10
            OnChange = EditMasterOKCreditPointChange
          end
          object EditMasterOKBonusPoint: TSpinEdit
            Left = 74
            Top = 42
            Width = 57
            Height = 21
            Hint = 'Level before earning master bonus points'
            MaxValue = 1000
            MinValue = 0
            TabOrder = 1
            Value = 10
            OnChange = EditMasterOKBonusPointChange
          end
        end
      end
      object ButtonMasterSave: TButton
        Left = 397
        Top = 274
        Width = 71
        Height = 28
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonMasterSaveClick
      end
    end
    object TabSheet38: TTabSheet
      Caption = #36716#29983#31995#32479
      ImageIndex = 9
      object GroupBox29: TGroupBox
        Left = 8
        Top = 9
        Width = 122
        Height = 280
        Caption = #21517#23383#39068#33394'('#31561#32423')'
        TabOrder = 0
        object Label56: TLabel
          Left = 12
          Top = 21
          Width = 18
          Height = 12
          Caption = #19968':'
        end
        object LabelReNewNameColor1: TLabel
          Left = 95
          Top = 19
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label58: TLabel
          Left = 12
          Top = 47
          Width = 18
          Height = 12
          Caption = #20108':'
        end
        object LabelReNewNameColor2: TLabel
          Left = 95
          Top = 45
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label60: TLabel
          Left = 12
          Top = 73
          Width = 18
          Height = 12
          Caption = #19977':'
        end
        object LabelReNewNameColor3: TLabel
          Left = 95
          Top = 71
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label62: TLabel
          Left = 12
          Top = 99
          Width = 18
          Height = 12
          Caption = #22235':'
        end
        object LabelReNewNameColor4: TLabel
          Left = 95
          Top = 97
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label64: TLabel
          Left = 12
          Top = 125
          Width = 18
          Height = 12
          Caption = #20116':'
        end
        object LabelReNewNameColor5: TLabel
          Left = 95
          Top = 123
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label66: TLabel
          Left = 12
          Top = 151
          Width = 18
          Height = 12
          Caption = #20845':'
        end
        object LabelReNewNameColor6: TLabel
          Left = 95
          Top = 149
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label68: TLabel
          Left = 12
          Top = 177
          Width = 18
          Height = 12
          Caption = #19971':'
        end
        object LabelReNewNameColor7: TLabel
          Left = 95
          Top = 175
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label70: TLabel
          Left = 12
          Top = 203
          Width = 18
          Height = 12
          Caption = #20843':'
        end
        object LabelReNewNameColor8: TLabel
          Left = 95
          Top = 201
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label72: TLabel
          Left = 12
          Top = 229
          Width = 18
          Height = 12
          Caption = #20061':'
        end
        object LabelReNewNameColor9: TLabel
          Left = 95
          Top = 227
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label74: TLabel
          Left = 12
          Top = 255
          Width = 18
          Height = 12
          Caption = #21313':'
        end
        object LabelReNewNameColor10: TLabel
          Left = 95
          Top = 253
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditReNewNameColor1: TSpinEdit
          Left = 43
          Top = 17
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 255
          OnChange = EditReNewNameColor1Change
        end
        object EditReNewNameColor2: TSpinEdit
          Left = 43
          Top = 43
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 255
          OnChange = EditReNewNameColor2Change
        end
        object EditReNewNameColor3: TSpinEdit
          Left = 43
          Top = 69
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 255
          OnChange = EditReNewNameColor3Change
        end
        object EditReNewNameColor4: TSpinEdit
          Left = 43
          Top = 95
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 255
          OnChange = EditReNewNameColor4Change
        end
        object EditReNewNameColor5: TSpinEdit
          Left = 43
          Top = 121
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 255
          OnChange = EditReNewNameColor5Change
        end
        object EditReNewNameColor6: TSpinEdit
          Left = 43
          Top = 147
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 255
          OnChange = EditReNewNameColor6Change
        end
        object EditReNewNameColor7: TSpinEdit
          Left = 43
          Top = 173
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 255
          OnChange = EditReNewNameColor7Change
        end
        object EditReNewNameColor8: TSpinEdit
          Left = 43
          Top = 199
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 255
          OnChange = EditReNewNameColor8Change
        end
        object EditReNewNameColor9: TSpinEdit
          Left = 43
          Top = 225
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 8
          Value = 255
          OnChange = EditReNewNameColor9Change
        end
        object EditReNewNameColor10: TSpinEdit
          Left = 43
          Top = 251
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 9
          Value = 255
          OnChange = EditReNewNameColor10Change
        end
      end
      object ButtonReNewLevelSave: TButton
        Left = 395
        Top = 281
        Width = 71
        Height = 27
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonReNewLevelSaveClick
      end
      object GroupBox30: TGroupBox
        Left = 138
        Top = 9
        Width = 119
        Height = 64
        Caption = #21517#23383#21464#33394
        TabOrder = 2
        object Label57: TLabel
          Left = 9
          Top = 38
          Width = 30
          Height = 12
          Caption = #38388#38548':'
        end
        object Label59: TLabel
          Left = 90
          Top = 39
          Width = 12
          Height = 12
          Caption = #31186
        end
        object EditReNewNameColorTime: TSpinEdit
          Left = 44
          Top = 34
          Width = 40
          Height = 21
          Hint = 'Time colour will last before reverting to normal'
          EditorEnabled = False
          MaxValue = 10
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditReNewNameColorTimeChange
        end
        object CheckBoxReNewChangeColor: TCheckBox
          Left = 9
          Top = 13
          Width = 68
          Height = 19
          Hint = 'Name will change colour when reborn'
          Caption = #33258#21160#21464#33394
          TabOrder = 1
          OnClick = CheckBoxReNewChangeColorClick
        end
      end
      object GroupBox33: TGroupBox
        Left = 138
        Top = 83
        Width = 119
        Height = 44
        Caption = #36716#29983#25511#21046
        TabOrder = 3
        object CheckBoxReNewLevelClearExp: TCheckBox
          Left = 9
          Top = 17
          Width = 100
          Height = 19
          Hint = 'reset exp to 0 when reborn'
          Caption = #28165#38500#24050#26377#32463#39564
          TabOrder = 0
          OnClick = CheckBoxReNewLevelClearExpClick
        end
      end
    end
    object TabSheet39: TTabSheet
      Caption = #23456#29289#21319#32423
      ImageIndex = 10
      object ButtonMonUpgradeSave: TButton
        Left = 390
        Top = 283
        Width = 70
        Height = 27
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonMonUpgradeSaveClick
      end
      object GroupBox32: TGroupBox
        Left = 5
        Top = 5
        Width = 122
        Height = 256
        Caption = #24618#29289#21517#23383#39068#33394'('#31561#32423')'
        TabOrder = 1
        object Label65: TLabel
          Left = 12
          Top = 21
          Width = 18
          Height = 12
          Caption = #19968':'
        end
        object LabelMonUpgradeColor1: TLabel
          Left = 87
          Top = 19
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label67: TLabel
          Left = 12
          Top = 47
          Width = 18
          Height = 12
          Caption = #20108':'
        end
        object LabelMonUpgradeColor2: TLabel
          Left = 87
          Top = 45
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label69: TLabel
          Left = 12
          Top = 73
          Width = 18
          Height = 12
          Caption = #19977':'
        end
        object LabelMonUpgradeColor3: TLabel
          Left = 87
          Top = 71
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label71: TLabel
          Left = 12
          Top = 99
          Width = 18
          Height = 12
          Caption = #22235':'
        end
        object LabelMonUpgradeColor4: TLabel
          Left = 87
          Top = 97
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label73: TLabel
          Left = 12
          Top = 125
          Width = 18
          Height = 12
          Caption = #20116':'
        end
        object LabelMonUpgradeColor5: TLabel
          Left = 87
          Top = 123
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label75: TLabel
          Left = 12
          Top = 151
          Width = 18
          Height = 12
          Caption = #20845':'
        end
        object LabelMonUpgradeColor6: TLabel
          Left = 87
          Top = 149
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label76: TLabel
          Left = 12
          Top = 177
          Width = 18
          Height = 12
          Caption = #19971':'
        end
        object LabelMonUpgradeColor7: TLabel
          Left = 87
          Top = 175
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label77: TLabel
          Left = 12
          Top = 203
          Width = 18
          Height = 12
          Caption = #20843':'
        end
        object LabelMonUpgradeColor8: TLabel
          Left = 87
          Top = 201
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object Label86: TLabel
          Left = 12
          Top = 229
          Width = 18
          Height = 12
          Caption = #20061':'
        end
        object LabelMonUpgradeColor9: TLabel
          Left = 87
          Top = 227
          Width = 10
          Height = 18
          AutoSize = False
          Color = clBackground
          ParentColor = False
        end
        object EditMonUpgradeColor1: TSpinEdit
          Left = 35
          Top = 17
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 0
          Value = 255
          OnChange = EditMonUpgradeColor1Change
        end
        object EditMonUpgradeColor2: TSpinEdit
          Left = 35
          Top = 43
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 1
          Value = 254
          OnChange = EditMonUpgradeColor2Change
        end
        object EditMonUpgradeColor3: TSpinEdit
          Left = 35
          Top = 69
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 2
          Value = 147
          OnChange = EditMonUpgradeColor3Change
        end
        object EditMonUpgradeColor4: TSpinEdit
          Left = 35
          Top = 95
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 3
          Value = 154
          OnChange = EditMonUpgradeColor4Change
        end
        object EditMonUpgradeColor5: TSpinEdit
          Left = 35
          Top = 121
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 4
          Value = 229
          OnChange = EditMonUpgradeColor5Change
        end
        object EditMonUpgradeColor6: TSpinEdit
          Left = 35
          Top = 147
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 5
          Value = 168
          OnChange = EditMonUpgradeColor6Change
        end
        object EditMonUpgradeColor7: TSpinEdit
          Left = 35
          Top = 173
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 6
          Value = 180
          OnChange = EditMonUpgradeColor7Change
        end
        object EditMonUpgradeColor8: TSpinEdit
          Left = 35
          Top = 199
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 7
          Value = 252
          OnChange = EditMonUpgradeColor8Change
        end
        object EditMonUpgradeColor9: TSpinEdit
          Left = 35
          Top = 225
          Width = 45
          Height = 21
          EditorEnabled = False
          MaxValue = 255
          MinValue = 0
          TabOrder = 8
          Value = 249
          OnChange = EditMonUpgradeColor9Change
        end
      end
      object GroupBox31: TGroupBox
        Left = 135
        Top = 5
        Width = 110
        Height = 256
        Caption = #21319#32423#26432#24618#25968
        TabOrder = 2
        object Label61: TLabel
          Left = 12
          Top = 21
          Width = 18
          Height = 12
          Caption = #19968':'
        end
        object Label63: TLabel
          Left = 12
          Top = 47
          Width = 18
          Height = 12
          Caption = #20108':'
        end
        object Label78: TLabel
          Left = 12
          Top = 73
          Width = 18
          Height = 12
          Caption = #19977':'
        end
        object Label79: TLabel
          Left = 12
          Top = 99
          Width = 18
          Height = 12
          Caption = #22235':'
        end
        object Label80: TLabel
          Left = 12
          Top = 125
          Width = 18
          Height = 12
          Caption = #20116':'
        end
        object Label81: TLabel
          Left = 12
          Top = 151
          Width = 18
          Height = 12
          Caption = #20845':'
        end
        object Label82: TLabel
          Left = 12
          Top = 177
          Width = 18
          Height = 12
          Caption = #19971':'
        end
        object Label83: TLabel
          Left = 12
          Top = 203
          Width = 30
          Height = 12
          Caption = #22522#25968':'
        end
        object Label84: TLabel
          Left = 12
          Top = 229
          Width = 30
          Height = 12
          Caption = #20493#29575':'
        end
        object EditMonUpgradeKillCount1: TSpinEdit
          Left = 47
          Top = 17
          Width = 53
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = EditMonUpgradeKillCount1Change
        end
        object EditMonUpgradeKillCount2: TSpinEdit
          Left = 47
          Top = 43
          Width = 53
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = EditMonUpgradeKillCount2Change
        end
        object EditMonUpgradeKillCount3: TSpinEdit
          Left = 47
          Top = 69
          Width = 53
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 50
          OnChange = EditMonUpgradeKillCount3Change
        end
        object EditMonUpgradeKillCount4: TSpinEdit
          Left = 47
          Top = 95
          Width = 53
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMonUpgradeKillCount4Change
        end
        object EditMonUpgradeKillCount5: TSpinEdit
          Left = 47
          Top = 121
          Width = 53
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 4
          Value = 200
          OnChange = EditMonUpgradeKillCount5Change
        end
        object EditMonUpgradeKillCount6: TSpinEdit
          Left = 47
          Top = 147
          Width = 53
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 5
          Value = 300
          OnChange = EditMonUpgradeKillCount6Change
        end
        object EditMonUpgradeKillCount7: TSpinEdit
          Left = 47
          Top = 173
          Width = 53
          Height = 21
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 6
          Value = 600
          OnChange = EditMonUpgradeKillCount7Change
        end
        object EditMonUpLvNeedKillBase: TSpinEdit
          Left = 47
          Top = 199
          Width = 53
          Height = 21
          Hint = '????=?? * ?? + ?? + ?? + ????'
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 7
          Value = 100
          OnChange = EditMonUpLvNeedKillBaseChange
        end
        object EditMonUpLvRate: TSpinEdit
          Left = 47
          Top = 225
          Width = 53
          Height = 21
          Hint = '????=???? * ?? + ?? + ?? + ????'
          EditorEnabled = False
          Increment = 10
          MaxValue = 9999
          MinValue = 0
          TabOrder = 8
          Value = 16
          OnChange = EditMonUpLvRateChange
        end
      end
      object GroupBox35: TGroupBox
        Left = 255
        Top = 5
        Width = 134
        Height = 122
        Caption = #21467#21464
        TabOrder = 3
        object Label88: TLabel
          Left = 12
          Top = 43
          Width = 30
          Height = 12
          Caption = #26426#29575':'
        end
        object Label90: TLabel
          Left = 12
          Top = 69
          Width = 30
          Height = 12
          Caption = #21147#37327':'
        end
        object Label92: TLabel
          Left = 12
          Top = 95
          Width = 30
          Height = 12
          Caption = #36895#24230':'
        end
        object CheckBoxMasterDieMutiny: TCheckBox
          Left = 9
          Top = 17
          Width = 122
          Height = 19
          Caption = #20027#20154#27515#20129#21467#21464
          TabOrder = 0
          OnClick = CheckBoxMasterDieMutinyClick
        end
        object EditMasterDieMutinyRate: TSpinEdit
          Left = 54
          Top = 39
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditMasterDieMutinyRateChange
        end
        object EditMasterDieMutinyPower: TSpinEdit
          Left = 54
          Top = 65
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditMasterDieMutinyPowerChange
        end
        object EditMasterDieMutinySpeed: TSpinEdit
          Left = 54
          Top = 91
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 3
          Value = 100
          OnChange = EditMasterDieMutinySpeedChange
        end
      end
      object GroupBox47: TGroupBox
        Left = 255
        Top = 135
        Width = 134
        Height = 70
        TabOrder = 4
        object Label112: TLabel
          Left = 12
          Top = 43
          Width = 54
          Height = 12
          Caption = #26102#38388#38388#38548':'
        end
        object CheckBoxBBMonAutoChangeColor: TCheckBox
          Left = 9
          Top = 17
          Width = 100
          Height = 19
          Caption = #23456#29289#33258#21160#21464#33394
          TabOrder = 0
          OnClick = CheckBoxBBMonAutoChangeColorClick
        end
        object EditBBMonAutoChangeColorTime: TSpinEdit
          Left = 70
          Top = 39
          Width = 53
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 1
          TabOrder = 1
          Value = 100
          OnChange = EditBBMonAutoChangeColorTimeChange
        end
      end
    end
    object MonSaySheet: TTabSheet
      Caption = #24618#29289#35828#35805
      object GroupBox40: TGroupBox
        Left = 9
        Top = 9
        Width = 148
        Height = 44
        Caption = #24618#29289#35828#35805
        TabOrder = 0
        object CheckBoxMonSayMsg: TCheckBox
          Left = 13
          Top = 17
          Width = 122
          Height = 19
          Hint = 'Allow mobs to talk'
          Caption = #24320#21551#24618#29289#35828#35805
          Checked = True
          State = cbChecked
          TabOrder = 0
          OnClick = CheckBoxMonSayMsgClick
        end
      end
      object ButtonMonSayMsgSave: TButton
        Left = 395
        Top = 288
        Width = 71
        Height = 26
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonMonSayMsgSaveClick
      end
    end
    object TabSheet1: TTabSheet
      Caption = #25216#33021#39764#27861
      ImageIndex = 1
      object MagicPageControl: TPageControl
        Left = 0
        Top = 0
        Width = 486
        Height = 281
        ActivePage = TabSheet36
        MultiLine = True
        TabOrder = 0
        TabPosition = tpBottom
        object TabSheet36: TTabSheet
          Caption = #24868#24594
          ImageIndex = 31
          object GroupBox17: TGroupBox
            Left = 9
            Top = 9
            Width = 124
            Height = 53
            Caption = #24868#24594#25915#20987#35774#32622
            TabOrder = 0
            object Label12: TLabel
              Left = 9
              Top = 24
              Width = 30
              Height = 12
              Caption = #24868#24594':'
            end
            object EditMagicAttackRage: TSpinEdit
              Left = 50
              Top = 20
              Width = 57
              Height = 21
              Hint = 
                'Range an object must be withing before it can be attacked by a m' +
                'agic(distance) attack'
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMagicAttackRageChange
            end
          end
        end
        object TabSheet11: TTabSheet
          Caption = #21050#26432#21073#27861
          ImageIndex = 10
          object GroupBox10: TGroupBox
            Left = 8
            Top = 56
            Width = 129
            Height = 49
            Caption = #25915#20987#21147#20493#25968
            TabOrder = 0
            object Label4: TLabel
              Left = 8
              Top = 24
              Width = 30
              Height = 12
              Caption = #20493#25968':'
            end
            object Label10: TLabel
              Left = 96
              Top = 24
              Width = 24
              Height = 12
              Caption = '/100'
            end
            object EditSwordLongPowerRate: TSpinEdit
              Left = 44
              Top = 19
              Width = 45
              Height = 21
              Hint = #25915#20987#21147#20493#25968#65292#25968#23383#22823#23567' '#38500#20197' 100'#20026#23454#38469#20493#25968#12290
              EditorEnabled = False
              MaxValue = 1000
              MinValue = 1
              TabOrder = 0
              Value = 100
              OnChange = EditSwordLongPowerRateChange
            end
          end
          object GroupBox9: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #26080#38480#21050#26432
            TabOrder = 1
            object CheckBoxLimitSwordLong: TCheckBox
              Left = 8
              Top = 16
              Width = 97
              Height = 17
              Hint = #25171#24320#27492#21151#33021#21518#65292#23558#26816#26597#26816#26597#38548#20301#26159#21542#26377#35282#33394#23384#22312#65292#20197#31105#27490#20992#20992#21050#26432#12290
              Caption = #31105#27490#26080#38480#21050#26432
              TabOrder = 0
              OnClick = CheckBoxLimitSwordLongClick
            end
          end
        end
        object FiresWordTab: TTabSheet
          Caption = #28872#28779#21073#27861
        end
        object TabSheet18: TTabSheet
          Caption = #35825#24785#20043#20809
          ImageIndex = 17
          object GroupBox39: TGroupBox
            Left = 8
            Top = 64
            Width = 113
            Height = 73
            Caption = #35825#24785#26426#29575
            TabOrder = 0
            object Label99: TLabel
              Left = 8
              Top = 20
              Width = 54
              Height = 12
              Caption = #24618#29289#31561#32423':'
            end
            object Label100: TLabel
              Left = 8
              Top = 44
              Width = 54
              Height = 12
              Caption = #24618#29289#34880#37327':'
            end
            object EditMagTammingTargetLevel: TSpinEdit
              Left = 64
              Top = 15
              Width = 41
              Height = 21
              Hint = #24618#29289#31561#32423#27604#29575#65292#27492#25968#23383#36234#23567#26426#29575#36234#22823#12290
              EditorEnabled = False
              MaxValue = 65535
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditMagTammingTargetLevelChange
            end
            object EditMagTammingHPRate: TSpinEdit
              Left = 64
              Top = 39
              Width = 41
              Height = 21
              Hint = #24618#29289#34880#37327#27604#29575#65292#27492#25968#23383#36234#22823#65292#26426#29575#36234#22823#12290
              EditorEnabled = False
              MaxValue = 65535
              MinValue = 1
              TabOrder = 1
              Value = 1
              OnChange = EditMagTammingHPRateChange
            end
          end
          object GroupBox38: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 49
            Caption = #24618#29289#31561#32423#38480#21046
            TabOrder = 1
            object Label98: TLabel
              Left = 8
              Top = 24
              Width = 30
              Height = 12
              Caption = #31561#32423':'
            end
            object EditMagTammingLevel: TSpinEdit
              Left = 44
              Top = 19
              Width = 61
              Height = 21
              Hint = #25351#23450#31561#32423#20197#19979#30340#24618#29289#25165#20250#34987#35825#24785#65292#25351#23450#31561#32423#20197#19978#30340#24618#29289#35825#24785#26080#25928#12290
              EditorEnabled = False
              MaxValue = 65535
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditMagTammingLevelChange
            end
          end
          object GroupBox45: TGroupBox
            Left = 128
            Top = 8
            Width = 113
            Height = 49
            Caption = #35825#24785#25968#37327
            TabOrder = 2
            object Label111: TLabel
              Left = 8
              Top = 24
              Width = 30
              Height = 12
              Caption = #25968#37327':'
            end
            object EditTammingCount: TSpinEdit
              Left = 44
              Top = 19
              Width = 61
              Height = 21
              Hint = #21487#35825#24785#24618#29289#25968#37327#12290
              EditorEnabled = False
              MaxValue = 65535
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditTammingCountChange
            end
          end
        end
        object TabSheet20: TTabSheet
          Caption = #28779#22681
          ImageIndex = 19
          object GroupBox46: TGroupBox
            Left = 9
            Top = 9
            Width = 122
            Height = 44
            Caption = #23433#20840#21306#31105#27490#28779#22681
            TabOrder = 0
            object CheckBoxFireCrossInSafeZone: TCheckBox
              Left = 9
              Top = 17
              Width = 105
              Height = 19
              Hint = 'Allow firewall to be casted in a safezone'
              Caption = #31105#27490#28779#22681
              TabOrder = 0
              OnClick = CheckBoxFireCrossInSafeZoneClick
            end
          end
        end
        object TabSheet28: TTabSheet
          Caption = #22307#35328#26415
          ImageIndex = 27
          object GroupBox37: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 49
            Caption = #24618#29289#31561#32423#38480#21046
            TabOrder = 0
            object Label97: TLabel
              Left = 8
              Top = 24
              Width = 30
              Height = 12
              Caption = #31561#32423':'
            end
            object EditMagTurnUndeadLevel: TSpinEdit
              Left = 44
              Top = 19
              Width = 61
              Height = 21
              Hint = #25351#23450#31561#32423#20197#19979#30340#24618#29289#25165#20250#34987#22307#35328#65292#25351#23450#31561#32423#20197#19978#30340#24618#29289#22307#35328#26080#25928#12290
              EditorEnabled = False
              MaxValue = 65535
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditMagTurnUndeadLevelChange
            end
          end
        end
        object TabSheet22: TTabSheet
          Caption = #22320#29425#38647#20809
          ImageIndex = 21
          object GroupBox15: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 49
            Caption = #25915#20987#33539#22260
            TabOrder = 0
            object Label9: TLabel
              Left = 8
              Top = 24
              Width = 30
              Height = 12
              Caption = #33539#22260':'
            end
            object EditElecBlizzardRange: TSpinEdit
              Left = 44
              Top = 19
              Width = 61
              Height = 21
              Hint = #39764#27861#25915#20987#33539#22260#21322#24452#12290
              EditorEnabled = False
              MaxValue = 12
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditElecBlizzardRangeChange
            end
          end
        end
        object TabSheet21: TTabSheet
          Caption = #29190#35010#28779#28976
          ImageIndex = 20
          object GroupBox13: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #25915#20987#33539#22260
            TabOrder = 0
            object Label7: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #33539#22260':'
            end
            object EditFireBoomRage: TSpinEdit
              Left = 44
              Top = 15
              Width = 61
              Height = 21
              Hint = #39764#27861#25915#20987#33539#22260#21322#24452#12290
              EditorEnabled = False
              MaxValue = 12
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditFireBoomRageChange
            end
          end
        end
        object TabSheet29: TTabSheet
          Caption = #20912#21638#21742
          ImageIndex = 28
          object GroupBox14: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #25915#20987#33539#22260
            TabOrder = 0
            object Label8: TLabel
              Left = 8
              Top = 20
              Width = 30
              Height = 12
              Caption = #33539#22260':'
            end
            object EditSnowWindRange: TSpinEdit
              Left = 44
              Top = 15
              Width = 61
              Height = 21
              Hint = #39764#27861#25915#20987#33539#22260#21322#24452#12290
              EditorEnabled = False
              MaxValue = 12
              MinValue = 1
              TabOrder = 0
              Value = 1
              OnChange = EditSnowWindRangeChange
            end
          end
        end
        object TabSheet6: TTabSheet
          Caption = #26045#27602#26415
          ImageIndex = 4
          object GroupBox16: TGroupBox
            Left = 8
            Top = 8
            Width = 137
            Height = 49
            Caption = #27602#33647#38477#28857
            TabOrder = 0
            object Label11: TLabel
              Left = 8
              Top = 22
              Width = 54
              Height = 12
              Caption = #28857#25968#25511#21046':'
            end
            object EditAmyOunsulPoint: TSpinEdit
              Left = 68
              Top = 18
              Width = 53
              Height = 21
              Hint = #20013#27602#21518#25351#23450#26102#38388#20869#38477#28857#25968#65292#23454#38469#28857#25968#36319#25216#33021#31561#32423#21450#26412#36523#36947#26415#39640#20302#26377#20851#65292#27492#21442#25968#21482#26159#35843#20854#20013#31639#27861#21442#25968#65292#27492#25968#23383#36234#23567#65292#28857#25968#36234#22823#12290
              EditorEnabled = False
              MaxValue = 100
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditAmyOunsulPointChange
            end
          end
        end
        object TabSheet3: TTabSheet
          Caption = #21484#21796#39607#39621
          ImageIndex = 1
          object GroupBox5: TGroupBox
            Left = 5
            Top = 6
            Width = 132
            Height = 143
            Caption = #22522#26412#35774#32622
            TabOrder = 0
            object Label2: TLabel
              Left = 12
              Top = 18
              Width = 54
              Height = 12
              Caption = #24618#29289#21517#31216':'
            end
            object Label3: TLabel
              Left = 12
              Top = 62
              Width = 54
              Height = 12
              Caption = #21484#21796#25968#37327':'
            end
            object EditBoneFammName: TEdit
              Left = 12
              Top = 32
              Width = 105
              Height = 20
              Hint = #35774#32622#40664#35748#21484#21796#30340#24618#29289#21517#31216#12290
              TabOrder = 0
              OnChange = EditBoneFammNameChange
            end
            object EditBoneFammCount: TSpinEdit
              Left = 64
              Top = 59
              Width = 53
              Height = 21
              Hint = #35774#32622#21487#21484#21796#26368#22823#25968#37327#12290
              EditorEnabled = False
              MaxValue = 255
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditBoneFammCountChange
            end
          end
          object GroupBox6: TGroupBox
            Left = 144
            Top = 6
            Width = 289
            Height = 143
            Caption = #39640#32423#35774#32622
            TabOrder = 1
            object GridBoneFamm: TStringGrid
              Left = 12
              Top = 16
              Width = 265
              Height = 113
              ColCount = 4
              DefaultRowHeight = 18
              FixedCols = 0
              RowCount = 11
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
              TabOrder = 0
              OnSetEditText = GridBoneFammSetEditText
              ColWidths = (
                55
                76
                57
                52)
            end
          end
        end
        object TabSheet4: TTabSheet
          Caption = #21484#21796#31070#20861
          ImageIndex = 2
          object GroupBox11: TGroupBox
            Left = 5
            Top = 2
            Width = 132
            Height = 143
            Caption = #22522#26412#35774#32622
            TabOrder = 0
            object Label5: TLabel
              Left = 12
              Top = 18
              Width = 54
              Height = 12
              Caption = #24618#29289#21517#31216':'
            end
            object Label6: TLabel
              Left = 12
              Top = 63
              Width = 54
              Height = 12
              Caption = #21484#21796#25968#37327':'
            end
            object EditDogzName: TEdit
              Left = 12
              Top = 32
              Width = 105
              Height = 20
              Hint = #35774#32622#40664#35748#21484#21796#30340#24618#29289#21517#31216#12290
              TabOrder = 0
              OnChange = EditDogzNameChange
            end
            object EditDogzCount: TSpinEdit
              Left = 68
              Top = 59
              Width = 49
              Height = 21
              Hint = #35774#32622#21487#21484#21796#26368#22823#25968#37327#12290
              EditorEnabled = False
              MaxValue = 255
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditDogzCountChange
            end
          end
          object GroupBox12: TGroupBox
            Left = 144
            Top = 2
            Width = 289
            Height = 143
            Caption = #39640#32423#35774#32622
            TabOrder = 1
            object GridDogz: TStringGrid
              Left = 12
              Top = 16
              Width = 265
              Height = 113
              ColCount = 4
              DefaultRowHeight = 18
              FixedCols = 0
              RowCount = 11
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goEditing]
              TabOrder = 0
              OnSetEditText = GridBoneFammSetEditText
              ColWidths = (
                55
                76
                57
                52)
            end
          end
        end
        object TabSheet41: TTabSheet
          Caption = #28779#28976#20912
          ImageIndex = 32
          object GroupBox41: TGroupBox
            Left = 8
            Top = 8
            Width = 145
            Height = 73
            Caption = #35282#33394#31561#32423#26426#29575#35774#32622
            TabOrder = 0
            object Label101: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #30456#24046#26426#29575':'
            end
            object Label102: TLabel
              Left = 8
              Top = 42
              Width = 54
              Height = 12
              Caption = #30456#24046#38480#21046':'
            end
            object EditMabMabeHitRandRate: TSpinEdit
              Left = 68
              Top = 15
              Width = 53
              Height = 21
              Hint = #25915#20987#34987#25915#20987#21452#26041#30456#24046#31561#32423#21629#20013#26426#29575#65292#25968#23383#36234#22823#26426#29575#36234#23567#12290
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMabMabeHitRandRateChange
            end
            object EditMabMabeHitMinLvLimit: TSpinEdit
              Left = 68
              Top = 39
              Width = 53
              Height = 21
              Hint = #25915#20987#34987#25915#20987#21452#26041#30456#24046#31561#32423#21629#20013#26426#29575#65292#26368#23567#38480#21046#65292#25968#23383#36234#23567#26426#29575#36234#20302#12290
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 1
              Value = 10
              OnChange = EditMabMabeHitMinLvLimitChange
            end
          end
          object GroupBox42: TGroupBox
            Left = 8
            Top = 88
            Width = 145
            Height = 49
            Caption = #40635#30201#21629#20013#26426#29575
            TabOrder = 1
            object Label103: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #21629#20013#26426#29575':'
            end
            object EditMabMabeHitSucessRate: TSpinEdit
              Left = 68
              Top = 15
              Width = 53
              Height = 21
              Hint = #25915#20987#40635#30201#26426#29575#65292#26368#23567#38480#21046#65292#25968#23383#36234#23567#26426#29575#36234#20302#12290
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMabMabeHitSucessRateChange
            end
          end
          object GroupBox43: TGroupBox
            Left = 160
            Top = 8
            Width = 145
            Height = 49
            Caption = #40635#30201#26102#38388#21442#25968#20493#29575
            TabOrder = 2
            object Label104: TLabel
              Left = 8
              Top = 18
              Width = 54
              Height = 12
              Caption = #21629#20013#26426#29575':'
            end
            object EditMabMabeHitMabeTimeRate: TSpinEdit
              Left = 68
              Top = 15
              Width = 53
              Height = 21
              Hint = #40635#30201#26102#38388#38271#24230#20493#29575#65292#22522#25968#19982#35282#33394#30340#39764#27861#26377#20851#12290
              EditorEnabled = False
              MaxValue = 20
              MinValue = 1
              TabOrder = 0
              Value = 10
              OnChange = EditMabMabeHitMabeTimeRateChange
            end
          end
        end
        object TabSheet43: TTabSheet
          Caption = #29422#23376#21564
          ImageIndex = 33
          object GroupBox48: TGroupBox
            Left = 8
            Top = 8
            Width = 113
            Height = 41
            Caption = #23545#20154#29289#26377#25928
            TabOrder = 0
            object CheckBoxGroupMbAttackPlayObject: TCheckBox
              Left = 8
              Top = 16
              Width = 97
              Height = 17
              Hint = #25171#24320#27492#21151#33021#21518#65292#23601#21487#20197#40635#30201#20154#29289
              Caption = #20801#35768#40635#30201#20154#29289
              TabOrder = 0
              OnClick = CheckBoxGroupMbAttackPlayObjectClick
            end
          end
        end
      end
      object ButtonSkillSave: TButton
        Left = 399
        Top = 292
        Width = 71
        Height = 26
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonSkillSaveClick
      end
    end
    object TabSheet34: TTabSheet
      Caption = #21319#32423#27494#22120
      ImageIndex = 6
      object GroupBox8: TGroupBox
        Left = 9
        Top = 9
        Width = 156
        Height = 128
        Caption = #22522#26412#35774#32622
        TabOrder = 0
        object Label13: TLabel
          Left = 9
          Top = 20
          Width = 54
          Height = 12
          Caption = #26368#39640#28857#25968':'
        end
        object Label15: TLabel
          Left = 9
          Top = 46
          Width = 54
          Height = 12
          Caption = #25152#38656#36153#29992':'
        end
        object Label16: TLabel
          Left = 9
          Top = 72
          Width = 54
          Height = 12
          Caption = #25152#38656#26102#38388':'
        end
        object Label17: TLabel
          Left = 9
          Top = 98
          Width = 54
          Height = 12
          Caption = #36807#26399#26102#38388':'
        end
        object Label18: TLabel
          Left = 135
          Top = 72
          Width = 12
          Height = 12
          Caption = #31186
        end
        object Label19: TLabel
          Left = 135
          Top = 98
          Width = 12
          Height = 12
          Caption = #22825
        end
        object EditUpgradeWeaponMaxPoint: TSpinEdit
          Left = 65
          Top = 16
          Width = 65
          Height = 21
          Hint = 'Maximum no of refines that can be made on 1 weapon'
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 20
          OnChange = EditUpgradeWeaponMaxPointChange
        end
        object EditUpgradeWeaponPrice: TSpinEdit
          Left = 65
          Top = 42
          Width = 65
          Height = 21
          Hint = 'Cost per refine'
          EditorEnabled = False
          MaxValue = 1000000
          MinValue = 1
          TabOrder = 1
          Value = 10000
          OnChange = EditUpgradeWeaponPriceChange
        end
        object EditUPgradeWeaponGetBackTime: TSpinEdit
          Left = 65
          Top = 68
          Width = 65
          Height = 21
          Hint = 'Time in minutes before you can get weapon back'
          EditorEnabled = False
          MaxValue = 36000000
          MinValue = 1
          TabOrder = 2
          Value = 3600
          OnChange = EditUPgradeWeaponGetBackTimeChange
        end
        object EditClearExpireUpgradeWeaponDays: TSpinEdit
          Left = 65
          Top = 94
          Width = 65
          Height = 21
          Hint = 'No of days weapon will be kept before being deleted'
          EditorEnabled = False
          MaxValue = 100
          MinValue = 1
          TabOrder = 3
          Value = 8
          OnChange = EditClearExpireUpgradeWeaponDaysChange
        end
      end
      object GroupBox18: TGroupBox
        Left = 191
        Top = 9
        Width = 287
        Height = 96
        Caption = #25915#20987#21147#21319#32423
        TabOrder = 1
        object Label20: TLabel
          Left = 9
          Top = 20
          Width = 54
          Height = 12
          Caption = #25104#21151#26426#29575':'
        end
        object Label21: TLabel
          Left = 9
          Top = 46
          Width = 54
          Height = 12
          Caption = #20108#28857#26426#29575':'
        end
        object Label22: TLabel
          Left = 9
          Top = 72
          Width = 54
          Height = 12
          Caption = #19977#28857#26426#29575':'
        end
        object ScrollBarUpgradeWeaponDCRate: TScrollBar
          Left = 69
          Top = 17
          Width = 157
          Height = 18
          Hint = '???????????,????????'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponDCRateChange
        end
        object EditUpgradeWeaponDCRate: TEdit
          Left = 234
          Top = 17
          Width = 44
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
          Text = '100'
        end
        object ScrollBarUpgradeWeaponDCTwoPointRate: TScrollBar
          Left = 69
          Top = 43
          Width = 157
          Height = 18
          Hint = '????????,????????'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponDCTwoPointRateChange
        end
        object EditUpgradeWeaponDCTwoPointRate: TEdit
          Left = 234
          Top = 43
          Width = 44
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
          Text = '30'
        end
        object ScrollBarUpgradeWeaponDCThreePointRate: TScrollBar
          Left = 69
          Top = 69
          Width = 157
          Height = 18
          Hint = '????????,????????'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponDCThreePointRateChange
        end
        object EditUpgradeWeaponDCThreePointRate: TEdit
          Left = 234
          Top = 69
          Width = 44
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
          Text = '200'
        end
      end
      object GroupBox19: TGroupBox
        Left = 191
        Top = 113
        Width = 287
        Height = 100
        Caption = #36947#26415#21319#32423
        TabOrder = 2
        object Label23: TLabel
          Left = 9
          Top = 20
          Width = 54
          Height = 12
          Caption = #25104#21151#26426#29575':'
        end
        object Label24: TLabel
          Left = 9
          Top = 46
          Width = 54
          Height = 12
          Caption = #20108#28857#26426#29575':'
        end
        object Label25: TLabel
          Left = 9
          Top = 72
          Width = 54
          Height = 12
          Caption = #19977#28857#26426#29575':'
        end
        object ScrollBarUpgradeWeaponSCRate: TScrollBar
          Left = 69
          Top = 17
          Width = 157
          Height = 18
          Hint = '??????????,????????'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponSCRateChange
        end
        object EditUpgradeWeaponSCRate: TEdit
          Left = 234
          Top = 17
          Width = 44
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
          Text = '100'
        end
        object ScrollBarUpgradeWeaponSCTwoPointRate: TScrollBar
          Left = 69
          Top = 43
          Width = 157
          Height = 18
          Hint = '????????,????????'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponSCTwoPointRateChange
        end
        object EditUpgradeWeaponSCTwoPointRate: TEdit
          Left = 234
          Top = 43
          Width = 44
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
          Text = '30'
        end
        object ScrollBarUpgradeWeaponSCThreePointRate: TScrollBar
          Left = 69
          Top = 69
          Width = 157
          Height = 18
          Hint = '????????,????????'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponSCThreePointRateChange
        end
        object EditUpgradeWeaponSCThreePointRate: TEdit
          Left = 234
          Top = 69
          Width = 44
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
          Text = '200'
        end
      end
      object GroupBox20: TGroupBox
        Left = 191
        Top = 221
        Width = 287
        Height = 97
        Caption = #39764#27861#21319#32423
        TabOrder = 3
        object Label26: TLabel
          Left = 9
          Top = 20
          Width = 54
          Height = 12
          Caption = #25104#21151#26426#29575':'
        end
        object Label27: TLabel
          Left = 9
          Top = 46
          Width = 54
          Height = 12
          Caption = #20108#28857#26426#29575':'
        end
        object Label28: TLabel
          Left = 9
          Top = 72
          Width = 54
          Height = 12
          Caption = #19977#28857#26426#29575':'
        end
        object ScrollBarUpgradeWeaponMCRate: TScrollBar
          Left = 69
          Top = 17
          Width = 157
          Height = 18
          Hint = '??????????,????????'
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarUpgradeWeaponMCRateChange
        end
        object EditUpgradeWeaponMCRate: TEdit
          Left = 234
          Top = 17
          Width = 44
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
          Text = '100'
        end
        object ScrollBarUpgradeWeaponMCTwoPointRate: TScrollBar
          Left = 69
          Top = 43
          Width = 157
          Height = 18
          Hint = '????????,????????'
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarUpgradeWeaponMCTwoPointRateChange
        end
        object EditUpgradeWeaponMCTwoPointRate: TEdit
          Left = 234
          Top = 43
          Width = 44
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
          Text = '30'
        end
        object ScrollBarUpgradeWeaponMCThreePointRate: TScrollBar
          Left = 69
          Top = 69
          Width = 157
          Height = 18
          Hint = '????????,????????'
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarUpgradeWeaponMCThreePointRateChange
        end
        object EditUpgradeWeaponMCThreePointRate: TEdit
          Left = 234
          Top = 69
          Width = 44
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
          Text = '200'
        end
      end
      object ButtonUpgradeWeaponSave: TButton
        Left = 9
        Top = 296
        Width = 70
        Height = 26
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 4
        OnClick = ButtonUpgradeWeaponSaveClick
      end
      object ButtonUpgradeWeaponDefaulf: TButton
        Left = 95
        Top = 296
        Width = 70
        Height = 26
        Hint = 'Reload default values'
        Caption = #40664#35748'(&D)'
        TabOrder = 5
        OnClick = ButtonUpgradeWeaponDefaulfClick
      end
    end
    object TabSheet35: TTabSheet
      Caption = #25366#30719#25511#21046
      ImageIndex = 7
      object ButtonMakeMineSave: TButton
        Left = 407
        Top = 292
        Width = 71
        Height = 25
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonMakeMineSaveClick
      end
      object ButtonMakeMineDefault: TButton
        Left = 321
        Top = 292
        Width = 70
        Height = 25
        Hint = 'Reload default values'
        Caption = #40664#35748'(&D)'
        TabOrder = 1
        OnClick = ButtonMakeMineDefaultClick
      end
      object GroupBox24: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 60
        Caption = #24471#21040#30719#30707#26426#29575
        TabOrder = 2
        object Label32: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #21629#20013#26426#29575':'
        end
        object Label33: TLabel
          Left = 8
          Top = 36
          Width = 54
          Height = 12
          Caption = #25366#30719#26426#29575':'
        end
        object ScrollBarMakeMineHitRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Hint = #35774#32622#30340#25968#23383#36234#23567#26426#29575#36234#22823#12290
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarMakeMineHitRateChange
        end
        object EditMakeMineHitRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarMakeMineRate: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Hint = #35774#32622#30340#25968#23383#36234#23567#26426#29575#36234#22823#12290
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarMakeMineRateChange
        end
        object EditMakeMineRate: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
      end
      object GroupBox25: TGroupBox
        Left = 8
        Top = 72
        Width = 273
        Height = 217
        Caption = #30719#30707#31867#22411#26426#29575
        TabOrder = 3
        object Label34: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #30719#30707#22240#23376':'
        end
        object Label35: TLabel
          Left = 8
          Top = 38
          Width = 42
          Height = 12
          Caption = #37329#30719#29575':'
        end
        object Label36: TLabel
          Left = 8
          Top = 56
          Width = 42
          Height = 12
          Caption = #38134#30719#29575':'
        end
        object Label37: TLabel
          Left = 8
          Top = 76
          Width = 42
          Height = 12
          Caption = #38081#30719#29575':'
        end
        object Label38: TLabel
          Left = 8
          Top = 96
          Width = 54
          Height = 12
          Caption = #40657#38081#30719#29575':'
        end
        object ScrollBarStoneTypeRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarStoneTypeRateChange
        end
        object EditStoneTypeRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarGoldStoneMax: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarGoldStoneMaxChange
        end
        object EditGoldStoneMax: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarSilverStoneMax: TScrollBar
          Left = 72
          Top = 56
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarSilverStoneMaxChange
        end
        object EditSilverStoneMax: TEdit
          Left = 208
          Top = 56
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarSteelStoneMax: TScrollBar
          Left = 72
          Top = 76
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarSteelStoneMaxChange
        end
        object EditSteelStoneMax: TEdit
          Left = 208
          Top = 76
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditBlackStoneMax: TEdit
          Left = 208
          Top = 96
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarBlackStoneMax: TScrollBar
          Left = 72
          Top = 96
          Width = 129
          Height = 15
          Max = 500
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarBlackStoneMaxChange
        end
      end
      object GroupBox26: TGroupBox
        Left = 288
        Top = 8
        Width = 153
        Height = 121
        Caption = #30719#30707#21697#36136
        TabOrder = 4
        object Label39: TLabel
          Left = 8
          Top = 18
          Width = 78
          Height = 12
          Caption = #30719#30707#26368#23567#21697#36136':'
        end
        object Label40: TLabel
          Left = 8
          Top = 42
          Width = 78
          Height = 12
          Caption = #26222#36890#21697#36136#33539#22260':'
        end
        object Label41: TLabel
          Left = 8
          Top = 66
          Width = 66
          Height = 12
          Caption = #39640#21697#36136#26426#29575':'
        end
        object Label42: TLabel
          Left = 8
          Top = 90
          Width = 66
          Height = 12
          Caption = #39640#21697#36136#33539#22260':'
        end
        object EditStoneMinDura: TSpinEdit
          Left = 92
          Top = 15
          Width = 45
          Height = 21
          Hint = #30719#30707#20986#29616#26368#20302#21697#36136#28857#25968#12290
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 0
          Value = 10
          OnChange = EditStoneMinDuraChange
        end
        object EditStoneGeneralDuraRate: TSpinEdit
          Left = 92
          Top = 39
          Width = 45
          Height = 21
          Hint = #30719#30707#38543#26426#20986#29616#21697#36136#28857#25968#33539#22260#12290
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditStoneGeneralDuraRateChange
        end
        object EditStoneAddDuraRate: TSpinEdit
          Left = 92
          Top = 63
          Width = 45
          Height = 21
          Hint = #30719#30707#20986#29616#39640#21697#36136#28857#25968#26426#29575#65292#39640#21697#36136#37327#25351#21487#36798#21040'20'#25110#20197#19978#30340#28857#25968#12290
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditStoneAddDuraRateChange
        end
        object EditStoneAddDuraMax: TSpinEdit
          Left = 92
          Top = 87
          Width = 45
          Height = 21
          Hint = #39640#21697#36136#30719#30707#38543#26426#20986#29616#21697#36136#28857#25968#33539#22260#12290
          EditorEnabled = False
          MaxValue = 1000
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditStoneAddDuraMaxChange
        end
      end
    end
    object TabSheet42: TTabSheet
      Caption = #31069#31119#27833#25511#21046
      ImageIndex = 12
      object ButtonWeaponMakeLuckDefault: TButton
        Left = 313
        Top = 292
        Width = 70
        Height = 25
        Hint = 'Reload default values'
        Caption = #40664#35748'(&D)'
        TabOrder = 0
        OnClick = ButtonWeaponMakeLuckDefaultClick
      end
      object ButtonWeaponMakeLuckSave: TButton
        Left = 399
        Top = 292
        Width = 71
        Height = 25
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 1
        OnClick = ButtonWeaponMakeLuckSaveClick
      end
      object GroupBox44: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 217
        Caption = #26426#29575#35774#32622
        TabOrder = 2
        object Label105: TLabel
          Left = 8
          Top = 18
          Width = 54
          Height = 12
          Caption = #35781#21650#26426#29575':'
        end
        object Label106: TLabel
          Left = 8
          Top = 38
          Width = 54
          Height = 12
          Caption = #19968#32423#28857#25968':'
        end
        object Label107: TLabel
          Left = 8
          Top = 56
          Width = 54
          Height = 12
          Caption = #20108#32423#28857#25968':'
        end
        object Label108: TLabel
          Left = 8
          Top = 76
          Width = 54
          Height = 12
          Caption = #20108#32423#26426#29575':'
        end
        object Label109: TLabel
          Left = 8
          Top = 96
          Width = 54
          Height = 12
          Caption = #19977#32423#28857#25968':'
        end
        object Label110: TLabel
          Left = 8
          Top = 116
          Width = 54
          Height = 12
          Caption = #19977#32423#26426#29575':'
        end
        object ScrollBarWeaponMakeUnLuckRate: TScrollBar
          Left = 72
          Top = 16
          Width = 129
          Height = 15
          Hint = #20351#29992#31069#31119#27833#35781#21650#26426#29575#65292#25968#23383#36234#22823#26426#29575#36234#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarWeaponMakeUnLuckRateChange
        end
        object EditWeaponMakeUnLuckRate: TEdit
          Left = 208
          Top = 16
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarWeaponMakeLuckPoint1: TScrollBar
          Left = 72
          Top = 36
          Width = 129
          Height = 15
          Hint = #24403#27494#22120#30340#24184#36816#28857#23567#20110#27492#28857#25968#26102#20351#29992#31069#31119#27833#21017'100% '#25104#21151#12290
          Max = 500
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarWeaponMakeLuckPoint1Change
        end
        object EditWeaponMakeLuckPoint1: TEdit
          Left = 208
          Top = 36
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarWeaponMakeLuckPoint2: TScrollBar
          Left = 72
          Top = 56
          Width = 129
          Height = 15
          Hint = #24403#27494#22120#30340#24184#36816#28857#23567#20110#27492#28857#25968#26102#20351#29992#31069#31119#27833#21017#25353#25351#23450#26426#29575#20915#23450#26159#21542#21152#24184#36816#12290
          Max = 500
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarWeaponMakeLuckPoint2Change
        end
        object EditWeaponMakeLuckPoint2: TEdit
          Left = 208
          Top = 56
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarWeaponMakeLuckPoint2Rate: TScrollBar
          Left = 72
          Top = 76
          Width = 129
          Height = 15
          Hint = #26426#29575#28857#25968#65292#25968#23383#36234#22823#26426#29575#36234#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarWeaponMakeLuckPoint2RateChange
        end
        object EditWeaponMakeLuckPoint2Rate: TEdit
          Left = 208
          Top = 76
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditWeaponMakeLuckPoint3: TEdit
          Left = 208
          Top = 96
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarWeaponMakeLuckPoint3: TScrollBar
          Left = 72
          Top = 96
          Width = 129
          Height = 15
          Hint = #24403#27494#22120#30340#24184#36816#28857#23567#20110#27492#28857#25968#26102#20351#29992#31069#31119#27833#21017#25353#25351#23450#26426#29575#20915#23450#26159#21542#21152#24184#36816#12290
          Max = 500
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarWeaponMakeLuckPoint3Change
        end
        object ScrollBarWeaponMakeLuckPoint3Rate: TScrollBar
          Left = 72
          Top = 116
          Width = 129
          Height = 15
          Hint = #26426#29575#28857#25968#65292#25968#23383#36234#22823#26426#29575#36234#23567#12290
          Max = 500
          PageSize = 0
          TabOrder = 10
          OnChange = ScrollBarWeaponMakeLuckPoint3RateChange
        end
        object EditWeaponMakeLuckPoint3Rate: TEdit
          Left = 208
          Top = 116
          Width = 57
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 11
        end
      end
    end
    object TabSheet37: TTabSheet
      Caption = #24425#31080#25511#21046
      ImageIndex = 8
      object ButtonWinLotterySave: TButton
        Left = 399
        Top = 292
        Width = 71
        Height = 25
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        ModalResult = 1
        TabOrder = 0
        OnClick = ButtonWinLotterySaveClick
      end
      object ButtonWinLotteryDefault: TButton
        Left = 313
        Top = 292
        Width = 70
        Height = 25
        Hint = 'Reload default values'
        Caption = #40664#35748'(&D)'
        TabOrder = 1
        OnClick = ButtonWinLotteryDefaultClick
      end
      object GroupBox27: TGroupBox
        Left = 8
        Top = 8
        Width = 273
        Height = 169
        Caption = #20013#22870#26426#29575
        TabOrder = 2
        object Label43: TLabel
          Left = 8
          Top = 42
          Width = 42
          Height = 12
          Caption = #19968#31561#22870':'
        end
        object Label44: TLabel
          Left = 8
          Top = 62
          Width = 42
          Height = 12
          Caption = #20108#31561#22870':'
        end
        object Label45: TLabel
          Left = 8
          Top = 80
          Width = 42
          Height = 12
          Caption = #19977#31561#22870':'
        end
        object Label46: TLabel
          Left = 8
          Top = 100
          Width = 42
          Height = 12
          Caption = #22235#31561#22870':'
        end
        object Label47: TLabel
          Left = 8
          Top = 120
          Width = 42
          Height = 12
          Caption = #20116#31561#22870':'
        end
        object Label48: TLabel
          Left = 8
          Top = 140
          Width = 42
          Height = 12
          Caption = #20845#31561#22870':'
        end
        object Label49: TLabel
          Left = 8
          Top = 18
          Width = 30
          Height = 12
          Caption = #22240#23376':'
        end
        object ScrollBarWinLottery1Max: TScrollBar
          Left = 56
          Top = 40
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 0
          OnChange = ScrollBarWinLottery1MaxChange
        end
        object EditWinLottery1Max: TEdit
          Left = 192
          Top = 40
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 1
        end
        object ScrollBarWinLottery2Max: TScrollBar
          Left = 56
          Top = 60
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 2
          OnChange = ScrollBarWinLottery2MaxChange
        end
        object EditWinLottery2Max: TEdit
          Left = 192
          Top = 60
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 3
        end
        object ScrollBarWinLottery3Max: TScrollBar
          Left = 56
          Top = 80
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 4
          OnChange = ScrollBarWinLottery3MaxChange
        end
        object EditWinLottery3Max: TEdit
          Left = 192
          Top = 80
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 5
        end
        object ScrollBarWinLottery4Max: TScrollBar
          Left = 56
          Top = 100
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 6
          OnChange = ScrollBarWinLottery4MaxChange
        end
        object EditWinLottery4Max: TEdit
          Left = 192
          Top = 100
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 7
        end
        object EditWinLottery5Max: TEdit
          Left = 192
          Top = 120
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 8
        end
        object ScrollBarWinLottery5Max: TScrollBar
          Left = 56
          Top = 120
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 9
          OnChange = ScrollBarWinLottery5MaxChange
        end
        object ScrollBarWinLottery6Max: TScrollBar
          Left = 56
          Top = 140
          Width = 129
          Height = 15
          Max = 1000000
          PageSize = 0
          TabOrder = 10
          OnChange = ScrollBarWinLottery6MaxChange
        end
        object EditWinLottery6Max: TEdit
          Left = 192
          Top = 140
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 11
        end
        object EditWinLotteryRate: TEdit
          Left = 192
          Top = 16
          Width = 73
          Height = 18
          Ctl3D = False
          Enabled = False
          ParentCtl3D = False
          ReadOnly = True
          TabOrder = 12
        end
        object ScrollBarWinLotteryRate: TScrollBar
          Left = 56
          Top = 16
          Width = 129
          Height = 15
          Max = 100000
          PageSize = 0
          TabOrder = 13
          OnChange = ScrollBarWinLotteryRateChange
        end
      end
      object GroupBox28: TGroupBox
        Left = 288
        Top = 8
        Width = 145
        Height = 169
        Caption = #22870#37329
        TabOrder = 3
        object Label50: TLabel
          Left = 8
          Top = 18
          Width = 42
          Height = 12
          Caption = #19968#31561#22870':'
        end
        object Label51: TLabel
          Left = 8
          Top = 42
          Width = 42
          Height = 12
          Caption = #20108#31561#22870':'
        end
        object Label52: TLabel
          Left = 8
          Top = 66
          Width = 42
          Height = 12
          Caption = #19977#31561#22870':'
        end
        object Label53: TLabel
          Left = 8
          Top = 90
          Width = 42
          Height = 12
          Caption = #22235#31561#22870':'
        end
        object Label54: TLabel
          Left = 8
          Top = 114
          Width = 42
          Height = 12
          Caption = #20116#31561#22870':'
        end
        object Label55: TLabel
          Left = 8
          Top = 138
          Width = 42
          Height = 12
          Caption = #20845#31561#22870':'
        end
        object EditWinLottery1Gold: TSpinEdit
          Left = 56
          Top = 15
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 0
          Value = 100000000
          OnChange = EditWinLottery1GoldChange
        end
        object EditWinLottery2Gold: TSpinEdit
          Left = 56
          Top = 39
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 1
          Value = 10
          OnChange = EditWinLottery2GoldChange
        end
        object EditWinLottery3Gold: TSpinEdit
          Left = 56
          Top = 63
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 2
          Value = 10
          OnChange = EditWinLottery3GoldChange
        end
        object EditWinLottery4Gold: TSpinEdit
          Left = 56
          Top = 87
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 3
          Value = 10
          OnChange = EditWinLottery4GoldChange
        end
        object EditWinLottery5Gold: TSpinEdit
          Left = 56
          Top = 111
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 4
          Value = 10
          OnChange = EditWinLottery5GoldChange
        end
        object EditWinLottery6Gold: TSpinEdit
          Left = 56
          Top = 135
          Width = 81
          Height = 21
          Increment = 500
          MaxValue = 100000000
          MinValue = 1
          TabOrder = 5
          Value = 10
          OnChange = EditWinLottery6GoldChange
        end
      end
    end
    object TabSheet40: TTabSheet
      Caption = #31048#31095#29983#25928
      ImageIndex = 11
      object ButtonSpiritMutinySave: TButton
        Left = 390
        Top = 283
        Width = 70
        Height = 27
        Hint = 'Save settings'
        Caption = #20445#23384'(&S)'
        TabOrder = 0
        OnClick = ButtonSpiritMutinySaveClick
      end
      object GroupBox36: TGroupBox
        Left = 8
        Top = 8
        Width = 137
        Height = 89
        Caption = #31048#31095#29983#25928
        TabOrder = 1
        object Label94: TLabel
          Left = 11
          Top = 40
          Width = 54
          Height = 12
          Caption = #29983#25928#26102#38271':'
        end
        object Label96: TLabel
          Left = 11
          Top = 64
          Width = 54
          Height = 12
          Caption = #33021#37327#20493#25968':'
          Enabled = False
        end
        object CheckBoxSpiritMutiny: TCheckBox
          Left = 8
          Top = 16
          Width = 113
          Height = 17
          Caption = #21551#29992#31048#31095#29305#27530#21151#33021
          TabOrder = 0
          OnClick = CheckBoxSpiritMutinyClick
        end
        object EditSpiritMutinyTime: TSpinEdit
          Left = 72
          Top = 36
          Width = 49
          Height = 21
          EditorEnabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 1
          Value = 100
          OnChange = EditSpiritMutinyTimeChange
        end
        object EditSpiritPowerRate: TSpinEdit
          Left = 72
          Top = 60
          Width = 49
          Height = 21
          EditorEnabled = False
          Enabled = False
          MaxValue = 9999
          MinValue = 0
          TabOrder = 2
          Value = 100
          OnChange = EditSpiritPowerRateChange
        end
      end
    end
  end
end
