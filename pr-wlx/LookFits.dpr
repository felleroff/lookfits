library LookFits;

uses
  System.AnsiStrings,
  System.SysUtils,
  Winapi.Windows,
  Winapi.Messages,
  Vcl.Forms,
  uProfile,
  ufmMain;

const
  cDetectStringCmd = 'EXT="FITS" | EXT="FIT" | EXT="FTS" | EXT="FIS"';
  cDetectStringExt = '.FITS.FIT.FTS.FIS';

procedure ListGetDetectString(DetectString: PAnsiChar; MaxLen: Integer); stdcall;
begin
  System.AnsiStrings.StrLCopy(DetectString, PAnsiChar(cDetectStringCmd), MaxLen - 1);
end;

function FileExtIsFits(FileToLoad: PAnsiChar): Boolean;
var
  Ext: string;
begin
  Ext := ExtractFileExt(string(FileToLoad));
  Ext := UpperCase(Ext);
  Result := (Pos(Ext, cDetectStringExt) > 0);
end;

function ListLoad(ListerWin: HWND; FileToLoad: PAnsiChar; ShowFlags: Integer): HWND; stdcall;
begin
  if FileExtIsFits(FileToLoad) then
    Result := TfmMain.PluginShow(ListerWin, string(FileToLoad))
  else
    Result := 0;
end;

function ListLoadNext(ListerWin, PluginWin: HWND; FileToLoad: PAnsiChar; ShowFlags: Integer): Integer; stdcall;
begin
  if FileExtIsFits(FileToLoad) then
    Result := TfmMain.PluginShowNext(PluginWin, string(FileToLoad))
  else
    Result := 0;
end;

procedure ListCloseWindow(PluginWin: HWND); stdcall;
begin
  TfmMain.PluginHide(PluginWin);
end;

{ Exprot }

exports
 ListGetDetectString,
 ListLoad,
 ListLoadNext,
 ListCloseWindow;

{$R *.res}

var
  WndMain: HWND = 0;
  ClassWndMain: TWndClassEx;

function WndMainWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  case Msg of
    {WM_SHOWWINDOW,} WM_WINDOWPOSCHANGED, WM_WINDOWPOSCHANGING:
       ShowWindow(hWnd, SW_HIDE);
  end;
  Result := DefWindowProc(hWnd, Msg, wParam, lParam);
end;

procedure CreateWndMain;
begin
  // init class of WndMain
  ClassWndMain.cbSize        := SizeOf(ClassWndMain);
  ClassWndMain.style         := 0;
  ClassWndMain.lpfnWndProc   := @WndMainWindowProc;
  ClassWndMain.cbClsExtra    := 0;
  ClassWndMain.cbWndExtra    := 0;
  ClassWndMain.hInstance     := HInstance;
  ClassWndMain.hIcon         := 0;
  ClassWndMain.hCursor       := 0;
  ClassWndMain.hbrBackground := COLOR_BTNFACE;
  ClassWndMain.lpszMenuName  := nil;
  ClassWndMain.lpszClassName := 'LookFits.ClassWndMain';
  // register class of WndMain
  RegisterClassEx(ClassWndMain);
  // create WndMain
  WndMain := CreateWindowEx(
    0,
    ClassWndMain.lpszClassName, nil,
    WS_POPUP,
    0, 0, 0, 0,
    0, 0,
    HInstance,
    nil);
end;

procedure Init;
begin
  if WndMain = 0 then
  begin
    CreateWndMain;
    Application.Initialize;
    Application.Handle := WndMain;
  end;
end;

procedure Done;
begin
  if WndMain <> 0 then
  begin
    DestroyWindow(WndMain);
    WndMain := 0;
    Application.Handle := 0;
  end;
end;

procedure DLLEntryPoint(Reason: Integer);
begin
  case Reason of
    DLL_PROCESS_ATTACH:
      Init;
    DLL_THREAD_ATTACH:
      ;
    DLL_THREAD_DETACH:
      ;
    DLL_PROCESS_DETACH:
      Done;
  end;
end;

begin
  DLLProc := @DLLEntryPoint;
  DLLEntryPoint(DLL_PROCESS_ATTACH);
end.
