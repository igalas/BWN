object F_Nak_Desc: TF_Nak_Desc
  Left = 375
  Top = 227
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'F_Nak_Desc'
  ClientHeight = 381
  ClientWidth = 657
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 337
    Width = 641
    Height = 2
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 213
    Height = 325
    BevelInner = bvLowered
    Color = clWhite
    TabOrder = 0
    object IMG_ORG: TImage
      Left = 3
      Top = 3
      Width = 208
      Height = 320
    end
  end
  object RCH_ORG: TRichEdit
    Left = 226
    Top = 8
    Width = 423
    Height = 325
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button1: TButton
    Left = 568
    Top = 344
    Width = 81
    Height = 27
    Cancel = True
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = Button1Click
  end
end
