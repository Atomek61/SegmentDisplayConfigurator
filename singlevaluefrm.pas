unit SingleValueFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LclType, FileUtil, Forms, Controls, StdCtrls;

type

  { TSingleValueFrame }

  TSingleValueFrame = class(TFrame)
    ButtonUp: TButton;
    ButtonDown: TButton;
    ButtonDefault: TButton;
    EditValue: TEdit;
    Label2: TLabel;
    procedure ButtonDefaultClick(Sender: TObject);
    procedure ButtonDownClick(Sender: TObject);
    procedure ButtonUpClick(Sender: TObject);
    procedure EditValueKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FValue :single;
    FDelta :single;
    FDefault :single;
    FFormat :string;
    FOnChanged :TNotifyEvent;
    procedure SetValue(AValue: single);
  public
    constructor Create(AOwner :TComponent); override;
    procedure Setup(const AValue, ADelta, ADefault :single; OnChanged :TNotifyEvent);
    property Value :single read FValue write SetValue;
    property Format :string read FFormat write FFormat;
  end;

implementation

uses
  Math;

{$R *.lfm}

{ TSingleValueFrame }

constructor TSingleValueFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFormat := '%.4f';
end;

procedure TSingleValueFrame.SetValue(AValue: single);
var
  i :integer;
begin
  if FValue=AValue then Exit;
  FValue := AValue;
  if FValue<0 then
    FValue := 0;
  EditValue.Text := SysUtils.Format(FFormat, [FValue]);
  if Assigned(FOnChanged) then
    FOnChanged(self);
end;

procedure TSingleValueFrame.ButtonUpClick(Sender: TObject);
begin
  Value := Value + FDelta;
end;

procedure TSingleValueFrame.EditValueKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then begin
    Key := 0;
    Value := StrToFloat(EditValue.Text);
  end;
end;

procedure TSingleValueFrame.ButtonDownClick(Sender: TObject);
begin
  Value := Value - FDelta;
end;

procedure TSingleValueFrame.ButtonDefaultClick(Sender: TObject);
begin
  Value := FDefault;
end;

procedure TSingleValueFrame.Setup(const AValue, ADelta, ADefault :single; OnChanged :TNotifyEvent);
begin
  FValue := -1e6;
  Value := AValue;
  FDelta := ADelta;
  FDefault := ADefault;
  FOnChanged := OnChanged;
end;

end.

