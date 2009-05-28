object Correction: TCorrection
  Left = 192
  Top = 107
  Width = 387
  Height = 175
  Caption = #1071#1088#1082#1086#1089#1090#1100'/'#1050#1086#1085#1090#1088#1072#1089#1090#1085#1086#1089#1090#1100
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 43
    Height = 14
    Caption = #1071#1088#1082#1086#1089#1090#1100
  end
  object Label2: TLabel
    Left = 16
    Top = 72
    Width = 79
    Height = 14
    Caption = #1050#1086#1085#1090#1088#1072#1089#1090#1085#1086#1089#1090#1100
  end
  object TrackBar1: TChangedTrackBar
    Left = 8
    Top = 40
    Width = 233
    Height = 25
    Max = 100
    Min = -100
    TabOrder = 0
    TickMarks = tmTopLeft
    TickStyle = tsNone
    OnChange = TrackBar1Change
  end
  object Edit1: TEdit
    Left = 184
    Top = 8
    Width = 49
    Height = 22
    TabOrder = 1
    Text = '0'
    OnChange = Edit1Change
  end
  object OK: TButton
    Left = 288
    Top = 16
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 2
    OnClick = OKClick
  end
  object Cancel: TButton
    Left = 288
    Top = 56
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
    OnClick = CancelClick
  end
  object see: TCheckBox
    Left = 288
    Top = 96
    Width = 73
    Height = 17
    Caption = #1055#1088#1086#1089#1084#1086#1090#1088
    Checked = True
    State = cbChecked
    TabOrder = 4
    OnClick = seeClick
  end
  object TrackBar2: TChangedTrackBar
    Left = 8
    Top = 104
    Width = 233
    Height = 25
    Max = 100
    Min = -100
    TabOrder = 5
    TickMarks = tmTopLeft
    TickStyle = tsNone
    OnChange = TrackBar2Change
  end
  object Edit2: TEdit
    Left = 184
    Top = 72
    Width = 49
    Height = 22
    TabOrder = 6
    Text = '0'
    OnChange = Edit2Change
  end
end
