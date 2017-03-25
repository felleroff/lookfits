{ **************************************************** }
{  LookFits - Lister plugin (WLX) for view FITS files  }
{                                                      }
{    Frame of the render of data block of fits-file    }
{                       as image                       }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit ufrImage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types,
  System.UITypes, System.Math, System.Classes, Vcl.Graphics, Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus,
  Vcl.StdCtrls, Vcl.Clipbrd, Vcl.ExtCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.Grids,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart,
  VCLTee.Series, ufrBase, Lofi.ExtCtrls, uProfile, uUtils, ufmWinProgress,
  DeLaFitsCommon, DeLaFitsString, DeLaFitsMath, DeLaFitsPalettes,
  DeLaFitsGraphics;

type

  TDebt = (deGridHead, deImgScn, deInfo, deGline, deNavig, deGeom, deTone, dePal, deHim);
  TDebts = set of TDebt;

  { TfrImage }

  TfrImage = class(TfrBase)

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

  // Set Fit property
  private
    procedure MatchFit;

  // GridHead
  published
    GridHead: TDrawGrid;
    procedure GridHeadDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure GridHeadMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
    procedure GridHeadMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
  private const
    cGridHeadColumnsCount = 3;
  private
    FGridHeadColumnsValue: array [0 .. cGridHeadColumnsCount - 1] of string;
    procedure InitGridHead;
    procedure MatchGridHead;
    procedure RenderGridHeadCur(ImgScnCur: TPoint);
    procedure RenderGridHead;

  // ImgScn
  published
    ImgScn: TImage;
    ImgScnMov: TImage;
    ImgScnSel: TShape;
    ImgScnSelHint: TLabel;
    procedure ImgScnScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
    procedure ImgScnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgScnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure ImgScnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgScnSelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ImgScnSelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  private const
    cImgStockBrd = 20;
  private
    FImgPix: TPix; // pixel of ImgScn for mode of moved and selected
    FImgScn: TRgn;
    procedure InitImgScn;
    procedure MatchImgScn;
    procedure RenderImgScn1; // render fit-layer
    procedure RenderImgScn2; // render gline-layer
    procedure RenderImgScn3; // render scroll-layer
    procedure RenderImgScn;

  // Info
  private
    procedure MatchInfo;
    procedure RenderInfo;

  // Gline
  published
    giGline: TLofiGroupItem;
    giGlineBtnMesh: TSpeedButton;
    giGlineBtnAxis: TSpeedButton;
    giGlineBtnScen: TSpeedButton;
    giGlineBtnMarks: TSpeedButton;
    giGlineBtnColor: TSpeedButton;
    giGlineBtnDefault: TSpeedButton;
    procedure giGlineAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giGlineBtnKindClick(Sender: TObject);
    procedure giGlineBtnMarksClick(Sender: TObject);
    procedure giGlineBtnColorClick(Sender: TObject);
    procedure giGlineBtnDefaultClick(Sender: TObject);
  private type
    TGline = (glNone, glMesh, glAxis, glScen);
  private const
    cGlineDef: TGline = glMesh;
    cGlineMarksDef: Boolean = False;
    cGlineColorDef: TColor = clRed;
  private
    FGline: TGline;
    FGlineMarks: Boolean;
    FGlineColor: TColor;
    procedure UpdateGline(NewGline: TGline; NewGlineMarks: Boolean; NewGlineColor: TColor);
    procedure RenderGline;

  // Navigation
  published
    giNavig: TLofiGroupItem;
    giNavigScnLabelX: TLabel;
    giNavigScnLabelY: TLabel;
    giNavigScnLabelW: TLabel;
    giNavigScnLabelH: TLabel;
    giNavigScnEditX: TEdit;
    giNavigScnEditY: TEdit;
    giNavigScnEditW: TEdit;
    giNavigScnEditH: TEdit;
    giNavigFrmLabelX: TLabel;
    giNavigFrmLabelY: TLabel;
    giNavigFrmEditX: TEdit;
    giNavigFrmEditY: TEdit;
    giNavigImg: TImage;
    giNavigScnBtnL: TSpeedButton;
    giNavigScnBtnT: TSpeedButton;
    giNavigScnBtnB: TSpeedButton;
    giNavigScnBtnR: TSpeedButton;
    procedure giNavigAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giNavigFrmEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure giNavigScnEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure giNavigScnBtnClick(Sender: TObject);
    procedure giNavigImgClick(Sender: TObject);
  private
    FNavigImg: TMatrix; // geometry of aiNavigImg
    procedure UpdateNavig(NewX1, NewY1: Integer); overload;
    procedure UpdateNavig(NewX1, NewY1: Double); overload;
    procedure RenderNavig;

  // Geometry
  published
    giGeom: TLofiGroupItem;
    giGemCmbScl: TLofiComboBox;
    giGemCmbRot: TLofiComboBox;
    giGemBtnSclDec: TSpeedButton;
    giGemBtnSclInc: TSpeedButton;
    giGemBtnRotDec: TSpeedButton;
    giGemBtnRotInc: TSpeedButton;
    giGemBtnFlipLR: TSpeedButton;
    giGemBtnFlipTD: TSpeedButton;
    giGemBtnDefault: TSpeedButton;
    procedure giGeomAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giGeomBtnSclClick(Sender: TObject);
    procedure giGemCmbSclChangeDone(Sender: TLofiComboBox; AText: string);
    procedure giGeomBtnRotClick(Sender: TObject);
    procedure giGemCmbRotChangeDone(Sender: TLofiComboBox; AText: string);
    procedure giGeomBtnFlipClick(Sender: TObject);
    procedure giGeomBtnDefaultClick(Sender: TObject);
  private const
    cGeomScl: DoubleFix = (Min: 0.05; Max: 10.0; Def: 1.0);
    cGeomRotDef: Double = 000.0;
    cGeomMirDef: BooleanXY = (X: False; Y: False);
  private
    FGeomScl: Double;
    FGeomRot: Double;
    FGeomMir: BooleanXY;
    procedure InitGeom;
    procedure UpdateGeom(NewScl, NewRot: Double; NewMir: BooleanXY);
    procedure RenderGeom;

  // Tone
  published
    giTone: TLofiGroupItem;
    giToneTrackBrightness: TLofiTrackBar;
    giToneTrackContrast: TLofiTrackBar;
    giToneTrackGamma: TLofiTrackBar;
    giToneIconBrightness: TImage;
    giToneIconContrast: TImage;
    giToneIconGamma: TImage;
    giToneLabelBrightness: TLabel;
    giToneLabelContrast: TLabel;
    giToneLabelGamma: TLabel;
    giToneBtnDefault: TSpeedButton;
    procedure giToneAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giToneTrackChangeDone(Sender: TObject);
    procedure giToneBtnDefaultClick(Sender: TObject);
  private const
    cToneBrightness: DoubleFix = (Min: cBrightnessMin; Max: cBrightnessMax; Def: cBrightnessDef); // [-1.0 ; +1.0], ~0.0
    cToneContrast: DoubleFix = (Min: cContrastMin; Max: cContrastMax; Def: cContrastDef);         // (+0.0 ; +3.0], ~1.0
    cToneGamma: DoubleFix = (Min: cGammaMin; Max: cGammaMax; Def: cGammaDef);                     // (+0.0 ; +3.0], ~1.0
  private
    FToneBrightness: Double;
    FToneContrast: Double;
    FToneGamma: Double;
    procedure InitTone;
    procedure UpdateTone(NewBrightness, NewContrast, NewGamma: Double);
    procedure RenderTone;

  // Palette
  published
    giPal: TLofiGroupItem;
    giPalImg: TImage;
    giPalCmbValue: TLofiComboBox;
    giPalBtnOrder: TSpeedButton;
    giPalBtnDefault: TSpeedButton;
    procedure giPalAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giPalCmbValueChangeDone(Sender: TLofiComboBox; AText: string);
    procedure giPalBtnOrderClick(Sender: TObject);
    procedure giPalBtnDefaultClick(Sender: TObject);
  private const
    cPalDef: PPalette = @DeLaFitsPalettes.cPalGrayScale; // =cPaletteGrayScale, [dcc32 Error] E2026 Constant expression expected
    cPalOrderDef: TPaletteOrder = palDirect;
  private
    FPal: PPalette;
    FPalOrder: TPaletteOrder;
    procedure InitPal;
    procedure UpdatePal(NewPal: PPalette; NewPalOrder: TPaletteOrder);
    procedure RenderPal;

  // Histogram
  published
    giHim: TLofiGroupItem;
    giHimChart: TChart;
    giHimChartBarSeries: TBarSeries;
    giHimEditVal1: TEdit;
    giHimEditVal2: TEdit;
    giHimEditInd1: TEdit;
    giHimEditInd2: TEdit;
    giHimBtnDec: TSpeedButton;
    giHimBtnDec1: TSpeedButton;
    giHimBtnInc1: TSpeedButton;
    giHimBtnDec2: TSpeedButton;
    giHimBtnInc2: TSpeedButton;
    giHimBtnInc: TSpeedButton;
    giHimBtnDefault: TSpeedButton;
    procedure giHimAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure giHimChartScroll(Sender: TObject);
    procedure giHimChartMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure giHimEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure giHimBtnRangeClick(Sender: TObject);
    procedure giHimBtnDefaultClick(Sender: TObject);
  private const
    cHimDef: THimNorm = (Index1: 0.0; Index2: 0.0);
  private
    FHim: THimNorm;
    FHimScroll: Boolean;
    procedure UpdateHim(NewHim: THimNorm);
    procedure RenderHim;

  // Copy
  published
    giCopyMiOpt: TMenuItem;
    procedure giCopyMiOptClick(Sender: TObject);
  private
    procedure CopyOpt;

  // Save
  published
    giSaveMiOpt: TMenuItem;
    procedure giSaveMiOptClick(Sender: TObject);
  private
    FSaveFilterIndex: Integer;
    procedure SaveOpt;

  end;

implementation

{$R *.dfm}

function GetFullDebts: TDebts; inline;
begin
  Result := [Low(TDebt) .. High(TDebt)];
end;

{ TfrImage }

procedure TfrImage.giChangeHeightState(Sender: TLofiGroupItem);
begin
  if not ViewMenu then
    Exit;
  if Sender.HeightState = hsMini then
    Exit;
  Render;
end;

procedure TfrImage.BeginRender;
begin
end;

procedure TfrImage.EndRender;
begin
  if not Blocked then
    GridHead.SetFocus;
end;

procedure TfrImage.ChangeSize;
begin
  Include(FUpdates, deImgScn);
  Include(FRenders, deGridHead);
  if View then
    Render;
end;

constructor TfrImage.Create(AOwner: TComponent; TheDockSitePanelMain, TheDockSitePanelMenu: TWinControl; TheSubWin: ISubWin);
var
  I: Integer;
begin
  inherited Create(AOwner, TheDockSitePanelMain, TheDockSitePanelMenu, TheSubWin);
  FUpdates := GetFullDebts;
  FRenders := GetFullDebts;
  for I := 0 to cGridHeadColumnsCount - 1 do FGridHeadColumnsValue[I] := '';
  FImgPix := ToPix(0, 0);
  FImgScn := ToRgnWiHe(0, 0, 0, 0);
  FGline := cGlineDef;
  FGlineMarks := cGlineMarksDef;
  FGlineColor := cGlineColorDef;
  FNavigImg := MatrixInit;
  FGeomScl := cGeomScl.Def;
  FGeomRot := cGeomRotDef;
  FGeomMir := cGeomMirDef;
  FToneBrightness := cToneBrightness.Def;
  FToneContrast := cToneContrast.Def;
  FToneGamma := cToneGamma.Def;
  FPal := cPalDef;
  FPalOrder := cPalOrderDef;
  FHim := cHimDef;
  FHimScroll := False;
  FSaveFilterIndex := 1;
end;

destructor TfrImage.Destroy;
begin
  inherited;
end;

procedure TfrImage.FrameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  case Key of
    // Gline: mode
    vkG:
      if Shift = [] then
      begin
        Key := 0;
        UpdateGline(TGline(EnsureRing(Integer(FGline) + 1, Integer(Low(TGline)), Integer(High(TGline)))), FGlineMarks, FGlineColor);
        Render;
      end;
    // Gline: marks
    vkM:
      if Shift = [] then
      begin
        Key := 0;
        UpdateGline(FGline, not FGlineMarks, FGlineColor);
        Render;
      end;
    // Navigation: left
    vkA:
      if Shift = [] then
      begin
        Key := 0;
        giNavigScnBtnL.Click;
      end;
    // Navigation: top
    vkW:
      if Shift = [] then
      begin
        Key := 0;
        giNavigScnBtnT.Click;
      end;
    // Navigation: right
    vkD:
      if Shift = [] then
      begin
        Key := 0;
        giNavigScnBtnR.Click;
      end;
    // Navigation: bottom & Save
    vkS:
      if Shift = [] then
      begin
        Key := 0;
        giNavigScnBtnB.Click;
      end
      else if (Shift = [ssCtrl]) and (Sender is TDrawGrid) then
      begin
        Key := 0;
        SaveOpt;
      end;
    // Geometry: scale & rotation
    VK_ADD:
      if Shift = [] then
      begin
        Key := 0;
        giGemBtnSclInc.Click;
      end
      else if Shift = [ssCtrl] then
      begin
        Key := 0;
        giGemBtnRotInc.Click;
      end;
    VK_SUBTRACT:
      if Shift = [] then
      begin
        Key := 0;
        giGemBtnSclDec.Click;
      end
      else if Shift = [ssCtrl] then
      begin
        Key := 0;
        giGemBtnRotDec.Click;
      end;
    // Geometry: scale, fit to window
    vkF:
      if Shift = [] then
      begin
        Key := 0;
        giGemCmbScl.Text := 'Fit';
        giGemCmbSclChangeDone(giGemCmbScl, giGemCmbScl.Text);
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

procedure TfrImage.ReadProfile;
var
  Section: string;
begin
  inherited;
  Section := ProfileSection;
  FImgScn.X1 := Profile.ReadInteger(Section, 'ImgScn.X1', FImgScn.X1);
  FImgScn.Y1 := Profile.ReadInteger(Section, 'ImgScn.Y1', FImgScn.Y1);
  FGline := TGline(Profile.ReadInteger(Section, 'Gline', Integer(Low(TGline)), Integer(High(TGline)), Integer(FGline)));
  FGlineMarks := Profile.ReadBool(Section, 'GlineMarks', FGlineMarks);
  FGlineColor := TColor(Profile.ReadInteger(Section, 'GlineColor', Integer(FGlineColor)));
  FGeomScl := Profile.ReadFloat(Section, 'GeomScl', cGeomScl.Min, cGeomScl.Max, FGeomScl);
  FGeomRot := Profile.ReadFloat(Section, 'GeomRot', 0.0, 359.99, FGeomRot);
  FGeomMir.X := Profile.ReadBool(Section, 'GeomMir.X', FGeomMir.X);
  FGeomMir.Y := Profile.ReadBool(Section, 'GeomMir.Y', FGeomMir.Y);
  FToneBrightness := Profile.ReadFloat(Section, 'ToneBrightness', cToneBrightness.Min, cToneBrightness.Max, FToneBrightness);
  FToneContrast := Profile.ReadFloat(Section, 'ToneContrast', cToneContrast.Min, cToneContrast.Max, FToneContrast);
  FToneGamma := Profile.ReadFloat(Section, 'ToneGamma', cToneGamma.Min, cToneGamma.Max, FToneGamma);
  // FPal := Profile.ReadString(Section, 'Pal', ...); see InitPal();
  FPalOrder := TPaletteOrder(Profile.ReadInteger(Section, 'PalOrder', Integer(Low(TPaletteOrder)), Integer(High(TPaletteOrder)), Integer(FPalOrder)));
  FHim.Index1 := Profile.ReadFloat(Section, 'Him.Index1', FHim.Index1);
  FHim.Index2 := Profile.ReadFloat(Section, 'Him.Index2', FHim.Index2);
  FSaveFilterIndex := Profile.ReadInteger(Section, 'SaveFilterIndex', FSaveFilterIndex);
end;

procedure TfrImage.WriteProfile;
var
  Section: string;
begin
  inherited;
  Section := ProfileSection;
  Profile.WriteInteger(Section, 'ImgScn.X1', FImgScn.X1);
  Profile.WriteInteger(Section, 'ImgScn.Y1', FImgScn.Y1);
  Profile.WriteInteger(Section, 'Gline', Integer(FGline));
  Profile.WriteBool(Section, 'GlineMarks', FGlineMarks);
  Profile.WriteInteger(Section, 'GlineColor', Integer(FGlineColor));
  Profile.WriteFloat(Section, 'GeomScl', FGeomScl);
  Profile.WriteFloat(Section, 'GeomRot', FGeomRot);
  Profile.WriteBool(Section, 'GeomMir.X', FGeomMir.X);
  Profile.WriteBool(Section, 'GeomMir.Y', FGeomMir.Y);
  Profile.WriteFloat(Section, 'ToneBrightness', FToneBrightness);
  Profile.WriteFloat(Section, 'ToneContrast', FToneContrast);
  Profile.WriteFloat(Section, 'ToneGamma', FToneGamma);
  Profile.WriteString(Section, 'Pal', PalToStr(FPal));
  Profile.WriteInteger(Section, 'PalOrder', Integer(FPalOrder));
  Profile.WriteFloat(Section, 'Him.Index1', FHim.Index1);
  Profile.WriteFloat(Section, 'Him.Index2', FHim.Index2);
  Profile.WriteInteger(Section, 'SaveFilterIndex', FSaveFilterIndex);
end;

procedure TfrImage.SetFit(Fit: TFitsFileBitmap);
begin
  inherited;
  FUpdates := GetFullDebts;
  FRenders := GetFullDebts;
end;

procedure TfrImage.Render;
begin
  BeginRender;
  try
    if not FInit then
    begin
      InitGeom;
      InitTone;
      InitPal;
      InitGridHead;
      InitImgScn;
      InitPopupMenu;
    end;
    if FUpdates <> [] then
    begin
      MatchGridHead;
      MatchImgScn;
      MatchInfo;
      MatchFit;
    end;
    if FRenders <> [] then
    begin
      RenderInfo;
      RenderGline;
      RenderNavig;
      RenderGeom;
      RenderTone;
      RenderPal;
      RenderHim;
      RenderGridHead;
      RenderImgScn;
    end;
  finally
    inherited Render;
    FUpdates := [];
    EndRender;
  end;
end;

procedure TfrImage.MatchFit;
var
  P: TPnt;
  sX, sY, Angle: Double;
  HimReal: THimReal;
begin
  if not Assigned(FFit) then
    Exit;
  if deGeom in FUpdates then
  begin
    // store a center point of region
    if not FNew then
    begin
      P := ToPnt(FImgScn.X1 + FImgScn.Width / 2, FImgScn.Y1 + FImgScn.Height / 2);
      P := FFit.GraphicGeom.PntScnToFrm(P);
    end;
    // update fits geometry
    sX := ifthen(FGeomMir.X, -FGeomScl, +FGeomScl);
    sY := ifthen(FGeomMir.Y, -FGeomScl, +FGeomScl);
    Angle := FGeomRot;
    FFit.GraphicGeom.Clr.Rot(Angle, xy00).Scl(sX, sY, xy00);
    // restore a center point of region
    if not FNew then
    begin
      P := FFit.GraphicGeom.PntFrmToScn(P);
      P := ToPnt(P.X - FImgScn.Width / 2, P.Y - FImgScn.Height / 2);
      UpdateNavig(P.X, P.Y);
    end;
  end;
  if deTone in FUpdates then
  begin
    FFit.GraphicColor.Tone(FToneBrightness, FToneContrast, FToneGamma);
  end;
  if dePal in FUpdates then
  begin
    FFit.GraphicColor.Palette := FPal;
    FFit.GraphicColor.PaletteOrder := FPalOrder;
  end;
  if deHim in FUpdates then
  begin
    if not FFit.GraphicColor.HistogramIsMake then
      FFit.GraphicColor.HistogramUpdate;
    HimReal := HimNormToReal(FHim, FFit.GraphicColor);
    if HimReal.Index1 > HimReal.Index2 then
    begin
      HimReal.Index1 := HimReal.Index2 - 1;
      FHim := HimRealToNorm(HimReal, FFit.GraphicColor);
    end;
    FFit.GraphicColor.HistogramDynamicRange := HimReal;
  end;
end;

procedure TfrImage.GridHeadDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: string;
  Padd: TRect;
  Flag: Vcl.Graphics.TTextFormat;
begin
  if ARow > 0 then
    Exit;
  // set ident
  Padd := Rect;
  Inc(Padd.Left, cGridSpec.CellBorderHalf.cx);
  Dec(Padd.Right, cGridSpec.CellBorderHalf.cx);
  // body
  S := FGridHeadColumnsValue[ACol];
  Flag := [tfSingleLine, tfLeft, tfVerticalCenter];
  with GridHead.Canvas do
  begin
    Font.Assign(GridHead.Font);
    Font.Color := clGrayText;
    Brush.Color := IfThenColor(gdHotTrack in State, cl3DLight, clBtnFace);
    FillRect(Rect);
    TextRect(Padd, S, Flag);
  end;
end;

procedure TfrImage.GridHeadMouseWheelUp(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [] then // scale
    giGemBtnSclInc.Click
  else if Shift = [ssCtrl] then
    giGemBtnRotInc.Click; // rotation
  Handled := True;
end;

procedure TfrImage.GridHeadMouseWheelDown(Sender: TObject; Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if Shift = [] then // scale
    giGemBtnSclDec.Click
  else if Shift = [ssCtrl] then
    giGemBtnRotDec.Click; // rotation
  Handled := True;
end;

procedure TfrImage.InitGridHead;
var
  H: Integer;
begin
  H := GridHead.Canvas.TextHeight('CurGeomTone0123456789');
  H := H + cGridSpec.CellBorder.cy;
  H := Max(H, cGridSpec.CellSizeMin.cy);
  GridHead.RowHeights[0] := H;
  GridHead.RowHeights[1] := 0;
  GridHead.Height := H;
end;

procedure TfrImage.MatchGridHead;
begin
  if FUpdates * [deNavig, deGeom, deTone] <> [] then
    Include(FRenders, deGridHead);
end;

procedure TfrImage.RenderGridHeadCur(ImgScnCur: TPoint);
var
  Pix: TPix;
  Pnt: TPnt;
  S: string;
begin
  S := 'Cur: ';
  if Assigned(FFit) then
  begin
    ImgScnCur.x := FImgScn.X1 + ImgScnCur.x;
    ImgScnCur.y := FImgScn.Y1 + ImgScnCur.y;
    Pix := FFit.GraphicGeom.PixScnToFrm(ToPix(ImgScnCur.x, ImgScnCur.y));
    Pnt := FFit.GraphicGeom.PntScnToFrm(ToPnt(ImgScnCur.x, ImgScnCur.y));
    S := S + FloatToStri(Pnt.X, False, '%.2f') + ', ';
    S := S + FloatToStri(Pnt.Y, False, '%.2f') + ', ';
    if RgnIsIncluded(FFit.DataRgn, Pix.X, Pix.Y) then
      S := S + FloatToStri(FFit.DataPixels[Pix.X, Pix.Y], False, '%g')
    else
      S := S + 'Null';
  end;
  FGridHeadColumnsValue[0] := S;
  GridHead.Invalidate;
end;

procedure TfrImage.RenderGridHead;
var
  Cur: TPoint;
  S: string;
  I, Wsum: Integer;
  W: array [0 .. cGridHeadColumnsCount - 1] of Integer;
begin
  if not (deGridHead in FRenders) then
    Exit;
  Exclude(FRenders, deGridHead);
  if not Assigned(FFit) then
  begin
    FGridHeadColumnsValue[0] := 'Cur:';
    FGridHeadColumnsValue[1] := 'Geom:';
    FGridHeadColumnsValue[2] := 'Tone:';
  end
  else
  begin
    // Cur
    Cur := ImgScn.ScreenToClient(Mouse.CursorPos);
    RenderGridHeadCur(Cur);
    // Geom
    S := 'Geom: ';
    S := S + FloatToStri(FGeomScl * 100) + '% ';
    S := S + FloatToStri(FGeomRot, False, '%.1f') + '°';
    FGridHeadColumnsValue[1] := S;
    // Tone
    S := 'Tone: ';
    S := S + FloatToStri(100 * PercentRange(FToneBrightness, cToneBrightness.Min, cToneBrightness.Max), False, '%.0f') + '% ';
    S := S + FloatToStri(100 * PercentRange(FToneContrast, cToneContrast.Min, cToneContrast.Max), False, '%.0f') + '% ';
    S := S + FloatToStri(FToneGamma, False, '%.1f');
    FGridHeadColumnsValue[2] := S;
  end;
  // Colums width
  Wsum := 0;
  for I := 0 to cGridHeadColumnsCount - 1 do
  begin
    W[I] := GridHead.Canvas.TextWidth(FGridHeadColumnsValue[I]) + cGridSpec.CellBorder.cy * 2;
    Inc(Wsum, W[I]);
  end;
  if Wsum < GridHead.Width then
    W[0] := GridHead.Width - (W[1] + W[2]);
  for I := 0 to cGridHeadColumnsCount - 1 do
    GridHead.ColWidths[I] := W[I];
end;

procedure TfrImage.ImgScnScroll(Sender: TObject; ScrollCode: TScrollCode; var ScrollPos: Integer);
var
  AScroll: TLofiScrollBar;
  NewScrollPos: Integer;
  NewX1, NewY1: Integer;
begin
  if ScrollCode = scEndScroll then
  begin
    AScroll := Sender as TLofiScrollBar;
    NewScrollPos := ScrollPos;
    if NewScrollPos = 0 then
      Dec(NewScrollPos, cImgStockBrd)
    else if NewScrollPos = AScroll.MaxScrollPos then
      Inc(NewScrollPos, cImgStockBrd);
    NewX1 := FImgScn.X1;
    NewY1 := FImgScn.Y1;
    if AScroll.Name = 'PanelMainScrollHor' then
      NewX1 := Min(FImgScn.X1, FFit.GraphicRgn.X1) - cImgStockBrd + NewScrollPos  // Hor
    else
      NewY1 := Min(FImgScn.Y1, FFit.GraphicRgn.Y1) - cImgStockBrd + NewScrollPos; // Ver
    UpdateNavig(NewX1, NewY1);
    Render;
    ScrollPos := AScroll.Position;
  end;
end;

procedure TfrImage.ImgScnMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  R: TRect;
begin
  if Button <> mbLeft then
    Exit;
  // remember mouse pos
  FImgPix := ToPix(X, Y);
  // reset sub controls
  ImgScnMov.Visible := False;
  ImgScnSel.Visible := False;
  ImgScnSelHint.Visible := False;
  // select
  if ssCtrl in Shift then
  begin
    P := ImgScn.ClientToParent(Point(X, Y));
    ImgScnSel.SetBounds(P.X, P.Y, 1, 1);
    ImgScnSel.Tag := 0; // logic of show/hide of ImgScnSel
    ImgScnSel.Visible := True;
    ImgScnSelHint.Caption := '1 x 1';
    ImgScnSelHint.Visible := True;
  end
  // moved
  else
  begin
    begin
      R.Left := X - ImgScnMov.Width div 2;
      R.Top := Y - ImgScnMov.Height div 2;
      R.Right := R.Left + ImgScnMov.Width;
      R.Bottom := R.Top + ImgScnMov.Height;
    end;
    with ImgScnMov.Picture.Bitmap.Canvas do
    begin
      Brush.Style := bsSolid;
      Brush.Color := clBtnFace;
      Rectangle(ImgScnMov.ClientRect);
      CopyRect(ImgScnMov.ClientRect, ImgScn.Picture.Bitmap.Canvas, R);
      DrawFocusRect(ImgScnMov.ClientRect);
    end;
    R.TopLeft := ImgScn.ClientToParent(R.TopLeft);
    ImgScnMov.Left := R.Left;
    ImgScnMov.Top  := R.Top;
    ImgScnMov.Visible := True;
  end;
end;

procedure TfrImage.ImgScnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  L, T, W, H: Integer;
  P: TPoint;
begin
  // select
  if ImgScnSel.Visible and (ImgScnSel.Tag = 0) then
  begin
    L := ifthen(X < FImgPix.X, X, FImgPix.X);
    T := ifthen(Y < FImgPix.Y, Y, FImgPix.Y);
    W := Max(abs(X - FImgPix.X), 1);
    H := Max(abs(Y - FImgPix.Y), 1);
    ImgScnSel.SetBounds(L, T, W, H);
    ImgScnSelHint.Caption := Format('%d x %d', [W, H]);
    ImgScnSelHint.SetBounds(L + W + 2, T + H - ImgScnSelHint.Height, ImgScnSelHint.Width, ImgScnSelHint.Height);
  end;
  // moved
  if ImgScnMov.Visible then
  begin
    P := ImgScn.ClientToParent(Point(X, Y));
    ImgScnMov.Left := P.X - ImgScnMov.Width div 2;
    ImgScnMov.Top  := P.Y - ImgScnMov.Height div 2;
  end;
  // out cursor pos
  RenderGridHeadCur(Point(X, Y));
end;

procedure TfrImage.ImgScnMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbLeft then
    Exit;
  // select
  if ImgScnSel.Visible then
  begin
    ImgScnSel.Tag := 1; // blocked size of ImgScnSel: no resize ImgScnSel in ImgScnMouseMove
  end;
  // moved
  if ImgScnMov.Visible then
  begin
    ImgScnMov.Visible := False;
    UpdateNavig(FImgScn.X1 + FImgPix.X - X, FImgScn.Y1 + FImgPix.Y - Y);
    Render;
  end;
end;

procedure TfrImage.ImgScnSelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  if Button = mbRight then
  begin
    P := ToPix(X, Y);
    P := (Sender as TControl).ClientToScreen(P);
    PmMain.PopUp(P.x, P.y);
  end
  else
  begin
    ImgScnSel.Visible := False;
    ImgScnSelHint.Visible := False;
  end;
end;

procedure TfrImage.ImgScnSelMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  P := ImgScnSel.ClientToParent(Point(X, Y));
  P.X := P.X - ImgScn.Left;
  P.Y := P.Y - ImgScn.Top;
  RenderGridHeadCur(P);
end;

procedure TfrImage.InitImgScn;
begin
  ImgScnMov.Picture.Bitmap.SetSize(ImgScnMov.Width, ImgScnMov.Height);
end;

procedure TfrImage.MatchImgScn;
begin
  if (FImgScn.Width <> ImgScn.Width) or (FImgScn.Height <> ImgScn.Height) then
  begin
    FImgScn.Width := ImgScn.Width;
    FImgScn.Height := ImgScn.Height;
    Include(FRenders, deImgScn);
  end;
  if FUpdates * [deGline, deNavig, deGeom, deTone, dePal, deHim] <> [] then
    Include(FRenders, deImgScn);
end;

procedure TfrImage.RenderImgScn1;
begin
  FFit.BitmapRead(ImgScn.Picture.Bitmap, FImgScn);
end;

procedure TfrImage.RenderImgScn2;
  function PntFrmToPixImg(const x_frm, y_frm: Double): TPix;
  var
    P: TPnt;
  begin
    P := ToPnt(x_frm, y_frm);
    P := FFit.GraphicGeom.PntFrmToScn(P);
    P.X := P.X - FImgScn.X1;
    P.Y := P.Y - FImgScn.Y1;
    Result := FloorPnt(P);
  end;
var
  R: TRgn;
  I, step_int: Integer;
  step, aroww, arowh: Double;
  x, xmin, xmax: Double;
  y, ymin, ymax: Double;
  O1, O2, O3: TPix;
  P1, P2, P3: TPnt;
  S1, S2: string;
  E1, E2: TSize;
  B: TRect;
  M: TMatrix;
begin
  case FGline of
    // none
    glNone:
      begin
      end;
    // mesh
    glMesh:
      begin
        // get step of grid line
        if IsLessEqual(FGeomScl, 0.1) then
        begin
          R := FFit.GraphicGeom.RectScnToFrm(ToRgnWiHe(0, 0, 60, 60));
          step := System.Math.Min(R.Width, R.Height);
          step := System.Math.SimpleRoundTo(step, 2);
          step := System.Math.Max(step, 600);
        end
        else if IsLessEqual(FGeomScl, 0.25) then
          step := 400
        else if IsLessEqual(FGeomScl, 0.5) then
          step := 200
        else if IsLessEqual(FGeomScl, 2.0) then
          step := 100
        else if IsLessEqual(FGeomScl, 4.0) then
          step := 50
        else if IsLessEqual(FGeomScl, 6.0) then
          step := 25
        else
          step := 10;
        // get region window scene in sys. coord frame and get min/max coord ~ step
        R := FFit.GraphicGeom.RectScnToFrm(FImgScn);
        xmin := step * Trunc(R.X1 / step);
        xmax := step * Trunc((R.X1 + R.Width) / step);
        ymin := step * Trunc(R.Y1 / step);
        ymax := step * Trunc((R.Y1 + R.Height) / step);
        // canvas prepare
        with ImgScn.Picture.Bitmap.Canvas do
        begin
          Pen.Color   := FGlineColor;
          Pen.Width   := 1;
          Brush.Style := bsSolid;
          Brush.Color := FGlineColor;
        end;
        // out line
        x := xmin;
        while x <= xmax do
        begin
          O1 := PntFrmToPixImg(x, R.Y1);
          O2 := PntFrmToPixImg(x, R.Y1 + R.Height);
          ImgScn.Picture.Bitmap.Canvas.MoveTo(O1.X, O1.Y);
          ImgScn.Picture.Bitmap.Canvas.LineTo(O2.X, O2.Y);
          x := x + step;
        end;
        y := ymin;
        while y <= ymax do
        begin
          O1 := PntFrmToPixImg(R.X1, y);
          O2 := PntFrmToPixImg(R.X1 + R.Width, y);
          ImgScn.Picture.Bitmap.Canvas.MoveTo(O1.X, O1.Y);
          ImgScn.Picture.Bitmap.Canvas.LineTo(O2.X, O2.Y);
           y := y + step;
        end;
        // out marks in nodes a grid line
        if not FGlineMarks then
          Exit;
        // ImgScn.Picture.Bitmap.Canvas.Font.SetDefault;
        // get text extent max
        S1 := FloatToStri(0.0, True, Word(Length(IntToStr(System.Math.MaxIntValue([R.X1, R.Y1, R.X1 + R.Width, R.Y1 + R.Height])))), 0);
        E1 := ImgScn.Picture.Bitmap.Canvas.TextExtent(S1);
        y := ymin;
        while y <= ymax do
        begin
          x := xmin;
          while x <= xmax do
          begin
            if (Round(y / step) mod 2 = 0) and (Round(x / step) mod 2 = 0) then
            begin
              O1 := PntFrmToPixImg(x, y);
              B.TopLeft     := ToPix(O1.X - E1.cx div 2 - 2, O1.Y - E1.cy - 2);
              B.BottomRight := ToPix(O1.X + E1.cx div 2 + 2, O1.Y + E1.cy + 2);
              with ImgScn.Picture.Bitmap.Canvas do
              begin
                Brush.Style := bsSolid;
                Brush.Color := FGlineColor;
                Rectangle(B);
                Brush.Style := bsClear;
                Font.Assign(Self.Font);
                TextRect(B, B.TopLeft.x + 2, B.TopLeft.y + 2,         FloatToStri(x, True, '%.0f'));
                TextRect(B, B.TopLeft.x + 2, B.TopLeft.y + 2 + E1.cy, FloatToStri(y, True, '%.0f'));
              end;
            end;
            x := x + step;
          end;
          y := y + step;
        end; // loop
      end;
    // X, Y
    glAxis:
      begin
        // canvas prepare
        with ImgScn.Picture.Bitmap.Canvas do
        begin
          Pen.Color   := FGlineColor;
          Pen.Width   := 3;
          Brush.Style := bsClear;
          Font.Style  := [fsBold];
          Font.Color  := FGlineColor;
        end;
        // get matrix rot, orient axis (scale sign) & shift in center
        M := MatrixMakeAsRot(FGeomRot);
        if FGeomMir.X then x := -1 else x := 1;
        if FGeomMir.Y then y := -1 else y := 1;
        M := MatrixMultiply(M, MatrixMakeAsScl(x, y));
        x := FImgScn.Width  / 2;
        y := FImgScn.Height / 2;
        M := MatrixMultiply(M, MatrixMakeAsTrn(x, y));
        // step & size-arrow
        step  := 100.0;
        aroww := 6.0;
        arowh := 3.0;
        // out X and x-arrow
        P1 := ToPnt(-step, 0.0);
        P2 := ToPnt(+step, 0.0);
        P1 := MapPnt(M, P1);
        P2 := MapPnt(M, P2);
        O1 := FloorPnt(P1);
        O2 := FloorPnt(P2);
        ImgScn.Picture.Bitmap.Canvas.MoveTo(O1.X, O1.Y);
        ImgScn.Picture.Bitmap.Canvas.LineTo(O2.X, O2.Y);
        P1 := ToPnt(step - aroww, -arowh);
        P2 := ToPnt(step, 0.0);
        P3 := ToPnt(step - aroww, +arowh);
        P1 := MapPnt(M, P1);
        P2 := MapPnt(M, P2);
        P3 := MapPnt(M, P3);
        O1 := FloorPnt(P1);
        O2 := FloorPnt(P2);
        O3 := FloorPnt(P3);
        ImgScn.Picture.Bitmap.Canvas.Polyline([O1, O2, O3]);
        E1 := ImgScn.Picture.Bitmap.Canvas.TextExtent('X');
        P1 := ToPnt(step + 4.0 + E1.cx / 2, 0.0);
        P1 := MapPnt(M, P1);
        P1.X := P1.X - E1.cx / 2;
        P1.Y := P1.Y - E1.cy / 2;
        O1 := FloorPnt(P1);
        ImgScn.Picture.Bitmap.Canvas.TextOut(O1.X, O1.Y, 'X');
        // out Y and y-arrow
        P1 := ToPnt(0.0, -step);
        P2 := ToPnt(0.0, +step);
        P1 := MapPnt(M, P1);
        P2 := MapPnt(M, P2);
        O1 := FloorPnt(P1);
        O2 := FloorPnt(P2);
        ImgScn.Picture.Bitmap.Canvas.MoveTo(O1.X, O1.Y);
        ImgScn.Picture.Bitmap.Canvas.LineTo(O2.X, O2.Y);
        P1 := ToPnt(-arowh, step - aroww);
        P2 := ToPnt(0.0, step);
        P3 := ToPnt(+arowh, step - aroww);
        P1 := MapPnt(M, P1);
        P2 := MapPnt(M, P2);
        P3 := MapPnt(M, P3);
        O1 := FloorPnt(P1);
        O2 := FloorPnt(P2);
        O3 := FloorPnt(P3);
        ImgScn.Picture.Bitmap.Canvas.Polyline([O1, O2, O3]);
        E1 := ImgScn.Picture.Bitmap.Canvas.TextExtent('Y');
        P1 := ToPnt(0.0, step + 4.0 + E1.cy / 2);
        P1 := MapPnt(M, P1);
        P1.X := P1.X - E1.cx / 2;
        P1.Y := P1.Y - E1.cy / 2;
        O1 := FloorPnt(P1);
        ImgScn.Picture.Bitmap.Canvas.TextOut(O1.X, O1.Y, 'Y');
        // out mark in center of arrow
        if not FGlineMarks then
          Exit;
        // center point
        P1 := ToPnt(FImgScn.X1 + FImgScn.Width / 2, FImgScn.Y1 + FImgScn.Height / 2);
        P1 := FFit.GraphicGeom.PntScnToFrm(P1);
        S1 := FloatToStri(P1.X, True, '%.2f');
        S2 := FloatToStri(P1.Y, True, '%.2f');
        E1 := ImgScn.Picture.Bitmap.Canvas.TextExtent(S1);
        E2 := ImgScn.Picture.Bitmap.Canvas.TextExtent(S2);
        E1.cx := System.Math.Max(E1.cx, E2.cx);
        E1.cy := System.Math.Max(E1.cy, E2.cy);
        O1.X := FImgScn.Width  div 2;
        O1.Y := FImgScn.Height div 2;
        B.TopLeft     := ToPix(O1.X - E1.cx div 2 - 2, O1.Y - E1.cy - 2);
        B.BottomRight := ToPix(O1.X + E1.cx div 2 + 2, O1.Y + E1.cy + 2);
        with ImgScn.Picture.Bitmap.Canvas do
        begin
          Brush.Style := bsSolid;
          Brush.Color := FGlineColor;
          Rectangle(B);
          Brush.Style := bsClear;
          Font.Assign(Self.Font);
          TextRect(B, B.TopLeft.x + 2, B.TopLeft.y + 2,         S1);
          TextRect(B, B.TopLeft.x + 2, B.TopLeft.y + 2 + E1.cy, S2);
        end;
      end;
    // scene
    glScen:
      begin
        // canvas prepare
        with ImgScn.Picture.Bitmap.Canvas do
        begin
          Pen.Color   := FGlineColor;
          Pen.Width   := 1;
          Brush.Style := bsSolid;
          Brush.Color := FGlineColor;
          // Font.SetDefault;
        end;
        step_int := 50;
        for I := 1 to 4 do
        begin
          case I of
            1: O1 := ToPix(                FImgScn.Width div 5,                  FImgScn.Height div 5);
            2: O1 := ToPix(FImgScn.Width - FImgScn.Width div 5,                  FImgScn.Height div 5);
            3: O1 := ToPix(                FImgScn.Width div 5, FImgScn.Height - FImgScn.Height div 5);
            4: O1 := ToPix(FImgScn.Width - FImgScn.Width div 5, FImgScn.Height - FImgScn.Height div 5);
          end;
          // out line
          O2 := ToPix(O1.X - step_int, O1.Y);
          O3 := ToPix(O1.X + step_int, O1.Y);
          ImgScn.Picture.Bitmap.Canvas.MoveTo(O2.X, O2.Y);
          ImgScn.Picture.Bitmap.Canvas.LineTo(O3.X, O3.Y);
          O2 := ToPix(O1.X, O1.Y - step_int);
          O3 := ToPix(O1.X, O1.Y + step_int);
          ImgScn.Picture.Bitmap.Canvas.MoveTo(O2.X, O2.Y);
          ImgScn.Picture.Bitmap.Canvas.LineTo(O3.X, O3.Y);
          // out mark
          if not FGlineMarks then
            Continue;
          P1 := ToPnt(FImgScn.X1 + O1.X, FImgScn.Y1 + O1.Y);
          P1 := FFit.GraphicGeom.PntScnToFrm(P1);
          S1 := FloatToStri(P1.X, True, '%.2f');
          S2 := FloatToStri(P1.Y, True, '%.2f');
          E1 := ImgScn.Picture.Bitmap.Canvas.TextExtent(S1);
          E2 := ImgScn.Picture.Bitmap.Canvas.TextExtent(S2);
          E1.cx := System.Math.Max(E1.cx, E2.cx);
          E1.cy := System.Math.Max(E1.cy, E2.cy);
          B.TopLeft     := ToPix(O1.X - E1.cx div 2 - 2, O1.Y - E1.cy - 2);
          B.BottomRight := ToPix(O1.X + E1.cx div 2 + 2, O1.Y + E1.cy + 2);
          with ImgScn.Picture.Bitmap.Canvas do
          begin
            Brush.Style := bsSolid;
            Brush.Color := FGlineColor;
            Rectangle(B);
            Brush.Style := bsClear;
            Font.Assign(Self.Font);
            TextRect(B, B.TopLeft.x + 2, B.TopLeft.y + 2,         S1);
            TextRect(B, B.TopLeft.x + 2, B.TopLeft.y + 2 + E1.cy, S2);
          end;
        end;
      end;
  end;
end;

procedure TfrImage.RenderImgScn3;
var
  R1, R2, R: TRgn;
  BarPos, BarMin, BarMax, BarPag: Integer;
begin
  R1 := FImgScn;
  R2 := FFit.GraphicRgn;
  R  := MergeRgn(R1, R2);
  // horz
  BarMin := 0;
  BarMax := cImgStockBrd + R.Width + cImgStockBrd - 1;
  BarPos := cImgStockBrd + (R1.X1 - R.X1);
  BarPag := R1.Width;
  PanelMainScrollHor.SetParams(BarPos, BarMin, BarMax, BarPag);
  PanelMainScrollHor.Enabled := True;
  // vert
  BarMin := 0;
  BarMax := cImgStockBrd + R.Height + cImgStockBrd - 1;
  BarPos := cImgStockBrd + (R1.Y1 - R.Y1);
  BarPag := R1.Height;
  PanelMainScrollVer.SetParams(BarPos, BarMin, BarMax, BarPag);
  PanelMainScrollVer.Enabled := True;
end;

procedure TfrImage.RenderImgScn;
begin
  if not (deImgScn in FRenders) then
    Exit;
  Exclude(FRenders, deImgScn);
  if not Assigned(FFit) then
  begin
    ImgScn.Picture.Bitmap := nil;
    PanelMainScrollHor.Enabled := False;
    PanelMainScrollVer.Enabled := False;
    Exit;
  end;
  RenderImgScn1;
  RenderImgScn2;
  RenderImgScn3;
  ImgScn.Invalidate;
end;

procedure TfrImage.MatchInfo;
begin
  if deGeom in FUpdates then
    Include(FRenders, deInfo);
end;

procedure TfrImage.RenderInfo;
var
  Lines: array [6 .. 14] of string;
  Mea: THistogramMeasure;
  Him: PHistogram;
  Rgn: TRgn;
  S: string;
begin
  if not ViewMenu then
    Exit;
  if giInfo.HeightState = hsMini then
    Exit;
  if not (deInfo in FRenders) then
    Exit;
  Exclude(FRenders, deInfo);
  Lines[06] := 'Histogram items count: %d';
  Lines[07] := 'Histogram points count:%d';
  Lines[08] := 'Value min: %g';
  Lines[09] := 'Value max: %g';
  Lines[10] := 'Value mean: %g';
  Lines[11] := 'Width frame: %d';
  Lines[12] := 'Height frame: %d';
  Lines[13] := 'Width scene: %d';
  Lines[14] := 'Height scene: %d';
  if not Assigned(FFit) then
  begin
    S := LinesTxt(Lines, True);
  end
  else
  begin
    if not FFit.GraphicColor.HistogramIsMake then
      FFit.GraphicColor.HistogramUpdate;
    Mea := FFit.GraphicColor.HistogramMeasure;
    LinesFmt(Lines[6], [Mea.CountItems]);
    LinesFmt(Lines[7], [Mea.CountPoints]);
    Him := FFit.GraphicColor.Histogram;
    LinesFmt(Lines[8], [Him^[0]^.Value]);
    LinesFmt(Lines[9], [Him^[Mea.CountItems - 1]^.Value]);
    LinesFmt(Lines[10], [Him^[Mea.ItemMedian]^.Value]);
    Rgn := FFit.DataRgn;
    LinesFmt(Lines[11], [Rgn.Width]);
    LinesFmt(Lines[12], [Rgn.Height]);
    Rgn := FFit.GraphicRgn;
    LinesFmt(Lines[13], [Rgn.Width]);
    LinesFmt(Lines[14], [Rgn.Height]);
    S := LinesTxt(Lines);
  end;
  giInfoMemo.Lines.Text := FitHduCoreAsString + S;
end;

procedure TfrImage.giGlineAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
var
  W, L: Integer;
begin
  if Control = giGlineBtnDefault then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end
  else
  begin
    W := NewWidth * 5 + CtrlGap * 3 + 16;
    L := (AlignRect.Width - W) div 2;
    if Control = giGlineBtnMesh then
      NewLeft := L
    else if Control = giGlineBtnAxis then
      NewLeft := L + NewWidth + CtrlGap
    else if Control = giGlineBtnScen then
      NewLeft := L + NewWidth * 2 + CtrlGap * 2
    else if Control = giGlineBtnMarks then
      NewLeft := L + NewWidth * 3 + CtrlGap * 2 + 16
    else if Control = giGlineBtnColor then
      NewLeft := L + NewWidth * 4 + CtrlGap * 3 + 16;
  end;
end;

procedure TfrImage.giGlineBtnKindClick(Sender: TObject);
var
  Btn: TSpeedButton;
  NewGline: TGline;
begin
  NewGline := glNone;
  Btn := Sender as TSpeedButton;
  if Btn.Down then
    case Btn.Tag of
      10: NewGline := glMesh;
      20: NewGline := glAxis;
      30: NewGline := glScen;
    end;
  UpdateGline(NewGline, FGlineMarks, FGlineColor);
  Render;
end;

procedure TfrImage.giGlineBtnMarksClick(Sender: TObject);
var
  NewGlineMarks: Boolean;
begin
  NewGlineMarks := (Sender as TSpeedButton).Down;
  UpdateGline(FGline, NewGlineMarks, FGlineColor);
  Render;
end;

procedure TfrImage.giGlineBtnColorClick(Sender: TObject);
var
  NewGlineColor: TColor;
begin
  with TColorDialog.Create(nil) do
  begin
    if Execute then
      NewGlineColor := Color
    else
      NewGlineColor := FGlineColor;
    Free;
  end;
  UpdateGline(FGline, FGlineMarks, NewGlineColor);
  Render;
end;

procedure TfrImage.giGlineBtnDefaultClick(Sender: TObject);
begin
  UpdateGline(cGlineDef, cGlineMarksDef, cGlineColorDef);
  Render;
end;

procedure TfrImage.UpdateGline(NewGline: TGline; NewGlineMarks: Boolean; NewGlineColor: TColor);
begin
  if (NewGline <> FGline) or (NewGlineMarks <> FGlineMarks) or (NewGlineColor <> FGlineColor) then
  begin
    FGline := NewGline;
    FGlineMarks := NewGlineMarks;
    FGlineColor := NewGlineColor;
    Include(FUpdates, deGline);
  end;
  Include(FRenders, deGline);
end;

procedure TfrImage.RenderGline;
begin
  if not ViewMenu then
    Exit;
  if giGline.HeightState = hsMini then
    Exit;
  if not (deGline in FRenders) then
    Exit;
  Exclude(FRenders, deGline);
  // set controls state
  giGlineBtnMesh.Down := False;
  giGlineBtnAxis.Down := False;
  giGlineBtnScen.Down := False;
  case FGline of
    glNone: ;
    glMesh: giGlineBtnMesh.Down := True;
    glAxis: giGlineBtnAxis.Down := True;
    glScen: giGlineBtnScen.Down := True;
  end;
  giGlineBtnMarks.Down := FGlineMarks;
  with giGlineBtnColor.Glyph.Canvas do
  begin
    Brush.Color := FGlineColor;
    Pen.Color := clBlack;
    Rectangle(4, 4, 12, 12);
  end;
end;

procedure TfrImage.giNavigAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
var
  W: Integer;
begin
  W := EnsureRange(Round(AlignRect.Width * 70 / 200), 40, 120);
  if (Control = giNavigFrmEditX) or (Control = giNavigScnEditX) or (Control = giNavigScnEditW) then
  begin
    NewWidth := W;
    NewLeft := (AlignRect.Width - CtrlGap) div 2 - NewWidth;
  end
  else if (Control = giNavigFrmEditY) or (Control = giNavigScnEditY) or (Control = giNavigScnEditH) then
  begin
    NewWidth := W;
    NewLeft := (AlignRect.Width + CtrlGap) div 2;
  end
  else if (Control = giNavigFrmLabelX) or (Control = giNavigScnLabelX) or (Control = giNavigScnLabelW) then
  begin
    NewLeft := (AlignRect.Width - CtrlGap) div 2 - W - CtrlGap div 2 - NewWidth;
  end
  else if (Control = giNavigFrmLabelY) or (Control = giNavigScnLabelY) or (Control = giNavigScnLabelH) then
  begin
    NewLeft := (AlignRect.Width + CtrlGap) div 2 + W + CtrlGap div 2;
  end
  else if (Control = giNavigImg) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end
  else if (Control = giNavigScnBtnT) or (Control = giNavigScnBtnB) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end
  else if (Control = giNavigScnBtnL) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2 - NewWidth;
  end
  else if (Control = giNavigScnBtnR) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2 + NewWidth;
  end;
end;

procedure TfrImage.giNavigFrmEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  P: TPnt;
begin
  if Key <> VK_RETURN then
    Exit;
  if (Sender as TEdit).Name = 'giNavigFrmEditX' then
  begin
    giNavigFrmEditY.SetFocus;
    Exit;
  end;
  P := ToPnt(FImgScn.X1 + FImgScn.Width / 2, FImgScn.Y1 + FImgScn.Height / 2);
  P := FFit.GraphicGeom.PntScnToFrm(P);
  P.X := TxtToFloat(giNavigFrmEditX.Text, P.X);
  P.Y := TxtToFloat(giNavigFrmEditY.Text, P.Y);
  P := FFit.GraphicGeom.PntFrmToScn(P);
  P.X := P.X - FImgScn.Width / 2;
  P.Y := P.Y - FImgScn.Height / 2;
  UpdateNavig(P.X, P.Y);
  Render;
end;

procedure TfrImage.giNavigScnEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  NewX1, NewY1: Integer;
begin
  if Key <> VK_RETURN then
    Exit;
  if (Sender as TEdit).Name = 'giNavigScnEditX' then
  begin
    giNavigScnEditY.SetFocus;
    Exit;
  end;
  NewX1 := StrToIntDef(giNavigScnEditX.Text, FImgScn.X1);
  NewY1 := StrToIntDef(giNavigScnEditY.Text, FImgScn.Y1);
  UpdateNavig(NewX1, NewY1);
  Render;
end;

procedure TfrImage.giNavigScnBtnClick(Sender: TObject);
var
  NewX1, NewY1: Integer;
begin
  NewX1 := FImgScn.X1;
  NewY1 := FImgScn.Y1;
  case (Sender as TSpeedButton).Tag of
    10: Dec(NewX1); // left
    20: Dec(NewY1); // top
    30: Inc(NewX1); // right
    40: Inc(NewY1); // bottom
  end;
  UpdateNavig(NewX1, NewY1);
  Render;
end;

procedure TfrImage.giNavigImgClick(Sender: TObject);
var
  Pix: TPix;
  Pnt: TPnt;
begin
  Pix := Mouse.CursorPos;
  Pix := giNavigImg.ScreenToClient(Pix);
  with giNavigImg.Picture.Bitmap.Canvas do
  begin
    Pen.Color := clRed;
    MoveTo(Pix.x - 2, Pix.y);
    LineTo(Pix.x + 3, Pix.y);
    MoveTo(Pix.x, Pix.y - 2);
    LineTo(Pix.x, Pix.y + 3);
  end;
  giNavigImg.Refresh;
  Pnt := ToPnt(Pix.x, Pix.y);
  Pnt := MapPnt(MatrixInverse(FNavigImg), Pnt);
  Pnt := FFit.GraphicGeom.PntFrmToScn(Pnt);
  Pnt.X := Pnt.X - FImgScn.Width / 2;
  Pnt.Y := Pnt.Y - FImgScn.Height / 2;
  UpdateNavig(Pnt.X, Pnt.Y);
  Render;
end;

procedure TfrImage.UpdateNavig(NewX1, NewY1: Integer);
begin
  if (NewX1 <> FImgScn.X1) or (NewY1 <> FImgScn.Y1) then
  begin
    FImgScn.X1 := NewX1;
    FImgScn.Y1 := NewY1;
    Include(FUpdates, deNavig);
  end;
  Include(FRenders, deNavig);
end;

procedure TfrImage.UpdateNavig(NewX1, NewY1: Double);
var
  P: TPix;
begin
  P := FloorPnt(ToPnt(NewX1, NewY1));
  UpdateNavig(P.X, P.Y);
end;

procedure TfrImage.RenderNavig;
const
  cBorder = 8;
var
  I: Integer;
  M: TMatrix;
  P, Pnt: TPnt;
  Pix: TPix;
  s, dx, dy: Double;
  R: TRgn;
  Re: TRect;
  Po: array [1 .. 4] of TPoint;
  P00, PW0, P0H: TPix;
  Ext: TSize;
begin
  if not ViewMenu then
    Exit;
  if giNavig.HeightState = hsMini then
    Exit;
  if not (deNavig in FRenders) then
    Exit;
  Exclude(FRenders, deNavig);
  // set imgscn region
  if not Assigned(FFit) then
  begin
    giNavigScnEditX.Text := '';
    giNavigScnEditY.Text := '';
    giNavigScnEditW.Text := '';
    giNavigScnEditH.Text := '';
    giNavigFrmEditX.Text := '';
    giNavigFrmEditY.Text := '';
    giNavigImg.Picture.Bitmap := nil;
    Exit;
  end;
  giNavigScnEditX.Text := IntToStr(FImgScn.X1);
  giNavigScnEditY.Text := IntToStr(FImgScn.Y1);
  giNavigScnEditW.Text := IntToStr(FImgScn.Width);
  giNavigScnEditH.Text := IntToStr(FImgScn.Height);
  P := ToPnt(FImgScn.X1 + FImgScn.Width / 2, FImgScn.Y1 + FImgScn.Height / 2);
  P := FFit.GraphicGeom.PntScnToFrm(P);
  giNavigFrmEditX.Text := FloatToStri(P.X, False, '%.2f');
  giNavigFrmEditY.Text := FloatToStri(P.Y, False, '%.2f');
  // set image navigation
  // compute new geometry:
  // 1. store fits geometry;
  M := FFit.GraphicGeom.MatrixFrm;
  // 2. store point(FImgScn.X1; FImgScn.Y1) in frame sys;
  Pnt := ToPnt(FImgScn.X1, FImgScn.Y1);
  Pnt := FFit.GraphicGeom.PntScnToFrm(Pnt);
  // 3. update fits geometry (shift & scale): RgnWin + RectRgnFrame = RgnCommon, here (RgnCommon.X1; RgnCommon.Y1) = (0; 0)
  R  := MergeRgn(FImgScn, FFit.GraphicRgn);
  s  := System.Math.Min((giNavigImg.Width - cBorder) / R.Width, (giNavigImg.Height - cBorder) / R.Height);
  dx := -R.X1;
  dy := -R.Y1;
  FFit.GraphicGeom.Trn(dx, dy).Scl(s, s, xy00);
  // 4. update fits geometry (shift): centered scene in ImageFigure
  Pix := RoundPnt(FFit.GraphicGeom.PntFrmToScn(Pnt));
  R.X1     := Pix.x;
  R.Y1     := Pix.y;
  R.Width  := Round(FImgScn.Width  * s);
  R.Height := Round(FImgScn.Height * s);
  R := MergeRgn(R, FFit.GraphicRgn);
  dx := (giNavigImg.Width  - R.Width)  / 2;
  dy := (giNavigImg.Height - R.Height) / 2;
  FFit.GraphicGeom.Trn(dx, dy);
  // 5. save new geometry
  FNavigImg := FFit.GraphicGeom.MatrixFrm;
  // 6. get new region (window) in new-scene sys
  Pix := RoundPnt(FFit.GraphicGeom.PntFrmToScn(Pnt));
  Re.Left   := Pix.x;
  Re.Top    := Pix.y;
  Re.Right  := Pix.x + Round(FImgScn.Width  * s);
  Re.Bottom := Pix.y + Round(FImgScn.Height * s);
  // 7. get quad-frame in new-scene sys
  with FFit.GraphicGeom.QuadFrmToScn(FFit.DataRgn) do
    for I := 1 to 4 do
      Po[I] := FloorPnt(PA[I]);
  P00 := FFit.GraphicGeom.PixFrmToScn(ToPix(0, 0));
  PW0 := FFit.GraphicGeom.PixFrmToScn(ToPix(FFit.DataRgn.Width, 0));
  P0H := FFit.GraphicGeom.PixFrmToScn(ToPix(0, FFit.DataRgn.Height));
  // 8. restore fits geometry
  FFit.GraphicGeom.Clr.Mul(M);
  // out
  giNavigImg.Picture.Bitmap.SetSize(giNavigImg.Width, giNavigImg.Height);
  with giNavigImg.Picture.Bitmap.Canvas do
  begin
    // substrate
    Brush.Style := bsSolid;
    Brush.Color := clWindow;
    Pen.Color   := clBlack;
    FillRect(giNavigImg.ClientRect);
    // region frame
    Brush.Style := bsClear;
    //Pen.Color := clBackground;
    Polygon(Po);
    Brush.Style := bsSolid;
    Font.Size  := 8;
    Font.Style := [fsBold];
    Ext := TextExtent('0');
    TextOut(P00.x - Ext.cx div 2, P00.y - Ext.cy div 2, '0');
    Ext := TextExtent('X');
    TextOut(PW0.x - Ext.cx div 2, PW0.y - Ext.cy div 2, 'X');
    Ext := TextExtent('Y');
    TextOut(P0H.x - Ext.cx div 2, P0H.y - Ext.cy div 2, 'Y');
    // region window
    DrawFocusRect(Re);
    Pen.Color := clRed;
    Pix.x := Re.Left + (Re.Right  - Re.Left) div 2;
    Pix.y := Re.Top  + (Re.Bottom - Re.Top)  div 2;
    MoveTo(Pix.x - 2, Pix.y);
    LineTo(Pix.x + 3, Pix.y);
    MoveTo(Pix.x, Pix.y - 2);
    LineTo(Pix.x, Pix.y + 3);
  end;
end;

procedure TfrImage.giGeomAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
var
  W: Integer;
begin
  W := EnsureRange(Round(AlignRect.Width * 100 / 200), 40, 120);
  if (Control = giGemCmbScl) or (Control = giGemCmbRot) then
  begin
    NewWidth := W;
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end
  else if (Control = giGemBtnSclDec) or (Control = giGemBtnRotDec) then
  begin
    NewLeft := (AlignRect.Width - W) div 2 - CtrlGap div 2 - NewWidth;
  end
  else if (Control = giGemBtnSclInc) or (Control = giGemBtnRotInc) then
  begin
    NewLeft := (AlignRect.Width - W) div 2 + W + CtrlGap div 2;
  end
  else if (Control = giGemBtnFlipLR) then
  begin
    NewLeft := AlignRect.Width div 2 - CtrlGap div 2 - NewWidth;
  end
  else if (Control = giGemBtnFlipTD) then
  begin
    NewLeft := AlignRect.Width div 2 + CtrlGap div 2;
  end
  else if (Control = giGemBtnDefault) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end;
end;

procedure TfrImage.giGeomBtnSclClick(Sender: TObject);
var
  NewScl: Double;
begin
  NewScl := FGeomScl;
  case (Sender as TSpeedButton).Tag of
    -1: // zoom-
      begin
        if NewScl <= cGeomScl.Min then
          // ...continue
        else if NewScl > cGeomScl.Max then
          NewScl := cGeomScl.Max
        else if IsLessEqual(NewScl, 0.4) then
          DecRound(NewScl, 0.05, cGeomScl.Min, -2)
        else if IsLessEqual(NewScl, 0.6) then
          DecRound(NewScl, 0.1, 0.4, -1)
        else if IsLessEqual(NewScl, 1.0) then
          DecRound(NewScl, 0.2, 0.6, -1)
        else if IsLessEqual(NewScl, 4.0) then
          DecRound(NewScl, 0.5, 1.0, -1)
        else
          DecRound(NewScl, 1.0, 4.0, 0);
      end;
    +1: // zoom+
      begin
        if NewScl < cGeomScl.Min then
          NewScl := cGeomScl.Min
        else if NewScl >= cGeomScl.Max then
          // ...continue
        else if IsMoreEqual(NewScl, 4.0) then
          IncRound(NewScl, 1.0, cGeomScl.Max, 0)
        else if IsMoreEqual(NewScl, 1.0) then
          IncRound(NewScl, 0.5, 4.0, -1)
        else if IsMoreEqual(NewScl, 0.6) then
          IncRound(NewScl, 0.2, 1.0, -1)
        else if IsMoreEqual(NewScl, 0.4) then
          IncRound(NewScl, 0.1, 0.6, -1)
        else
          IncRound(NewScl, 0.05, 0.4, -2);
      end;
  end;
  UpdateGeom(NewScl, FGeomRot, FGeomMir);
  Render;
end;

procedure TfrImage.giGemCmbSclChangeDone(Sender: TLofiComboBox; AText: string);
var
  NewScl: Double;
  R: TRgn;
begin
  NewScl := FGeomScl;
  AText := AnsiUpperCase(Trim(AText));
  if AText = 'FIT' then
  begin
    R := FFit.GraphicRgn;
    NewScl := NewScl * Min(FImgScn.Width / R.Width, FImgScn.Height / R.Height);
    NewScl := SimpleRoundTo(NewScl, -4);
    // correct region scene: set in ceneter window scene
    UpdateNavig(R.X1 + (R.Width - FImgScn.Width) / 2, R.Y1 + (R.Height - FImgScn.Height) / 2);
  end
  else
  begin
    AText := StringReplace(AText, '%', '', [rfReplaceAll]);
    NewScl := TxtToFloat(AText, NewScl * 100) / 100;
    NewScl := SimpleRoundTo(NewScl, -4);
    NewScl := EnsureRange(NewScl, cGeomScl.Min, cGeomScl.Max);
  end;
  UpdateGeom(NewScl, FGeomRot, FGeomMir);
  Render;
end;

procedure TfrImage.giGeomBtnRotClick(Sender: TObject);
const
  Step = 5;
var
  NewRot: Double;
begin
  NewRot := FGeomRot;
  case (Sender as TSpeedButton).Tag of
    -1: // anticlockwise
      begin
        NewRot := SimpleRoundTo(NewRot, 0);
        NewRot := NewRot - Step;
      end;
    +1: // clockwise
      begin
        NewRot := SimpleRoundTo(NewRot, 0);
        NewRot := NewRot + Step;
      end;
  end;
  UpdateGeom(FGeomScl, NewRot, FGeomMir);
  Render;
end;

procedure TfrImage.giGemCmbRotChangeDone(Sender: TLofiComboBox; AText: string);
var
  NewRot: Double;
begin
  NewRot := FGeomRot;
  AText := StringReplace(AText, '°', '', [rfReplaceAll]);
  NewRot := TxtToFloat(AText, NewRot);
  NewRot := SimpleRoundTo(NewRot, -1);
  UpdateGeom(FGeomScl, NewRot, FGeomMir);
  Render;
end;

procedure TfrImage.giGeomBtnFlipClick(Sender: TObject);
var
  NewMir: BooleanXY;
begin
  NewMir := FGeomMir;
  case (Sender as TSpeedButton).Tag of
    10: NewMir.X := not NewMir.X; // flip left to right
    20: NewMir.Y := not NewMir.Y; // flip top to down
  end;
  UpdateGeom(FGeomScl, FGeomRot, NewMir);
  Render;
end;

procedure TfrImage.giGeomBtnDefaultClick(Sender: TObject);
begin
  UpdateGeom(cGeomScl.Def, cGeomRotDef, cGeomMirDef);
  Render;
end;

procedure TfrImage.InitGeom;
begin
  giGemCmbScl.Hint := StringReplace(giGemCmbScl.Hint, LineEndingEscape, LineEnding, [rfReplaceAll]);
  giGemCmbRot.Hint := StringReplace(giGemCmbRot.Hint, LineEndingEscape, LineEnding, [rfReplaceAll]);
end;

procedure TfrImage.UpdateGeom(NewScl, NewRot: Double; NewMir: BooleanXY);
var
  Trn: Double; // number of complete revolutions, ~ 2PI
begin
  NewScl := SimpleRoundTo(NewScl, -4);
  if not SameValue(NewScl, FGeomScl, 1E-4) then
    NewScl := EnsureRange(NewScl, cGeomScl.Min, cGeomScl.Max);
  NewRot := System.Math.SimpleRoundTo(NewRot, -1);
  if not SameValue(NewRot, FGeomRot, 1E-1) then
  begin
    // correct to 2PI-cycle
    Trn := 360.0 * Trunc(abs(NewRot) / 360.0);
    if NewRot < 0 then
    begin
      NewRot := NewRot + Trn;
      if NewRot <> 0.0 then
        NewRot := 360.0 + NewRot;
    end
    else
      NewRot := NewRot - Trn;
  end;
  if (not SameValue(NewScl, FGeomScl, 1E-4)) or
     (not SameValue(NewRot, FGeomRot, 1E-1)) or
     (not (NewMir.X = FGeomMir.X)) or
     (not (NewMir.Y = FGeomMir.Y)) then
  begin
    FGeomScl := NewScl;
    FGeomRot := NewRot;
    FGeomMir := NewMir;
    Include(FUpdates, deGeom);
  end;
  Include(FRenders, deGeom);
end;

procedure TfrImage.RenderGeom;
begin
  if not ViewMenu then
    Exit;
  if giGeom.HeightState = hsMini then
    Exit;
  if not (deGeom in FRenders) then
    Exit;
  Exclude(FRenders, deGeom);
  giGemCmbScl.Text := FloatToStri(FGeomScl * 100) + '%';
  giGemCmbRot.Text := FloatToStri(FGeomRot, False, '%.1f') + '°';
end;

procedure TfrImage.giToneAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
var
  W: Integer;
begin
  W := EnsureRange(Round(AlignRect.Width * 100 / 200), 40, 120);
  if (Control = giToneTrackBrightness) or (Control = giToneTrackContrast) or (Control = giToneTrackGamma) then
  begin
    NewWidth := W;
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end
  else if (Control = giToneIconBrightness) or (Control = giToneIconContrast) or (Control = giToneIconGamma) then
  begin
    NewLeft := (AlignRect.Width - W) div 2 - CtrlGap div 2 - NewWidth;
  end
  else if (Control = giToneLabelBrightness) or (Control = giToneLabelContrast) or (Control = giToneLabelGamma) then
  begin
    NewLeft := (AlignRect.Width - W) div 2 + W + CtrlGap div 2;
  end
  else if (Control = giToneBtnDefault) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end;
end;

procedure TfrImage.giToneTrackChangeDone(Sender: TObject);
var
  Track: TTrackBar;
  NewBrightness, NewContrast, NewGamma: Double;
begin
  NewBrightness := FToneBrightness;
  NewContrast := FToneContrast;
  NewGamma := FToneGamma;
  Track := Sender as TTrackBar;
  case Track.Tag of
    10: NewBrightness := Track.Position / 100;
    20: NewContrast := Track.Position / 100;
    30: NewGamma := Track.Position / 100;
  end;
  UpdateTone(NewBrightness, NewContrast, NewGamma);
  Render;
end;

procedure TfrImage.giToneBtnDefaultClick(Sender: TObject);
begin
  UpdateTone(cToneBrightness.Def, cToneContrast.Def, cToneGamma.Def);
  Render;
end;

procedure TfrImage.InitTone;
begin
  with giToneTrackBrightness do
  begin
    Min := Trunc(cToneBrightness.Min * 100);
    Max := Trunc(cToneBrightness.Max * 100);
  end;
  with giToneTrackContrast do
  begin
    Min := Trunc(cToneContrast.Min * 100);
    Max := Trunc(cToneContrast.Max * 100);
  end;
  with giToneTrackGamma do
  begin
    Min := Trunc(cToneGamma.Min * 100);
    Max := Trunc(cToneGamma.Max * 100);
  end;
end;

procedure TfrImage.UpdateTone(NewBrightness, NewContrast, NewGamma: Double);
begin
  NewBrightness := SimpleRoundTo(NewBrightness, -4);
  NewBrightness := EnsureRange(NewBrightness, cToneBrightness.Min, cToneBrightness.Max);
  NewContrast   := SimpleRoundTo(NewContrast, -4);
  NewContrast   := EnsureRange(NewContrast, cToneContrast.Min, cToneContrast.Max);
  NewGamma      := SimpleRoundTo(NewGamma, -4);
  NewGamma      := EnsureRange(NewGamma, cToneGamma.Min, cToneGamma.Max);
  if (not SameValue(NewBrightness, FToneBrightness, 1E-4)) or
     (not SameValue(NewContrast, FToneContrast, 1E-4)) or
     (not SameValue(NewGamma, FToneGamma, 1E-4)) then
  begin
    FToneBrightness := NewBrightness;
    FToneContrast   := NewContrast;
    FToneGamma      := NewGamma;
    Include(FUpdates, deTone);
  end;
  Include(FRenders, deTone);
end;

procedure TfrImage.RenderTone;
begin
  if not ViewMenu then
    Exit;
  if giTone.HeightState = hsMini then
    Exit;
  if not (deTone in FRenders) then
    Exit;
  Exclude(FRenders, deTone);
  giToneTrackBrightness.Position := Trunc(FToneBrightness * 100);
  giToneTrackContrast.Position := Trunc(FToneContrast * 100);
  giToneTrackGamma.Position := Trunc(FToneGamma * 100);
  giToneLabelBrightness.Caption := FloatToStri(100 * PercentRange(FToneBrightness, cToneBrightness.Min, cToneBrightness.Max), False, '%.0f') + '%';
  giToneLabelContrast.Caption := FloatToStri(100 * PercentRange(FToneContrast, cToneContrast.Min, cToneContrast.Max), False, '%.0f') + '%';
  giToneLabelGamma.Caption := FloatToStri(FToneGamma, False, '%.1f');
end;

procedure TfrImage.giPalAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
begin
  if (Control = giPalCmbValue) then
  begin
    NewWidth := EnsureRange(Round(AlignRect.Width * 100 / 200), 40, 120);
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end
  else if (Control = giPalBtnOrder) or (Control = giPalBtnDefault) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end;
end;

procedure TfrImage.giPalCmbValueChangeDone(Sender: TLofiComboBox; AText: string);
var
  Cmb: TLofiComboBox;
  I: Integer;
  NewPal: PPalette;
begin
  NewPal := FPal;
  Cmb := Sender as TLofiComboBox;
  AText := AnsiUpperCase(Trim(AText));
  for I := 0 to Cmb.Items.Count - 1 do
   if AText = AnsiUpperCase(Cmb.Items[I]) then
   begin
     NewPal := PPalette(Cmb.Items.Objects[I]);
     Break;
   end;
  UpdatePal(NewPal, FPalOrder);
  Render;
end;

procedure TfrImage.giPalBtnOrderClick(Sender: TObject);
var
  NewPalOrder: TPaletteOrder;
begin
  if (Sender as TSpeedButton).Down then
    NewPalOrder := palInverse
  else
    NewPalOrder := palDirect;
  UpdatePal(FPal, NewPalOrder);
  Render;
end;

procedure TfrImage.giPalBtnDefaultClick(Sender: TObject);
begin
  UpdatePal(cPalDef, cPalOrderDef);
  Render;
end;

procedure TfrImage.InitPal;
  procedure giPalCmbValue_Items_Add(Pal: PPalette);
  begin
    giPalCmbValue.Items.AddObject(PalToStr(Pal), TObject(Pal));
  end;
var
  S: string;
  I: Integer;
begin
  giPalCmbValue.Items.BeginUpdate;
  giPalCmbValue.Text := '';
  giPalCmbValue_Items_Add(cPaletteGrayScale);
  giPalCmbValue_Items_Add(cPaletteHot);
  giPalCmbValue_Items_Add(cPaletteCool);
  giPalCmbValue_Items_Add(cPaletteBonnet);
  giPalCmbValue_Items_Add(cPaletteJet);
  giPalCmbValue.Items.EndUpdate;
  S := PalToStr(cPalDef);
  S := Profile.ReadString(ProfileSection, 'Pal', S);
  S := AnsiUpperCase(S);
  for I := 0 to giPalCmbValue.Items.Count - 1 do
    if S = AnsiUpperCase(giPalCmbValue.Items[I]) then
    begin
      FPal := PPalette(giPalCmbValue.Items.Objects[I]);
      Break;
    end;
end;

procedure TfrImage.UpdatePal(NewPal: PPalette; NewPalOrder: TPaletteOrder);
begin
  if NewPal = nil then
    NewPal := FPal;
  if (NewPal <> FPal) or (NewPalOrder <> FPalOrder) then
  begin
    FPal := NewPal;
    FPalOrder := NewPalOrder;
    Include(FUpdates, dePal);
  end;
  Include(FRenders, dePal);
end;

procedure TfrImage.RenderPal;
var
  I, W: Integer;
  Bmp: TBitmap;
  Item: TPaletteItem;
  ItemColor: TColor;
begin
  if not ViewMenu then
    Exit;
  if giPal.HeightState = hsMini then
    Exit;
  if not (dePal in FRenders) then
    Exit;
  Exclude(FRenders, dePal);
  Bmp := TBitmap.Create;
  try
    W := Length(FPal^);
    Bmp.SetSize(W, 1);
    for I := 0 to W - 1 do
    begin
      Item := FPal^[I];
      ItemColor := RGB(Item.R, Item.G, Item.B);
      case FPalOrder of
        palDirect:  Bmp.Canvas.Pixels[I, 0] := ItemColor;
        palInverse: Bmp.Canvas.Pixels[W - 1 - I, 0] := ItemColor;
      end;
    end;
    giPalImg.Picture.Bitmap := Bmp;
  finally
    Bmp.Free;
  end;
  I := giPalCmbValue.Items.IndexOfObject(TObject(FPal));
  giPalCmbValue.Text := giPalCmbValue.Items[I];
  giPalBtnOrder.Down := (FPalOrder = palInverse);
end;

procedure TfrImage.giHimAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
var
  W, L: Integer;
begin
  W := EnsureRange(Round(AlignRect.Width * 70 / 200), 40, 120);
  if (Control = giHimEditVal1) or (Control = giHimEditInd1) then
  begin
    NewWidth := W;
    NewLeft := (AlignRect.Width - CtrlGap) div 2 - NewWidth;
  end
  else if (Control = giHimEditVal2) or (Control = giHimEditInd2) then
  begin
    NewWidth := W;
    NewLeft := (AlignRect.Width + CtrlGap) div 2;
  end
  else if (Control = giHimBtnDefault) then
  begin
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end
  else
  begin
    W := NewWidth * 6;
    L := (AlignRect.Width - W) div 2;
    if Control = giHimBtnDec then
      W := 0
    else if Control = giHimBtnDec1 then
      W := 1
    else if Control = giHimBtnInc1 then
      W := 2
    else if Control = giHimBtnDec2 then
      W := 3
    else if Control = giHimBtnInc2 then
      W := 4
    else if Control = giHimBtnInc then
      W := 5;
    NewLeft := L + NewWidth * W;
  end;
end;

procedure TfrImage.giHimChartScroll(Sender: TObject);
begin
  FHimScroll := Assigned(FFit);
end;

procedure TfrImage.giHimChartMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  D: Double;
  H: THimNorm;
begin
  if FHimScroll then
  begin
    D := (giHimChart.BottomAxis.Minimum - HimNormToReal(FHim, FFit.GraphicColor).Index1) / FFit.GraphicColor.HistogramMeasure.CountItems;
    H.Index1 := FHim.Index1 + D;
    H.Index2 := FHim.Index2 + D;
    UpdateHim(H);
    Render;
  end;
  FHimScroll := False;
end;

procedure TfrImage.giHimEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var
  RealHim: THimReal;
  NewHim: THimNorm;
begin
  if Key <> VK_RETURN then
    Exit;
  if (Sender as TEdit).Name = 'giHimEditInd1' then
  begin
    giHimEditInd2.SetFocus;
    Exit;
  end;
  NewHim := FHim;
  RealHim := HimNormToReal(NewHim, FFit.GraphicColor);
  RealHim.Index1 := StrToIntDef(giHimEditInd1.Text, RealHim.Index1);
  RealHim.Index2 := StrToIntDef(giHimEditInd2.Text, RealHim.Index2);
  NewHim := HimRealToNorm(RealHim, FFit.GraphicColor);
  UpdateHim(NewHim);
  Render;
end;

procedure TfrImage.giHimBtnRangeClick(Sender: TObject);
var
  step: Double;
  NewHim: THimNorm;
begin
  NewHim := FHim;
  step := 1 / FFit.GraphicColor.HistogramMeasure.CountItems;
  case (Sender as TSpeedButton).Tag of
    -1: NewHim.Index1 := NewHim.Index1 - step;
    +1: NewHim.Index1 := NewHim.Index1 + step;
    -2: NewHim.Index2 := NewHim.Index2 - step;
    +2: NewHim.Index2 := NewHim.Index2 + step;
    -3:
      begin
        NewHim.Index1 := NewHim.Index1 - step;
        NewHim.Index2 := NewHim.Index2 - step;
      end;
    +3:
      begin
        NewHim.Index1 := NewHim.Index1 + step;
        NewHim.Index2 := NewHim.Index2 + step;
      end;
  end;
  UpdateHim(NewHim);
  Render;
end;

procedure TfrImage.giHimBtnDefaultClick(Sender: TObject);
begin
  UpdateHim(cHimDef);
  Render;
end;

procedure TfrImage.UpdateHim(NewHim: THimNorm);
begin
  // check of real-value takes place in MatchFit()
  // invalid! if NewHim.Index1 > NewHim.Index2 then NewHim := FHim;
  if (not SameValue(NewHim.Index1, FHim.Index1, 1E-5)) or (not SameValue(NewHim.Index2, FHim.Index2, 1E-5)) then
  begin
    FHim := NewHim;
    Include(FUpdates, deHim);
  end;
  Include(FRenders, deHim);
end;

procedure TfrImage.RenderHim;
var
  RangeReal: THimReal;
  X, Y, Xmin, Xmax, Ymin, Ymax: Integer;
  Data: PHistogram;
  Meas: THistogramMeasure;
  BarColor: TColor;

  function StrHimRealValue(Index: Integer): string;
  begin
    Result := '';
    if Index < 0 then
    begin
      Index := 0;
      Result := '<';
    end
    else if Index > (Meas.CountItems - 1) then
    begin
      Index := Meas.CountItems - 1;
      Result := '>';
    end;
    Result := Result + FloatToStri(Data^[Index]^.Value, False, '%g');
  end;

begin
  if not ViewMenu then
    Exit;
  if giHim.HeightState = hsMini then
    Exit;
  if not (deHim in FRenders) then
    Exit;
  Exclude(FRenders, deHim);
  if not Assigned(FFit) then
  begin
    giHimChartBarSeries.Clear;
    giHimEditVal1.Text := '';
    giHimEditVal2.Text := '';
    giHimEditInd1.Text := '';
    giHimEditInd2.Text := '';
    Exit;
  end;
  RangeReal := HimNormToReal(FHim, FFit.GraphicColor);
  Data := FFit.GraphicColor.Histogram;
  Meas := FFit.GraphicColor.HistogramMeasure;
  giHimEditVal1.Text := StrHimRealValue(RangeReal.Index1);
  giHimEditVal2.Text := StrHimRealValue(RangeReal.Index2);
  giHimEditInd1.Text := IntToStr(RangeReal.Index1);
  giHimEditInd2.Text := IntToStr(RangeReal.Index2);
  Xmin := RangeReal.Index1;
  Xmax := RangeReal.Index2;
  Ymin := 0;
  Ymax := Meas.ItemMaxSmooth;
  Ymax := Data^[Ymax]^.Count;
  giHimChartBarSeries.BeginUpdate;
  giHimChartBarSeries.Clear;
  giHimChart.BottomAxis.SetMinMax(Xmin, Xmax);
  giHimChart.LeftAxis.SetMinMax(Ymin, Ymax);
  // out dynamic range
  for X := Xmin to Xmax do
  begin
    if (X >= 0) and (X < Meas.CountItems) then
    begin
      Y := Data^[X]^.Count;
      if Y > Ymax then
        Y := Ymax;
      BarColor := clBlack;
    end
    else
    begin
      Y := Ymin;
      BarColor := clWhite;
    end;
    giHimChartBarSeries.AddXY(X, Y, '', BarColor);
  end;
  giHimChartBarSeries.EndUpdate;
end;

procedure TfrImage.giCopyMiOptClick(Sender: TObject);
begin
  CopyOpt;
end;

procedure TfrImage.CopyOpt;
var
  Bmp: TBitmap;
begin
  if ImgScnSel.Visible then
  begin
    Bmp := TBitmap.Create;
    Bmp.SetSize(ImgScnSel.Width, ImgScnSel.Height);
    Bmp.Canvas.CopyRect(ImgScnSel.ClientRect, ImgScn.Picture.Bitmap.Canvas, ImgScnSel.BoundsRect);
    Clipboard.Assign(Bmp);
    Bmp.Free;
    ImgScnSel.Visible := False;
    ImgScnSelHint.Visible := False;
  end
  else
  begin
    Clipboard.Assign(ImgScn.Picture.Bitmap);
  end;
end;

procedure TfrImage.giSaveMiOptClick(Sender: TObject);
begin
  SaveOpt;
end;

procedure TfrImage.SaveOpt;
const
  Ext: array [1 .. 2] of string = ('.bmp', '.jpg');
var
  I, PicType: Integer;
  S, PicName: string;
  Pic: TGraphic;
  PicCanvas: TCanvas;
begin
  // get picname
  PicName := '';
  with TSaveDialog.Create(nil) do
  begin
    Title := 'Save selected...';
    S := '';
    for I := Low(Ext) to High(Ext) do
      S := S + Format('*%s|*%s|', [Ext[I], Ext[I]]);
    Delete(S, Length(S), 1);
    Filter := S;
    FilterIndex := FSaveFilterIndex;
    if Execute then
    begin
      PicName := FileName;
      FSaveFilterIndex := FilterIndex;
    end;
    Free;
  end;
  if PicName = '' then
    Exit;
  // get pictype
  PicType := 0;
  S := AnsiLowerCase(ExtractFileExt(PicName));
  for I := Low(Ext) to High(Ext) do
    if S = Ext[I] then
    begin
      PicType := I;
      Break;
    end;
  if PicType = 0 then
  begin
    PicType := FSaveFilterIndex;
    PicName := PicName + Ext[PicType];
  end;
  // create pic
  Pic := nil;
  case PicType of
    1: Pic := TBitmap.Create;
    2: Pic := TJPEGImage.Create;
  end;
  try
    if ImgScnSel.Visible then
    begin
      Pic.SetSize(ImgScnSel.Width, ImgScnSel.Height);
      PicCanvas := nil;
      case PicType of
        1: PicCanvas := TBitmap(Pic).Canvas;
        2: PicCanvas := TJPEGImage(Pic).Canvas;
      end;
      PicCanvas.CopyRect(ImgScnSel.ClientRect, ImgScn.Picture.Bitmap.Canvas, ImgScnSel.BoundsRect);
      ImgScnSel.Visible := False;
      ImgScnSelHint.Visible := False;
    end
    else
    begin
      Pic.Assign(ImgScn.Picture.Bitmap);
    end;
    Pic.SaveToFile(PicName);
    MessageDlg('The image was successfully saved to a file' + sLineBreak + PicName, mtInformation, [mbOK], 0);
  finally
    if Assigned(Pic) then
      Pic.Free;
  end;
end;

end.


