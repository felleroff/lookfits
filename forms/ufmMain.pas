{ **************************************************** }
{  LookFits - Lister plugin (WLX) for view FITS files  }
{                                                      }
{                      Main Form                       }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit ufmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellAPI, System.SysUtils,
  System.Classes, System.Types, System.UITypes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons,
  // library
  DeLaFitsCommon, DeLaFitsGraphics,
  // project controls
  Lofi.ExtCtrls,
  // project modules
  uProfile, ufmWinProgress, ufrBase, ufrHeader, ufrData, ufrImage;

type

  TfmMain = class(TForm)

  published
    SitePanelMain: TPanel;
    Split: TLofiSplitter;
    PanelMenu: TPanel;
    BtnHeader: TSpeedButton;
    BtnData: TSpeedButton;
    BtnImage: TSpeedButton;
    BtnScrollUp: TSpeedButton;
    BtnScrollDown: TSpeedButton;
    TimerScroll: TTimer;
    SitePanelMenu: TPanel;
    LabelCopyright: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure SplitCanLeft(Sender: TLofiSplitter; const OldLeft: Integer; var NewLeft: Integer);
    procedure BtnFrameClick(Sender: TObject);
    procedure BtnScrollMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtnScrollMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PanelMenuAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure TimerScrollTimer(Sender: TObject);
    procedure LabelCopyrightClick(Sender: TObject);
    procedure LabelCopyrightMouseEnter(Sender: TObject);
    procedure LabelCopyrightMouseLeave(Sender: TObject);
  private
    FFirstShow: Boolean; // flag of the first form display
    procedure WmFormAfterResize(var Message :TMessage); message WM_FORM_AFTER_RESIZE;
  private
    frHeader: TfrHeader;
    frData: TfrData;
    frImage: TfrImage;
    procedure AlignPanels(PanelMenuNewWidth: Integer);
  private
    fmWinProgress: TfmWinProgress;
    procedure WinProgress(AOnStart: TOnStart; AOnExec: TOnExec; AOnStop: TOnStop);
    procedure SubWinShowed(Sender: TObject);
    procedure SubWinClosed(Sender: TObject);
    procedure SubWinClose;
    function SubWinActive: Boolean;
    function SubWinInterface: ISubWin;
 private
    FFit: TFitsFileBitmap;
    procedure LoadFit(const AFileName: string);
    procedure DropFit;
    procedure ShowFit;
  private
    function FrameItemCopy: TfrBase;
    function FrameItemIndex: Integer;
  private const
     cSection = 'Main';
  private
    procedure ReadProfile;
    procedure WriteProfile;
  private const
     sScrollStep = 4;
  private
    FTimerScrollStep: Integer; // value and direct scroll
    FTimerScrollCall: Boolean; // flag in guaranteed call TimerScrollTimer

  {$IFDEF PRAPP}
  protected
    procedure Loaded; override;
  {$ENDIF}

  {$IFDEF PRWLX}
  private
    FParentWin: HWND;    // handle of Lister window
    FQuickView: Boolean; // Ctrl+Q panel
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor CreateParented(AParentWindow: HWND);
  public
    class function PluginShow(ListerWin: HWND; FileToLoad: string): HWND;
    class function PluginShowNext(PluginWin: HWND; FileToLoad: string): Integer;
    class function PluginHide(PluginWin: HWND): HWND;
  {$ENDIF}

  end;

{$IFDEF PRAPP}
var
  fmMain: TfmMain;
{$ENDIF}

implementation

{$R *.dfm}

{ TfmMain }

procedure TfmMain.FormCreate(Sender: TObject);
begin
  fmWinProgress := TfmWinProgress.Create(Self, SubWinShowed, SubWinClosed);
  fmWinProgress.ManualDock(Self);
  frHeader := TfrHeader.Create(Self, SitePanelMain, SitePanelMenu, SubWinInterface);
  frData   := TfrData.Create(Self, SitePanelMain, SitePanelMenu, SubWinInterface);
  frImage  := TfrImage.Create(Self, SitePanelMain, SitePanelMenu, SubWinInterface);
  BtnHeader.Tag := NativeInt(frHeader);
  BtnData.Tag := NativeInt(frData);
  BtnImage.Tag := NativeInt(frImage);
  FFirstShow := True;
  FFit := nil;
  FTimerScrollCall := True;
  FTimerScrollStep := 0;
  ReadProfile;
  {$IFDEF PRAPP}
  // debug: auto load fits
  Caption := ExtractFilePath(ParamStr(0));
  Caption := IncludeTrailingPathDelimiter(Caption);
  Caption := Caption + 'temp.fit';
  LoadFit(Caption);
  {$ENDIF}
end;

procedure TfmMain.FormResize(Sender: TObject);
begin
  PostMessage(Handle, WM_FORM_AFTER_RESIZE, PanelMenu.Width, 0);
end;

procedure TfmMain.WmFormAfterResize(var Message: TMessage);
begin
  AlignPanels(Message.WParam);
  if FFirstShow then
    ShowFit;
  FFirstShow := False;
end;

procedure TfmMain.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure BtnClickDown(Btn: TSpeedButton);
  begin
    Btn.Down := not Btn.Down;
    Btn.Click;
  end;
var
  EditMode: Boolean;
begin
  EditMode := False;
  if Assigned(ActiveControl) then
  begin
    if (ActiveControl is TEdit) then
      EditMode := not TEdit(ActiveControl).ReadOnly
    else if (ActiveControl is TComboBox) then
      EditMode := TComboBox(ActiveControl).Style = csDropDown;
  end;
  case Key of
    {$IFDEF PRWLX}
    // Close
    VK_ESCAPE:
      begin
        if not FQuickView then
          PostMessage(FParentWin, WM_KEYDOWN, VK_ESCAPE, 0)
        else
          PostMessage(FParentWin, WM_KEYDOWN, VK_TAB, 0);
        Key := 0;
      end;
    // Options -> 1..7
    vk1..vk7:
      if not EditMode then
      begin
        PostMessage(FParentWin, WM_KEYDOWN, Key, 0);
        Key := 0;
      end;
    // File -> Next (N) or Prev (P)
    vkN, vkP:
      if not EditMode then
      begin
        PostMessage(FParentWin, WM_KEYDOWN, Key, 0);
        Key := 0;
      end;
    // Ctrl+Q panel
    // http://forum.vingrad.ru/topic-169161.html
    // http://programmersforum.ru/showthread.php?p=558929
    vkQ:
      if FQuickView and (Shift = [ssCtrl]) then
      begin
        Winapi.Windows.SetFocus(FParentWin);
        keybd_event(VK_CONTROL, 0, 0, 0);
        keybd_event(vkQ, 0, 0, 0);
        keybd_event(vkQ, 0, KEYEVENTF_KEYUP, 0);
        keybd_event(VK_CONTROL, 0, KEYEVENTF_KEYUP, 0);
        Key := 0;
      end;
    {$ENDIF}
    VK_SPACE:
      if (Shift = [ssCtrl]) and (not SubWinActive) then
      begin
        if BtnHeader.Down then BtnClickDown(BtnData)
        else if BtnData.Down then BtnClickDown(BtnImage)
        else {if BtnImage.Down then} BtnClickDown(BtnHeader);
        Key := 0;
      end;
    // other key
    else
      if (not SubWinActive) and (not EditMode) then
      begin
        FrameItemCopy.FrameKeyDown(ActiveControl, Key, Shift);
      end;
  end;
end;

procedure TfmMain.FormDestroy(Sender: TObject);
begin
  DropFit;
  WriteProfile;
end;

procedure TfmMain.SplitCanLeft(Sender: TLofiSplitter; const OldLeft: Integer; var NewLeft: Integer);
begin
  AlignPanels(ClientWidth - (NewLeft + Sender.ClientWidth));
  NewLeft := Split.Left;
end;

procedure TfmMain.BtnFrameClick(Sender: TObject);
var
  fr: TfrBase;
begin
  // because here FrameItemCopy = Sender.Tag
  frHeader.View := False;
  frData.View := False;
  frImage.View := False;
  fr := TfrBase((Sender as TSpeedButton).Tag);
  fr.View := True;
  fr.Render;
end;

procedure TfmMain.BtnScrollMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender as TSpeedButton).Name = 'BtnScrollUp' then
    FTimerScrollStep := -sScrollStep
  else
    FTimerScrollStep := +sScrollStep;
  FTimerScrollCall := False;
  TimerScroll.Enabled := True;
end;

procedure TfmMain.BtnScrollMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TimerScroll.Enabled := False;
  // forced call
  if not FTimerScrollCall then
    TimerScrollTimer(TimerScroll);
end;

procedure TfmMain.PanelMenuAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
const
  Brd = 6;
begin
  if (Control = BtnHeader) or (Control = BtnData) or (Control = BtnImage) then
  begin
    NewLeft := (AlignRect.Width - (Control.Width * 3 + Brd * 2)) div 2;
    if Control = BtnData then
      NewLeft := NewLeft + Control.Width + Brd;
    if Control = BtnImage then
      NewLeft := NewLeft + Control.Width * 2 + Brd * 2;
  end;
  if (Control = BtnScrollUp) or (Control = BtnScrollDown) then
  begin
    NewLeft := (AlignRect.Width - (Control.Width * 2 + Brd)) div 2;
    if Control = BtnScrollDown then
      NewLeft := NewLeft + Control.Width + Brd;
  end;
end;

procedure TfmMain.TimerScrollTimer(Sender: TObject);
begin
  FTimerScrollCall := True;
  with FrameItemCopy.PanelMenu do
    AnchorTop := AnchorTop + FTimerScrollStep;
end;

procedure TfmMain.LabelCopyrightClick(Sender: TObject);
begin
  ShellExecute(0, 'Open', PChar(LabelCopyright.Hint), nil, nil, SW_SHOWNORMAL);
end;

procedure TfmMain.LabelCopyrightMouseEnter(Sender: TObject);
begin
  LabelCopyright.Font.Color := clHotLight;
end;

procedure TfmMain.LabelCopyrightMouseLeave(Sender: TObject);
begin
  LabelCopyright.Font.Color := clHighlight;
end;

// Align controls (SitePanelMain, PanelMenu and Split) after resize form

procedure TfmMain.AlignPanels(PanelMenuNewWidth: Integer);
const
  cSitePanelMainMinWidth = 250;
var
  Wc, Hc: Integer;
  L, T, W, H: Integer;
begin
  if PanelMenuNewWidth < 0 then
    PanelMenuNewWidth := 1;
  Wc := ClientWidth;
  Hc := ClientHeight;
  // SitePanelMain
  L := 0;
  T := 0;
  H := Hc;
  W := Wc - PanelMenuNewWidth - Split.Width;
  if W < cSitePanelMainMinWidth then
    W := cSitePanelMainMinWidth;
  if W > Wc - Split.Width - 1 then
    W := Wc - Split.Width - 1;
  SitePanelMain.SetBounds(L, T, W, H);
  // Split
  L := L + W;
  T := 0;
  H := Hc;
  W := Split.Width;
  Split.SetBounds(L, T, W, H);
  // PanelMenu
  L := L + W;
  T := 0;
  H := Hc;
  W := Wc - L;
  PanelMenu.SetBounds(L, T, W, H);
end;

// WinProgress & SubWin

procedure TfmMain.WinProgress(AOnStart: TOnStart; AOnExec: TOnExec; AOnStop: TOnStop);
begin
  if not fmWinProgress.Showing then
    fmWinProgress.Starting(AOnStart, AOnExec, AOnStop);
end;

procedure TfmMain.SubWinShowed(Sender: TObject);
begin
  SitePanelMain.Enabled := False;
  PanelMenu.Enabled := False;
  Split.Enabled := False;
end;

procedure TfmMain.SubWinClosed(Sender: TObject);
begin
  SitePanelMain.Enabled := True;
  PanelMenu.Enabled := True;
  Split.Enabled := True;
end;

procedure TfmMain.SubWinClose;
begin
  fmWinProgress.Stopping;
end;

function TfmMain.SubWinActive: Boolean;
begin
  Result := fmWinProgress.Showing;
end;

function TfmMain.SubWinInterface: ISubWin;
begin
  Result.Progress := WinProgress;
end;

// Fit

procedure TfmMain.LoadFit(const AFileName: string);
begin
  SubWinClose;
  if Assigned(FFit) then
  begin
    FFit.Free;
    FFit := nil;
  end;
  FFit := TFitsFileBitmap.CreateJoin(AFileName, cFileRead);
  frHeader.SetFit(FFit);
  frData.SetFit(FFit);
  frImage.SetFit(FFit);
end;

procedure TfmMain.DropFit;
begin
  SubWinClose;
  if Assigned(FFit) then
  begin
    FFit.Free;
    FFit := nil;
  end;
end;

procedure TfmMain.ShowFit;
begin
  case FrameItemIndex of
    1: BtnHeader.Click;
    2: BtnData.Click;
    3: BtnImage.Click;
  end;
end;

// FrameItem

function TfmMain.FrameItemCopy: TfrBase;
var
  Btn: TSpeedButton;
begin
  if BtnHeader.Down then
    Btn := BtnHeader
  else if BtnData.Down then
    Btn := BtnData
  else {if BtnImage.Down then}
    Btn := BtnImage;
  Result := TfrBase(Btn.Tag);
end;

function TfmMain.FrameItemIndex: Integer;
begin
  if BtnHeader.Down then
    Result := 1
  else if BtnData.Down then
    Result := 2
  else {if BtnImage.Down then}
    Result := 3;
end;

// Profile

procedure TfmMain.ReadProfile;
begin
  Profile.Enter;
  try
    LabelCopyright.Caption := Format(LabelCopyright.Caption, [Profile.VersionNum]);
    case Profile.ReadInteger(cSection, 'FrameItemIndex', 1) of
      1: BtnHeader.Down := True;
      2: BtnData.Down := True;
      3: BtnImage.Down := True;
    end;
    PanelMenu.Width := Profile.ReadInteger(cSection, 'PanelMenu.Width', PanelMenu.Width);
    frHeader.ReadProfile;
    frData.ReadProfile;
    frImage.ReadProfile;
  finally
    Profile.Leave;
  end;
end;

procedure TfmMain.WriteProfile;
begin
  Profile.Enter;
  try
    Profile.WriteInteger(cSection, 'FrameItemIndex', FrameItemIndex);
    Profile.WriteInteger(cSection, 'PanelMenu.Width', PanelMenu.Width);
    frHeader.WriteProfile;
    frData.WriteProfile;
    frImage.WriteProfile;
  finally
    Profile.Leave;
  end;
end;

{$IFDEF PRAPP}

procedure TfmMain.Loaded;
begin
  inherited;
  WindowState := wsMaximized; // for test
end;

{$ENDIF}

{$IFDEF PRWLX}

class function TfmMain.PluginShow(ListerWin: HWND; FileToLoad: string): HWND;
var
  fmMain: TfmMain;
begin
  fmMain := nil;
  try
    fmMain := TfmMain.CreateParented(ListerWin);
    fmMain.LoadFit(FileToLoad);
    fmMain.Show;
    SetWindowLongPtr(fmMain.Handle, GWL_USERDATA, NativeInt(fmMain));
    // set focus to our window
    if not fmMain.FQuickView then
    begin
      PostMessage(fmMain.Handle, WM_SETFOCUS, 0, 0);
      fmMain.SetFocus;
    end;
    Result := fmMain.Handle;
  except
    if Assigned(fmMain) then
      fmMain.Free;
    Result := 0;
  end;
end;

class function TfmMain.PluginShowNext(PluginWin: HWND; FileToLoad: string): Integer;
var
  fmMain: TfmMain;
begin
  fmMain := TfmMain(GetWindowLongPtr(PluginWin, GWL_USERDATA));
  try
    fmMain.LoadFit(FileToLoad);
    fmMain.ShowFit;
    Result := 0;
  except
    Result := 1;
  end;
end;

class function TfmMain.PluginHide(PluginWin: HWND): HWND;
var
  fmMain: TfmMain;
begin
  Result := 0;
  fmMain := TfmMain(GetWindowLongPtr(PluginWin, GWL_USERDATA));
  try
    fmMain.Free;
  except
  end;
end;

procedure TfmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := (WS_CHILD or WS_MAXIMIZE) and not WS_CAPTION and not WS_BORDER;
  Params.WindowClass.cbWndExtra := SizeOf(NativeInt); // ~4/8 bytes for form
end;

constructor TfmMain.CreateParented(AParentWindow: HWND);
begin
  inherited CreateParented(AParentWindow);
  FParentWin := AParentWindow;
  FQuickView := Winapi.Windows.GetParent(FParentWin) <> 0;
end;

{$ENDIF}

end.
