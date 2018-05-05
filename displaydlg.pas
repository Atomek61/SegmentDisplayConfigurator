unit DisplayDlg;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Controls.SegmentDisplay, FPImage, Types.Led;

type

  { TPreviewDialog }

  TPreviewDialog = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    Display :TSegmentDisplay;
  end;

var
  PreviewDialog: TPreviewDialog;

implementation

uses
  MainDlg;

{$R *.lfm}

{ TPreviewDialog }

procedure TPreviewDialog.FormCreate(Sender: TObject);
begin
  Display := MainDialog.Display;
  Display.Parent := self;
  Display.Align := alClient;
  Display.Visible := true;
end;

procedure TPreviewDialog.Button1Click(Sender: TObject);
var
  Bmp :TBitmap;
  Png :TPortableNetworkGraphic;
  i :integer;
begin
  Bmp := TBitmap.Create;
  Bmp.SetSize(Display.Width, Display.Height);
  Png := TPortableNetworkGraphic.Create;
  for i:=0 to High(COLORSETS) do begin
    with COLORSETS[i] do begin
      Display.Design.BackgroundColor := Background;
      Display.Design.BrightColor := Bright;
      Display.Design.DarkColor := Dark;
    end;
    Application.ProcessMessages;
    Display.Draw(Bmp.Canvas);
    Png.Assign(Bmp);
    Png.SaveToFile(Format('D:\TEMP\COLORSET%d.png', [i+1]));
  end;
  Bmp.Free;
  Png.Free;
end;

end.

