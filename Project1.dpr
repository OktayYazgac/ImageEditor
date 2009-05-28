program Project1;

uses
  Forms,
  Unit1 in 'Unit1.pas' {frmMDIParent},
  Unit2 in 'Unit2.pas' {Correction},
  Unit3 in 'Unit3.pas',
  Unit4 in 'Unit4.pas' {frmMDIChild},
  Unit5 in 'Unit5.pas' {YourFilter},
  Unit6 in 'Unit6.pas' {Filter};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMDIParent, frmMDIParent);
  Application.CreateForm(TYourFilter, YourFilter);
  Application.CreateForm(TFilter, Filter);
  Application.CreateForm(TCorrection, Correction);
  Application.Run;
end.
