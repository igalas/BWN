unit Preload;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, wpat_main, Gauges, ExtCtrls, jpeg, sqlite3, WPat_Edit;

type
  TF_PreLoad = class(TForm)
    Gauge1: TGauge;
    Timer1: TTimer;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_PreLoad: TF_PreLoad;

implementation

{$R *.dfm}

procedure TF_PreLoad.FormActivate(Sender: TObject);
var j,i : word;
    nn:integer;
   sql,ssex,sfio,sldd: string;
begin
  with f_pat do begin
   application.ProcessMessages;
   dir:=extractFilePath(paramstr(0));  indx:=0;
   ic_m := TIcon.Create; ic_f := TIcon.Create;
   ic_om := TIcon.Create; ic_of := TIcon.Create;
   db:=TSqliteDatabase.Open(dir+'\DB\BIO_Pat.db3');
   sql:='select count(*) from T_Pat as npat';
   res:=TSqliteQueryResults.Create(db, sql);
   nn:=res.FieldAsInteger(0); res.Free;
   sql:='select fio, LD, sex from T_Pat WHERE act=1';
   res:=TSqliteQueryResults.Create(db, sql);
   For i:=1 to nn do  begin
       Gauge1.Progress := i;
       sfio:=UTF8Decode(res.FieldAsString(0));
       sld:=res.FieldAsString(1);
       if sld='No' then sldd:='0000' else sldd:=copy(sld,7,4);
       ssex:=UTF8Decode(res.FieldAsString(2));
       imgl.GetIcon(0, ic_of); imgl.GetIcon(1, ic_om);
       imgl.GetIcon(2, ic_f); imgl.GetIcon(3, ic_m);
       if (ssex = 'Æ') then if strtoint(sldd)<pat_old then List.Items.AddObject(sfio, ic_of)
           else List.Items.AddObject(sfio, ic_f);
       if (ssex = 'Ì') then if strtoint(sldd)<pat_old then List.Items.AddObject(sfio, ic_om)
           else List.Items.AddObject(sfio, ic_m);
       res.Next;
   end; res.free; db.Free;
   list.Invalidate; List.Repaint; list.Refresh;
  end;
  gauge1.Hide;
  f_load := true;
  timer1.Enabled := true;
end;

procedure TF_PreLoad.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  close;
end;

end.
