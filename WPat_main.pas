unit WPat_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls,
  Menus, ImgList, Wrec_main, jpeg, sqlite3;

type
  TF_Pat = class(TForm)
    List: TListBox;
    GroupBox1: TGroupBox;
    Find_edt: TEdit;
    IMGL: TImageList;
    L1: TLabel;
    RButton1: TRadioButton;
    RButton2: TRadioButton;
    GroupBox2: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    L_D: TLabel;
    L_P: TLabel;
    L_A: TLabel;
    NEW_Btn: TBitBtn;
    Ch_btn: TBitBtn;
    Del_Btn: TBitBtn;
    No_BTN: TBitBtn;
    WRK_Btn: TBitBtn;
    Image1: TImage;
    Panel1: TPanel;
    L_LD: TLabel;
    Label4: TLabel;
    Image2: TImage;
    procedure FormShow(Sender: TObject);
    procedure ListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Find_edtChange(Sender: TObject);
    procedure ListContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure NEW_BTNClick(Sender: TObject);
    procedure OnMod(Sender: TObject);
    procedure NoPat(Sender: TObject);
    procedure ListClick(Sender: TObject);
    procedure Del_BTNClick(Sender: TObject);
    procedure OnSelect(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

type
     pt = array[1..70] of Char;
     ppt =^pt;

var
  F_Pat                       : TF_Pat;
  fl,i,indx,pat_old           : Integer;
  buf                         : array[1..70] of Char;
  act                         : char;
  pp                          : ppt;
  //num,
  nm                     : integer;
  dir                         : string;
  Patient                     : string[4];
  ic_m, ic_f, ic_om, ic_of    : TIcon;
  s_arr                       : array [0..9999] of word;
  sld                         : string;
  f_load                  : boolean;
const
  lab: array[1..20] of string[2]=('Ly',' P','Gi','Nd','MC','Al','Pd','TR',' C',
                          'IG','Rp',' F','Ad',' E','Cd',' S','Fd','VB',' R',' V');

  Procedure ShData(i:integer);

implementation

uses WPat_Edit, wrec_log,
  Preload;
{$R *.dfm}
// ---------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------
procedure TF_Pat.FormShow(Sender: TObject);
var j : word;
begin
   if (not f_load) then F_PreLoad.ShowModal;                 //первая загрузка - показ PRELOAD
   GroupBox2.Caption:=' Всего '+inttostr(list.Items.Count)+' пациентов ';
end;
// ----------------------------------------------------------------------------------------------
procedure TF_Pat.ListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do begin
   FillRect(Rect);
   Draw(rect.Left+5, rect.Top+2, TIcon((Control as TListBox).Items.Objects[Index]));
   TextOut(Rect.Left+34,Rect.Top+(Rect.Bottom-Rect.Top+font.Height) div 2,List.Items[Index]);
  end;
end;
// ---------------------------------------------------------------------------------------------
procedure ShData(i:integer);
var
   sql, sss:string;
begin
   sql:='SELECT D, M, Y, LD, addr, phone  FROM T_Pat WHERE ID='+inttostr(i);
   db:=TSqliteDatabase.Open(dir+'\DB\BIO_Pat.db3');
   res:=TSqliteQueryResults.Create(db, sql);
   F_Pat.L_D.Caption:=res.FieldAsString(0)+'-'+res.FieldAsString(1)+'-'+res.FieldAsString(2);
   F_Pat.L_LD.Caption:=res.FieldAsString(3);
   F_Pat.L_A.Caption:=UTF8Decode(res.FieldAsString(4));
   F_Pat.L_P.Caption:=UTF8Decode(res.FieldAsString(5));
   res.Free; db.Free;
end;
// ---------------------------------------------------------------------------------------------
procedure getnum();
var sql, stt:string;
begin
   stt:=F_Pat.List.items[F_pat.List.itemindex];
   sql:='SELECT ID FROM T_Pat WHERE fio="'+UTF8Encode(stt)+'"';
   db:=TSqliteDatabase.Open(dir+'\DB\BIO_Pat.db3');
   res:=TSqliteQueryResults.Create(db, sql);
   num:=res.FieldAsInteger(0);
   res.Free; db.Free;
end;
// --------------------------------------------------------------------------------------------
procedure TF_Pat.Find_edtChange(Sender: TObject);
var ndx,k,i: integer;
        sql, sfio, snum: string;
begin
  WITH Sender AS TEdit DO BEGIN
    if RButton2.Checked=true then begin
      try i:=strtoint(Text); except i:=11111; end;               // по номеру
      snum:=inttostr(i);                           //
      sql:='SELECT fio FROM T_Pat WHERE ID='+UTF8Encode(snum);
      db:=TSqliteDatabase.Open(dir+'\DB\BIO_Pat.db3');
      res:=TSqliteQueryResults.Create(db, sql);
      sfio:=UTF8Decode(res.FieldAsString(0)); res.Free; db.Free;
      if sfio='' then sfio:='sysys';
    end else sfio:=Text;                                        // по фамилии
      Ndx := List.Items.Add(sfio); List.Items.Delete(Ndx);      // вставил, взял индех, удалил
      IF AnsiCompareText(sfio, Copy(List.Items[Ndx],1,Length(sfio)))=0 THEN
         List.ItemIndex:=Ndx ELSE List.ItemIndex:=-1;
  END;
  if list.ItemIndex>-1 then  begin
    ch_btn.Enabled:=true; del_btn.Enabled:=true; wrk_btn.Enabled:=true;
    getnum();F_Pat.Caption:='Пациент  '+inttostr(num);  ShData(num);    //
  end else begin
    ch_btn.Enabled:=false; del_btn.Enabled:=false; wrk_btn.Enabled:=false;
  end;
end;
// -------------------------------------------------------------------------------------------
procedure TF_Pat.ListContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;
// -------------------------------------------------------------------------------------------
procedure TF_Pat.NEW_BTNClick(Sender: TObject);
begin
 num:=0;
 with patedt do  begin
   Caption:='Новый пациент...';  reload_btn.Hide; OK_BTN.Caption:='Создать';
   d_edt.text:='01'; m_edt.text:='01'; y_edt.text:='1980';
  end;
 patedt.ShowModal;
 GroupBox2.Caption:=' Всего '+inttostr(list.Items.Count)+' пациентов ';
end;
// --------------------------------------------------------------------------------------------
procedure TF_Pat.OnMod(Sender: TObject);
var st, stt:string;
begin
   patedt.Caption:='Редактирование пациента...';
   patedt.reload_btn.Show;  patedt.OK_BTN.Caption:='Сохранить';
   stt:=List.items[List.itemindex]; getnum();
   patedt.ShowModal;
end;
// --------------------------------------------------------------------------------------------
procedure TF_Pat.ListClick(Sender: TObject);
begin
  if list.ItemIndex>-1 then  begin
    ch_btn.Enabled:=true; del_btn.Enabled:=true; wrk_btn.Enabled:=true;
    getnum();F_Pat.Caption:='Пациент  '+inttostr(num);                       //
    WRK_BTN.Enabled:=true; ShData(num);
  end;
end;
// --------------------------------------------------------------------------------------------
procedure TF_Pat.Del_BTNClick(Sender: TObject);
var  st: string[4];
     arr:array[1..70] of char;
     sr: TSearchRec;
     stt,sql:string;
     numm:integer;
begin
  If MessageDlg('Вы действительно желаете удалить пациента ?',MtConfirmation,
      [mbYes,mbNo],0)=idYes then begin
    getnum();
    list.Items.Delete(list.ItemIndex); st:=inttohex(list.Items.Count,4);   //Затирание в окне
    sql:='UPDATE T_Pat SET act=0 WHERE ID='+inttostr(num);                 //Затирание в базе
    db:=TSqliteDatabase.Open(dir+'\DB\BIO_Pat.db3');
    db.ExecSQL(sql); db.Commit; db.Free;
    indx:=1;
    GroupBox2.Caption:=' Всего '+inttostr(list.Items.Count)+' пациентов ';
    F_Pat.Caption:='Выбор пациента...';
    ch_btn.Enabled:=false; del_btn.Enabled:=false; wrk_btn.Enabled:=false;
    sql:='DELETE FROM T_Rec WHERE pid='+inttostr(num);                    //Затирание в базе
    db:=TSqliteDatabase.Open(dir+'\DB\BIO_Rec.db3');
    db.ExecSQL(sql); db.Free;
  end;
end;
// --------------------------------------------------------------------------------------------
procedure TF_Pat.OnSelect(Sender: TObject);
var sst:string;
    i: integer;
begin
   sst:=inttostr(num); if num<11then sst:='000'+sst else if
       num<101 then sst:='00'+sst else if num<1001 then sst:='0'+sst;
   patient:=sst;
   pat_name := patient; WRec_main.ReadRecList(num);
   Main.Pat_FIO:=List.items[List.itemindex];;
   Main.Caption:='Пациентов: '+inttostr(list.Items.Count)+'.  Пациент: № '+pat_name+' '+Main.Pat_FIO+'   Последний визит: '+F_Pat.L_LD.Caption;
   Modalresult := mrOk;
   WriteLog('Выбран пациент ' + Main.Pat_FIO, 0);
end;
// ---------------------------------------------------------------------------------------------
procedure TF_Pat.NoPat(Sender: TObject);
begin
  Main.Caption:='Пациентов: '+inttostr(list.Items.Count)+' ==Работа без пациента==';
  pat_name:='9999';  num:=9999;
  Modalresult := mrOk;
  WriteLog('Работа без пациента', 0);
end;
// ---------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------


end.


