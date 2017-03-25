unit ufmDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Lofi.ExtCtrls,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs,
  VCLTee.Chart;

type

  TDrawGrid = class(Vcl.Grids.TDrawGrid)
  private const
    WM_COLSIZECHANGED = WM_USER + 100;
  private
    FCol: Integer;
  protected
    procedure WmColSizeChanged(var Message: TMessage); message WM_COLSIZECHANGED;
    procedure ColWidthsChanged; override;
    procedure CalcSizingState(X, Y: Integer; var State: TGridState; var Index: Longint; var SizingPos, SizingOfs: Integer; var FixedInfo: TGridDrawInfo); override;
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TfmDemo = class(TForm)
    DrawGrid1: TDrawGrid;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    Button1: TButton;
    LofiScrollBar1: TLofiScrollBar;
    Label1: TLabel;
    ComboBox1: TComboBox;
    Chart1: TChart;
    Series1: TBarSeries;
    LofiTrackBar1: TLofiTrackBar;
    procedure LofiTrackBar1ChangeDone(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDemo: TfmDemo;

implementation

{$R *.dfm}

{ TDrawGrid }

procedure TDrawGrid.WmColSizeChanged(var Message: TMessage);
const
  Wmin = 20;
begin
  if FCol > 0 then
    if ColWidths[FCol] < Wmin then
      ColWidths[FCol] := Wmin;
  FCol := -1;
end;

procedure TDrawGrid.ColWidthsChanged;
const
  Wmin = 20;
begin
  inherited;
  if FCol > 0 then
    if ColWidths[FCol] < Wmin then
      ColWidths[FCol] := Wmin;
  FCol := -1;
  //PostMessage(Handle, WM_COLSIZECHANGED, 0, 0);
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
end;

{ TfmDemo }

Function ButtonIsDown(Button:TMousebutton):Boolean;
var Swap :Boolean;
    State:short;
begin
State:=0;
Swap:= GetSystemMetrics(SM_SWAPBUTTON)<>0;
if Swap then
   case button of
   mbLeft :State:=getAsyncKeystate(VK_RBUTTON);
   mbRight:State:=getAsyncKeystate(VK_LBUTTON);
   end
else
   case button of
   mbLeft :State:=getAsyncKeystate(VK_LBUTTON);
   mbRight:State:=getAsyncKeystate(VK_RBUTTON);
   end;
Result:= (State < 0);
end;


procedure TfmDemo.Button1Click(Sender: TObject);
begin
  LofiTrackBar1.Position := 15;
end;

procedure TfmDemo.LofiTrackBar1ChangeDone(Sender: TObject);
var
  X: Integer;
begin
  X := LofiTrackBar1.Position;
  Caption := IntToStr(X);
end;

end.
