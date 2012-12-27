unit WRec_print;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Printers, ExtCtrls, Grids, INIFiles, ShellAPI,
  WPat_edit, wrec_log, sqlite3;

type
  TF_Print = class(TForm)
    Memo1: TMemo;
    Bt_Print: TBitBtn;
    Bt_Exit: TBitBtn;
    LTitle1: TLabel;
    Bt_Sav: TBitBtn;
    LTitle2: TLabel;
    LTitle3: TLabel;
    Rz_List: TComboBox;
    Bt_Del: TBitBtn;
    LLoad: TLabel;
    LStat: TPanel;
    Memo2: TMemo;
    Grid: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    ChBox: TCheckBox;
    procedure OnShow(Sender: TObject);
    procedure Printing(Sender: TObject);
    procedure OnSav(Sender: TObject);
    procedure OnExit(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure OnLoad(Sender: TObject);
    procedure OnDel(Sender: TObject);
    procedure Load_Rz(Sender: TObject);
    Function Rezume(const sdt:string):integer;
    procedure OnSDrCel(Sender: TObject; wCol, wRow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure OnChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Print: TF_Print;
   Rz_nam,Rz_date,sfio,sdate,saddr,sphone,sNow: string;
   Rz_num,rrf,g_n: integer;
   a:array[0..100] of byte;

implementation

uses WRec_main, WPat_main;

{$R *.dfm}
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
function STF(s:string):string;
var
   k:integer;
begin
  for k:=1 to Length(s) do begin
     if s[k]='''' then s[k]:='`';
     if s[k]='"' then s[k]:='`';
  end;
  STF:=s;
end;
//---------------------------------------------------------------------------
procedure TF_Print.OnShow(Sender: TObject);
var i:integer;
    st,stt:string;
begin
    OnLoad(Sender); rrf:=rf;  sNow:=DateToStr(Now); memo2.Clear; Rz_date:=sNow;
    RZ_num:=Rezume(sNow); F_Print.Caption:='Заключение: №'+inttostr(Rz_num)+' от '+sNow;
    bt_del.Enabled:=true; bt_sav.Enabled:=true;  memo1.Clear;
    memo1.Lines.Add('B связи с жалобами: '); memo1.Lines.Add('Заключение:  ');
    memo1.Lines.Add('Общее энергетическое состояние   D    S.');
    memo1.Lines.Add('Выравнивание показателей происходит при тестировании нозонда(ов)  :');
    memo1.Lines.Add('Снижение биоэнергетики по меридианам и выравнивающие факторы  :');
    memo1.Lines.Add(''); memo1.Lines.Add('Диагноз:   '); grid.RowCount:=rrf;
    for i:=1 to rf do begin
      st:=main.Grid.Rows[i-1].Text; st[length(st)-1]:=' '; st[length(st)]:=' ';
      grid.Rows[i-1].Add(st);  a[i-1]:=atr[i-1];  ChBox.Checked:=true;
    end;
    Bt_Sav.Enabled:=true; Bt_Del.Enabled:=false;
    sql:='SELECT * FROM T_Pat WHERE id='+inttostr(pnum);
    db:=TSqliteDatabase.Open(dir+'\DB\BIO_Pat.db3');
    res:=TSqliteQueryResults.Create(db, sql);
    sfio:=Trim(UTF8Decode(res.FieldAsString(2)));
    saddr:=Trim(UTF8Decode(res.FieldAsString(8)));
    sdate:=res.FieldAsString(3)+'.'+res.FieldAsString(4)+'.'+res.FieldAsString(5);
    sphone:=Trim(UTF8Decode(res.FieldAsString(9)));
    stt:=sdate+'    Тел.'+sphone;
    res.Free; db.Free;
end;
//---------------------------------------------------------------------------
procedure ClrList();
var i:integer;
begin
  if rrf>0 then for i:=1 to rrf do F_Print.grid.Rows[i-1].Clear;
  rrf:=0; F_Print.grid.RowCount:=rrf; i:=0;
end;

//---------------------------------------------------------------------------
procedure TF_Print.Printing(Sender: TObject);
var i,k,kf,kp:integer;
    st:string;
    PDoc : TStringList;
 begin
   LStat.Color:=ClNavy;
   LStat.caption:='Печать заключения...';
   PDoc := TStringList.Create;
   PDoc.Add('<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
   PDoc.Add('<html xmlns="http://www.w3.org/1999/xhtml">');
   PDoc.Add('<head>');
   PDoc.Add('<meta http-equiv="Content-Type" content="text/html; charset=Windows-1251" />');
   PDoc.Add('<style>');
   PDoc.Add('body { mrgin: 0 auto; padding: 0; font-family: "Verdana"; font-weight: normal; font-size: 14px; }');
   PDoc.Add('h1 { font-family: "Times New Roman"; font-size: 16px; font-weight: 600; color: #000; text-align: center; margin: 5px; }');
   PDoc.Add('h2 { font-family: "Times New Roman"; font-size: 16px; font-weight: normal; color: #000; text-align: center; margin: 5px; }');
   PDoc.Add('td, th { height: 18px; font-family: "Verdana"; font-size: 12px; font-weight: normal; color: #000; text-align: left; }');
   PDoc.Add('.data th { background: #e0e0e0; width: 120px; height: 20px; padding-right: 5px; text-align: right; }');
   PDoc.Add('.recept th { height: 18px; font-family: "Verdana"; font-size: 12px; font-weight: normal; color: #bbb; }');
   PDoc.Add('.recept td { height: 18px; font-family: "Verdana"; font-size: 12px; font-weight: normal;}');
   PDoc.Add('</style>');
   PDoc.Add('</head>');
   PDoc.Add('<body>');
   PDoc.Add('<h1>Медико-техническая фирма "ЭРВА"</h1>');
   PDoc.Add('<h2>Обследование методом электропунктуры <br/> на компютерном комплексе BIOCORID FC+ 2</h2><hr/>');
   PDoc.Add('<table width="100%" cellspacing="2" cellpadding="0" border="0" class="data">');
   PDoc.Add('<tr><th>Дата приема:</th><td>'+Rz_date+'</td></tr>');
   PDoc.Add('<tr><th>ФИО:</th><td><b>'+sfio+'</b></td></tr>');
   PDoc.Add('<tr><th>Адрес:</th><td>'+saddr+'</td></tr>');
   PDoc.Add('<tr><th>Дата рождения:</th><td>'+sdate+'</td></tr>');
   PDoc.Add('<tr><th>Телефон:</th><td>'+sphone+'</td></tr>');
   PDoc.Add('</table><br/>');
   PDoc.Add('<table width="100%" cellspacing="0" cellpadding="0" border="0">');
   for i:=0 to memo1.Lines.Count-1 do PDoc.Add('<tr><td>'+memo1.Lines[i]+'</td></tr>');
   PDoc.Add('</table></br><b>Рецепт:</b><br/>');
   PDoc.Add('<table width="100%" cellspacing="2" cellpadding="0" border="0" class="recept">');
   for i:=1 to grid.RowCount do begin
      st:=Grid.Rows[i-1].Text; st[length(st)-1]:=' '; st[length(st)]:=' ';
      if a[i-1]<2 then PDoc.Add('<tr><td>'+st+'</td></tr>')
         else if (ChBox.Checked) then PDoc.Add('<tr><th>'+st+'</th></tr>');
   end;
   PDoc.Add('</table><br/><b>Дополнительная информация:</b><br/>');
   PDoc.Add('<table width="100%" cellspacing="0" cellpadding="0" border="0">');
   for i:=0 to memo2.Lines.Count-1 do PDoc.Add('<tr><td>'+memo2.Lines[i]+'</td></tr>');
   PDoc.Add('</table>');
   PDoc.Add('</body>');
   PDoc.Add('</html>');
   PDoc.SaveToFile(appdir + 'RPT.HTML');
   PDoc.Free;
   ShellExecute(handle,'Print','RPT.HTML','',PAnsiChar(appdir),0);
   LStat.caption := '';
   LStat.Color := clBtnFace;
end;
//---------------------------------------------------------------------------
procedure TF_Print.OnExit(Sender: TObject);
begin
 ClrList(); ModalResult:=mrOK;
end;
//---------------------------------------------------------------------------
procedure TF_Print.Memo1Click(Sender: TObject);
begin
 lstat.Caption:='';
end;
//---------------------------------------------------------------------------
Function TF_Print.Rezume(const sdt:string):integer;
var i,nn:integer;
    stt:string;
begin
  sql:='SELECT * FROM T_LP WHERE pid="'+inttostr(pnum)+'" AND date="'+sdt+'"';
  sql:=sql+' ORDER BY num DESC';
  db:=TSqliteDatabase.Open(dir+'\DB\BIO_PRT.db3');
  res:=TSqliteQueryResults.Create(db, sql);
  if not res.Eof then nn:=strtoint(res.FieldAsString(3))+1 else nn:=1;
  Rezume:=nn; res.Free; db.Free;
end;
//---------------------------------------------------------------------------
procedure TF_Print.OnSav(Sender: TObject);
var i:integer;
    st,stt,sq,id,f,ff:string;
begin
  Rz_num:=Rezume(sNow);
  db:=TSqliteDatabase.Open(dir+'\DB\BIO_PRT.db3');
  sql:='INSERT INTO T_LP (pid,date,num) VALUES ('+inttostr(pnum)+',"'+sNow+'","'+inttostr(Rz_num)+'")';
  db.ExecSQL(sql);
  sql:='SELECT * FROM T_LP WHERE pid="'+inttostr(pnum)+'" AND date="'+sNow+'" AND num="'+inttostr(Rz_num)+'"';
  res:=TSqliteQueryResults.Create(db,sql);
  id:=inttostr(res.FieldAsInteger(0)); res.Free;
  sq:='INSERT INTO T_P (idp,dsc) VALUES ('+id+',"'; db.BeginTransaction;
  for i:=1 to memo1.Lines.Count do begin
    st:=memo1.Lines[i-1]; st:=Trim(st); ff:=f;
    if (length(st)>6) and (pos(':',st)>0) then begin
       if (copy(st,1,7)='B связи') then f:='1';
       if (copy(st,1,7)='Заключе') then f:='2';
       if (copy(st,1,7)='Выравни') then f:='4';
       if (copy(st,1,7)='Снижени') then f:='5';
       if (copy(st,1,7)='Диагноз') then f:='6';
       if ff<f then delete(st,1,pos(':',st));
    end;
    if (length(st)>6) and (copy(st,1,7)='Общее э') then begin
         delete(st,1,31); f:='3';
    end;
    st:=Trim(st);  stt:=st;
    if st<>'' then sql:=sq+f+':'+STF(UTF8Encode(st))+'")' else sql:='';
    if sql<>'' then db.ExecSQL(sql);
  end; f:='7';
  for i:=1 to grid.RowCount do begin
    st:=grid.Rows[i-1].Text;  st:=Trim(st);
    if a[i-1]<2 then st:='A\'+st else st:='0\'+st;
    sql:=sq+f+':'+STF(UTF8Encode(st))+'")';
    db.ExecSQL(sql);
  end; f:='8';
  for i:=1 to memo2.Lines.Count do begin
    st:=memo2.Lines[i-1]; st:=Trim(st);
    if st<>'' then sql:=sq+f+':'+STF(UTF8Encode(st))+'")' else sql:='';
    if sql<>'' then db.ExecSQL(sql);
  end;
  db.Commit; db.Free; OnLoad(Sender); //LStat.Caption:=id;                  ///////////////
end;
//---------------------------------------------------------------------------
procedure TF_Print.OnLoad(Sender: TObject);
var
   sdt:string;
begin
  Rz_list.Clear; Rz_num:=0;
  sql:='SELECT * FROM T_LP WHERE pid='+inttostr(pnum);
  db:=TSqliteDatabase.Open(dir+'\DB\BIO_PRT.db3');
  res:=TSqliteQueryResults.Create(db, sql);
  while not res.Eof do begin
     sdt:=res.FieldAsString(2)+' №'+res.FieldAsString(3);
     Rz_LIST.Items.Add(sdt); inc(Rz_num); res.Next;
  end;
  res.Free; db.Free;
end;
//---------------------------------------------------------------------------
procedure TF_Print.OnDel(Sender: TObject);
var id:string;
begin
  db:=TSqliteDatabase.Open(dir+'\DB\BIO_PRT.db3');
  sql:='SELECT * FROM T_LP WHERE pid="'+inttostr(pnum)+'" AND date="'+Rz_date+'" AND num="'+inttostr(Rz_num)+'"';
  res:=TSqliteQueryResults.Create(db,sql);
  id:=inttostr(res.FieldAsInteger(0)); res.Free;
  sql:='DELETE FROM T_P WHERE idp='+id;
  db.ExecSQL(sql);
  sql:='DELETE FROM T_LP WHERE id='+id;
  db.ExecSQL(sql);
  db.Free; OnLoad(Sender);
end;
//---------------------------------------------------------------------------
procedure TF_Print.Load_Rz(Sender: TObject);
var
    st,stt:string;
    i,f,ff,k:integer;
begin
  memo1.Clear; memo2.Clear; ClrList(); f:=0; ff:=0; i:=0; g_n:=0;
  Rz_nam:=Rz_List.Text; Rz_date:=copy(Rz_nam,1,10);
  Rz_num:=strtoint(copy(Rz_nam,length(Rz_nam),1));
  db:=TSqliteDatabase.Open(dir+'\DB\BIO_PRT.db3');
  sql:='SELECT T_P.*,T_LP.id FROM T_LP,T_P WHERE T_LP.date="'+Rz_date+'" AND T_LP.num="';
  sql:=sql+copy(Rz_nam,length(Rz_nam),1)+'" AND T_LP.pid='+inttostr(pnum)+' AND T_LP.id=T_P.idp';
  res:=TSqliteQueryResults.Create(db, sql);
  While not res.Eof do begin
      if ff=f then begin
        stt:=UTF8Decode(res.FieldAsString(2));  res.Next;
        ff:=strtoint(copy(stt,1,1)); delete(stt,1,2);
        if stt[2]='\' then begin
            inc(i); if stt[1]='0' then a[i-1]:=2 else a[i-1]:=0;  rrf:=i; delete(stt,1,2);
        end; if ff>=f+1 then st:='' else st:=stt;
      end;
      if ff=f+1 then st:=stt;
      case f of
        0: if ff>f then begin
               memo1.Lines.Add('B связи с жалобами: '+st); inc(f);
           end;
        1: if ff>f then begin
               memo1.Lines.Add('Заключение: '+st); inc(f);
           end else memo1.Lines.Add(st);
        2: if ff>f then begin
               memo1.Lines.Add('Общее энергетическое состояние '+st); inc(f);
           end else memo1.Lines.Add(st);
        3: if ff>f then begin
               memo1.Lines.Add('Выравнивание показателей происходит при тестировании нозонда(ов):'+st); inc(f);
           end else memo1.Lines.Add(st);
        4: if ff>f then begin
               memo1.Lines.Add('Снижение биоэнергетики по меридианам и выравнивающие факторы:'+st); inc(f);
           end else memo1.Lines.Add(st);
        5: if ff>f then begin
               memo1.Lines.Add('');
               memo1.Lines.Add('Диагноз: '+st); inc(f);
           end else memo1.Lines.Add(st);
        6: if ff>f then begin
               inc(g_n); inc(f); grid.Rows[g_n-1].Add(st);
           end else memo1.Lines.Add(st);
        7: if ff>f then begin
               memo2.Lines.Add(st); inc(f);
           end else begin
               grid.RowCount:=grid.RowCount+1; inc(g_n); grid.Rows[g_n-1].Add(st);
           end;
        8: memo2.Lines.Add(st);
      end;
  end;
  res.Free; db.Free;
  LStat.Font.Color:=ClNavy;  LStat.caption:='';
  bt_del.Enabled:=true; Bt_Sav.Enabled:=false;
  F_Print.Caption:='Заключение: №'+inttostr(Rz_num)+' от '+Rz_date;
end;
//---------------------------------------------------------------------------
procedure TF_Print.OnSDrCel(Sender: TObject; wCol, wRow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
WITH Sender AS TStringGrid DO begin
    if a[wRow]<2 then Canvas.Font.Color := clBlack else Canvas.Font.Color := clSilver;
    Canvas.Brush.Color := clWindow;
    if (gdSelected IN State) and (Sender=ActiveControl) then begin
       if a[wRow]<2 then Canvas.Font.Color := clWhite else Canvas.Font.Color := clYellow;
       Canvas.Brush.Color := clMenuHighlight;
    end;
    Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,Cells[wCol,wRow]);
  end;
end;
//---------------------------------------------------------------------------
procedure TF_Print.FormCreate(Sender: TObject);
begin
  grid.ColWidths[0]:=2100;
end;
//---------------------------------------------------------------------------
procedure TF_Print.OnChange(Sender: TObject);
begin
  Bt_Sav.Enabled:=true;
end;
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
end.
