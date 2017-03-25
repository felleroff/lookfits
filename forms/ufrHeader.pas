{ **************************************************** }
{  LookFits - Lister plugin (WLX) for view FITS files  }
{                                                      }
{   Frame of the render of header block of fits-file   }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit ufrHeader;

interface

uses
  Winapi.Windows, Winapi.Messages, System.UITypes, System.SysUtils,
  System.Classes, System.StrUtils, System.Math, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.Buttons, Vcl.Clipbrd, ufrBase, Lofi.ExtCtrls, uProfile, uUtils,
  DeLaFitsCommon, DeLaFitsString, DeLaFitsGraphics;

type

  TDebt = (deGridMain, deInfo, deFont, deMode, deSearch);
  TDebts = set of TDebt;

  { TCheckBox }

  TCheckBox = class(Vcl.StdCtrls.TCheckBox)
  protected
    procedure Loaded; override;
  end;

  { TDrawGrid }

  TOnColWidthsUserChanged = procedure (Sender: TObject; ACol: Integer) of object;

  TDrawGrid = class(Vcl.Grids.TDrawGrid)
  private
    FCol: Integer;
    FColMinWidth: Integer;
    FOnColWidthsUserChanged: TOnColWidthsUserChanged;
  protected
    procedure ColWidthsChanged; override;
    procedure CalcSizingState(X, Y: Integer; var State: TGridState; var Index: Longint; var SizingPos, SizingOfs: Integer; var FixedInfo: TGridDrawInfo); override;
  public
    constructor Create(AOwner: TComponent); override;
    property OnColWidthsUserChanged: TOnColWidthsUserChanged read FOnColWidthsUserChanged write FOnColWidthsUserChanged;
  end;

  { TfrHeader }

  TfrHeader = class(TfrBase)

  // Common
  published
    procedure giChangeHeightState(Sender: TLofiGroupItem);
  private
    FUpdates: TDebts;
    FRenders: TDebts;
    procedure BeginRender;
    procedure EndRender;
  protected
    procedure ChangeSize; override;
    procedure ChangeView; override;
  public
    constructor Create(AOwner: TComponent; TheDockSitePanelMain, TheDockSitePanelMenu: TWinControl; TheSubWin: ISubWin); reintroduce;
    destructor Destroy; override;
    procedure FrameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure ReadProfile; override;
    procedure WriteProfile; override;
    procedure SetFit(Fit: TFitsFileBitmap); override;
    procedure Render; override;

  // Lines
  private type
    TItem = record
      iText : string;
      iColor: TColor;
      iStyle: TFontStyles;
      iAlign: TTextFormat;
    end;
    TItems = array [0 .. 4] of TItem; // [0]Keyword, [1]ValueIndicator, [2]Value, [3]NoteIndicator, [4]Note
    TLines = array of TItems;
  private
    FLines: TLines;
    FLineCount: Integer;
    FLineCapacity: Integer;
    procedure MatchLines;

  // GridMain & GridGutt
  published
    GridMain: TDrawGrid;
    GridGutt: TDrawGrid;
    procedure GridMainDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure GridMainScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure GridMainTopLeftChanged(Sender: TObject);
    procedure GridMainColWidthsUserChanged(Sender: TObject; ACol: Integer);
    procedure GridGuttDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure GridGuttMouseLeave(Sender: TObject);
    procedure GridGuttMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private
    FGridGuttHotTrack: Integer; // Row of GridGutt under cursor mouse
    FGridMainUserTopLeftChanged: Boolean; // Flag for check owner-call a GridMainTopLeftChanged()
    procedure FixBoundsGridMain;
    procedure InitGridMain;
    procedure MatchGridMain;
    procedure RenderGridMain;

  // Info
  private
    procedure RenderInfo;

  // Font
  published
    giFont: TLofiGroupItem;
    giFontCmbName: TLofiComboBox;
    giFontCmbSize: TLofiComboBox;
    giFontBtnMonospace: TSpeedButton;
    giFontBtnDefault: TSpeedButton;
    procedure giFontAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giFontCmbNameChangeDone(Sender: TLofiComboBox; AText: string);
    procedure giFontCmbSizeChangeDone(Sender: TLofiComboBox; AText: string);
    procedure giFontBtnMonospaceClick(Sender: TObject);
    procedure giFontBtnDefaultClick(Sender: TObject);
  private const
    cFontName: StringFix = (Def: 'Tahoma'; DefView: 'Tahoma');
    cFontSize: IntegerFix = (Min: 8; Max: 20; Def: 8; DefView: '8');
  private
    FFontName: string;
    FFontSize: Integer;
    procedure InitFont;
    procedure UpdateFont(NewName: string; NewSize: Integer);
    procedure RenderFont;

  // Mode
  published
    giMode: TLofiGroupItem;
    giModeBtnSim: TSpeedButton;
    giModeBtnChr: TSpeedButton;
    giModeBtnTxt: TSpeedButton;
    procedure giModeAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giModeBtnClick(Sender: TObject);
  private type
    TMode = (mSimple, mItems, mItemsEx);
  private
    FMode: TMode;
    procedure UpdateMode(NewMode: TMode);
    procedure RenderMode;

  // Search
  published
    giSearch: TLofiGroupItem;
    giSearchEditValue: TEdit;
    giSearchLabelOut: TLabel;
    giSearchChbMatchCase: TCheckBox;
    giSearchChbKeywordOnly: TCheckBox;
    giSearchBtnReset: TSpeedButton;
    giSearchBtnReverse: TSpeedButton;
    giSearchBtnForward: TSpeedButton;
    giDivSearch: TMenuItem;
    giSearchMiActivate: TMenuItem;
    procedure giSearchAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giSearchMiActivateClick(Sender: TObject);
    procedure giSearchEditValueChange(Sender: TObject);
    procedure giSearchEditValueKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure giSearchCmbClick(Sender: TObject);
    procedure giSearchBtnResetClick(Sender: TObject);
    procedure giSearchBtnReverseClick(Sender: TObject);
    procedure giSearchBtnForwardClick(Sender: TObject);
  private type
    TSearchFlag = (sfMathCase, sfKeywordOnly);
    TSearchFlags = set of TSearchFlag;
    TSearchDir = (dReverse, dForward);
    TSearchItem = record
      iCol, iRow: Integer;
      iPos, iLen: Integer;
    end;
  private
    FSearchActive: Boolean;
    FSearchText: string;
    FSearchFlags: TSearchFlags;
    FSearchDir: TSearchDir;
    FSearchIndex: Integer;
    FSearchCount: Integer;
    FSearchItem: TSearchItem;
    procedure MatchSearch;
    procedure UpdateSearchActive(NewActive: Boolean);
    procedure UpdateSearchText(NewText: string; NewFlags: TSearchFlags); overload;
    procedure UpdateSearchText(NewText: string; NewDir: TSearchDir); overload;
    procedure RenderSearch;

  // Copy
  published
    giCopy: TLofiGroupItem;
    giCopyBtnOpt: TSpeedButton;
    giCopyBtnAll: TSpeedButton;
    giCopyBtnOne: TSpeedButton;
    giCopyMiOpt: TMenuItem;
    giCopyMiAll: TMenuItem;
    giCopyMiOne: TMenuItem;
    procedure giCopyAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giCopyBtnClick(Sender: TObject);
  private
    procedure InitCopy;
    function EmptyLineByMode: string;
    procedure CopyOpt;
    procedure CopyAll;
    procedure CopyOne;

  end;

implementation

{$R *.dfm}

function GetFullDebts: TDebts; inline;
begin
  Result := [Low(TDebt) .. High(TDebt)];
end;

function ToItem(const AText: string; AColor: TColor; AStyle: TFontStyles; AAlign: TTextFormat): TfrHeader.TItem; inline;
begin
  Result.iText  := AText;
  Result.iColor := AColor;
  Result.iStyle := AStyle;
  Result.iAlign := [tfNoPrefix, tfSingleLine, tfVerticalCenter] + AAlign;
end;

function SearchFlagsToInt(const V: TfrHeader.TSearchFlags): Integer; inline;
var
  I: TfrHeader.TSearchFlag;
  K: Integer;
begin
  Result := 0;
  K := 1;
  for I := Low(I) to High(I) do
  begin
    if I in V then
      Result := Result or K;
    K := K * 2;
  end;
end;

function IntToSearchFlags(const V: Integer): TfrHeader.TSearchFlags; inline;
var
  I: TfrHeader.TSearchFlag;
  K: Integer;
begin
  Result := [];
  K := 1;
  for I := Low(I) to High(I) do
  begin
    if (V and K) <> 0 then
      Include(Result, I);
    K := K * 2;
  end;
end;

{ TCheckBox }

procedure TCheckBox.Loaded;
begin
  inherited;
  Width := GetSystemMetrics(SM_CXMENUCHECK) + 4 + (Parent as TLofiGroupItem).Canvas.TextWidth(Caption);
end;

{ TDrawGrid }

procedure TDrawGrid.ColWidthsChanged;
begin
  inherited;
  if FCol >= 0 then
  begin
    if ColWidths[FCol] < FColMinWidth then
      ColWidths[FCol] := FColMinWidth;
    if Assigned(FOnColWidthsUserChanged) then
      FOnColWidthsUserChanged(Self, FCol);
  end;
  FCol := -1;
end;

procedure TDrawGrid.CalcSizingState(X, Y: Integer; var State: TGridState; var Index, SizingPos, SizingOfs: Integer; var FixedInfo: TGridDrawInfo);
begin
  inherited;
  FCol := -1;
  if State = gsColSizing then
    FCol := Index;
end;

constructor TDrawGrid.Create(AOwner: TComponent);
begin
  inherited;
  FCol := -1;
  FColMinWidth := cGridSpec.CellSizeMin.cx;
  FOnColWidthsUserChanged := nil;
end;

{ TfrHeader }

procedure TfrHeader.giChangeHeightState(Sender: TLofiGroupItem);
begin
  if not ViewMenu then
    Exit;
  if Sender.HeightState = hsMini then
    Exit;
  Render;
end;

procedure TfrHeader.BeginRender;
begin
  // http://stackoverflow.com/questions/3712229/delphi-tstringgrid-flicker
  GridMain.Perform(WM_SETREDRAW, 0, 0);
end;

procedure TfrHeader.EndRender;
begin
  GridMain.SetFocus;
  GridMain.Perform(WM_SETREDRAW, 1, 0);
  GridMain.Invalidate;
end;

procedure TfrHeader.ChangeSize;
begin
  if View then
    FixBoundsGridMain
  else
    Include(FRenders, deGridMain);
end;

procedure TfrHeader.ChangeView;
begin
  if View then
    FixBoundsGridMain;
end;

constructor TfrHeader.Create(AOwner: TComponent; TheDockSitePanelMain, TheDockSitePanelMenu: TWinControl; TheSubWin: ISubWin);
begin
  inherited Create(AOwner, TheDockSitePanelMain, TheDockSitePanelMenu, TheSubWin);
  FUpdates := GetFullDebts;
  FRenders := GetFullDebts;
  FLines := nil;
  FLineCount := 0;
  FLineCapacity := 0;
  FFontName := cFontName.Def;
  FFontSize := cFontSize.Def;
  FMode := mItemsEx;
  FSearchActive := False;
  FSearchText := '';
  FSearchFlags := [sfMathCase];
  FSearchDir := dForward;
  FSearchIndex := 0;
  FSearchCount := 0;
  with FSearchItem do
  begin
    iCol := -1;
    iRow := -1;
    iPos := 0;
    iLen := 0;
  end;
end;

destructor TfrHeader.Destroy;
begin
  FLines := nil;
  inherited;
end;

procedure TfrHeader.FrameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    // Font: monospace
    VK_DIVIDE:
      if Shift = [] then
      begin
        Key := 0;
        giFontBtnMonospace.Click;
      end;
    // Font: default
    VK_MULTIPLY:
      if Shift = [] then
      begin
        Key := 0;
        giFontBtnDefault.Click;
      end;
    // Font: inc size
    VK_ADD:
      if Shift = [] then
      begin
        Key := 0;
        UpdateFont(FFontName, FFontSize + 1);
        Render;
      end;
    // Font: dec size
    VK_SUBTRACT:
      if Shift = [] then
      begin
        Key := 0;
        UpdateFont(FFontName, FFontSize - 1);
        Render;
      end;
    // Mode
    vkM:
      if Shift = [] then
      begin
        Key := 0;
        case FMode of
          mSimple : giModeBtnChr.Click;
          mItems  : giModeBtnTxt.Click;
          mItemsEx: giModeBtnSim.Click;
        end;
      end;
    // Search
    vkF:
      if Shift = [ssCtrl] then
      begin
        Key := 0;
        giSearchMiActivate.Click;
      end
      else if Shift = [] then
      begin
        Key := 0;
        giSearchBtnForward.Click;
      end;
    // Copy
    vkC:
      if (Shift = [ssCtrl]) and (Sender is TDrawGrid) then
      begin
        Key := 0;
        CopyOpt;
      end
      else if Shift = [ssAlt] then
      begin
        Key := 0;
        CopyAll;
      end
      else if Shift = [ssShift] then
      begin
        Key := 0;
        CopyOne;
      end;
    // Select
    vkA:
      if (Shift = [ssCtrl]) and (Sender is TDrawGrid) then
      begin
        Key := 0;
        GridMain.Selection := ToGridRect(0, 1, GridMain.ColCount - 1, GridMain.RowCount - 1);
      end;
  end;
end;

procedure TfrHeader.ReadProfile;
var
  Section: string;
begin
  inherited;
  Section := ProfileSection;
  FFontName := Profile.ReadString(Section, 'FontName', FFontName);
  FFontSize := Profile.ReadInteger(Section, 'FontSize', FFontSize);
  FMode := TMode(Profile.ReadInteger(Section, 'Mode', Integer(Low(TMode)), Integer(High(TMode)), Integer(FMode)));
  FSearchFlags := IntToSearchFlags(Profile.ReadInteger(Section, 'Search', SearchFlagsToInt(FSearchFlags)));
end;

procedure TfrHeader.WriteProfile;
var
  Section: string;
begin
  inherited;
  Section := ProfileSection;
  Profile.WriteString(Section, 'FontName', FFontName);
  Profile.WriteInteger(Section, 'FontSize', FFontSize);
  Profile.WriteInteger(Section, 'Mode', Integer(FMode));
  Profile.WriteInteger(Section, 'Search', SearchFlagsToInt(FSearchFlags));
end;

procedure TfrHeader.SetFit(Fit: TFitsFileBitmap);
begin
  inherited;
  FUpdates := GetFullDebts;
  FRenders := GetFullDebts;
end;

procedure TfrHeader.Render;
begin
  BeginRender;
  try
    if not FInit then
    begin
      InitFont;
      InitCopy;
      InitGridMain;
      InitPopupMenu;
    end;
    if FUpdates <> [] then
    begin
      MatchLines;
      MatchSearch;
      MatchGridMain;
    end;
    if FRenders <> [] then
    begin
      RenderInfo;
      RenderFont;
      RenderMode;
      RenderSearch;
      RenderGridMain;
    end;
  finally
    inherited;
    FUpdates := [];
    EndRender;
  end;
end;

procedure TfrHeader.MatchLines;
const
  // TColor($00BBGGRR)
  clText     = clWindowText;
  clKeyword  = clNavy;
  clValuInd  = clNavy;
  clNoteInd  = clTeal;
  clNote     = clTeal;
  clDateTime = TColor($000037CD);
  clRaDe     = TColor($00CD52B4);
  clComment  = clGray;
var
  I: Integer;
  S: string;
  L: TLineItem;
begin
  if not (deMode in FUpdates) then
    Exit;
  if not Assigned(FFit) then
  begin
    FLineCapacity := 0;
    FLineCount := 0;
    Exit;
  end;
  FLineCount := FFit.LineCount;
  FLineCapacity := FFit.LineCapacity;
  if Length(FLines) < FLineCount then
  begin
    FLines := nil;
    SetLength(FLines, FLineCount);
  end;
  case FMode of
    // simple line
    mSimple:
      begin
        for I := 0 to FLineCount - 1 do
          FLines[I][0] := ToItem(FFit.Lines[I], clText, [], [tfLeft]);
      end;
    // items as cahrs
    mItems:
      begin
        for I := 0 to FLineCount - 1 do
        begin
          L := FFit.LineBuilder.Items[I, cCastChars];
          FLines[I][0] := ToItem(L.Keyword, clKeyword, [], [tfLeft]);
          FLines[I][1] := ToItem('', clValuInd, [], [tfCenter]);
          if L.ValueIndicate then
            FLines[I][1].iText := cChrValueIndicator;
          FLines[I][2] := ToItem(L.Value.Str, clText, [], [tfRight]);
          FLines[I][3] := ToItem('', clNoteInd, [fsItalic], [tfCenter]);
          if L.NoteIndicate then
            FLines[I][3].iText := cChrNoteIndicator;
          FLines[I][4] := ToItem(L.Note, clNote, [fsItalic], [tfLeft]);
        end;
      end;
    // items as text
    mItemsEx:
      begin
        for I := 0 to FLineCount - 1 do
        begin
          L := FFit.LineBuilder.Items[I, cCastString];
          FLines[I][0] := ToItem(L.Keyword, clKeyword, [], [tfLeft]);
          FLines[I][1] := ToItem('', clValuInd, [], [tfCenter]);
          if L.ValueIndicate then
            FLines[I][1].iText := cChrValueIndicator;
          FLines[I][2] := ToItem(L.Value.Str, clText, [], [tfRight]);
          FLines[I][3] := ToItem('', clNoteInd, [fsItalic], [tfCenter]);
          if L.NoteIndicate then
            FLines[I][3].iText := cChrNoteIndicator;
          FLines[I][4] := ToItem(L.Note, clNote, [fsItalic], [tfLeft]);
          // highlights
          S := UpperCase(L.Keyword);
          // - core
          if AnsiMatchStr(S, ['SIMPLE', 'BITPIX', 'NAXIS', 'NAXIS1', 'NAXIS2', 'BSCALE', 'BZERO']) then
          begin
            FLines[I][2].iStyle := [fsBold];
            FLines[I][2].iColor := clKeyword;
          end
          else
          // - datetime
          if AnsiMatchStr(S, ['DATE', 'DATE-OBS', 'DATE-END', 'TIME-OBS', 'TIME-END']) then
          begin
            FLines[I][2].iColor := clDateTime;
          end
          else
          // - ra,de
          if AnsiMatchStr(S, ['RA', 'DEC', 'RA_NOM', 'DEC_NOM', 'RA_OBJ', 'DEC_OBJ', 'RA_PNT', 'DEC_PNT']) then
          begin
            FLines[I][2].iColor := clRaDe;
          end
          else
          // --
          if AnsiMatchStr(S, ['COMMENT', 'HISTORY']) then
          begin
            FLines[I][2].iColor := clComment;
          end;
        end;
      end;
  end;
end;

procedure TfrHeader.GridMainDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Item: TItem;
  Padd: TRect;
  Len: Integer;
  X1, Y1, X2, Y2: Integer;
begin
  // set padding-rect
  Padd := Rect;
  Inc(Padd.Left, cGridSpec.CellBorderHalf.cx);
  Dec(Padd.Right, cGridSpec.CellBorderHalf.cx);
  // init null-item
  Item := ToItem('', clWindowText, [], []);
  // draw title, ARow = 0
  if gdFixed in State then
  begin
    if FMode = mSimple then // GridMain.ColCount = 1
      Item := ToItem('Lines', clGrayText, [], [tfLeft])
    else
    case ACol of // GridMain.ColCount = 5
      0: Item := ToItem('Keyword', clGrayText, [], [tfLeft]);
      2: Item := ToItem('Value', clGrayText, [], [tfRight]);
      4: Item := ToItem('Note', clGrayText, [], [tfLeft]);
    end;
    with GridMain.Canvas do
    begin
      Font.Assign(PanelMain.Font);
      Font.Color := Item.iColor;
      Font.Style := Item.iStyle;
      Brush.Color := IfThenColor(gdHotTrack in State, cl3DLight, clBtnFace);
      FillRect(Rect);
      TextRect(Padd, Item.iText, Item.iAlign);
    end;
    Exit;
  end;
  // draw body:
  // ARow - 1 == Index of FLines
  // ACol - 0 == Index of FItems
  // LineCount <= LineCapacity
  if ARow <= FLineCount then
    Item := FLines[ARow - 1][ACol];
  Len := Length(Item.iText);
  // highlight of background
  with GridMain.Canvas do
  begin
    Brush.Color := IfThenColor([gdSelected, gdFocused] * State = [], GridMain.Color, cGridSpec.SelectedColor);
    FillRect(Rect);
  end;
  // highlight of search
  if (FSearchCount > 0) and (FSearchItem.iRow = ARow - 1) and (FSearchItem.iCol = ACol) then
  begin
    Y1 := Padd.TopLeft.y;
    X1 := Padd.TopLeft.x;
    Y2 := Padd.BottomRight.y;
    X2 := Padd.BottomRight.x;
    if tfRight in Item.iAlign then
    begin
      X2 := X2 - GridMain.Canvas.TextWidth(Copy(Item.iText, FSearchItem.iPos + FSearchItem.iLen, Len));
      X1 := X2 - GridMain.Canvas.TextWidth(Copy(Item.iText, FSearchItem.iPos, FSearchItem.iLen));
    end
    else
    begin
      X1 := X1 + GridMain.Canvas.TextWidth(Copy(Item.iText, 1, FSearchItem.iPos - 1));
      X2 := X1 + GridMain.Canvas.TextWidth(Copy(Item.iText, FSearchItem.iPos, FSearchItem.iLen));
    end;
    with GridMain.Canvas do
    begin
      Brush.Color := clYellow; // TColor($00ADDEFF);
      FillRect(System.Classes.Rect(X1, Y1, X2, Y2));
      Brush.Style := bsClear;
    end;
  end;
  // out item text
  with GridMain.Canvas do
  begin
    Font.Assign(GridMain.Font);
    Font.Color := Item.iColor;
    Font.Style := Item.iStyle;
    TextRect(Padd, Item.iText, Item.iAlign);
  end;
end;

procedure TfrHeader.GridMainScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  AScroll: TLofiScrollBar;
begin
  if ScrollCode = scEndScroll then
  begin
    AScroll := Sender as TLofiScrollBar;
    if AScroll.Name = 'PanelMainScrollHor' then
      GridMain.Left := GridGutt.Width - ScrollPos
    else // if AScroll.Name = 'PanelMainScrollVer' then
      GridMain.TopRow := ScrollPos + 1; // ~fixed row
  end;
end;

procedure TfrHeader.GridMainTopLeftChanged(Sender: TObject);
begin
  GridGutt.TopRow := GridMain.TopRow;
  if FGridMainUserTopLeftChanged then
    PanelMainScrollVer.Position := GridMain.TopRow - 1; // ~fixed row
end;

procedure TfrHeader.GridMainColWidthsUserChanged(Sender: TObject; ACol: Integer);
begin
  if View then
    FixBoundsGridMain;
end;

procedure TfrHeader.GridGuttDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  Item: TItem;
  Padd: TRect;
begin
  // set padding-rect
  Padd := Rect;
  Inc(Padd.Left, cGridSpec.CellBorderHalf.cx);
  Dec(Padd.Right, cGridSpec.CellBorderHalf.cx);
  // set item
  if ARow = 0 then
    Item := ToItem('', clWindowText, [], [])
  else
    Item := ToItem(Format('%.3d', [ARow]), clGrayText, [], [tfRight]);
  with GridGutt.Canvas do
  begin
    Font.Assign(PanelMain.Font);
    Font.Color := Item.iColor;
    Font.Style := Item.iStyle;
    Brush.Color := IfThenColor(FGridGuttHotTrack = ARow, cl3DLight, clBtnFace);
    FillRect(Rect);
    TextRect(Padd, Item.iText, Item.iAlign);
  end;
end;

procedure TfrHeader.GridGuttMouseLeave(Sender: TObject);
begin
  if FGridGuttHotTrack >= 0 then
  begin
    FGridGuttHotTrack := -1;
    GridGutt.Invalidate;
  end;
end;

procedure TfrHeader.GridGuttMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: Integer;
begin
  GridGutt.MouseToCell(X, Y, ACol, ARow);
  if ARow <> FGridGuttHotTrack then
  begin
    FGridGuttHotTrack := ARow;
    GridGutt.Invalidate;
  end;
end;

procedure TfrHeader.FixBoundsGridMain;
var
  I: Integer;
  Bar: Boolean;
  Wpage, Wgrid,  Hpage, Hgrid: Integer;
  BarPos, BarMin, BarMax, BarPag: Integer;
begin
  Wpage := PanelMainSpace.Width - GridGutt.Width;
  Wgrid := 0;
  for I := 0 to GridMain.ColCount - 1 do
    Wgrid := Wgrid + GridMain.ColWidths[I];
  Wgrid := Max(Wpage, Wgrid);
  Hpage := 1 + (PanelMainSpace.Height - GridMain.RowHeights[0]) div GridMain.RowHeights[1];
  Hgrid := GridMain.RowCount - 1;
  GridMain.SetBounds(GridGutt.Width, GridGutt.Top, Wgrid, GridGutt.Height);
  // set horizont scroll, taking into account the past value of Position
  Bar := Wgrid > Wpage;
  if Bar then
  begin
    BarPag := Wpage;
    BarMin := 0;
    BarMax := Wgrid - 1;
    BarPos := 0;
    if PanelMainScrollHor.Enabled then
    begin
      BarPos := PanelMainScrollHor.Position - (BarMax - PanelMainScrollHor.Max);
      BarPos := Max(0, BarPos);
      BarPos := Min(BarMax - (BarPag - 1), BarPos);
    end;
    PanelMainScrollHor.SetParams(BarPos, BarMin, BarMax, BarPag);
    GridMain.Left := GridGutt.Width - BarPos;
  end;
  PanelMainScrollHor.Enabled := Bar;
  // set vertical scroll, taking into account the past value of Position
  Bar := Hgrid > Hpage;
  if Bar then
  begin
    BarPag := Hpage;
    BarMin := 0;
    BarMax := Hgrid; // ~fixed row
    BarPos := 0;
    if PanelMainScrollVer.Enabled then
    begin
      BarPos := PanelMainScrollVer.Position - (BarMax - PanelMainScrollVer.Max);
      BarPos := Max(0, BarPos);
      BarPos := Min(BarMax - (BarPag - 1), BarPos);
    end;
    PanelMainScrollVer.SetParams(BarPos, BarMin, BarMax, BarPag);
    FGridMainUserTopLeftChanged := False;
    GridMain.TopRow := BarPos + 1; // ~fixed row
    FGridMainUserTopLeftChanged := True;
  end;
  PanelMainScrollVer.Enabled := Bar;
end;

procedure TfrHeader.InitGridMain;
begin
  FGridGuttHotTrack := -1;
  FGridMainUserTopLeftChanged := True;
  GridMain.OnColWidthsUserChanged := GridMainColWidthsUserChanged;
end;

procedure TfrHeader.MatchGridMain;
begin
  if not Assigned(FFit) then
  begin
    GridMain.ColCount := 1;
    GridMain.RowCount := 1;
    Exit;
  end;
  if deFont in FUpdates then
  begin
    GridMain.Font.Name := FFontName;
    GridMain.Font.Size := FFontSize;
  end;
  if deMode in FUpdates then
    GridMain.ColCount := ifthen(FMode = mSimple, 1, 5);
  if FNew then
  begin
    GridMain.RowCount := 1 + FLineCapacity;
    GridGutt.RowCount := GridMain.RowCount;
  end;
  Include(FRenders, deGridMain);
end;

procedure TfrHeader.RenderGridMain;
var
  I, J, N: Integer;
  S: string;
  X: array [0 .. 4] of Integer;
  Item: TItem;
  CanvasDef: TCanvas;
  Bar: Boolean;
  Wpage, Wgrid,  Hpage, Hgrid: Integer;
  BarPos, BarMin, BarMax, BarPag: Integer;
begin
  if not View then
    Exit;
  if not Assigned(FFit) then
    Exit;
  if not (deGridMain in FRenders) then
    Exit;
  Exclude(FRenders, deGridMain);
  // get canvas default
  CanvasDef := PanelMain.Canvas;
  // set canvas of gridmain
  GridMain.Canvas.Font.Assign(GridMain.Font);
  // set rows height
  X[0] := CanvasDef.TextHeight('W') + cGridSpec.CellBorder.cy;
  X[0] := Max(X[0], cGridSpec.CellSizeMin.cy);
  X[1] := GridMain.Canvas.TextHeight('H') + cGridSpec.CellBorder.cy;
  X[1] := Max(X[1], cGridSpec.CellSizeMin.cy);
  GridMain.DefaultRowHeight := Max(X[0], X[1]);
  GridMain.RowHeights[0] := X[0];
  GridGutt.DefaultRowHeight := GridMain.DefaultRowHeight;
  GridGutt.RowHeights[0] := GridMain.RowHeights[0];
  // set cols width
  if FMode = mSimple then
  begin
    N := 1;
    X[0] := CanvasDef.TextWidth('Lines');
  end
  else // FMode = mItems or mItemsEx
  begin
    N := 5;
    X[0] := CanvasDef.TextWidth('Keyword');
    X[1] := CanvasDef.TextWidth(cChrValueIndicator);
    X[2] := CanvasDef.TextWidth('Value');
    X[3] := CanvasDef.TextWidth(cChrNoteIndicator);
    X[4] := CanvasDef.TextWidth('Note');
  end;
  for I := 0 to FLineCount - 1 do
  for J := 0 to N - 1 do
  begin
    Item := FLines[I][J];
    GridMain.Canvas.Font.Style := Item.iStyle;
    X[J] := Max(X[J], GridMain.Canvas.TextWidth(Item.iText));
  end;
  for J := 0 to N - 1 do
    GridMain.ColWidths[J] := X[J] + cGridSpec.CellBorder.cx;
  GridGutt.ColWidths[0] := CanvasDef.TextWidth('0000') + cGridSpec.CellBorder.cx * 2;
  GridGutt.Width := GridGutt.ColWidths[0];
  // restore canvas of gridmain
  GridMain.Canvas.Font.Assign(GridMain.Font);
  // set bounds of gridmain and scrollbars position
  Wpage := PanelMainSpace.Width - GridGutt.Width;
  Wgrid := 0;
  for I := 0 to GridMain.ColCount - 1 do
    Wgrid := Wgrid + GridMain.ColWidths[I];
  Wgrid := Max(Wpage, Wgrid);
  Hpage := 1 + (PanelMainSpace.Height - GridMain.RowHeights[0]) div GridMain.RowHeights[1];
  Hgrid := GridMain.RowCount - 1;
  GridMain.SetBounds(GridGutt.Width, GridGutt.Top, Wgrid, GridGutt.Height);
  // horizont scroll
  Bar := Wgrid > Wpage;
  if Bar then
  begin
    BarPag := Wpage;
    BarMin := 0;
    BarMax := Wgrid - 1;
    BarPos := 0;
    // correct the scroll position as per search result
    if deSearch in FUpdates then
      if FSearchCount > 0 then
      begin
        I := FSearchItem.iRow;
        J := FSearchItem.iCol;
        for N := 0 to J do
          BarPos := BarPos + GridMain.ColWidths[N] + GridMain.GridLineWidth;
        if tfRight in FLines[I][J].iAlign then
        begin
          S := Copy(FLines[I][J].iText, FSearchItem.iPos, Length(FLines[I][J].iText));
          BarPos := BarPos - cGridSpec.CellBorderHalf.cx - GridMain.Canvas.TextWidth(S);
        end
        else
        begin
          S := Copy(FLines[I][J].iText, 1, FSearchItem.iPos - 1);
          BarPos := BarPos - GridMain.ColWidths[J] + cGridSpec.CellBorderHalf.cx + GridMain.Canvas.TextWidth(S);
        end;
        BarPos := Max(BarPos - 50, 0);
        BarPos := Min(Wgrid - Wpage + 1, BarPos);
      end;
    PanelMainScrollHor.SetParams(BarPos, BarMin, BarMax, BarPag);
    GridMain.Left := GridMain.Left - BarPos;
  end;
  PanelMainScrollHor.Enabled := Bar;
  // vertical scroll
  Bar := Hgrid > Hpage;
  if Bar then
  begin
    BarPag := Hpage;
    BarMin := 0;
    BarMax := Hgrid; // ~fixed row
    BarPos := 0;
    // correct the scroll position as per search result
    if deSearch in FUpdates then
      if FSearchCount > 0 then
        BarPos := FSearchItem.iRow;
    PanelMainScrollVer.SetParams(BarPos, BarMin, BarMax, BarPag);
    FGridMainUserTopLeftChanged := False;
    GridMain.TopRow := BarPos + 1; // ~fixed row
    FGridMainUserTopLeftChanged := True;
  end;
  PanelMainScrollVer.Enabled := Bar;
end;

procedure TfrHeader.RenderInfo;
var
  Lines: array [6 .. 9] of string;
  S: string;
begin
  if not ViewMenu then
    Exit;
  if giInfo.HeightState = hsMini then
    Exit;
  if not (deInfo in FRenders) then
    Exit;
  Exclude(FRenders, deInfo);
  Lines[6] := 'Header offset: %d';
  Lines[7] := 'Header size (byte): %d';
  Lines[8] := 'Line count: %d';
  Lines[9] := 'Line capacity: %d';
  if not Assigned(FFit) then
  begin
    S := LinesTxt(Lines, True);
  end
  else
  begin
    LinesFmt(Lines[6], [0]);
    LinesFmt(Lines[7], [FFit.StreamSizeHead]);
    LinesFmt(Lines[8], [FFit.LineCount]);
    LinesFmt(Lines[9], [FFit.LineCapacity]);
    S := LinesTxt(Lines);
  end;
  giInfoMemo.Lines.Text := FitHduCoreAsString + S;
end;

procedure TfrHeader.giFontAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
begin
  if Control = giFontCmbName then
  begin
    NewWidth := AlignRect.Width - CtrlGap * 3 - Round(AlignRect.Width * 70 / 200);
    NewLeft := CtrlGap;
  end
  else if Control = giFontCmbSize then
  begin
    NewWidth := Round(AlignRect.Width * 70 / 200);
    NewLeft := AlignRect.Width - NewWidth - CtrlGap;
  end
  else if Control = giFontBtnMonospace then
    NewLeft := AlignRect.Width div 2 - CtrlGap div 2 - NewWidth
  else if Control = giFontBtnDefault then
    NewLeft := AlignRect.Width div 2 + CtrlGap div 2;
end;

procedure TfrHeader.giFontCmbNameChangeDone(Sender: TLofiComboBox; AText: string);
var
  S, NewName: string;
begin
  S := Trim(AText);
  if S = cFontName.DefView then
    NewName := cFontName.Def
  else
    NewName := S;
  UpdateFont(NewName, FFontSize);
  Render;
end;

procedure TfrHeader.giFontCmbSizeChangeDone(Sender: TLofiComboBox; AText: string);
var
  S: string;
  NewSize: Integer;
begin
  S := Trim(AText);
  if S = cFontSize.DefView then
    NewSize := cFontSize.Def
  else
    NewSize := StrToIntDef(S, FFontSize);
  UpdateFont(FFontName, NewSize);
  Render;
end;

procedure TfrHeader.giFontBtnMonospaceClick(Sender: TObject);
begin
  UpdateFont('Courier New', cFontSize.Min);
  Render;
end;

procedure TfrHeader.giFontBtnDefaultClick(Sender: TObject);
begin
  UpdateFont(cFontName.Def, cFontSize.Def);
  Render;
end;

procedure TfrHeader.InitFont;
var
  I: Integer;
begin
  giFontCmbName.Items.Assign(Screen.Fonts);
  if giFontCmbName.Items.IndexOf(FFontName) < 0 then
    FFontName := cFontName.Def;
  giFontCmbSize.Items.BeginUpdate;
  for I := cFontSize.Min to cFontSize.Max do
    giFontCmbSize.Items.Add(IntToStr(I));
  giFontCmbSize.Items.EndUpdate;
  if FFontSize <> cFontSize.Def then
    FFontSize := EnsureRange(FFontSize, cFontSize.Min, cFontSize.Max);
end;

procedure TfrHeader.UpdateFont(NewName: string; NewSize: Integer);
begin
  // verify name & size
  if NewName <> cFontName.Def then
    NewName := ifthen(giFontCmbName.Items.IndexOf(NewName) < 0, FFontName, NewName);
  if NewSize <> cFontSize.Def then
    NewSize := EnsureRange(NewSize, cFontSize.Min, cFontSize.Max);
  // check need update
  if (NewName <> FFontName) or (NewSize <> FFontSize) then
  begin
    FFontName := NewName;
    FFontSize := NewSize;
    Include(FUpdates, deFont);
  end;
  // mandatory render
  Include(FRenders, deFont);
end;

procedure TfrHeader.RenderFont;
begin
  if not ViewMenu then
    Exit;
  if giFont.HeightState = hsMini then
    Exit;
  if not (deFont in FRenders) then
    Exit;
  Exclude(FRenders, deFont);
  giFontCmbName.Text := ifthen(FFontName = cFontName.Def, cFontName.DefView, FFontName);
  giFontCmbSize.Text := ifthen(FFontSize = cFontSize.Def, cFontSize.DefView, IntToStr(FFontSize));
end;

procedure TfrHeader.giModeAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
begin
  if Control = giModeBtnSim then
    NewLeft := AlignRect.Width div 2 - NewWidth div 2 - CtrlGap - NewWidth
  else if Control = giModeBtnChr then
    NewLeft := AlignRect.Width div 2 - NewWidth div 2
  else if Control = giModeBtnTxt then
    NewLeft := AlignRect.Width div 2 + NewWidth div 2 + CtrlGap;
end;

procedure TfrHeader.giModeBtnClick(Sender: TObject);
var
  NewMode: TMode;
begin
  NewMode := TMode((Sender as TSpeedButton).Tag);
  UpdateMode(NewMode);
  Render;
end;

procedure TfrHeader.UpdateMode(NewMode: TMode);
begin
  if NewMode <> FMode then
  begin
    FMode := NewMode;
    Include(FUpdates, deMode);
  end;
  Include(FRenders, deMode);
end;

procedure TfrHeader.RenderMode;
begin
  if not ViewMenu then
    Exit;
  if giMode.HeightState = hsMini then
    Exit;
  if not (deMode in FRenders) then
    Exit;
  Exclude(FRenders, deMode);
  case FMode of
    mSimple:  giModeBtnSim.Down := True;
    mItems:   giModeBtnChr.Down := True;
    mItemsEx: giModeBtnTxt.Down := True;
  end;
end;

procedure TfrHeader.giSearchAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
begin
  if Control = giSearchEditValue then
  begin
    NewWidth := AlignRect.Width - CtrlGap * 2;
    if giSearchLabelOut.Visible then
      NewWidth := NewWidth - giSearchLabelOut.Width - CtrlGap;
    NewTop := giSearchEditValue.Top + (giSearchEditValue.Height - NewHeight) div 2;
  end
  else if Control = giSearchLabelOut then
  begin
    NewLeft := AlignRect.Width - NewWidth - CtrlGap;
    NewTop := giSearchEditValue.Top + (giSearchEditValue.Height - NewHeight) div 2;
  end
  else if (Control = giSearchChbMatchCase) or (Control = giSearchChbKeywordOnly) then
    NewLeft := AlignRect.Width div 2 - NewWidth div 2
  else if Control = giSearchBtnReset then
    NewLeft := AlignRect.Width div 2 - NewWidth div 2 - CtrlGap - NewWidth
  else if Control = giSearchBtnReverse then
    NewLeft := AlignRect.Width div 2 - NewWidth div 2
  else if Control = giSearchBtnForward then
    NewLeft := AlignRect.Width div 2 + NewWidth div 2 + CtrlGap;
end;

procedure TfrHeader.giSearchMiActivateClick(Sender: TObject);
begin
  ActivateGroupItem(giSearch);
  giSearchEditValue.SetFocus;
end;

procedure TfrHeader.giSearchEditValueChange(Sender: TObject);
begin
  FSearchActive := False;
end;

procedure TfrHeader.giSearchEditValueKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    giSearchBtnForward.Click;
end;

procedure TfrHeader.giSearchCmbClick(Sender: TObject);
var
  NewText: string;
  NewFlags: TSearchFlags;
begin
  NewText := giSearchEditValue.Text;
  NewFlags := [];
  if giSearchChbMatchCase.Checked then
    Include(NewFlags, sfMathCase);
  if giSearchChbKeywordOnly.Checked then
    Include(NewFlags, sfKeywordOnly);
  UpdateSearchText(NewText, NewFlags);
  Render;
end;

procedure TfrHeader.giSearchBtnResetClick(Sender: TObject);
begin
  UpdateSearchActive(False);
  Render;
end;

procedure TfrHeader.giSearchBtnReverseClick(Sender: TObject);
begin
  UpdateSearchText(giSearchEditValue.Text, dReverse);
  Render;
end;

procedure TfrHeader.giSearchBtnForwardClick(Sender: TObject);
begin
  UpdateSearchText(giSearchEditValue.Text, dForward);
  Render;
end;

procedure TfrHeader.MatchSearch;
  // http://qubanshi.cc/questions/245890/any-build-in-delphi-function-like-posex-that-finds-a-sub-string-starting-from-th
  function RPosEx(const SubStr, S: string; Offset: Integer): Integer;
  var
    I, J, K, L: Integer;
  begin
    Result := 0;
    L := Length(SubStr);
    for I := Offset downto 1 do
    begin
      Result := I;
      K := 1;
      for J := I to I + L - 1 do
      begin
        if S[J] <> SubStr[K] then
        begin
          Result := 0;
          Break;
        end;
        Inc(K);
      end;
      if Result <> 0 then
        Break;
    end;
  end;
var
  I, Imax, J, Jmax: Integer;
  X, D, Offset: Integer;
  S, Sub: string;
  Found, Frwrd: Boolean;
begin
  // auto deactivate
  if FNew or (not Assigned(FFit)) or (deMode in FUpdates) then
    if FSearchActive then
    begin
      Include(FUpdates, deSearch);
      Include(FRenders, deSearch);
      FSearchActive := False;
    end;
  // check modify
  if not (deSearch in FUpdates) then
    Exit;
  // reset
  if not FSearchActive then
  begin
    FSearchText := '';
    // FSearchFlags;
    FSearchDir := dForward;
    FSearchIndex := 0;
    FSearchCount := 0;
    FSearchItem.iCol := -1;
    FSearchItem.iRow := -1;
    FSearchItem.iPos := 0;
    FSearchItem.iLen := 0;
    Exit;
  end;
  // search
  Imax := FLineCount - 1;
  Jmax := IfThen((FMode = mSimple) or (sfKeywordOnly in FSearchFlags), 1, 5) - 1;
  Sub := IfThen(sfMathCase in FSearchFlags, AnsiUpperCase(FSearchText), FSearchText);
  // search count
  if FSearchCount = 0 then
  begin
    FSearchIndex := 0;
    for I := 0 to Imax do
    for J := 0 to Jmax do
    begin
      S := FLines[I][J].iText;
      if (FMode = mSimple) and (sfKeywordOnly in FSearchFlags) then
        S := Copy(S, 1, cSizeKeyword);
      if sfMathCase in FSearchFlags then
        S := AnsiUpperCase(S);
      FSearchCount := FSearchCount + StrCountOccur(Sub, S);
    end;
  end;
  if FSearchCount = 0 then
  begin
    FSearchIndex := 0;
    FSearchItem.iCol := -1;
    FSearchItem.iRow := -1;
    FSearchItem.iPos := 0;
    FSearchItem.iLen := 0;
    Exit;
  end;
  // search item next, FSearchCount > 0
  Frwrd := FSearchDir = dForward;
  D := ifthen(Frwrd, +1, -1);
  if FSearchIndex = 0 then
  begin
    I := ifthen(Frwrd, 0, Imax);
    J := ifthen(Frwrd, 0, Jmax);
    Offset := ifthen(Frwrd, 1, Length(FLines[Imax][Jmax].iText));
  end
  else
  begin
    I := FSearchItem.iRow;
    J := FSearchItem.iCol;
    Offset := FSearchItem.iPos + D;
    // edits of the boundary conditions, when the last search result
    // FSearchItem.iPos = 1 or Length(FLines[I][J].iText)
    case FSearchDir of
      dForward:
        if Offset > Length(FLines[I][J].iText) then
        begin
          J := J + 1;
          if J > Jmax then
          begin
            J := 0;
            I := I + 1;
            if I > Imax then
              I := 0;
          end;
          Offset := 1;
        end;
      dReverse:
        if Offset = 0 then
        begin
          J := J - 1;
          if J < 0 then
          begin
            J := Jmax;
            I := I - 1;
            if I < 0 then
              I := Imax;
          end;
          Offset := Length(FLines[I][J].iText);
        end;
    end;
  end;
  repeat
    repeat
      S := FLines[I][J].iText;
      if (FMode = mSimple) and (sfKeywordOnly in FSearchFlags) then
        S := Copy(S, 1, cSizeKeyword);
      if sfMathCase in FSearchFlags then
        S := AnsiUpperCase(S);
      if Offset = 0 then
        Offset := IfThen(Frwrd, 1, Length(S));
      if Frwrd then
        X := PosEx(Sub, S, Offset)
      else
        X := RPosEx(Sub, S, Offset);
      Found := X > 0;
      if Found then
      begin
        FSearchIndex := EnsureRing(FSearchIndex + D, 1, FSearchCount);
        FSearchItem.iRow := I;
        FSearchItem.iCol := J;
        FSearchItem.iPos := X;
        FSearchItem.iLen := Length(Sub);
      end
      else
      begin
        Offset := 0;
        J := J + D;
        if J < 0 then
          Break;
        if J > Jmax then
          Break;
      end;
    until Found;
    I := EnsureRing(I + D, 0, Imax);
    J := ifthen(Frwrd, 0, Jmax);
  until Found;
end;

procedure TfrHeader.UpdateSearchActive(NewActive: Boolean);
begin
  if NewActive <> FSearchActive then
  begin
    FSearchActive := NewActive;
    Include(FUpdates, deSearch);
  end;
  Include(FRenders, deSearch);
end;

procedure TfrHeader.UpdateSearchText(NewText: string; NewFlags: TSearchFlags);
begin
  if NewFlags <> FSearchFlags then
  begin
    FSearchActive := (NewText <> '');
    FSearchText := NewText;
    FSearchCount := 0;
    FSearchIndex := 0;
    FSearchFlags := NewFlags;
    Include(FUpdates, deSearch);
  end;
  Include(FRenders, deSearch);
end;

procedure TfrHeader.UpdateSearchText(NewText: string; NewDir: TSearchDir);
begin
  Include(FUpdates, deSearch);
  Include(FRenders, deSearch);
  // search active
  FSearchActive := (NewText <> '');
  if not FSearchActive then
    Exit;
  // search
  if NewText <> FSearchText then
  begin
    FSearchText := NewText;
    FSearchCount := 0;
    FSearchIndex := 0;
  end;
  // search or search next
  FSearchDir := NewDir;
end;

procedure TfrHeader.RenderSearch;
var
  Hr: TNotifyEvent;
begin
  if not ViewMenu then
    Exit;
  if giSearch.HeightState = hsMini then
    Exit;
  if not (deSearch in FRenders) then
    Exit;
  Exclude(FRenders, deSearch);
  with giSearchEditValue do
  begin
    Hr := OnChange;
    OnChange := nil;
    Text := FSearchText;
    OnChange := Hr;
  end;
  with giSearchChbMatchCase do
  begin
    ClicksDisabled := True;
    Checked := sfMathCase in FSearchFlags;
    ClicksDisabled := False;
  end;
  with giSearchChbKeywordOnly do
  begin
    ClicksDisabled := True;
    Checked := sfKeywordOnly in FSearchFlags;
    ClicksDisabled := False;
  end;
  giSearchLabelOut.Visible := FSearchActive;
  if FSearchActive then
  begin
    if FSearchCount > 0 then
      giSearchLabelOut.Font.Color := clGrayText
    else
      giSearchLabelOut.Font.Color := clRed;
    giSearchLabelOut.Caption := Format(' %d/%d ', [FSearchIndex, FSearchCount]);
  end;
end;

procedure TfrHeader.giCopyAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
begin
  if Control = giCopyBtnOpt then
    NewLeft := AlignRect.Width div 2 - NewWidth div 2 - CtrlGap - NewWidth
  else if Control = giCopyBtnAll then
    NewLeft := AlignRect.Width div 2 - NewWidth div 2
  else if Control = giCopyBtnOne then
    NewLeft := AlignRect.Width div 2 + NewWidth div 2 + CtrlGap;
end;

procedure TfrHeader.giCopyBtnClick(Sender: TObject);
begin
  case (Sender as TComponent).Tag of
    10: CopyOpt;
    20: CopyAll;
    30: CopyOne;
  end;
end;

procedure TfrHeader.InitCopy;
begin
  giCopyMiOpt.Caption := giCopyBtnOpt.Hint;
  giCopyMiAll.Caption := giCopyBtnAll.Hint;
  giCopyMiOne.Caption := giCopyBtnOne.Hint;
end;

function TfrHeader.EmptyLineByMode: string;
begin
  case FMode of
    mSimple:
      Result := DeLaFitsString.Blank(cSizeLine);
    mItems:
      Result := DeLaFitsString.Blank(cSizeKeyword)    + LinesItemDelim +                   // keyword
                ' '                                   + LinesItemDelim +                   // ValueIndicate
                DeLaFitsString.Blank(cWidthLineValue) + LinesItemDelim +                   // Value
                ' '                                   + LinesItemDelim +                   // NoteIndicate
                DeLaFitsString.Blank(cSizeLine - cSizeKeyword - 1 - cWidthLineValue - 1) ; // Note

    else // mItemsEx:
      Result := '' + LinesItemDelim + // keyword
                '' + LinesItemDelim + // ValueIndicate
                '' + LinesItemDelim + // Value
                '' + LinesItemDelim + // NoteIndicate
                '' ;                  // Note
  end;
end;

procedure TfrHeader.CopyOpt;
var
  Row, Row1, Row2: Integer;
  Col, Col1, Col2: Integer;
  S: string;
begin
  S := '';
  with GridMain.Selection do
  begin
    Row1 := Top;
    Row2 := Bottom;
    Col1 := Left;
    Col2 := Right;
  end;
  for Row := Row1 to Row2 do
  begin
    if Row <= FLineCount then
    begin
      for Col := Col1 to Col2 do
        S := S + FLines[Row - 1][Col].iText + LinesItemDelim;
      Delete(S, Length(S), 1);
    end
    else // Row > FLineCount, empty line
    begin
      S := S + EmptyLineByMode;
    end;
    S := S + sLineBreak;
  end;
  Clipboard.AsText := S;
end;

procedure TfrHeader.CopyAll;
var
  Row: Integer;
  Col, Col1, Col2: Integer;
  S: string;
begin
  S := '';
  Col1 := 0;
  Col2 := 0; if FMode > mSimple then Col2 := 4;
  // copy real line
  for Row := 0 to FLineCount - 1 do
  begin
    for Col := Col1 to Col2 do
      S := S + FLines[Row][Col].iText + LinesItemDelim;
    Delete(S, Length(S), 1);
    S := S + sLineBreak;
  end;
  // copy empty line
  for Row := FLineCount to FLineCapacity - 1 do
    S := S + EmptyLineByMode + sLineBreak;
  Clipboard.AsText := S;
end;

procedure TfrHeader.CopyOne;
var
  S: string;
begin
  S := FFit.HduText;
  S := S + DeLaFitsString.Blank(cSizeLine * (FLineCapacity - FLineCount));
  Clipboard.AsText := S;
end;

end.
