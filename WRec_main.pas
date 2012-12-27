unit WRec_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, ImgList, ComCtrls, TabNotBk,
  Grids, CPort, INIFiles, CPortCtl, sqlite3;

type
  TMain = class(TForm)
    REC_PM: TPopupMenu;
    Sav_MNU: TMenuItem;
    SavAs_MNU: TMenuItem;
    Del_MNU: TMenuItem;
    GroupBox2: TGroupBox;
    SP_TAB: TTabControl;
    SP_IMG: TImageList;
    SP_Menu: TTreeView;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    R_LIST: TComboBox;
    Grid: TStringGrid;
    SP_list: TStringGrid;
    Linfo: TEdit;
    Bt_Del: TBitBtn;
    Bt_SavAs: TBitBtn;
    Bt_Sav: TBitBtn;
    Bt_PInfo: TBitBtn;
    Bt_Print: TBitBtn;
    Bt_Exit: TBitBtn;
    Bt_Clear: TBitBtn;
    Bt_DelS: TBitBtn;
    Bt_AddS: TBitBtn;
    Ed_Find: TEdit;
    Bt_Find: TBitBtn;
    SP_Find: TStringGrid;
    Bt_Help: TBitBtn;
    SpeedButton2: TSpeedButton;
    PL_STATE: TPanel;
    PL_VAL: TPanel;
    cport: TComPort;
    Image1: TImage;
    T_TIM: TTimer;
    SW_SPEC: TPanel;
    SW_REC: TPanel;
    Menu: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N6: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    COM1: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    Bt_Pat: TBitBtn;
    N18: TMenuItem;
    SB_Time: TSpeedButton;
    Bevel1: TBevel;
    N20: TMenuItem;
    N21: TMenuItem;
    PR_VAL: TProgressBar;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N3: TMenuItem;
    N9: TMenuItem;
    N19: TMenuItem;
    N25: TMenuItem;
    LabSel: TLabel;
    N26: TMenuItem;
    N27: TMenuItem;
    Label2: TLabel;
    procedure AppException(Sender: TObject; E: Exception);
    procedure OnChPage(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OnRDrCel(Sender: TObject; vCol, vRow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure OnSDrCel(Sender: TObject; wCol, wRow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure OnSCLick(Sender: TObject);
    procedure OnSelRec(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure DelSRec(Sender: TObject);
    procedure ClearRec(Sender: TObject);
    procedure OnAddSp(Sender: TObject);
    procedure OnChR_n(Sender: TObject);
    procedure SavRec(Sender: TObject);
    procedure SavAs(Sender: TObject);
    procedure DelRec(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function SortFRec(Sender: TObject):integer;
    procedure OnPrint(Sender: TObject);
    procedure OnClose(Sender: TObject);
    procedure OnInfo(Sender: TObject);
    procedure EboutBIO(Sender: TObject);
    procedure OnFind(Sender: TObject);
    procedure OnFDrCel(Sender: TObject; WCol, WRow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure OnHelp(Sender: TObject);
    procedure OnSortFiles(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cportRxChar(Sender: TObject; Count: Integer);
    procedure T_TIMTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SW_SPECClick(Sender: TObject);
    procedure SW_RECClick(Sender: TObject);
    procedure SetCOMClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure Bt_PatClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SP_MenuClick(Sender: TObject);
    procedure SP_MenuKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N21Click(Sender: TObject);
    procedure OnSB_Time(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Ed_FindExit(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure OnDelSelRec(Sender: TObject);
  private
    { Private declarations }
  public
    Pat_FIO : string;
  end;

Type
     ar= array[1..5] of byte;
     ListRec=Record
       ni  : TTreeNode;
       num : String[3];
       lvl : String[1];
       sp  : String[1];
       nam : String[40];
       dsc : string[100];
     End;
     SpRec=Record
       sp  : ar;
       n   : string[4];
       nc  : string[2];
       ns  : string[6];//array[1..6] of char;
       nam : string[200];//array[1..232] of char;
     End;
     pt= String[200];
     arr= array[1..250] of char;
     ars= array[1..80] of char;
     parr=^arr;

const IDM_New = $C0;
      fold : real = 1.0;
      fk : real = 20.0;
      MODE_REC : boolean = true;
      MODE_SPEC: boolean = false;
var
  ini    : TINIFile;
  ftek   : real;
  Main   : TMain;
  AppDir : String;
  FRec   : array[1..15000] of ^SpRec;
  LRec   : array[1..2000] of ^Listrec;                 //
  SRec   : array[1..2000] of ^SpRec;                   // SP in SP_List
  Rec    : array[1..100] of ^SpRec;                    // SP in Grid
  atr,ats: array[0..2000] of byte;                     // atr-SP active in REC; ats-SP atr in SP
  Pat    : string[4];                                  // Patient number
  Pat_name: string;                                    // Patient name
  Ldata  : string;                                     // Last visit
  senderOld : char;
  count_nk, sumNK : integer;
  bak_opts : string[4];

  indx,nl,lf,lfl,rf,chp,chr,num,hlp_side,rsa: integer;       //
  nsel, kf:integer;
  sp     : ar;  //                                           //
  sWin,sWn,sDos,Slist_n,Rec_nam,Rec_W: string;               //
  Rec_n  :string;                                            // Комментарий в рецепте
  conn, mode_l, flblock, mode : boolean;                     //
  byteru : byte;
  flStartMeasureNK, flMeasureNK : boolean;
  SelRList:TStringList;
  lv: array[0..4] of TTreeNode;

  db                          : TSqliteDatabase;
  res                         : TSqliteQueryResults;
  sql,srnum,ssp,sdesc,tmode   : string;
  pnum,rnum                   : integer;
  vi                          : integer;               //vi - VACUUM+REINDEX
                                                       // rsa - receipt active specter count
procedure WrRec(R_n:string;k:byte);                    // chr - change recept
//Function Cnvrt(var p:pt; lng,wd: byte): pt;            // chp - change patient
procedure working(var c:char);                         // indx - pos of SP_TAB
procedure setMode(const bMode : boolean);              // lf   - SP count in SP_List
procedure ReadRecList(pnm:integer);                    // lfl  - SP count in Find
procedure Archivate;                                   // rf   - SP count in Grid
procedure SetAddress(addr : integer);                  // num  -  Abs Spectr NUM
procedure Wr_Rec(addr: integer);                       // hlp_side -  ????????
procedure Buttons(DS,CL,DR,SN,SV: byte);               // nl - menu count
function SetRNam(num: integer):string;
//function RTrim(Str: String): String;
//uses WBio_print;
//-------------------------------------------------------------------------------------------------
//================================================================================= Н А Ч А Л О ===
//-------------------------------------------------------------------------------------------------
implementation
uses WRec_print,WRec_About, WRec_Help, Wrec_cfg, WPat_main,
  WPat_edit, WRec_Nak, WRec_log, WRec_Hlp;
//------------------------------------------------------------------------------
procedure Tmain.AppException(Sender: TObject; E: Exception);
begin
  WriteLog('В приложении произошла ошибка!', 2);
  DebugMsg(E.Message);
end;
//------------------------------------------------------------------------------
procedure Buttons(DS,CL,DR,SN,SV: byte);
begin
  with Main do begin
      Bt_DelS.Enabled:=bool(DS);
      Bt_Clear.Enabled:=bool(CL); N13.Enabled:=bool(CL);
      Bt_Del.Enabled:=bool(DR);   N16.Enabled:=bool(DR);
      Bt_SavAs.Enabled:=bool(SN); N15.Enabled:=bool(SN);
      Bt_Sav.Enabled:=bool(SV);   N14.Enabled:=bool(SV);
      if(rf>0) then begin
        Linfo.ReadOnly:=false; SB_Time.Enabled:=true;
      end else begin
        Linfo.ReadOnly:=true; SB_Time.Enabled:=false;
      end;
  end;
end;
//------------------------------------------------------------------------------
{$R *.dfm}
//------------------------------------------------------------------------------
procedure Archivate;
var commline : string;
begin
  If MessageBox(main.handle, 'Будет выполнена архивация данных! Начать?', 'Архивация', MB_YESNO)=IDYES then begin
     //pkzipc -add -rec -dir=current 1.zip *.*
     commline := '"'+appdir+'pkzipc.exe" -add '+appdir+'db\'+FormatDateTime('yyyy-mm-dd',now)+'_BIO.ZIP '+appdir+'db\BIO_REC.DB3';
     if (bak_opts[1] = '1') then commline := commline + ' ' +appdir+'db\BIO_PAT.DB3';
     if (bak_opts[2] = '1') then commline := commline + ' ' +appdir+'db\BIO_SP.DB3 '+appdir+'db\BIO_ST.DB3';
     if (bak_opts[3] = '1') then commline := commline + ' '+appdir+'db\BIO_PRT.DB3';
     if (bak_opts[4] = '1') then commline := commline + ' '+appdir+'db\BIO_HLP.DB3';

     WinExec(PAnsiChar(commline), 1);
     ini := TIniFile.Create(ExtractFilePath(Application.ExeName)+'config.ini');
     ini.WriteDate('Backup', 'lastdate', now);
     ini.Free;
     WriteLog('Архивация данных', 1);
     If (vi=1) then BEGIN
         db:=TSqliteDatabase.Open(dir+'DB\BIO_PAT.db3');
         db.ExecSQL('REINDEX T_Pat_Index01');
         db.ExecSQL('VACUUM T_Pat'); db.Free;
         db:=TSqliteDatabase.Open(dir+'DB\BIO_REC.db3');
         db.ExecSQL('VACUUM T_Rec'); db.Free;
         db:=TSqliteDatabase.Open(dir+'DB\BIO_PRT.db3');
         db.ExecSQL('VACUUM T_LP'); db.ExecSQL('VACUUM T_P'); db.Free;
     END;
  end;
end;

//------------------------------------------------------------------------------
function strhex(sp:ar):integer;
var n:ar;
    i:integer;
begin
   for i:=1 to 4 do if sp[i]<65 then n[i]:=sp[i]-48 else n[i]:=sp[i]-55;
   strhex:=n[1]*4096+n[2]*256+n[3]*16+n[4];
end;
// -----------------------------------------------------------------------------
Procedure Sclear(st:pt);
var i : integer;
Begin
    for i:=1 to 100 do st[i]:=#0;
end;
//------------------------------------------------------------------------------
procedure ClrList();
var i:integer;
begin
   for i:=1 to lf do begin
    dispose(SRec[i]); Srec[i]:=nil;  main.SP_list.Rows[i-1].Clear; ats[i-1]:=0;
   end; lf:=0; main.SP_list.RowCount:=lf;
end;
//------------------------------------------------------------------------------
procedure ClrFind();
var i:integer;
begin
   for i:=1 to lfl do begin
      main.SP_Find.Rows[i-1].Clear; dispose(FRec[i]);  FRec[i]:=nil;
   end; lfl:=0; main.SP_Find.RowCount:=lfl;
end;
// -----------------------------------------------------------------------------
Function Readarr(st:string):ars;
var i,k : integer;
    r : ars;
Begin
  for i:=1 to 80 do r[i]:=' ';  k:=length(st);
  if (k>0) then for i:=1 to length(st) do r[i]:=st[i]; ReadArr:=r;
end;
//----------------------------------------------------------------------------- Read Recept List  ---
procedure ReadRecList(pnm:integer);
var  sr: TSearchRec;
     stt:string;
     ltime: Double;
begin
  main.R_List.Clear; ltime:=0;  pnum:=pnm;
  if(nsel>0) then begin
      main.N26.Enabled:=false; nsel:=0; main.LabSel.Visible:=False; SelRList.Free;
  end;
  db:=TSqliteDatabase.Open(dir+'DB\BIO_REC.DB3');
  sql:='SELECT rnum FROM T_REC WHERE pid='+inttostr(pnum);
  res:=TSqliteQueryResults.Create(db, sql);
  while not res.Eof do begin
   srnum:=res.FieldAsString(0);// while length(srnum)<3 do srnum:='0'+srnum;
   main.R_List.Items.Add(srnum);
   res.Next;
  end;
  res.Free; db.Free;
  if ltime>0 then Ldata:=DateToStr(ltime) else Ldata:='Нет';
  Main.Label1.Caption:='Рецептов:'; Main.LabSel.Caption:=inttostr(Main.R_List.Items.Count);
  Main.LabSel.Font.Color:=clNavy;
end;
// ------------------------------------------------------------------------ Show Spectr TREE --------
Procedure ShBsm(mode:string);
var st:string[200];
    i,lev : integer;
Begin
  db := TSqliteDatabase.Open(dir+'DB\BIO_ST.db3');
  sql:='SELECT * FROM T_ST WHERE mode="'+mode+'"';
  res:=TSqliteQueryResults.Create(db,sql);
  While not res.Eof do begin
    inc(nl); new(Lrec[nl]);
    Lrec[nl]^.num:=res.FieldAsString(2);
    Lrec[nl]^.lvl:=res.FieldAsString(3); lev:=strtoint(Lrec[nl]^.lvl);
    Lrec[nl]^.sp:=res.FieldAsString(4);
    Lrec[nl]^.nam:=UTF8Decode(res.FieldAsString(5));
    Lrec[nl]^.dsc:=UTF8Decode(res.FieldAsString(6));
    lv[lev+1]:=Main.SP_MENU.Items.AddChild(lv[lev],Lrec[nl]^.nam);
    res.Next;
  end; res.Free; db.Free;
end;
//------------------------------------------------------------------------- Show Spectr List -------
procedure ShSp(num:string);
var    i,j,n:integer;
       st:string[100];
       ssp,sn,min:string;
begin
    db := TSqliteDatabase.Open(dir+'DB\BIO_SP.db3');
    if tmode='1' then sql:='SELECT sp,n,nc,ns,nam FROM T_SP WHERE nc="'+copy(num,2,2)+'"' else begin
      sql:='SELECT T_SPK.sp, T_SP.n, T_SP.nc, T_SP.ns, T_SP.nam FROM T_SP, T_SPK WHERE T_SPK.mode="'+tmode+'" AND T_SPK.num="';
      sql:=sql+num+'" AND T_SP.sp=substr(T_SPK.sp,1,4)';
    end;
    res:=TSqliteQueryResults.Create(db, sql); i:=1; lf:=0;
    while not res.Eof do begin
      ssp:=res.FieldAsString(0); for j:=1 to 4 do char(sp[j]):=ssp[j];
      sp[5]:=0;
      if tmode<>'1' then begin
       if ssp[5]='-' then sp[5]:=1;
       if ssp[5]='+' then sp[5]:=2;
      end;
      new(SRec[i]); SRec[i]^.sp:=sp; n:=strhex(sp); ats[i-1]:=sp[5];
      Srec[i]^.n:=res.FieldAsString(1);
      Srec[i]^.nc:=res.FieldAsString(2);
      Srec[i]^.ns:=res.FieldAsString(3);
      Srec[i]^.nam:=UTF8Decode(res.FieldAsString(4));
      inc(i); inc(lf); res.Next;
    end; res.Free; db.Free;
    main.SP_list.RowCount:=lf;
    for i:=1 to lf do begin
      if Srec[i]^.sp[5]=1 then min:='--' else min:='';
      main.SP_list.Rows[i-1].Add(Srec[i]^.nc+Srec[i]^.ns+' '+min+Srec[i]^.nam);
    end;
    main.GroupBox2.Caption:='Спектров: '+inttostr(lf);
end;
//--------------------------------------------------------------------------- Show Recept -----------
procedure ShRec(pn:pt);
var ff,i,n,kk:integer;
    st:string[100];
    tmp,sss : string;
begin
  rsa := 0; i:=0;
  if chr>0 then WrRec(Rec_nam,0);
  db:=TSqliteDatabase.Open(dir+'DB\BIO_REC.DB3');
  sql:='SELECT desc, sp FROM T_REC WHERE pid='+inttostr(pnum)+' AND rnum="'+pn+'"';
  res:=TSqliteQueryResults.Create(db, sql);
  Rec_n:=UTF8Decode(res.FieldAsString(0));  main.Linfo.Text:=Rec_n;
  ssp:=UTF8Decode(res.FieldAsString(1));
  res.Free; db.Free;
  db := TSqliteDatabase.Open(dir+'DB\BIO_SP.db3');
  rf:=length(ssp) div 5; main.grid.RowCount:=rf;
  for i:=1 to rf do begin
    sss:=copy(ssp,(i-1)*5+1,5); if sss[5]='+' then sss[5]:=#0 else sss[5]:=#2;
    n:=strtoint('0x'+copy(sss,1,4));
    for kk:=1 to 5 do char(sp[kk]):=sss[kk];
    new(Rec[i]); Rec[i]^.sp:=sp; atr[i-1]:=sp[5];
    sql:='SELECT * FROM T_SP WHERE sp="'+copy(sss,1,4)+'"';
    res:=TSqliteQueryResults.Create(db, sql);
    Rec[i]^.n:=res.FieldAsString(2);
    Rec[i]^.nc:=res.FieldAsString(3);
    Rec[i]^.ns:=res.FieldAsString(4);
    Rec[i]^.nam:=UTF8Decode(res.FieldAsString(5));
    res.Free;
    main.grid.Rows[i-1].Add(Rec[i]^.nc+Rec[i]^.ns+' '+Rec[i]^.nam);
  end; Buttons(0,1,1,1,1);
  Chr:=0; Rec_nam:=pn;  db.Free;
end;
//--------------------------------------------------------------------- Select Recept trom List ----
procedure TMain.OnSelRec(Sender: TObject);
var i:integer;
begin
   if chr>0 then WrRec(Rec_nam,0);
   Bt_Clear.Click;
   ShRec(R_list.Text);
   Buttons(0,1,1,0,0);
   WriteLog('Загружен рецепт ' + R_list.Text, 0);
   if(nsel>0) then begin
     if(SelRList.IndexOf(R_List.Text)=-1) then begin
         LabSel.Font.Color:=clNavy;
     end else begin
         LabSel.Font.Color:=clRed;
     end;
   end;
end;
//------------------------------------------------------------------------ PAGE Change ------------
procedure TMain.OnChPage(Sender: TObject);
var
    i:integer;
begin
  for i:=1 to nl do begin dispose(Lrec[i]); Lrec[i]:=nil; end;
  ClrList();  GroupBox2.Caption:='Спектры'; SP_MENU.Items.Clear; nl:=0;
  indx:=SP_TAB.TabIndex;
  case indx of
     0: begin tmode:='1'; Bt_Find.Default := false; end;
     1: begin tmode:='2'; Bt_Find.Default := false; end;
     2: begin tmode:='3'; Bt_Find.Default := false; end;
     3: begin ClrFind;  end;
  end;
  if indx<3 then begin
     SP_menu.Visible:=true; SP_list.Visible:=true;
     BT_Find.Visible:=false; Ed_Find.Visible:=false; SP_Find.Visible:=false;
     ShBsm(tmode);
  end else begin
     SP_menu.Visible:=false; SP_list.Visible:=false; Bt_AddS.Enabled:=false;
     BT_Find.Visible:=true; Ed_Find.Visible:=true; SP_Find.Visible:=true;
     Ed_Find.Text:='';
  end;
  Slist_n:=''; Linfo.Text:=Slist_n;
end;
//---------------------------------------------------------------------------------<<<< MAIN >>>>--
//---------------------------------------------------------------------------------<<<< MAIN >>>>--
//---------------------------------------------------------------------------------<<<< MAIN >>>>--
procedure TMain.FormCreate(Sender: TObject);
var i : word;
begin
  byteru := $80;
  for i:=1 to 2000 do srec[i] := nil;
  for i:=1 to 100 do rec[i] := nil;
  Application.OnException := AppException;
  AppDir:=ExtractFilePath(Application.ExeName);
  ini := TINIFile.Create(AppDir+'config.ini');
  pat_old:=ini.ReadInteger('Pat window', 'pat_old', 2005);
end;
//---------------------------------------------------------------------------------<<<< MAIN >>>>--
procedure TMain.FormShow(Sender: TObject);
var arcd : TDateTime;
    arcp : byte;
    arcl : word;
    cprt : string;
begin
 nl:=0; Chr:=0; lv[0]:=nil; tmode:='1'; ShBsm('1');
 Buttons(0,0,0,0,0);
 flMeasureNK := false;
 flStartMeasureNK := false;
 AppDir:=ExtractFilePath(Application.ExeName);
 ini := TINIFile.Create(AppDir+'config.ini');
 opt[0] := ini.ReadBool('Log window', 'Info', false);
 opt[1] := ini.ReadBool('Log window', 'Warn', false);
 opt[2] := ini.ReadBool('Log window', 'Err', false);
 opt[3] := ini.ReadBool('Log window', 'Debug', false);
 opt[4] := ini.ReadBool('Log window', 'DevDebug', false);
 opts[0] := ini.ReadBool('Log window', 'sInfo', false);
 opts[1] := ini.ReadBool('Log window', 'sWarn', false);
 opts[2] := ini.ReadBool('Log window', 'sErr', false);
 opts[3] := ini.ReadBool('Log window', 'sDebug', false);
 opts[4] := ini.ReadBool('Log window', 'sDev', false);
 cprt := ini.ReadString('Connection', 'Port', 'COM1');
 if (cprt = 'COM0') then begin
    conn := false;
    ini.WriteString('Connection', 'Port', 'COM0');
    ini.WriteBool('Connection', 'Offline', true);
 end else cport.Port:=cprt;
 conn := not ini.ReadBool('Connection', 'Offline', true);
 f_pat.Width := ini.ReadInteger('Pat window', 'width', 500);
 f_pat.height := ini.ReadInteger('Pat window', 'height', 530);
 F_PAT.ShowModal;  Pat:=pat_name;  //num:=strtoint(pt);
 main.Width := ini.ReadInteger('Main window', 'width', 790);
 main.height := ini.ReadInteger('Main window', 'height', 590);
 if ini.ReadString('Main window', 'state', 'normal') = 'normal' then main.WindowState := wsNormal;
 if ini.ReadString('Main window', 'state', 'normal') = 'maximized' then main.WindowState := wsMaximized;
 arcp:=ini.ReadInteger('Backup', 'Period', 1);
 arcd:=ini.readDate('Backup', 'LastDate', now);
 bak_opts := ini.ReadString('Backup', 'Options', '1111');

 ini.free;
 Application.OnException := AppException;
 if arcp>0 then begin
    arcl := trunc(now - arcd);
    if arcl > arcp * 7 then begin
      WriteLog('Архивация не проводилась более '+IntToStr(arcl)+' дней!', 1);
      if MessageBox(handle, PAnsiChar('Архивация не проводилась более '+IntToStr(arcl)+' дней! Начать архивацию сейчас?'), 'Предупреждение об ррхивации', MB_YESNO) = IDYes then Archivate;
    end;
 end;
 if conn then
  Try
    cport.Connected := true;
 Except
    ini := TINIFile.Create(AppDir+'config.ini');
    ini.WriteString('Connection', 'Port', 'COM0');
    ini.WriteBool('Connection', 'Offline', true);
    conn := false;
    PL_STATE.Color := clRed;
    WriteLog('Последовательные порты отсутствуют! Автономный режим!',1);
 end;
 T_TIM.Enabled := conn; Grid.ColWidths[0]:=900; SP_List.ColWidths[0]:=900;
 if conn then begin
    pl_state.Color := clMaroon; pl_state.Caption := 'ВЫКЛ';
 end else begin
    pl_state.Color := clBlack;  pl_state.Caption := '----';
    WriteLog('Включен автономный режим! Диагностические данные будут недоступны.',1);
 end;
end;
//-----------------------------------------------------------------------RECEPT COLOR -------------------
procedure TMain.OnRDrCel(Sender: TObject; vCol, vRow: Integer; Rect: TRect;
  State: TGridDrawState);
var i: integer;
begin
   WITH Sender AS TStringGrid DO begin
     if SW_REC.BevelInner = bvLowered then begin
       if atr[vRow]<2 then Canvas.Font.Color := clNavy else Canvas.Font.Color := clSilver;
       Canvas.Brush.Color := clWindow;
       if (gdSelected IN State) and (Sender=ActiveControl) then begin
          if atr[vRow]<2 then Canvas.Font.Color := clWhite else Canvas.Font.Color := clYellow;
          Canvas.Brush.Color := clMenuHighlight;
       end;
     Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2,Cells[vCol, vRow]);
     end
      else begin
        if atr[vRow]<2 then Canvas.Font.Color := clBlack else Canvas.Font.Color := clSilver;
        Canvas.Brush.Color := clWindow;
        if (gdSelected IN State) and (Sender=ActiveControl) then begin
          if atr[vRow]<2 then Canvas.Font.Color := clWhite else Canvas.Font.Color := clYellow;
          Canvas.Brush.Color := clMenuHighlight;
        end;
        Canvas.TextRect(Rect, Rect.Left+2, Rect.Top+2,Cells[vCol, vRow]);
     end;
  end;
end;
//------------------------------------------------------------------------SPECTR LIST COLOR ---------------
procedure TMain.OnSDrCel(Sender: TObject; wCol, wRow: Integer; Rect: TRect;
  State: TGridDrawState);
begin
  WITH Sender AS TStringGrid DO begin
    if ats[wRow]=2 then begin Canvas.Font.Color := clGreen; Canvas.Font.Style:=[fsBold]; end;
    if ats[wRow]=1 then Canvas.Font.Color := clNavy;
    if ats[wRow]=0 then Canvas.Font.Color := clBlack;
    Canvas.Brush.Color := clWindow;
    if (gdSelected IN State) and (Sender=ActiveControl) then begin
       if ats[wRow]<2 then Canvas.Font.Color := clWhite else Canvas.Font.Color := clYellow;
       Canvas.Brush.Color := clMenuHighlight;
    end;
    Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,Cells[wCol,wRow]);
  end;
end;
//-------------------------------------------------------------------------SPECTR LIST COLOR ---------------
procedure TMain.OnFDrCel(Sender: TObject; WCol, WRow: Integer; Rect: TRect;
  State: TGridDrawState);
begin
    WITH Sender AS TStringGrid DO begin
       Canvas.Brush.Color := clWindow; Canvas.Font.Color := clGreen;
       if (gdSelected IN State) and (Sender=ActiveControl) then begin
         Canvas.Brush.Color := clGreen; Canvas.Font.Color := clWindow;
       end;
       Canvas.TextRect(Rect,Rect.Left+2,Rect.Top+2,Cells[wCol,wRow]);
    end;
end;
//--------------------------------------------------------------- Change LINFO COLOR OnClick --------
procedure TMain.OnSCLick(Sender: TObject);
var tmp : string;
       i: byte;
begin
 i:=0;
 if (ActiveControl=SP_List) or (Sender=SP_menu) or (ActiveControl=SP_Find) then begin
    setMode(MODE_SPEC);
    if (not flblock) and (ActiveControl<>SP_Find)then begin                                           // one specter meter
       if (Srec[1] <> nil) then begin
          tmp :='0x'+Srec[Sp_list.row+1]^.n; SetAddress(StrToInt(tmp));
       end;
    end;
    if (not flblock) and (ActiveControl=SP_Find)then begin                                           // one specter meter
       if (Frec[1] <> nil) then begin
          tmp :='0x'+Frec[Sp_Find.row+1]^.n; SetAddress(StrToInt(tmp));
       end;
    end;
    if ((Sp_list.row<lf) and (ActiveControl=SP_List)) or                           ////
       ((Sp_Find.row<lfl) and (ActiveControl=SP_Find)) then begin                  ////
        Bt_AddS.Enabled:=true; Bt_help.Enabled:=true; hlp_side:=2;
    end else begin
      Bt_AddS.Enabled:=false; Bt_help.Enabled:=false;
    end;
    Linfo.Font.Color:=clGray; Linfo.Text:=Slist_n; Linfo.Text:= Trim(Linfo.Text);
    Linfo.ReadOnly:=true; SB_Time.Enabled:=false; Bt_DelS.Enabled:=false;
 end;
 if (ActiveControl=Grid) then begin
    setMode(mode_l);
    if StrComp(PChar(Rec_W),PChar(R_list.Text))<>0 then begin
       rsa:=0;                                                      ///////      Added 14.08.2012
       for i:=1 to rf do begin                                            //
          if Rec[i]^.sp[5] = 0 then  begin                                //
            inc(rsa);  tmp := '0x'+Rec[i]^.n;                              //
            wr_rec(StrToInt(tmp));                                        //
          end;                                                            //
       end;                                                               //
       Rec_W:=R_list.Text;                                          ///////
    end;
    if rsa > 0 then begin
      if (not flblock) then                                               // one specter meter
         if (rec[1] <> nil) then begin
           tmp :='0x'+rec[grid.row+1]^.n;
           SetAddress(StrToInt(tmp));
         end;
    end;
    if (grid.row<rf) then begin
        tmp:=Rec_n; Linfo.Text:=Trim(tmp);
        Linfo.Font.Color:=clNavy; hlp_side:=1;  SB_Time.Enabled:=true;
        Linfo.ReadOnly:=false; Bt_DelS.Enabled:=true; Bt_help.Enabled:=true;
    end else Bt_help.Enabled:=false;
    Bt_AddS.Enabled:=false;
 end;
end;
//-----------------------------------------------------------------------------<< DUBLCKICK >> ----

procedure TMain.GridDblClick(Sender: TObject);
 var i:integer;
     st:string;
begin
     i:=grid.Row;
     if atr[i]=0 then with grid.Canvas do begin
        atr[i]:=2; Font.Color := clYellow; Brush.Color := clMenuHighlight;
        dec(rsa);
     end else with grid.Canvas do begin
        atr[i]:=0; Font.Color := clWhite; Brush.Color := clMenuHighlight;
        inc(rsa);
     end;
     wr_rec(StrToInt('0x'+rec[grid.row+1]^.n));
     st:=grid.rows[i].Text; st[length(st)-1]:=' '; st[length(st)]:=' ';
     grid.Repaint; chr:=1;
     if (Rec_nam='') then Buttons(1,1,0,1,0) else Buttons(1,1,1,1,1);
end;
//--------------------------------------------------------------------<< ENTER >>-<< SPACE >> ----
procedure TMain.FormKeyPress(Sender: TObject; var Key: Char);
var i:integer;

begin
  if (key = #13) then begin
    if (ActiveControl=Grid) then GridDblClick(Grid);
    if (ActiveControl=SP_List) then OnAddSp(SP_List);
    if (ActiveControl=SP_Find) then OnAddSp(SP_Find);
  end;
  if (key = #32) and Grid.Focused then begin
    if(mode_l=MODE_SPEC) then begin
       setMode(MODE_REC); Grid.Invalidate; mode_l:=MODE_REC;
    end else begin
       setMode(MODE_SPEC); Grid.Invalidate; mode_l:=MODE_SPEC;
    end;
  end;
  if ((key='s') or (key='S') or (key='Ы') or (key='ы')or (key='і') or (key='І')) and (ActiveControl=R_List) and (R_List.Text<>'') then begin
     if (kf=0) then begin
       if(nsel=0) then begin
         SelRList:=TStringList.Create; LabSel.Visible:=True;  N26.Enabled:=true;
       end;
       if((nsel=0) or ((nsel>0) and (SelRList.IndexOf(R_List.Text)=-1))) then begin
         inc(nsel); SelRList.Add(R_List.Text); i:= SelRList.IndexOf(R_List.Text);
         LabSel.Font.Color:=clRed; Label1.Caption:='Удалить:'; LabSel.Caption:=Inttostr(nsel);
       end else if((nsel>0) and (SelRList.IndexOf(R_List.Text)<>-1)) then begin
         dec(nsel); SelRList.Delete(SelRList.IndexOf(R_List.Text));
         LabSel.Font.Color:=clNavy; LabSel.Caption:=Inttostr(nsel);
         if(nsel=0) then begin
            Label1.Caption:='Рецептов:'; LabSel.Caption:=inttostr(R_List.Items.Count);
            LabSel.Font.Color:=clNavy;
            SelRList.Free; N26.Enabled:=False;
         end;
       end;  kf:=1;
     end else kf:=0;
  end;
end;

//------------------------------------------------------------------------------
//========================== Работа с рецептами ================================
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------<< Del Spectr >>---
procedure TMain.DelSRec(Sender: TObject);
var i:integer;
begin
  if (rf>0) then begin
    if rec[grid.Row+1]^.sp[5] = 0 then begin
      dec(rsa);
      wr_rec(StrToInt('0x'+rec[grid.Row+1]^.n));
      WriteLog('Спектр ' + rec[grid.Row+1]^.n + ' удален из рецепта!',0);
    end;
    for i:=grid.Row to rf-1 do begin
        atr[i]:=atr[i+1]; grid.Rows[i].Text:=grid.Rows[i+1].Text; Rec[i+1]:=Rec[i+2];
    end;
    grid.Rows[rf-1].Clear; Rec[rf]:=nil; dec(rf); grid.RowCount:=rf;
  end;
  Chr:=1;  if (Rec_nam='') then Buttons(0,1,0,1,0) else Buttons(0,1,1,1,1);
  if (rf=0) then Buttons(0,0,0,0,0);
end;
//--------------------------------------------------------------------------------<< Clear Rec >>---
procedure TMain.ClearRec(Sender: TObject);
var i:integer;
 BuffOn, BuffOff : array[1..6] of char;
begin
   for i:=1 to rf do begin
     dispose(Rec[i]); Rec[i]:=nil; atr[i-1]:=0; grid.Rows[i-1].Clear;
   end;
   rf:=0; grid.RowCount:=1;  Rec_n:=readarr(''); Linfo.Text:=Rec_n;
   rsa := 0; Buttons(0,0,0,0,0);                                              ////
   byteru := byteru or $02;
   BuffOn[1] := 'O';   BuffOn[2] := Char($20);   BuffOn[3] := char(byteru);
   BuffOn[4] := '3';   BuffOn[5] := '3';         BuffOn[6] := Char($40);
   If conn then main.cport.write(buffOn,6);
   Sleep(1); byteru := byteru and $FD;
   BuffOff[1] := '3';  BuffOff[2] := '3';        BuffOff[3] := char($BF);
   BuffOff[4] := 'O';  BuffOff[5] := Char($20);  BuffOff[6] := Char(byteru);
   if conn then main.cport.Write(buffoff, 6);
   setMOde(MODE_SPEC); WriteLog('Рецепт очищен', 0);
   SetAddress(1);
end;
//----------------------------------------------------------------------------<< Add Spectr >>---
procedure TMain.OnAddSp(Sender: TObject);
var i,x:integer;
begin
 if rf<40 then begin
  if (srec[1]<>nil) and (indx<3) then begin
    x:=0; for i:=1 to rf do if rec[i]^.n=Srec[Sp_list.row+1]^.n then x:=1;
    if (x=0) then begin//and (Srec[Sp_list.row+1]^.sp[5]<2) then begin
      inc(rf); new(Rec[rf]); atr[rf]:=0; Rec[rf]^.nam:=Srec[Sp_list.row+1]^.nam;
      Rec[rf]^.n:=Srec[Sp_list.row+1]^.n; Rec[rf]^.ns:=Srec[Sp_list.row+1]^.ns;
      Rec[rf]^.sp:=Srec[Sp_list.row+1]^.sp;
      Grid.Rows[rf-1].Text:=SP_List.Rows[Sp_list.row].Text; grid.RowCount:=rf;  Chr:=1;
      inc(rsa); if(Rec_nam='') then Buttons(0,1,0,1,0) else Buttons(0,1,1,1,1);
      Linfo.ReadOnly:=true; SB_Time.Enabled:=false;
      wr_rec(StrToInt('0x'+Srec[Sp_list.row+1]^.n));
    end else ShowMessage('Спектр присутствует в рецепте');
  end;
  if (Frec[1]<>nil) and (indx=3) then begin
    x:=0; for i:=1 to rf do if rec[i]^.n=Frec[Sp_Find.row+1]^.n then x:=1;
    if (x=0) then begin //and (Frec[Sp_Find.row+1]^.sp[5]<2) then begin
      inc(rf); new(Rec[rf]); atr[rf]:=0; Rec[rf]^.nam:=Frec[Sp_Find.row+1]^.nam;
      Rec[rf]^.n:=Frec[Sp_Find.row+1]^.n; Rec[rf]^.ns:=Frec[Sp_Find.row+1]^.ns;
      Rec[rf]^.sp:=Frec[Sp_Find.row+1]^.sp;
      Grid.Rows[rf-1].Text:=SP_Find.Rows[Sp_Find.row].Text; grid.RowCount:=rf;  Chr:=1;
      inc(rsa); if(Rec_nam='') then Buttons(0,1,0,1,0) else Buttons(0,1,1,1,1);
      Linfo.ReadOnly:=true; SB_Time.Enabled:=false;
      wr_rec(StrToInt('0x'+Frec[Sp_Find.row+1]^.n));
      WriteLog('Спектр ' + Frec[SP_Find.Row+1]^.n + ' добавлен в рецепт',0);
    end else ShowMessage('Спектр присутствует в рецепте');
  end;
 end else ShowMessage('Превышен лимит (40) спектров в рецепте');
end;
//---------------------------------------------------------------------------- Edit Anotation ---
procedure TMain.OnChR_n(Sender: TObject);
begin
  if ActiveControl=Linfo then begin
     Rec_n:=readarr(main.Linfo.Text); Chr:=1;
     if (rf>0) then (if(Rec_nam='') then Buttons(0,1,0,1,0) else Buttons(0,1,1,1,1));
  end;
end;
//-----------------------------------------------------------------------------Запись рецепта---
procedure WrRec(R_n:string;k:byte);
var fl,i,n,j:integer;
    sss:string[5];

begin
  ssp:='';
  if k=0 then begin
    case MessageDlg('Рецепт изменен. Сохранить?',mtConfirmation, [mbYes, mbNo] ,0) of
    MrYes : k:=1;
    end;
  end;
  if k>0 then begin
    for i:=1 to rf do begin               //формируется запись i-го спектра
      sss:='00000';
      for j:=1 to 5 do sss[j]:=Char(Rec[i]^.sp[j]);
      if atr[i-1]=0 then sss[5]:='+' else sss[5]:='-'; ssp:=ssp+sss;
    end;
    sdesc:=trim(main.Linfo.Text);
    for j:=1 to Length(sdesc) do begin
     if sdesc[j]='''' then sdesc[j]:='`'; if sdesc[j]='"' then sdesc[j]:='`';
    end;
    if (R_n='') then begin
      n:=Main.SortFrec(Main); R_n:=SetRNam(n+1);
      sql:='INSERT INTO T_REC (pid,rnum,md,desc,sp) VALUES ('+inttostr(pnum);
      sql:=sql+',"'+R_n+'","'+DateToStr(Now)+'","'+UTF8Encode(sdesc)+'","'+ssp+'")';
    end else begin
      sql:='UPDATE T_REC SET md="'+DateToStr(Now)+'",desc="'+UTF8Encode(sdesc)+'",sp="'+ssp+'"';
      sql:=sql+' WHERE pid='+inttostr(pnum)+' AND rnum="'+R_n+'"';
    end;
    db:=TSqliteDatabase.Open(Dir+'DB\BIO_REC.DB3');
    db.ExecSQL(sql); sql:='COMMIT'; db.ExecSQL(sql); db.Free;
    sql:='UPDATE T_PAT SET LD="'+DateToStr(Now)+'" WHERE ID='+inttostr(pnum);
    db:=TSqliteDatabase.Open(Dir+'DB\BIO_PAT.DB3');
    db.ExecSQL(sql); db.Commit; db.Free;
    MessageDlg('Рецепт сохранен.',mtInformation, [mbOk] ,0);
    Main.Caption:='Пациентов: '+inttostr(F_Pat.list.Items.Count)+'.  Пациент: № '+pat_name+' '+Main.Pat_FIO+'   Последний визит: '+DateToStr(Now);
  end; chr:=0;
end;
//------------------------------------------------------------------------ Имя REC-ФАЙЛА ----------
function SetRNam(num: integer):string;
var st:string;
begin
  st:=inttostr(num); while length(st)<3 do st:='0'+st;  Result:=st;
end;
//-----------------------------------------------------------------СОРТИРОВКА REC-ФАЙЛОВ ----------
function TMain.SortFRec(Sender: TObject):integer;
var  i,kk:integer;
    st,stt:string;
begin
   if R_List.Items.Count>0 then begin
      db:=TSqliteDatabase.Open(dir+'DB\BIO_REC.db3'); kk:=0;
      for i:=1 to R_List.Items.Count do begin
        st:=R_List.Items.Strings[i-1];
        stt:=inttostr(i); while length(stt)<3 do stt:='0'+stt;
        if st<>stt then begin
          sql:='UPDATE T_REC SET rnum="'+stt+'" WHERE pid='+inttostr(pnum)+' AND rnum="'+st+'"';
          db.ExecSQL(sql);
        end;  inc(kk);
      end;
      db.Commit; db.Free; ClearRec(Sender);
      Result:=kk;
      if(nsel>0) then begin
        N26.Enabled:=false; nsel:=0; SelRList.Free;
        Label1.Caption:='Рецептов:'; LabSel.Caption:=inttostr(R_List.Items.Count);
        LabSel.Font.Color:=clNavy;
      end;
   end else Result:=0;
end;
//-----------------------------------------------------------------------Кл. меню -Сохранить------------
procedure TMain.SavRec(Sender: TObject);
begin
   if Rec_nam<>'' then begin
     WrRec(Rec_nam,1); Buttons(1,1,1,0,0);
     if Sender<>Bt_DelS then Bt_DelS.Enabled:=false; Bt_AddS.Enabled:=false;
   end;
end;
//-----------------------------------------------------------------------Кл. меню -Сохранить-как--------
procedure TMain.SavAs(Sender: TObject);
var n:integer;
begin
    WrRec('',1); ReadRecList(pnum);
    R_List.ItemIndex:=R_List.Items.Count-1; ShRec(R_list.Text); chr:=0;
    Buttons(1,1,1,0,0);
    if Sender<>Bt_DelS then Bt_DelS.Enabled:=false; Bt_AddS.Enabled:=false;
end;
//----------------------------------------------------------------------Кл. меню -Удалить-------------
procedure TMain.DelRec(Sender: TObject);
var stt: string;
begin
  if (Rec_nam<>'') and (MessageDlg('Удалить рецепт?',mtConfirmation,
     [mbYes,MbNo],0)=MrYes) then begin
     if ((nsel>0) and (SelRList.IndexOf(R_List.Text)<>-1)) then begin
       SelRList.Delete(SelRList.IndexOf(R_List.Text));
       dec(nsel); LabSel.Font.Color:=clNavy; LabSel.Caption:=inttostr(nsel);
       if (nsel=0) then begin
         N26.Enabled:=false;  SelRList.Free;
         Label1.Caption:='Рецептов:'; LabSel.Caption:=inttostr(R_List.Items.Count);
       end;
     end;
     sql:='DELETE FROM T_REC WHERE pid='+inttostr(pnum)+' AND rnum="'+Rec_nam+'"';
     db:=TSqliteDatabase.Open(dir+'DB\BIO_REC.db3');
     db.ExecSQL(sql); db.Commit; db.Free;                  //Затирание в базе
     R_List.Items.Delete(R_List.Items.IndexOf(R_List.Text));
     WriteLog('Рецепт ' + Rec_nam + ' удален', 0);
     ClearRec(Sender);
     if Sender<>Bt_DelS then Bt_DelS.Enabled:=false; Bt_AddS.Enabled:=false;
     Rec_nam:=''; Buttons(0,0,0,0,0);
  end;
end;
//--------------------------------------------------------------------------<<  HOT KEYS >>------------------
procedure TMain.FormKeyDown(Sender:TObject;var Key: Word;Shift: TShiftState);
const VK_S = 83;
begin
 case key of
       VK_S :if (ssCtrl in Shift) then  begin
               if (ssShift in Shift) then begin           //Save recept as new
                  SavAs(SavAs_MNU); key:=0; exit;
               end;
               WrRec(Rec_n,1); key:=0;                    // Save recept
             end;
       VK_F1: if (ssCtrl in Shift) then begin
                 SP_TAB.TabIndex := 0;
                 OnChPage(Sender);
                 SP_MENU.Selected := SP_MENU.Items.Item[0];
                 SP_MenuClick(SP_MENU AS TObject);
                 ActiveControl := SP_MENU;
              end;
       VK_F2: if (ssCtrl in Shift) then begin
                 SP_TAB.TabIndex := 1;
                 OnChPage(Sender);
                 SP_MENU.Selected := SP_MENU.Items.Item[0];
                 SP_MenuClick(SP_MENU AS TObject);
                 ActiveControl := SP_MENU;
              end;
       VK_F3: if (ssCtrl in Shift) then begin
                 SP_TAB.TabIndex := 2;
                 OnChPage(Sender);
                 SP_MENU.Selected := SP_MENU.Items.Item[0];
                 SP_MenuClick(SP_MENU AS TObject);
                 ActiveControl := SP_MENU;
              end;
       VK_F4: if (ssCtrl in Shift) then begin
                 SP_TAB.TabIndex := 3;
                 OnChPage(Sender);
                 ActiveControl := ED_find;
              end;
  VK_DELETE :begin
               if (ssCtrl in Shift) then begin            //Delete recept
                  DelRec(Del_MNU); exit;
               end;
               if ActiveControl=Grid then DelSRec(grid);  //Delete spectr
             end;
     VK_LEFT:Begin
               if (ActiveControl=SP_List) or (ActiveControl=SP_Find) then ActiveControl := Grid;
             end;
    VK_RIGHT:Begin
               if (ActiveControl=grid) and (SP_TAB.TabIndex<3) then ActiveControl := Sp_List;
               if (ActiveControl=grid) and (SP_TAB.TabIndex=3) then ActiveControl := Sp_Find;
             end;
 end;
end;
//---------------------------------------------------------------------------
procedure TMain.OnClose(Sender: TObject);
var i:integer;
begin
  if (Rec_nam<>'') and (Chr=1) then WrRec(Rec_nam,0);
  ClearRec(Sender); clrlist(); for i:=1 to nl do dispose(Lrec[i]);
   main.Close;
end;
//---------------------------------------------------------------------------
procedure TMain.OnPrint(Sender: TObject);
begin
  F_Print.ShowModal;
end;
//---------------------------------------------------------------------------
procedure TMain.OnInfo(Sender: TObject);
begin
  PatEDT.showmodal;
end;
//---------------------------------------------------------------------------
procedure TMain.OnHelp(Sender: TObject);
begin
   F_Help.ShowModal;
end;
//---------------------------------------------------------------------------
procedure TMain.EboutBIO(Sender: TObject);
begin
      aboutbox.ShowModal;
end;
//------------------------------------------------------------------- ПОИСК СПЕКТРОВ --------
procedure TMain.OnFind(Sender: TObject);
var ff,i,kk,lf,j,n:integer;
       rc:SpRec;
       stt,ss: string;
begin
  ClrFind;  lfl:=0;
  db := TSqliteDatabase.Open(dir+'DB\BIO_SP.db3');
  stt:=Ed_Find.Text; ss:=AnsiUpperCase(stt); stt[1]:=ss[1];
  sql:='SELECT * FROM T_SP WHERE (nam LIKE "%'+UTF8Encode(Ed_Find.Text)+'%") OR (nam LIKE "%'+UTF8Encode(stt)+'%")';
  res:=TSqliteQueryResults.Create(db, sql); i:=1; lfl:=0;
  while not res.Eof do begin
    ssp:=res.FieldAsString(1); for j:=1 to 4 do char(sp[j]):=ssp[j];
    sp[5]:=0;
    new(FRec[i]); FRec[i]^.sp:=sp; n:=strhex(sp); ats[i-1]:=sp[5];
    FRec[i]^.n:=res.FieldAsString(2);
    FRec[i]^.nc:=res.FieldAsString(3);
    FRec[i]^.ns:=res.FieldAsString(4);
    FRec[i]^.nam:=UTF8Decode(res.FieldAsString(5));
    inc(i); inc(lfl); res.Next;
  end; res.Free; db.Free;
  SP_Find.RowCount:=lfl;
  for i:=1 to lfl do
      main.SP_Find.Rows[i-1].Add(FRec[i]^.nc+FRec[i]^.ns+' '+FRec[i]^.nam);
end;
//---------------------------------------------------------------------------
procedure TMain.OnSortFiles(Sender: TObject);
var n: integer;
begin
    n:=SortFrec(Sender); ReadRecList(pnum);
end;
//---------------------------------------------------------------------------
procedure working(var c:char);
var b, value, oldvalue : byte;
state, oldstate : boolean;
buff : array[1..3] of char;
begin
   Application.ProcessMessages;
   char(b) := c;
   state := bool(b shr 7);
   if (state and not oldstate) then begin
      oldstate := true;
      flStartMeasureNK := true;
   end;
   if (F_Nak.Visible) then begin
      if (flStartMeasureNK and not flMeasureNK) then begin
         flMeasureNK := true;
         byteru := byteru or $08;
         buff[1] := 'O'; buff[2] := Char($20);  buff[3] := Char(byteru);
         if conn then main.cport.Write(buff, 3);
      end;
      if (flMeasureNK) then begin
         sumNK := sumNK + value;
         if (count_nk = 99) then begin
            count_nk := 0;
            flMeasureNK := false; flStartMeasureNK := false;
            ExecuteNK(sumNK div 100);
            byteru := byteru and $F7;
            buff[1] := 'O'; buff[2] := Char($20);  buff[3] := Char(byteru);
            if conn then main.cport.Write(buff, 3);
            sumNK := 0;
            exit;
         end;
      inc(count_nk);
      end;
   end;
   if (not state) then oldstate := false;
   if (not state) then  begin
      main.pl_state.color:=$7BFF00;
      main.PL_STATE.Font.Color := clBlack;
      main.pl_state.caption:= 'ВКЛ';
      flblock := false;
    end else begin
       main.pl_state.color:=clMaroon;
       main.PL_STATE.Font.Color := clWhite;
       main.pl_state.caption:= 'ВЫКЛ';
       flblock := true;
    end;
   value := b and $7F;
   if (value>100) then value:=100;
    if (value <> oldvalue) then begin
      main.pr_val.position := value;
      main.pl_val.Caption := IntToStr(value);
      oldvalue:=value;
    end;
end;
//---------------------------------------------------------------------------
procedure TMain.cportRxChar(Sender: TObject; Count: Integer);
var
  buffstr:string;
  i : byte;
  rb: integer;
begin
  rb:=cport.ReadStr(buffstr, Count);
  if (rb>0) then for i:=1 to rb do  working(buffstr[i]);
end;
//---------------------------------------------------------------------------
procedure setMode(const bMode : boolean);
var buff : array[1..3] of char;
begin
  mode:=bmode; byteru:=$80;
  buff[1]:='O'; buff[2]:=Char($20); buff[3]:=Char($80);
  if (not bMode) then begin
     byteru:=byteru or $10;
     main.SW_SPEC.Font.Style:=[fsBold]; //Specter mode (false)
     main.SW_REC.Font.Style:=[];
     main.SW_SPEC.BevelInner:=bvLowered;
     main.SW_SPEC.BevelOuter:=bvLowered;
     main.SW_REC.BevelInner:=bvRaised;
     main.SW_REC.BevelOuter:=bvRaised;
     main.SW_SPEC.Font.Color:=clWhite;
     main.SW_SPEC.Color:=clGray;
     main.SW_REC.Color:=clBtnFace;
     main.SW_REC.Font.Color:=clNavy;
     DebugDev('Установлен режим "Спектр"');
  end
    else begin
      byteru := byteru or $20;
      main.SW_REC.Font.Style := [fsBold]; //Receipt mode (true)
      main.SW_SPEC.Font.Style:=[];
      main.SW_REC.BevelInner:=bvLowered;
      main.SW_REC.BevelOuter:=bvLowered;
      main.SW_SPEC.BevelInner:=bvRaised;
      main.SW_SPEC.BevelOuter:=bvRaised;
      main.SW_REC.Font.Color:=clWhite;
      main.SW_REC.Color:=clNavy;
      main.SW_SPEC.Color:=clBtnFace;
      main.SW_SPEC.Font.Color:=clBlack;
      DebugDev('Установлен режим "Рецепт"');
    end;
  buff[3]:=Char(byteru);
  if conn then main.cport.Write(buff,3);
end;
//---------------------------------------------------------------------------
procedure TMain.T_TIMTimer(Sender: TObject);
var hr, min, sec, msec, wr : word;
    dt : TDateTime;
    buff : array [1..9] of char;
begin
    dt:=now; DecodeTime(dt, hr, min, sec, msec);
    buff[1]:='O';   buff[2]:=Char($34);   buff[3]:=Char($AA);
    buff[4]:='O';   buff[5]:=Char($30);   buff[6]:=Char(sec div 10 or $A0);
    buff[7]:='O';   buff[8]:=Char($2C);   buff[9]:=Char(sec mod 10 or $40);
    if conn then wr:=cport.Write(buff, 9);
end;
//--------------------------------------------------------------------- ЗАПИСЬ КОНФИГУРАЦИИ ------
procedure TMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var state : string;
begin
  cport.Connected:=false;
  ini:= TINIFile.Create(AppDir+'config.ini');
  ini.WriteInteger('Pat window','width',f_pat.Width);
  ini.WriteInteger('Pat window','height',f_pat.height);
  if main.WindowState = wsNormal then begin
    state := 'normal';
    ini.WriteInteger('Main window','width',main.Width);
    ini.WriteInteger('Main window','height',main.height);
  end;
  if main.WindowState = wsMaximized then state := 'maximized';
  ini.WriteString('Main window', 'state', state);
  ini.Free;
  DeleteFile(appdir + 'RPT.HTML');
end;
//-------------------------------------------------------------------- РЕЖИМ "СПЕКТР" -------
procedure TMain.SW_SPECClick(Sender: TObject);
begin
  setMode(MODE_SPEC); Grid.Invalidate; mode_l:=MODE_SPEC;
end;
//-------------------------------------------------------------------- РЕЖИМ "РЕЦЕПТ" -------
procedure TMain.SW_RECClick(Sender: TObject);
begin
  setMode(MODE_REC); Grid.Invalidate; mode_l:=MODE_REC;
end;
//-------------------------------------------------------------------- Конфигурация СОМ ---------
procedure TMain.SetCOMClick(Sender: TObject);
begin
  F_Cfg.Show;
end;
//--------------------------------------------------------------------- Выбор пациента --------------
procedure TMain.Bt_PatClick(Sender: TObject);
begin
  if chr>0 then WrRec(Rec_nam,0);
  f_pat.showmodal; Pat:=pat_name; ClearRec(Sender);
  Chr:=0;  Bt_DelS.Enabled:=false; Bt_Sav.Enabled:=false;
end;
// ----------------------------------------------------------------------- ---------------------
procedure TMain.Button1Click(Sender: TObject);
begin
  PatEdt.showmodal;
end;
 // --------------------------------------------------------------------- FORM RESIZE -----------
procedure TMain.FormResize(Sender: TObject);
begin
   GroupBox1.Width:=round(Main.Width*0.415);
   GroupBox2.Left:=GroupBox1.Width+16;
   GroupBox2.Width:=Main.Width-GroupBox1.Width-40;
   Bt_Pat.Left:=GroupBox1.Width+31;
   Bt_Pinfo.Left:=Bt_Pat.Left+173;
end;
// ---------------------------------------------------------------------------------------------
procedure TMain.SP_MenuClick(Sender: TObject);
begin
  clrlist(); GroupBox2.Caption:='Спектры';
  if main.SP_Menu.SelectionCount>0 then begin
    if LRec[main.SP_Menu.Selected.AbsoluteIndex+1]^.sp='1' then begin
      ShSp(LRec[main.SP_Menu.Selected.AbsoluteIndex+1]^.num);
      OnSCLick(SP_Menu);
    end;
    Slist_n:=LRec[main.SP_Menu.Selected.AbsoluteIndex+1]^.dsc;
  end;
end;
// ------------------------------------------------------------------ Listing SP on Ch MENU ----
procedure TMain.SP_MenuKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if main.SP_Menu.SelectionCount>0 then begin
      if (key=40) and (main.SP_Menu.Selected.AbsoluteIndex<nl-1) then begin       //DOWN
        clrlist(); GroupBox2.Caption:='Спектры';
        if LRec[main.SP_Menu.Selected.AbsoluteIndex+2]^.sp='1' then begin
          Slist_n:=LRec[main.SP_Menu.Selected.AbsoluteIndex+2]^.dsc;
          ShSp(LRec[main.SP_Menu.Selected.AbsoluteIndex+2]^.num);
          OnSCLick(SP_Menu);
        end;
      end;
      if (key=38) and (main.SP_Menu.Selected.AbsoluteIndex>0) then  begin         //UP
        clrlist(); GroupBox2.Caption:='Спектры';
        if LRec[main.SP_Menu.Selected.AbsoluteIndex]^.sp='1' then begin
          Slist_n:=LRec[main.SP_Menu.Selected.AbsoluteIndex]^.dsc;
          ShSp(LRec[main.SP_Menu.Selected.AbsoluteIndex]^.num);
          OnSCLick(SP_Menu);
        end;
      end;
   end;
end;
// -------------------------------------------------------------------- Spectr >> BIOCORID  ----
procedure SetAddress(addr : integer);
var buff : array[1..6] of char;
begin
   if rsa > 0 then addr:=addr or $8000;
   buff[1]:='O'; buff[2]:=char($24);  buff[3]:=char(addr);
   buff[4]:='O'; buff[5]:=char($28);  buff[6]:=char(addr shr 8);
   if conn then main.cport.Write(buff, 6);
   DebugDev('Запись спектра '+IntToStr(addr)+' буфер: '+buff);
end;
// -------------------------------------------------------------------- Receipt >> BIOCORID ----
procedure Wr_Rec(addr: integer);
var temp : byte;
    BuffOn, BuffOff : array[1..6] of char;
begin
  SetAddress(addr);
  temp:=byteru;  byteru := byteru or $40;  byteru:=byteru and $EF;
  BuffOn[1]:='O'; BuffOn[2]:=Char($20); BuffOn[3]:=char(byteru);
  BuffOn[4]:='3'; BuffOn[5]:='3';       BuffOn[6]:=Char($40);
  If conn then main.cport.write(buffOn,6);
  Sleep(1); byteru := temp;  byteru := byteru and $BF;
  BuffOff[1]:='3';   BuffOff[2]:='3';        BuffOff[3]:=char($BF);
  BuffOff[4]:='O';   BuffOff[5]:=Char($20);  BuffOff[6]:=Char(byteru);
  if conn then main.cport.Write(buffoff,6);
end;
// --------------------------------------------------------------------- ARCHIVATION -----------
procedure TMain.N21Click(Sender: TObject);
begin
   Archivate;
end;
// ---------------------------------------------------------------------------------------------
procedure TMain.OnSB_Time(Sender: TObject);
begin
   if length(Linfo.Text)<68 then begin
     Linfo.Text:= DateToStr(Now)+'- '+Linfo.Text; chr:=1;
     if((rf>0)) then begin
       if(Rec_nam='') then Buttons(0,1,0,1,0) else Buttons(0,1,1,1,1);
     end;
   end;
end;
// ---------------------------------------------------------------------------------------------

procedure TMain.N24Click(Sender: TObject);
var buff : array[1..3] of char;
begin
  byteru:=byteru or $04;
  buff[1]:='O';   buff[2]:=Char($20);  buff[3]:=Char(byteru);
  if conn then cport.Write(buff, 3);
  f_nak.showmodal;  count_nk:=0;  flMeasureNK:=false;  sumNK:=0;
  byteru:=byteru and $FB;  buff[2]:=Char(byteru);
  if conn then cport.Write(buf, 3);

end;
// ---------------------------------------------------------------------------------------------
procedure TMain.N3Click(Sender: TObject);
begin
  f_log.Show;
end;
// ---------------------------------------------------------------------------------------------
procedure TMain.Ed_FindExit(Sender: TObject);
begin
  Bt_Find.Default:=false;
end;
// ---------------------------------------------------------------------------------------------
procedure TMain.N25Click(Sender: TObject);
begin
  F_Hlp.Show;
end;
// ---------------------------------------------------------------------------------------------
procedure TMain.OnDelSelRec(Sender: TObject);
var
 i:integer;
 stt:string;
begin
  if (nsel>0) and (MessageDlg('Удалить выбранные рецепты?',mtConfirmation,[mbYes,MbNo],0)=MrYes) then
    db:=TSqliteDatabase.Open(dir+'DB\BIO_REC.db3');
    db.BeginTransaction;
    for i:=0 to nsel-1 do begin
      sql:='DELETE FROM T_REC WHERE pid='+inttostr(pnum)+' AND rnum="'+SelRList[i]+'"';
      db.ExecSQL(sql);                                                          //Затирание в базе
      R_List.Items.Delete(R_List.Items.IndexOf(SelRList[i]));
      WriteLog('Рецепт ' + stt + ' удален', 0); 
    end;
    db.Commit; db.Free; ClearRec(Sender);
    N26.Enabled:=false; Bt_AddS.Enabled:=false;
    Rec_nam:=''; Buttons(0,0,0,0,0); nsel:=0; LabSel.Visible:=False; SelRList.Free;
end;
// ---------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------------------------

end.
