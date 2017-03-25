{ **************************************************** }
{  LookFits - Lister plugin (WLX) for view FITS files  }
{                                                      }
{             Profile - configuration file             }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit uProfile;

interface

uses
  System.Classes, System.SysUtils, System.IOUtils, System.IniFiles,
  System.SyncObjs, Winapi.Windows, Lofi.ExtCtrls;

type

  { TProfile }

  TProfile = class(TMemIniFile)
  public
    constructor Create; reintroduce;
    procedure Enter;
    procedure Leave;
    function ReadHeightState(const Section, Ident: string; Default: THeightState): THeightState;
    procedure WriteHeightState(const Section, Ident: string; Value: THeightState);
    function ReadInteger(const Section, Ident: string; AMin, AMax: Longint; Default: Longint): Longint; reintroduce; overload;
    function ReadFloat(const Section, Ident: string; AMin, AMax: Double; Default: Double): Double; reintroduce; overload;
  private
    function GetVersionNum: string;
  public
    property VersionNum: string read GetVersionNum;
  end;

var
  Profile: TProfile = nil;

implementation

var
  CritSec: TCriticalSection = nil;

{ TProfile }

constructor TProfile.Create;
var
  Dir, Name: string;
begin
  Dir := TPath.GetHomePath;
  Dir := IncludeTrailingPathDelimiter(Dir);
  Dir := Dir + 'LookFits' + TPath.DirectorySeparatorChar;
  if not TDirectory.Exists(Dir) then
    TDirectory.CreateDirectory(Dir);
  Name := Dir + 'LookFits';
  {$IFDEF WIN32}
  Name := Name + '32';
  {$ENDIF}
  {$IFDEF WIN64}
  Name := Name + '64';
  {$ENDIF}
  Name := Name + '.ini';
  inherited Create(Name);
  AutoSave := True;
end;

procedure TProfile.Enter;
begin
  CritSec.Enter;
end;

procedure TProfile.Leave;
begin
  CritSec.Leave;
end;

function TProfile.ReadHeightState(const Section, Ident: string; Default: THeightState): THeightState;
var
  X, Xmin, Xmax, Xdef: Integer;
begin
  Xmin := Integer(Low(THeightState));
  Xmax := Integer(High(THeightState));
  Xdef := Integer(Default);
  X := ReadInteger(Section, Ident, Xdef);
  if (X < Xmin) or (X > Xmax) then
    X := Xdef;
  Result := THeightState(X);
end;

procedure TProfile.WriteHeightState(const Section, Ident: string; Value: THeightState);
begin
  WriteInteger(Section, Ident, Integer(Value));
end;

function TProfile.ReadInteger(const Section, Ident: string; AMin, AMax: Longint; Default: Longint): Longint;
begin
  Result := ReadInteger(Section, Ident, Default);
  if Result < AMin then
    Result := AMin
  else if Result > AMax then
    Result := AMax;
end;

function TProfile.ReadFloat(const Section, Ident: string; AMin, AMax: Double; Default: Double): Double;
begin
  Result := ReadFloat(Section, Ident, Default);
  if Result < AMin then
    Result := AMin
  else if Result > AMax then
    Result := AMax;
end;

function TProfile.GetVersionNum: string;
// http://stackoverflow.com/questions/1717844/how-to-determine-delphi-application-version
var
  Res:TResourceStream;
  Mem: TMemoryStream;
  VerBlock: PVSFIXEDFILEINFO;
  VerLen: Cardinal;
  Num: array [0 .. 3] of WORD; // [Major, Minor, Release, Build]
begin
  Result := '';
  try
    Mem := TMemoryStream.Create;
    try
      Res := TResourceStream.CreateFromID(HInstance, 1, RT_VERSION);
      try
        Mem.CopyFrom(Res, Res.Size);
      finally
        Res.Free;
      end;
      Mem.Position:=0;
      if VerQueryValue(Mem.Memory, '\', Pointer(VerBlock), VerLen) then
      begin
        Num[0] := VerBlock^.dwFileVersionMS shr 16;
        Num[1] := VerBlock^.dwFileVersionMS and $FFFF;
        Num[2] := VerBlock^.dwFileVersionLS shr 16;
        Num[3] := VerBlock^.dwFileVersionLS and $FFFF;
        Result := Format('%d.%d.%d', [Num[0], Num[1], Num[2]]);
      end;
    finally
      Mem.Free;
    end;
  except
  end;
end;

initialization
begin
  CritSec := TCriticalSection.Create;
  CritSec.Enter;
  try
    Profile := TProfile.Create;
  finally
    CritSec.Leave;
  end;
end;

finalization
begin
  CritSec.Enter;
  try
    Profile.Free;
  finally
    CritSec.Leave;
    CritSec.Free;
  end;
end;

end.
