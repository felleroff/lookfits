{ **************************************************** }
{  LookFits - Lister plugin (WLX) for view FITS files  }
{                                                      }
{                      Base Frame                      }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit ufrBase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.StrUtils,
  System.Classes, System.Math, System.UITypes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus, Vcl.StdCtrls, Lofi.ExtCtrls,
  uProfile, uUtils, ufmWinProgress, DeLaFitsString, DeLaFitsCommon,
  DeLaFitsGraphics;

const

  WM_FORM_AFTER_RESIZE = WM_USER + 1;

type

  ISubWin = record
    Progress: procedure (AOnStart: TOnStart; AOnExec: TOnExec; AOnStop: TOnStop) of object;
  end;

  TPanel = class(Vcl.ExtCtrls.TPanel)
  public
    property Canvas;
  end;

  { TfrBase }

  TfrBase = class(TFrame)
    PanelMain: TPanel;
    PanelMainSpace: TPanel;
    PanelMainScrollHor: TLofiScrollBar;
    PanelMainScrollVer: TLofiScrollBar;
    PmMain: TPopupMenu;
    miDivMenu: TMenuItem;
    miMenu: TMenuItem;
    PanelMenu: TLofiGroup;
    giInfo: TLofiGroupItem;
    giInfoMemo: TMemo;
    procedure PanelMainAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure PanelMainSpaceResize(Sender: TObject);
    procedure PmMainPopup(Sender: TObject);
    procedure miMenuClick(Sender: TObject);
  private
    FView: Boolean;
    FDockSitePanelMain: TWinControl;
    FDockSitePanelMenu: TWinControl;
    procedure SetView(const Value: Boolean);
    function GetViewMenu: Boolean;
    procedure SetViewMenu(const Value: Boolean);
    function GetBlocked: Boolean;
  protected
    FSubWin: ISubWin;
    FInit: Boolean;
    FFit: TFitsFileBitmap;
    FNew: Boolean;
    procedure ChangeSize; virtual;
    procedure ChangeView; virtual;
    function ProfileSection: string; virtual;
    function FitHduCoreAsString: string;
    procedure ActivateGroupItem(Item: TLofiGroupItem);
    procedure InitPopupMenu;
  public
    constructor Create(AOwner: TComponent; TheDockSitePanelMain, TheDockSitePanelMenu: TWinControl; TheSubWin: ISubWin); reintroduce;
    destructor Destroy; override;
    procedure FrameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState); virtual;
    procedure ReadProfile; virtual;
    procedure WriteProfile; virtual;
    procedure SetFit(Fit: TFitsFileBitmap); virtual;
    procedure Render; virtual;
    property View: Boolean read FView write SetView;
    property ViewMenu: Boolean read GetViewMenu write SetViewMenu;
    property Blocked: Boolean read GetBlocked;
  end;

const
   CtrlGap = 6;

implementation

{$R *.dfm}

{ TfrBase }

procedure TfrBase.SetView(const Value: Boolean);
  procedure UpDock(APanel, ANewDockSite: TWinControl);
  begin
    if APanel.Parent = Self then
    begin
      APanel.ManualDock(ANewDockSite);
      APanel.Align := alClient;
    end;
    //APanel.Visible := True;
    APanel.BringToFront;
  end;
  procedure UnDock(APanel: TWinControl);
  begin
    //APanel.Visible := False;
    APanel.SendToBack;
  end;
begin
  if Value = FView then
    Exit;
  if Value then
  begin
    UpDock(PanelMenu, FDockSitePanelMenu);
    UpDock(PanelMain, FDockSitePanelMain);
    FView := Value;
  end
  else
  begin
    FView := Value;
    UnDock(PanelMenu);
    UnDock(PanelMain);
  end;
  ChangeView;
end;

function TfrBase.GetViewMenu: Boolean;
begin
  Result := FView and (PanelMenu.Width > 1);
end;

procedure TfrBase.SetViewMenu(const Value: Boolean);
var
  W: Integer;
begin
  if not FView then
    Exit;
  if Value <> ViewMenu then
  begin
    if Value then
      W := 200
    else
      W := 1;
    (Owner as TForm).Perform(WM_FORM_AFTER_RESIZE, W, 0);
  end;
end;

function TfrBase.GetBlocked: Boolean;
begin
  Result := not FDockSitePanelMain.Enabled;
end;

procedure TfrBase.ChangeSize;
begin
  // stub, see PanelMainSpaceResize()
end;

procedure TfrBase.ChangeView;
begin
  // stub, see SetView();
end;

function TfrBase.ProfileSection: string;
begin
  Result := ClassName;
  Result := Copy(Result, 4, Length(Result) - 3);
end;

function TfrBase.FitHduCoreAsString: string;
var
  Lines: array [0 .. 5] of string;
begin
  Lines[0] := 'BitPix: %s';
  Lines[1] := 'NAxis1: %d';
  Lines[2] := 'NAxis2: %d';
  Lines[3] := 'BScale: %f%s';
  Lines[4] := 'BZero: %f%s';
  Lines[5] := 'File size (byte): %d';
  if not Assigned(FFit) then
  begin
    Result := LinesTxt(Lines, True);
  end
  else
  begin
    LinesFmt(Lines[0], [IntToStri(BitPixToInt(FFit.HduCore.BitPix), True, 2)]);
    LinesFmt(Lines[1], [FFit.HduCore.NAxis1]);
    LinesFmt(Lines[2], [FFit.HduCore.NAxis2]);
    LinesFmt(Lines[3], [FFit.HduCore.BScale, IfThen(FFit.LineIndexOf(cBSCALE) < 0, ' ~implicit', '')]);
    LinesFmt(Lines[4], [FFit.HduCore.BZero, IfThen(FFit.LineIndexOf(cBZERO) < 0, ' ~implicit', '')]);
    LinesFmt(Lines[5], [FFit.StreamSize]);
    Result := LinesTxt(Lines);
  end;
  Result := Result + LinesEnd;
end;

procedure TfrBase.ActivateGroupItem(Item: TLofiGroupItem);
begin
  ViewMenu := True;
  Item.HeightState := hsMaxi;
  with Item.Group do
    AnchorTop := AnchorTop - Item.Top;
end;

procedure TfrBase.InitPopupMenu;
var
  I, J, Wmax, Wdiv: Integer;
  S: string;
  Item: TMenuItem;
begin
  Wmax := 0;
  for I := 0 to PmMain.Items.Count - 1 do
  begin
    Item := PmMain.Items[I];
    S := Item.Caption;
    J := Pos(',', S);
    if J > 0 then
      Insert('   ', S, J + 1);
    Wmax := Max(Wmax, PanelMenu.Canvas.TextWidth(S));
    Item.Caption := S;
  end;
  Wdiv := PanelMenu.Canvas.TextWidth(' ');
  for I := 0 to PmMain.Items.Count - 1 do
  begin
    Item := PmMain.Items[I];
    S := Item.Caption;
    J := Pos(',', S);
    if J > 0 then
    begin
      while abs(Wmax - PanelMenu.Canvas.TextWidth(S)) > Wdiv do
        Insert(' ', S, J + 1);
      S[J] := ' ';
      Item.Caption := S;
    end;
  end;
end;

constructor TfrBase.Create(AOwner: TComponent; TheDockSitePanelMain, TheDockSitePanelMenu: TWinControl; TheSubWin: ISubWin);
begin
  inherited Create(AOwner);
  FView := False;
  FDockSitePanelMain := TheDockSitePanelMain;
  FDockSitePanelMenu := TheDockSitePanelMenu;
  FSubWin := TheSubWin;
  FInit := False;
  FFit := nil;
  FNew := False;
end;

destructor TfrBase.Destroy;
begin
  FDockSitePanelMain := nil;
  FDockSitePanelMenu := nil;
  FFit := nil;
  inherited Destroy;
end;

procedure TfrBase.FrameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    vkM:
      if Shift = [ssCtrl] then
      begin
        miMenu.Click;
        Key := 0;
      end;
  end;
end;

procedure TfrBase.ReadProfile;
var
  Section: string;
  I: Integer;
  A: TLofiGroupItem;
begin
  Section := ProfileSection;
  PanelMenu.AnchorTop := Profile.ReadInteger(Section, 'PanelMenu.AnchorTop', 0);
  for I := 0 to PanelMenu.ControlCount - 1 do
    if PanelMenu.Controls[I] is TLofiGroupItem then
    begin
      A := TLofiGroupItem(PanelMenu.Controls[I]);
      A.HeightState := Profile.ReadHeightState(Section, A.Name + '.HeightState', hsMaxi);
    end;
end;

procedure TfrBase.WriteProfile;
var
  Section: string;
  I: Integer;
  A: TLofiGroupItem;
begin
  Section := ProfileSection;
  Profile.WriteInteger(Section, 'PanelMenu.AnchorTop', PanelMenu.AnchorTop);
  for I := 0 to PanelMenu.ControlCount - 1 do
    if PanelMenu.Controls[I] is TLofiGroupItem then
    begin
      A := TLofiGroupItem(PanelMenu.Controls[I]);
      Profile.WriteHeightState(Section, A.Name + '.HeightState', A.HeightState);
    end;
end;

procedure TfrBase.SetFit(Fit: TFitsFileBitmap);
begin
  FFit := Fit;
  FNew := True;
end;

procedure TfrBase.Render;
begin
  FInit := True;
  FNew := False;
end;

procedure TfrBase.PanelMainAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
begin
  if Control = PanelMainSpace then
  begin
    NewLeft := 0;
    NewTop := 0;
    NewWidth  := AlignRect.Width - PanelMainScrollVer.Width;
    NewHeight := AlignRect.Height - PanelMainScrollHor.Height;
  end
  else
  if Control = PanelMainScrollVer then
  begin
    NewLeft := AlignRect.Width - NewWidth;
    NewHeight := AlignRect.Height - PanelMainScrollHor.Height;
  end
  else
  if Control = PanelMainScrollHor then
  begin
    NewTop := AlignRect.Height - NewHeight;
    NewWidth := AlignRect.Width - PanelMainScrollVer.Width;
  end;
end;

procedure TfrBase.PanelMainSpaceResize(Sender: TObject);
begin
  ChangeSize;
end;

procedure TfrBase.PmMainPopup(Sender: TObject);
begin
  miMenu.Caption := ifthen(ViewMenu, 'Hide', 'Show') + Copy(miMenu.Caption, 5, Length(miMenu.Caption));
end;

procedure TfrBase.miMenuClick(Sender: TObject);
begin
  ViewMenu := not ViewMenu;
end;

end.
