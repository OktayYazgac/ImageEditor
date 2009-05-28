unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TFilter = class(TForm)
    TreeView1: TTreeView;
    OK: TButton;
    Cancel: TButton;
    Before: TGroupBox;
    After: TGroupBox;
    GroupBox3: TGroupBox;
    Apply: TCheckBox;
    Image1: TImage;
    Image2: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Filter: TFilter;

implementation

{$R *.dfm}

end.
