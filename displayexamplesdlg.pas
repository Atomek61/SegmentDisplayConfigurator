unit DisplayExamplesDlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, Buttons, ActnList,
  Controls.SegmentDisplay, fgl;

type

  { TDisplayExamplesDialog }

  TSegmentDisplays = specialize TFPGObjectList<TSegmentDisplay>;

  TDisplayExamplesDialog = class(TForm)
    ActionStartStop: TAction;
    ActionListDisplay5: TActionList;
    GroupBoxDisplay7: TGroupBox;
    GroupBoxExample6: TGroupBox;
    GroupBoxExample1: TGroupBox;
    GroupBoxExample2: TGroupBox;
    GroupBoxExample3: TGroupBox;
    GroupBoxExample4: TGroupBox;
    GroupBoxExample5: TGroupBox;
    ImageListDisplay5: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    PanelDisplay71: TPanel;
    PanelDisplay4: TPanel;
    PanelDisplay3: TPanel;
    PanelDisplay5: TPanel;
    PanelDisplay6: TPanel;
    PanelSOG: TPanel;
    PanelDisplay2: TPanel;
    PanelMouse: TPanel;
    PanelDisplay1: TPanel;
    TimerDisplay7: TTimer;
    TimerDisplay5: TTimer;
    TimerDisplay3: TTimer;
    TimerDisplay4: TTimer;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    TrackBarSOG: TTrackBar;
    procedure ActionStartStopExecute(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PanelMouseMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure TimerDisplay3Timer(Sender: TObject);
    procedure TimerDisplay4Timer(Sender: TObject);
    procedure TimerDisplay5Timer(Sender: TObject);
    procedure TimerDisplay7Timer(Sender: TObject);
    procedure TrackBarSOGChange(Sender: TObject);
  private
    FDisplays :TSegmentDisplays;
    FDisplay11 :TSegmentDisplay;
    FDisplay12 :TSegmentDisplay;
    FDisplay2 :TSegmentDisplay;
    FDisplay3 :TSegmentDisplay;
    FDisplay4 :TSegmentDisplay;
    FDisplay4Counter :integer;
    FDisplay5 :TSegmentDisplay;
    FDisplay5T0 :TDateTime;
    FDisplay6 :TSegmentDisplay;
    FDisplay6Counter :integer;
    FDisplay7 :TSegmentDisplay;
    function AddDisplay(AParent :TWinControl) :TSegmentDisplay;
    procedure StackOrder(AParent :TWinControl; const AControls :array of TControl);
    procedure OnDrawDisplay5Segments(Sender :TSegmentDisplay; ASymbolIndex :integer; var Segments :TSegments);
  public

  end;

var
  DisplayExamplesDialog: TDisplayExamplesDialog;

implementation

{$R *.lfm}

{ TDisplayExamplesDialog }

procedure TDisplayExamplesDialog.FormCreate(Sender: TObject);
begin
  FDisplays := TSegmentDisplays.Create;

  FDisplay11 := AddDisplay(PanelDisplay1);
  with FDisplay11 do begin
    Padding   := 4;
    GapRatio  := 0.0000;
    Alignment := taRightJustify;
    with Design do begin
      ModuleRatio      := 1.8000;
      SegmentRatio     := 0.1350;
      SlitRatio        := 0.0350;
      TiltRatio        := 0.1500;
      EdgeRatio        := 0.1250;
      DarkVisible      := true;
      BackgroundColor  := $000000;
      BrightColor      := $0000FF;
      DarkColor        := $00004A;
    end;
    Modules := '8.8.8.8.';
    Text := '123.4';
  end;
  FDisplay12 := AddDisplay(PanelDisplay1);
  FDisplay12.Design := FDisplay11.Design;
  StackOrder(PanelDisplay1, [FDisplay11, FDisplay12]);

  FDisplay2 := AddDisplay(PanelSOG);
  FDisplay2.Align := alClient;
  with FDisplay2 do begin
    Padding   := 0;
    GapRatio  := 0.0000;
    Alignment := taRightJustify;
    with Design do begin
      ModuleRatio      := 1.8000;
      SegmentRatio     := 0.1650;
      SlitRatio        := 0.0150;
      TiltRatio        := 0.1500;
      EdgeRatio        := 0.1250;
      DarkVisible      := true;
      BackgroundColor  := $B6CBC5;
      BrightColor      := $000000;
      DarkColor        := $ABBEB9;
    end;
    Modules := '888.8';
    Text := ' -.-';
  end;
  TrackBarSOGChange(nil);

  FDisplay3 := AddDisplay(PanelDisplay3);
  FDisplay3.Align := alClient;
  with FDisplay3 do begin
    Padding   := 10;
    GapRatio  := 0.0000;
    Alignment := taCenter;
    with Design do begin
      ModuleRatio      := 1.8000;
      SegmentRatio     := 0.1250;
      SlitRatio        := 0.0150;
      TiltRatio        := 0.1500;
      EdgeRatio        := 0.1250;
      DarkVisible      := true;
      InnerGlow        := true;
      BackgroundColor  := $000000;
      BrightColor      := $FFFFA4;
      DarkColor        := $303018;
    end;
    Modules := '88:88';
    Text := '12:34';
  end;

  FDisplay4 := AddDisplay(PanelDisplay4);
  FDisplay4.OnDrawSegments := @OnDrawDisplay5Segments;
  FDisplay4.Align := alClient;
  with FDisplay4 do begin
    Padding   := 10;
    GapRatio  := 0.1000;
    Alignment := taCenter;
    with Design do begin
      ModuleRatio      := 1.8000;
      SegmentRatio     := 0.1250;
      SlitRatio        := 0.0150;
      TiltRatio        := 0.0000;
      EdgeRatio        := 0.1250;
      DarkVisible      := true;
      InnerGlow        := false;
      Style            := ssClassic;
      BackgroundColor  := $000000;
      BrightColor      := $91FF96;
      DarkColor        := $1E3019;
    end;
    Modules := '888888';
    Text := '??????';
  end;

  FDisplay5 := AddDisplay(PanelDisplay5);
  FDisplay5.Align := alClient;
  with FDisplay5 do begin
    Padding   := 4;
    GapRatio  := 0.0000;
    Alignment := taRightJustify;
    with Design do begin
      ModuleRatio      := 1.400;
      SegmentRatio     := 0.150;
      SlitRatio        := 0.0400;
      TiltRatio        := 0.1100;
      EdgeRatio        := 0.2150;
      DarkVisible      := true;
      InnerGlow        := true;
      Style            := ss80th;
      BackgroundColor  := $000000;
      BrightColor      := $54BFFE;
      DarkColor        := $000810;
    end;
    Modules := '88:88:88.888';
    Text := '00:00:00.000';
  end;

  FDisplay6 := AddDisplay(PanelDisplay6);
  FDisplay6.Align := alClient;
  with FDisplay6 do begin
    Padding   := 4;
    GapRatio  := 0.0000;
    Alignment := taCenter;
    with Design do begin
      ModuleRatio      := 1.8000;
      SegmentRatio     := 0.1250;
      SlitRatio        := 0.0150;
      TiltRatio        := 0.1500;
      EdgeRatio        := 0.1250;
      DarkVisible      := false;
      InnerGlow        := false;
      Style            := ssClassic;
      BackgroundColor  := $000000;
      BrightColor      := $FEFEFE;
      DarkColor        := $181818;
    end;
    Modules := '888888888888888888888';
    Text    := '    -0123456789ABCDEF';
  end;

  FDisplay7 := AddDisplay(PanelDisplay71);
  FDisplay7.Align := alClient;
  with FDisplay7 do begin
    Padding   := 4;
    GapRatio  := 0.1000;
    Alignment := taRightJustify;
    with Design do begin
      ModuleRatio      := 1.8000;
      SegmentRatio     := 0.1250;
      SlitRatio        := 0.0400;
      TiltRatio        := 0.0300;
      EdgeRatio        := 0.0550;
      DarkVisible      := true;
      InnerGlow        := false;
      Style            := ssBlock;
      BackgroundColor  := $FF0000;
      BrightColor      := $FFF2DD;
      DarkColor        := $FF2D2D;
    end;
    Modules := '888.888.888.888';
    Text := '192.168. 67.  1';
  end;

end;

procedure TDisplayExamplesDialog.ActionStartStopExecute(Sender: TObject);
begin
  if TimerDisplay5.Enabled then begin
    ActionStartStop.ImageIndex := 0;
  end else begin
    ActionStartStop.ImageIndex := 1;
    FDisplay5T0 := Now;
  end;
  TimerDisplay5.Enabled := not TimerDisplay5.Enabled;
end;

procedure TDisplayExamplesDialog.ButtonCloseClick(Sender: TObject);
begin
end;

procedure TDisplayExamplesDialog.TimerDisplay5Timer(Sender: TObject);
var
  h, m, s, z :word;
begin
  DecodeTime(Now-FDisplay5T0, h, m, s, z);
  FDisplay5.Text := Format('%2.2d:%2.2d:%2.2d.%3.3d', [h, m, s, z]);
end;

procedure TDisplayExamplesDialog.TimerDisplay7Timer(Sender: TObject);
const
  TXT :string  = '    -0123456789ABCDEF';
var
  i, n :integer;
begin
  n := Length(TXT);
  i := FDisplay6Counter mod n + 1;
  FDisplay6.Text := Copy(TXT, i, n-i+1) + Copy(TXT, 1, i-1);
  inc(FDisplay6Counter);
end;

procedure TDisplayExamplesDialog.FormHide(Sender: TObject);
begin
  TimerDisplay3.Enabled := false;
  TimerDisplay4.Enabled := false;
  TimerDisplay7.Enabled := false;
end;

procedure TDisplayExamplesDialog.FormShow(Sender: TObject);
begin
  TimerDisplay3.Enabled := true;
  TimerDisplay4.Enabled := true;
  TimerDisplay7.Enabled := true;
end;

procedure TDisplayExamplesDialog.PanelMouseMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  FDisplay11.Text := Format('%5.1f', [(X - PanelMouse.ClientWidth div 2)/3]);
  FDisplay12.Text := Format('%5.1f', [(PanelMouse.ClientHeight div 2 - Y)/3]);
end;

procedure TDisplayExamplesDialog.TimerDisplay3Timer(Sender: TObject);
var
  h, m, s, z :word;
begin
  DecodeTime(Now, h, m, s, z);
  if z<500 then
    FDisplay3.Text := Format('%2.2d:%2.2d', [h, m])
  else
    FDisplay3.Text := Format('%2.2d %2.2d', [h, m]);
end;

procedure TDisplayExamplesDialog.TimerDisplay4Timer(Sender: TObject);
begin
  inc(FDisplay4Counter);
  FDisplay4.Invalidate;
end;

procedure TDisplayExamplesDialog.TrackBarSOGChange(Sender: TObject);
begin
  FDisplay2.Text := Format('%4.1f', [TrackBarSOG.Position/10.0]);
//  FDisplay2.Text := Format('%4s', [Format('%.1f', [TrackBarSOG.Position/10.0])]);
end;

function TDisplayExamplesDialog.AddDisplay(AParent: TWinControl): TSegmentDisplay;
begin
  result := TSegmentDisplay.Create(self);
  FDisplays.Add(result);
  result.Parent := AParent;
//  result.Align := alClient;
  result.Visible := true;
end;

procedure TDisplayExamplesDialog.StackOrder(AParent :TWinControl; const AControls :array of TControl);
var
  w, h, i :integer;
begin
  w := AParent.ClientWidth;
  h := AParent.ClientHeight div Length(AControls);
  for i:=0 to high(AControls) do begin
    AControls[i].SetBounds(0, i*h, w, h);
  end;
end;

procedure TDisplayExamplesDialog.OnDrawDisplay5Segments(Sender: TSegmentDisplay; ASymbolIndex: integer; var Segments: TSegments);
const
  VSEGS :array[0..3] of TSegments = ([SegA], [SegG], [SegD], [SegG]);
begin
  Segments += VSEGS[(ASymbolIndex-1 + FDisplay4Counter) mod Length(VSEGS)];
end;

end.

