object frmMDIParent: TfrmMDIParent
  Left = 316
  Top = 340
  AutoScroll = False
  Caption = 'BitmapEditor'
  ClientHeight = 421
  ClientWidth = 633
  Color = clAppWorkSpace
  TransparentColorValue = clCaptionText
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MainMenu1: TMainMenu
    Left = 64
    Top = 656
    object File1: TMenuItem
      Caption = #1060#1072#1081#1083
      object Open1: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100'...'
        OnClick = Open1Click
      end
      object Save2: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        Enabled = False
      end
      object Save1: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
        Enabled = False
      end
      object N7: TMenuItem
        Caption = '-'
      end
      object Close1: TMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100
        Enabled = False
        OnClick = Close1Click
      end
      object N6: TMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100' '#1074#1089#1077
        Enabled = False
        OnClick = N6Click
      end
      object Exit1: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = Exit1Click
      end
    end
    object N1: TMenuItem
      Caption = #1048#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
      object N2: TMenuItem
        Caption = #1071#1088#1082#1086#1089#1090#1100'/'#1050#1086#1085#1090#1088#1072#1089#1090#1085#1086#1089#1090#1100'...'
        Enabled = False
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = #1054#1073#1077#1089#1094#1074#1077#1090#1080#1090#1100
        Enabled = False
        OnClick = N3Click
      end
      object N4: TMenuItem
        Caption = #1048#1085#1074#1077#1088#1089#1080#1103
        Enabled = False
        OnClick = N4Click
      end
    end
    object N5: TMenuItem
      Caption = #1060#1080#1083#1100#1090#1088
      object N8: TMenuItem
        Caption = #1057#1074#1086#1081' '#1060#1080#1083#1100#1090#1088'...'
        Enabled = False
        OnClick = N8Click
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object N9: TMenuItem
        Caption = #1056#1072#1079#1084#1099#1090#1080#1077'+'
        Enabled = False
        OnClick = N9Click
      end
      object N21: TMenuItem
        Caption = #1056#1072#1079#1084#1099#1090#1080#1077'++'
        Enabled = False
        OnClick = N21Click
      end
      object N22: TMenuItem
        Caption = #1056#1072#1079#1084#1099#1090#1080#1077'+++'
        Enabled = False
        OnClick = N22Click
      end
      object N20: TMenuItem
        Caption = #1041#1083#1102#1088
        Enabled = False
        OnClick = N20Click
      end
      object N25: TMenuItem
        Caption = #1057#1077#1088#1086#1077' '#1090#1080#1089#1085#1077#1085#1080#1077
        Enabled = False
        OnClick = N25Click
      end
      object N17: TMenuItem
        Caption = #1058#1080#1089#1085#1077#1085#1080#1077
        Enabled = False
        OnClick = N17Click
      end
      object N18: TMenuItem
        Caption = #1042#1099#1076#1077#1083#1077#1085#1080#1077' '#1082#1088#1072#1077#1074
        Enabled = False
        OnClick = N18Click
      end
      object N23: TMenuItem
        Caption = #1042#1099#1076#1077#1083#1077#1085#1080#1077' '#1082#1088#1072#1077#1074'+'
        Enabled = False
        OnClick = N23Click
      end
      object N19: TMenuItem
        Caption = #1056#1077#1079#1082#1086#1089#1090#1100
        Enabled = False
        OnClick = N19Click
      end
      object N24: TMenuItem
        Caption = 'Emboss'
        Enabled = False
        OnClick = N24Click
      end
    end
    object N10: TMenuItem
      Caption = #1054#1082#1085#1086
      object a1: TMenuItem
        Caption = 'Tile'
        Enabled = False
        OnClick = a1Click
      end
      object a2: TMenuItem
        Caption = 'Tile horizontally'
        Enabled = False
      end
      object a3: TMenuItem
        Caption = 'Tile vertically'
        Enabled = False
      end
      object a4: TMenuItem
        Caption = 'Cascade'
        Enabled = False
        OnClick = a4Click
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object N12: TMenuItem
        Caption = #1057#1074#1077#1088#1085#1091#1090#1100' '#1074#1089#1077
        Enabled = False
        OnClick = N12Click
      end
      object N13: TMenuItem
        Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1089#1077
        Enabled = False
        OnClick = N13Click
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object N15: TMenuItem
        Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077'...'
        Enabled = False
      end
    end
  end
  object OpenPictureDialog1: TOpenDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Top = 392
  end
  object SavePictureDialog1: TSaveDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    Left = 32
    Top = 392
  end
end
