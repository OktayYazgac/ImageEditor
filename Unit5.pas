unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Unit3, Unit1;

type
  TYourFilter = class(TForm)
    GroupBox1: TGroupBox;
    OK: TButton;
    ListBox1: TListBox;
    GroupBox2: TGroupBox;
    Edit2: TEdit;
    Edit1: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Edit21: TEdit;
    Edit22: TEdit;
    Edit23: TEdit;
    Edit24: TEdit;
    Edit25: TEdit;
    Edit26: TEdit;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Edit32: TEdit;
    Edit33: TEdit;
    Edit34: TEdit;
    Edit35: TEdit;
    Edit36: TEdit;
    Edit37: TEdit;
    Edit38: TEdit;
    Edit39: TEdit;
    Edit40: TEdit;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit43: TEdit;
    Edit44: TEdit;
    Edit45: TEdit;
    Edit46: TEdit;
    Edit47: TEdit;
    Edit48: TEdit;
    Edit49: TEdit;
    ComboBox1: TComboBox;
    Edit50: TEdit;
    Label1: TLabel;
    Edit51: TEdit;
    Edit52: TEdit;
    Cancel: TButton;
    Del: TButton;
    New: TButton;
    Edit: TButton;
    Save: TButton;
    Apply: TButton;
    Label2: TLabel;
    Label3: TLabel;
    ListBox2: TListBox;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Start;
    procedure Finish;
    procedure Editing;
    procedure notEditing;
    procedure Clear(fClear:shortint);
    procedure ReadOnly;
    procedure let33;
    procedure let55;
    procedure let77;
    procedure blank33;
    procedure blank55;
    procedure blank77;
    procedure put33e(nM:Matrix33);
    procedure put55e(nM:Matrix55);
    procedure put77e(nM:Matrix77);
    function put33m:Matrix33;
    function put55m:Matrix55;
    function put77m:Matrix77;
    function shMtoS33(nM:Matrix33):string;
    function shStoM33(Value:string):Matrix33;
    function shMtoS55(nM:Matrix55):string;
    function shStoM55(Value:string):Matrix55;
    function shMtoS77(nM:Matrix77):string;
    function shStoM77(Value:string):Matrix77;
    procedure ListBox1Click(Sender: TObject);
    procedure DelClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
    procedure OKClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  RYF:shortint;
  edits:array[-3..3,-3..3] of TEdit;
  nM33:Matrix33;
  nM55:Matrix55;
  nM77:Matrix77;
  sStringnM:string;
  fFile:TextFile;
  YourFilter: TYourFilter;

implementation

{$R *.dfm}

procedure TYourFilter.blank33;
var
  i,j:shortint;
begin
  for i:=-1 to 1 do
    for j:=-1 to 1 do
      if edits[i,j].Text='' then
        edits[i,j].Text:='0';
  if edit50.Text='' then
    edit50.Text:='new';
  if edit51.Text='' then
    edit51.Text:='1';
  if edit52.Text='' then
    edit52.Text:='0';
end;

procedure TYourFilter.blank55;
var
  i,j:shortint;
begin
  for i:=-2 to 2 do
    for j:=-2 to 2 do
      if edits[i,j].Text='' then
        edits[i,j].Text:='0';
  if edit50.Text='' then
    edit50.Text:='new';
  if edit51.Text='' then
    edit51.Text:='1';
  if edit52.Text='' then
    edit52.Text:='0';
end;

procedure TYourFilter.blank77;
var
  i,j:shortint;
begin
  for i:=-3 to 3 do
    for j:=-3 to 3 do
      if edits[i,j].Text='' then
        edits[i,j].Text:='0';
  if edit50.Text='' then
    edit50.Text:='new';
  if edit51.Text='' then
    edit51.Text:='1';
  if edit52.Text='' then
    edit52.Text:='0';
end;

function TYourFilter.put33m:Matrix33;
var
  i,j:shortint;
begin
  for i:=-1 to 1 do
    for j:=-1 to 1 do
      Result[i,j]:=rnd2(edits[i,j].Text);
  Result[2,-1]:=rnd2(edit51.Text);
  Result[2,0]:=rnd2(edit52.Text);
end;

function TYourFilter.put55m:Matrix55;
var
  i,j:shortint;
begin
  for i:=-2 to 2 do
    for j:=-2 to 2 do
      Result[i,j]:=rnd2(edits[i,j].Text);
  Result[3,-1]:=rnd2(edit51.Text);
  Result[3,0]:=rnd2(edit52.Text);
end;

function TYourFilter.put77m:Matrix77;
var
  i,j:shortint;
begin
  for i:=-3 to 3 do
    for j:=-3 to 3 do
      Result[i,j]:=rnd2(edits[i,j].Text);
  Result[4,-1]:=rnd2(edit51.Text);
  Result[4,0]:=rnd2(edit52.Text);
end;

function TYourFilter.shMtoS33(nM:Matrix33):string;
var
  i,j:shortint;
begin
  Result:='3 ';
  for i:=-1 to 1 do
    for j:=-1 to 1 do
      Result:=Result+floattostr(nM[i,j])+' ';
  Result:=Result+floattostr(nM[2,-1])+' '+floattostr(nM[2,0]);
end;

function TYourFilter.shStoM33(Value:string):Matrix33;
var
  i,j:shortint;
begin
  Value:=Value+' ';
  for i:=-1 to 1 do
    for j:=-1 to 1 do
    begin
      Result[i,j]:=strtofloat(copy(Value,1,pos(' ',Value)-1));
      delete(Value,1,pos(' ',Value));
    end;
  Result[2,-1]:=strtofloat(copy(Value,1,pos(' ',Value)-1));
  delete(Value,1,pos(' ',Value));
  Result[2,0]:=strtofloat(copy(Value,1,pos(' ',Value)-1));
  delete(Value,1,pos(' ',Value));
end;

function TYourFilter.shMtoS55(nM:Matrix55):string;
var
  i,j:shortint;
begin
  Result:='5 ';
  for i:=-2 to 2 do
    for j:=-2 to 2 do
      Result:=Result+floattostr(nM[i,j])+' ';
  Result:=Result+floattostr(nM[3,-1])+' '+floattostr(nM[3,0]);
end;

function TYourFilter.shStoM55(Value:string):Matrix55;
var
  i,j:shortint;
begin
  Value:=Value+' ';
  for i:=-2 to 2 do
    for j:=-2 to 2 do
    begin
      Result[i,j]:=strtofloat(copy(Value,1,pos(' ',Value)-1));
      delete(Value,1,pos(' ',Value));
    end;
  Result[3,-1]:=strtofloat(copy(Value,1,pos(' ',Value)-1));
  delete(Value,1,pos(' ',Value));
  Result[3,0]:=strtofloat(copy(Value,1,pos(' ',Value)-1));
  delete(Value,1,pos(' ',Value));
end;

function TYourFilter.shMtoS77(nM:Matrix77):string;
var
  i,j:shortint;
begin
  Result:='7 ';
  for i:=-3 to 3 do
    for j:=-3 to 3 do
      Result:=Result+floattostr(nM[i,j])+' ';
  Result:=Result+floattostr(nM[4,-1])+' '+floattostr(nM[4,0]);
end;

function TYourFilter.shStoM77(Value:string):Matrix77;
var
  i,j:shortint;
begin
  Value:=Value+' ';
  for i:=-3 to 3 do
    for j:=-3 to 3 do
    begin
      Result[i,j]:=strtofloat(copy(Value,1,pos(' ',Value)-1));
      delete(Value,1,pos(' ',Value));
    end;
  Result[4,-1]:=strtofloat(copy(Value,1,pos(' ',Value)-1));
  delete(Value,1,pos(' ',Value));
  Result[4,0]:=strtofloat(copy(Value,1,pos(' ',Value)-1));
  delete(Value,1,pos(' ',Value));
end;

procedure TYourFilter.put33e(nM:Matrix33);
var
  i,j:shortint;
begin
  Clear(0);
  for i:=-1 to 1 do
    for j:=-1 to 1 do
      edits[i,j].Text:=floattostr(nM[i,j]);
  edit51.Text:=floattostr(nM[2,-1]);
  edit52.Text:=floattostr(nM[2,0]);
  combobox1.ItemIndex:=0;
end;

procedure TYourFilter.let33;
var
  i,j:shortint;
begin
  for i:=-3 to 3 do
    for j:=-3 to 3 do
      if (i<-1) or (i>1) or (j<-1) or (j>1)  then
      begin
        edits[i,j].Text:='';
        edits[i,j].ReadOnly:=true;
      end;
  for i:=-1 to 1 do
    for j:=-1 to 1 do
      edits[i,j].ReadOnly:=false;
end;

procedure TYourFilter.put55e(nM:Matrix55);
var
  i,j:shortint;
begin
  Clear(0);
  for i:=-2 to 2 do
    for j:=-2 to 2 do
      edits[i,j].Text:=floattostr(nM[i,j]);
  edit51.Text:=floattostr(nM[3,-1]);
  edit52.Text:=floattostr(nM[3,0]);
  combobox1.ItemIndex:=1;
end;

procedure TYourFilter.let55;
var
  i,j:shortint;
begin
  for i:=-3 to 3 do
    for j:=-3 to 3 do
      if (i<-2) or (i>2) or (j<-2) or (j>2)  then
      begin
        edits[i,j].Text:='';
        edits[i,j].ReadOnly:=true;
      end;
  for i:=-2 to 2 do
    for j:=-2 to 2 do
      edits[i,j].ReadOnly:=false;
end;

procedure TYourFilter.let77;
var
  i,j:shortint;
begin
  for i:=-3 to 3 do
    for j:=-3 to 3 do
      edits[i,j].ReadOnly:=false;
end;

procedure TYourFilter.put77e(nM:Matrix77);
var
  i,j:shortint;
begin
  Clear(0);
  for i:=-3 to 3 do
    for j:=-3 to 3 do
      edits[i,j].Text:=floattostr(nM[i,j]);
  edit51.Text:=floattostr(nM[4,-1]);
  edit52.Text:=floattostr(nM[4,0]);
  combobox1.ItemIndex:=2;
end;

procedure TYourFilter.ReadOnly;
var
  i,j:shortint;
begin
  for i:=-3 to 3 do
    for j:=-3 to 3 do
      edits[i,j].ReadOnly:=True;
end;

procedure TYourFilter.Clear(fClear:shortint);
var
  i,j:shortint;
begin
  for i:=-3 to 3 do
    for j:=-3 to 3 do
      edits[i,j].Text:='';
  if fClear=1 then
  begin
    edit50.Text:='';
    edit51.Text:='';
    edit52.Text:='';
    combobox1.ItemIndex:=-1;
  end;
end;

procedure TYourFilter.Editing;
begin
  edit50.Enabled:=true;
  edit51.Enabled:=true;
  edit52.Enabled:=true;
  combobox1.Enabled:=true;
end;

procedure TYourFilter.notEditing;
begin
  edit50.Enabled:=false;
  edit51.Enabled:=false;
  edit52.Enabled:=false;
  combobox1.Enabled:=false;
  ReadOnly;
end;

procedure TYourFilter.Start;
begin
  Clear(1);
  notEditing;
  del.Enabled:=false;
  save.Enabled:=false;
  edit.Enabled:=false;
  apply.Enabled:=false;
end;

procedure TYourFilter.Finish;
begin
  listbox1.Items.SaveToFile(StandartC+'\System\1.fltr');
  listbox2.Items.SaveToFile(StandartC+'\System\2.fltr');
  SwitchIMG(RYF);
end;

procedure TYourFilter.FormShow(Sender: TObject);
begin
  SwitchIMG(0);
  Start;
  listbox1.Items.LoadFromFile(StandartC+'\System\1.fltr');
  listbox2.Items.LoadFromFile(StandartC+'\System\2.fltr');
  RYF:=-1;   
end;

procedure TYourFilter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Finish;
end;

procedure TYourFilter.ListBox1Click(Sender: TObject);
begin
  case strtoint(copy(listbox2.Items[listbox1.ItemIndex],1,1)) of
  3:put33e(shStoM33(copy(listbox2.Items[listbox1.ItemIndex],3,length(listbox2.Items[listbox1.ItemIndex])-2)));
  5:put55e(shStoM55(copy(listbox2.Items[listbox1.ItemIndex],3,length(listbox2.Items[listbox1.ItemIndex])-2)));
  7:put77e(shStoM77(copy(listbox2.Items[listbox1.ItemIndex],3,length(listbox2.Items[listbox1.ItemIndex])-2)));
  end;
  edit50.Text:=listbox1.Items[listbox1.ItemIndex];
  notEditing;
  del.Enabled:=true;
  new.Enabled:=true;
  edit.Enabled:=true;
  apply.Enabled:=true;
  save.Enabled:=false;
end;

procedure TYourFilter.DelClick(Sender: TObject);
begin
  if listbox1.ItemIndex<>-1 then
  begin
    listbox2.Items.Delete(listbox1.ItemIndex);
    listbox1.Items.Delete(listbox1.ItemIndex);
    Start;
  end;
end;

procedure TYourFilter.NewClick(Sender: TObject);
begin
  Clear(1);
  let33;
  blank33;
  listbox1.ItemIndex:=-1;
  combobox1.ItemIndex:=0;
  save.Enabled:=true;
  new.Enabled:=true;
  apply.Enabled:=true;
  edit.Enabled:=false;
  del.Enabled:=false;
  Editing;
end;

procedure TYourFilter.FormCreate(Sender: TObject);
var
  i:shortint;
  bufEdit:TEdit;
begin
  for i:=0 to 48 do
  begin
    bufEdit:=FindComponent('Edit'+inttostr(i+1)) as TEdit;
    if bufEdit<>nil then
      edits[i div 7 -3,i mod 7 -3]:=bufEdit;
  end;
end;

procedure TYourFilter.ComboBox1Change(Sender: TObject);
begin
  case combobox1.ItemIndex of
  0:
  begin
    let33;
    blank33;
  end;
  1:
  begin
    let55;
    blank55;
  end;
  2:
  begin
    let77;
    blank77;
  end;
  end;
end;

procedure TYourFilter.ComboBox1Click(Sender: TObject);
begin
  case combobox1.ItemIndex of
  0:
  begin
    let33;
    blank33;
  end;
  1:
  begin
    let55;
    blank55;
  end;
  2:
  begin
    let77;
    blank77;
  end;
  end;
end;

procedure TYourFilter.EditClick(Sender: TObject);
begin
  Editing;
  case combobox1.ItemIndex of
  0:let33;
  1:let55;
  2:let77;
  end;
  del.Enabled:=true;
  new.Enabled:=true;
  apply.Enabled:=true;
  save.Enabled:=true;
  edit.Enabled:=false;
end;

procedure TYourFilter.SaveClick(Sender: TObject);
begin
  if listbox1.ItemIndex=-1 then
  begin
    case combobox1.ItemIndex of
    0:
    begin
      listbox1.Items.Add(edit50.Text);
      listbox2.Items.Add(shMtoS33(put33m));
    end;
    1:
    begin
      listbox1.Items.Add(edit50.Text);
      listbox2.Items.Add(shMtoS55(put55m));
    end;
    2:
    begin
      listbox1.Items.Add(edit50.Text);
      listbox2.Items.Add(shMtoS55(put55m));
    end;
    end;
    listbox1.ItemIndex:=listbox1.Count-1;
    YourFilter.ListBox1Click(Sender);
  end
  else
  begin
    case combobox1.ItemIndex of
    0:
    begin
      listbox1.Items[listbox1.ItemIndex]:=edit50.Text;
      listbox2.Items[listbox1.ItemIndex]:=shMtoS33(put33m);
    end;
    1:
    begin
      listbox1.Items[listbox1.ItemIndex]:=edit50.Text;
      listbox2.Items[listbox1.ItemIndex]:=shMtoS55(put55m);
    end;
    2:
    begin
      listbox1.Items[listbox1.ItemIndex]:=edit50.Text;
      listbox2.Items[listbox1.ItemIndex]:=shMtoS77(put77m);
    end;
    end;
    YourFilter.ListBox1Click(Sender);
  end
end;

procedure TYourFilter.ApplyClick(Sender: TObject);
begin
  case combobox1.ItemIndex of
  0:
  begin
    FilterMatrix33(put33m);
  end;
  1:
  begin
    FilterMatrix55(put55m);
  end;
  2:
  begin
    FilterMatrix77(put77m);
  end;
  end;
end;

procedure TYourFilter.OKClick(Sender: TObject);
begin
  RYF:=1;
  YourFilter.Close;
end;

procedure TYourFilter.CancelClick(Sender: TObject);
begin
  RYF:=-1;
  YourFilter.Close;
end;

end.




