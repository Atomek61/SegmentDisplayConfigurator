unit MainDlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynHighlighterPas, SynEdit, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, ColorBox, BGRABitmap, BGRABitmapTypes,
  BGRACanvas, BGRAPath, BGRASvg, BGRACanvas2D, BGRAUnits,
  Controls.SegmentDisplay, fgl, LCLType, StrUtils, Clipbrd,
  BGRAGradientScanner, BGRATransform, SingleValueFrm, Types.Led, PreviewDlg;

type

  { TMainDialog }

  TMainDialog = class(TForm)
    Button1: TButton;
    ButtonExamples: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ButtonCopy: TButton;
    CheckBoxDarkVisible: TCheckBox;
    CheckBoxInnerGlow: TCheckBox;
    ColorDialog: TColorDialog;
    ComboBoxText: TComboBox;
    ComboBoxModules: TComboBox;
    ComboBoxAlignment: TComboBox;
    ComboBoxColorSet: TComboBox;
    ComboBoxStyle: TComboBox;
    EditPadding: TEdit;
    GroupBoxModules: TGroupBox;
    GroupBoxSymbols: TGroupBox;
    GroupBoxDesign: TGroupBox;
    GroupBoxCode: TGroupBox;
    GroupBoxLayout: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
//    PanelControls: TPanel;
    PanelBackgroundColor: TPanel;
    PanelBrightColor: TPanel;
    PanelDarkColor: TPanel;
    EditCode: TSynEdit;
    PascalSyntax: TSynPasSyn;
    ModuleRatioFrame: TSingleValueFrame;
    GapRatioFrame: TSingleValueFrame;
    SegmentRatioFrame: TSingleValueFrame;
    EdgeRatioFrame: TSingleValueFrame;
    SlitRatioFrame: TSingleValueFrame;
    TiltRatioFrame: TSingleValueFrame;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ButtonCopyClick(Sender: TObject);
    procedure ButtonExamplesClick(Sender: TObject);
    procedure CheckBoxDarkVisibleChange(Sender: TObject);
    procedure CheckBoxInnerGlowChange(Sender: TObject);
    procedure ComboBoxAlignmentChange(Sender: TObject);
    procedure ComboBoxColorSetChange(Sender: TObject);
    procedure ComboBoxModulesChange(Sender: TObject);
    procedure ComboBoxStyleChange(Sender: TObject);
    procedure ComboBoxTextChange(Sender: TObject);
    procedure EditModulesKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditPaddingKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure EditTextKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormChangeBounds(Sender: TObject);
    procedure FormConstrainedResize(Sender: TObject; var MinWidth, MinHeight, MaxWidth, MaxHeight: TConstraintSize);
    procedure FormCreate(Sender: TObject);
    procedure MainDialogSizeConstraintsChange(Sender: TObject);
  private
    FCodeFormatSettings :TFormatSettings;
    procedure OnDisplayChanged(Sender :TObject);
    procedure OnGapRatioChanged(Sender :TObject);
    procedure OnModuleRatioChanged(Sender :TObject);
    procedure OnSegmentRatioChanged(Sender :TObject);
    procedure OnTiltRatioChanged(Sender :TObject);
    procedure OnEdgeRatioChanged(Sender :TObject);
    procedure OnSlitRatioChanged(Sender :TObject);
    procedure OnBlink(Sender :TObject);
  public
    Display :TSegmentDisplay;
  end;

var
  MainDialog: TMainDialog;

const
  MODULERATIOS :array[0..3] of single = (19/11, 2/1, 3/1, 2/3);
  ALIDX :array[TAlignment] of integer = (0, 2, 1);
  ALGINS :array[0..2] of TAlignment = (taLeftJustify, taCenter, taRightJustify);
//  STYLES :array[TSegmentStyle] of string= ('', '', '', '');

const
  CODETEMPLATE =
    'with SegmentDisplay do begin' + #13#10 +
    '  Padding   := %PADDING%;' + #13#10 +
    '  GapRatio  := %GAPRATIO%;' + #13#10 +
    '  Alignment := %ALIGNMENT%;' + #13#10 +
    '  with Design do begin' + #13#10 +
    '    ModuleRatio      := %MODULERATIO%;' + #13#10 +
    '    SegmentRatio     := %SEGMENTRATIO%;' + #13#10 +
    '    SlitRatio        := %SLITRATIO%;' + #13#10 +
    '    TiltRatio        := %TILTRATIO%;' + #13#10 +
    '    EdgeRatio        := %EDGERATIO%;' + #13#10 +
    '    DarkVisible      := %DARKVISIBLE%;' + #13#10 +
    '    InnerGlow        := %INNERGLOW%;' + #13#10 +
    '    Style            := %STYLE%;' + #13#10 +
    '    BackgroundColor  := %BACKGROUNDCOLOR%;' + #13#10 +
    '    BrightColor      := %BRIGHTCOLOR%;' + #13#10 +
    '    DarkColor        := %DARKCOLOR%;' + #13#10 +
    '  end;' + #13#10 +
    'end;' + #13#10;

implementation

uses
  Math, DisplayExamplesDlg;

{$R *.lfm}

function BuildCode(Control :TSegmentDisplay): string;
var
  Code :string;
  CodeFormatSettings :TFormatSettings;

  procedure ReplaceFloat(const Variable :string; Value :single);
  begin
    Code := StringReplace(Code, Variable, Format('%.4f', [Value], CodeFormatSettings), []);
  end;

  procedure ReplaceInteger(const Variable :string; Value :integer);
  begin
    Code := StringReplace(Code, Variable, Format('%d', [Value]), []);
  end;

  procedure ReplaceColor(const Variable :string; Value :TColor);
  begin
    Code := StringReplace(Code, Variable, Format('$%6.6x', [ColorToRGB(Value)]), []);
  end;

  procedure ReplaceBoolean(const Variable :string; Value :boolean);
  const
    FALSETRUE :array[boolean] of string = ('false', 'true');
  begin
    Code := StringReplace(Code, Variable, FALSETRUE[Value], []);
  end;

  procedure ReplaceStyle(const Variable :string; Value :TSegmentStyle);
  const
    STYLES :array[TSegmentStyle] of string = ('ssClassic', 'ssBlock', 'ss80th');
  begin
    Code := StringReplace(Code, Variable, STYLES[Value], []);
  end;

  procedure ReplaceAlignment(const Variable :string; Value :TAlignment);
  const
    ALIGNMENTS :array[TAlignment] of string = ('taLeftJustify', 'taRightJustify', 'taCenter');
  begin
    Code := StringReplace(Code, Variable, ALIGNMENTS[Value], []);
  end;

begin
  CodeFormatSettings := DefaultFormatSettings;
  CodeFormatSettings.DecimalSeparator := '.';

  Code := CODETEMPLATE;
  ReplaceAlignment('%ALIGNMENT%', Control.Alignment);
  ReplaceInteger('%PADDING%', Control.Padding);
  ReplaceFloat('%GAPRATIO%', Control.GapRatio);

  ReplaceFloat('%MODULERATIO%', Control.Design.ModuleRatio);
  ReplaceFloat('%SEGMENTRATIO%', Control.Design.SegmentRatio);
  ReplaceFloat('%SLITRATIO%', Control.Design.SlitRatio);
  ReplaceFloat('%TILTRATIO%', Control.Design.TiltRatio);
  ReplaceFloat('%EDGERATIO%', Control.Design.EdgeRatio);
  ReplaceBoolean('%INNERGLOW%', Control.Design.InnerGlow);
  ReplaceBoolean('%DARKVISIBLE%', Control.Design.DarkVisible);
  ReplaceColor('%BACKGROUNDCOLOR%', Control.Design.BackgroundColor);
  ReplaceColor('%BRIGHTCOLOR%', Control.Design.BrightColor);
  ReplaceColor('%DARKCOLOR%', Control.Design.DarkColor);
  ReplaceStyle('%STYLE%', Control.Design.Style);

  result := Code;
end;

{ TMainDialog }

procedure TMainDialog.FormCreate(Sender: TObject);
begin

  Display := TSegmentDisplay.Create(self);
  Display.Align := alClient;
  Display.Modules := '8.8.8.8.';
  Display.Text := ' 12.3';
  Display.OnChanged := @OnDisplayChanged;

  GapRatioFrame.Setup(Display.GapRatio, 0.1, DEFAULTGAPRATIO, @OnGapRatioChanged);

  ModuleRatioFrame.Setup(Display.Design.ModuleRatio, 0.1, DEFAULTMODULERATIO, @OnModuleRatioChanged);
  SegmentRatioFrame.Setup(Display.Design.SegmentRatio, 0.01, DEFAULTSEGMENTRATIO, @OnSegmentRatioChanged);
  TiltRatioFrame.Setup(Display.Design.TiltRatio, 0.02, DEFAULTTILTRATIO, @OnTiltRatioChanged);
  EdgeRatioFrame.Setup(Display.Design.EdgeRatio, 0.02, DEFAULTEDGERATIO, @OnEdgeRatioChanged);
  SlitRatioFrame.Setup(Display.Design.SlitRatio, 0.005, DEFAULTSLITRATIO, @OnSlitRatioChanged);

  OnDisplayChanged(nil);
end;

procedure TMainDialog.MainDialogSizeConstraintsChange(Sender: TObject);
begin

end;

procedure TMainDialog.OnDisplayChanged(Sender: TObject);
begin
  ComboBoxModules.Text := Display.Modules;
  ComboBoxText.Text := Display.Text;
  ModuleRatioFrame.Value := Display.Design.ModuleRatio;
  EditPadding.Text := IntToStr(Display.Padding);
  ComboBoxAlignment.ItemIndex := ALIDX[Display.Alignment];
  SegmentRatioFrame.Value := Display.Design.SegmentRatio;
  TiltRatioFrame.Value := Display.Design.TiltRatio;
  EdgeRatioFrame.Value := Display.Design.EdgeRatio;
  SlitRatioFrame.Value := Display.Design.SlitRatio;
  CheckBoxDarkVisible.Checked := Display.Design.DarkVisible;
  CheckBoxInnerGlow.Checked := Display.Design.InnerGlow;
  ComboBoxStyle.ItemIndex := integer(Display.Design.Style);
  PanelBackgroundColor.Color := Display.Design.BackgroundColor;
  PanelBrightColor.Color := Display.Design.BrightColor;
  PanelDarkColor.Color := Display.Design.DarkColor;
  EditCode.Lines.Text := BuildCode(Display);
end;

procedure TMainDialog.OnGapRatioChanged(Sender: TObject);
begin
  Display.GapRatio := TSingleValueFrame(Sender).Value;
end;

procedure TMainDialog.OnModuleRatioChanged(Sender: TObject);
begin
  Display.Design.ModuleRatio := TSingleValueFrame(Sender).Value;
end;

procedure TMainDialog.OnSegmentRatioChanged(Sender: TObject);
begin
  Display.Design.SegmentRatio := TSingleValueFrame(Sender).Value;
end;

procedure TMainDialog.OnTiltRatioChanged(Sender: TObject);
begin
  Display.Design.TiltRatio := TSingleValueFrame(Sender).Value;
end;

procedure TMainDialog.OnEdgeRatioChanged(Sender: TObject);
begin
  Display.Design.EdgeRatio := TSingleValueFrame(Sender).Value;
end;

procedure TMainDialog.OnSlitRatioChanged(Sender: TObject);
begin
  Display.Design.SlitRatio := TSingleValueFrame(Sender).Value;
end;

procedure TMainDialog.OnBlink(Sender: TObject);
begin
  Display.Text := FormatDateTime('HH:NN:SS', Now);
end;

procedure TMainDialog.Button2Click(Sender: TObject);
var
  Panel :TPanel;
begin
  Panel := TControl(Sender).Parent as TPanel;
  ColorDialog.CustomColors[0] := Format('ColorA=%6.6x', [ColorToRGB(Display.Design.BackgroundColor)]);
  ColorDialog.CustomColors[1] := Format('ColorB=%6.6x', [ColorToRGB(Display.Design.BrightColor)]);
  ColorDialog.CustomColors[2] := Format('ColorC=%6.6x', [ColorToRGB(Display.Design.DarkColor)]);
  ColorDialog.Color := Panel.Color;
  if ColorDialog.Execute then begin
    Panel.Color := ColorDialog.Color;
    case Panel.Tag of
    0: Display.Design.BackgroundColor := ColorDialog.Color;
    1: Display.Design.BrightColor := ColorDialog.Color;
    2: Display.Design.DarkColor := ColorDialog.Color;
    end;
  end;
end;

procedure TMainDialog.Button1Click(Sender: TObject);
var
  i :integer;
  Bmp :TBitmap;
begin
  Bmp := TBitmap.Create;
//  Bmp.SetSize(PanelDisplay.ClientWidth, round(PanelDisplay.ClientHeight*4));
//  Display.Draw
end;

procedure TMainDialog.ButtonCopyClick(Sender: TObject);
begin
  Clipboard.AsText := EditCode.Lines.Text;
end;

procedure TMainDialog.ButtonExamplesClick(Sender: TObject);
begin
  DisplayExamplesDialog.Show;
end;

procedure TMainDialog.CheckBoxDarkVisibleChange(Sender: TObject);
begin
  Display.Design.DarkVisible := CheckBoxDarkVisible.Checked;
end;

procedure TMainDialog.CheckBoxInnerGlowChange(Sender: TObject);
begin
  Display.Design.InnerGlow := CheckBoxInnerGlow.Checked;
end;

procedure TMainDialog.ComboBoxAlignmentChange(Sender: TObject);
begin
  Display.Alignment := ALGINS[ComboBoxAlignment.ItemIndex];
end;

procedure TMainDialog.ComboBoxColorSetChange(Sender: TObject);
begin
  with COLORSETS[ComboBoxColorSet.ItemIndex] do begin
    Display.Design.BackgroundColor := Background;
    Display.Design.BrightColor := Bright;
    Display.Design.DarkColor := Dark;
  end;
end;

procedure TMainDialog.ComboBoxModulesChange(Sender: TObject);
begin
  Display.Modules := ComboBoxModules.Text;
end;

procedure TMainDialog.ComboBoxStyleChange(Sender: TObject);
begin
  Display.Design.Style := TSegmentStyle(ComboBoxStyle.ItemIndex);
end;

procedure TMainDialog.ComboBoxTextChange(Sender: TObject);
begin
  Display.Text := ComboBoxText.Text;
end;

procedure TMainDialog.EditModulesKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then begin
    Key := 0;
    Display.Modules := ComboBoxModules.Text;
  end;
end;

procedure TMainDialog.EditPaddingKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then begin
    Key := 0;
    Display.Padding := StrToInt(EditPadding.Text);
  end;
end;

procedure TMainDialog.EditTextKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_RETURN then begin
    Key := 0;
    Display.Text := ComboBoxText.Text;
  end;
end;

procedure TMainDialog.FormChangeBounds(Sender: TObject);
begin

end;

procedure TMainDialog.FormConstrainedResize(Sender: TObject; var MinWidth, MinHeight, MaxWidth,
  MaxHeight: TConstraintSize);
begin
  MinWidth := Width;
  MaxWidth := Width;
end;

end.

