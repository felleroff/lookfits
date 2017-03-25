{ **************************************************** }
{  LookFits - Lister plugin (WLX) for view FITS files  }
{                                                      }
{    Frame of the render of data block of fits-file    }
{                   in digital kind                    }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit ufrData;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.IOUtils, System.StrUtils, System.Math, System.ImageList,
  Winapi.Windows, Winapi.Messages, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,
  Vcl.ImgList, Vcl.Clipbrd, ufrBase, Lofi.ExtCtrls, uProfile, uUtils,
  ufmWinProgress, DeLaFitsCommon, DeLaFitsString, DeLaFitsGraphics;

type

  TDebt = (deGridMain, deInfo, deFont, deFormat, deNavig, deConvert);
  TDebts = set of TDebt;

  { TfrData }

  TfrData = class(TfrBase)

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
  public
    constructor Create(AOwner: TComponent; TheDockSitePanelMain, TheDockSitePanelMenu: TWinControl; TheSubWin: ISubWin); reintroduce;
    destructor Destroy; override;
    procedure FrameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); override;
    procedure ReadProfile; override;
    procedure WriteProfile; override;
    procedure SetFit(Fit: TFitsFileBitmap); override;
    procedure Render; override;

  // Cache of data-fits
  private
    FCache: array of array of Double;
    FCacheCols: Integer;
    FCacheRows: Integer;
    FCacheRgn: TRgn;
    FRepDefault: TRep; // value of new fits.datarep by default
    procedure InitCache;
    procedure MatchCache;

  // GridMain
  published
    GridMain: TDrawGrid;
    procedure GridMainDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure GridMainScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure GridMainTopLeftChanged(Sender: TObject);
  private
    FGridMainCellTitleSize: TSize;
    FGridMainCellGutterSize: TSize;
    FGridMainCellBodySize: TSize;
    FGridMainColsBodyCount: Integer;
    FGridMainRowsBodyCount: Integer;
    FGridMainCellBodyFormat: string;
    function GetGridMainRegion: TRgn;
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

  // Format
  published
    giFormat: TLofiGroupItem;
    giFormatCmbStyle: TLofiComboBox;
    giFormatCmbPrec: TLofiComboBox;
    giFormatBtnDefault: TSpeedButton;
    procedure giFormatAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giFormatCmbStyleChangeDone(Sender: TLofiComboBox; AText: string);
    procedure giFormatCmbPrecChangeDone(Sender: TLofiComboBox; AText: string);
    procedure giFormatBtnDefaultClick(Sender: TObject);
  private const
    cFormatStyle: StringFix = (Def: 'default'; DefView: '');
    cFormatPrec: IntegerFix = (Min: 1; Max: 18; Def: 0; DefView: '');
  private
    FFormatStyle: string;
    FFormatPrec: Integer;
    procedure InitFormat;
    procedure UpdateFormat(NewStyle: string; NewPrec: Integer);
    procedure RenderFormat;

  // Navigation
  published
    giNavig: TLofiGroupItem;
    giNavigEditX: TEdit;
    giNavigEditY: TEdit;
    giNavigEditW: TEdit;
    giNavigEditH: TEdit;
    giNavigLabelX: TLabel;
    giNavigLabelY: TLabel;
    giNavigLabelW: TLabel;
    giNavigLabelH: TLabel;
    giNavigBtnL: TSpeedButton;
    giNavigBtnT: TSpeedButton;
    giNavigBtnR: TSpeedButton;
    giNavigBtnB: TSpeedButton;
    procedure giNavigAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giNavigEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure giNavigBtnClick(Sender: TObject);
  private
    procedure MatchNavig;
    procedure UpdateNavig(NewX1, NewY1: Integer);
    procedure RenderNavig;

  // Copy
  published
    giCopyMiOpt: TMenuItem;
    procedure giCopyMiOptClick(Sender: TObject);
  private
    procedure CopyOpt;

  // Convert
  published
    giConvert: TLofiGroupItem;
    giConvertLabelRgn: TLabel;
    giConvertLabelRep: TLabel;
    giConvertLabelOut: TLabel;
    giConvertCmbRgn: TComboBox;
    giConvertCmbRep: TComboBox;
    giConvertEditOut: TButtonedEdit;
    giConvertBtnStart: TSpeedButton;
    giConvertImgList: TImageList;
    procedure giConvertAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giConvertEditOutRightButtonClick(Sender: TObject);
    procedure giConvertBtnStartClick(Sender: TObject);
  private type
    TConvertBuf = record
      A08u1: TA08u1; A08u2: TA08u2;
      A16c1: TA16c1; A16c2: TA16c2;
      A16u1: TA16u1; A16u2: TA16u2;
      A32c1: TA32c1; A32c2: TA32c2;
      A32u1: TA32u1; A32u2: TA32u2;
      A64c1: TA64c1; A64c2: TA64c2;
      A32f1: TA32f1; A32f2: TA32f2;
      A64f1: TA64f1; A64f2: TA64f2;
    end;
  private
    FConvertRgn: TRgn;
    FConvertRow: Integer;
    FConvertRep: TRep;
    FConvertFile: TFileStream;
    FConvertBuf: TConvertBuf;
    procedure InitConvert;
    procedure MatchConvert;
    procedure RenderConvert;
    procedure ConvertStart(var AState: TProgressState; var AParams: TProgressParams);
    procedure ConvertExec(var AState: TProgressState; var AParams: TProgressParams);
    procedure ConvertStop(const AState: TProgressState; var AParams: TProgressParams);

  end;

implementation

{$R *.dfm}

type
  ELooDataException = class(Exception);

function GetFullDebts: TDebts; inline;
begin
  Result := [Low(TDebt) .. High(TDebt)];
end;

{ TfrData }

procedure TfrData.giChangeHeightState(Sender: TLofiGroupItem);
begin
  if not ViewMenu then
    Exit;
  if Sender.HeightState = hsMini then
    Exit;
  Render;
end;

procedure TfrData.BeginRender;
begin
  GridMain.Perform(WM_SETREDRAW, 0, 0);
end;

procedure TfrData.EndRender;
begin
  GridMain.SetFocus;
  GridMain.Perform(WM_SETREDRAW, 1, 0);
  GridMain.Invalidate;
end;

procedure TfrData.ChangeSize;
begin
  Include(FUpdates, deNavig);
  if View then
    Render;
end;

constructor TfrData.Create(AOwner: TComponent; TheDockSitePanelMain, TheDockSitePanelMenu: TWinControl; TheSubWin: ISubWin);
begin
  inherited Create(AOwner, TheDockSitePanelMain, TheDockSitePanelMenu, TheSubWin);
  FUpdates := GetFullDebts;
  FRenders := GetFullDebts;
  FCache := nil;
  FCacheCols := 0;
  FCacheRows := 0;
  FCacheRgn := ToRgnCoRo(0, 0, 0, 0);
  FRepDefault := repUnknown;
  FFontName := cFontName.Def;
  FFontSize := cFontSize.Def;
  FFormatStyle := cFormatStyle.Def;
  FFormatPrec := cFormatPrec.Def;
  FGridMainCellTitleSize := cGridSpec.CellSizeMin;
  FGridMainCellGutterSize := cGridSpec.CellSizeMin;
  FGridMainCellBodySize := cGridSpec.CellSizeMin;
  FGridMainColsBodyCount := 0;
  FGridMainRowsBodyCount := 0;
  FGridMainCellBodyFormat := '';
end;

destructor TfrData.Destroy;
begin
  FCache := nil;
  inherited;
end;

procedure TfrData.FrameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
    // Font and Format: default
    VK_MULTIPLY:
      if Shift = [] then
      begin
        Key := 0;
        giFontBtnDefault.Click;
      end
      else if Shift = [ssCtrl] then
      begin
        Key := 0;
        giFormatBtnDefault.Click;
      end;
    // Font: inc size & Format: inc precision
    VK_ADD:
      if Shift = [] then
      begin
        Key := 0;
        UpdateFont(FFontName, FFontSize + 1);
        Render;
      end
      else if Shift = [ssCtrl] then
      begin
        Key := 0;
        UpdateFormat(FFormatStyle, FFormatPrec + 1);
        Render;
      end;
    // Font: dec size & Format: dec precision
    VK_SUBTRACT:
      if Shift = [] then
      begin
        Key := 0;
        UpdateFont(FFontName, FFontSize - 1);
        Render;
      end
      else if Shift = [ssCtrl] then
      begin
        Key := 0;
        UpdateFormat(FFormatStyle, FFormatPrec - 1);
        Render;
      end;
    // Format: style
    vkF:
      if Shift = [] then
      begin
        Key := 0;
        giFormatCmbStyle.ItemIndex := EnsureRing(giFormatCmbStyle.ItemIndex + 1, 0, giFormatCmbStyle.Items.Count - 1);
        giFormatCmbStyleChangeDone(giFormatCmbStyle, giFormatCmbStyle.Text);
      end;
    // Navigation: left & Select
    vkA:
      if Shift = [] then
      begin
        Key := 0;
        giNavigBtnL.Click;
      end
      else if (Shift = [ssCtrl]) and (Sender is TDrawGrid) then
      begin
        Key := 0;
        GridMain.Selection := ToGridRect(1, 1, GridMain.ColCount - 1, GridMain.RowCount - 1);
      end;
    // Navigation: top
    vkW:
      if Shift = [] then
      begin
        Key := 0;
        giNavigBtnT.Click;
      end;
    // Navigation: right
    vkD:
      if Shift = [] then
      begin
        Key := 0;
        giNavigBtnR.Click;
      end;
    // Navigation: bottom
    vkS:
      if Shift = [] then
      begin
        Key := 0;
        giNavigBtnB.Click;
      end;
    // Copy
    vkC:
      if (Shift = [ssCtrl]) and (Sender is TDrawGrid) then
      begin
        Key := 0;
        CopyOpt;
      end
  end;
end;

procedure TfrData.ReadProfile;
var
  Section: string;
begin
  inherited;
  Section := ProfileSection;
  FCacheRgn.X1 := Profile.ReadInteger(Section, 'CacheRgn.X1', FCacheRgn.X1);
  FCacheRgn.Y1 := Profile.ReadInteger(Section, 'CacheRgn.Y1', FCacheRgn.Y1);
  FFontName := Profile.ReadString(Section, 'FontName', FFontName);
  FFontSize := Profile.ReadInteger(Section, 'FontSize', FFontSize);
  FFormatStyle := Profile.ReadString(Section, 'FormatStyle', FFormatStyle);
  FFormatPrec := Profile.ReadInteger(Section, 'FormatPrec', FFormatPrec);
end;

procedure TfrData.WriteProfile;
var
  Section: string;
begin
  inherited;
  Section := ProfileSection;
  Profile.WriteInteger(Section, 'CacheRgn.X1', FCacheRgn.X1);
  Profile.WriteInteger(Section, 'CacheRgn.Y1', FCacheRgn.Y1);
  Profile.WriteString(Section, 'FontName', FFontName);
  Profile.WriteInteger(Section, 'FontSize', FFontSize);
  Profile.WriteString(Section, 'FormatStyle', FFormatStyle);
  Profile.WriteInteger(Section, 'FormatPrec', FFormatPrec);
end;

procedure TfrData.SetFit(Fit: TFitsFileBitmap);
begin
  inherited;
  FUpdates := GetFullDebts;
  FRenders := GetFullDebts;
end;

procedure TfrData.Render;
begin
  BeginRender;
  try
    if not FInit then
    begin
      InitCache;
      InitFont;
      InitFormat;
      InitConvert;
      InitPopupMenu;
    end;
    if FUpdates <> [] then
    begin
      MatchCache;
      MatchNavig;
      MatchConvert;
      MatchGridMain;
    end;
    if FRenders <> [] then
    begin
      RenderInfo;
      RenderFont;
      RenderFormat;
      RenderNavig;
      RenderConvert;
      RenderGridMain;
    end;
  finally
    inherited Render;
    FUpdates := [];
    EndRender;
  end;
end;

procedure TfrData.InitCache;
begin
  FCacheCols := Screen.DesktopWidth div cGridSpec.CellSizeMin.cx + 1;
  FCacheRows := Screen.Height div cGridSpec.CellSizeMin.cy + 1;
  DeLaFitsCommon.RgnAllocMem(ToRgnCoRo(0, 0, FCacheCols, FCacheRows), rep64f, Pointer(FCache));
  if FCacheRgn.X1 < 0 then FCacheRgn.X1 := 0;
  if FCacheRgn.Y1 < 0 then FCacheRgn.Y1 := 0;
end;

procedure TfrData.MatchCache;
var
  FFitRgn: TRgn;
begin
  if not Assigned(FFit) then
  begin
    // FCacheRgn := ToRgnCoRo(0, 0, 0, 0); not nulled! persists
    FRepDefault := repUnknown;
    Exit;
  end;
  if not (deNavig in FUpdates) then
    Exit;
  FFitRgn := FFit.DataRgn;
  if FNew then
  begin
    FCacheRgn.X1 := EnsureRange(FCacheRgn.X1, FFitRgn.X1, FFitRgn.X1 + FFitRgn.ColsCount - 1);
    FCacheRgn.Y1 := EnsureRange(FCacheRgn.Y1, FFitRgn.Y1, FFitRgn.Y1 + FFitRgn.RowsCount - 1);
    FRepDefault := FFit.DataRep;
  end;
  FCacheRgn.ColsCount := Min(FCacheCols, FFitRgn.ColsCount - FCacheRgn.X1);
  FCacheRgn.RowsCount := Min(FCacheRows, FFitRgn.RowsCount - FCacheRgn.Y1);
  FFit.DataRep := rep64f;
  FFit.DataRead(Pointer(FCache), FCacheRgn);
end;

procedure TfrData.GridMainDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: string;
  Padd: TRect;
  Flag: TTextFormat;
begin
  // set ident
  Padd := Rect;
  Inc(Padd.Left, cGridSpec.CellBorderHalf.cx);
  Dec(Padd.Right, cGridSpec.CellBorderHalf.cx);
  // title & gutter
  if gdFixed in State then
  begin
    Flag := [tfSingleLine, tfVerticalCenter];
    if (ACol = 0) and (ARow = 0) then // [0, 0]
      S := ''
    else if ARow = 0 then // title
    begin
      S := IntToStr(FCacheRgn.X1 + (aCol - 1));
      Include(Flag, tfCenter);
    end
    else // if ACol = 0 then // gutter
    begin
      S := IntToStr(FCacheRgn.Y1 + (aRow - 1));
      Include(Flag, tfRight);
    end;
    with GridMain.Canvas do
    begin
      Font.Assign(PanelMain.Font);
      Font.Color := clGrayText;
      Brush.Color := IfThenColor(gdHotTrack in State, cl3DLight, clBtnFace);
      FillRect(Rect);
      TextRect(Padd, S, Flag);
    end;
    Exit;
  end;
  // body
  S := DeLaFitsString.FloatToStri(FCache[aCol - 1, aRow - 1], False, FGridMainCellBodyFormat);
  Flag := [tfSingleLine, tfCenter, tfVerticalCenter];
  with GridMain.Canvas do
  begin
    Font.Assign(GridMain.Font);
    Brush.Color := IfThenColor([gdSelected, gdFocused] * State = [], GridMain.Color, cGridSpec.SelectedColor);
    FillRect(Rect);
    TextRect(Padd, S, Flag);
  end;
end;

procedure TfrData.GridMainScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  NewX1, NewY1: Integer;
begin
  if ScrollCode = scEndScroll then
  begin
    NewX1 := FCacheRgn.X1;
    NewY1 := FCacheRgn.Y1;
    if (Sender as TLofiScrollBar).Name = 'PanelMainScrollHor' then
      NewX1 := ScrollPos  // Hor
    else
      NewY1 := ScrollPos; // Ver
    UpdateNavig(NewX1, NewY1);
    Render;
  end;
end;

procedure TfrData.GridMainTopLeftChanged(Sender: TObject);
begin
  GridMain.LeftCol := 1;
  GridMain.TopRow := 1;
end;

function TfrData.GetGridMainRegion: TRgn;
begin
  Result.X1 := FCacheRgn.X1;
  Result.Y1 := FCacheRgn.Y1;
  Result.Width := Max(1, FGridMainColsBodyCount);
  Result.Height := Max(1, FGridMainRowsBodyCount);
  //Result.Width := Max(1, FGridMainColsBodyCount - 1);
  //Result.Height := Max(1, FGridMainRowsBodyCount - 1);
end;

procedure TfrData.MatchGridMain;
var
  I, X, Y: Integer;
  S: string;
  Size: TSize;
  CanvasDef: TCanvas;
begin
  if [deGridMain, deFont, deFormat, deNavig] * FUpdates  = [] then
    Exit;
  Include(FRenders, deGridMain);
  if not Assigned(FFit) then
  begin
    FGridMainColsBodyCount := 0;
    FGridMainRowsBodyCount := 0;
    Exit;
  end;
  if deFont in FUpdates then
  begin
    GridMain.Font.Name := FFontName;
    GridMain.Font.Size := FFontSize;
  end;
  if deFormat in FUpdates then
  begin
    FGridMainCellBodyFormat := '%';
    if FFormatPrec <> cFormatPrec.Def then
      FGridMainCellBodyFormat := FGridMainCellBodyFormat + '.' + IntToStr(FFormatPrec);
    if FFormatStyle = cFormatStyle.Def then
      S := 'g'
    else if FFormatStyle = giFormatCmbStyle.Items[0] then
      S := 'g'
    else if FFormatStyle = giFormatCmbStyle.Items[1] then
      S := 'e'
    else // if FFormatStyle = giFormatCmbStyle.Items[3] then
      S := 'f';
    FGridMainCellBodyFormat := FGridMainCellBodyFormat + S;
  end;
  // get canvas default
  CanvasDef := PanelMain.Canvas;
  // get size cell title
  S := IntToStr(FFit.DataRgn.ColsCount);
  for I := 1 to Length(S) do
    S[I] := '0';
  Size := CanvasDef.TextExtent(S);
  Size := Sum(Size, cGridSpec.CellBorder.cx, cGridSpec.CellBorder.cy);
  Size.cx := Max(Size.cx, cGridSpec.CellSizeMin.cx);
  FGridMainCellTitleSize := Size;
  // get size cell gutter
  S := IntToStr(FFit.DataRgn.RowsCount);
  for I := 1 to Length(S) do
    S[I] := '0';
  Size := CanvasDef.TextExtent(S);
  Size := Sum(Size, cGridSpec.CellBorder.cx * 2, cGridSpec.CellBorder.cy);
  Size.cy := Max(Size.cy, cGridSpec.CellSizeMin.cy);
  FGridMainCellGutterSize := Size;
  // get size cell body
  GridMain.Canvas.Font.Assign(GridMain.Font);
  FGridMainCellBodySize.cx := FGridMainCellTitleSize.cx;
  FGridMainCellBodySize.cy := FGridMainCellGutterSize.cy;
  for Y := 0 to FCacheRgn.RowsCount - 1 do
  for X := 0 to FCacheRgn.ColsCount - 1 do
  begin
    S := DeLaFitsString.FloatToStri(FCache[X, Y], False, FGridMainCellBodyFormat);
    Size := GridMain.Canvas.TextExtent(S);
    Size := Sum(Size, cGridSpec.CellBorder.cx, cGridSpec.CellBorder.cy);
    FGridMainCellBodySize := Max(FGridMainCellBodySize, Size);
  end;
  // correct size cell title & gutter
  FGridMainCellTitleSize.cx := Max(FGridMainCellTitleSize.cx, FGridMainCellBodySize.cx);
  FGridMainCellGutterSize.cy := Max(FGridMainCellGutterSize.cy, FGridMainCellBodySize.cy);
  // get cols & rows count of body
  FGridMainColsBodyCount := (GridMain.Width - FGridMainCellGutterSize.cx) div FGridMainCellBodySize.cx + 1; // +lastcol
  FGridMainColsBodyCount := Min(FGridMainColsBodyCount, FCacheRgn.ColsCount);
  FGridMainRowsBodyCount := (GridMain.Height - FGridMainCellTitleSize.cy) div FGridMainCellBodySize.cy + 1; // +lastrow
  FGridMainRowsBodyCount := Min(FGridMainRowsBodyCount, FCacheRgn.RowsCount);
end;

procedure TfrData.RenderGridMain;
var
  FFitRgn: TRgn;
  Bar: Boolean;
  BarPos, BarMin, BarMax, BarPag: Integer;
begin
  if not View then
    Exit;
  if not (deGridMain in FRenders) then
    Exit;
  if not Assigned(FFit) then
  begin
    GridMain.ColCount := 1;
    GridMain.RowCount := 1;
    PanelMainScrollVer.Enabled := False;
    PanelMainScrollHor.Enabled := False;
    Exit;
  end;
  Exclude(FRenders, deGridMain);
  // set cols count & rows count
  GridMain.ColCount := FGridMainColsBodyCount + 1; // +gutter
  GridMain.RowCount := FGridMainRowsBodyCount + 1; // +title
  // set size (width & height) cells
  GridMain.DefaultColWidth := FGridMainCellBodySize.cx;
  GridMain.DefaultRowHeight := FGridMainCellBodySize.cy;
  GridMain.ColWidths[0] := FGridMainCellGutterSize.cx;
  GridMain.RowHeights[0] := FGridMainCellTitleSize.cy;
  // set scrollbars
  FFitRgn := FFit.DataRgn;
  Bar := FFitRgn.RowsCount > FGridMainRowsBodyCount;
  if Bar then
  begin
    BarPag := FGridMainRowsBodyCount;
    BarMin := FFitRgn.Y1;
    BarMax := FFitRgn.Y1 + FFitRgn.RowsCount - 1;
    BarPos := FCacheRgn.Y1;
    PanelMainScrollVer.SetParams(BarPos, BarMin, BarMax, BarPag);
  end;
  PanelMainScrollVer.Enabled := Bar;
  Bar := FFitRgn.ColsCount > FGridMainColsBodyCount;
  if Bar then
  begin
    BarPag := FGridMainColsBodyCount;
    BarMin := FFitRgn.X1;
    BarMax := FFitRgn.X1 + FFitRgn.ColsCount - 1;
    BarPos := FCacheRgn.X1;
    PanelMainScrollHor.SetParams(BarPos, BarMin, BarMax, BarPag);
  end;
  PanelMainScrollHor.Enabled := Bar;
end;

procedure TfrData.RenderInfo;
var
  Lines: array [6 .. 11] of string;
  S: string;
begin
  if not ViewMenu then
    Exit;
  if giInfo.HeightState = hsMini then
    Exit;
  if not (deInfo in FRenders) then
    Exit;
  Exclude(FRenders, deInfo);
  Lines[06] := 'Data offset: %d';
  Lines[07] := 'Data size in real (byte): %d';
  Lines[08] := 'Data size in file (byte): %d';
  Lines[09] := 'Data Rep recom: %s';
  Lines[10] := 'ColsCount: %d';
  Lines[11] := 'RowsCount: %d';
  if not Assigned(FFit) then
  begin
    S := LinesTxt(Lines, True);
  end
  else
  begin
    LinesFmt(Lines[06], [FFit.DataOffset]);
    LinesFmt(Lines[07], [FFit.StreamSizeData]);
    LinesFmt(Lines[08], [FFit.StreamSize - FFit.StreamSizeHead]);
    LinesFmt(Lines[09], [RepToStr(FRepDefault)]);
    LinesFmt(Lines[10], [FFit.DataRgn.ColsCount]);
    LinesFmt(Lines[11], [FFit.DataRgn.RowsCount]);
    S := LinesTxt(Lines);
  end;
  giInfoMemo.Lines.Text := FitHduCoreAsString + S;
end;

procedure TfrData.giFontAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
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

procedure TfrData.giFontCmbNameChangeDone(Sender: TLofiComboBox; AText: string);
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

procedure TfrData.giFontCmbSizeChangeDone(Sender: TLofiComboBox; AText: string);
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

procedure TfrData.giFontBtnMonospaceClick(Sender: TObject);
begin
  UpdateFont('Courier New', cFontSize.Min);
  Render;
end;

procedure TfrData.giFontBtnDefaultClick(Sender: TObject);
begin
  UpdateFont(cFontName.Def, cFontSize.Def);
  Render;
end;

procedure TfrData.InitFont;
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

procedure TfrData.UpdateFont(NewName: string; NewSize: Integer);
begin
  if NewName <> cFontName.Def then
    NewName := ifthen(giFontCmbName.Items.IndexOf(NewName) < 0, FFontName, NewName);
  if NewSize <> cFontSize.Def then
    NewSize := EnsureRange(NewSize, cFontSize.Min, cFontSize.Max);
  if (NewName <> FFontName) or (NewSize <> FFontSize) then
  begin
    FFontName := NewName;
    FFontSize := NewSize;
    Include(FUpdates, deFont);
  end;
  Include(FRenders, deFont);
end;

procedure TfrData.RenderFont;
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

procedure TfrData.giFormatAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
begin
  if Control = giFormatCmbStyle then
  begin
    NewWidth := AlignRect.Width - CtrlGap * 3 - Round(AlignRect.Width * 70 / 200);
    NewLeft := CtrlGap;
  end
  else if Control = giFormatCmbPrec then
  begin
    NewWidth := Round(AlignRect.Width * 70 / 200);
    NewLeft := AlignRect.Width - NewWidth - CtrlGap;
  end
  else if Control = giFormatBtnDefault then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end;
end;

procedure TfrData.giFormatCmbStyleChangeDone(Sender: TLofiComboBox; AText: string);
var
  S, NewStyle: string;
begin
  S := Trim(AText);
  if S = cFormatStyle.DefView then
    NewStyle := cFormatStyle.Def
  else
    NewStyle := S;
  UpdateFormat(NewStyle, FFormatPrec);
  Render;
end;

procedure TfrData.giFormatCmbPrecChangeDone(Sender: TLofiComboBox; AText: string);
var
  S: string;
  NewPrec: Integer;
begin
  S := Trim(AText);
  if S = cFormatPrec.DefView then
    NewPrec := cFormatPrec.Def
  else
    NewPrec := StrToIntDef(S, FFormatPrec);
  UpdateFormat(FFormatStyle, NewPrec);
  Render;
end;

procedure TfrData.giFormatBtnDefaultClick(Sender: TObject);
begin
  UpdateFormat(cFormatStyle.Def, cFormatPrec.Def);
  Render;
end;

procedure TfrData.InitFormat;
var
  I: Integer;
begin
  if giFormatCmbStyle.Items.IndexOf(FFormatStyle) < 0 then
    FFormatStyle := cFormatStyle.Def;
  giFormatCmbPrec.Items.BeginUpdate;
  for I := cFormatPrec.Min to cFormatPrec.Max do
    giFormatCmbPrec.Items.Add(IntToStr(I));
  giFormatCmbPrec.Items.EndUpdate;
  if FFormatPrec <> cFormatPrec.Def then
    FFormatPrec := EnsureRange(FFormatPrec, cFormatPrec.Min, cFormatPrec.Max);
end;

procedure TfrData.UpdateFormat(NewStyle: string; NewPrec: Integer);
begin
  if NewStyle <> cFormatStyle.Def then
    NewStyle := IfThen(giFormatCmbStyle.Items.IndexOf(NewStyle) < 0, FFormatStyle, NewStyle);
  if NewPrec <> cFormatPrec.Def then
    NewPrec := EnsureRange(NewPrec, cFormatPrec.Min, cFormatPrec.Max);
  if (NewStyle <> FFormatStyle) or (NewPrec <> FFormatPrec) then
  begin
    FFormatStyle := NewStyle;
    FFormatPrec := NewPrec;
    Include(FUpdates, deFormat);
  end;
  Include(FRenders, deFormat);
end;

procedure TfrData.RenderFormat;
begin
  if not ViewMenu then
    Exit;
  if giFormat.HeightState = hsMini then
    Exit;
  if not (deFormat in FRenders) then
    Exit;
  Exclude(FRenders, deFormat);
  giFormatCmbStyle.Text := ifthen(FFormatStyle = cFormatStyle.Def, cFormatStyle.DefView, FFormatStyle);
  giFormatCmbPrec.Text := ifthen(FFormatPrec = cFormatPrec.Def, cFormatPrec.DefView, IntToStr(FFormatPrec));
end;

procedure TfrData.giNavigAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
var
  W: Integer;
begin
  W := EnsureRange(Round(AlignRect.Width * 70 / 200), 40, 120);
  if (Control = giNavigEditX) or (Control = giNavigEditW) then
  begin
    NewWidth := W;
    NewLeft := (AlignRect.Width - CtrlGap) div 2 - NewWidth;
  end
  else if (Control = giNavigEditY) or (Control = giNavigEditH) then
  begin
    NewWidth := W;
    NewLeft := (AlignRect.Width + CtrlGap) div 2;
  end
  else if (Control = giNavigLabelX) or (Control = giNavigLabelW) then
  begin
    NewLeft := (AlignRect.Width - CtrlGap) div 2 - W - CtrlGap div 2 - NewWidth;
  end
  else if (Control = giNavigLabelY) or (Control = giNavigLabelH) then
  begin
    NewLeft := (AlignRect.Width + CtrlGap) div 2 + W + CtrlGap div 2;
  end
  else if (Control = giNavigBtnT) or (Control = giNavigBtnB) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end
  else if (Control = giNavigBtnL) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2 - NewWidth;
  end
  else if (Control = giNavigBtnR) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2 + NewWidth;
  end;
end;

procedure TfrData.giNavigEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if (Sender as TEdit).Name = 'giNavigEditX' then
      giNavigEditY.SetFocus
    else
      giNavigBtnClick(Sender);
  end;
end;

procedure TfrData.giNavigBtnClick(Sender: TObject);
var
  NewX1, NewY1: Integer;
begin
  NewX1 := FCacheRgn.X1;
  NewY1 := FCacheRgn.Y1;
  case (Sender as TComponent).Tag of
    00: // position, see giNavigEditKeyDown()
      begin
        NewX1 := StrToIntDef(giNavigEditX.Text, NewX1);
        NewY1 := StrToIntDef(giNavigEditY.Text, NewY1);
      end;
    10: Dec(NewX1); // left
    20: Dec(NewY1); // top
    30: Inc(NewX1); // right
    40: Inc(NewY1); // bottom
  end;
  UpdateNavig(NewX1, NewY1);
  Render;
end;

procedure TfrData.MatchNavig;
begin
  if [deFont, deFormat, deNavig] * FUpdates  <> [] then
    Include(FRenders, deNavig);
end;

procedure TfrData.UpdateNavig(NewX1, NewY1: Integer);
var
  FFitRgn: TRgn;
begin
  FFitRgn := FFit.DataRgn;
  if NewX1 <> FCacheRgn.X1 then
    NewX1 := EnsureRange(NewX1, FFitRgn.X1, FFitRgn.X1 + FFitRgn.ColsCount - 1);
  if NewY1 <> FCacheRgn.Y1 then
    NewY1 := EnsureRange(NewY1, FFitRgn.Y1, FFitRgn.Y1 + FFitRgn.RowsCount - 1);
  if (NewX1 <> FCacheRgn.X1) or (NewY1 <> FCacheRgn.Y1) then
  begin
    FCacheRgn.X1 := NewX1;
    FCacheRgn.Y1 := NewY1;
    Include(FUpdates, deNavig);
  end;
  Include(FRenders, deNavig);
end;

procedure TfrData.RenderNavig;
var
  R: TRgn;
begin
  if not ViewMenu then
    Exit;
  if giNavig.HeightState = hsMini then
    Exit;
  if not (deNavig in FRenders) then
    Exit;
  Exclude(FRenders, deNavig);
  if not Assigned(FFit) then
  begin
    giNavigEditX.Text := '';
    giNavigEditY.Text := '';
    giNavigEditW.Text := '';
    giNavigEditH.Text := '';
    Exit;
  end;
  R := GetGridMainRegion;
  giNavigEditX.Text := IntToStr(R.X1);
  giNavigEditY.Text := IntToStr(R.Y1);
  giNavigEditW.Text := IntToStr(R.Width);
  giNavigEditH.Text := IntToStr(R.Height);
end;

procedure TfrData.giCopyMiOptClick(Sender: TObject);
begin
  CopyOpt;
end;

procedure TfrData.CopyOpt;
var
  Row, Row1, Row2: Integer;
  Col, Col1, Col2: Integer;
  S: string;
begin
  with GridMain.Selection do
  begin
    Row1 := Top;
    Row2 := Bottom;
    Col1 := Left;
    Col2 := Right;
  end;
  S := '';
  for Row := Row1 to Row2 do
  begin
    for Col := Col1 to Col2 do
      S := S + DeLaFitsString.FloatToStri(FCache[Col - 1, Row - 1], False, FGridMainCellBodyFormat) + LinesItemDelim;
    Delete(S, Length(S), 1);
    S := S + sLineBreak;
  end;
  Clipboard.AsText := S;
end;

procedure TfrData.giConvertAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
var
  W: Integer;
begin
  W := Round(AlignRect.Width * 163 / 200);
  if (Control = giConvertCmbRgn) or (Control = giConvertCmbRep) or (Control = giConvertEditOut) then
  begin
    NewWidth := W;
    NewLeft := AlignRect.Width - (NewWidth + CtrlGap);
  end
  else if (Control = giConvertLabelRgn) or (Control = giConvertLabelRep) or (Control = giConvertLabelOut) then
  begin
    NewLeft := AlignRect.Width - (W + CtrlGap) - CtrlGap div 2 - NewWidth;
  end;
end;

procedure TfrData.giConvertEditOutRightButtonClick(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
  begin
    Title := giConvertEditOut.RightButton.Hint;
    if Execute then
      giConvertEditOut.Text := FileName;
    Free;
  end;
end;

procedure TfrData.giConvertBtnStartClick(Sender: TObject);
begin
  FSubWin.Progress(ConvertStart, ConvertExec, ConvertStop);
end;

procedure TfrData.InitConvert;
  procedure giConvertCmbRep_Items_Add(Rep: TRep);
  begin
    giConvertCmbRep.Items.AddObject(RepToStr(Rep), TObject(Rep));
  end;
begin
  giConvertCmbRgn.Text := '';
  giConvertCmbRep.Items.BeginUpdate;
  giConvertCmbRep_Items_Add(rep08u);
  giConvertCmbRep_Items_Add(rep16c);
  giConvertCmbRep_Items_Add(rep16u);
  giConvertCmbRep_Items_Add(rep32c);
  giConvertCmbRep_Items_Add(rep32u);
  giConvertCmbRep_Items_Add(rep64c);
  giConvertCmbRep_Items_Add(rep32f);
  giConvertCmbRep_Items_Add(rep64f);
  giConvertCmbRep.Text := '';
  giConvertCmbRep.Items.EndUpdate;
  giConvertEditOut.Text := '';
end;

procedure TfrData.MatchConvert;
begin
  if deNavig in FUpdates then
    Include(FRenders, deConvert);
end;

procedure TfrData.RenderConvert;
begin
  if not ViewMenu then
    Exit;
  if giConvert.HeightState = hsMini then
    Exit;
  if not (deConvert in FRenders) then
    Exit;
  Exclude(FRenders, deConvert);
  giConvertCmbRgn.Items.BeginUpdate;
  if not Assigned(FFit) then
  begin
    giConvertCmbRgn.Items[0] := '0; 0; 0; 0';
    giConvertCmbRgn.Items[1] := '0; 0; 0; 0';
  end
  else
  begin
    giConvertCmbRgn.Items[0] := RgnToStr(GetGridMainRegion);
    giConvertCmbRgn.Items[1] := RgnToStr(FFit.DataRgn);
  end;
  giConvertCmbRgn.Items.EndUpdate;
  giConvertCmbRep.Hint := giConvertCmbRep.Hint + LineEnding + 'Recommended ' + RepToStr(FRepDefault);
end;

procedure TfrData.ConvertStart(var AState: TProgressState; var AParams: TProgressParams);
var
  EMsgHeader: string;

  procedure PutRgn;
  var
    List: TStringList;
    S: string;
  begin
    EMsgHeader := '';
    S := giConvertCmbRgn.Text;
    S := Trim(S);
    if S = '' then
      raise ELooDataException.Create('Please, input region data');
    EMsgHeader := 'Input region (%s) is incorrect!' + LineEnding + 'Format: (X; Y; Width; Height)' + LineEnding + 'Example: (%s)' + LineEnding +  '---';
    EMsgHeader := Format(EMsgHeader, [S, giConvertCmbRgn.Items[0]]);
    List := TStringList.Create;
    try
      List.Delimiter := ';';
      List.DelimitedText := S;
      if List.Count <> 4 then
        raise ELooDataException.Create('Input string must contain four elements: X, Y, Width and Height');
      FConvertRgn.X1 := StrToInt(List[0]);
      FConvertRgn.Y1 := StrToInt(List[1]);
      FConvertRgn.ColsCount := StrToInt(List[2]);
      FConvertRgn.RowsCount := StrToInt(List[3]);
      if (FConvertRgn.X1 < 0) or (FConvertRgn.Y1 < 0) then
        raise ELooDataException.Create('Coordinates (X, Y) of the region' +
                          LineEnding + 'should be greater than or equal to zero!');
      if (FConvertRgn.ColsCount <= 0) or (FConvertRgn.RowsCount <= 0) then
        raise ELooDataException.Create('Size (Width, Height) of the region' +
                          LineEnding + 'must be greater than zero!');
      if not DeLaFitsCommon.RgnIsIncluded(FFit.DataRgn, FConvertRgn) then
        raise ELooDataException.CreateFmt('Input region isn''t inscribed in' +
                             LineEnding + 'general region of data:' +
                             LineEnding + '(%s) is not included in (%s)',
                             [RgnToStr(FConvertRgn), RgnToStr(FFit.DataRgn)]);
    finally
      List.Free;
    end;
  end;

  procedure PutRow;
  begin
    EMsgHeader := '';
    FConvertRow := FConvertRgn.Y1;
  end;

  procedure PutRep;
  var
    Index: Integer;
  begin
    EMsgHeader := '';
    Index := giConvertCmbRep.ItemIndex;
    if Index < 0 then
      raise ELooDataException.CreateFmt('Input representation "%s" is incorrect!' +
                        LineEnding + 'Please, select data representation',
                        [giConvertCmbRep.Text]);
    FConvertRep := TRep(giConvertCmbRep.Items.Objects[Index]);
  end;

  procedure PutFile;
  var
    S: string;
  begin
    EMsgHeader := '';
    S := giConvertEditOut.Text;
    S := Trim(S);
    if S = '' then
      raise ELooDataException.Create('Please, input name output file');
    S := ExpandFileName(S);
    if AnsiLowerCase(S) = AnsiLowerCase(ExpandFileName(FFit.StreamFileName)) then
      raise ELooDataException.Create('Input name of output file' + LineEnding + 'matches of name of the fits-file');
    EMsgHeader := 'Input name of output file is incorrect!';
    FConvertFile := TFileStream.Create(S, fmCreate);
  end;

  procedure PutBuf;
  var
    N: Integer;
  begin
    EMsgHeader := '';
    N := FConvertRgn.ColsCount;
    with FConvertBuf do
      case FConvertRep of
        rep08u: begin SetLength(A08u2, N, 1); SetLength(A08u1, N); end;
        rep16c: begin SetLength(A16c2, N, 1); SetLength(A16c1, N); end;
        rep16u: begin SetLength(A16u2, N, 1); SetLength(A16u1, N); end;
        rep32c: begin SetLength(A32c2, N, 1); SetLength(A32c1, N); end;
        rep32u: begin SetLength(A32u2, N, 1); SetLength(A32u1, N); end;
        rep64c: begin SetLength(A64c2, N, 1); SetLength(A64c1, N); end;
        rep32f: begin SetLength(A32f2, N, 1); SetLength(A32f1, N); end;
        rep64f: begin SetLength(A64f2, N, 1); SetLength(A64f1, N); end;
      end;
  end;

begin
  EMsgHeader := '';
  AParams.Text1 := 'Data convert';
  try
    PutRgn;
    PutRow;
    PutRep;
    PutFile;
    PutBuf;
  except
    on E: Exception do
    begin
      AState := psExcept;
      if EMsgHeader <> '' then
        EMsgHeader := EMsgHeader + LineEnding;
      AParams.Text2 := EMsgHeader + E.Message;
    end;
  end;
end;

procedure TfrData.ConvertExec(var AState: TProgressState; var AParams: TProgressParams);

  procedure Conv08u(var A1: TA08u1; var A2: TA08u2; const R2: TRgn);
  var
    I: Integer;
  begin
    FFit.DataRead(Pointer(A2), R2);
    for I := 0 to R2.ColsCount - 1 do
      A1[I] := A2[I, 0];
    FConvertFile.Seek((FConvertRow - FConvertRgn.Y1) * FConvertRgn.ColsCount * SizeOf(A1[0]), soFromBeginning);
    FConvertFile.WriteBuffer(A1[0], R2.ColsCount * SizeOf(A1[0]));
  end;

  procedure Conv16c(var A1: TA16c1; var A2: TA16c2; const R2: TRgn);
  var
    I: Integer;
  begin
    FFit.DataRead(Pointer(A2), R2);
    for I := 0 to R2.ColsCount - 1 do
      A1[I] := A2[I, 0];
    FConvertFile.Seek((FConvertRow - FConvertRgn.Y1) * FConvertRgn.ColsCount * SizeOf(A1[0]), soFromBeginning);
    FConvertFile.WriteBuffer(A1[0], R2.ColsCount * SizeOf(A1[0]));
  end;

  procedure Conv16u(var A1: TA16u1; var A2: TA16u2; const R2: TRgn);
  var
    I: Integer;
  begin
    FFit.DataRead(Pointer(A2), R2);
    for I := 0 to R2.ColsCount - 1 do
      A1[I] := A2[I, 0];
    FConvertFile.Seek((FConvertRow - FConvertRgn.Y1) * FConvertRgn.ColsCount * SizeOf(A1[0]), soFromBeginning);
    FConvertFile.WriteBuffer(A1[0], R2.ColsCount * SizeOf(A1[0]));
  end;

  procedure Conv32c(var A1: TA32c1; var A2: TA32c2; const R2: TRgn);
  var
    I: Integer;
  begin
    FFit.DataRead(Pointer(A2), R2);
    for I := 0 to R2.ColsCount - 1 do
      A1[I] := A2[I, 0];
    FConvertFile.Seek((FConvertRow - FConvertRgn.Y1) * FConvertRgn.ColsCount * SizeOf(A1[0]), soFromBeginning);
    FConvertFile.WriteBuffer(A1[0], R2.ColsCount * SizeOf(A1[0]));
  end;

  procedure Conv32u(var A1: TA32u1; var A2: TA32u2; const R2: TRgn);
  var
    I: Integer;
  begin
    FFit.DataRead(Pointer(A2), R2);
    for I := 0 to R2.ColsCount - 1 do
      A1[I] := A2[I, 0];
    FConvertFile.Seek((FConvertRow - FConvertRgn.Y1) * FConvertRgn.ColsCount * SizeOf(A1[0]), soFromBeginning);
    FConvertFile.WriteBuffer(A1[0], R2.ColsCount * SizeOf(A1[0]));
  end;

  procedure Conv64c(var A1: TA64c1; var A2: TA64c2; const R2: TRgn);
  var
    I: Integer;
  begin
    FFit.DataRead(Pointer(A2), R2);
    for I := 0 to R2.ColsCount - 1 do
      A1[I] := A2[I, 0];
    FConvertFile.Seek((FConvertRow - FConvertRgn.Y1) * FConvertRgn.ColsCount * SizeOf(A1[0]), soFromBeginning);
    FConvertFile.WriteBuffer(A1[0], R2.ColsCount * SizeOf(A1[0]));
  end;

  procedure Conv32f(var A1: TA32f1; var A2: TA32f2; const R2: TRgn);
  var
    I: Integer;
  begin
    FFit.DataRead(Pointer(A2), R2);
    for I := 0 to R2.ColsCount - 1 do
      A1[I] := A2[I, 0];
    FConvertFile.Seek((FConvertRow - FConvertRgn.Y1) * FConvertRgn.ColsCount * SizeOf(A1[0]), soFromBeginning);
    FConvertFile.WriteBuffer(A1[0], R2.ColsCount * SizeOf(A1[0]));
  end;

  procedure Conv64f(var A1: TA64f1; var A2: TA64f2; const R2: TRgn);
  var
    I: Integer;
  begin
    FFit.DataRead(Pointer(A2), R2);
    for I := 0 to R2.ColsCount - 1 do
      A1[I] := A2[I, 0];
    FConvertFile.Seek((FConvertRow - FConvertRgn.Y1) * FConvertRgn.ColsCount * SizeOf(A1[0]), soFromBeginning);
    FConvertFile.WriteBuffer(A1[0], R2.ColsCount * SizeOf(A1[0]));
  end;

const
  Imax = 5; // number of repeats
var
  I: Integer;
  Stop: Boolean;
  Rgn: TRgn;
  ProgressValu: Double;
  ProgressPrec: Integer;
begin
  I := 0;
  Stop := False;
  while (not Stop) and (I < Imax) do
  begin
    Rgn := ToRgnCoRo(FConvertRgn.X1, FConvertRow, FConvertRgn.ColsCount, 1);
    FFit.DataRep := FConvertRep;
    with FConvertBuf do
      case FConvertRep of
        rep08u: Conv08u(A08u1, A08u2, Rgn);
        rep16c: Conv16c(A16c1, A16c2, Rgn);
        rep16u: Conv16u(A16u1, A16u2, Rgn);
        rep32c: Conv32c(A32c1, A32c2, Rgn);
        rep32u: Conv32u(A32u1, A32u2, Rgn);
        rep64c: Conv64c(A64c1, A64c2, Rgn);
        rep32f: Conv32f(A32f1, A32f2, Rgn);
        rep64f: Conv64f(A64f1, A64f2, Rgn);
      end;
    Inc(FConvertRow);
    Stop := FConvertRow > FConvertRgn.Y1 + FConvertRgn.RowsCount - 1;
    Inc(I);
  end;
  if Stop then
  begin
    AState := psStop;
    AParams.Value := 100;
    AParams.Legend := '100%';
  end
  else
  begin
    ProgressValu := 100 * (FConvertRow - FConvertRgn.Y1) / FConvertRgn.RowsCount;
    if FConvertRgn.RowsCount <= 1000 then
      ProgressPrec := 0
    else if FConvertRgn.RowsCount <= 10000 then
      ProgressPrec := 1
    else
      ProgressPrec := 2;
    AParams.Value := Round(ProgressValu);
    AParams.Legend := DeLaFitsString.FloatToStri(ProgressValu, False, 1, ProgressPrec) + '%';
  end;
end;

procedure TfrData.ConvertStop(const AState: TProgressState; var AParams: TProgressParams);
var
  FileName: string;
begin
  if AState = psStop then
    if Assigned(FConvertFile) then
      AParams.Text2 := AParams.Text2 + LineEnding + 'Out: ' + FConvertFile.FileName;
  // free convert resources
  FConvertRgn := ToRgnCoRo(0, 0, 0, 0);
  FConvertRow := -1;
  FConvertRep := repUnknown;
  if Assigned(FConvertFile) then
  begin
    FileName := FConvertFile.FileName;
    FreeAndNil(FConvertFile);
    if AState <> psStop then
      TFile.Delete(FileName);
  end;
  with FConvertBuf do
  begin
    A08u1 := nil; A08u2 := nil;
    A16c1 := nil; A16c2 := nil;
    A16u1 := nil; A16u2 := nil;
    A32c1 := nil; A32c2 := nil;
    A32u1 := nil; A32u2 := nil;
    A64c1 := nil; A64c2 := nil;
    A32f1 := nil; A32f2 := nil;
    A64f1 := nil; A64f2 := nil;
  end;
end;

end.


