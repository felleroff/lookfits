inherited frHeader: TfrHeader
  Height = 600
  ExplicitHeight = 600
  inherited PanelMain: TPanel
    Height = 600
    ExplicitHeight = 600
    inherited PanelMainScrollHor: TLofiScrollBar
      Top = 583
      OnScroll = GridMainScroll
      ExplicitTop = 583
    end
    inherited PanelMainScrollVer: TLofiScrollBar
      Height = 583
      OnScroll = GridMainScroll
      ExplicitHeight = 583
    end
    inherited PanelMainSpace: TPanel
      Height = 583
      ExplicitHeight = 583
      object GridMain: TDrawGrid
        Left = 104
        Top = 0
        Width = 189
        Height = 583
        Anchors = [akLeft, akTop, akBottom]
        BorderStyle = bsNone
        DefaultDrawing = False
        DoubleBuffered = True
        DrawingStyle = gdsClassic
        FixedCols = 0
        GridLineWidth = 0
        Options = [goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedColClick, goFixedRowClick, goFixedHotTrack]
        ParentDoubleBuffered = False
        PopupMenu = PmMain
        ScrollBars = ssNone
        TabOrder = 0
        OnDrawCell = GridMainDrawCell
        OnTopLeftChanged = GridMainTopLeftChanged
      end
      object GridGutt: TDrawGrid
        Left = 0
        Top = 0
        Width = 75
        Height = 583
        Align = alLeft
        BorderStyle = bsNone
        ColCount = 1
        DefaultDrawing = False
        DoubleBuffered = True
        DrawingStyle = gdsClassic
        FixedCols = 0
        GridLineWidth = 0
        Options = [goFixedRowClick]
        ParentDoubleBuffered = False
        ScrollBars = ssNone
        TabOrder = 1
        OnDrawCell = GridGuttDrawCell
        OnMouseLeave = GridGuttMouseLeave
        OnMouseMove = GridGuttMouseMove
      end
    end
  end
  inherited PanelMenu: TLofiGroup
    Height = 600
    ExplicitHeight = 600
    inherited giInfo: TLofiGroupItem
      Height = 165
      OnChangeHeightState = giChangeHeightState
      ExplicitHeight = 165
      inherited giInfoMemo: TMemo
        Height = 134
        Lines.Strings = (
          '{0}'#39'BitPix: %s'#39','
          '{1}'#39'NAxis1: %d'#39','
          '{2}'#39'NAxis2: %d'#39','
          '{3}'#39'BScale: %s'#39','
          '{4}'#39'BZero: %s'#39','
          '{5}'#39'File size (byte): %d'#39','
          '{6}'#39'Header offset: %d'#39','
          '{7}'#39'Header size (byte): %d'#39','
          '{8}'#39'Line count: %d'#39','
          '{9}'#39'Line capacity: %d'#39';')
        ExplicitHeight = 134
      end
    end
    object giFont: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 171
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
    object giMode: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 257
      Width = 200
      Height = 53
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 2
      OnAlignPosition = giModeAlignPosition
      Caption = 'Mode view'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giModeBtnSim: TSpeedButton
        Left = 49
        Top = 27
        Width = 30
        Height = 22
        Hint = 'Mode: simple, M'
        Align = alCustom
        GroupIndex = 1
        Caption = 'Sim'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giModeBtnClick
      end
      object giModeBtnChr: TSpeedButton
        Tag = 1
        Left = 85
        Top = 27
        Width = 30
        Height = 22
        Hint = 'Mode: items as chars, M'
        Align = alCustom
        GroupIndex = 1
        Caption = 'Chr'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giModeBtnClick
      end
      object giModeBtnTxt: TSpeedButton
        Tag = 2
        Left = 121
        Top = 27
        Width = 30
        Height = 22
        Hint = 'Mode: items as text, M'
        Align = alCustom
        GroupIndex = 1
        Down = True
        Caption = 'Txt'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giModeBtnClick
      end
    end
    object giSearch: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 316
      Width = 200
      Height = 126
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 3
      OnAlignPosition = giSearchAlignPosition
      Caption = 'Search'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giSearchLabelOut: TLabel
        Left = 110
        Top = 31
        Width = 84
        Height = 13
        Align = alCustom
        Caption = 'giSearchLabelOut'
      end
      object giSearchBtnReset: TSpeedButton
        Left = 59
        Top = 100
        Width = 23
        Height = 22
        Hint = 'Search: reset'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FF
          FFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FF
          FFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = giSearchBtnResetClick
      end
      object giSearchBtnReverse: TSpeedButton
        Left = 88
        Top = 100
        Width = 23
        Height = 22
        Hint = 'Search: reverse'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FF
          FFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          0000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = giSearchBtnReverseClick
      end
      object giSearchBtnForward: TSpeedButton
        Left = 117
        Top = 100
        Width = 23
        Height = 22
        Hint = 'Search: forward, F'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000
          0000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFF000000000000FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000FFFFFFFF
          FFFFFFFFFFFFFFFF000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = giSearchBtnForwardClick
      end
      object giSearchEditValue: TEdit
        Left = 6
        Top = 27
        Width = 98
        Height = 21
        Align = alCustom
        TabOrder = 0
        Text = 'giSearchEditValue'
        OnChange = giSearchEditValueChange
        OnKeyDown = giSearchEditValueKeyDown
      end
      object giSearchChbMatchCase: TCheckBox
        Left = 62
        Top = 54
        Width = 75
        Height = 17
        Align = alCustom
        Caption = 'Match Case'
        TabOrder = 1
        OnClick = giSearchCmbClick
      end
      object giSearchChbKeywordOnly: TCheckBox
        Left = 57
        Top = 77
        Width = 85
        Height = 17
        Align = alCustom
        Caption = 'Keyword Only'
        TabOrder = 2
        OnClick = giSearchCmbClick
      end
    end
    object giCopy: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 448
      Width = 200
      Height = 53
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 4
      OnAlignPosition = giCopyAlignPosition
      Caption = 'Copy to clipboard'
      HeightState = hsMaxi
      object giCopyBtnOpt: TSpeedButton
        Tag = 10
        Left = 59
        Top = 27
        Width = 23
        Height = 22
        Hint = 'Copy selected, Ctrl+C'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FC030000FDFB0000C1FB0000DDFB0000DDFB0000DDFB0000DDFB
          0000DDFB0000DDF30000DDE30000DC030000DFBF0000C03F0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giCopyBtnClick
      end
      object giCopyBtnAll: TSpeedButton
        Tag = 20
        Left = 88
        Top = 27
        Width = 23
        Height = 22
        Hint = 'Copy all, Atl+C'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FE070000FEF70000F8F70000FAF70000E2F70000EAE7
          0000EA070000EBDF0000E81F0000EF7F0000E07F0000FFFF0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giCopyBtnClick
      end
      object giCopyBtnOne: TSpeedButton
        Tag = 30
        Left = 117
        Top = 27
        Width = 23
        Height = 22
        Hint = 'Copy all a one line, Shift+C'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FE070000FEF70000F8F70000FAF70000E2F70000EAE7
          0000EA070000EBDF0000E8170000EF770000E0770000FFE70000FFF70000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giCopyBtnClick
      end
    end
  end
  inherited PmMain: TPopupMenu
    object giCopyMiOpt: TMenuItem [0]
      Tag = 10
      Caption = 'giCopyMiOpt'
      OnClick = giCopyBtnClick
    end
    object giCopyMiAll: TMenuItem [1]
      Tag = 20
      Caption = 'giCopyMiAll'
      OnClick = giCopyBtnClick
    end
    object giCopyMiOne: TMenuItem [2]
      Tag = 30
      Caption = 'giCopyMiOne'
      OnClick = giCopyBtnClick
    end
    object giDivSearch: TMenuItem [3]
      Caption = '-'
    end
    object giSearchMiActivate: TMenuItem [4]
      Caption = 'Search, Ctrl+F'
      OnClick = giSearchMiActivateClick
    end
  end
end
