inherited frImage: TfrImage
  Height = 700
  ExplicitHeight = 700
  inherited PanelMain: TPanel
    Height = 700
    ExplicitHeight = 700
    inherited PanelMainScrollHor: TLofiScrollBar
      Top = 683
      OnScroll = ImgScnScroll
      ExplicitTop = 683
    end
    inherited PanelMainScrollVer: TLofiScrollBar
      Height = 683
      OnScroll = ImgScnScroll
      ExplicitHeight = 683
    end
    inherited PanelMainSpace: TPanel
      Height = 683
      ExplicitHeight = 683
      object ImgScn: TImage
        Left = 0
        Top = 32
        Width = 293
        Height = 651
        Align = alClient
        PopupMenu = PmMain
        OnMouseDown = ImgScnMouseDown
        OnMouseMove = ImgScnMouseMove
        OnMouseUp = ImgScnMouseUp
        ExplicitLeft = 56
        ExplicitTop = 112
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
      object ImgScnMov: TImage
        Left = 16
        Top = 74
        Width = 100
        Height = 100
        Visible = False
      end
      object ImgScnSel: TShape
        Left = 122
        Top = 74
        Width = 100
        Height = 100
        Pen.Mode = pmNot
        Visible = False
        OnMouseDown = ImgScnSelMouseDown
        OnMouseMove = ImgScnSelMouseMove
      end
      object ImgScnSelHint: TLabel
        Left = 122
        Top = 176
        Width = 68
        Height = 13
        Caption = 'ImgScnSelHint'
        Color = clInfoBk
        ParentColor = False
        Transparent = False
        Visible = False
        OnMouseDown = ImgScnSelMouseDown
        OnMouseMove = ImgScnSelMouseMove
      end
      object GridHead: TDrawGrid
        Left = 0
        Top = 0
        Width = 293
        Height = 32
        Align = alTop
        BorderStyle = bsNone
        ColCount = 3
        Ctl3D = True
        DefaultDrawing = False
        DoubleBuffered = True
        DrawingStyle = gdsClassic
        RowCount = 2
        GridLineWidth = 0
        Options = [goFixedColClick, goFixedRowClick, goFixedHotTrack]
        ParentCtl3D = False
        ParentDoubleBuffered = False
        ScrollBars = ssNone
        TabOrder = 0
        OnDrawCell = GridHeadDrawCell
        OnMouseWheelDown = GridHeadMouseWheelDown
        OnMouseWheelUp = GridHeadMouseWheelUp
      end
    end
  end
  inherited PanelMenu: TLofiGroup
    Height = 700
    ExplicitHeight = 700
    inherited giInfo: TLofiGroupItem
      Height = 229
      OnChangeHeightState = giChangeHeightState
      ExplicitHeight = 229
      inherited giInfoMemo: TMemo
        Height = 198
        Lines.Strings = (
          '{0}'#39'BitPix: %s'#39','
          '{1}'#39'NAxis1: %d'#39','
          '{2}'#39'NAxis2: %d'#39','
          '{3}'#39'BScale: %s'#39','
          '{4}'#39'BZero: %s'#39','
          '{5}'#39'File size (byte): %d'#39','
          '{6}'#39'Histogram items count: %d'#39','
          '{7}'#39'Histogram points count:%d'#39','
          '{8}'#39'Value min: %g'#39','
          '{9}'#39'Value max: %g'#39','
          '{10}'#39'Value mean: %g'#39','
          '{11}'#39'Width frame: %d'#39','
          '{12}'#39'Height frame: %d'#39','
          '{13}'#39'Width scene: %d'#39','
          '{14}'#39'Height scene: %d'#39';')
        ExplicitHeight = 198
      end
    end
    object giGline: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 235
      Width = 200
      Height = 81
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 1
      OnAlignPosition = giGlineAlignPosition
      Caption = 'Grid line'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giGlineBtnMesh: TSpeedButton
        Tag = 10
        Left = 31
        Top = 27
        Width = 23
        Height = 22
        Hint = 'Grid line: mesh, G'
        Align = alCustom
        AllowAllUp = True
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000EEEF0000EEEF0000C0030000EEEF0000EEEF0000EEEF
          0000C0030000EEEF0000EEEF0000EEEF0000C0030000EEEF0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giGlineBtnKindClick
      end
      object giGlineBtnAxis: TSpeedButton
        Tag = 20
        Left = 56
        Top = 27
        Width = 23
        Height = 22
        Hint = 'Grid line: axes, G'
        Align = alCustom
        AllowAllUp = True
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FE7F0000FC3F0000FE7F0000FE7F0000FE770000C003
          0000C0030000FE770000FE7F0000FE7F0000FE7F0000FE7F0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giGlineBtnKindClick
      end
      object giGlineBtnScen: TSpeedButton
        Tag = 30
        Left = 81
        Top = 27
        Width = 23
        Height = 22
        Hint = 'Grid lines: scene, G'
        Align = alCustom
        AllowAllUp = True
        GroupIndex = 1
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000F7EF0000F7EF0000C1830000F7EF0000F7EF0000FFFF
          0000FFFF0000F7EF0000F7EF0000C1830000F7EF0000F7EF0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giGlineBtnKindClick
      end
      object giGlineBtnMarks: TSpeedButton
        Left = 120
        Top = 27
        Width = 23
        Height = 22
        Hint = 'Grid line: marks (X, Y) in the grid nodes, M'
        Align = alCustom
        AllowAllUp = True
        GroupIndex = 2
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000FFFF0000FFFF0000F00F0000F7EF0000F42F0000F42F
          0000F42F0000F42F0000F7EF0000F00F0000FFFF0000FFFF0000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giGlineBtnMarksClick
      end
      object giGlineBtnColor: TSpeedButton
        Left = 145
        Top = 27
        Width = 23
        Height = 22
        Hint = 'Grid line: select color...'
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
          FFFFFFFFFFFF000000000000000000000000000000000000000000000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000FF0000FF00
          00FF0000FF0000FF0000FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF0000000000FF0000FF0000FF0000FF0000FF0000FF000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000FF0000FF00
          00FF0000FF0000FF0000FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF0000000000FF0000FF0000FF0000FF0000FF0000FF000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000000000FF0000FF00
          00FF0000FF0000FF0000FF000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFF0000000000FF0000FF0000FF0000FF0000FF0000FF000000FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000
          0000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = giGlineBtnColorClick
      end
      object giGlineBtnDefault: TSpeedButton
        Left = 65
        Top = 55
        Width = 70
        Height = 22
        Hint = 'Grid line: default'
        Align = alCustom
        Caption = 'Default'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giGlineBtnDefaultClick
      end
    end
    object giNavig: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 322
      Width = 200
      Height = 322
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 2
      OnAlignPosition = giNavigAlignPosition
      Caption = 'Navigation'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giNavigScnLabelX: TLabel
        Left = 18
        Top = 58
        Width = 6
        Height = 13
        Align = alCustom
        Caption = 'X'
      end
      object giNavigScnLabelY: TLabel
        Left = 176
        Top = 58
        Width = 6
        Height = 13
        Align = alCustom
        Caption = 'Y'
      end
      object giNavigScnLabelW: TLabel
        Left = 14
        Top = 85
        Width = 10
        Height = 13
        Align = alCustom
        Caption = 'W'
      end
      object giNavigScnLabelH: TLabel
        Left = 176
        Top = 85
        Width = 7
        Height = 13
        Align = alCustom
        Caption = 'H'
      end
      object giNavigScnBtnL: TSpeedButton
        Tag = 10
        Left = 67
        Top = 296
        Width = 22
        Height = 22
        Hint = 
          'Navigation: move the displayed scene-region of image to the left' +
          ', A'
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
        OnClick = giNavigScnBtnClick
      end
      object giNavigScnBtnT: TSpeedButton
        Tag = 20
        Left = 89
        Top = 274
        Width = 22
        Height = 22
        Hint = 'Navigation: move the displayed scene-region of image upwards, W'
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
        OnClick = giNavigScnBtnClick
      end
      object giNavigScnBtnB: TSpeedButton
        Tag = 40
        Left = 89
        Top = 296
        Width = 22
        Height = 22
        Hint = 
          'Navigation: move the displayed scene-region of image downwards, ' +
          'S'
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
        OnClick = giNavigScnBtnClick
      end
      object giNavigScnBtnR: TSpeedButton
        Tag = 30
        Left = 111
        Top = 296
        Width = 22
        Height = 22
        Hint = 
          'Navigation: move the displayed scene-region of image to the righ' +
          't, D'
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
        OnClick = giNavigScnBtnClick
      end
      object giNavigFrmLabelX: TLabel
        Left = 7
        Top = 33
        Width = 17
        Height = 13
        Align = alCustom
        Caption = 'Xoc'
      end
      object giNavigFrmLabelY: TLabel
        Left = 176
        Top = 33
        Width = 17
        Height = 13
        Align = alCustom
        Caption = 'Yoc'
      end
      object giNavigImg: TImage
        Left = 20
        Top = 108
        Width = 160
        Height = 160
        Align = alCustom
        OnClick = giNavigImgClick
      end
      object giNavigScnEditX: TEdit
        Left = 27
        Top = 54
        Width = 70
        Height = 21
        Hint = 
          'Navigation: X coordinate (topleft.x) of the displayed image scen' +
          'e-region'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'giNavigScnEditX'
        OnKeyDown = giNavigScnEditKeyDown
      end
      object giNavigScnEditY: TEdit
        Left = 103
        Top = 54
        Width = 70
        Height = 21
        Hint = 
          'Navigation: Y coordinate (topleft.y) of the displayed image scen' +
          'e-region'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'giNavigScnEditY'
        OnKeyDown = giNavigScnEditKeyDown
      end
      object giNavigScnEditW: TEdit
        Left = 27
        Top = 81
        Width = 70
        Height = 21
        Hint = 'Navigation: Width of the displayed image scene-region'
        Align = alCustom
        Alignment = taCenter
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = 'giNavigScnEditW'
      end
      object giNavigScnEditH: TEdit
        Left = 103
        Top = 81
        Width = 70
        Height = 21
        Hint = 'Navigation: Height of the displayed image scene-region'
        Align = alCustom
        Alignment = taCenter
        Enabled = False
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Text = 'giNavigScnEditH'
      end
      object giNavigFrmEditX: TEdit
        Left = 27
        Top = 29
        Width = 70
        Height = 21
        Hint = 
          'Navigation: X coordinate (center.x) of the displayed origin-imag' +
          'e region'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Text = 'giNavigFrmEditX'
        OnKeyDown = giNavigFrmEditKeyDown
      end
      object giNavigFrmEditY: TEdit
        Left = 103
        Top = 29
        Width = 70
        Height = 21
        Hint = 
          'Navigation: Y coordinate (center.y) of the displayed origin-imag' +
          'e region'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        Text = 'giNavigFrmEditY'
        OnKeyDown = giNavigFrmEditKeyDown
      end
    end
    object giGeom: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 650
      Width = 200
      Height = 135
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 3
      OnAlignPosition = giGeomAlignPosition
      Caption = 'Geometry'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giGemBtnSclDec: TSpeedButton
        Tag = -1
        Left = 24
        Top = 27
        Width = 23
        Height = 21
        Align = alCustom
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFC5C5C56565652222220202020101011E1E1E5F5F5FBEBEBEFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F568686801010100000000000000
          00000000000000000000000000005E5E5EF0F0F0FFFFFFFFFFFFFFFFFFF5F5F5
          4747470000000000000000000000000000000000000000000000000000000000
          003C3C3CF0F0F0FFFFFFFFFFFF6C6C6C00000000000000000000000000000012
          12121313130000000000000000000000000000005D5D5DFFFFFFCECECE020202
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000C1C1C16E6E6E00000000000000000000000000000000000000
          00000000000000000000000000000000000000000000005D5D5D292929000000
          0000000000000000000000000000000000000000000000000000000000000000
          000000000000001B1B1B0404040000000000000C0C0CC3C3C3D9D9D9D9D9D9F7
          F7F7F9F9F9D9D9D9D9D9D9CCCCCC141414000000000000000000050505000000
          0000000B0B0BB6B6B6CBCBCBCBCBCBF4F4F4F7F7F7CBCBCBCBCBCBBFBFBF1212
          120000000000000000002D2D2D00000000000000000000000000000000000000
          00000000000000000000000000000000000000000000001E1E1E737373000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000636363D3D3D305050500000000000000000000000000000000
          0000000000000000000000000000000000000000000000C7C7C7FFFFFF767676
          0000000000000000000000000000000B0B0B0C0C0C0000000000000000000000
          00000000676767FFFFFFFFFFFFFAFAFA52525200000000000000000000000000
          0000000000000000000000000000000000474747F5F5F5FFFFFFFFFFFFFFFFFF
          FAFAFA7676760808080000000000000000000000000000000000000404046C6C
          6CF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD1D1D17474742F2F2F07
          07070606062C2C2C6F6F6FCBCBCBFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = giGeomBtnSclClick
      end
      object giGemBtnSclInc: TSpeedButton
        Tag = 1
        Left = 153
        Top = 27
        Width = 23
        Height = 21
        Align = alCustom
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFC5C5C56565652222220202020101011E1E1E5F5F5FBEBEBEFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5F5F568686801010100000000000000
          00000000000000000000000000005E5E5EF0F0F0FFFFFFFFFFFFFFFFFFF5F5F5
          4747470000000000000000000000000000000000000000000000000000000000
          003C3C3CF0F0F0FFFFFFFFFFFF6C6C6C00000000000000000000000000000012
          12121313130000000000000000000000000000005D5D5DFFFFFFCECECE020202
          000000000000000000000000000000BFBFBFCCCCCC0000000000000000000000
          00000000000000C1C1C16E6E6E000000000000000000000000000000000000CE
          CECEDCDCDC0000000000000000000000000000000000005D5D5D292929000000
          000000000000000000000000000000CBCBCBD9D9D90000000000000000000000
          000000000000001B1B1B0404040000000000000C0C0CC3C3C3D9D9D9D9D9D9F7
          F7F7F9F9F9D9D9D9D9D9D9CCCCCC141414000000000000000000050505000000
          0000000B0B0BB6B6B6CBCBCBCBCBCBF4F4F4F7F7F7CBCBCBCBCBCBBFBFBF1212
          120000000000000000002D2D2D000000000000000000000000000000000000CA
          CACAD8D8D80000000000000000000000000000000000001E1E1E737373000000
          000000000000000000000000000000D0D0D0DEDEDE0000000000000000000000
          00000000000000636363D3D3D3050505000000000000000000000000000000B7
          B7B7C3C3C3000000000000000000000000000000000000C7C7C7FFFFFF767676
          0000000000000000000000000000000B0B0B0C0C0C0000000000000000000000
          00000000676767FFFFFFFFFFFFFAFAFA52525200000000000000000000000000
          0000000000000000000000000000000000474747F5F5F5FFFFFFFFFFFFFFFFFF
          FAFAFA7676760808080000000000000000000000000000000000000404046C6C
          6CF6F6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD1D1D17474742F2F2F07
          07070606062C2C2C6F6F6FCBCBCBFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = giGeomBtnSclClick
      end
      object giGemBtnRotDec: TSpeedButton
        Tag = -1
        Left = 24
        Top = 54
        Width = 23
        Height = 21
        Align = alCustom
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEEEEEEA4A4A4FCFCFCFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFA6A6A6252525010101E5E5E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFF0F0F0F6F6F6FFFFFFFFFFFFC9C9C9484848000000000000000000AFAFAFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFE9E9E93333335D5D5DFFFFFF8B8B8B000000
          0000000000000000000000006E6E6EFFFFFFFFFFFFFFFFFFFFFFFFFBFBFB4545
          45000000000000C0C0C0E3E3E3A0A0A01F1F1F000000000000000000313131FD
          FDFDFFFFFFFFFFFFFFFFFFFEFEFE898989000000000000585858FFFFFFFFFFFF
          3333330000000B0B0B181818000000D8D8D8FFFFFFFFFFFFFFFFFFFFFFFFF1F1
          F1171717000000181818FFFFFFF2F2F21B1B1B000000323232EBEBEB979797C8
          C8C8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF363636000000000000FFFFFFF9F9F9
          2424240000001E1E1EFCFCFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFA
          FA2323230000000D0D0DFFFFFFFFFFFF4E4E4E000000010101B0B0B0FFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFB8B8B8010101000000434343FFFFFFFFFFFF
          A8A8A8000000000000212121D8D8D8FFFFFFFFFFFFFFFFFFFFFFFFDCDCDC2626
          26000000000000A1A1A1FFFFFFFFFFFFFBFBFB40404000000000000016161681
          8181BFBFBFC0C0C0848484191919000000000000383838F9F9F9FFFFFFFFFFFF
          FFFFFFE1E1E12B2B2B0000000000000000000000000000000000000000000000
          00262626DCDCDCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE8E8E85E5E5E06060600
          0000000000000000000000050505595959E4E4E4FFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFD3D3D38F8F8F6969696868688D8D8DD0D0D0FFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = giGeomBtnRotClick
      end
      object giGemBtnRotInc: TSpeedButton
        Tag = 1
        Left = 153
        Top = 54
        Width = 23
        Height = 21
        Align = alCustom
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFCFCFCA4A4A4EEEEEEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6F6
          F0F0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE5E5E5010101252525A6A6
          A6FFFFFFFFFFFFFFFFFFFFFFFF5D5D5D333333E9E9E9FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFAFAFAF000000000000000000484848C9C9C9FFFFFFC0C0C0000000
          000000454545FBFBFBFFFFFFFFFFFFFFFFFFFFFFFF6E6E6E0000000000000000
          000000000000008B8B8B585858000000000000898989FEFEFEFFFFFFFFFFFFFF
          FFFFFDFDFD3131310000000000000000001F1F1FA0A0A0E3E3E3181818000000
          171717F1F1F1FFFFFFFFFFFFFFFFFFFFFFFFD8D8D80000001818180B0B0B0000
          00333333FFFFFFFFFFFF000000000000363636FFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFC8C8C8979797EBEBEB3232320000001B1B1BF2F2F2FFFFFF0D0D0D000000
          232323FAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFC1E1E1E0000
          00242424F9F9F9FFFFFF434343000000010101B8B8B8FFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFB0B0B00101010000004E4E4EFFFFFFFFFFFFA1A1A1000000
          000000262626DCDCDCFFFFFFFFFFFFFFFFFFFFFFFFD8D8D82121210000000000
          00A8A8A8FFFFFFFFFFFFF9F9F9383838000000000000191919848484C0C0C0BF
          BFBF818181161616000000000000404040FBFBFBFFFFFFFFFFFFFFFFFFDCDCDC
          2626260000000000000000000000000000000000000000000000002B2B2BE1E1
          E1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE4E4E459595905050500000000000000
          00000000000606065E5E5EE8E8E8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFD0D0D08D8D8D6868686969698F8F8FD3D3D3FFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        OnClick = giGeomBtnRotClick
      end
      object giGemBtnFlipLR: TSpeedButton
        Tag = 10
        Left = 74
        Top = 81
        Width = 23
        Height = 22
        Hint = 'Geometry: flip left to right'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF807F80807F80807F80807F80807F80807F80757475EA
          EAEAEAEAEA6160616160616160616160616160616160617D7C7DA09E9FBFBEBF
          FFFFFFFFFFFFFFFFFFFFFFFFA09E9FDFDEDEDFDEDE0401030401030401030401
          030401030401039C9A9BFFFFFF696869FAFAFAFFFFFFFFFFFFFFFFFFA09E9FDF
          DEDEDFDEDE0401030401030401030401030401032B282BFAFAFAFFFFFFB3B2B3
          A3A2A3FFFFFFFFFFFFFFFFFFA09E9FDFDEDEDFDEDE0401030401030401030401
          03040103ABAAABFFFFFFFFFFFFFFFFFF757475FAFAFAFFFFFFFFFFFFA09E9FDF
          DEDEDFDEDE0401030401030401030401033A383AFAFAFAFFFFFFFFFFFFFFFFFF
          BFBEBFAFAEAFFFFFFFFFFFFFA09E9FDFDEDEDFDEDE0401030401030401030401
          03B7B6B7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF797879EEEEEEFFFFFFA09E9FDF
          DEDEDFDEDE040103040103040103464445FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFD7D6D6908E8FFFFFFFA09E9FDFDEDEDFDEDE040103040103040103C7C6
          C7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF757475E2E2E2A09E9FDF
          DEDEDFDEDE040103040103616061FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFE2E2E2908E8FA09E9FDFDEDEDFDEDE0401030B080ADBDADAFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8C8A8B908E8FDF
          DEDEDFDEDE040103757475FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFEAEAEA2F2C2DDFDEDEDFDEDE0F0C0EE2E2E2FFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF848283DF
          DEDEDFDEDE807F80FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFF2F2F2EEEEEEEAEAEAEEEEEEFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = giGeomBtnFlipClick
      end
      object giGemBtnFlipTD: TSpeedButton
        Tag = 20
        Left = 103
        Top = 81
        Width = 23
        Height = 22
        Hint = 'Geometry: flip top to down'
        Align = alCustom
        Flat = True
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FFFFFF7C7B7C
          9B9A9AFAFAFAFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF605F60030002292729AAAAAAFAFAFAFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF605F60
          0300020300020300023A3738B6B6B6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF605F6003000203000203000203000203000245
          4344C6C6C6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF605F60
          030002030002030002030002030002030002030002605F60DADADAFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF605F6003000203000203000203000203000203
          0002030002030002090708747374E2E2E2FFFFFFFFFFFFFFFFFFFFFFFF605F60
          0300020300020300020300020300020300020300020300020300020300020D0B
          0C7F7E7FEEEEEEFFFFFFFFFFFFEAEAEADEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEEAEAEAFFFFFFFFFFFFEAEAEA
          DEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDEDE
          DEDEDEDEEEEEEEFFFFFFFFFFFF7473749F9E9E9F9E9E9F9E9E9F9E9E9F9E9E9F
          9E9E9F9E9E9F9E9E9F9E9E8F8E8E2D2B2B838282F2F2F2FFFFFFFFFFFF7F7E7F
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE2E2E28F8E8E8B8A8AEAEA
          EAFFFFFFFFFFFFFFFFFFFFFFFF7F7E7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEE
          EEEE8F8E8E747374E2E2E2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7E7F
          FFFFFFFFFFFFFFFFFFFAFAFAAEAEAE787778D6D6D6FFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF7F7E7FFFFFFFFAFAFAA2A2A2747374BEBEBEFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7E7F
          BEBEBE686768B2B2B2FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFF7F7E7F9F9E9EFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = giGeomBtnFlipClick
      end
      object giGemBtnDefault: TSpeedButton
        Left = 65
        Top = 109
        Width = 70
        Height = 22
        Hint = 'Geometry: default'
        Align = alCustom
        Caption = 'Default'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giGeomBtnDefaultClick
      end
      object giGemCmbScl: TLofiComboBox
        Left = 50
        Top = 27
        Width = 100
        Height = 21
        Hint = 
          'Geometry, scale: 5% .. 1000%##zoom in, num+ or mouse wheel up##z' +
          'oom out, num- or mouse wheel down##fit to window, F'
        Align = alCustom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'giGemCmbScl'
        Items.Strings = (
          '5%'
          '10%'
          '20%'
          '25%'
          '50%'
          '75%'
          '100%'
          '200%'
          '300%'
          '400%'
          '500%'
          '600%'
          '700%'
          '800%'
          '900%'
          '1000%'
          'Fit')
        OnChangeDone = giGemCmbSclChangeDone
      end
      object giGemCmbRot: TLofiComboBox
        Left = 50
        Top = 54
        Width = 100
        Height = 21
        Hint = 
          'Geometry, rotation: 0'#176' .. 360'#176'##clockwise rotation, Ctrl+(num+ o' +
          'r mouse wheel up)##counterclockwise rotation, Ctrl+(num- or mous' +
          'e wheel down)'
        Align = alCustom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Text = 'giGemCmbRot'
        Items.Strings = (
          '-270.0'#176
          '-90.0'#176
          '-45.0'#176
          '0.0'#176
          '+45.0'#176
          '+90.0'#176
          '+180.0'#176
          '+270.0'#176)
        OnChangeDone = giGemCmbRotChangeDone
      end
    end
    object giTone: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 791
      Width = 200
      Height = 146
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 4
      OnAlignPosition = giToneAlignPosition
      Caption = 'Tone'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      object giToneIconBrightness: TImage
        Left = 27
        Top = 27
        Width = 20
        Height = 25
        Hint = 'Tone: brightness'
        Align = alCustom
        Center = True
        ParentShowHint = False
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000100000
          00100804000000B5FA37EA0000000273424954080855EC460400000009704859
          73000004A8000004A8018AB23F090000001974455874536F6674776172650077
          77772E696E6B73636170652E6F72679BEE3C1A0000011F4944415478DA7D914D
          28845114869F8369223BB19485ACB0D624A1E46FCAC26E48C8CFD66E34295B0B
          4A6629351999B1A31465216C58280B2C4C4949898D05A314AFAF996FC67CDFC2
          5D9DFBDEE79EF39E734C941E6B22A48447F1019DF469DE07583561A5DD6B0D8D
          BAC845550C2B9907CAD8E44ACB9E7F95EC91D0B65BC2CA99D4BA0589D14D803B
          16F8A24DBB1E0F16E0901449E7A99D154694F199B4392A0A65AC992585DD9841
          6A39D5BDED33ABA7A28733BAE8A09E5723421D47BAB10326F45C044EE8618006
          5EFE4A44C92A5E1C575CBD7E0F418E596347B256369C6CD71EC0FAB9E48345A7
          83321E892963A3A4F45D9843847186F4E919559416C6F4930766D852362787B8
          D59B8B4C91D6BB7F59AB8E78FEDF36A79D961F4A955FCE3F69A8688D56530000
          000049454E44AE426082}
        ShowHint = True
      end
      object giToneIconContrast: TImage
        Left = 27
        Top = 58
        Width = 20
        Height = 25
        Hint = 'Tone: contrast'
        Align = alCustom
        Center = True
        ParentShowHint = False
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000100000
          001008060000001FF3FF61000000F44944415478DACDD2A18A84501406E0DF60
          B489C9220A5631D87C038B18F435B48941144C82168B6033D9B509C236834510
          BB987C89BB33C22E0B8BCCEC6CD8FDE30FF73B70EEA1F0CB50FF17589685ACEB
          0A4992A0280AF534707B448AA280AEEB98A609699A429665D4750D4DD3A88780
          E77924CBB2B3CFF39CB8AE7BF60CC3609E670882405D0249929020083EBBAFC0
          3DB66DA3699A6B200C431245D125C0F33CF67D7F1DE0380EC771BC0E188681B6
          6DAF816DDBDEAAAAD2E338FEB6449AA6318E235455BD06EEE9FB9EDCA6C0711C
          0CC300DFF7C1B22CCAB28465598FBFF1235DD79D87248A224CD37CFE907E9ABF
          07DE01D1586D11BC3A1F470000000049454E44AE426082}
        ShowHint = True
      end
      object giToneIconGamma: TImage
        Left = 27
        Top = 89
        Width = 20
        Height = 25
        Hint = 'Tone: gamma'
        Align = alCustom
        Center = True
        ParentShowHint = False
        Picture.Data = {
          0954506E67496D61676589504E470D0A1A0A0000000D49484452000000100000
          001008060000001FF3FF610000000473424954080808087C0864880000000970
          4859730000026B0000026B019A449E160000001974455874536F667477617265
          007777772E696E6B73636170652E6F72679BEE3C1A000001414944415478DAA5
          933F4842511487BDD06053108293538B2D0E093A3984D054D0568B938520822E
          8943909B6E35B9B5578353436B0411053525848A0E419082424BF487E777F006
          8FE7B56BF4E0E3DC7B7EE7FCB89C7B9F721CC767FB945269EA8E8D9AD7806245
          8893BF71E50AEC8F6632D00D79C219DA8BDEAFB0BEFF8BC11C21019710866568
          C123F55F56036D228D39B88228ECC113A4E8B99B30A06197D0830B98877D28A2
          7FCB0C581FEA9E378890EF4E9C804239AA0C71136A68C39F21BA0CE43B45DBFE
          6D0665F265F72D780C9ED143FF3178450F7A67E027AC4113B6A08AF63EC5E01C
          6DC36B90225CB36FB396E3EDB03E30187CFAC60FEDC1768D49C23A9CC02A54A0
          0F197AEAB68714202C41433F28B99DB63C2CEA07D68784811CBD82F6A1F731D6
          B7C6931A7EA605C222F98E2B57625F9DC960CA3CB2D4D54CDA088C9DB8E10E29
          FCBA0000000049454E44AE426082}
        ShowHint = True
      end
      object giToneLabelBrightness: TLabel
        Left = 153
        Top = 27
        Width = 31
        Height = 25
        Align = alCustom
        AutoSize = False
        Caption = '50%'
        Layout = tlCenter
      end
      object giToneLabelContrast: TLabel
        Left = 153
        Top = 58
        Width = 31
        Height = 25
        Align = alCustom
        AutoSize = False
        Caption = '33%'
        Layout = tlCenter
      end
      object giToneLabelGamma: TLabel
        Left = 153
        Top = 89
        Width = 31
        Height = 25
        Align = alCustom
        AutoSize = False
        Caption = '1.0'
        Layout = tlCenter
      end
      object giToneBtnDefault: TSpeedButton
        Left = 65
        Top = 120
        Width = 70
        Height = 22
        Hint = 'Tone: default'
        Align = alCustom
        Caption = 'Default'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giToneBtnDefaultClick
      end
      object giToneTrackBrightness: TLofiTrackBar
        Tag = 10
        Left = 50
        Top = 27
        Width = 100
        Height = 25
        Align = alCustom
        TabOrder = 0
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChangeDone = giToneTrackChangeDone
      end
      object giToneTrackContrast: TLofiTrackBar
        Tag = 20
        Left = 50
        Top = 58
        Width = 100
        Height = 25
        Align = alCustom
        TabOrder = 1
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChangeDone = giToneTrackChangeDone
      end
      object giToneTrackGamma: TLofiTrackBar
        Tag = 30
        Left = 50
        Top = 89
        Width = 100
        Height = 25
        Align = alCustom
        TabOrder = 2
        TickMarks = tmBoth
        TickStyle = tsNone
        OnChangeDone = giToneTrackChangeDone
      end
    end
    object giPal: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 943
      Width = 200
      Height = 128
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 5
      OnAlignPosition = giPalAlignPosition
      Caption = 'Palette'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      DesignSize = (
        200
        128)
      object giPalImg: TImage
        Left = 6
        Top = 27
        Width = 188
        Height = 41
        Anchors = [akLeft, akTop, akRight]
        Stretch = True
      end
      object giPalBtnOrder: TSpeedButton
        Left = 65
        Top = 74
        Width = 70
        Height = 22
        Hint = 'Palette: inverse'
        Align = alCustom
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Inverse'
        Flat = True
        Glyph.Data = {
          7E000000424D7E000000000000003E0000002800000010000000100000000100
          010000000000400000000000000000000000020000000000000000000000FFFF
          FF00FFFF0000FFFF0000C0030000C0030000D0030000D8E30000DC630000DE23
          0000DB030000D9830000D8C30000DFE30000DFF30000C0030000FFFF0000FFFF
          0000}
        ParentShowHint = False
        ShowHint = True
        OnClick = giPalBtnOrderClick
      end
      object giPalBtnDefault: TSpeedButton
        Left = 65
        Top = 102
        Width = 70
        Height = 22
        Hint = 'Palette: default'
        Align = alCustom
        Caption = 'Default'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giPalBtnDefaultClick
      end
      object giPalCmbValue: TLofiComboBox
        Left = 50
        Top = 37
        Width = 100
        Height = 21
        Hint = 'Palette: value'
        Align = alCustom
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Text = 'giPalCmbValue'
        OnChangeDone = giPalCmbValueChangeDone
      end
    end
    object giHim: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 1077
      Width = 200
      Height = 301
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 6
      OnAlignPosition = giHimAlignPosition
      Caption = 'Histogram'
      HeightState = hsMaxi
      OnChangeHeightState = giChangeHeightState
      DesignSize = (
        200
        301)
      object giHimBtnDec: TSpeedButton
        Tag = -3
        Left = 34
        Top = 247
        Width = 22
        Height = 22
        Align = alCustom
        Flat = True
        Glyph.Data = {
          5A000000424D5A000000000000003E000000280000000A000000070000000100
          0100000000001C0000000000000000000000020000000000000000000000FFFF
          FF00FFC00000E6400000CCC0000099C00000CCC00000E6400000FFC00000}
        OnClick = giHimBtnRangeClick
      end
      object giHimBtnDec1: TSpeedButton
        Tag = -1
        Left = 56
        Top = 247
        Width = 22
        Height = 22
        Align = alCustom
        Flat = True
        Glyph.Data = {
          5A000000424D5A000000000000003E0000002800000006000000070000000100
          0100000000001C0000000000000000000000020000000000000000000000FFFF
          FF00FC000000E4000000CC0000009C000000CC000000E4000000FC000000}
        OnClick = giHimBtnRangeClick
      end
      object giHimBtnInc1: TSpeedButton
        Tag = 1
        Left = 78
        Top = 247
        Width = 22
        Height = 22
        Align = alCustom
        Flat = True
        Glyph.Data = {
          5A000000424D5A000000000000003E0000002800000006000000070000000100
          0100000000001C0000000000000000000000020000000000000000000000FFFF
          FF00FC0000009C000000CC000000E4000000CC0000009C000000FC000000}
        OnClick = giHimBtnRangeClick
      end
      object giHimBtnDec2: TSpeedButton
        Tag = -2
        Left = 100
        Top = 247
        Width = 22
        Height = 22
        Align = alCustom
        Flat = True
        Glyph.Data = {
          5A000000424D5A000000000000003E0000002800000006000000070000000100
          0100000000001C0000000000000000000000020000000000000000000000FFFF
          FF00FC000000E4000000CC0000009C000000CC000000E4000000FC000000}
        OnClick = giHimBtnRangeClick
      end
      object giHimBtnInc2: TSpeedButton
        Tag = 2
        Left = 122
        Top = 247
        Width = 22
        Height = 22
        Align = alCustom
        Flat = True
        Glyph.Data = {
          5A000000424D5A000000000000003E0000002800000006000000070000000100
          0100000000001C0000000000000000000000020000000000000000000000FFFF
          FF00FC0000009C000000CC000000E4000000CC0000009C000000FC000000}
        OnClick = giHimBtnRangeClick
      end
      object giHimBtnInc: TSpeedButton
        Tag = 3
        Left = 144
        Top = 247
        Width = 22
        Height = 22
        Align = alCustom
        Flat = True
        Glyph.Data = {
          5A000000424D5A000000000000003E000000280000000A000000070000000100
          0100000000001C0000000000000000000000020000000000000000000000FFFF
          FF00FFC0000099C00000CCC00000E6400000CCC0000099C00000FFC00000}
        OnClick = giHimBtnRangeClick
      end
      object giHimBtnDefault: TSpeedButton
        Left = 65
        Top = 275
        Width = 70
        Height = 22
        Hint = 'Histogram: default'
        Align = alCustom
        Caption = 'Default'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = giHimBtnDefaultClick
      end
      object giHimChart: TChart
        Left = 6
        Top = 27
        Width = 188
        Height = 160
        AllowPanning = pmHorizontal
        BackWall.Visible = False
        ScrollMouseButton = mbLeft
        Title.Text.Strings = (
          'TChart')
        Title.Visible = False
        OnScroll = giHimChartScroll
        AxisVisible = False
        Panning.MouseWheel = pmwNone
        View3D = False
        Zoom.Allow = False
        Zoom.MouseButton = mbRight
        BevelOuter = bvNone
        Color = clWindow
        TabOrder = 0
        Anchors = [akLeft, akTop, akRight]
        OnMouseUp = giHimChartMouseUp
        DefaultCanvas = 'TGDIPlusCanvas'
        PrintMargins = (
          15
          8
          15
          8)
        ColorPaletteIndex = 13
        object giHimChartBarSeries: TBarSeries
          Legend.Visible = False
          BarPen.Visible = False
          Marks.Visible = False
          SeriesColor = clBlack
          ShowInLegend = False
          BarWidthPercent = 100
          SideMargins = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
      end
      object giHimEditVal1: TEdit
        Left = 27
        Top = 193
        Width = 70
        Height = 21
        Hint = 'Histogram: threshold-value of black'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 1
        Text = 'giHimEditVal1'
      end
      object giHimEditVal2: TEdit
        Left = 103
        Top = 193
        Width = 70
        Height = 21
        Hint = 'Histogram: threshold-value of white'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ReadOnly = True
        ShowHint = True
        TabOrder = 2
        Text = 'giHimEditVal2'
      end
      object giHimEditInd1: TEdit
        Left = 27
        Top = 220
        Width = 70
        Height = 21
        Hint = 'Histogram: threshold-index of black'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        Text = 'giHimEditInd1'
        OnKeyDown = giHimEditKeyDown
      end
      object giHimEditInd2: TEdit
        Left = 103
        Top = 220
        Width = 70
        Height = 21
        Hint = 'Histogram: threshold-index of white'
        Align = alCustom
        Alignment = taCenter
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Text = 'giHimEditInd2'
        OnKeyDown = giHimEditKeyDown
      end
    end
  end
  inherited PmMain: TPopupMenu
    object giCopyMiOpt: TMenuItem [0]
      Caption = 'Copy selected, Ctrl+C'
      OnClick = giCopyMiOptClick
    end
    object giSaveMiOpt: TMenuItem [1]
      Caption = 'Save selected..., Ctrl + S'
      OnClick = giSaveMiOptClick
    end
  end
end
