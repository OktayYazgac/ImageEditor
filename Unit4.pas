unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls;

type
  TfrmMDIChild = class(TForm)
    StatusBar1: TStatusBar;
  procedure ActivatefrmMDIChild(Sender: TObject);
  procedure ClosefrmMDIChild(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var

  frmMDIChild: TfrmMDIChild;

implementation

uses Unit1;

{$R *.dfm}

procedure TfrmMDIChild.ActivatefrmMDIChild(Sender: TObject);
var
  i:byte;
begin
  for i:=(Sender as TfrmMDIChild).ComponentCount-1 downto 0 do
    if (Sender as TfrmMDIChild).Components[i].Tag=1 then
      img:=(Sender as TfrmMDIChild).Components[i] as TImage
    else
      if (Sender as TfrmMDIChild).Components[i].Tag=2 then
        imgg:=(Sender as TfrmMDIChild).Components[i] as TImage;
end;

procedure TfrmMDIChild.ClosefrmMDIChild(Sender: TObject; var Action: TCloseAction);
var
  i:word;
begin
  CountMDIChildrenImages:=CountMDIChildrenImages-1;
  if CountMDIChildrenImages=0 then
  begin
      frmMDIParent.Save1.Enabled:=false;
      frmMDIParent.Save2.Enabled:=false;
      frmMDIParent.Close1.Enabled:=false;
      frmMDIParent.N6.Enabled:=false;
      frmMDIParent.N2.Enabled:=false;
      frmMDIParent.N3.Enabled:=false;
      frmMDIParent.N4.Enabled:=false;
      frmMDIParent.N8.Enabled:=false;
      frmMDIParent.N9.Enabled:=false;
      frmMDIParent.N16.Enabled:=false;
      frmMDIParent.N17.Enabled:=false;
      frmMDIParent.N18.Enabled:=false;
      frmMDIParent.N19.Enabled:=false;
      frmMDIParent.N20.Enabled:=false;
      frmMDIParent.a1.Enabled:=false;
      frmMDIParent.a2.Enabled:=false;
      frmMDIParent.a3.Enabled:=false;
      frmMDIParent.a4.Enabled:=false;
      frmMDIParent.N12.Enabled:=false;
      frmMDIParent.N13.Enabled:=false;
      frmMDIParent.N15.Enabled:=false;
      frmMDIParent.N21.Enabled:=false;
      frmMDIParent.N22.Enabled:=false;
      frmMDIParent.N25.Enabled:=false;
      frmMDIParent.N23.Enabled:=false;
      frmMDIParent.N24.Enabled:=false;
  end;
  Action:=caFree;
end;

end.
