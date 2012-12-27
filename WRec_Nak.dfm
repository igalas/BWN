object F_Nak: TF_Nak
  Left = 285
  Top = 187
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = #1058#1077#1089#1090' '#1060#1086#1083#1083#1103' - '#1053#1072#1082#1072#1090#1072#1085#1080
  ClientHeight = 387
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    425
    387)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 344
    Width = 411
    Height = 2
    Anchors = [akLeft, akBottom]
  end
  object GR_RES: TStringGrid
    Left = 8
    Top = 8
    Width = 199
    Height = 329
    ColCount = 3
    RowCount = 13
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnSelectCell = GR_RESSelectCell
  end
  object Button2: TButton
    Left = 336
    Top = 352
    Width = 81
    Height = 25
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077'...'
    TabOrder = 1
    OnClick = onNakDesc
  end
  object Button3: TButton
    Left = 8
    Top = 352
    Width = 89
    Height = 25
    Caption = #1044#1080#1072#1075#1088#1072#1084#1084#1072'...'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Panel1: TPanel
    Left = 208
    Top = 8
    Width = 209
    Height = 327
    BevelInner = bvLowered
    Color = clWhite
    TabOrder = 3
    object IMG_ITEM: TImage
      Left = 3
      Top = 3
      Width = 204
      Height = 322
    end
    object LB_ITEM: TLabel
      Left = 8
      Top = 296
      Width = 193
      Height = 25
      Alignment = taCenter
      AutoSize = False
      Transparent = True
      Layout = tlCenter
    end
  end
end
