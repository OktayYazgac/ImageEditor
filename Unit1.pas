unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ExtDlgs, ExtCtrls, XPMan, jpeg, axCtrls, StdCtrls,
  ToolWin, ComCtrls, FileCtrl, Unit3;

const
  raz3:Matrix33=
       ((1,1,1),
        (1,1,1),
        (1,1,1),
        (9,0,0));

  raz5:Matrix55=
       ((1,1,1,1,1),
        (1,1,1,1,1),
        (1,1,1,1,1),
        (1,1,1,1,1),
        (1,1,1,1,1),
        (0,25,0,0,0));
  raz7:Matrix77=
       ((1,1,1,1,1,1,1),
        (1,1,1,1,1,1,1),
        (1,1,1,1,1,1,1),
        (1,1,1,1,1,1,1),
        (1,1,1,1,1,1,1),
        (1,1,1,1,1,1,1),
        (1,1,1,1,1,1,1),
        (0,0,49,0,0,0,0));
  blur:Matrix33=
       ((1,2,1),
        (2,4,2),
        (1,2,1),
        (16,0,0));
  emboss:Matrix33=
       ((-1,-1,-1),
        (-1,8,-1),
        (-1,-1,-1),
        (1,0,0));
  embossMORE:Matrix33=
       ((-2,-2,-2),
        (-2,16,-2),
        (-2,-2,-2),
        (1,0,0));
  emboss1:Matrix33=
       ((-1,0,0),
        (0,0,0),
        (0,0,-1),
        (1,128,0));
  tis:Matrix33=
       ((1,0,1),
        (0,0,0),
        (1,0,-2),
        (1,0,0));
  tisgr:Matrix33=
       ((-1,0,0),
        (0,0,0),
        (0,0,1),
        (1,128,0));
  rez:Matrix33=
       ((-1,-1,-1),
        (-1,9,-1),
        (-1,-1,-1),
        (1,0,0));

type
  TfrmMDIParent = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Close1: TMenuItem;
    Exit1: TMenuItem;
    Save2: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N8: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    OpenPictureDialog1: TOpenDialog;
    SavePictureDialog1: TSaveDialog;
    N10: TMenuItem;
    a1: TMenuItem;
    a2: TMenuItem;
    a3: TMenuItem;
    a4: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N9: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    procedure Open1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure CreateChildForm_img(openFile:string);
    procedure Exit1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure a4Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CountMDIChildrenImages:cardinal;
  path,fileName,StandartC:string;
  drive: char;
  img,imgg: TImage;
  frmMDIParent: TfrmMDIParent;

implementation

uses Unit2, Unit4, Unit5, Unit6;

{$R *.dfm}

procedure TfrmMDIParent.CreateChildForm_img(openFile:string);
var
  imgChild:TfrmMDIChild;
begin
  imgChild:=TfrmMDIChild.Create(frmMDIParent);

  img:=TImage.Create(imgChild);
  img.Top:=0;
  img.Left:=0;
  img.Picture.LoadFromFile(openFile);
  img.Height:=img.Picture.Height;
  img.Width:=img.Picture.Width;
  img.Tag:=1;
  img.Parent:=imgChild;

  imgg:=TImage.Create(imgChild);
  imgg.Visible:=false;
  imgg.Tag:=2;
  imgg.Parent:=imgChild;

  ProcessPath(openFile,drive,path,fileName);
  imgChild.Caption:=fileName;
  imgChild.StatusBar1.Panels[0].Text:=openFile;
  imgChild.ClientHeight:=img.Height+19;
  imgChild.ClientWidth:=img.Width;
  imgChild.Color:=clAppWorkSpace;
  imgChild.OnActivate:=imgChild.ActivatefrmMDIChild;
  imgChild.OnClose:=imgChild.ClosefrmMDIChild;
end;

procedure TfrmMDIParent.Open1Click(Sender: TObject);
begin
  if openpicturedialog1.Execute then
  begin
    CreateChildForm_img(OpenPictureDialog1.FileName);
    CountMDIChildrenImages:=CountMDIChildrenImages+1;
    if CountMDIChildrenImages<>0 then
    begin
      frmMDIParent.Save1.Enabled:=true;
      frmMDIParent.Save2.Enabled:=true;
      frmMDIParent.Close1.Enabled:=true;
      frmMDIParent.N6.Enabled:=true;
      frmMDIParent.N2.Enabled:=true;
      frmMDIParent.N3.Enabled:=true;
      frmMDIParent.N4.Enabled:=true;
      frmMDIParent.N8.Enabled:=true;
      frmMDIParent.N9.Enabled:=true;
      frmMDIParent.N16.Enabled:=true;
      frmMDIParent.N17.Enabled:=true;
      frmMDIParent.N18.Enabled:=true;
      frmMDIParent.N19.Enabled:=true;
      frmMDIParent.N20.Enabled:=true;
      frmMDIParent.a1.Enabled:=true;
      frmMDIParent.a2.Enabled:=true;
      frmMDIParent.a3.Enabled:=true;
      frmMDIParent.a4.Enabled:=true;
      frmMDIParent.N12.Enabled:=true;
      frmMDIParent.N13.Enabled:=true;
      frmMDIParent.N15.Enabled:=true;
      frmMDIParent.N21.Enabled:=true;
      frmMDIParent.N22.Enabled:=true;
      frmMDIParent.N25.Enabled:=true;
      frmMDIParent.N23.Enabled:=true;
      frmMDIParent.N24.Enabled:=true;
    end;
  end;
end;

procedure TfrmMDIParent.FormCreate(Sender: TObject);
begin
  doublebuffered:=true;
  CountMDIChildrenImages:=0;
  ProcessPath(Application.ExeName,drive,path,fileName);
  StandartC:=drive+':'+path;
end;

procedure TfrmMDIParent.N2Click(Sender: TObject);
begin
  Correction.ShowModal;
end;

procedure TfrmMDIParent.Exit1Click(Sender: TObject);
begin
  halt;
end;

procedure TfrmMDIParent.N3Click(Sender: TObject);
begin
  Discolor;
end;

procedure TfrmMDIParent.N4Click(Sender: TObject);
begin
  Inversion;
end;

procedure TfrmMDIParent.N8Click(Sender: TObject);
begin
  YourFilter.ShowModal;
end;

procedure TfrmMDIParent.N13Click(Sender: TObject);
var
  i:smallint;
begin
  for i:= MDIChildCount-1 downto 0 do
    MDIChildren[i].WindowState:= wsNormal;
end;

procedure TfrmMDIParent.N12Click(Sender: TObject);
var
  i:smallint;
begin
  for i:= MDIChildCount-1 downto 0 do
    MDIChildren[i].WindowState:= wsMinimized;
end;

procedure TfrmMDIParent.a1Click(Sender: TObject);
begin
  Tile;
end;

procedure TfrmMDIParent.a4Click(Sender: TObject);
begin
  Cascade;
end;

procedure TfrmMDIParent.Close1Click(Sender: TObject);
begin
 if not (ActiveMDIChild = Nil) then 
   if ActiveMDIChild is TfrmMDIChild then
     TfrmMDIChild(ActiveMDIChild).Close;
end;

procedure TfrmMDIParent.N6Click(Sender: TObject);
var
  i:smallint;
begin
  for i:= MDIChildCount-1 downto 0 do
    MDIChildren[i].Close;
end;

procedure TfrmMDIParent.N9Click(Sender: TObject);
begin
  FilterMatrix33(raz3);
  SwitchIMG(1);
end;

procedure TfrmMDIParent.N21Click(Sender: TObject);
begin
  FilterMatrix55(raz5);
  SwitchIMG(1);
end;

procedure TfrmMDIParent.N22Click(Sender: TObject);
begin
  FilterMatrix77(raz7);
  SwitchIMG(1);
end;

procedure TfrmMDIParent.N20Click(Sender: TObject);
begin
  FilterMatrix33(blur);
  SwitchIMG(1);
end;

procedure TfrmMDIParent.N25Click(Sender: TObject);
begin
  FilterMatrix33(tisgr);
  SwitchIMG(1);
end;

procedure TfrmMDIParent.N17Click(Sender: TObject);
begin
  FilterMatrix33(tis);
  SwitchIMG(1);
end;

procedure TfrmMDIParent.N18Click(Sender: TObject);
begin
  FilterMatrix33(emboss);
  SwitchIMG(1);
end;

procedure TfrmMDIParent.N23Click(Sender: TObject);
begin
  FilterMatrix33(embossMORE);
  SwitchIMG(1);
end;

procedure TfrmMDIParent.N19Click(Sender: TObject);
begin
  FilterMatrix33(rez);
  SwitchIMG(1);
end;

procedure TfrmMDIParent.N24Click(Sender: TObject);
begin
  FilterMatrix33(emboss1);
  SwitchIMG(1);
end;

end.
