unit Unit3;

interface

uses
  Windows, SysUtils, Graphics;

type
  pRGBArray = ^TRGBArray;
  TRGBArray = array[0..32767] of TRGBTriple; 
  Matrix33  = array[-1..2,-1..1] of single; //2,0-br,2,-1divi...
  Matrix55  = array[-2..3,-2..2] of single;
  Matrix77  = array[-3..4,-3..3] of single;
  procedure BrightnessContrast(ValueB:shortint; ValueC:real);
  procedure Discolor;
  procedure Inversion;
  procedure FilterMatrix33(nM:Matrix33);
  procedure FilterMatrix55(nM:Matrix55);
  procedure FilterMatrix77(nM:Matrix77);
  procedure SwitchIMG(bufSwitchIMG:shortint); //switch img imgg
  function rnd(rndRGB:real):byte; //color
  function rnd2(Value:shortstring):integer; //f5
  function rnd4(Value:integer):shortint; //edit
  function rnd3i(Value:smallint):smallint; //filter i
var
  p:array[-6..6] of pRGBArray;
  pp:pRGBArray;
  CorrectionBitmap:TBitmap;

implementation

Uses Unit2, Unit1, Unit4,Unit5;

function rnd4(Value:integer):shortint;
begin
  if Value<-100 then
    Result:=-100
  else
  if Value>100 then
    Result:=100
  else
    Result:=Value;
end;

procedure SwitchIMG(bufSwitchIMG:shortint);
begin
  if bufSwitchIMG=0 then
  begin
    imgg.Top:=img.Top;
    imgg.Left:=img.Left;
    imgg.Height:=img.Height;
    imgg.Width:=img.Width;
    imgg.Picture.Assign(img.Picture);
    imgg.Visible:=true;
    img.Visible:=false;
  end
  else
    if bufSwitchIMG=1 then
    begin
      img.Picture.Assign(imgg.Picture);
      img.Visible:=true;
      imgg.Visible:=false;
    end
    else
    begin
      img.Visible:=true;
      imgg.Visible:=false;
    end;
end;

function rnd(rndRGB:real):byte;
begin
  if rndRGB<0 then
    Result:=0
  else
  if rndRGB>255 then
    Result:=255
  else
    Result:=round(rndRGB);
end;

function rnd2(Value:shortstring):integer;
var
  CodeER:integer;
begin
  val(Value,Result,CodeER);
end;

function rnd3i(Value:smallint):smallint;
begin
  if Value<0 then
    Result:=0
  else
  if Value>correctionbitmap.Height-1 then
    Result:=correctionbitmap.Height-1
  else
    Result:=Value;
end;

procedure BrightnessContrast(ValueB:shortint; ValueC:real);
var
  i,j:word;
  kb,kg,kr:integer;
begin
  CorrectionBitmap:=TBitmap.Create;
  try
  CorrectionBitmap.Assign(img.Picture);
  if ValueC>0 then
    ValueC:=1+sqrt( ValueC)/10
  else
    ValueC:=1-sqrt(-ValueC)/10;
  kb:=0;
  kg:=0;
  kr:=0;
  for i:=CorrectionBitmap.Height-1 downto 0 do
  begin
    p[0]:=CorrectionBitmap.ScanLine[i];
    for j:=CorrectionBitmap.Width-1 downto 0 do
    begin
      kb:=kb+p[0][j].rgbtBlue;
      kg:=kg+p[0][j].rgbtGreen;
      kr:=kr+p[0][j].rgbtRed;
    end;
  end;
  kb:=round(kb/(CorrectionBitmap.Height*CorrectionBitmap.Width));
  kg:=round(kg/(CorrectionBitmap.Height*CorrectionBitmap.Width));
  kr:=round(kr/(CorrectionBitmap.Height*CorrectionBitmap.Width));
  for i:=CorrectionBitmap.Height-1 downto 0 do
  begin
    p[0]:=CorrectionBitmap.ScanLine[i];
    for j:=CorrectionBitmap.Width-1 downto 0 do
    begin
      p[0][j].rgbtBlue :=rnd(ValueC*(-kb+p[0][j].rgbtBlue )+kb+ValueB);
      p[0][j].rgbtGreen:=rnd(ValueC*(-kg+p[0][j].rgbtGreen)+kg+ValueB);
      p[0][j].rgbtRed  :=rnd(ValueC*(-kr+p[0][j].rgbtRed  )+kr+ValueB);
    end;
  end;
  finally
    imgg.Picture.Assign(CorrectionBitmap);
    CorrectionBitmap.Free;
  end;
end;

procedure Discolor;
var
  i,j:word;
begin
  CorrectionBitmap:=TBitmap.Create;
  try
  CorrectionBitmap.Assign(img.Picture);
  for i:=CorrectionBitmap.Height-1 downto 0 do
  begin
    p[0]:=CorrectionBitmap.ScanLine[i];
    for j:=CorrectionBitmap.Width-1 downto 0 do
    begin
      p[0][j].rgbtBlue :=rnd(0.11*p[0][j].rgbtBlue+0.59*p[0][j].rgbtGreen+0.3*p[0][j].rgbtRed);
      p[0][j].rgbtGreen:=p[0][j].rgbtBlue;
      p[0][j].rgbtRed  :=p[0][j].rgbtBlue;
    end;
  end;
  finally
    img.Picture.Assign(CorrectionBitmap);
    CorrectionBitmap.Free;
  end;
end;

procedure Inversion;
var
  i,j:word;
begin
  CorrectionBitmap:=TBitmap.Create;
  try
  CorrectionBitmap.Assign(img.Picture);
  for i:=CorrectionBitmap.Height-1 downto 0 do
  begin
    p[0]:=CorrectionBitmap.ScanLine[i];
    for j:=CorrectionBitmap.Width-1 downto 0 do
    begin
      p[0][j].rgbtBlue :=255-p[0][j].rgbtBlue;
      p[0][j].rgbtGreen:=255-p[0][j].rgbtGreen;
      p[0][j].rgbtRed  :=255-p[0][j].rgbtRed;
    end;
  end;
  finally
    img.Picture.Assign(CorrectionBitmap);
    CorrectionBitmap.Free;
  end;
end;

procedure FilterMatrix33(nM:Matrix33);
var
  i,j:integer;
begin
  if nM[2,-1]=0 then
    nm[2,-1]:=1;
  CorrectionBitmap:=TBitmap.Create;
  try
  CorrectionBitmap.Assign(img.Picture);
  for i:=CorrectionBitmap.Height-1 downto 0 do
  begin
    if i=0 then
      p[-1]:=img.Picture.Bitmap.ScanLine[0]
    else
      p[-1]:=img.Picture.Bitmap.ScanLine[i-1];
    p[0] :=img.Picture.Bitmap.ScanLine[i];
    if i=CorrectionBitmap.Height-1 then
      p[1] :=img.Picture.Bitmap.ScanLine[i]
    else
      p[1] :=img.Picture.Bitmap.ScanLine[i+1];
    pp   :=CorrectionBitmap.ScanLine[i];
       pp[correctionbitmap.Width-1].rgbtBlue:=rnd((p[-1][correctionbitmap.Width-2].rgbtBlue*nM[-1,-1]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[-1,0]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[-1,1]

                          +p[0][correctionbitmap.Width-2].rgbtBlue*nM[0,-1]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,0]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,1]

                          +p[1][correctionbitmap.Width-2].rgbtBlue*nM[1,-1]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[1,0]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[1,1])
                          /nM[2,-1]+nm[2,0]);
      pp[correctionbitmap.Width-1].rgbtGreen:=rnd((p[-1][correctionbitmap.Width-2].rgbtGreen*nM[-1,-1]
                           +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[-1,0]
                           +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[-1,1]

                           +p[0][correctionbitmap.Width-2].rgbtGreen*nM[0,-1]
                           +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,0]
                           +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,1]

                           +p[1][correctionbitmap.Width-2].rgbtGreen*nM[1,-1]
                           +p[1][correctionbitmap.Width-1].rgbtGreen*nM[1,0]
                           +p[1][correctionbitmap.Width-1].rgbtGreen*nM[1,1])
                           /nM[2,-1]+nm[2,0]);
      pp[correctionbitmap.Width-1].rgbtRed:=rnd((p[-1][correctionbitmap.Width-2].rgbtRed*nM[-1,-1]
                         +p[-1][correctionbitmap.Width-1].rgbtRed*nM[-1,0]
                         +p[-1][correctionbitmap.Width-1].rgbtRed*nM[-1,1]

                         +p[0][correctionbitmap.Width-2].rgbtRed*nM[0,-1]
                         +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,0]
                         +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,1]

                         +p[1][correctionbitmap.Width-2].rgbtRed*nM[1,-1]
                         +p[1][correctionbitmap.Width-1].rgbtRed*nM[1,0]
                         +p[1][correctionbitmap.Width-1].rgbtRed*nM[1,1])
                         /nM[2,-1]+nm[2,0]);
       pp[0].rgbtBlue:=rnd((p[-1][0].rgbtBlue*nM[-1,-1]
                          +p[-1][0].rgbtBlue*nM[-1,0]
                          +p[-1][1].rgbtBlue*nM[-1,1]

                          +p[0][0].rgbtBlue*nM[0,-1]
                          +p[0][0].rgbtBlue*nM[0,0]
                          +p[0][1].rgbtBlue*nM[0,1]

                          +p[1][0].rgbtBlue*nM[1,-1]
                          +p[1][0].rgbtBlue*nM[1,0]
                          +p[1][1].rgbtBlue*nM[1,1])
                          /nM[2,-1]+nm[2,0]);
      pp[0].rgbtGreen:=rnd((p[-1][0].rgbtGreen*nM[-1,-1]
                           +p[-1][0].rgbtGreen*nM[-1,0]
                           +p[-1][1].rgbtGreen*nM[-1,1]

                           +p[0][0].rgbtGreen*nM[0,-1]
                           +p[0][0].rgbtGreen*nM[0,0]
                           +p[0][1].rgbtGreen*nM[0,1]

                           +p[1][0].rgbtGreen*nM[1,-1]
                           +p[1][0].rgbtGreen*nM[1,0]
                           +p[1][1].rgbtGreen*nM[1,1])
                           /nM[2,-1]+nm[2,0]);
      pp[0].rgbtRed:=rnd((p[-1][0].rgbtRed*nM[-1,-1]
                         +p[-1][0].rgbtRed*nM[-1,0]
                         +p[-1][1].rgbtRed*nM[-1,1]

                         +p[0][0].rgbtRed*nM[0,-1]
                         +p[0][0].rgbtRed*nM[0,0]
                         +p[0][1].rgbtRed*nM[0,1]

                         +p[1][0].rgbtRed*nM[1,-1]
                         +p[1][0].rgbtRed*nM[1,0]
                         +p[1][1].rgbtRed*nM[1,1])
                         /nM[2,-1]+nm[2,0]);
    for j:=CorrectionBitmap.Width-2 downto 1 do
    begin
      pp[j].rgbtBlue:=rnd((p[-1][j-1].rgbtBlue*nM[-1,-1]
                          +p[-1][j].rgbtBlue*nM[-1,0]
                          +p[-1][j+1].rgbtBlue*nM[-1,1]

                          +p[0][j-1].rgbtBlue*nM[0,-1]
                          +p[0][j].rgbtBlue*nM[0,0]
                          +p[0][j+1].rgbtBlue*nM[0,1]

                          +p[1][j-1].rgbtBlue*nM[1,-1]
                          +p[1][j].rgbtBlue*nM[1,0]
                          +p[1][j+1].rgbtBlue*nM[1,1])
                          /nM[2,-1]+nm[2,0]);
      pp[j].rgbtGreen:=rnd((p[-1][j-1].rgbtGreen*nM[-1,-1]
                           +p[-1][j].rgbtGreen*nM[-1,0]
                           +p[-1][j+1].rgbtGreen*nM[-1,1]

                           +p[0][j-1].rgbtGreen*nM[0,-1]
                           +p[0][j].rgbtGreen*nM[0,0]
                           +p[0][j+1].rgbtGreen*nM[0,1]

                           +p[1][j-1].rgbtGreen*nM[1,-1]
                           +p[1][j].rgbtGreen*nM[1,0]
                           +p[1][j+1].rgbtGreen*nM[1,1])
                           /nM[2,-1]+nm[2,0]);
      pp[j].rgbtRed:=rnd((p[-1][j-1].rgbtRed*nM[-1,-1]
                         +p[-1][j].rgbtRed*nM[-1,0]
                         +p[-1][j+1].rgbtRed*nM[-1,1]

                         +p[0][j-1].rgbtRed*nM[0,-1]
                         +p[0][j].rgbtRed*nM[0,0]
                         +p[0][j+1].rgbtRed*nM[0,1]

                         +p[1][j-1].rgbtRed*nM[1,-1]
                         +p[1][j].rgbtRed*nM[1,0]
                         +p[1][j+1].rgbtRed*nM[1,1])
                         /nM[2,-1]+nM[2,0]);
    end;
  end;
  finally
    imgg.Picture.Assign(CorrectionBitmap);
    CorrectionBitmap.Free;
  end;
end;

procedure FilterMatrix55(nM:Matrix55);
var
  i,j:integer;
begin
  if nM[3,-1]=0 then
    nm[3,-1]:=1;
  CorrectionBitmap:=TBitmap.Create;
  try
  CorrectionBitmap.Assign(img.Picture);
  for i:=CorrectionBitmap.Height-1 downto 0 do
  begin
    p[-2]:=img.Picture.Bitmap.ScanLine[rnd3i(i-2)];
    p[-1]:=img.Picture.Bitmap.ScanLine[rnd3i(i-1)];
    p[0] :=img.Picture.Bitmap.ScanLine[i];
    p[1] :=img.Picture.Bitmap.ScanLine[rnd3i(i+1)];
    p[2] :=img.Picture.Bitmap.ScanLine[rnd3i(i+2)];
    pp   :=CorrectionBitmap.ScanLine[i];
      pp[0].rgbtBlue:=rnd((p[-2][0].rgbtBlue*nM[-2,-2]
                          +p[-2][0].rgbtBlue*nM[-2,-1]
                          +p[-2][0].rgbtBlue*nM[-2,0]
                          +p[-2][1].rgbtBlue*nM[-2,1]
                          +p[-2][2].rgbtBlue*nM[-2,2]

                          +p[-1][0].rgbtBlue*nM[-1,-2]
                          +p[-1][0].rgbtBlue*nM[-1,-1]
                          +p[-1][0].rgbtBlue*nM[-1,0]
                          +p[-1][1].rgbtBlue*nM[-1,1]
                          +p[-1][2].rgbtBlue*nM[-1,2]

                          +p[0][0].rgbtBlue*nM[0,-2]
                          +p[0][0].rgbtBlue*nM[0,-1]
                          +p[0][0].rgbtBlue*nM[0,0]
                          +p[0][1].rgbtBlue*nM[0,1]
                          +p[0][2].rgbtBlue*nM[0,2]

                          +p[1][0].rgbtBlue*nM[1,-2]
                          +p[1][0].rgbtBlue*nM[1,-1]
                          +p[1][0].rgbtBlue*nM[1,0]
                          +p[1][1].rgbtBlue*nM[1,1]
                          +p[1][2].rgbtBlue*nM[1,2]

                          +p[2][0].rgbtBlue*nM[2,-2]
                          +p[2][0].rgbtBlue*nM[2,-1]
                          +p[2][0].rgbtBlue*nM[2,0]
                          +p[2][1].rgbtBlue*nM[2,1]
                          +p[2][2].rgbtBlue*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[0].rgbtGreen:=rnd((p[-2][0].rgbtGreen*nM[-2,-2]
                          +p[-2][0].rgbtGreen*nM[-2,-1]
                          +p[-2][0].rgbtGreen*nM[-2,0]
                          +p[-2][1].rgbtGreen*nM[-2,1]
                          +p[-2][2].rgbtGreen*nM[-2,2]

                          +p[-1][0].rgbtGreen*nM[-1,-2]
                          +p[-1][0].rgbtGreen*nM[-1,-1]
                          +p[-1][0].rgbtGreen*nM[-1,0]
                          +p[-1][1].rgbtGreen*nM[-1,1]
                          +p[-1][2].rgbtGreen*nM[-1,2]

                          +p[0][0].rgbtGreen*nM[0,-2]
                          +p[0][0].rgbtGreen*nM[0,-1]
                          +p[0][0].rgbtGreen*nM[0,0]
                          +p[0][1].rgbtGreen*nM[0,1]
                          +p[0][2].rgbtGreen*nM[0,2]

                          +p[1][0].rgbtGreen*nM[1,-2]
                          +p[1][0].rgbtGreen*nM[1,-1]
                          +p[1][0].rgbtGreen*nM[1,0]
                          +p[1][1].rgbtGreen*nM[1,1]
                          +p[1][2].rgbtGreen*nM[1,2]

                          +p[2][0].rgbtGreen*nM[2,-2]
                          +p[2][0].rgbtGreen*nM[2,-1]
                          +p[2][0].rgbtGreen*nM[2,0]
                          +p[2][1].rgbtGreen*nM[2,1]
                          +p[2][2].rgbtGreen*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[0].rgbtRed:=rnd((p[-2][0].rgbtRed*nM[-2,-2]
                          +p[-2][0].rgbtRed*nM[-2,-1]
                          +p[-2][0].rgbtRed*nM[-2,0]
                          +p[-2][1].rgbtRed*nM[-2,1]
                          +p[-2][2].rgbtRed*nM[-2,2]

                          +p[-1][0].rgbtRed*nM[-1,-2]
                          +p[-1][0].rgbtRed*nM[-1,-1]
                          +p[-1][0].rgbtRed*nM[-1,0]
                          +p[-1][1].rgbtRed*nM[-1,1]
                          +p[-1][2].rgbtRed*nM[-1,2]

                          +p[0][0].rgbtRed*nM[0,-2]
                          +p[0][0].rgbtRed*nM[0,-1]
                          +p[0][0].rgbtRed*nM[0,0]
                          +p[0][1].rgbtRed*nM[0,1]
                          +p[0][2].rgbtRed*nM[0,2]

                          +p[1][0].rgbtRed*nM[1,-2]
                          +p[1][0].rgbtRed*nM[1,-1]
                          +p[1][0].rgbtRed*nM[1,0]
                          +p[1][1].rgbtRed*nM[1,1]
                          +p[1][2].rgbtRed*nM[1,2]

                          +p[2][0].rgbtRed*nM[2,-2]
                          +p[2][0].rgbtRed*nM[2,-1]
                          +p[2][0].rgbtRed*nM[2,0]
                          +p[2][1].rgbtRed*nM[2,1]
                          +p[2][2].rgbtRed*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[1].rgbtBlue:=rnd((p[-2][0].rgbtBlue*nM[-2,-2]
                          +p[-2][0].rgbtBlue*nM[-2,-1]
                          +p[-2][1].rgbtBlue*nM[-2,0]
                          +p[-2][2].rgbtBlue*nM[-2,1]
                          +p[-2][3].rgbtBlue*nM[-2,2]

                          +p[-1][0].rgbtBlue*nM[-1,-2]
                          +p[-1][0].rgbtBlue*nM[-1,-1]
                          +p[-1][1].rgbtBlue*nM[-1,0]
                          +p[-1][2].rgbtBlue*nM[-1,1]
                          +p[-1][3].rgbtBlue*nM[-1,2]

                          +p[0][0].rgbtBlue*nM[0,-2]
                          +p[0][0].rgbtBlue*nM[0,-1]
                          +p[0][1].rgbtBlue*nM[0,0]
                          +p[0][2].rgbtBlue*nM[0,1]
                          +p[0][3].rgbtBlue*nM[0,2]

                          +p[1][0].rgbtBlue*nM[1,-2]
                          +p[1][0].rgbtBlue*nM[1,-1]
                          +p[1][1].rgbtBlue*nM[1,0]
                          +p[1][2].rgbtBlue*nM[1,1]
                          +p[1][3].rgbtBlue*nM[1,2]

                          +p[2][0].rgbtBlue*nM[2,-2]
                          +p[2][0].rgbtBlue*nM[2,-1]
                          +p[2][1].rgbtBlue*nM[2,0]
                          +p[2][2].rgbtBlue*nM[2,1]
                          +p[2][3].rgbtBlue*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[1].rgbtGreen:=rnd((p[-2][0].rgbtGreen*nM[-2,-2]
                          +p[-2][0].rgbtGreen*nM[-2,-1]
                          +p[-2][1].rgbtGreen*nM[-2,0]
                          +p[-2][2].rgbtGreen*nM[-2,1]
                          +p[-2][3].rgbtGreen*nM[-2,2]

                          +p[-1][0].rgbtGreen*nM[-1,-2]
                          +p[-1][0].rgbtGreen*nM[-1,-1]
                          +p[-1][1].rgbtGreen*nM[-1,0]
                          +p[-1][2].rgbtGreen*nM[-1,1]
                          +p[-1][3].rgbtGreen*nM[-1,2]

                          +p[0][0].rgbtGreen*nM[0,-2]
                          +p[0][0].rgbtGreen*nM[0,-1]
                          +p[0][1].rgbtGreen*nM[0,0]
                          +p[0][2].rgbtGreen*nM[0,1]
                          +p[0][3].rgbtGreen*nM[0,2]

                          +p[1][0].rgbtGreen*nM[1,-2]
                          +p[1][0].rgbtGreen*nM[1,-1]
                          +p[1][1].rgbtGreen*nM[1,0]
                          +p[1][2].rgbtGreen*nM[1,1]
                          +p[1][3].rgbtGreen*nM[1,2]

                          +p[2][0].rgbtGreen*nM[2,-2]
                          +p[2][0].rgbtGreen*nM[2,-1]
                          +p[2][1].rgbtGreen*nM[2,0]
                          +p[2][2].rgbtGreen*nM[2,1]
                          +p[2][3].rgbtGreen*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[1].rgbtRed:=rnd((p[-2][0].rgbtRed*nM[-2,-2]
                          +p[-2][0].rgbtRed*nM[-2,-1]
                          +p[-2][1].rgbtRed*nM[-2,0]
                          +p[-2][2].rgbtRed*nM[-2,1]
                          +p[-2][3].rgbtRed*nM[-2,2]

                          +p[-1][0].rgbtRed*nM[-1,-2]
                          +p[-1][0].rgbtRed*nM[-1,-1]
                          +p[-1][1].rgbtRed*nM[-1,0]
                          +p[-1][2].rgbtRed*nM[-1,1]
                          +p[-1][3].rgbtRed*nM[-1,2]

                          +p[0][0].rgbtRed*nM[0,-2]
                          +p[0][0].rgbtRed*nM[0,-1]
                          +p[0][1].rgbtRed*nM[0,0]
                          +p[0][2].rgbtRed*nM[0,1]
                          +p[0][3].rgbtRed*nM[0,2]

                          +p[1][0].rgbtRed*nM[1,-2]
                          +p[1][0].rgbtRed*nM[1,-1]
                          +p[1][1].rgbtRed*nM[1,0]
                          +p[1][2].rgbtRed*nM[1,1]
                          +p[1][3].rgbtRed*nM[1,2]

                          +p[2][0].rgbtRed*nM[2,-2]
                          +p[2][0].rgbtRed*nM[2,-1]
                          +p[2][1].rgbtRed*nM[2,0]
                          +p[2][2].rgbtRed*nM[2,1]
                          +p[2][3].rgbtRed*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[CorrectionBitmap.Width-1].rgbtBlue:=rnd((p[-2][CorrectionBitmap.Width-3].rgbtBlue*nM[-2,-2]
                          +p[-2][CorrectionBitmap.Width-2].rgbtBlue*nM[-2,-1]
                          +p[-2][CorrectionBitmap.Width-1].rgbtBlue*nM[-2,0]
                          +p[-2][CorrectionBitmap.Width-1].rgbtBlue*nM[-2,1]
                          +p[-2][CorrectionBitmap.Width-1].rgbtBlue*nM[-2,2]

                          +p[-1][CorrectionBitmap.Width-3].rgbtBlue*nM[-1,-2]
                          +p[-1][CorrectionBitmap.Width-2].rgbtBlue*nM[-1,-1]
                          +p[-1][CorrectionBitmap.Width-1].rgbtBlue*nM[-1,0]
                          +p[-1][CorrectionBitmap.Width-1].rgbtBlue*nM[-1,1]
                          +p[-1][CorrectionBitmap.Width-1].rgbtBlue*nM[-1,2]

                          +p[0][CorrectionBitmap.Width-3].rgbtBlue*nM[0,-2]
                          +p[0][CorrectionBitmap.Width-2].rgbtBlue*nM[0,-1]
                          +p[0][CorrectionBitmap.Width-1].rgbtBlue*nM[0,0]
                          +p[0][CorrectionBitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[0][CorrectionBitmap.Width-1].rgbtBlue*nM[0,2]

                          +p[1][CorrectionBitmap.Width-3].rgbtBlue*nM[1,-2]
                          +p[1][CorrectionBitmap.Width-2].rgbtBlue*nM[1,-1]
                          +p[1][CorrectionBitmap.Width-1].rgbtBlue*nM[1,0]
                          +p[1][CorrectionBitmap.Width-1].rgbtBlue*nM[1,1]
                          +p[1][CorrectionBitmap.Width-1].rgbtBlue*nM[1,2]

                          +p[2][CorrectionBitmap.Width-3].rgbtBlue*nM[2,-2]
                          +p[2][CorrectionBitmap.Width-2].rgbtBlue*nM[2,-1]
                          +p[2][CorrectionBitmap.Width-1].rgbtBlue*nM[2,0]
                          +p[2][CorrectionBitmap.Width-1].rgbtBlue*nM[2,1]
                          +p[2][CorrectionBitmap.Width-1].rgbtBlue*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[CorrectionBitmap.Width-1].rgbtGreen:=rnd((p[-2][CorrectionBitmap.Width-3].rgbtGreen*nM[-2,-2]
                          +p[-2][CorrectionBitmap.Width-2].rgbtGreen*nM[-2,-1]
                          +p[-2][CorrectionBitmap.Width-1].rgbtGreen*nM[-2,0]
                          +p[-2][CorrectionBitmap.Width-1].rgbtGreen*nM[-2,1]
                          +p[-2][CorrectionBitmap.Width-1].rgbtGreen*nM[-2,2]

                          +p[-1][CorrectionBitmap.Width-3].rgbtGreen*nM[-1,-2]
                          +p[-1][CorrectionBitmap.Width-2].rgbtGreen*nM[-1,-1]
                          +p[-1][CorrectionBitmap.Width-1].rgbtGreen*nM[-1,0]
                          +p[-1][CorrectionBitmap.Width-1].rgbtGreen*nM[-1,1]
                          +p[-1][CorrectionBitmap.Width-1].rgbtGreen*nM[-1,2]

                          +p[0][CorrectionBitmap.Width-3].rgbtGreen*nM[0,-2]
                          +p[0][CorrectionBitmap.Width-2].rgbtGreen*nM[0,-1]
                          +p[0][CorrectionBitmap.Width-1].rgbtGreen*nM[0,0]
                          +p[0][CorrectionBitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[0][CorrectionBitmap.Width-1].rgbtGreen*nM[0,2]

                          +p[1][CorrectionBitmap.Width-3].rgbtGreen*nM[1,-2]
                          +p[1][CorrectionBitmap.Width-2].rgbtGreen*nM[1,-1]
                          +p[1][CorrectionBitmap.Width-1].rgbtGreen*nM[1,0]
                          +p[1][CorrectionBitmap.Width-1].rgbtGreen*nM[1,1]
                          +p[1][CorrectionBitmap.Width-1].rgbtGreen*nM[1,2]

                          +p[2][CorrectionBitmap.Width-3].rgbtGreen*nM[2,-2]
                          +p[2][CorrectionBitmap.Width-2].rgbtGreen*nM[2,-1]
                          +p[2][CorrectionBitmap.Width-1].rgbtGreen*nM[2,0]
                          +p[2][CorrectionBitmap.Width-1].rgbtGreen*nM[2,1]
                          +p[2][CorrectionBitmap.Width-1].rgbtGreen*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[CorrectionBitmap.Width-1].rgbtRed:=rnd((p[-2][CorrectionBitmap.Width-3].rgbtRed*nM[-2,-2]
                          +p[-2][CorrectionBitmap.Width-2].rgbtRed*nM[-2,-1]
                          +p[-2][CorrectionBitmap.Width-1].rgbtRed*nM[-2,0]
                          +p[-2][CorrectionBitmap.Width-1].rgbtRed*nM[-2,1]
                          +p[-2][CorrectionBitmap.Width-1].rgbtRed*nM[-2,2]

                          +p[-1][CorrectionBitmap.Width-3].rgbtRed*nM[-1,-2]
                          +p[-1][CorrectionBitmap.Width-2].rgbtRed*nM[-1,-1]
                          +p[-1][CorrectionBitmap.Width-1].rgbtRed*nM[-1,0]
                          +p[-1][CorrectionBitmap.Width-1].rgbtRed*nM[-1,1]
                          +p[-1][CorrectionBitmap.Width-1].rgbtRed*nM[-1,2]

                          +p[0][CorrectionBitmap.Width-3].rgbtRed*nM[0,-2]
                          +p[0][CorrectionBitmap.Width-2].rgbtRed*nM[0,-1]
                          +p[0][CorrectionBitmap.Width-1].rgbtRed*nM[0,0]
                          +p[0][CorrectionBitmap.Width-1].rgbtRed*nM[0,1]
                          +p[0][CorrectionBitmap.Width-1].rgbtRed*nM[0,2]

                          +p[1][CorrectionBitmap.Width-3].rgbtRed*nM[1,-2]
                          +p[1][CorrectionBitmap.Width-2].rgbtRed*nM[1,-1]
                          +p[1][CorrectionBitmap.Width-1].rgbtRed*nM[1,0]
                          +p[1][CorrectionBitmap.Width-1].rgbtRed*nM[1,1]
                          +p[1][CorrectionBitmap.Width-1].rgbtRed*nM[1,2]

                          +p[2][CorrectionBitmap.Width-3].rgbtRed*nM[2,-2]
                          +p[2][CorrectionBitmap.Width-2].rgbtRed*nM[2,-1]
                          +p[2][CorrectionBitmap.Width-1].rgbtRed*nM[2,0]
                          +p[2][CorrectionBitmap.Width-1].rgbtRed*nM[2,1]
                          +p[2][CorrectionBitmap.Width-1].rgbtRed*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[CorrectionBitmap.Width-2].rgbtBlue:=rnd((p[-2][CorrectionBitmap.Width-4].rgbtBlue*nM[-2,-2]
                          +p[-2][CorrectionBitmap.Width-3].rgbtBlue*nM[-2,-1]
                          +p[-2][CorrectionBitmap.Width-2].rgbtBlue*nM[-2,0]
                          +p[-2][CorrectionBitmap.Width-1].rgbtBlue*nM[-2,1]
                          +p[-2][CorrectionBitmap.Width-1].rgbtBlue*nM[-2,2]

                          +p[-1][CorrectionBitmap.Width-4].rgbtBlue*nM[-1,-2]
                          +p[-1][CorrectionBitmap.Width-3].rgbtBlue*nM[-1,-1]
                          +p[-1][CorrectionBitmap.Width-2].rgbtBlue*nM[-1,0]
                          +p[-1][CorrectionBitmap.Width-1].rgbtBlue*nM[-1,1]
                          +p[-1][CorrectionBitmap.Width-1].rgbtBlue*nM[-1,2]

                          +p[0][CorrectionBitmap.Width-4].rgbtBlue*nM[0,-2]
                          +p[0][CorrectionBitmap.Width-3].rgbtBlue*nM[0,-1]
                          +p[0][CorrectionBitmap.Width-2].rgbtBlue*nM[0,0]
                          +p[0][CorrectionBitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[0][CorrectionBitmap.Width-1].rgbtBlue*nM[0,2]

                          +p[1][CorrectionBitmap.Width-4].rgbtBlue*nM[1,-2]
                          +p[1][CorrectionBitmap.Width-3].rgbtBlue*nM[1,-1]
                          +p[1][CorrectionBitmap.Width-2].rgbtBlue*nM[1,0]
                          +p[1][CorrectionBitmap.Width-1].rgbtBlue*nM[1,1]
                          +p[1][CorrectionBitmap.Width-1].rgbtBlue*nM[1,2]

                          +p[2][CorrectionBitmap.Width-4].rgbtBlue*nM[2,-2]
                          +p[2][CorrectionBitmap.Width-3].rgbtBlue*nM[2,-1]
                          +p[2][CorrectionBitmap.Width-2].rgbtBlue*nM[2,0]
                          +p[2][CorrectionBitmap.Width-1].rgbtBlue*nM[2,1]
                          +p[2][CorrectionBitmap.Width-1].rgbtBlue*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[CorrectionBitmap.Width-2].rgbtGreen:=rnd((p[-2][CorrectionBitmap.Width-4].rgbtGreen*nM[-2,-2]
                          +p[-2][CorrectionBitmap.Width-3].rgbtGreen*nM[-2,-1]
                          +p[-2][CorrectionBitmap.Width-2].rgbtGreen*nM[-2,0]
                          +p[-2][CorrectionBitmap.Width-1].rgbtGreen*nM[-2,1]
                          +p[-2][CorrectionBitmap.Width-1].rgbtGreen*nM[-2,2]

                          +p[-1][CorrectionBitmap.Width-4].rgbtGreen*nM[-1,-2]
                          +p[-1][CorrectionBitmap.Width-3].rgbtGreen*nM[-1,-1]
                          +p[-1][CorrectionBitmap.Width-2].rgbtGreen*nM[-1,0]
                          +p[-1][CorrectionBitmap.Width-1].rgbtGreen*nM[-1,1]
                          +p[-1][CorrectionBitmap.Width-1].rgbtGreen*nM[-1,2]

                          +p[0][CorrectionBitmap.Width-4].rgbtGreen*nM[0,-2]
                          +p[0][CorrectionBitmap.Width-3].rgbtGreen*nM[0,-1]
                          +p[0][CorrectionBitmap.Width-2].rgbtGreen*nM[0,0]
                          +p[0][CorrectionBitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[0][CorrectionBitmap.Width-1].rgbtGreen*nM[0,2]

                          +p[1][CorrectionBitmap.Width-4].rgbtGreen*nM[1,-2]
                          +p[1][CorrectionBitmap.Width-3].rgbtGreen*nM[1,-1]
                          +p[1][CorrectionBitmap.Width-2].rgbtGreen*nM[1,0]
                          +p[1][CorrectionBitmap.Width-1].rgbtGreen*nM[1,1]
                          +p[1][CorrectionBitmap.Width-1].rgbtGreen*nM[1,2]

                          +p[2][CorrectionBitmap.Width-4].rgbtGreen*nM[2,-2]
                          +p[2][CorrectionBitmap.Width-3].rgbtGreen*nM[2,-1]
                          +p[2][CorrectionBitmap.Width-2].rgbtGreen*nM[2,0]
                          +p[2][CorrectionBitmap.Width-1].rgbtGreen*nM[2,1]
                          +p[2][CorrectionBitmap.Width-1].rgbtGreen*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[CorrectionBitmap.Width-2].rgbtRed:=rnd((p[-2][CorrectionBitmap.Width-4].rgbtRed*nM[-2,-2]
                          +p[-2][CorrectionBitmap.Width-3].rgbtRed*nM[-2,-1]
                          +p[-2][CorrectionBitmap.Width-2].rgbtRed*nM[-2,0]
                          +p[-2][CorrectionBitmap.Width-1].rgbtRed*nM[-2,1]
                          +p[-2][CorrectionBitmap.Width-1].rgbtRed*nM[-2,2]

                          +p[-1][CorrectionBitmap.Width-4].rgbtRed*nM[-1,-2]
                          +p[-1][CorrectionBitmap.Width-3].rgbtRed*nM[-1,-1]
                          +p[-1][CorrectionBitmap.Width-2].rgbtRed*nM[-1,0]
                          +p[-1][CorrectionBitmap.Width-1].rgbtRed*nM[-1,1]
                          +p[-1][CorrectionBitmap.Width-1].rgbtRed*nM[-1,2]

                          +p[0][CorrectionBitmap.Width-4].rgbtRed*nM[0,-2]
                          +p[0][CorrectionBitmap.Width-3].rgbtRed*nM[0,-1]
                          +p[0][CorrectionBitmap.Width-2].rgbtRed*nM[0,0]
                          +p[0][CorrectionBitmap.Width-1].rgbtRed*nM[0,1]
                          +p[0][CorrectionBitmap.Width-1].rgbtRed*nM[0,2]

                          +p[1][CorrectionBitmap.Width-4].rgbtRed*nM[1,-2]
                          +p[1][CorrectionBitmap.Width-3].rgbtRed*nM[1,-1]
                          +p[1][CorrectionBitmap.Width-2].rgbtRed*nM[1,0]
                          +p[1][CorrectionBitmap.Width-1].rgbtRed*nM[1,1]
                          +p[1][CorrectionBitmap.Width-1].rgbtRed*nM[1,2]

                          +p[2][CorrectionBitmap.Width-4].rgbtRed*nM[2,-2]
                          +p[2][CorrectionBitmap.Width-3].rgbtRed*nM[2,-1]
                          +p[2][CorrectionBitmap.Width-2].rgbtRed*nM[2,0]
                          +p[2][CorrectionBitmap.Width-1].rgbtRed*nM[2,1]
                          +p[2][CorrectionBitmap.Width-1].rgbtRed*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
    for j:=CorrectionBitmap.Width-3 downto 2 do
    begin
      pp[j].rgbtBlue:=rnd((p[-2][j-2].rgbtBlue*nM[-2,-2]
                          +p[-2][j-1].rgbtBlue*nM[-2,-1]
                          +p[-2][j].rgbtBlue*nM[-2,0]
                          +p[-2][j+1].rgbtBlue*nM[-2,1]
                          +p[-2][j+2].rgbtBlue*nM[-2,2]

                          +p[-1][j-2].rgbtBlue*nM[-1,-2]
                          +p[-1][j-1].rgbtBlue*nM[-1,-1]
                          +p[-1][j].rgbtBlue*nM[-1,0]
                          +p[-1][j+1].rgbtBlue*nM[-1,1]
                          +p[-1][j+2].rgbtBlue*nM[-1,2]

                          +p[0][j-2].rgbtBlue*nM[0,-2]
                          +p[0][j-1].rgbtBlue*nM[0,-1]
                          +p[0][j].rgbtBlue*nM[0,0]
                          +p[0][j+1].rgbtBlue*nM[0,1]
                          +p[0][j+2].rgbtBlue*nM[0,2]

                          +p[1][j-2].rgbtBlue*nM[1,-2]
                          +p[1][j-1].rgbtBlue*nM[1,-1]
                          +p[1][j].rgbtBlue*nM[1,0]
                          +p[1][j+1].rgbtBlue*nM[1,1]
                          +p[1][j+2].rgbtBlue*nM[1,2]

                          +p[2][j-2].rgbtBlue*nM[2,-2]
                          +p[2][j-1].rgbtBlue*nM[2,-1]
                          +p[2][j].rgbtBlue*nM[2,0]
                          +p[2][j+1].rgbtBlue*nM[2,1]
                          +p[2][j+2].rgbtBlue*nM[2,2])
                          /nM[3,-1]+nM[3,0]);
      pp[j].rgbtGreen:=rnd((p[-2][j-2].rgbtGreen*nM[-2,-2]
                          +p[-2][j-1].rgbtGreen*nM[-2,-1]
                          +p[-2][j].rgbtGreen*nM[-2,0]
                          +p[-2][j+1].rgbtGreen*nM[-2,1]
                          +p[-2][j+2].rgbtGreen*nM[-2,2]

                          +p[-1][j-2].rgbtGreen*nM[-1,-2]
                          +p[-1][j-1].rgbtGreen*nM[-1,-1]
                          +p[-1][j].rgbtGreen*nM[-1,0]
                          +p[-1][j+1].rgbtGreen*nM[-1,1]
                          +p[-1][j+2].rgbtGreen*nM[-1,2]

                          +p[0][j-2].rgbtGreen*nM[0,-2]
                          +p[0][j-1].rgbtGreen*nM[0,-1]
                          +p[0][j].rgbtGreen*nM[0,0]
                          +p[0][j+1].rgbtGreen*nM[0,1]
                          +p[0][j+2].rgbtGreen*nM[0,2]

                          +p[1][j-2].rgbtGreen*nM[1,-2]
                          +p[1][j-1].rgbtGreen*nM[1,-1]
                          +p[1][j].rgbtGreen*nM[1,0]
                          +p[1][j+1].rgbtGreen*nM[1,1]
                          +p[1][j+2].rgbtGreen*nM[1,2]

                          +p[2][j-2].rgbtGreen*nM[2,-2]
                          +p[2][j-1].rgbtGreen*nM[2,-1]
                          +p[2][j].rgbtGreen*nM[2,0]
                          +p[2][j+1].rgbtGreen*nM[2,1]
                          +p[2][j+2].rgbtGreen*nM[2,2])
                          /nM[3,-1]+nm[3,0]);
      pp[j].rgbtRed:=rnd((p[-2][j-2].rgbtRed*nM[-2,-2]
                          +p[-2][j-1].rgbtRed*nM[-2,-1]
                          +p[-2][j].rgbtRed*nM[-2,0]
                          +p[-2][j+1].rgbtRed*nM[-2,1]
                          +p[-2][j+2].rgbtRed*nM[-2,2]

                          +p[-1][j-2].rgbtRed*nM[-1,-2]
                          +p[-1][j-1].rgbtRed*nM[-1,-1]
                          +p[-1][j].rgbtRed*nM[-1,0]
                          +p[-1][j+1].rgbtRed*nM[-1,1]
                          +p[-1][j+2].rgbtRed*nM[-1,2]

                          +p[0][j-2].rgbtRed*nM[0,-2]
                          +p[0][j-1].rgbtRed*nM[0,-1]
                          +p[0][j].rgbtRed*nM[0,0]
                          +p[0][j+1].rgbtRed*nM[0,1]
                          +p[0][j+2].rgbtRed*nM[0,2]

                          +p[1][j-2].rgbtRed*nM[1,-2]
                          +p[1][j-1].rgbtRed*nM[1,-1]
                          +p[1][j].rgbtRed*nM[1,0]
                          +p[1][j+1].rgbtRed*nM[1,1]
                          +p[1][j+2].rgbtRed*nM[1,2]

                          +p[2][j-2].rgbtRed*nM[2,-2]
                          +p[2][j-1].rgbtRed*nM[2,-1]
                          +p[2][j].rgbtRed*nM[2,0]
                          +p[2][j+1].rgbtRed*nM[2,1]
                          +p[2][j+2].rgbtRed*nM[2,2])
                          /nM[3,-1]+nm[3,0]);
    end;
  end;
  finally
    imgg.Picture.Assign(CorrectionBitmap);
    CorrectionBitmap.Free;
  end;
end;

procedure FilterMatrix77(nM:Matrix77);
var
  i,j:integer;
begin
  if nM[4,-1]=0 then
    nm[4,-1]:=1;
  CorrectionBitmap:=TBitmap.Create;
  try
  CorrectionBitmap.Assign(img.Picture);
  for i:=CorrectionBitmap.Height-1 downto 0 do
  begin
    p[-3]:=img.Picture.Bitmap.ScanLine[rnd3i(i-3)];
    p[-2]:=img.Picture.Bitmap.ScanLine[rnd3i(i-2)];
    p[-1]:=img.Picture.Bitmap.ScanLine[rnd3i(i-1)];
    p[0] :=img.Picture.Bitmap.ScanLine[i];
    p[1] :=img.Picture.Bitmap.ScanLine[rnd3i(i+1)];
    p[2] :=img.Picture.Bitmap.ScanLine[rnd3i(i+2)];
    p[3] :=img.Picture.Bitmap.ScanLine[rnd3i(i+3)];
    pp   :=CorrectionBitmap.ScanLine[i];
      pp[0].rgbtBlue:=rnd((p[-3][0].rgbtBlue*nM[0,-3]
                          +p[-3][0].rgbtBlue*nM[0,-2]
                          +p[-3][0].rgbtBlue*nM[0,-1]
                          +p[-3][0].rgbtBlue*nM[0,0]
                          +p[-3][1].rgbtBlue*nM[0,1]
                          +p[-3][2].rgbtBlue*nM[0,2]
                          +p[-3][3].rgbtBlue*nM[0,3]

                          +p[-2][0].rgbtBlue*nM[0,-3]
                          +p[-2][0].rgbtBlue*nM[0,-2]
                          +p[-2][0].rgbtBlue*nM[0,-1]
                          +p[-2][0].rgbtBlue*nM[0,0]
                          +p[-2][1].rgbtBlue*nM[0,1]
                          +p[-2][2].rgbtBlue*nM[0,2]
                          +p[-2][3].rgbtBlue*nM[0,3]

                          +p[-1][0].rgbtBlue*nM[0,-3]
                          +p[-1][0].rgbtBlue*nM[0,-2]
                          +p[-1][0].rgbtBlue*nM[0,-1]
                          +p[-1][0].rgbtBlue*nM[0,0]
                          +p[-1][1].rgbtBlue*nM[0,1]
                          +p[-1][2].rgbtBlue*nM[0,2]
                          +p[-1][3].rgbtBlue*nM[0,3]

                          +p[0][0].rgbtBlue*nM[0,-3]
                          +p[0][0].rgbtBlue*nM[0,-2]
                          +p[0][0].rgbtBlue*nM[0,-1]
                          +p[0][0].rgbtBlue*nM[0,0]
                          +p[0][1].rgbtBlue*nM[0,1]
                          +p[0][2].rgbtBlue*nM[0,2]
                          +p[0][3].rgbtBlue*nM[0,3]

                          +p[1][0].rgbtBlue*nM[0,-3]
                          +p[1][0].rgbtBlue*nM[0,-2]
                          +p[1][0].rgbtBlue*nM[0,-1]
                          +p[1][0].rgbtBlue*nM[0,0]
                          +p[1][1].rgbtBlue*nM[0,1]
                          +p[1][2].rgbtBlue*nM[0,2]
                          +p[1][3].rgbtBlue*nM[0,3]

                          +p[2][0].rgbtBlue*nM[0,-3]
                          +p[2][0].rgbtBlue*nM[0,-2]
                          +p[2][0].rgbtBlue*nM[0,-1]
                          +p[2][0].rgbtBlue*nM[0,0]
                          +p[2][1].rgbtBlue*nM[0,1]
                          +p[2][2].rgbtBlue*nM[0,2]
                          +p[2][3].rgbtBlue*nM[0,3]

                          +p[3][0].rgbtBlue*nM[0,-3]
                          +p[3][0].rgbtBlue*nM[0,-2]
                          +p[3][0].rgbtBlue*nM[0,-1]
                          +p[3][0].rgbtBlue*nM[0,0]
                          +p[3][1].rgbtBlue*nM[0,1]
                          +p[3][2].rgbtBlue*nM[0,2]
                          +p[3][3].rgbtBlue*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[0].rgbtGreen:=rnd((p[-3][0].rgbtGreen*nM[0,-3]
                          +p[-3][0].rgbtGreen*nM[0,-2]
                          +p[-3][0].rgbtGreen*nM[0,-1]
                          +p[-3][0].rgbtGreen*nM[0,0]
                          +p[-3][1].rgbtGreen*nM[0,1]
                          +p[-3][2].rgbtGreen*nM[0,2]
                          +p[-3][3].rgbtGreen*nM[0,3]

                          +p[-2][0].rgbtGreen*nM[0,-3]
                          +p[-2][0].rgbtGreen*nM[0,-2]
                          +p[-2][0].rgbtGreen*nM[0,-1]
                          +p[-2][0].rgbtGreen*nM[0,0]
                          +p[-2][1].rgbtGreen*nM[0,1]
                          +p[-2][2].rgbtGreen*nM[0,2]
                          +p[-2][3].rgbtGreen*nM[0,3]

                          +p[-1][0].rgbtGreen*nM[0,-3]
                          +p[-1][0].rgbtGreen*nM[0,-2]
                          +p[-1][0].rgbtGreen*nM[0,-1]
                          +p[-1][0].rgbtGreen*nM[0,0]
                          +p[-1][1].rgbtGreen*nM[0,1]
                          +p[-1][2].rgbtGreen*nM[0,2]
                          +p[-1][3].rgbtGreen*nM[0,3]

                          +p[0][0].rgbtGreen*nM[0,-3]
                          +p[0][0].rgbtGreen*nM[0,-2]
                          +p[0][0].rgbtGreen*nM[0,-1]
                          +p[0][0].rgbtGreen*nM[0,0]
                          +p[0][1].rgbtGreen*nM[0,1]
                          +p[0][2].rgbtGreen*nM[0,2]
                          +p[0][3].rgbtGreen*nM[0,3]

                          +p[1][0].rgbtGreen*nM[0,-3]
                          +p[1][0].rgbtGreen*nM[0,-2]
                          +p[1][0].rgbtGreen*nM[0,-1]
                          +p[1][0].rgbtGreen*nM[0,0]
                          +p[1][1].rgbtGreen*nM[0,1]
                          +p[1][2].rgbtGreen*nM[0,2]
                          +p[1][3].rgbtGreen*nM[0,3]

                          +p[2][0].rgbtGreen*nM[0,-3]
                          +p[2][0].rgbtGreen*nM[0,-2]
                          +p[2][0].rgbtGreen*nM[0,-1]
                          +p[2][0].rgbtGreen*nM[0,0]
                          +p[2][1].rgbtGreen*nM[0,1]
                          +p[2][2].rgbtGreen*nM[0,2]
                          +p[2][3].rgbtGreen*nM[0,3]

                          +p[3][0].rgbtGreen*nM[0,-3]
                          +p[3][0].rgbtGreen*nM[0,-2]
                          +p[3][0].rgbtGreen*nM[0,-1]
                          +p[3][0].rgbtGreen*nM[0,0]
                          +p[3][1].rgbtGreen*nM[0,1]
                          +p[3][2].rgbtGreen*nM[0,2]
                          +p[3][3].rgbtGreen*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[0].rgbtRed:=rnd((p[-3][0].rgbtRed*nM[0,-3]
                          +p[-3][0].rgbtRed*nM[0,-2]
                          +p[-3][0].rgbtRed*nM[0,-1]
                          +p[-3][0].rgbtRed*nM[0,0]
                          +p[-3][1].rgbtRed*nM[0,1]
                          +p[-3][2].rgbtRed*nM[0,2]
                          +p[-3][3].rgbtRed*nM[0,3]

                          +p[-2][0].rgbtRed*nM[0,-3]
                          +p[-2][0].rgbtRed*nM[0,-2]
                          +p[-2][0].rgbtRed*nM[0,-1]
                          +p[-2][0].rgbtRed*nM[0,0]
                          +p[-2][1].rgbtRed*nM[0,1]
                          +p[-2][2].rgbtRed*nM[0,2]
                          +p[-2][3].rgbtRed*nM[0,3]

                          +p[-1][0].rgbtRed*nM[0,-3]
                          +p[-1][0].rgbtRed*nM[0,-2]
                          +p[-1][0].rgbtRed*nM[0,-1]
                          +p[-1][0].rgbtRed*nM[0,0]
                          +p[-1][1].rgbtRed*nM[0,1]
                          +p[-1][2].rgbtRed*nM[0,2]
                          +p[-1][3].rgbtRed*nM[0,3]

                          +p[0][0].rgbtRed*nM[0,-3]
                          +p[0][0].rgbtRed*nM[0,-2]
                          +p[0][0].rgbtRed*nM[0,-1]
                          +p[0][0].rgbtRed*nM[0,0]
                          +p[0][1].rgbtRed*nM[0,1]
                          +p[0][2].rgbtRed*nM[0,2]
                          +p[0][3].rgbtRed*nM[0,3]

                          +p[1][0].rgbtRed*nM[0,-3]
                          +p[1][0].rgbtRed*nM[0,-2]
                          +p[1][0].rgbtRed*nM[0,-1]
                          +p[1][0].rgbtRed*nM[0,0]
                          +p[1][1].rgbtRed*nM[0,1]
                          +p[1][2].rgbtRed*nM[0,2]
                          +p[1][3].rgbtRed*nM[0,3]

                          +p[2][0].rgbtRed*nM[0,-3]
                          +p[2][0].rgbtRed*nM[0,-2]
                          +p[2][0].rgbtRed*nM[0,-1]
                          +p[2][0].rgbtRed*nM[0,0]
                          +p[2][1].rgbtRed*nM[0,1]
                          +p[2][2].rgbtRed*nM[0,2]
                          +p[2][3].rgbtRed*nM[0,3]

                          +p[3][0].rgbtRed*nM[0,-3]
                          +p[3][0].rgbtRed*nM[0,-2]
                          +p[3][0].rgbtRed*nM[0,-1]
                          +p[3][0].rgbtRed*nM[0,0]
                          +p[3][1].rgbtRed*nM[0,1]
                          +p[3][2].rgbtRed*nM[0,2]
                          +p[3][3].rgbtRed*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[1].rgbtBlue:=rnd((p[-3][0].rgbtBlue*nM[0,-3]
                          +p[-3][0].rgbtBlue*nM[0,-2]
                          +p[-3][0].rgbtBlue*nM[0,-1]
                          +p[-3][1].rgbtBlue*nM[0,0]
                          +p[-3][2].rgbtBlue*nM[0,1]
                          +p[-3][3].rgbtBlue*nM[0,2]
                          +p[-3][4].rgbtBlue*nM[0,3]

                          +p[-2][0].rgbtBlue*nM[0,-3]
                          +p[-2][0].rgbtBlue*nM[0,-2]
                          +p[-2][0].rgbtBlue*nM[0,-1]
                          +p[-2][1].rgbtBlue*nM[0,0]
                          +p[-2][2].rgbtBlue*nM[0,1]
                          +p[-2][3].rgbtBlue*nM[0,2]
                          +p[-2][4].rgbtBlue*nM[0,3]

                          +p[-1][0].rgbtBlue*nM[0,-3]
                          +p[-1][0].rgbtBlue*nM[0,-2]
                          +p[-1][0].rgbtBlue*nM[0,-1]
                          +p[-1][1].rgbtBlue*nM[0,0]
                          +p[-1][2].rgbtBlue*nM[0,1]
                          +p[-1][3].rgbtBlue*nM[0,2]
                          +p[-1][4].rgbtBlue*nM[0,3]

                          +p[0][0].rgbtBlue*nM[0,-3]
                          +p[0][0].rgbtBlue*nM[0,-2]
                          +p[0][0].rgbtBlue*nM[0,-1]
                          +p[0][1].rgbtBlue*nM[0,0]
                          +p[0][2].rgbtBlue*nM[0,1]
                          +p[0][3].rgbtBlue*nM[0,2]
                          +p[0][4].rgbtBlue*nM[0,3]

                          +p[1][0].rgbtBlue*nM[0,-3]
                          +p[1][0].rgbtBlue*nM[0,-2]
                          +p[1][0].rgbtBlue*nM[0,-1]
                          +p[1][1].rgbtBlue*nM[0,0]
                          +p[1][2].rgbtBlue*nM[0,1]
                          +p[1][3].rgbtBlue*nM[0,2]
                          +p[1][4].rgbtBlue*nM[0,3]

                          +p[2][0].rgbtBlue*nM[0,-3]
                          +p[2][0].rgbtBlue*nM[0,-2]
                          +p[2][0].rgbtBlue*nM[0,-1]
                          +p[2][1].rgbtBlue*nM[0,0]
                          +p[2][2].rgbtBlue*nM[0,1]
                          +p[2][3].rgbtBlue*nM[0,2]
                          +p[2][4].rgbtBlue*nM[0,3]

                          +p[3][0].rgbtBlue*nM[0,-3]
                          +p[3][0].rgbtBlue*nM[0,-2]
                          +p[3][0].rgbtBlue*nM[0,-1]
                          +p[3][1].rgbtBlue*nM[0,0]
                          +p[3][2].rgbtBlue*nM[0,1]
                          +p[3][3].rgbtBlue*nM[0,2]
                          +p[3][4].rgbtBlue*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[1].rgbtGreen:=rnd((p[-3][0].rgbtGreen*nM[0,-3]
                          +p[-3][0].rgbtGreen*nM[0,-2]
                          +p[-3][0].rgbtGreen*nM[0,-1]
                          +p[-3][1].rgbtGreen*nM[0,0]
                          +p[-3][2].rgbtGreen*nM[0,1]
                          +p[-3][3].rgbtGreen*nM[0,2]
                          +p[-3][4].rgbtGreen*nM[0,3]

                          +p[-2][0].rgbtGreen*nM[0,-3]
                          +p[-2][0].rgbtGreen*nM[0,-2]
                          +p[-2][0].rgbtGreen*nM[0,-1]
                          +p[-2][1].rgbtGreen*nM[0,0]
                          +p[-2][2].rgbtGreen*nM[0,1]
                          +p[-2][3].rgbtGreen*nM[0,2]
                          +p[-2][4].rgbtGreen*nM[0,3]

                          +p[-1][0].rgbtGreen*nM[0,-3]
                          +p[-1][0].rgbtGreen*nM[0,-2]
                          +p[-1][0].rgbtGreen*nM[0,-1]
                          +p[-1][1].rgbtGreen*nM[0,0]
                          +p[-1][2].rgbtGreen*nM[0,1]
                          +p[-1][3].rgbtGreen*nM[0,2]
                          +p[-1][4].rgbtGreen*nM[0,3]

                          +p[0][0].rgbtGreen*nM[0,-3]
                          +p[0][0].rgbtGreen*nM[0,-2]
                          +p[0][0].rgbtGreen*nM[0,-1]
                          +p[0][1].rgbtGreen*nM[0,0]
                          +p[0][2].rgbtGreen*nM[0,1]
                          +p[0][3].rgbtGreen*nM[0,2]
                          +p[0][4].rgbtGreen*nM[0,3]

                          +p[1][0].rgbtGreen*nM[0,-3]
                          +p[1][0].rgbtGreen*nM[0,-2]
                          +p[1][0].rgbtGreen*nM[0,-1]
                          +p[1][1].rgbtGreen*nM[0,0]
                          +p[1][2].rgbtGreen*nM[0,1]
                          +p[1][3].rgbtGreen*nM[0,2]
                          +p[1][4].rgbtGreen*nM[0,3]

                          +p[2][0].rgbtGreen*nM[0,-3]
                          +p[2][0].rgbtGreen*nM[0,-2]
                          +p[2][0].rgbtGreen*nM[0,-1]
                          +p[2][1].rgbtGreen*nM[0,0]
                          +p[2][2].rgbtGreen*nM[0,1]
                          +p[2][3].rgbtGreen*nM[0,2]
                          +p[2][4].rgbtGreen*nM[0,3]

                          +p[3][0].rgbtGreen*nM[0,-3]
                          +p[3][0].rgbtGreen*nM[0,-2]
                          +p[3][0].rgbtGreen*nM[0,-1]
                          +p[3][1].rgbtGreen*nM[0,0]
                          +p[3][2].rgbtGreen*nM[0,1]
                          +p[3][3].rgbtGreen*nM[0,2]
                          +p[3][4].rgbtGreen*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[1].rgbtRed:=rnd((p[-3][0].rgbtRed*nM[0,-3]
                          +p[-3][0].rgbtRed*nM[0,-2]
                          +p[-3][0].rgbtRed*nM[0,-1]
                          +p[-3][1].rgbtRed*nM[0,0]
                          +p[-3][2].rgbtRed*nM[0,1]
                          +p[-3][3].rgbtRed*nM[0,2]
                          +p[-3][4].rgbtRed*nM[0,3]

                          +p[-2][0].rgbtRed*nM[0,-3]
                          +p[-2][0].rgbtRed*nM[0,-2]
                          +p[-2][0].rgbtRed*nM[0,-1]
                          +p[-2][1].rgbtRed*nM[0,0]
                          +p[-2][2].rgbtRed*nM[0,1]
                          +p[-2][3].rgbtRed*nM[0,2]
                          +p[-2][4].rgbtRed*nM[0,3]

                          +p[-1][0].rgbtRed*nM[0,-3]
                          +p[-1][0].rgbtRed*nM[0,-2]
                          +p[-1][0].rgbtRed*nM[0,-1]
                          +p[-1][1].rgbtRed*nM[0,0]
                          +p[-1][2].rgbtRed*nM[0,1]
                          +p[-1][3].rgbtRed*nM[0,2]
                          +p[-1][4].rgbtRed*nM[0,3]

                          +p[0][0].rgbtRed*nM[0,-3]
                          +p[0][0].rgbtRed*nM[0,-2]
                          +p[0][0].rgbtRed*nM[0,-1]
                          +p[0][1].rgbtRed*nM[0,0]
                          +p[0][2].rgbtRed*nM[0,1]
                          +p[0][3].rgbtRed*nM[0,2]
                          +p[0][4].rgbtRed*nM[0,3]

                          +p[1][0].rgbtRed*nM[0,-3]
                          +p[1][0].rgbtRed*nM[0,-2]
                          +p[1][0].rgbtRed*nM[0,-1]
                          +p[1][1].rgbtRed*nM[0,0]
                          +p[1][2].rgbtRed*nM[0,1]
                          +p[1][3].rgbtRed*nM[0,2]
                          +p[1][4].rgbtRed*nM[0,3]

                          +p[2][0].rgbtRed*nM[0,-3]
                          +p[2][0].rgbtRed*nM[0,-2]
                          +p[2][0].rgbtRed*nM[0,-1]
                          +p[2][1].rgbtRed*nM[0,0]
                          +p[2][2].rgbtRed*nM[0,1]
                          +p[2][3].rgbtRed*nM[0,2]
                          +p[2][4].rgbtRed*nM[0,3]

                          +p[3][0].rgbtRed*nM[0,-3]
                          +p[3][0].rgbtRed*nM[0,-2]
                          +p[3][0].rgbtRed*nM[0,-1]
                          +p[3][1].rgbtRed*nM[0,0]
                          +p[3][2].rgbtRed*nM[0,1]
                          +p[3][3].rgbtRed*nM[0,2]
                          +p[3][4].rgbtRed*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[2].rgbtBlue:=rnd((p[-3][0].rgbtBlue*nM[0,-3]
                          +p[-3][0].rgbtBlue*nM[0,-2]
                          +p[-3][1].rgbtBlue*nM[0,-1]
                          +p[-3][2].rgbtBlue*nM[0,0]
                          +p[-3][3].rgbtBlue*nM[0,1]
                          +p[-3][4].rgbtBlue*nM[0,2]
                          +p[-3][5].rgbtBlue*nM[0,3]

                          +p[-2][0].rgbtBlue*nM[0,-3]
                          +p[-2][0].rgbtBlue*nM[0,-2]
                          +p[-2][1].rgbtBlue*nM[0,-1]
                          +p[-2][2].rgbtBlue*nM[0,0]
                          +p[-2][3].rgbtBlue*nM[0,1]
                          +p[-2][4].rgbtBlue*nM[0,2]
                          +p[-2][5].rgbtBlue*nM[0,3]

                          +p[-1][0].rgbtBlue*nM[0,-3]
                          +p[-1][0].rgbtBlue*nM[0,-2]
                          +p[-1][1].rgbtBlue*nM[0,-1]
                          +p[-1][2].rgbtBlue*nM[0,0]
                          +p[-1][3].rgbtBlue*nM[0,1]
                          +p[-1][4].rgbtBlue*nM[0,2]
                          +p[-1][5].rgbtBlue*nM[0,3]

                          +p[0][0].rgbtBlue*nM[0,-3]
                          +p[0][0].rgbtBlue*nM[0,-2]
                          +p[0][1].rgbtBlue*nM[0,-1]
                          +p[0][2].rgbtBlue*nM[0,0]
                          +p[0][3].rgbtBlue*nM[0,1]
                          +p[0][4].rgbtBlue*nM[0,2]
                          +p[0][5].rgbtBlue*nM[0,3]

                          +p[1][0].rgbtBlue*nM[0,-3]
                          +p[1][0].rgbtBlue*nM[0,-2]
                          +p[1][1].rgbtBlue*nM[0,-1]
                          +p[1][2].rgbtBlue*nM[0,0]
                          +p[1][3].rgbtBlue*nM[0,1]
                          +p[1][4].rgbtBlue*nM[0,2]
                          +p[1][5].rgbtBlue*nM[0,3]

                          +p[2][0].rgbtBlue*nM[0,-3]
                          +p[2][0].rgbtBlue*nM[0,-2]
                          +p[2][1].rgbtBlue*nM[0,-1]
                          +p[2][2].rgbtBlue*nM[0,0]
                          +p[2][3].rgbtBlue*nM[0,1]
                          +p[2][4].rgbtBlue*nM[0,2]
                          +p[2][5].rgbtBlue*nM[0,3]

                          +p[3][0].rgbtBlue*nM[0,-3]
                          +p[3][0].rgbtBlue*nM[0,-2]
                          +p[3][1].rgbtBlue*nM[0,-1]
                          +p[3][2].rgbtBlue*nM[0,0]
                          +p[3][3].rgbtBlue*nM[0,1]
                          +p[3][4].rgbtBlue*nM[0,2]
                          +p[3][5].rgbtBlue*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[2].rgbtGreen:=rnd((p[-3][0].rgbtGreen*nM[0,-3]
                          +p[-3][0].rgbtGreen*nM[0,-2]
                          +p[-3][1].rgbtGreen*nM[0,-1]
                          +p[-3][2].rgbtGreen*nM[0,0]
                          +p[-3][3].rgbtGreen*nM[0,1]
                          +p[-3][4].rgbtGreen*nM[0,2]
                          +p[-3][5].rgbtGreen*nM[0,3]

                          +p[-2][0].rgbtGreen*nM[0,-3]
                          +p[-2][0].rgbtGreen*nM[0,-2]
                          +p[-2][1].rgbtGreen*nM[0,-1]
                          +p[-2][2].rgbtGreen*nM[0,0]
                          +p[-2][3].rgbtGreen*nM[0,1]
                          +p[-2][4].rgbtGreen*nM[0,2]
                          +p[-2][5].rgbtGreen*nM[0,3]

                          +p[-1][0].rgbtGreen*nM[0,-3]
                          +p[-1][0].rgbtGreen*nM[0,-2]
                          +p[-1][1].rgbtGreen*nM[0,-1]
                          +p[-1][2].rgbtGreen*nM[0,0]
                          +p[-1][3].rgbtGreen*nM[0,1]
                          +p[-1][4].rgbtGreen*nM[0,2]
                          +p[-1][5].rgbtGreen*nM[0,3]

                          +p[0][0].rgbtGreen*nM[0,-3]
                          +p[0][0].rgbtGreen*nM[0,-2]
                          +p[0][1].rgbtGreen*nM[0,-1]
                          +p[0][2].rgbtGreen*nM[0,0]
                          +p[0][3].rgbtGreen*nM[0,1]
                          +p[0][4].rgbtGreen*nM[0,2]
                          +p[0][5].rgbtGreen*nM[0,3]

                          +p[1][0].rgbtGreen*nM[0,-3]
                          +p[1][0].rgbtGreen*nM[0,-2]
                          +p[1][1].rgbtGreen*nM[0,-1]
                          +p[1][2].rgbtGreen*nM[0,0]
                          +p[1][3].rgbtGreen*nM[0,1]
                          +p[1][4].rgbtGreen*nM[0,2]
                          +p[1][5].rgbtGreen*nM[0,3]

                          +p[2][0].rgbtGreen*nM[0,-3]
                          +p[2][0].rgbtGreen*nM[0,-2]
                          +p[2][1].rgbtGreen*nM[0,-1]
                          +p[2][2].rgbtGreen*nM[0,0]
                          +p[2][3].rgbtGreen*nM[0,1]
                          +p[2][4].rgbtGreen*nM[0,2]
                          +p[2][5].rgbtGreen*nM[0,3]

                          +p[3][0].rgbtGreen*nM[0,-3]
                          +p[3][0].rgbtGreen*nM[0,-2]
                          +p[3][1].rgbtGreen*nM[0,-1]
                          +p[3][2].rgbtGreen*nM[0,0]
                          +p[3][3].rgbtGreen*nM[0,1]
                          +p[3][4].rgbtGreen*nM[0,2]
                          +p[3][5].rgbtGreen*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[2].rgbtRed:=rnd((p[-3][0].rgbtRed*nM[0,-3]
                          +p[-3][0].rgbtRed*nM[0,-2]
                          +p[-3][1].rgbtRed*nM[0,-1]
                          +p[-3][2].rgbtRed*nM[0,0]
                          +p[-3][3].rgbtRed*nM[0,1]
                          +p[-3][4].rgbtRed*nM[0,2]
                          +p[-3][5].rgbtRed*nM[0,3]

                          +p[-2][0].rgbtRed*nM[0,-3]
                          +p[-2][0].rgbtRed*nM[0,-2]
                          +p[-2][1].rgbtRed*nM[0,-1]
                          +p[-2][2].rgbtRed*nM[0,0]
                          +p[-2][3].rgbtRed*nM[0,1]
                          +p[-2][4].rgbtRed*nM[0,2]
                          +p[-2][5].rgbtRed*nM[0,3]

                          +p[-1][0].rgbtRed*nM[0,-3]
                          +p[-1][0].rgbtRed*nM[0,-2]
                          +p[-1][1].rgbtRed*nM[0,-1]
                          +p[-1][2].rgbtRed*nM[0,0]
                          +p[-1][3].rgbtRed*nM[0,1]
                          +p[-1][4].rgbtRed*nM[0,2]
                          +p[-1][5].rgbtRed*nM[0,3]

                          +p[0][0].rgbtRed*nM[0,-3]
                          +p[0][0].rgbtRed*nM[0,-2]
                          +p[0][1].rgbtRed*nM[0,-1]
                          +p[0][2].rgbtRed*nM[0,0]
                          +p[0][3].rgbtRed*nM[0,1]
                          +p[0][4].rgbtRed*nM[0,2]
                          +p[0][5].rgbtRed*nM[0,3]

                          +p[1][0].rgbtRed*nM[0,-3]
                          +p[1][0].rgbtRed*nM[0,-2]
                          +p[1][1].rgbtRed*nM[0,-1]
                          +p[1][2].rgbtRed*nM[0,0]
                          +p[1][3].rgbtRed*nM[0,1]
                          +p[1][4].rgbtRed*nM[0,2]
                          +p[1][5].rgbtRed*nM[0,3]

                          +p[2][0].rgbtRed*nM[0,-3]
                          +p[2][0].rgbtRed*nM[0,-2]
                          +p[2][1].rgbtRed*nM[0,-1]
                          +p[2][2].rgbtRed*nM[0,0]
                          +p[2][3].rgbtRed*nM[0,1]
                          +p[2][4].rgbtRed*nM[0,2]
                          +p[2][5].rgbtRed*nM[0,3]

                          +p[3][0].rgbtRed*nM[0,-3]
                          +p[3][0].rgbtRed*nM[0,-2]
                          +p[3][1].rgbtRed*nM[0,-1]
                          +p[3][2].rgbtRed*nM[0,0]
                          +p[3][3].rgbtRed*nM[0,1]
                          +p[3][4].rgbtRed*nM[0,2]
                          +p[3][5].rgbtRed*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
//
      pp[correctionbitmap.Width-1].rgbtBlue:=rnd((p[-3][correctionbitmap.Width-4].rgbtBlue*nM[0,-3]
                          +p[-3][correctionbitmap.Width-3].rgbtBlue*nM[0,-2]
                          +p[-3][correctionbitmap.Width-2].rgbtBlue*nM[0,-1]
                          +p[-3][correctionbitmap.Width-1].rgbtBlue*nM[0,0]
                          +p[-3][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[-3][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[-3][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[-2][correctionbitmap.Width-4].rgbtBlue*nM[0,-3]
                          +p[-2][correctionbitmap.Width-3].rgbtBlue*nM[0,-2]
                          +p[-2][correctionbitmap.Width-2].rgbtBlue*nM[0,-1]
                          +p[-2][correctionbitmap.Width-1].rgbtBlue*nM[0,0]
                          +p[-2][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[-2][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[-2][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[-1][correctionbitmap.Width-4].rgbtBlue*nM[0,-3]
                          +p[-1][correctionbitmap.Width-3].rgbtBlue*nM[0,-2]
                          +p[-1][correctionbitmap.Width-2].rgbtBlue*nM[0,-1]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[0,0]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[0][correctionbitmap.Width-4].rgbtBlue*nM[0,-3]
                          +p[0][correctionbitmap.Width-3].rgbtBlue*nM[0,-2]
                          +p[0][correctionbitmap.Width-2].rgbtBlue*nM[0,-1]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,0]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[1][correctionbitmap.Width-4].rgbtBlue*nM[0,-3]
                          +p[1][correctionbitmap.Width-3].rgbtBlue*nM[0,-2]
                          +p[1][correctionbitmap.Width-2].rgbtBlue*nM[0,-1]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[0,0]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[2][correctionbitmap.Width-4].rgbtBlue*nM[0,-3]
                          +p[2][correctionbitmap.Width-3].rgbtBlue*nM[0,-2]
                          +p[2][correctionbitmap.Width-2].rgbtBlue*nM[0,-1]
                          +p[2][correctionbitmap.Width-1].rgbtBlue*nM[0,0]
                          +p[2][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[2][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[2][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[3][correctionbitmap.Width-4].rgbtBlue*nM[0,-3]
                          +p[3][correctionbitmap.Width-3].rgbtBlue*nM[0,-2]
                          +p[3][correctionbitmap.Width-2].rgbtBlue*nM[0,-1]
                          +p[3][correctionbitmap.Width-1].rgbtBlue*nM[0,0]
                          +p[3][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[3][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[3][correctionbitmap.Width-1].rgbtBlue*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[correctionbitmap.Width-1].rgbtGreen:=rnd((p[-3][correctionbitmap.Width-4].rgbtGreen*nM[0,-3]
                          +p[-3][correctionbitmap.Width-3].rgbtGreen*nM[0,-2]
                          +p[-3][correctionbitmap.Width-2].rgbtGreen*nM[0,-1]
                          +p[-3][correctionbitmap.Width-1].rgbtGreen*nM[0,0]
                          +p[-3][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[-3][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[-3][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[-2][correctionbitmap.Width-4].rgbtGreen*nM[0,-3]
                          +p[-2][correctionbitmap.Width-3].rgbtGreen*nM[0,-2]
                          +p[-2][correctionbitmap.Width-2].rgbtGreen*nM[0,-1]
                          +p[-2][correctionbitmap.Width-1].rgbtGreen*nM[0,0]
                          +p[-2][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[-2][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[-2][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[-1][correctionbitmap.Width-4].rgbtGreen*nM[0,-3]
                          +p[-1][correctionbitmap.Width-3].rgbtGreen*nM[0,-2]
                          +p[-1][correctionbitmap.Width-2].rgbtGreen*nM[0,-1]
                          +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[0,0]
                          +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[0][correctionbitmap.Width-4].rgbtGreen*nM[0,-3]
                          +p[0][correctionbitmap.Width-3].rgbtGreen*nM[0,-2]
                          +p[0][correctionbitmap.Width-2].rgbtGreen*nM[0,-1]
                          +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,0]
                          +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[1][correctionbitmap.Width-4].rgbtGreen*nM[0,-3]
                          +p[1][correctionbitmap.Width-3].rgbtGreen*nM[0,-2]
                          +p[1][correctionbitmap.Width-2].rgbtGreen*nM[0,-1]
                          +p[1][correctionbitmap.Width-1].rgbtGreen*nM[0,0]
                          +p[1][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[1][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[1][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[2][correctionbitmap.Width-4].rgbtGreen*nM[0,-3]
                          +p[2][correctionbitmap.Width-3].rgbtGreen*nM[0,-2]
                          +p[2][correctionbitmap.Width-2].rgbtGreen*nM[0,-1]
                          +p[2][correctionbitmap.Width-1].rgbtGreen*nM[0,0]
                          +p[2][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[2][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[2][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[3][correctionbitmap.Width-4].rgbtGreen*nM[0,-3]
                          +p[3][correctionbitmap.Width-3].rgbtGreen*nM[0,-2]
                          +p[3][correctionbitmap.Width-2].rgbtGreen*nM[0,-1]
                          +p[3][correctionbitmap.Width-1].rgbtGreen*nM[0,0]
                          +p[3][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[3][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[3][correctionbitmap.Width-1].rgbtGreen*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[correctionbitmap.Width-1].rgbtRed:=rnd((p[-3][correctionbitmap.Width-4].rgbtRed*nM[0,-3]
                          +p[-3][correctionbitmap.Width-3].rgbtRed*nM[0,-2]
                          +p[-3][correctionbitmap.Width-2].rgbtRed*nM[0,-1]
                          +p[-3][correctionbitmap.Width-1].rgbtRed*nM[0,0]
                          +p[-3][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[-3][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[-3][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[-2][correctionbitmap.Width-4].rgbtRed*nM[0,-3]
                          +p[-2][correctionbitmap.Width-3].rgbtRed*nM[0,-2]
                          +p[-2][correctionbitmap.Width-2].rgbtRed*nM[0,-1]
                          +p[-2][correctionbitmap.Width-1].rgbtRed*nM[0,0]
                          +p[-2][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[-2][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[-2][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[-1][correctionbitmap.Width-4].rgbtRed*nM[0,-3]
                          +p[-1][correctionbitmap.Width-3].rgbtRed*nM[0,-2]
                          +p[-1][correctionbitmap.Width-2].rgbtRed*nM[0,-1]
                          +p[-1][correctionbitmap.Width-1].rgbtRed*nM[0,0]
                          +p[-1][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[-1][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[-1][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[0][correctionbitmap.Width-4].rgbtRed*nM[0,-3]
                          +p[0][correctionbitmap.Width-3].rgbtRed*nM[0,-2]
                          +p[0][correctionbitmap.Width-2].rgbtRed*nM[0,-1]
                          +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,0]
                          +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[1][correctionbitmap.Width-4].rgbtRed*nM[0,-3]
                          +p[1][correctionbitmap.Width-3].rgbtRed*nM[0,-2]
                          +p[1][correctionbitmap.Width-2].rgbtRed*nM[0,-1]
                          +p[1][correctionbitmap.Width-1].rgbtRed*nM[0,0]
                          +p[1][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[1][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[1][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[2][correctionbitmap.Width-4].rgbtRed*nM[0,-3]
                          +p[2][correctionbitmap.Width-3].rgbtRed*nM[0,-2]
                          +p[2][correctionbitmap.Width-2].rgbtRed*nM[0,-1]
                          +p[2][correctionbitmap.Width-1].rgbtRed*nM[0,0]
                          +p[2][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[2][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[2][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[3][correctionbitmap.Width-4].rgbtRed*nM[0,-3]
                          +p[3][correctionbitmap.Width-3].rgbtRed*nM[0,-2]
                          +p[3][correctionbitmap.Width-2].rgbtRed*nM[0,-1]
                          +p[3][correctionbitmap.Width-1].rgbtRed*nM[0,0]
                          +p[3][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[3][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[3][correctionbitmap.Width-1].rgbtRed*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[correctionbitmap.Width-2].rgbtBlue:=rnd((p[-3][correctionbitmap.Width-5].rgbtBlue*nM[0,-3]
                          +p[-3][correctionbitmap.Width-4].rgbtBlue*nM[0,-2]
                          +p[-3][correctionbitmap.Width-3].rgbtBlue*nM[0,-1]
                          +p[-3][correctionbitmap.Width-2].rgbtBlue*nM[0,0]
                          +p[-3][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[-3][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[-3][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[-2][correctionbitmap.Width-5].rgbtBlue*nM[0,-3]
                          +p[-2][correctionbitmap.Width-4].rgbtBlue*nM[0,-2]
                          +p[-2][correctionbitmap.Width-3].rgbtBlue*nM[0,-1]
                          +p[-2][correctionbitmap.Width-2].rgbtBlue*nM[0,0]
                          +p[-2][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[-2][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[-2][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[-1][correctionbitmap.Width-5].rgbtBlue*nM[0,-3]
                          +p[-1][correctionbitmap.Width-4].rgbtBlue*nM[0,-2]
                          +p[-1][correctionbitmap.Width-3].rgbtBlue*nM[0,-1]
                          +p[-1][correctionbitmap.Width-2].rgbtBlue*nM[0,0]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[0][correctionbitmap.Width-5].rgbtBlue*nM[0,-3]
                          +p[0][correctionbitmap.Width-4].rgbtBlue*nM[0,-2]
                          +p[0][correctionbitmap.Width-3].rgbtBlue*nM[0,-1]
                          +p[0][correctionbitmap.Width-2].rgbtBlue*nM[0,0]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[1][correctionbitmap.Width-5].rgbtBlue*nM[0,-3]
                          +p[1][correctionbitmap.Width-4].rgbtBlue*nM[0,-2]
                          +p[1][correctionbitmap.Width-3].rgbtBlue*nM[0,-1]
                          +p[1][correctionbitmap.Width-2].rgbtBlue*nM[0,0]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[2][correctionbitmap.Width-5].rgbtBlue*nM[0,-3]
                          +p[2][correctionbitmap.Width-4].rgbtBlue*nM[0,-2]
                          +p[2][correctionbitmap.Width-3].rgbtBlue*nM[0,-1]
                          +p[2][correctionbitmap.Width-2].rgbtBlue*nM[0,0]
                          +p[2][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[2][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[2][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[3][correctionbitmap.Width-5].rgbtBlue*nM[0,-3]
                          +p[3][correctionbitmap.Width-4].rgbtBlue*nM[0,-2]
                          +p[3][correctionbitmap.Width-3].rgbtBlue*nM[0,-1]
                          +p[3][correctionbitmap.Width-2].rgbtBlue*nM[0,0]
                          +p[3][correctionbitmap.Width-1].rgbtBlue*nM[0,1]
                          +p[3][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[3][correctionbitmap.Width-1].rgbtBlue*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[correctionbitmap.Width-2].rgbtGreen:=rnd((p[-3][correctionbitmap.Width-5].rgbtGreen*nM[0,-3]
                          +p[-3][correctionbitmap.Width-4].rgbtGreen*nM[0,-2]
                          +p[-3][correctionbitmap.Width-3].rgbtGreen*nM[0,-1]
                          +p[-3][correctionbitmap.Width-2].rgbtGreen*nM[0,0]
                          +p[-3][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[-3][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[-3][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[-2][correctionbitmap.Width-5].rgbtGreen*nM[0,-3]
                          +p[-2][correctionbitmap.Width-4].rgbtGreen*nM[0,-2]
                          +p[-2][correctionbitmap.Width-3].rgbtGreen*nM[0,-1]
                          +p[-2][correctionbitmap.Width-2].rgbtGreen*nM[0,0]
                          +p[-2][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[-2][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[-2][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[-1][correctionbitmap.Width-5].rgbtGreen*nM[0,-3]
                          +p[-1][correctionbitmap.Width-4].rgbtGreen*nM[0,-2]
                          +p[-1][correctionbitmap.Width-3].rgbtGreen*nM[0,-1]
                          +p[-1][correctionbitmap.Width-2].rgbtGreen*nM[0,0]
                          +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[0][correctionbitmap.Width-5].rgbtGreen*nM[0,-3]
                          +p[0][correctionbitmap.Width-4].rgbtGreen*nM[0,-2]
                          +p[0][correctionbitmap.Width-3].rgbtGreen*nM[0,-1]
                          +p[0][correctionbitmap.Width-2].rgbtGreen*nM[0,0]
                          +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[1][correctionbitmap.Width-5].rgbtGreen*nM[0,-3]
                          +p[1][correctionbitmap.Width-4].rgbtGreen*nM[0,-2]
                          +p[1][correctionbitmap.Width-3].rgbtGreen*nM[0,-1]
                          +p[1][correctionbitmap.Width-2].rgbtGreen*nM[0,0]
                          +p[1][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[1][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[1][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[2][correctionbitmap.Width-5].rgbtGreen*nM[0,-3]
                          +p[2][correctionbitmap.Width-4].rgbtGreen*nM[0,-2]
                          +p[2][correctionbitmap.Width-3].rgbtGreen*nM[0,-1]
                          +p[2][correctionbitmap.Width-2].rgbtGreen*nM[0,0]
                          +p[2][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[2][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[2][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[3][correctionbitmap.Width-5].rgbtGreen*nM[0,-3]
                          +p[3][correctionbitmap.Width-4].rgbtGreen*nM[0,-2]
                          +p[3][correctionbitmap.Width-3].rgbtGreen*nM[0,-1]
                          +p[3][correctionbitmap.Width-2].rgbtGreen*nM[0,0]
                          +p[3][correctionbitmap.Width-1].rgbtGreen*nM[0,1]
                          +p[3][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[3][correctionbitmap.Width-1].rgbtGreen*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[correctionbitmap.Width-2].rgbtRed:=rnd((p[-3][correctionbitmap.Width-5].rgbtRed*nM[0,-3]
                          +p[-3][correctionbitmap.Width-4].rgbtRed*nM[0,-2]
                          +p[-3][correctionbitmap.Width-3].rgbtRed*nM[0,-1]
                          +p[-3][correctionbitmap.Width-2].rgbtRed*nM[0,0]
                          +p[-3][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[-3][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[-3][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[-2][correctionbitmap.Width-5].rgbtRed*nM[0,-3]
                          +p[-2][correctionbitmap.Width-4].rgbtRed*nM[0,-2]
                          +p[-2][correctionbitmap.Width-3].rgbtRed*nM[0,-1]
                          +p[-2][correctionbitmap.Width-2].rgbtRed*nM[0,0]
                          +p[-2][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[-2][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[-2][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[-1][correctionbitmap.Width-5].rgbtRed*nM[0,-3]
                          +p[-1][correctionbitmap.Width-4].rgbtRed*nM[0,-2]
                          +p[-1][correctionbitmap.Width-3].rgbtRed*nM[0,-1]
                          +p[-1][correctionbitmap.Width-2].rgbtRed*nM[0,0]
                          +p[-1][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[-1][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[-1][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[0][correctionbitmap.Width-5].rgbtRed*nM[0,-3]
                          +p[0][correctionbitmap.Width-4].rgbtRed*nM[0,-2]
                          +p[0][correctionbitmap.Width-3].rgbtRed*nM[0,-1]
                          +p[0][correctionbitmap.Width-2].rgbtRed*nM[0,0]
                          +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[1][correctionbitmap.Width-5].rgbtRed*nM[0,-3]
                          +p[1][correctionbitmap.Width-4].rgbtRed*nM[0,-2]
                          +p[1][correctionbitmap.Width-3].rgbtRed*nM[0,-1]
                          +p[1][correctionbitmap.Width-2].rgbtRed*nM[0,0]
                          +p[1][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[1][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[1][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[2][correctionbitmap.Width-5].rgbtRed*nM[0,-3]
                          +p[2][correctionbitmap.Width-4].rgbtRed*nM[0,-2]
                          +p[2][correctionbitmap.Width-3].rgbtRed*nM[0,-1]
                          +p[2][correctionbitmap.Width-2].rgbtRed*nM[0,0]
                          +p[2][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[2][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[2][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[3][correctionbitmap.Width-5].rgbtRed*nM[0,-3]
                          +p[3][correctionbitmap.Width-4].rgbtRed*nM[0,-2]
                          +p[3][correctionbitmap.Width-3].rgbtRed*nM[0,-1]
                          +p[3][correctionbitmap.Width-2].rgbtRed*nM[0,0]
                          +p[3][correctionbitmap.Width-1].rgbtRed*nM[0,1]
                          +p[3][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[3][correctionbitmap.Width-1].rgbtRed*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[correctionbitmap.Width-3].rgbtBlue:=rnd((p[-3][correctionbitmap.Width-6].rgbtBlue*nM[0,-3]
                          +p[-3][correctionbitmap.Width-5].rgbtBlue*nM[0,-2]
                          +p[-3][correctionbitmap.Width-4].rgbtBlue*nM[0,-1]
                          +p[-3][correctionbitmap.Width-3].rgbtBlue*nM[0,0]
                          +p[-3][correctionbitmap.Width-2].rgbtBlue*nM[0,1]
                          +p[-3][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[-3][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[-2][correctionbitmap.Width-6].rgbtBlue*nM[0,-3]
                          +p[-2][correctionbitmap.Width-5].rgbtBlue*nM[0,-2]
                          +p[-2][correctionbitmap.Width-4].rgbtBlue*nM[0,-1]
                          +p[-2][correctionbitmap.Width-3].rgbtBlue*nM[0,0]
                          +p[-2][correctionbitmap.Width-2].rgbtBlue*nM[0,1]
                          +p[-2][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[-2][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[-1][correctionbitmap.Width-6].rgbtBlue*nM[0,-3]
                          +p[-1][correctionbitmap.Width-5].rgbtBlue*nM[0,-2]
                          +p[-1][correctionbitmap.Width-4].rgbtBlue*nM[0,-1]
                          +p[-1][correctionbitmap.Width-3].rgbtBlue*nM[0,0]
                          +p[-1][correctionbitmap.Width-2].rgbtBlue*nM[0,1]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[-1][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[0][correctionbitmap.Width-6].rgbtBlue*nM[0,-3]
                          +p[0][correctionbitmap.Width-5].rgbtBlue*nM[0,-2]
                          +p[0][correctionbitmap.Width-4].rgbtBlue*nM[0,-1]
                          +p[0][correctionbitmap.Width-3].rgbtBlue*nM[0,0]
                          +p[0][correctionbitmap.Width-2].rgbtBlue*nM[0,1]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[0][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[1][correctionbitmap.Width-6].rgbtBlue*nM[0,-3]
                          +p[1][correctionbitmap.Width-5].rgbtBlue*nM[0,-2]
                          +p[1][correctionbitmap.Width-4].rgbtBlue*nM[0,-1]
                          +p[1][correctionbitmap.Width-3].rgbtBlue*nM[0,0]
                          +p[1][correctionbitmap.Width-2].rgbtBlue*nM[0,1]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[1][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[2][correctionbitmap.Width-6].rgbtBlue*nM[0,-3]
                          +p[2][correctionbitmap.Width-5].rgbtBlue*nM[0,-2]
                          +p[2][correctionbitmap.Width-4].rgbtBlue*nM[0,-1]
                          +p[2][correctionbitmap.Width-3].rgbtBlue*nM[0,0]
                          +p[2][correctionbitmap.Width-2].rgbtBlue*nM[0,1]
                          +p[2][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[2][correctionbitmap.Width-1].rgbtBlue*nM[0,3]

                          +p[3][correctionbitmap.Width-6].rgbtBlue*nM[0,-3]
                          +p[3][correctionbitmap.Width-5].rgbtBlue*nM[0,-2]
                          +p[3][correctionbitmap.Width-4].rgbtBlue*nM[0,-1]
                          +p[3][correctionbitmap.Width-3].rgbtBlue*nM[0,0]
                          +p[3][correctionbitmap.Width-2].rgbtBlue*nM[0,1]
                          +p[3][correctionbitmap.Width-1].rgbtBlue*nM[0,2]
                          +p[3][correctionbitmap.Width-1].rgbtBlue*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[correctionbitmap.Width-3].rgbtGreen:=rnd((p[-3][correctionbitmap.Width-6].rgbtGreen*nM[0,-3]
                          +p[-3][correctionbitmap.Width-5].rgbtGreen*nM[0,-2]
                          +p[-3][correctionbitmap.Width-4].rgbtGreen*nM[0,-1]
                          +p[-3][correctionbitmap.Width-3].rgbtGreen*nM[0,0]
                          +p[-3][correctionbitmap.Width-2].rgbtGreen*nM[0,1]
                          +p[-3][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[-3][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[-2][correctionbitmap.Width-6].rgbtGreen*nM[0,-3]
                          +p[-2][correctionbitmap.Width-5].rgbtGreen*nM[0,-2]
                          +p[-2][correctionbitmap.Width-4].rgbtGreen*nM[0,-1]
                          +p[-2][correctionbitmap.Width-3].rgbtGreen*nM[0,0]
                          +p[-2][correctionbitmap.Width-2].rgbtGreen*nM[0,1]
                          +p[-2][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[-2][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[-1][correctionbitmap.Width-6].rgbtGreen*nM[0,-3]
                          +p[-1][correctionbitmap.Width-5].rgbtGreen*nM[0,-2]
                          +p[-1][correctionbitmap.Width-4].rgbtGreen*nM[0,-1]
                          +p[-1][correctionbitmap.Width-3].rgbtGreen*nM[0,0]
                          +p[-1][correctionbitmap.Width-2].rgbtGreen*nM[0,1]
                          +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[-1][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[0][correctionbitmap.Width-6].rgbtGreen*nM[0,-3]
                          +p[0][correctionbitmap.Width-5].rgbtGreen*nM[0,-2]
                          +p[0][correctionbitmap.Width-4].rgbtGreen*nM[0,-1]
                          +p[0][correctionbitmap.Width-3].rgbtGreen*nM[0,0]
                          +p[0][correctionbitmap.Width-2].rgbtGreen*nM[0,1]
                          +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[0][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[1][correctionbitmap.Width-6].rgbtGreen*nM[0,-3]
                          +p[1][correctionbitmap.Width-5].rgbtGreen*nM[0,-2]
                          +p[1][correctionbitmap.Width-4].rgbtGreen*nM[0,-1]
                          +p[1][correctionbitmap.Width-3].rgbtGreen*nM[0,0]
                          +p[1][correctionbitmap.Width-2].rgbtGreen*nM[0,1]
                          +p[1][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[1][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[2][correctionbitmap.Width-6].rgbtGreen*nM[0,-3]
                          +p[2][correctionbitmap.Width-5].rgbtGreen*nM[0,-2]
                          +p[2][correctionbitmap.Width-4].rgbtGreen*nM[0,-1]
                          +p[2][correctionbitmap.Width-3].rgbtGreen*nM[0,0]
                          +p[2][correctionbitmap.Width-2].rgbtGreen*nM[0,1]
                          +p[2][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[2][correctionbitmap.Width-1].rgbtGreen*nM[0,3]

                          +p[3][correctionbitmap.Width-6].rgbtGreen*nM[0,-3]
                          +p[3][correctionbitmap.Width-5].rgbtGreen*nM[0,-2]
                          +p[3][correctionbitmap.Width-4].rgbtGreen*nM[0,-1]
                          +p[3][correctionbitmap.Width-3].rgbtGreen*nM[0,0]
                          +p[3][correctionbitmap.Width-2].rgbtGreen*nM[0,1]
                          +p[3][correctionbitmap.Width-1].rgbtGreen*nM[0,2]
                          +p[3][correctionbitmap.Width-1].rgbtGreen*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[correctionbitmap.Width-3].rgbtRed:=rnd((p[-3][correctionbitmap.Width-6].rgbtRed*nM[0,-3]
                          +p[-3][correctionbitmap.Width-5].rgbtRed*nM[0,-2]
                          +p[-3][correctionbitmap.Width-4].rgbtRed*nM[0,-1]
                          +p[-3][correctionbitmap.Width-3].rgbtRed*nM[0,0]
                          +p[-3][correctionbitmap.Width-2].rgbtRed*nM[0,1]
                          +p[-3][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[-3][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[-2][correctionbitmap.Width-6].rgbtRed*nM[0,-3]
                          +p[-2][correctionbitmap.Width-5].rgbtRed*nM[0,-2]
                          +p[-2][correctionbitmap.Width-4].rgbtRed*nM[0,-1]
                          +p[-2][correctionbitmap.Width-3].rgbtRed*nM[0,0]
                          +p[-2][correctionbitmap.Width-2].rgbtRed*nM[0,1]
                          +p[-2][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[-2][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[-1][correctionbitmap.Width-6].rgbtRed*nM[0,-3]
                          +p[-1][correctionbitmap.Width-5].rgbtRed*nM[0,-2]
                          +p[-1][correctionbitmap.Width-4].rgbtRed*nM[0,-1]
                          +p[-1][correctionbitmap.Width-3].rgbtRed*nM[0,0]
                          +p[-1][correctionbitmap.Width-2].rgbtRed*nM[0,1]
                          +p[-1][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[-1][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[0][correctionbitmap.Width-6].rgbtRed*nM[0,-3]
                          +p[0][correctionbitmap.Width-5].rgbtRed*nM[0,-2]
                          +p[0][correctionbitmap.Width-4].rgbtRed*nM[0,-1]
                          +p[0][correctionbitmap.Width-3].rgbtRed*nM[0,0]
                          +p[0][correctionbitmap.Width-2].rgbtRed*nM[0,1]
                          +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[0][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[1][correctionbitmap.Width-6].rgbtRed*nM[0,-3]
                          +p[1][correctionbitmap.Width-5].rgbtRed*nM[0,-2]
                          +p[1][correctionbitmap.Width-4].rgbtRed*nM[0,-1]
                          +p[1][correctionbitmap.Width-3].rgbtRed*nM[0,0]
                          +p[1][correctionbitmap.Width-2].rgbtRed*nM[0,1]
                          +p[1][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[1][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[2][correctionbitmap.Width-6].rgbtRed*nM[0,-3]
                          +p[2][correctionbitmap.Width-5].rgbtRed*nM[0,-2]
                          +p[2][correctionbitmap.Width-4].rgbtRed*nM[0,-1]
                          +p[2][correctionbitmap.Width-3].rgbtRed*nM[0,0]
                          +p[2][correctionbitmap.Width-2].rgbtRed*nM[0,1]
                          +p[2][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[2][correctionbitmap.Width-1].rgbtRed*nM[0,3]

                          +p[3][correctionbitmap.Width-6].rgbtRed*nM[0,-3]
                          +p[3][correctionbitmap.Width-5].rgbtRed*nM[0,-2]
                          +p[3][correctionbitmap.Width-4].rgbtRed*nM[0,-1]
                          +p[3][correctionbitmap.Width-3].rgbtRed*nM[0,0]
                          +p[3][correctionbitmap.Width-2].rgbtRed*nM[0,1]
                          +p[3][correctionbitmap.Width-1].rgbtRed*nM[0,2]
                          +p[3][correctionbitmap.Width-1].rgbtRed*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
    for j:=CorrectionBitmap.Width-4 downto 3 do
    begin
      pp[j].rgbtBlue:=rnd((p[-3][j-3].rgbtBlue*nM[0,-3]
                          +p[-3][j-2].rgbtBlue*nM[0,-2]
                          +p[-3][j-1].rgbtBlue*nM[0,-1]
                          +p[-3][j].rgbtBlue*nM[0,0]
                          +p[-3][j+1].rgbtBlue*nM[0,1]
                          +p[-3][j+2].rgbtBlue*nM[0,2]
                          +p[-3][j+3].rgbtBlue*nM[0,3]

                          +p[-2][j-3].rgbtBlue*nM[0,-3]
                          +p[-2][j-2].rgbtBlue*nM[0,-2]
                          +p[-2][j-1].rgbtBlue*nM[0,-1]
                          +p[-2][j].rgbtBlue*nM[0,0]
                          +p[-2][j+1].rgbtBlue*nM[0,1]
                          +p[-2][j+2].rgbtBlue*nM[0,2]
                          +p[-2][j+3].rgbtBlue*nM[0,3]

                          +p[-1][j-3].rgbtBlue*nM[0,-3]
                          +p[-1][j-2].rgbtBlue*nM[0,-2]
                          +p[-1][j-1].rgbtBlue*nM[0,-1]
                          +p[-1][j].rgbtBlue*nM[0,0]
                          +p[-1][j+1].rgbtBlue*nM[0,1]
                          +p[-1][j+2].rgbtBlue*nM[0,2]
                          +p[-1][j+3].rgbtBlue*nM[0,3]

                          +p[0][j-3].rgbtBlue*nM[0,-3]
                          +p[0][j-2].rgbtBlue*nM[0,-2]
                          +p[0][j-1].rgbtBlue*nM[0,-1]
                          +p[0][j].rgbtBlue*nM[0,0]
                          +p[0][j+1].rgbtBlue*nM[0,1]
                          +p[0][j+2].rgbtBlue*nM[0,2]
                          +p[0][j+3].rgbtBlue*nM[0,3]

                          +p[1][j-3].rgbtBlue*nM[0,-3]
                          +p[1][j-2].rgbtBlue*nM[0,-2]
                          +p[1][j-1].rgbtBlue*nM[0,-1]
                          +p[1][j].rgbtBlue*nM[0,0]
                          +p[1][j+1].rgbtBlue*nM[0,1]
                          +p[1][j+2].rgbtBlue*nM[0,2]
                          +p[1][j+3].rgbtBlue*nM[0,3]

                          +p[2][j-3].rgbtBlue*nM[0,-3]
                          +p[2][j-2].rgbtBlue*nM[0,-2]
                          +p[2][j-1].rgbtBlue*nM[0,-1]
                          +p[2][j].rgbtBlue*nM[0,0]
                          +p[2][j+1].rgbtBlue*nM[0,1]
                          +p[2][j+2].rgbtBlue*nM[0,2]
                          +p[2][j+3].rgbtBlue*nM[0,3]

                          +p[3][j-3].rgbtBlue*nM[0,-3]
                          +p[3][j-2].rgbtBlue*nM[0,-2]
                          +p[3][j-1].rgbtBlue*nM[0,-1]
                          +p[3][j].rgbtBlue*nM[0,0]
                          +p[3][j+1].rgbtBlue*nM[0,1]
                          +p[3][j+2].rgbtBlue*nM[0,2]
                          +p[3][j+3].rgbtBlue*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[j].rgbtGreen:=rnd((p[-3][j-3].rgbtGreen*nM[0,-3]
                          +p[-3][j-2].rgbtGreen*nM[0,-2]
                          +p[-3][j-1].rgbtGreen*nM[0,-1]
                          +p[-3][j].rgbtGreen*nM[0,0]
                          +p[-3][j+1].rgbtGreen*nM[0,1]
                          +p[-3][j+2].rgbtGreen*nM[0,2]
                          +p[-3][j+3].rgbtGreen*nM[0,3]

                          +p[-2][j-3].rgbtGreen*nM[0,-3]
                          +p[-2][j-2].rgbtGreen*nM[0,-2]
                          +p[-2][j-1].rgbtGreen*nM[0,-1]
                          +p[-2][j].rgbtGreen*nM[0,0]
                          +p[-2][j+1].rgbtGreen*nM[0,1]
                          +p[-2][j+2].rgbtGreen*nM[0,2]
                          +p[-2][j+3].rgbtGreen*nM[0,3]

                          +p[-1][j-3].rgbtGreen*nM[0,-3]
                          +p[-1][j-2].rgbtGreen*nM[0,-2]
                          +p[-1][j-1].rgbtGreen*nM[0,-1]
                          +p[-1][j].rgbtGreen*nM[0,0]
                          +p[-1][j+1].rgbtGreen*nM[0,1]
                          +p[-1][j+2].rgbtGreen*nM[0,2]
                          +p[-1][j+3].rgbtGreen*nM[0,3]

                          +p[0][j-3].rgbtGreen*nM[0,-3]
                          +p[0][j-2].rgbtGreen*nM[0,-2]
                          +p[0][j-1].rgbtGreen*nM[0,-1]
                          +p[0][j].rgbtGreen*nM[0,0]
                          +p[0][j+1].rgbtGreen*nM[0,1]
                          +p[0][j+2].rgbtGreen*nM[0,2]
                          +p[0][j+3].rgbtGreen*nM[0,3]

                          +p[1][j-3].rgbtGreen*nM[0,-3]
                          +p[1][j-2].rgbtGreen*nM[0,-2]
                          +p[1][j-1].rgbtGreen*nM[0,-1]
                          +p[1][j].rgbtGreen*nM[0,0]
                          +p[1][j+1].rgbtGreen*nM[0,1]
                          +p[1][j+2].rgbtGreen*nM[0,2]
                          +p[1][j+3].rgbtGreen*nM[0,3]

                          +p[2][j-3].rgbtGreen*nM[0,-3]
                          +p[2][j-2].rgbtGreen*nM[0,-2]
                          +p[2][j-1].rgbtGreen*nM[0,-1]
                          +p[2][j].rgbtGreen*nM[0,0]
                          +p[2][j+1].rgbtGreen*nM[0,1]
                          +p[2][j+2].rgbtGreen*nM[0,2]
                          +p[2][j+3].rgbtGreen*nM[0,3]

                          +p[3][j-3].rgbtGreen*nM[0,-3]
                          +p[3][j-2].rgbtGreen*nM[0,-2]
                          +p[3][j-1].rgbtGreen*nM[0,-1]
                          +p[3][j].rgbtGreen*nM[0,0]
                          +p[3][j+1].rgbtGreen*nM[0,1]
                          +p[3][j+2].rgbtGreen*nM[0,2]
                          +p[3][j+3].rgbtGreen*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
      pp[j].rgbtRed:=rnd((p[-3][j-3].rgbtRed*nM[0,-3]
                          +p[-3][j-2].rgbtRed*nM[0,-2]
                          +p[-3][j-1].rgbtRed*nM[0,-1]
                          +p[-3][j].rgbtRed*nM[0,0]
                          +p[-3][j+1].rgbtRed*nM[0,1]
                          +p[-3][j+2].rgbtRed*nM[0,2]
                          +p[-3][j+3].rgbtRed*nM[0,3]

                          +p[-2][j-3].rgbtRed*nM[0,-3]
                          +p[-2][j-2].rgbtRed*nM[0,-2]
                          +p[-2][j-1].rgbtRed*nM[0,-1]
                          +p[-2][j].rgbtRed*nM[0,0]
                          +p[-2][j+1].rgbtRed*nM[0,1]
                          +p[-2][j+2].rgbtRed*nM[0,2]
                          +p[-2][j+3].rgbtRed*nM[0,3]

                          +p[-1][j-3].rgbtRed*nM[0,-3]
                          +p[-1][j-2].rgbtRed*nM[0,-2]
                          +p[-1][j-1].rgbtRed*nM[0,-1]
                          +p[-1][j].rgbtRed*nM[0,0]
                          +p[-1][j+1].rgbtRed*nM[0,1]
                          +p[-1][j+2].rgbtRed*nM[0,2]
                          +p[-1][j+3].rgbtRed*nM[0,3]

                          +p[0][j-3].rgbtRed*nM[0,-3]
                          +p[0][j-2].rgbtRed*nM[0,-2]
                          +p[0][j-1].rgbtRed*nM[0,-1]
                          +p[0][j].rgbtRed*nM[0,0]
                          +p[0][j+1].rgbtRed*nM[0,1]
                          +p[0][j+2].rgbtRed*nM[0,2]
                          +p[0][j+3].rgbtRed*nM[0,3]

                          +p[1][j-3].rgbtRed*nM[0,-3]
                          +p[1][j-2].rgbtRed*nM[0,-2]
                          +p[1][j-1].rgbtRed*nM[0,-1]
                          +p[1][j].rgbtRed*nM[0,0]
                          +p[1][j+1].rgbtRed*nM[0,1]
                          +p[1][j+2].rgbtRed*nM[0,2]
                          +p[1][j+3].rgbtRed*nM[0,3]

                          +p[2][j-3].rgbtRed*nM[0,-3]
                          +p[2][j-2].rgbtRed*nM[0,-2]
                          +p[2][j-1].rgbtRed*nM[0,-1]
                          +p[2][j].rgbtRed*nM[0,0]
                          +p[2][j+1].rgbtRed*nM[0,1]
                          +p[2][j+2].rgbtRed*nM[0,2]
                          +p[2][j+3].rgbtRed*nM[0,3]

                          +p[3][j-3].rgbtRed*nM[0,-3]
                          +p[3][j-2].rgbtRed*nM[0,-2]
                          +p[3][j-1].rgbtRed*nM[0,-1]
                          +p[3][j].rgbtRed*nM[0,0]
                          +p[3][j+1].rgbtRed*nM[0,1]
                          +p[3][j+2].rgbtRed*nM[0,2]
                          +p[3][j+3].rgbtRed*nM[0,3])
                          /nM[4,-1]+nM[4,0]);
    end;
  end;
  finally
    imgg.Picture.Assign(CorrectionBitmap);
    CorrectionBitmap.Free;
  end;
end;
end.

kova@kpi.kharkov.ua
brightness
contrast
