{ **************************************************** }
{  LookFits - Lister plugin (WLX) for view FITS files  }
{                                                      }
{               Common types & functions               }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit uUtils;

interface

uses
  System.Classes, System.SysUtils, System.StrUtils, System.Math,
  Winapi.Windows, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Grids,
  DeLaFitsCommon, DeLaFitsMath, DeLaFitsGraphics;

type

  StringFix = record
    Def: string;
    DefView: string;
  end;

  IntegerFix = record
    Min, Max, Def: Integer;
    DefView: string;
  end;

  DoubleFix = record
    Min, Max, Def: Double;
  end;

  BooleanXY = record
    X, Y: Boolean;
  end;

  const
    LinesEnd         = #13;
    LinesItemDelim   = #9;
    LineEnding       = #13#10;
    LineEndingEscape = '##';

  function LinesTxt(const Lines: array of string; Empty: Boolean = False): string;
  procedure LinesFmt(var Line: string; const Args: array of const);

  function RepToStr(const Rep: TRep): string;
  function RgnToStr(const Rgn: TRgn): string;
  function MergeRgn(const R1, R2: TRgn): TRgn; inline;

  function PalToStr(Palette: PPalette): string;

  type
    THimReal = THistogramDynamicRange;
    THimNorm = record
      Index1, Index2: Double;
    end;

  function HimRealToNorm(Value: THimReal; Graph: TGraphicColor): THimNorm;
  function HimNormToReal(Value: THimNorm; Graph: TGraphicColor): THimReal;

  function TxtToFloat(Txt: string; const Default: Double): Double;

  function IsLessEqual(const V1, V2: Double): Boolean;
  function IsMoreEqual(const V1, V2: Double): Boolean;
  procedure DecRound(var Value: Double; const Step, Minimum: Double; const Digits: TRoundToRange);
  procedure IncRound(var Value: Double; const Step, Maximum: Double; const Digits: TRoundToRange);

  function StrCountOccur(const Sub, S: string): Integer;

  function EnsureRing(const AValue, AMin, AMax: Integer): Integer; inline;
  function PercentRange(const AValue, AMin, AMax: Double): Double; inline;

  type
    TGridSpec = record
      SelectedColor: TColor;
      CellBorder: TSize;
      CellBorderHalf: TSize;
      CellSizeMin: TSize;
    end;

  const
    cGridSpec: TGridSpec = (
      SelectedColor: $00DBEFFF;
      CellBorder: (cx: 4 + 4; cy: 2 + 2);
      CellBorderHalf: (cx: 4; cy: 2);
      CellSizeMin: (cx: 8 + 8; cy: 12 + 4);
      );

  function ToSize(cx, cy: Integer): TSize; inline;
  function ToGridRect(ALeft, ATop, ARight, ABottom: Integer): TGridRect; inline;
  function Max(const V1, V2: TSize): TSize; inline; overload;
  function Sum(const V1, V2: TSize): TSize; inline; overload;
  function Sum(const V1: TSize; cx, cy: Integer): TSize; inline; overload;
  function IfThenColor(AValue: Boolean; const ATrue, AFalse: TColor): Integer; inline;

  procedure ShowHintInvalid(AControl: TControl; const AText: string);

implementation

function LinesTxt(const Lines: array of string; Empty: Boolean = False): string;
var
  I: Integer;
begin
  Result := '';
  if Length(Lines) = 0 then
    Exit;
  for I := Low(Lines) to High(Lines) do
    Result := Result + System.StrUtils.IfThen(Empty, '', Lines[I]) + LinesEnd;
  Delete(Result, Length(Result), 1);
end;

procedure LinesFmt(var Line: string; const Args: array of const);
var
  fs: TFormatSettings;
begin
  fs := TFormatSettings.Create;
  fs.DecimalSeparator := '.';
  Line := Format(Line, Args, fs);
end;

function RepToStr(const Rep: TRep): string;
begin
  case Rep of
    rep08u        : Result := 'Integer 8 bits, unsigned';
    rep08c, rep16c: Result := 'Integer 16 bits, signed';
    rep16u        : Result := 'Integer 16 bits, unsigned';
    rep32c        : Result := 'Integer 32 bits, signed';
    rep32u        : Result := 'Integer 32 bits, unsigned';
    rep64c        : Result := 'Integer 64 bits, signed';
    rep32f        : Result := 'Float 32 bits (single)';
    rep64f, rep80f: Result := 'Float 64 bits (double)';
    else {repUnknown}
                    Result := 'Unknown';
  end;
end;

function RgnToStr(const Rgn: TRgn): string;
begin
  Result := Format('%d; %d; %d; %d', [Rgn.X1, Rgn.Y1, Rgn.Width, Rgn.Height]);
end;

function MergeRgn(const R1, R2: TRgn): TRgn; inline;
var
  Xmin, Ymin, Xmax , Ymax: Integer;
begin
  Xmin := System.Math.Min(R1.X1, R2.X1);
  Ymin := System.Math.Min(R1.Y1, R2.Y1);
  Xmax := System.Math.Max(R1.X1 + R1.Width   - 1, R2.X1 + R2.Width  - 1);
  Ymax := System.Math.Max(R1.Y1 + R1.Height  - 1, R2.Y1 + R2.Height - 1);
  Result := ToRgnWiHe(Xmin, Ymin, Xmax - Xmin + 1, Ymax - Ymin + 1);
end;

function PalToStr(Palette: PPalette): string;
begin
  if Palette = cPaletteGrayScale then
    Result := 'GrayScale'
  else if Palette = cPaletteHot then
    Result := 'Hot'
  else if Palette = cPaletteCool then
    Result := 'Cool'
  else if Palette = cPaletteBonnet then
    Result := 'Bonnet'
  else if Palette = cPaletteJet then
    Result := 'Jet'
  else
    Result := '';
end;

// Calculation indexes of dynamic range in relative units
function HimRealToNorm(Value: THimReal; Graph: TGraphicColor): THimNorm;
var
  N: Integer;
  RealDef: THimReal;
begin
  N := Graph.HistogramMeasure.CountItems;
  RealDef := Graph.HistogramMeasure.DynamicRangeDefault;
  Result.Index1 := (Value.Index1 - RealDef.Index1) / N;
  Result.Index2 := (Value.Index2 - RealDef.Index2) / N;
end;

// Calculation indexes of dynamic range in absolute units
function HimNormToReal(Value: THimNorm; Graph: TGraphicColor): THimReal;
var
  N: Integer;
  RealDef: THimReal;
begin
  N := Graph.HistogramMeasure.CountItems;
  RealDef := Graph.HistogramMeasure.DynamicRangeDefault;
  Result.Index1 := MathRound(RealDef.Index1 + Value.Index1 * N);
  Result.Index2 := MathRound(RealDef.Index2 + Value.Index2 * N);
end;

function TxtToFloat(Txt: string; const Default: Double): Double;
var
  fs: TFormatSettings;
begin
  Txt := Trim(Txt);
  Txt := StringReplace(Txt, ',', '.', [rfReplaceAll]);
  fs := TFormatSettings.Create;
  fs.DecimalSeparator := '.';
  Result := StrToFloatDef(Txt, Default, fs);
end;

function IsLessEqual(const V1, V2: Double): Boolean;
begin
  Result := (V1 < V2) or System.Math.SameValue(V1, V2, 1E-4);
end;

function IsMoreEqual(const V1, V2: Double): Boolean;
begin
  Result := (V1 > V2) or System.Math.SameValue(V1, V2, 1E-4);
end;

procedure DecRound(var Value: Double; const Step, Minimum: Double; const Digits: TRoundToRange);
begin
  Value := Value - Step;
  Value := System.Math.SimpleRoundTo(Value, Digits);
  if Value < Minimum then
    Value := Minimum;
end;

procedure IncRound(var Value: Double; const Step, Maximum: Double; const Digits: TRoundToRange);
begin
  Value := Value + Step;
  Value := System.Math.SimpleRoundTo(Value, Digits);
  if Value > Maximum then
    Value := Maximum;
end;

function StrCountOccur(const Sub, S: string): Integer;
var
  X: Integer;
begin
  Result := 0;
  X := 1;
  while True do
  begin
    X := PosEx(Sub, S, X);
    if X = 0 then
      Break;
    Inc(Result);
    Inc(X);
  end;
end;

function EnsureRing(const AValue, AMin, AMax: Integer): Integer; inline;
begin
  Result := AValue;
  if Result > AMax then
    Result := AMin
  else if Result < AMin then
    Result := AMax;
end;

function PercentRange(const AValue, AMin, AMax: Double): Double; inline;
begin
  Result := (AValue - AMin) / (AMax - AMin);
end;

function ToSize(cx, cy: Integer): TSize; inline;
begin
  Result.cx := cx;
  Result.cy := cy;
end;

function ToGridRect(ALeft, ATop, ARight, ABottom: Integer): TGridRect; inline;
begin
  Result.Left   := ALeft;
  Result.Top    := ATop;
  Result.Right  := ARight;
  Result.Bottom := ABottom;
end;

function Max(const V1, V2: TSize): TSize; inline; overload;
begin
  if V1.cx > V2.cx then
    Result.cx := V1.cx
  else
    Result.cx := V2.cx;
  if V1.cy > V2.cy then
    Result.cy := V1.cy
  else
    Result.cy := V2.cy;
end;

function Sum(const V1, V2: TSize): TSize; inline; overload;
begin
  Result.cx := V1.cx + V2.cx;
  Result.cy := V1.cy + V2.cy;
end;

function Sum(const V1: TSize; cx, cy: Integer): TSize; inline; overload;
begin
  Result.cx := V1.cx + cx;
  Result.cy := V1.cy + cy;
end;

function IfThenColor(AValue: Boolean; const ATrue, AFalse: TColor): Integer; inline;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

type

  { THintInvalid }

  THintInvalid = class(TForm)
  private
    FText: string;
  protected
    procedure Paint; override;
    procedure DoClose(var CloseAction: TCloseAction); override;
    procedure Click; override;
    procedure Deactivate; override;
  public
    constructor CreateNew(AOwner: TControl; const AText: string); reintroduce;
  end;

procedure THintInvalid.Paint;
const
  clBorder = $000133D6;
  clBackground = $00BACCFF;
  clFont = clBorder;
begin
  inherited Paint;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Color := clBorder;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clBackground;
  Canvas.Font.Color := clFont;
  Canvas.Rectangle(ClientRect);
  Canvas.Brush.Color := clFont;
  Canvas.Rectangle(4, 4, 18, 18);
  Canvas.Pen.Color := clBackground;
  Canvas.MoveTo(10, 6);
  Canvas.LineTo(10, 13);
  Canvas.MoveTo(11, 6);
  Canvas.LineTo(11, 13);
  Canvas.MoveTo(10, 15);
  Canvas.LineTo(10, 16);
  Canvas.MoveTo(11, 15);
  Canvas.LineTo(11, 16);
  Canvas.TextRect(ClientRect, 22, 4, FText);
end;

procedure THintInvalid.DoClose(var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  inherited DoClose(CloseAction);
end;

procedure THintInvalid.Click;
begin
  inherited Click;
  Close;
end;

procedure THintInvalid.Deactivate;
begin
  inherited Deactivate;
  Close;
end;

constructor THintInvalid.CreateNew(AOwner: TControl; const AText: string);
var
  L, T, W, H: Integer;
begin
  inherited CreateNew(AOwner);
  FText := AText;
  AlphaBlend := True;
  AlphaBlendValue := 240;
  BorderStyle := bsNone;
  with AOwner.ClientOrigin do
  begin
    L := X;
    T := Y + AOwner.Height + 2;
  end;
  with Canvas.TextExtent(FText) do
  begin
    W := Max(AOwner.Width, 4 + 14 + 4 + cx + 4);
    H := 4 + cy + 4;
  end;
  SetBounds(L, T, W, H);
end;

procedure ShowHintInvalid(AControl: TControl; const AText: string);
var
  Hint: THintInvalid;
begin
  Hint := THintInvalid.CreateNew(AControl, AText);
  Hint.Show;
end;

end.

