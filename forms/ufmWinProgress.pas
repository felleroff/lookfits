{ **************************************************** }
{  LookFits - Lister plugin (WLX) for view FITS files  }
{                                                      }
{               Aux Form of ProgressBar                }
{            in modal mode for the instance            }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit ufmWinProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types,
  System.Classes, System.Math, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type

  { TProgressBar }

  TProgressBar = class(Vcl.ComCtrls.TProgressBar)
  private
    FLegend: TLabel;
    function GetLegend: string;
    procedure SetLegend(const Value: string);
  protected
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    property Legend: string read GetLegend write SetLegend;
  end;


  TProgressState = (psStart, psExec, psStop, psClose, psCancel, psExcept);

  TProgressParams = record
    Text1: string;  // Label1.Caption
    Text2: string;  // Label2.Caption
    Value: Integer; // ProgressBar1.Progress
    Legend: string; // ProgressBar1.Legend
  end;

  TOnStart = procedure (var AState: TProgressState; var AParams: TProgressParams) of object;
  TOnExec = procedure (var AState: TProgressState; var AParams: TProgressParams) of object;
  TOnStop = procedure (const AState: TProgressState; var AParams: TProgressParams) of object;

  { TfmWinProgress }

  TfmWinProgress = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ProgressBar1: TProgressBar;
    SpeedButton1: TSpeedButton;
    Timer1: TTimer;
    procedure FormAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Label1DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FOnShowed: TNotifyEvent;
    FOnClosed: TNotifyEvent;
  private
    FState: TProgressState;
    function GetParams: TProgressParams;
    procedure SetParams(AParams: TProgressParams);
  private
    FOnStart: TOnStart;
    FOnExec: TOnExec;
    FOnStop: TOnStop;
    procedure DoStart;
    procedure DoExec;
    procedure DoStop;
  private
    FPoint: TPoint;
    FMoved: Boolean;
    FSized: Boolean;
  public
    constructor Create(AOwner: TComponent; AOnShowed, AOnClosed: TNotifyEvent); reintroduce;
    procedure Starting(AOnStart: TOnStart; AOnExec: TOnExec; AOnStop: TOnStop);
    procedure Stopping;
  end;

implementation

{$R *.dfm}

const
  BrdSized = 10;
  BrdColor = clActiveBorder;

{ TProgressBar }

constructor TProgressBar.Create(AOwner: TComponent);
begin
  inherited;
  FLegend := TLabel.Create(Self);
  FLegend.ManualDock(Self);
  FLegend.Align := alClient;
  FLegend.Alignment := taCenter;
  FLegend.Layout := tlCenter;
end;

function TProgressBar.GetLegend: string;
begin
  Result := FLegend.Caption;
end;

procedure TProgressBar.Loaded;
begin
  inherited;
  FLegend.OnMouseDown := OnMouseDown;
  FLegend.OnMouseMove := OnMouseMove;
  FLegend.OnMouseUp := OnMouseUp;
end;

procedure TProgressBar.SetLegend(const Value: string);
begin
  FLegend.Caption := Value;
end;

{ TfmWinProgress }

function TfmWinProgress.GetParams: TProgressParams;
begin
  Result.Text1 := Label1.Caption;
  Result.Text2 := Label2.Caption;
  Result.Value := ProgressBar1.Position;
  Result.Legend := ProgressBar1.Legend;
end;

procedure TfmWinProgress.SetParams(AParams: TProgressParams);
const
  clCancel = $006030B0;
  clExcept = $000133D6;
  clStop   = clGreen;
begin
  Label1.Caption := AParams.Text1;
  if FState = psStop then
    AParams.Value := 100;
  ProgressBar1.Position := AParams.Value;
  ProgressBar1.Legend := AParams.Legend;
  case FState of
    psCancel: Label2.Font.Color := clCancel;
    psExcept: Label2.Font.Color := clExcept;
    psStop  : Label2.Font.Color := clStop;
    else
              Label2.Font.Color := clDefault;
  end;
  Label2.Caption := AParams.Text2;
  if FState = psExec then
    SpeedButton1.Caption := 'Cancel'
  else
    SpeedButton1.Caption := 'Ok';
  ClientHeight := Max(ClientHeight, SpeedButton1.BoundsRect.Bottom + 8);
end;

procedure TfmWinProgress.DoStart;
var
  Params: TProgressParams;
begin
  if not Assigned(FOnStart) then
    Exit;
  Params := GetParams;
  try
    FOnStart(FState, Params);
  except
    on E: Exception do
    begin
      FState := psExcept;
      Params.Text2 := E.ClassName + '! ' + E.Message;
    end;
  end;
  SetParams(Params);
end;

procedure TfmWinProgress.DoExec;
var
  Params: TProgressParams;
begin
  if not Assigned(FOnExec) then
    Exit;
  Params := GetParams;
  try
    FOnExec(FState, Params);
  except
    on E: Exception do
    begin
      FState := psExcept;
      Params.Text2 := E.ClassName + '! ' + E.Message;
    end;
  end;
  SetParams(Params);
end;

procedure TfmWinProgress.DoStop;
var
  Params: TProgressParams;
begin
  if not Assigned(FOnStop) then
    Exit;
  Params := GetParams;
  case FState of
    psStop  : Params.Text2 := 'Procedure successfully completed';
    psCancel: Params.Text2 := 'Procedure is canceled by user!';
  end;
  try
    FOnStop(FState, Params);
  except
    on E: Exception do
    begin
      FState := psExcept;
      Params.Text2 := E.ClassName + '. ' + E.Message;
    end;
  end;
  SetParams(Params);
end;

constructor TfmWinProgress.Create(AOwner: TComponent; AOnShowed, AOnClosed: TNotifyEvent);
begin
  inherited Create(AOwner);
  FOnShowed := AOnShowed;
  FOnClosed := AOnClosed;
  FState := psStart;
  FPoint := Point(0, 0);
  FMoved := False;
  FSized := False;
end;

procedure TfmWinProgress.Starting(AOnStart: TOnStart; AOnExec: TOnExec; AOnStop: TOnStop);
begin
  // preventing re-launch
  if Showing then
    Exit;
  // set frame-callback
  FOnStart := AOnStart;
  FOnExec := AOnExec;
  FOnStop := AOnStop;
  // init components
  Label1.Caption := '';
  Label2.Caption := '';
  ProgressBar1.Position := 0;
  ProgressBar1.Legend := '';
  // run
  FState := psStart;
  DoStart;
  if FState = psStart then
  begin
    FState := psExec;
    Timer1.Enabled := True;
  end
  else
  begin
    DoStop;
  end;
  Show;
end;

procedure TfmWinProgress.Stopping;
begin
  // preventing re-launch
  if not Showing then
    Exit;
  Timer1.Enabled := False;
  FState := psClose;
  DoStop;
  Hide;
end;

procedure TfmWinProgress.FormAlignPosition(Sender: TWinControl; Control: TControl; var NewLeft, NewTop, NewWidth, NewHeight: Integer; var AlignRect: TRect; AlignInfo: TAlignInfo);
begin
  if Control = SpeedButton1 then
  begin
    NewTop  := Label2.Top + Label2.Height + 6;
    NewLeft := (AlignRect.Width - NewWidth) div 2;
  end;
end;

procedure TfmWinProgress.FormResize(Sender: TObject);
begin
  Invalidate;
end;

procedure TfmWinProgress.FormShow(Sender: TObject);
var
  L, T, W, H, Wmax, Hmax: Integer;
begin
  ProgressBar1.Height := Max(ProgressBar1.Height, SpeedButton1.Height);
  Wmax := Parent.ClientWidth;
  Hmax := Parent.ClientHeight;
  W := Min(Label1.Width, Wmax - 16);
  H := SpeedButton1.BoundsRect.Bottom + 8;
  L := Max(8, (Wmax - W) div 2);
  T := Max(8, (Hmax - H) div 2);
  SetBounds(L, T, W, H);
  if Assigned(FOnShowed) then
    FOnShowed(Sender);
end;

procedure TfmWinProgress.FormHide(Sender: TObject);
begin
  if Assigned(FOnClosed) then
    FOnClosed(Sender);
end;

procedure TfmWinProgress.FormPaint(Sender: TObject);
begin
  with Canvas do
  begin
    Brush.Style := bsClear;
    Pen.Width := 2;
    Pen.Color := BrdColor;
    RoundRect(ClientRect, 4, 4);
    Brush.Style := bsSolid;
    Brush.Color := BrdColor;
    Polygon([
      Point(ClientWidth - BrdSized, ClientHeight),
      Point(ClientWidth, ClientHeight - BrdSized),
      Point(ClientWidth, ClientHeight)
      ]);
  end;
end;

procedure TfmWinProgress.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (Shift = [ssLeft]) then
  begin
    if Sender = Self then
    begin
      if (X >= ClientWidth - BrdSized) and
         (Y >= ClientHeight - BrdSized) then
         FSized := True
      else
         FMoved := True;
    end
    else
    begin
      FMoved := True;
    end;
    FPoint := Point(X, Y);
  end;
end;

procedure TfmWinProgress.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
   if (X >= ClientWidth - BrdSized) and  (Y >= ClientHeight - BrdSized) then
    Cursor := crSizeNWSE
  else
    Cursor := crDefault;
  if FMoved then
  begin
    SetBounds(Left + X - FPoint.x, Top + Y - FPoint.y, Width, Height);
  end;
  if FSized then
  begin
    SetBounds(Left, Top, Width + X - FPoint.x, Height + Y - FPoint.y);
    FPoint := Point(X, Y);
  end;
end;

procedure TfmWinProgress.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FMoved := False;
  FSized := False;
end;

procedure TfmWinProgress.Label1DblClick(Sender: TObject);
begin
  SetBounds(8, 8, Width, Height);
end;

procedure TfmWinProgress.Timer1Timer(Sender: TObject);
begin
  if FState = psExec then
  begin
    DoExec;
  end
  else
  begin
    Timer1.Enabled := False;
    DoStop;
  end;
end;

procedure TfmWinProgress.SpeedButton1Click(Sender: TObject);
begin
  if FState = psExec then
    FState := psCancel
  else
    Hide;
end;

end.
