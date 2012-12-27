object F_Diagr: TF_Diagr
  Left = 253
  Top = 173
  Width = 744
  Height = 514
  BorderIcons = [biSystemMenu, biMaximize, biHelp]
  Caption = 'F_Diagr'
  Color = clBtnFace
  Constraints.MinHeight = 514
  Constraints.MinWidth = 744
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
    728
    476)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 432
    Width = 712
    Height = 2
    Anchors = [akLeft, akRight, akBottom]
  end
  object Chart1: TChart
    Left = 8
    Top = 8
    Width = 711
    Height = 418
    AllowPanning = pmNone
    AllowZoom = False
    BackWall.Brush.Color = clWhite
    BackWall.Color = clWindow
    MarginBottom = 2
    MarginLeft = 0
    MarginRight = 2
    MarginTop = 10
    Title.Text.Strings = (
      #1044#1080#1072#1075#1088#1072#1084#1084#1072' '#1060#1086#1083#1083#1103' - '#1053#1072#1082#1072#1090#1072#1085#1080)
    Title.Visible = False
    BackColor = clWindow
    BottomAxis.Automatic = False
    BottomAxis.AutomaticMaximum = False
    BottomAxis.AutomaticMinimum = False
    BottomAxis.ExactDateTime = False
    BottomAxis.Increment = 1.000000000000000000
    BottomAxis.Maximum = 624.000000000000000000
    DepthAxis.Automatic = False
    DepthAxis.AutomaticMaximum = False
    DepthAxis.AutomaticMinimum = False
    DepthAxis.Maximum = 0.500000000000000000
    DepthAxis.Minimum = -0.500000000000000000
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Maximum = 100.000000000000000000
    Legend.Visible = False
    View3D = False
    Color = clWindow
    TabOrder = 0
    Anchors = [akLeft, akTop, akRight, akBottom]
    object Series1: TBarSeries
      Marks.ArrowLength = 20
      Marks.Style = smsXValue
      Marks.Visible = False
      SeriesColor = clRed
      ShowInLegend = False
      AfterDrawValues = Series1AfterDrawValues
      BeforeDrawValues = Series1BeforeDrawValues
      BarWidthPercent = 1
      OffsetPercent = 80
      YOrigin = 64.000000000000000000
      XValues.DateTime = False
      XValues.Name = 'X'
      XValues.Multiplier = 1.000000000000000000
      XValues.Order = loAscending
      YValues.DateTime = False
      YValues.Name = 'Bar'
      YValues.Multiplier = 1.000000000000000000
      YValues.Order = loNone
    end
  end
  object Button1: TButton
    Left = 8
    Top = 440
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = #1055#1077#1095#1072#1090#1100'...'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 645
    Top = 440
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = Button2Click
  end
  object DLG_PRINT: TPrintDialog
    Left = 88
    Top = 272
  end
end
