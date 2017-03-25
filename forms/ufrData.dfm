inherited frData: TfrData
  Height = 700
  ExplicitHeight = 700
  inherited PanelMain: TPanel
    Height = 700
    ExplicitHeight = 700
    inherited PanelMainScrollHor: TLofiScrollBar
      Top = 683
      OnScroll = GridMainScroll
      ExplicitTop = 683
    end
    inherited PanelMainScrollVer: TLofiScrollBar
      Height = 683
      OnScroll = GridMainScroll
      ExplicitHeight = 683
    end
    inherited PanelMainSpace: TPanel
      Height = 683
      ExplicitHeight = 683
      object GridMain: TDrawGrid
        Left = 0
        Top = 0
        Width = 293
        Height = 683
        Align = alClient
        BorderStyle = bsNone
        DefaultDrawing = False
        DoubleBuffered = True
        DrawingStyle = gdsClassic
        GridLineWidth = 0
        Options = [goVertLine, goHorzLine, goRangeSelect, goFixedColClick, goFixedRowClick, goFixedHotTrack]
        ParentDoubleBuffered = False
        PopupMenu = PmMain
        ScrollBars = ssNone
        TabOrder = 0
        OnDrawCell = GridMainDrawCell
        OnTopLeftChanged = GridMainTopLeftChanged
      end
    end
  end
  inherited PanelMenu: TLofiGroup
    Height = 700
    ExplicitHeight = 700
    inherited giInfo: TLofiGroupItem
      Height = 189
      OnChangeHeightState = giChangeHeightState
      ExplicitHeight = 189
      inherited giInfoMemo: TMemo
        Height = 158
        Lines.Strings = (
          '{0}'#39'BitPix: %s'#39','
          '{1}'#39'NAxis1: %d'#39','
          '{2}'#39'NAxis2: %d'#39','
          '{3}'#39'BScale: %s'#39','
          '{4}'#39'BZero: %s'#39','
          '{5}'#39'File size (byte): %d'#39','
          '{6}'#39'Data offset: %d'#39','
          '{7}'#39'Data size in real (byte): %d'#39','
          '{8}'#39'Data size in file (byte): %d'#39','
          '{9}'#39'Data Rep recom: %s'#39','
          '{10}'#39'ColsCount: %d'#39','
          '{11}'#39'RowsCount: %d'#39';')
        ExplicitHeight = 158
      end
    end
    object giFont: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 195
      Width = 200
      Height = 80
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 1
      OnAlignPosition = giFontAlignPosition
      Caption = 'Font'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giFontBtnMonospace: TSpeedButton
        Left = 27
        Top = 54
        Width = 70
        Height = 22
        Hint = 'Font: monospace, num/'
        Align = alCustom
        Caption = 'Monospace'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giFontBtnMonospaceClick
      end
      object giFontBtnDefault: TSpeedButton
        Left = 103
        Top = 54
        Width = 70
        Height = 22
        Hint = 'Font: default, num*'
        Align = alCustom
        Caption = 'Default'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giFontBtnDefaultClick
      end
      object giFontCmbName: TLofiComboBox
        Left = 6
        Top = 27
        Width = 112
        Height = 21
        Hint = 'Font: family'
        Align = alCustom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'giFontCmbName'
        OnChangeDone = giFontCmbNameChangeDone
      end
      object giFontCmbSize: TLofiComboBox
        Left = 124
        Top = 27
        Width = 70
        Height = 21
        Hint = 'Font: size, num+ or num-'
        Align = alCustom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'giFontCmbSize'
        OnChangeDone = giFontCmbSizeChangeDone
      end
    end
    object giFormat: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 281
      Width = 200
      Height = 80
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 2
      OnAlignPosition = giFormatAlignPosition
      Caption = 'Format'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giFormatBtnDefault: TSpeedButton
        Left = 65
        Top = 54
        Width = 70
        Height = 22
        Hint = 'Format: default (General), Ctrl+num*'
        Align = alCustom
        Caption = 'Default'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giFormatBtnDefaultClick
      end
      object giFormatCmbStyle: TLofiComboBox
        Left = 6
        Top = 27
        Width = 112
        Height = 21
        Hint = 'Format: style, F'
        Align = alCustom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'giFormatCmbStyle'
        Items.Strings = (
          'General'
          'Scientific'
          'Fixed')
        OnChangeDone = giFormatCmbStyleChangeDone
      end
      object giFormatCmbPrec: TLofiComboBox
        Left = 124
        Top = 27
        Width = 70
        Height = 21
        Hint = 'Format: precision, Ctrl+num+ or Ctrl+num-'
        Align = alCustom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'giFormatCmbPrec'
        OnChangeDone = giFormatCmbPrecChangeDone
      end
    end
    object giNavig: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 367
      Width = 200
      Height = 129
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 3
      OnAlignPosition = giNavigAlignPosition
      Caption = 'Navigation'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giNavigLabelX: TLabel
        Left = 18
        Top = 31
        Width = 6
        Height = 13
        Align = alCustom
        Caption = 'X'
      end
      object giNavigLabelY: TLabel
        Left = 176
        Top = 31
        Width = 6
        Height = 13
        Align = alCustom
        Caption = 'Y'
      end
      object giNavigLabelW: TLabel
        Left = 14
        Top = 58
        Width = 10
        Height = 13
        Align = alCustom
        Caption = 'W'
      end
      object giNavigLabelH: TLabel
        Left = 176
        Top = 58
        Width = 7
        Height = 13
        Align = alCustom
        Caption = 'H'
      end
      object giNavigBtnL: TSpeedButton
        Tag = 10
        Left = 67
        Top = 103
        Width = 22
        Height = 22
        Hint = 'Navigation: move the displayed region of data to the left, A'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FFBF0000FF3F0000FE070000FC070000F8070000F007
          0000F0070000F8070000FC070000FE070000FF3F0000FFBF0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giNavigBtnClick
      end
      object giNavigBtnT: TSpeedButton
        Tag = 20
        Left = 89
        Top = 81
        Width = 22
        Height = 22
        Hint = 'Navigation: move the displayed region of data upwards, W'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FFFF0000F00F0000F00F0000F00F0000C0030000E007
          0000F00F0000F81F0000FC3F0000FE7F0000FFFF0000FFFF0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giNavigBtnClick
      end
      object giNavigBtnB: TSpeedButton
        Tag = 40
        Left = 89
        Top = 103
        Width = 22
        Height = 22
        Hint = 'Navigation: move the displayed region of data downwards, S'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FFFF0000FFFF0000FE7F0000FC3F0000F81F0000F00F
          0000E0070000C0030000F00F0000F00F0000F00F0000FFFF0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giNavigBtnClick
      end
      object giNavigBtnR: TSpeedButton
        Tag = 30
        Left = 111
        Top = 103
        Width = 22
        Height = 22
        Hint = 'Navigation: move the displayed region of data to the right, D'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FDFF0000FCFF0000E07F0000E03F0000E01F0000E00F
          0000E00F0000E01F0000E03F0000E07F0000FCFF0000FDFF0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giNavigBtnClick
      end
      object giNavigEditX: TEdit
        Left = 27
        Top = 27
        Width = 70
        Height = 21
        Hint = 
          'Navigation: X coordinate (topleft.x) of the displayed data regio' +
          'n'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'giNavigEditX'
        OnKeyDown = giNavigEditKeyDown
      end
      object giNavigEditY: TEdit
        Left = 103
        Top = 27
        Width = 70
        Height = 21
        Hint = 
          'Navigation: Y coordinate (topleft.y) of the displayed data regio' +
          'n'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'giNavigEditY'
        OnKeyDown = giNavigEditKeyDown
      end
      object giNavigEditW: TEdit
        Left = 27
        Top = 54
        Width = 70
        Height = 21
        Hint = 'Navigation: Width (number columns) of the displayed data region'
        Align = alCustom
        Alignment = taCenter
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = 'giNavigEditW'
      end
      object giNavigEditH: TEdit
        Left = 103
        Top = 54
        Width = 70
        Height = 21
        Hint = 'Navigation: Height (number rows) of the displayed data region'
        Align = alCustom
        Alignment = taCenter
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Text = 'giNavigEditH'
      end
    end
    object giConvert: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 502
      Width = 200
      Height = 134
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 4
      OnAlignPosition = giConvertAlignPosition
      Caption = 'Convert'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giConvertLabelRgn: TLabel
        Left = 6
        Top = 31
        Width = 19
        Height = 13
        Align = alCustom
        Caption = 'Rgn'
      end
      object giConvertLabelRep: TLabel
        Left = 6
        Top = 58
        Width = 19
        Height = 13
        Align = alCustom
        Caption = 'Rep'
      end
      object giConvertLabelOut: TLabel
        Left = 7
        Top = 85
        Width = 18
        Height = 13
        Align = alCustom
        Caption = 'Out'
      end
      object giConvertBtnStart: TSpeedButton
        Left = 65
        Top = 108
        Width = 70
        Height = 22
        Align = alCustom
        Caption = 'Start'
        Flat = True
        OnClick = giConvertBtnStartClick
      end
      object giConvertCmbRgn: TComboBox
        Left = 31
        Top = 27
        Width = 163
        Height = 21
        Hint = 'Convert: region data, in format (X; Y; Width; Height)'
        Align = alCustom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'giConvertCmbRgn'
        Items.Strings = (
          '0; 0; 0; 0'
          '0; 0; 0; 0')
      end
      object giConvertCmbRep: TComboBox
        Left = 31
        Top = 54
        Width = 163
        Height = 21
        Hint = 'Convert: data representation in output'
        Align = alCustom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'giConvertCmbRep'
      end
      object giConvertEditOut: TButtonedEdit
        Left = 31
        Top = 81
        Width = 163
        Height = 21
        Hint = 'Convert: output file name'
        Align = alCustom
        Ctl3D = True
        Images = giConvertImgList
        ParentCtl3D = False
        ParentShowHint = False
        RightButton.DisabledImageIndex = 2
        RightButton.Hint = 'select output file name...'
        RightButton.HotImageIndex = 1
        RightButton.ImageIndex = 0
        RightButton.Visible = True
        ShowHint = True
        TabOrder = 2
        Text = 'giConvertEditOut'
        OnRightButtonClick = giConvertEditOutRightButtonClick
      end
    end
  end
  inherited PmMain: TPopupMenu
    object giCopyMiOpt: TMenuItem [0]
      Caption = 'Copy selected, Ctrl+C'
      OnClick = giCopyMiOptClick
    end
  end
  object giConvertImgList: TImageList
    Left = 80
    Top = 16
    Bitmap = {
      494C010103002400640010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C3C3C3000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F00000000007F7F7F007F7F7F00000000007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C3C3C3000000000000000000000000000000000000000000000000000000
      00007F7F7F007F7F7F00000000007F7F7F007F7F7F00000000007F7F7F007F7F
      7F00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C3C3C300C3C3C30000000000C3C3C300C3C3C30000000000C3C3C300C3C3
      C300C3C3C3000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      F24FF247F24F0000F24FF247F24F0000FFFFF247FFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF000000000000000000000000000000000000
      000000000000}
  end
end
