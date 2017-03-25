object frBase: TfrBase
  Left = 0
  Top = 0
  Width = 522
  Height = 400
  TabOrder = 0
  object PanelMain: TPanel
    Left = 0
    Top = 0
    Width = 310
    Height = 400
    Align = alClient
    BevelOuter = bvNone
    Caption = 'PanelMain'
    ShowCaption = False
    TabOrder = 0
    OnAlignPosition = PanelMainAlignPosition
    object PanelMainScrollHor: TLofiScrollBar
      Left = 0
      Top = 383
      Width = 293
      Height = 17
      Align = alCustom
      Ctl3D = False
      PageSize = 0
      ParentCtl3D = False
      TabOrder = 0
    end
    object PanelMainScrollVer: TLofiScrollBar
      Left = 293
      Top = 0
      Width = 17
      Height = 383
      Align = alCustom
      Ctl3D = False
      Kind = sbVertical
      PageSize = 0
      ParentCtl3D = False
      TabOrder = 1
    end
    object PanelMainSpace: TPanel
      Left = 0
      Top = 0
      Width = 293
      Height = 383
      Align = alCustom
      BevelOuter = bvNone
      Caption = 'PanelMainSpace'
      ShowCaption = False
      TabOrder = 2
      OnResize = PanelMainSpaceResize
    end
  end
  object PanelMenu: TLofiGroup
    Left = 310
    Top = 0
    Width = 212
    Height = 400
    Align = alRight
    TabOrder = 1
    AnchorTop = 0
    object giInfo: TLofiGroupItem
      AlignWithMargins = True
      Left = 6
      Top = 0
      Width = 200
      Height = 112
      Margins.Left = 6
      Margins.Top = 0
      Margins.Right = 6
      Margins.Bottom = 6
      Align = alTop
      TabOrder = 0
      Caption = 'Info'
      HeightState = hsMaxi
      DesignSize = (
        200
        112)
      object giInfoMemo: TMemo
        Left = 6
        Top = 27
        Width = 188
        Height = 81
        Anchors = [akLeft, akTop, akRight]
        BorderStyle = bsNone
        Lines.Strings = (
          '{0}'#39'BitPix: %s'#39','
          '{1}'#39'NAxis1: %d'#39','
          '{2}'#39'NAxis2: %d'#39','
          '{3}'#39'BScale: %s'#39','
          '{4}'#39'BZero: %s'#39','
          '{5}'#39'File size (byte): %d'#39';')
        ReadOnly = True
        TabOrder = 0
        WordWrap = False
      end
    end
  end
  object PmMain: TPopupMenu
    AutoHotkeys = maManual
    OnPopup = PmMainPopup
    Left = 16
    Top = 16
    object miDivMenu: TMenuItem
      Caption = '-'
    end
    object miMenu: TMenuItem
      Caption = 'Show Menu, Ctrl+M'
      OnClick = miMenuClick
    end
  end
end
