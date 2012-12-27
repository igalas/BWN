unit WRec_Nak;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, wrec_main;

type

  Cell = record
         col, row : integer;
         enable : boolean;
  end;

  TF_Nak = class(TForm)
    GR_RES: TStringGrid;
    Bevel1: TBevel;
    IMG_ITEM: TImage;
    Button2: TButton;
    Button3: TButton;
    LB_ITEM: TLabel;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure onNakDesc(Sender: TObject);
    procedure GR_RESSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormShow(Sender: TObject);



  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Nak: TF_Nak;
  start : boolean;
  index : integer;
  cells : array[0..23] of Cell;
  procedure ExecuteNK(value : integer);
  procedure ASelectCell(index : integer);

implementation

uses WRec_Diagr, WRec_NakDesc;

{$R *.dfm}

procedure ExecuteNK(value : integer);
var b, fl_diagrame, bb : boolean;
    cc : integer;
    Snd: TObject;
    i : integer;
begin
  if (start) then begin
     start := false;
     exit;
  end;

  F_Nak.GR_RES.Cells[cells[index].col,cells[index].row] := IntToStr(value);
  cells[index].enable := true;
  cc := index + 1;
  ASelectCell(cc);
  if(index = 24) then index := 23;
  bb := not b;
  F_Nak.GR_RESSelectCell(Snd, cells[index].col, cells[index].row, bb);
  for i := 1 to 12 do
    if ((F_Nak.GR_RES.Cells[1,i] = '0') or (F_Nak.GR_RES.Cells[2,i] = '0')) then begin
      //fl_diagrame := false;
      break;
    end;
  //ButtonDiagrame->Enabled=fl_diagrame;
end;

procedure ASelectCell(index : integer);
var Rect : TGridRect;
begin
  Rect.TopLeft.X := cells[index].col;
  Rect.TopLeft.Y := cells[index].row;
  Rect.BottomRight.X := cells[index].col;
  Rect.BottomRight.Y := cells[index].row;
  F_Nak.GR_RES.Selection := Rect;
end;

procedure TF_Nak.FormCreate(Sender: TObject);
var i : byte;
begin
   GR_RES.Cells[0,0]:='Точка';
   GR_RES.Cells[1,0]:='Слева';
   GR_RES.Cells[2,0]:='Справа';
   GR_RES.Cells[0,1]:='P(I)9';
   GR_RES.Cells[0,2]:='MC(IX)7';
   GR_RES.Cells[0,3]:='C(V)7';
   GR_RES.Cells[0,4]:='IG(VI)4';
   GR_RES.Cells[0,5]:='TR(X)4';
   GR_RES.Cells[0,6]:='GI(II)5';
   GR_RES.Cells[0,7]:='RP(IV)3';
   GR_RES.Cells[0,8]:='F(XII)4';
   GR_RES.Cells[0,9]:='R(VIII)3';
   GR_RES.Cells[0,10]:='V(VII)65';
   GR_RES.Cells[0,11]:='VB(XI)40';
   GR_RES.Cells[0,12]:='E(III)42';
   
   for i:=1 to 13 do begin
     GR_RES.Cells[1,i]:='0';
     GR_RES.Cells[2,i]:='0';
   end;

   cells[0].col := 1; cells[0].row := 1;
   cells[1].col := 1; cells[1].row := 2;
   cells[2].col := 1; cells[2].row := 3;
   cells[3].col := 1; cells[3].row := 4;
   cells[4].col := 1; cells[4].row := 5;
   cells[5].col := 1; cells[5].row := 6;
   cells[6].col := 2; cells[6].row := 1;
   cells[7].col := 2; cells[7].row := 2;
   cells[8].col := 2; cells[8].row := 3;
   cells[9].col := 2; cells[9].row := 4;
   cells[10].col := 2; cells[10].row := 5;
   cells[11].col := 2; cells[11].row := 6;
   cells[12].col := 1; cells[12].row := 7;
   cells[13].col := 1; cells[13].row := 8;
   cells[14].col := 1; cells[14].row := 9;
   cells[15].col := 1; cells[15].row := 10;
   cells[16].col := 1; cells[16].row := 11;
   cells[17].col := 1; cells[17].row := 12;
   cells[18].col := 2; cells[18].row := 7;
   cells[19].col := 2; cells[19].row := 8;
   cells[20].col := 2; cells[20].row := 9;
   cells[21].col := 2; cells[21].row := 10;
   cells[22].col := 2; cells[22].row := 11;
   cells[23].col := 2; cells[23].row := 12;

   start := false;
   //fl_diagrame := true;
end;

procedure TF_Nak.Button3Click(Sender: TObject);
var cl : TColor;
    fl : boolean;
    deltaX, val : double;
    i : byte;
begin
  fl := false;
  F_Diagr.Chart1.Series[0].Clear;
  deltaX := 636/12; val := 0;
  for i:=0 to 11 do begin
      val := StrToFloat(GR_RES.Cells[1, i+1]);
      if (val <= 19) then cl := clBlack;
      if ((val > 19) and (val <= 41)) then cl := clBlue;
      if ((val > 41) and (val <= 55)) then cl := clYellow;
      if ((val > 55) and (val <= 72)) then cl := clGreen;
      if (val > 72) then cl := clRed;
      F_Diagr.Chart1.Series[0].AddXY(deltaX*i,val,'L',cl);
      val := StrToFloat(GR_RES.Cells[2, i+1]);
      if (val <= 19) then cl := clBlack;
      if ((val > 19) and (val <= 41)) then cl := clBlue;
      if ((val > 41) and (val <= 55)) then cl := clYellow;
      if ((val > 55) and (val <= 72)) then cl := clGreen;
      if (val > 72) then cl := clRed;
      F_Diagr.Chart1.Series[0].AddXY(deltaX*(i)+0+deltaX/3,val,'R',cl)
  end;
  f_diagr.showmodal;
end;

procedure TF_Nak.onNakDesc(Sender: TObject);
begin
     f_nak_desc.showmodal;
end;

procedure TF_Nak.GR_RESSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var i : byte;
begin

   for i:=0 to 24 do
     if((ACol = cells[i].col) and (ARow = cells[i].row)) then begin
       index := i;
       break;
     end;
   
   if ((ACol = 1) and (ARow = 1)) then begin
     LB_ITEM.Caption := 'ТАЙ-ЮАНЬ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lP9.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tR9.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\легкие.bmp');
     F_Nak_Desc.Caption := 'Легкие';
   end;

   if ((ACol = 2) and (ARow = 1)) then begin
     LB_ITEM.Caption := 'ТАЙ-ЮАНЬ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rP9.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tR9.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\легкие.bmp');
     F_Nak_Desc.Caption := 'Перикард';
   end;

   if ((ACol = 1) and (ARow = 2)) then begin
     LB_ITEM.Caption := 'ДА-ЛИН';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lMC7.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tMC7.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Перикард.bmp');
     F_Nak_Desc.Caption := 'Перикард';
   end;

   if ((ACol = 2) and (ARow = 2)) then begin
     LB_ITEM.Caption := 'ДА-ЛИН';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rMC7.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tMC7.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Перикард.bmp');
     F_Nak_Desc.Caption := 'Перикард';
   end;

   if ((ACol = 1) and (ARow = 3)) then begin
     LB_ITEM.Caption := 'ШЭНЬ-МЭНЬ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lC7.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tC7.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Сердце.bmp');
     F_Nak_Desc.Caption := 'Перикард';
   end;

   if ((ACol = 2) and (ARow = 3)) then begin
     LB_ITEM.Caption := 'ШЭНЬ-МЭНЬ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rC7.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tC7.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Сердце.bmp');
     F_Nak_Desc.Caption := 'Перикард';
   end;

   if ((ACol = 1) and (ARow = 4)) then begin
     LB_ITEM.Caption := 'ВАНЬ-ГУ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lIG4.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tIG4.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Тонкая кишка.bmp');
     F_Nak_Desc.Caption := 'Тонкая кишка';
   end;

   if ((ACol = 2) and (ARow = 4)) then begin
     LB_ITEM.Caption := 'ВАНЬ-ГУ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rIG4.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tIG4.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Тонкая кишка.bmp');
     F_Nak_Desc.Caption := 'Тонкая кишка';
   end;

   if ((ACol = 1) and (ARow = 5)) then begin
     LB_ITEM.Caption := 'ЯН-ЧИ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lTR4.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tTR4.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Три обогревателя.bmp');
     F_Nak_Desc.Caption := 'Три обогревателя';
   end;

   if ((ACol = 2) and (ARow = 5)) then begin
     LB_ITEM.Caption := 'ЯН-ЧИ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rTR4.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tTR4.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Три обогревателя.bmp');
     F_Nak_Desc.Caption := 'Три обогревателя';
   end;

   if ((ACol = 1) and (ARow = 6)) then begin
     LB_ITEM.Caption := 'ЯН-CИ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lGI5.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tGI5.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Толстая кишка.bmp');
     F_Nak_Desc.Caption := 'Толкстая кишка';
   end;

   if ((ACol = 2) and (ARow = 6)) then begin
     LB_ITEM.Caption := 'ЯН-CИ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rGI5.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tGI5.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Толстая кишка.bmp');
     F_Nak_Desc.Caption := 'Толкстая кишка';
   end;

   if ((ACol = 1) and (ARow = 7)) then begin
     LB_ITEM.Caption := 'ТАЙ-БАЙ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lRP3.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tRP3.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Селезенка.bmp');
     F_Nak_Desc.Caption := 'Селезенка-Поджелудочная железа';
   end;

   if ((ACol = 2) and (ARow = 7)) then begin
     LB_ITEM.Caption := 'ТАЙ-БАЙ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rRP3.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tRP3.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Селезенка.bmp');
     F_Nak_Desc.Caption := 'Селезенка-Поджелудочная железа';
   end;

   if ((ACol = 1) and (ARow = 8)) then begin
     LB_ITEM.Caption := 'ТАЙ-ЧУН';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lF3.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tF3.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Печень.bmp');
     F_Nak_Desc.Caption := 'Печень';
   end;

   if ((ACol = 2) and (ARow = 8)) then begin
     LB_ITEM.Caption := 'ТАЙ-ЧУН';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rF3.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tF3.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Печень.bmp');
     F_Nak_Desc.Caption := 'Печень';
   end;

   if ((ACol = 1) and (ARow = 9)) then begin
     LB_ITEM.Caption := 'ТАЙ-СИ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lR3.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tR3.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Почки.bmp');
     F_Nak_Desc.Caption := 'Почки';
   end;

   if ((ACol = 2) and (ARow = 9)) then begin
     LB_ITEM.Caption := 'ТАЙ-СИ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rR3.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tR3.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Почки.bmp');
     F_Nak_Desc.Caption := 'Почки';
   end;

   if ((ACol = 1) and (ARow = 10)) then begin
     LB_ITEM.Caption := 'ШУ-ГУ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lV65.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tV65.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Мочевой пузырь.bmp');
     F_Nak_Desc.Caption := 'Мочевой пузырь';
   end;

   if ((ACol = 2) and (ARow = 10)) then begin
     LB_ITEM.Caption := 'ШУ-ГУ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rV65.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tV65.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Мочевой пузырь.bmp');
     F_Nak_Desc.Caption := 'Мочевой пузырь';
   end;

   if ((ACol = 1) and (ARow = 11)) then begin
     LB_ITEM.Caption := 'ЦЮ-СЮЙ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lVB40.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tVB40.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Желчный пузырь.bmp');
     F_Nak_Desc.Caption := 'Желчный пузырь';
   end;

   if ((ACol = 2) and (ARow = 11)) then begin
     LB_ITEM.Caption := 'ЦЮ-СЮЙ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rVB40.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tVB40.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Желчный пузырь.bmp');
     F_Nak_Desc.Caption := 'Желчный пузырь';
   end;

   if ((ACol = 1) and (ARow = 12)) then begin
     LB_ITEM.Caption := 'ЧУН-ЯН';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lE42.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tE42.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Желудок.bmp');
     F_Nak_Desc.Caption := 'Желудок';
   end;

   if ((ACol = 2) and (ARow = 12)) then begin
     LB_ITEM.Caption := 'ЧУН-ЯН';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\rE42.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tE42.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\Желудок.bmp');
     F_Nak_Desc.Caption := 'Желудок';
   end;

end;

procedure TF_Nak.FormShow(Sender: TObject);
begin
     LB_ITEM.Caption := 'ТАЙ-ЮАНЬ';
     IMG_ITEM.Picture.LoadFromFile(appdir + 'Data\lP9.bmp');

     F_Nak_Desc.RCH_ORG.Lines.LoadFromFile(appdir + 'Data\tR9.rtf');
     F_Nak_Desc.IMG_ORG.Picture.LoadFromFile(appdir + 'Data\легкие.bmp');
     F_Nak_Desc.Caption := 'Легкие';
end;

end.
