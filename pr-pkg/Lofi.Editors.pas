{ **************************************************** }
{           Components for project LookFits            }
{                                                      }
{                   ComponentEditors                   }
{                                                      }
{           Copyright(c) 2017, Evgeniy Dikov           }
{        https://github.com/felleroff/lookfits         }
{ **************************************************** }

unit Lofi.Editors;

interface

uses
  System.SysUtils, System.Types, System.Classes, Vcl.Controls, Vcl.ExtCtrls,
  DesignIntf, DesignEditors, Lofi.ExtCtrls;

type

  TLofiGroupEditor = class(TComponentEditor)
  private
    procedure AddItem;
    procedure AdjustItems;
  public
    procedure Edit; override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

  TLofiGroupItemEditor = class(TComponentEditor)
  private
    procedure Adjust;
    procedure Upward;
  public
    procedure Edit; override;
    function GetVerbCount: Integer; override;
    function GetVerb(Index: Integer): string; override;
    procedure ExecuteVerb(Index: Integer); override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponentEditor(TLofiGroup, TLofiGroupEditor);
  RegisterComponentEditor(TLofiGroupItem, TLofiGroupItemEditor);
end;

{ TLofiGroupEditor }

procedure TLofiGroupEditor.AddItem;
var
  I, T: Integer;
  Group: TLofiGroup;
  GroupItem: TLofiGroupItem;
begin
  Group := Component as TLofiGroup;
  T := 0;
  for I := 0 to Group.ControlCount - 1 do
    if Group.Controls[I] is TLofiGroupItem then
      T := T + Group.Controls[I].Height;
  T := T + 1;
  GroupItem := Designer.CreateComponent(TLofiGroupItem, Group, 0, T, 100, 50) as TLofiGroupItem;
  GroupItem.Align := alTop;
end;

procedure TLofiGroupEditor.AdjustItems;
var
  I: Integer;
  Group: TLofiGroup;
  GroupItem: TLofiGroupItem;
begin
  Group := Component as TLofiGroup;
  Group.AnchorTop := 0;
  for I := 0 to Group.ControlCount - 1 do
    if Group.Controls[I] is TLofiGroupItem then
    begin
      GroupItem := Group.Controls[I] as TLofiGroupItem;
      if GroupItem.HeightState <> hsMaxi then
        GroupItem.HeightState := hsMaxi
      else
        GroupItem.AdjustHeight;
    end;
end;

procedure TLofiGroupEditor.Edit;
begin
  AdjustItems;
end;

procedure TLofiGroupEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: AddItem;
    1: AdjustItems;
  end;
end;

function TLofiGroupEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Add item';
    1: Result := 'Adjust items'
    else
       Result := '';
  end;
end;

function TLofiGroupEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

{ TLofiGroupItemEditor }

procedure TLofiGroupItemEditor.Adjust;
var
  GroupItem: TLofiGroupItem;
begin
   GroupItem := Component as TLofiGroupItem;
   GroupItem.AdjustHeight;
end;

procedure TLofiGroupItemEditor.Upward;
var
  GroupItem: TLofiGroupItem;
begin
   GroupItem := Component as TLofiGroupItem;
   with GroupItem.Group do
     AnchorTop := AnchorTop - GroupItem.Top;
end;

procedure TLofiGroupItemEditor.Edit;
begin
  Adjust;
end;

procedure TLofiGroupItemEditor.ExecuteVerb(Index: Integer);
begin
  case Index of
    0: Adjust;
    1: Upward;
  end;
end;

function TLofiGroupItemEditor.GetVerb(Index: Integer): string;
begin
  case Index of
    0: Result := 'Adjust';
    1: Result := 'Upward'
    else
       Result := '';
  end;
end;

function TLofiGroupItemEditor.GetVerbCount: Integer;
begin
  Result := 2;
end;

end.
