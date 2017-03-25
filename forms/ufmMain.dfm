object fmMain: TfmMain
  Left = 0
  Top = 0
  Caption = 'fmMain'
  ClientHeight = 393
  ClientWidth = 478
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object PanelMenu: TPanel
    Left = 298
    Top = 8
    Width = 180
    Height = 370
    BevelOuter = bvNone
    Caption = 'PanelMenu'
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    ShowCaption = False
    TabOrder = 0
    OnAlignPosition = PanelMenuAlignPosition
    object BtnHeader: TSpeedButton
      Left = 50
      Top = 6
      Width = 23
      Height = 22
      Hint = 'Header, Ctrl+Space'
      Align = alCustom
      GroupIndex = 1
      Down = True
      Flat = True
      Glyph.Data = {
        7E000000424D7E000000000000003E0000002800000010000000100000000100
        010000000000400000000000000000000000020000000000000000000000FFFF
        FF00FFFF0000FFFF0000C0030000DFFB0000DFFB0000DFFB0000DFFB0000DFFB
        0000DFFB0000DFFB0000C0030000C8030000C8030000C0030000FFFF0000FFFF
        0000}
      ParentShowHint = False
      ShowHint = True
      OnClick = BtnFrameClick
    end
    object BtnData: TSpeedButton
      Left = 78
      Top = 6
      Width = 23
      Height = 22
      Hint = 'Data, Ctrl+Space'
      Align = alCustom
      GroupIndex = 1
      Flat = True
      Glyph.Data = {
        7E000000424D7E000000000000003E0000002800000010000000100000000100
        010000000000400000000000000000000000020000000000000000000000FFFF
        FF00FFFF0000FFFF0000C0030000C0030000CDB30000CDB30000C0030000CDB3
        0000CDB30000C0030000C0030000DFFB0000DFFB0000C0030000FFFF0000FFFF
        0000}
      ParentShowHint = False
      ShowHint = True
      OnClick = BtnFrameClick
    end
    object BtnImage: TSpeedButton
      Left = 108
      Top = 6
      Width = 23
      Height = 22
      Hint = 'Image, Ctrl+Space'
      Align = alCustom
      GroupIndex = 1
      Flat = True
      Glyph.Data = {
        7E000000424D7E000000000000003E0000002800000010000000100000000100
        010000000000400000000000000000000000020000000000000000000000FFFF
        FF00FFFF0000FFFF0000C0030000C0030000C0030000C0030000C18B0000C3DB
        0000C7FB0000CFFB0000DFCB0000DFCB0000DFFB0000C0030000FFFF0000FFFF
        0000}
      ParentShowHint = False
      ShowHint = True
      OnClick = BtnFrameClick
    end
    object BtnScrollUp: TSpeedButton
      Left = 72
      Top = 34
      Width = 16
      Height = 16
      Align = alCustom
      Flat = True
      Glyph.Data = {
        5E000000424D5E000000000000003E0000002800000009000000080000000100
        010000000000200000000000000000000000020000000000000000000000FFFF
        FF00FF800000FF80000080800000C1800000E3800000F7800000FF800000FF80
        0000}
      OnMouseDown = BtnScrollMouseDown
      OnMouseUp = BtnScrollMouseUp
    end
    object BtnScrollDown: TSpeedButton
      Left = 92
      Top = 34
      Width = 16
      Height = 16
      Align = alCustom
      Flat = True
      Glyph.Data = {
        5E000000424D5E000000000000003E0000002800000009000000080000000100
        010000000000200000000000000000000000020000000000000000000000FFFF
        FF00FF800000FF800000F7800000E3800000C180000080800000FF800000FF80
        0000}
      OnMouseDown = BtnScrollMouseDown
      OnMouseUp = BtnScrollMouseUp
    end
    object LabelCopyright: TLabel
      AlignWithMargins = True
      Left = 0
      Top = 351
      Width = 58
      Height = 13
      Cursor = crHandPoint
      Hint = 'https://github.com/felleroff/lookfits'
      Margins.Left = 0
      Margins.Top = 6
      Margins.Right = 0
      Margins.Bottom = 6
      Align = alBottom
      Alignment = taCenter
      Caption = 'LookFits %s'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clHighlight
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = LabelCopyrightClick
      OnMouseEnter = LabelCopyrightMouseEnter
      OnMouseLeave = LabelCopyrightMouseLeave
    end
    object SitePanelMenu: TPanel
      Left = 0
      Top = 50
      Width = 180
      Height = 295
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      BevelOuter = bvNone
      Caption = 'SitePanelMenu'
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
    end
  end
  object SitePanelMain: TPanel
    Left = 8
    Top = 8
    Width = 245
    Height = 370
    BevelOuter = bvNone
    Caption = 'SitePanelMain'
    ParentBackground = False
    ShowCaption = False
    TabOrder = 1
  end
  object Split: TLofiSplitter
    Left = 275
    Top = 8
    Width = 3
    Height = 370
    OnCanLeft = SplitCanLeft
  end
  object TimerScroll: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerScrollTimer
    Left = 375
    Top = 66
  end
end
