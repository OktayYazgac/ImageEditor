unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, jpeg, Unit1, Unit3, Unit5,
  ChangedTrackBar;

type
  TCorrection = class(TForm)
    TrackBar1: TChangedTrackBar;
    Edit1: TEdit;
    OK: TButton;
    Cancel: TButton;
    see: TCheckBox;
    Label1: TLabel;
    TrackBar2: TChangedTrackBar;
    Edit2: TEdit;
    Label2: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Change;
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure seeClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  CorrectionValue:smallint;
  Correction: TCorrection;

implementation

{$R *.dfm}

procedure TCorrection.TrackBar1Change(Sender: TObject);
begin
  edit1.Text:=inttostr(trackbar1.Position);
  edit1.Refresh;
  Change;
end;

procedure TCorrection.TrackBar2Change(Sender: TObject);
begin
  edit2.Text:=floattostr(trackbar2.Position);
  edit2.Refresh;
  Change;
end;

procedure TCorrection.FormShow(Sender: TObject);
begin
  SwitchIMG(0);
  trackbar1.Position:=0;
  trackbar2.Position:=0;
  see.Checked:=true;
  CorrectionValue:=0;
  RYF:=-1;
end;

procedure TCorrection.Edit1Change(Sender: TObject);
begin
  trackbar1.Position:=rnd4(rnd2(edit1.Text));
end;

procedure TCorrection.Edit2Change(Sender: TObject);
begin
  trackbar2.Position:=rnd4(rnd2(edit2.Text));
end;

procedure TCorrection.Change;
begin
  if Correction.see.Checked then
  begin
    BrightnessContrast(Correction.TrackBar1.Position,
                       Correction.Trackbar2.Position);
    imgg.Refresh;
  end;
end;

procedure TCorrection.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CorrectionValue=1 then
  begin
    if see.Checked=false then
    begin
      BrightnessContrast(Correction.TrackBar1.Position,
                         Correction.Trackbar2.Position);
    end;
    RYF:=1;
  end;
  SwitchIMG(RYF);
end;

procedure TCorrection.OKClick(Sender: TObject);
begin
  CorrectionValue:=1;
  Correction.Close;
end;

procedure TCorrection.CancelClick(Sender: TObject);
begin
  Correction.Close;
end;

procedure TCorrection.seeClick(Sender: TObject);
begin
  if see.Checked then
  begin
    Change;
    imgg.Visible:=true;
    img.Visible:=false;
  end
  else
  begin
    img.Visible:=true;
    imgg.Visible:=false;
  end;
end;

end.
