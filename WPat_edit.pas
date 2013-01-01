unit WPat_edit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Mask, StdCtrls, Grids, WPat_main, ExtCtrls, Buttons, sqlite3;

type
  TPatEdt = class(TForm)
    FIO_EDT: TEdit;
    ADDR_EDT: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Grid: TStringGrid;
    Sex_GR: TRadioGroup;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    PHONE_EDT: TEdit;
    D_Edt: TMaskEdit;
    M_Edt: TMaskEdit;
    Y_Edt: TMaskEdit;
    Reload_btn: TBitBtn;
    OK_Btn: TBitBtn;
    Canc_btn: TBitBtn;
    procedure Show(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; VCol, VRow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridClick(Sender: TObject);
    procedure Canc_btnClick(Sender: TObject);
    procedure onWrite(Sender: TObject);
    procedure onReload(Sender: TObject);
    procedure ChFio(Sender: TObject);
    procedure onChDate(Sender: TObject);
    procedure onValidate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PatEdt: TPatEdt;
    num,i,idx: integer;
    sfio,sD,sM,sY,ssex,saddr,sphone:string;
    el: array[1..3] of string[20];
    ell:string[60];
    db   : TSqliteDatabase;
    res  : TSqliteQueryResults;
    astr: array[1..12,1..20] of byte=
((1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0),(0,0,0,0,1,0,0,0,0,0,1,0,1,0,0,0,0,1,0,0),
 (0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0),(1,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
 (1,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0),(0,1,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,1,0,0),
 (0,1,1,0,0,0,0,0,0,1,1,0,0,1,0,0,0,1,0,0),(0,0,0,1,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0),
 (0,0,1,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,1),(0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1),
 (1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1),(0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0));
 procedure Redraw(Sender: TObject; grid:TStringGrid);

implementation

{$R *.dfm}
// -----------------------------------------------------------
procedure Redraw(Sender: TObject; grid:TStringGrid);
var i,j: integer;
    sql:string;
begin
  WITH Sender AS TPatEdt DO BEGIN
    for i:=1 to 60 do ell:=ell+'0'; fio_edt.Clear; addr_edt.Clear; phone_edt.Clear;
    D_edt.Text:='01'; M_edt.Text:='01'; Y_edt.Text:='1980'; sex_gr.ItemIndex:=1;
    if num>0 then  begin
      db:=TSqliteDatabase.Open(dir+'\DB\BIO_Pat.db3');
      sql:='select * from T_Pat WHERE ID='+inttostr(num);
      res:=TSqliteQueryResults.Create(db, sql);
      fio_edt.Text:=UTF8Decode(res.FieldAsString(2));
      D_edt.Text:=res.FieldAsString(3);
      M_edt.Text:=res.FieldAsString(4);
      Y_edt.Text:=res.FieldAsString(5);
      ssex:=UTF8Decode(res.FieldAsString(7));
      addr_edt.Text:=UTF8Decode(res.FieldAsString(8));
      phone_edt.Text:=UTF8Decode(res.FieldAsString(9));
      ell:=res.FieldAsString(10);
      res.free; db.free;
    end;
    el[1]:=copy(ell,1,20); el[2]:=copy(ell,21,20); el[3]:=copy(ell,41,20);
    If ssex='Ж' then sex_gr.ItemIndex:=1 else sex_gr.ItemIndex:=0;
  END;
  with grid.Canvas do begin
    font.Color:=clblue; font.Name:='tahoma';
    font.style:=[fsBold]; font.Size:=10;
    for j:=1 to 3 do for i:=1 to 20 do  begin
      if el[j][i]='0' then font.Color:=clsilver else font.Color:=clBlack;
      textout((i-1)*(25+3)+4,(j-1)*(25+3)+4, lab[i]);
    end;
  end; // PatEdt.caption:=el[1]+'   '+el[2]+'   '+el[3];
end;
// -----------------------------------------------------------
procedure TPatEdt.Show(Sender: TObject);
begin
  Redraw(PatEdt,grid); idx:=0;
end;
// -----------------------------------------------------------
procedure TPatEdt.GridDrawCell(Sender: TObject; VCol, VRow: Integer;
  Rect: TRect; State: TGridDrawState);
var i,j: byte;
begin
  IF Sender=ActiveControl THEN Exit;
  IF NOT (gdSelected IN State) THEN Exit;
  WITH Sender AS TStringGrid DO BEGIN
       Canvas.Brush.Color:=Color; Canvas.Font.Color:=Font.Color;
       Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,Cells[vCol,vRow]);
  end;
  with grid.Canvas do begin
    font.Color:=clblue; font.Name:='tahoma';
    font.style:=[fsBold]; font.Size:=10;
    for j:=1 to 3 do for i:=1 to 20 do  begin
      if el[j][i]='0' then font.Color:=clsilver else font.Color:=clBlack;
      textout((i-1)*(25+3)+4,(j-1)*(25+3)+4, lab[i]);
    end;
  end;
end;
// -----------------------------------------------------------
procedure TPatEdt.GridClick(Sender: TObject);
begin
  with grid.Canvas do if Grid.Row>0 then begin
   if el[Grid.Row+1][Grid.Col+1]='0' then el[Grid.Row+1][Grid.Col+1]:='1' else el[Grid.Row+1][Grid.Col+1]:='0';
   if el[Grid.Row+1][Grid.Col+1]='0' then font.Color:=clsilver else font.Color:=clBlack;
   font.style:=[fsBold]; font.Size:=10; font.Name:='tahoma';
   textout(Grid.Col*(25+3)+4,Grid.Row*(25+3)+4, lab[Grid.Col+1]);
  end;
end;
// -----------------------------------------------------------
procedure TPatEdt.onWrite(Sender: TObject);
var i,fl:integer;
    arr:array[1..70] of char;
    st:string[4];
    sql:string;
begin
  if length(fio_edt.text)>0 then begin
     sfio:=trim(fio_edt.Text);
     sD:=D_edt.Text; sM:=M_edt.Text; sY:=Y_edt.Text;
     If sex_gr.itemindex=0 then ssex:='М' else ssex:='Ж';
     saddr:=trim(addr_edt.Text); sphone:=trim(phone_edt.Text);
     ell:=el[1]+el[2]+el[3];
     db:=TSqliteDatabase.Open(dir+'\DB\BIO_Pat.db3');
     if num>0 then begin
       F_pat.list.Items[F_pat.list.ItemIndex]:=sfio;
     end else begin
       if (ssex = 'Ж') then F_pat.List.Items.AddObject(sfio, ic_f);
       if (ssex = 'М') then F_pat.List.Items.AddObject(sfio, ic_m);
       sld:='No';
       F_pat.GroupBox2.Caption:=' Всего '+inttostr(F_pat.list.Items.Count)+' пациентов ';
       sql:='SELECT ID FROM T_Pat WHERE act=0';
       res:=TSqliteQueryResults.Create(db, sql);
       if not res.Eof then num:=res.FieldAsInteger(0);
       res.Free;
     end;
     if num>0 then begin
        if (sld='') then sld:='No';
        sql:='UPDATE T_Pat SET act=1,fio="'+UTF8Encode(sfio)+'",D="'+sD+'",M="'+sM+'",Y="'+sY;
        sql:=sql+'",LD="'+sld+'",sex="'+UTF8Encode(ssex)+'",addr="'+UTF8Encode(saddr);
        sql:=sql+'",phone="'+UTF8Encode(sphone)+'",el="'+ell+'" WHERE ID='+inttostr(num);
        db.ExecSQL(sql); db.Commit;
     end else begin
        ShowMessage('База пациентов переполнена! Удалите устаревшие записи.');
        {
        sql:= 'INSERT INTO T_Pat (act,fio,D,M,Y,LD,sex,addr,phone,el) VALUES("1","';
        sql:=sql+UTF8Encode(sfio)+'","'+sD+'","'+sM+'","'+sY+'","No","'+UTF8Encode(ssex)+'","';
        sql:=sql+UTF8Encode(saddr)+'","'+UTF8Encode(sphone)+'","'+ell+'")';
        num:=F_pat.list.Items.Count;
        db.ExecSQL(sql); db.Commit;
        }
     end;
     db.Free;
     F_pat.list.ItemIndex:=F_pat.list.Items.IndexOf(sfio);
     F_Pat.Caption:='Пациент  '+inttostr(num-1) ;ShData(num);
     if idx=1 then indx:=1; Patedt.close;
     F_Pat.WRK_BTN.Enabled:=true;
     F_Pat.Del_BTN.Enabled:=true; F_Pat.Ch_btn.Enabled:=true;
  end else ShowMessage('Не заполнена графа "Ф.И.О"');
end;
// -----------------------------------------------------------
procedure TPatEdt.Canc_btnClick(Sender: TObject);
begin
 Patedt.close;
end;
// -----------------------------------------------------------
procedure TPatEdt.onReload(Sender: TObject);
begin
 Redraw(PatEdt,grid); idx:=0;
end;
// -----------------------------------------------------------
procedure TPatEdt.ChFio(Sender: TObject);
begin
 idx:=1;
end;
// -----------------------------------------------------------
procedure TPatEdt.onChDate(Sender: TObject);
var i,j:integer;
    st:string[4];
begin
  st:=M_edt.Text+D_edt.Text; j:=1;
  if st>'1221' then j:=1 else if st>'1122' then j:=12 else if st>'1023' then j:=11 else
  if st>'0923' then j:=10 else if st>'0823' then j:=9 else if st>'0722' then j:=8 else
  if st>'0621' then j:=7 else if st>'0520' then j:=6 else if st>'0420' then j:=5 else
  if st>'0320' then j:=4 else if st>'0219' then j:=3 else if st>'0120' then j:=2;
  for i:=1 to 20 do begin
    if astr[j,i]=1 then el[1][i]:='1' else el[1][i]:='0';
  end;
  with grid.Canvas do if length(st)=4 then begin
    font.Color:=clblue; font.Name:='tahoma';
    font.style:=[fsBold]; font.Size:=10;
    for i:=1 to 20 do  begin
      if el[1][i]='0' then font.Color:=clsilver else font.Color:=clBlack;
      textout((i-1)*(25+3)+4,4,lab[i]);
    end;
  end;
end;
// -----------------------------------------------------------
procedure TPatEdt.onValidate(Sender: TObject);
var Date: integer;
    s: string;
begin
  try
    if(sender=D_Edt) then Date:=StrToInt(D_Edt.Text) else
    if(sender=M_Edt) then Date:=StrToInt(M_Edt.Text) else
    if(sender=Y_Edt) then Date:=StrToInt(Y_Edt.Text);
  except
    on E: EConvertError do ShowMessage('Повторите ввод даты в формате 00 00 0000');
  end;
end;

end.
