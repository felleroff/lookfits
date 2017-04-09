{ **************************************************** }
{           Components for project LookFits            }
{                                                      }
{ * Accordeon GroupBox of Panels;                      }
{ * Vertical Splitter with the hint about position;    }
{ * TLofiComboBox with OnChangeDone event;             }
{ * TLofiScrollBar with SetParams method;              }
{ * TLofiTrackBar with OnChangeDone event;             }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit Lofi.ExtCtrls;

interface

uses
  System.SysUtils, System.Classes, System.Types, Winapi.Windows, Vcl.Controls,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Graphics, Vcl.Forms;

type

  TLofiGroup = class;

  TLofiGroupItem = class;

  TLofiCustomGroup = class(TCustomPanel)
  private
    FMouseDown: Boolean;
    FMousePoint: TPoint;
    procedure IncGroupAnchorTop(Delta: Integer);
  protected
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
    property DockManager;
    property Canvas;
  published
    property Align;
    //property Alignment;
    property Anchors;
    //property AutoSize;
    //property BevelEdges;
    //property BevelInner;
    //property BevelKind;
    //property BevelOuter;
    //property BevelWidth;
    property BiDiMode;
    //property BorderWidth;
    //property BorderStyle;
    //property Caption;
    property Color;
    property Constraints;
    property Ctl3D;
    property UseDockManager default True;
    property DockSite;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FullRepaint;
    property Font;
    property Locked;
    property Padding;
    property ParentBiDiMode;
    property ParentBackground default False;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    //property ShowCaption;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Touch;
    //property VerticalAlignment;
    property Visible;
    property StyleElements;
    property OnAlignInsertBefore;
    property OnAlignPosition;
    property OnCanResize;
    property OnClick;
    property OnConstrainedResize;
    property OnContextPopup;
    property OnDockDrop;
    property OnDockOver;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnGetSiteInfo;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;
    property OnStartDock;
    property OnStartDrag;
    property OnUnDock;
  end;

  { TLofiGroup }

  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TLofiGroup = class(TLofiCustomGroup)
  private
    FHeightText: Integer;
    FHeightHead: Integer;
    FAnchorTop: Integer;
    procedure CalcHeightInfo;
    procedure SetAnchorTop(Value: Integer);
  protected
    procedure AdjustClientRect(var Rect: TRect); override;
    procedure ValidateInsert(AComponent: TComponent); override;
    procedure SetParent(AParent: TWinControl); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AnchorTop: Integer read FAnchorTop write SetAnchorTop;
  end;

  THeightState = (hsMini, hsMaxi);
  TOnChangeHeightState = procedure (Sender: TLofiGroupItem) of object;

  { TLofiGroupItem }

  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TLofiGroupItem = class(TLofiCustomGroup)
  private
    FHeightState: THeightState;
    FOnChangeHeightState: TOnChangeHeightState;
    FIconFocused: Boolean;
    function GetGroup: TLofiGroup;
    function GetHeightMin: Integer;
    function GetHeightMax: Integer;
    function GetIconRect: TRect;
    procedure SetHeightState(const Value: THeightState);
    procedure PaintCaption;
    procedure PaintBorder;
    procedure PaintIcon;
  protected
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Paint; override;
    procedure SetParent(AParent: TWinControl); override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AdjustHeight;
    property Group: TLofiGroup read GetGroup;
  published
    property Caption;
    property HeightMin: Integer read GetHeightMin;
    property HeightMax: Integer read GetHeightMax;
    property HeightState: THeightState read FHeightState write SetHeightState;
    property OnChangeHeightState: TOnChangeHeightState read FOnChangeHeightState write FOnChangeHeightState;
  end;

  { TLofiSplitter }

  TLofiSplitter = class;

  TOnCanLeft = procedure (Sender: TLofiSplitter; const OldLeft: Integer; var NewLeft: Integer) of object;

  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TLofiSplitter = class(TCustomPanel)
  private
    FHeightCursor: Integer;
    FHintText: TStaticText;
    FOldLeft: Integer;
    FMousePoint: TPoint;
    FOnCanLeft: TOnCanLeft;
    FBitmap: TBitmap;
    function GetHeightCursor: Integer;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ParentBackground default False;
  published
    property Cursor default crHSplit;
    property OnCanLeft: TOnCanLeft read FOnCanLeft write FOnCanLeft;
  end;

  { TLofiComboBox }

  TLofiComboBox = class;

  TOnChangeDone = procedure (Sender: TLofiComboBox; AText: string) of object;

  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TLofiComboBox = class(TComboBox)
  private
    FTextCache: string;
    FChanging: Boolean;
    FOnChangeDone: TOnChangeDone;
    procedure ChangeDone;
  protected
    procedure DoEnter; override;
    procedure DoExit; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Select; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property AutoComplete default False;
    property OnChangeDone: TOnChangeDone read FOnChangeDone write FOnChangeDone;
  end;

  { TLofiScrollBar }

  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TLofiScrollBar = class(TScrollBar)
  private
    function GetMaxScrollPos: Integer;
  protected
    procedure Scroll(ScrollCode: TScrollCode; var ScrollPos: Integer); override;
  public
    procedure SetParams(APosition, AMin, AMax, APageSize: Integer);
    property MaxScrollPos: Integer read GetMaxScrollPos;
  end;

  { TLofiTrackBar }

  [ComponentPlatformsAttribute(pidWin32 or pidWin64)]
  TLofiTrackBar = class(TTrackBar)
  private
    FTracking: Boolean;
    FPosition: Integer;
    FOnChangeDone: TNotifyEvent;
    procedure ChangeRise;
    procedure ChangeDone;
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property OnChangeDone: TNotifyEvent read FOnChangeDone write FOnChangeDone;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('LookFits', [TLofiGroup, TLofiSplitter, TLofiComboBox, TLofiScrollBar, TLofiTrackBar]);
  RegisterClasses([TLofiGroupItem]);
end;

const
  BvlSize  = 4;
  BrdSize  = 6;
  BrdColor = clActiveBorder;
  BkgColor = clActiveBorder;
  IconSize = 8; // size of icon in header of TLofiGroupItem
  clDark   = BrdColor;
  clLight  = clBtnFace;

function IfThen(AValue: Boolean; const ATrue: TColor; const AFalse: TColor): TColor; inline;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function Max(const V1, V2: Integer): Integer; inline;
begin
  if V1 > V2 then
    Result := V1
  else
    Result := V2;
end;

function InRect(X, Y: Integer; const Rect: TRect): Boolean; inline;
begin
  Result := (X >= Rect.Left) and (X <= Rect.Right) and
            (Y >= Rect.Top)  and (Y <= Rect.Bottom);
end;

{ TLofiCustomGroup }

procedure TLofiCustomGroup.IncGroupAnchorTop(Delta: Integer);
var
  Group: TLofiGroup;
begin
  if Delta = 0 then
    Exit;
  if Self is TLofiGroup then
    Group := Self as TLofiGroup
  else if Self is TLofiGroupItem then
    Group := (Self as TLofiGroupItem).Group
  else
    Group := nil;
  if Assigned(Group) then
    Group.AnchorTop := Group.AnchorTop + Delta;
end;

function TLofiCustomGroup.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint): Boolean;
const
  cDelta = 8;
var
  Delta: Integer;
begin
  Result := inherited;
  if Self is TLofiGroup then
    if not (Screen.ActiveControl is TComboBox) then
    begin
      if WheelDelta < 0 then
        Delta := -cDelta
      else if WheelDelta > 0 then
        Delta := +cDelta
      else
        Delta := 0;
      IncGroupAnchorTop(Delta);
      Result := True;
    end;
end;

procedure TLofiCustomGroup.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FMouseDown := True;
    FMousePoint := ClientToScreen(Point(X, Y));
  end;
  inherited;
end;

procedure TLofiCustomGroup.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  AMousePoint: TPoint;
begin
  if FMouseDown then
  begin
    AMousePoint := ClientToScreen(Point(X, Y));
    IncGroupAnchorTop(AMousePoint.y - FMousePoint.y);
    FMousePoint := AMousePoint;
  end;
  inherited;
end;

procedure TLofiCustomGroup.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMouseDown := False;
  inherited;
end;

constructor TLofiCustomGroup.Create(AOwner: TComponent);
begin
  inherited;
  ParentBackground := False;
  FMouseDown := False;
  FMousePoint := Point(0, 0);
end;

{ TLofiGroup }

procedure TLofiGroup.CalcHeightInfo;
begin
  FHeightText := Canvas.TextHeight('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789');
  if FHeightText < IconSize then
    FHeightText := IconSize;
  FHeightHead := BvlSize + FHeightText + BvlSize;
end;

procedure TLofiGroup.SetAnchorTop(Value: Integer);
const
  Lim = 20;
var
  Vmin, Vmax: Integer;
  I: Integer;
begin
  // valid value
  if not (csLoading in ComponentState) then
  begin
    Vmax := 0;
    Vmin := 0;
    for I := 0 to ControlCount - 1 do
      if Controls[I] is TLofiGroupItem then
        Vmin := Vmin + Controls[I].Height + BrdSize;
    if Vmin > 0 then
      Dec(Vmin, BrdSize);
    if Vmin > Lim then
      Dec(Vmin, Lim);
    if Vmin > 0 then
      Vmin := -Vmin;
    if Value > Vmax then
      Value := Vmax;
    if Value < Vmin then
      Value := Vmin;
  end;
  // set value
  if FAnchorTop <> Value then
  begin
    FAnchorTop := Value;
    Realign;
  end;
end;

procedure TLofiGroup.AdjustClientRect(var Rect: TRect);
begin
  inherited;
  Rect.Top := FAnchorTop;
end;

procedure TLofiGroup.ValidateInsert(AComponent: TComponent);
begin
  if not (AComponent is TLofiGroupItem) then
    raise EInvalidOperation.Create('Only LofiGroupItem can be inserted into a LofiGroup');
end;

procedure TLofiGroup.SetParent(AParent: TWinControl);
begin
  inherited;
  if AParent <> nil then
    CalcHeightInfo;
end;

constructor TLofiGroup.Create(AOwner: TComponent);
begin
  inherited;
  ShowCaption := False;
  BevelOuter := bvNone;
  Align := alRight;
  FHeightText := 0;
  FHeightHead := 0;
  FAnchorTop := 0;
end;

{ TLofiGroupItem }

function TLofiGroupItem.GetGroup: TLofiGroup;
begin
  Result := Parent as TLofiGroup;
end;

function TLofiGroupItem.GetHeightMin: Integer;
begin
  if Assigned(Group) then
    Result := Group.FHeightHead
  else
    Result := 0;
end;

function TLofiGroupItem.GetHeightMax: Integer;
var
  I: Integer;
  C: TControl;
begin
  Result := GetHeightMin;
  for I := 0 to ControlCount - 1 do
  begin
    C := Controls[I];
    Result := Max(Result, C.Top + C.Height + BvlSize);
  end;
end;

function TLofiGroupItem.GetIconRect: TRect;
begin
  Result.Right  := Width - BvlSize;
  Result.Left   := Result.Right - IconSize;
  Result.Top    := BvlSize;
  Result.Bottom := Result.Top + IconSize;
end;

procedure TLofiGroupItem.SetHeightState(const Value: THeightState);
begin
  if FHeightState <> Value then
  begin
    FHeightState := Value;
    AdjustHeight;
    if Assigned(FOnChangeHeightState) then
      FOnChangeHeightState(Self);
  end;
end;

procedure TLofiGroupItem.PaintBorder;
var
  R: TRect;
begin
  R := ClientRect;
  with Canvas do
  begin
    Pen.Style := psSolid;
    Pen.Width := 1;
    Pen.Color := BkgColor;
    Brush.Style := bsSolid;
    Brush.Color := BkgColor;
    Rectangle(0, 0, ClientWidth, HeightMin);
    Pen.Color := BrdColor;
    Brush.Style := bsClear;
    RoundRect(R, BvlSize * 2, BvlSize * 2);
  end;
end;

procedure TLofiGroupItem.PaintCaption;
var
  R: TRect;
  Flags: Longint;
begin
  R := ClientRect;
  R.Bottom := HeightMin;
  with Canvas do
  begin
    Brush.Style := bsClear;
    Font := Self.Font;
    Flags := DT_EXPANDTABS or DT_SINGLELINE or DT_CENTER or DT_VCENTER;
    Flags := DrawTextBiDiModeFlags(Flags);
    DrawText(Handle, Caption, -1, R, Flags);
  end;
end;

procedure TLofiGroupItem.PaintIcon;
const
  Pmin = 2;
  Pmax = IconSize - 1;
var
  R: TRect;
begin
  R := GetIconRect;
  with Canvas do
  begin
    Pen.Color := IfThen(FIconFocused, clBtnFace, clBtnShadow);
    Rectangle(R.Left + Pmin, R.Top, R.Left + Pmax, R.Top + (Pmax - Pmin));
    Rectangle(R.Left, R.Top + Pmin, R.Left + (Pmax - Pmin), R.Top + Pmax);
  end;
end;

procedure TLofiGroupItem.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if ((Shift = [ssLeft]) and FIconFocused) or
     ((Shift = [ssLeft, ssDouble]) and (Y < HeightMin)) then
  begin
    if HeightState = hsMini then
      HeightState := hsMaxi
    else
      HeightState := hsMini;
  end;
end;

procedure TLofiGroupItem.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  AIconFocused: Boolean;
begin
  inherited;
  if Shift = [] then
  begin
    AIconFocused := InRect(X, Y, GetIconRect);
    if AIconFocused <> FIconFocused then
    begin
      FIconFocused := AIconFocused;
      PaintIcon;
    end;
  end;
end;

procedure TLofiGroupItem.Paint;
begin
  inherited;
  PaintBorder;
  PaintCaption;
  PaintIcon;
end;

procedure TLofiGroupItem.SetParent(AParent: TWinControl);
begin
  if not (AParent is TLofiGroup) then
    if not (csDestroying in ComponentState) then
      raise EInvalidOperation.Create('LofiGroupItem must have a LofiGroup as its parent');
  inherited;
end;

procedure TLofiGroupItem.Loaded;
begin
  inherited;
  AdjustHeight;
end;

constructor TLofiGroupItem.Create(AOwner: TComponent);
begin
  inherited;
  ShowCaption := False;
  BevelOuter := bvNone;
  AlignWithMargins := True;
  Margins.SetBounds(BrdSize, 0, BrdSize, BrdSize);
  FHeightState := hsMaxi;
  FOnChangeHeightState := nil;
  FIconFocused := False;
end;

procedure TLofiGroupItem.AdjustHeight;
begin
  case FHeightState of
    hsMini: Height := HeightMin;
    hsMaxi: Height := HeightMax;
  end;
end;

{ TLofiSplitter }

constructor TLofiSplitter.Create(AOwner: TComponent);
begin
  inherited;
  ParentBackground := False;
  ShowCaption := False;
  BevelOuter := bvNone;
  Cursor := crHSplit;
  FHeightCursor := GetHeightCursor;
  FHintText := TStaticText.Create(Self);
  FHintText.Alignment := taCenter;
  FHintText.Transparent := False;
  FHintText.Color := clInfoBk;
  FHintText.Visible := False;
  FOldLeft := -1;
  FMousePoint := Point(-1, -1);
  FBitmap := TBitmap.Create;
end;

destructor TLofiSplitter.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

function TLofiSplitter.GetHeightCursor: Integer;
// http://stackoverflow.com/questions/1699666/how-do-i-know-the-size-of-a-hcursor-object
var
  Ico: PICONINFOEX;
begin
  try
    New(Ico);
    Ico.cbSize := SizeOf(Ico^);
    try
      if GetIconInfoEx(GetCursor, Ico) then
        Result := Ico^.yHotspot
      else
        Result := GetSystemMetrics(SM_CYCURSOR) div 2;
    finally
      Dispose(Ico);
    end;
  except
    Result := 16;
  end;
end;

procedure TLofiSplitter.Loaded;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    BringToFront;
    FHintText.Parent := Parent;
    FHintText.BringToFront;
  end;
end;

procedure TLofiSplitter.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    FHintText.Caption := IntToStr(Parent.ClientWidth - Left - ClientWidth);
    FHintText.Visible := True;
    FHintText.SetBounds(Left - FHintText.Width div 2, Y + FHeightCursor, FHintText.Width, FHintText.Height);
    FOldLeft := Left;
    FMousePoint := ClientToParent(Point(X, Y));
  end;
  inherited;
end;

procedure TLofiSplitter.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
begin
  if FHintText.Visible then
  begin
    P := ClientToParent(Point(X, Y));
    Left := FOldLeft + (P.X - FMousePoint.X);
    FHintText.Caption := IntToStr(Parent.ClientWidth - Left - ClientWidth);
    FHintText.SetBounds(Left + ClientWidth div 2 - FHintText.Width div 2, P.Y + FHeightCursor, FHintText.Width, FHintText.Height);
  end;
  inherited;
end;

procedure TLofiSplitter.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  NewLeft: Integer;
begin
  if FHintText.Visible then
  begin
    FHintText.Visible := False;
    if Assigned(FOnCanLeft) then
    begin
      NewLeft := Left;
      FOnCanLeft(Self, FOldLeft, NewLeft);
      Left := NewLeft;
    end;
    Invalidate;
  end;
  inherited;
end;

procedure TLofiSplitter.Paint;
var
  R: TRect;
begin
  inherited;
  R := ClientRect;
  FBitmap.SetSize(R.Width, R.Height);
  FBitmap.Canvas.CopyRect(R, Canvas, R);
  with FBitmap.Canvas do
  begin
    Brush.Style := bsSolid;
    if FHintText.Visible then
    begin
      Pen.Color := clDark;
      Brush.Color := clDark;
      Rectangle(R);
      Pen.Color := clLight;
      Brush.Color := clLight;
    end
    else
    begin
      Pen.Color := clDark;
      Brush.Color := clDark;
    end;
    R.Left := R.Width div 2 - 1;
    R.Right := R.Left + 3;
    R.Top := R.Height div 2 - 1;
    R.Bottom := R.Top + 3;
    Ellipse(R);
    R.Offset(0, -(R.Width + 2));
    Ellipse(R);
    R.Offset(0, (R.Width + 2) * 2);
    Ellipse(R);
  end;
  Canvas.Draw(0, 0, FBitmap);
end;

{ TLofiComboBox }

procedure TLofiComboBox.ChangeDone;
begin
  FChanging := True;
  FTextCache := Text;
  try
    if Assigned(FOnChangeDone) then
      FOnChangeDone(Self, Text);
  finally
    FChanging := False;
    FTextCache := Text;
  end;
end;

constructor TLofiComboBox.Create(AOwner: TComponent);
begin
  inherited;
  FTextCache := '';
  FChanging := False;
  FOnChangeDone := nil;
  AutoComplete := False;
end;

procedure TLofiComboBox.DoEnter;
begin
  inherited;
  FTextCache := Text;
end;

procedure TLofiComboBox.DoExit;
begin
  inherited;
  if not FChanging then
  begin
    Text := FTextCache;
    ItemIndex := Items.IndexOf(FTextCache);
  end;
end;

procedure TLofiComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_RETURN then
    ChangeDone;
end;

procedure TLofiComboBox.Select;
begin
  inherited;
  ChangeDone;
end;

{ TLofiScrollBar }

function TLofiScrollBar.GetMaxScrollPos: Integer;
begin
  // https://msdn.microsoft.com/en-us/library/windows/desktop/bb787527(v=vs.85).aspx
  // MaxScrollPos = MaxRangeValue - (PageSize - 1)
  Result := Max - (PageSize - 1);
end;

procedure TLofiScrollBar.Scroll(ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if ScrollPos > MaxScrollPos then
    ScrollPos := MaxScrollPos;
  inherited;
end;

procedure TLofiScrollBar.SetParams(APosition, AMin, AMax, APageSize: Integer);
var
  AOnScroll: TScrollEvent;
  ALargeChange: Integer;
begin
  AOnScroll := OnScroll;
  try
    OnScroll := nil;
    PageSize := 0;
    inherited SetParams(APosition, AMin, AMax);
    PageSize := APageSize;
    ALargeChange := APageSize div 2;
    if ALargeChange < 1 then
      ALargeChange := 1;
    LargeChange := ALargeChange;
  finally
    OnScroll := AOnScroll;
  end;
end;

{ TLofiTrackBar }

procedure TLofiTrackBar.ChangeRise;
begin
  FTracking := True;
  FPosition := Position;
end;

procedure TLofiTrackBar.ChangeDone;
begin
  if FTracking then
    if FPosition <> Position then
      if Assigned(FOnChangeDone) then
        FOnChangeDone(Self);
  FTracking := False;
  FPosition := Position;
end;

procedure TLofiTrackBar.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  ChangeRise;
end;

procedure TLofiTrackBar.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  ChangeDone;
end;

procedure TLofiTrackBar.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  ChangeRise;
end;

procedure TLofiTrackBar.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited;
  ChangeDone;
end;

constructor TLofiTrackBar.Create(AOwner: TComponent);
begin
  inherited;
  FTracking := False;
  FPosition := 0;
  FOnChangeDone := nil;
end;

end.

