unit WRec_Help;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, WRec_main, StdCtrls, Buttons, sqlite3;

type
  TF_Help = class(TForm)
    Bt_Exit: TBitBtn;
    Bt_Sav: TBitBtn;
    Memo: TMemo;
    procedure OnShow(Sender: TObject);
    procedure OnExit(Sender: TObject);
    procedure OnChg(Sender: TObject);
    procedure OnSav(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Help: TF_Help;
  stf,st:string[200];
  chg: byte;
  Dir,sp:string;
//---------------------------------------------------------------------------
implementation

uses WPat_main;

{$R *.dfm}
//---------------------------------------------------------------------------
procedure TF_Help.OnShow(Sender: TObject);
var fl:textfile;
    st:string;
    ssp:string[4];
    j:integer;
begin
  Dir:=extractFilePath(paramstr(0));
  if hlp_side=1 then begin
     for j:=1 to 4 do ssp[j]:=char(Rec[Main.grid.row+1]^.sp[j]);
     st:=Rec[Main.grid.row+1]^.nc+Rec[Main.grid.row+1]^.ns;
  end;
  if hlp_side=2 then begin
     for j:=1 to 4 do ssp[j]:=char(Srec[Main.Sp_list.row+1]^.sp[j]);
     st:=Srec[Main.Sp_list.row+1]^.nc+Srec[Main.Sp_list.row+1]^.ns;
  end;
  F_Help.Caption:='Спектр '+st; memo.Clear; sp:=copy(ssp,1,4);
  db:=TSqliteDatabase.Open(Dir+'DB\BIO_HLP.DB3');
  sql:='SELECT dsc FROM T_HLP WHERE sp="'+sp+'"';
  res:=TSqliteQueryResults.Create(db, sql);
  Rec_n:=UTF8Decode(res.FieldAsString(0)); memo.Clear;
  while not res.Eof do begin
     st:=res.FieldAsString(0);
     if length(st)>0 then st:=UTF8Decode(st);
     memo.Lines.Add(st); res.Next;
  end;
  if memo.Lines.Count=0 then memo.Lines.Add('Информация о спектре отсутствует'); chg:=0;
  res.Free; db.Free;
end;
//---------------------------------------------------------------------------
procedure TF_Help.OnExit(Sender: TObject);
begin
   if chg=1 then if MessageDlg('Файл изменен. сохранить?',
   mtConfirmation,
      [mbYes, mbNo],
      0) = mrYes then OnSav(memo);
   F_Help.Close;
end;
//---------------------------------------------------------------------------
procedure TF_Help.OnChg(Sender: TObject);
begin
  chg:=1;
end;
//---------------------------------------------------------------------------
procedure TF_Help.OnSav(Sender: TObject);
var i,k: integer;
    fl:textfile;
begin
  if chg=1 then begin
    db:=TSqliteDatabase.Open(Dir+'DB\BIO_HLP.DB3');
    sql:='DELETE FROM T_HLP WHERE sp="'+sp+'"';
    db.ExecSQL(sql); db.BeginTransaction;
    for i:=1 to memo.Lines.Count do begin
      st:= memo.Lines[i-1];
      for k:=1 to Length(st) do begin
         if st[k]='''' then st[k]:='`'; if st[k]='"' then st[k]:='`';
      end;
      sql:='INSERT INTO T_HLP (sp,dsc) VALUES ("'+sp+'","'+UTF8Encode(st)+'")';
      db.ExecSQL(sql);
    end; db.Commit; db.Free;
  end; chg:=0;
end;
//---------------------------------------------------------------------------


end.
