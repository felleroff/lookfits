object fmDemo: TfmDemo
  Left = 0
  Top = 0
  Caption = 'fmDemo'
  ClientHeight = 675
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 80
    Top = 312
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object ScrollBar1: TScrollBar
    Left = 0
    Top = 239
    Width = 521
    Height = 17
    Align = alCustom
    Ctl3D = False
    PageSize = 0
    ParentCtl3D = False
    TabOrder = 1
  end
  object ScrollBar2: TScrollBar
    Left = 550
    Top = 0
    Width = 17
    Height = 256
    Align = alCustom
    Ctl3D = False
    Kind = sbVertical
    PageSize = 0
    ParentCtl3D = False
    TabOrder = 2
  end
  object Button1: TButton
    Left = 688
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 3
    OnClick = Button1Click
  end
  object DrawGrid1: TDrawGrid
    Left = 0
    Top = 0
    Width = 529
    Height = 217
    Align = alCustom
    BorderStyle = bsNone
    Ctl3D = True
    DefaultDrawing = False
    DrawingStyle = gdsClassic
    GridLineWidth = 0
    Options = [goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedColClick, goFixedRowClick, goFixedHotTrack]
    ParentCtl3D = False
    ScrollBars = ssNone
    TabOrder = 0
    ColWidths = (
      64
      64
      64
      64
      64)
    RowHeights = (
      24
      24
      24
      24
      24)
  end
  object LofiScrollBar1: TLofiScrollBar
    Left = 22
    Top = 272
    Width = 499
    Height = 17
    LargeChange = 40
    PageSize = 50
    TabOrder = 4
  end
  object ComboBox1: TComboBox
    Left = 168
    Top = 309
    Width = 145
    Height = 22
    Style = csOwnerDrawVariable
    TabOrder = 5
    Items.Strings = (
      '111'
      '222'
      '333')
  end
  object Chart1: TChart
    Left = 64
    Top = 375
    Width = 441
    Height = 292
    AllowPanning = pmHorizontal
    ScrollMouseButton = mbLeft
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    AxisVisible = False
    BottomAxis.Increment = 1.000000000000000000
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Maximum = 735.000000000000000000
    Panning.MouseWheel = pmwNone
    View3D = False
    Zoom.Allow = False
    Zoom.MouseButton = mbRight
    TabOrder = 6
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TBarSeries
      Legend.Visible = False
      BarPen.Visible = False
      Marks.Visible = False
      ShowInLegend = False
      BarWidthPercent = 100
      SideMargins = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Bar'
      YValues.Order = loNone
    end
  end
  object LofiTrackBar1: TLofiTrackBar
    Left = 648
    Top = 192
    Width = 150
    Height = 45
    Max = 100
    TabOrder = 7
    OnChangeDone = LofiTrackBar1ChangeDone
  end
end
