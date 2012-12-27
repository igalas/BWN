unit WRec_cfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Registry, INIFiles, ComCtrls, TabNotBk, ExtCtrls, Spin,
  CheckLst;

type
  TF_Cfg = class(TForm)
    BTN_OK: TButton;
    TabbedNotebook1: TTabbedNotebook;
    Label1: TLabel;
    CMB_COM: TComboBox;
    Bevel1: TBevel;
    Label2: TLabel;
    Label4: TLabel;
    LB_LASTARCDATE: TLabel;
    BTN_ARCNOW: TButton;
    LB_DAYS: TLabel;
    LB_ARCNOW: TLabel;
    CH_OFF: TCheckBox;
    SP_ARCPERIOD: TSpinEdit;
    Label5: TLabel;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    CH_N_INFO: TCheckBox;
    Image2: TImage;
    CH_N_WARN: TCheckBox;
    Image3: TImage;
    CH_N_ERR: TCheckBox;
    Image4: TImage;
    CH_N_DEBUG: TCheckBox;
    Image5: TImage;
    CH_N_DEV: TCheckBox;
    CH_INFO: TCheckBox;
    CH_WARN: TCheckBox;
    CH_ERR: TCheckBox;
    CH_DEBUG: TCheckBox;
    CH_DEV: TCheckBox;
    IMGC: TImage;
    list_bak: TCheckListBox;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CmbOldPat: TComboBox;
    ChBI: TCheckBox;
    Label8: TLabel;
    procedure BTN_OKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BTN_ARCNOWClick(Sender: TObject);
    procedure CH_DEBUGClick(Sender: TObject);
    procedure CH_DEVClick(Sender: TObject);
    procedure CH_INFOClick(Sender: TObject);
    procedure CH_WARNClick(Sender: TObject);
    procedure CH_ERRClick(Sender: TObject);
    procedure CMB_COMDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure Button1Click(Sender: TObject);
    procedure list_bakClickCheck(Sender: TObject);
    procedure OnPatold(Sender: TObject);
    procedure OnVI(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Cfg: TF_Cfg;
  reg  : TRegistry;
  ini  : TINIFile;

implementation

uses WRec_main, Wrec_log, WPat_main;

{$R *.dfm}
//-------------------------------------------------------------------------------
//-------------------------------------------------------------------------------
procedure TF_Cfg.BTN_OKClick(Sender: TObject);
var i : integer;
begin
  // Save setings
  ini := TIniFile.Create(AppDir+'config.ini');
  if (cmb_com.items.Count < 1) then ini.WriteString('Connection', 'Port', 'COM0')
    else ini.WriteString('Connection', 'Port', CMB_COM.Text);

  conn := not CH_OFF.Checked;
  ini.WriteBool('Connection', 'Offline', CH_OFF.Checked);

  ini.WriteInteger('Pat window','pat_old',pat_old);

  ini.WriteInteger('Backup', 'Period', SP_ARCPERIOD.Value);
  for i:=1 to 4 do
     if (list_bak.Checked[i]) then bak_opts[i] := '1' else bak_opts[i] := '0';
  ini.WriteString('Backup', 'Options', bak_opts);
  ini.WriteInteger('Backup', 'VI', vi);

  ini.WriteBool('Log window', 'sInfo', ch_n_info.Checked); opts[0] := ch_n_info.Checked;
  ini.WriteBool('Log window', 'sWarn', ch_n_warn.Checked); opts[1] := ch_n_warn.Checked;
  ini.WriteBool('Log window', 'sErr', ch_n_err.Checked); opts[2] := ch_n_err.Checked;
  ini.WriteBool('Log window', 'sDebug', ch_n_debug.Checked); opts[3] := ch_n_debug.Checked;
  ini.WriteBool('Log window', 'sDev', CH_N_DEV.Checked); opts[4] := CH_N_DEV.Checked;

  ini.WriteBool('Log window', 'Debug', ch_debug.Checked); opt[3] := ch_debug.Checked;
  ini.WriteBool('Log window', 'DevDebug', ch_dev.Checked); opt[4] := ch_dev.Checked;
  ini.WriteBool('Log window', 'Info', ch_info.Checked); opt[0] := ch_info.Checked;
  ini.WriteBool('Log window', 'Warn', ch_warn.Checked); opt[1] := ch_warn.Checked;
  ini.WriteBool('Log window', 'Err', ch_err.Checked); opt[2] := ch_err.Checked;

  ini.free;

  // Applying settings
  main.cport.Connected := false;
  main.T_TIM.Enabled:= false;
  if conn then
    if CMB_COM.ItemIndex >= 0 then begin
      main.cport.port := CMB_COM.Text;
      main.cport.Connected := true;
      main.T_TIM.Enabled := true;
    end;

  if conn then begin
    main.pl_state.Color := clMaroon;
    main.pl_state.Caption := 'ВЫКЛ';
  end else begin
    main.pl_state.Color := clBlack;
    main.pl_state.Caption := '----';
  end;
  WriteLog('Настройки сохранены', 0);
  close;
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.FormShow(Sender: TObject);
var i,Y: integer;
   dt: TDateTime;
   hw: word;
   com : string;
   portlist : TStringList;
begin
  CMB_COM.Clear;
  portlist := TStringList.Create;
  reg := TRegistry.Create;
  reg.RootKey := HKEY_LOCAL_MACHINE;
  reg.OpenKey('Hardware\DeviceMap\SerialComm', false);
  reg.GetValueNames(portlist);
  for i:=0 to portlist.Count-1 do
      if (pos('COM', reg.ReadString(portlist[i])) = 1) then
         CMB_COM.Items.Add(reg.ReadString(portlist[i]));
  reg.Free;
  portlist.Free;

  ini := TIniFile.Create(AppDir+'config.ini');

  if (CMB_COM.Items.Count > 0) then begin
      com := ini.ReadString('Connection', 'Port', 'COM0');
      if com <> 'COM0' then CMB_COM.ItemIndex := CMB_COM.Items.IndexOf(com)
        else CMB_COM.ItemIndex := 0;
      CH_OFF.Checked := ini.ReadBool('Connection', 'Offline', true);
    end
    else begin
      CMB_COM.Enabled := false;
      CH_OFF.Checked := true;
      CH_OFF.Enabled := false;
    end;

  SP_ARCPERIOD.Value := ini.ReadInteger('Backup','Period', 0);
  LB_LASTARCDATE.Caption := DateToStr(ini.ReadDate('Backup', 'Lastdate', now));
  bak_opts := ini.ReadString('Backup', 'Options', '1111');
  vi:= ini.ReadInteger('Backup','VI', 1);

  for i:=1 to 4 do
    list_bak.Checked[i] := boolean(StrToInt(bak_opts[i]));
  list_bak.Checked[0] := true;
  list_bak.ItemEnabled[0] := false;

  CH_INFO.Checked := ini.ReadBool('Log window', 'Info', false);
  CH_N_INFO.Checked := ini.ReadBool('Log window', 'sInfo', false);

  CH_WARN.Checked := ini.ReadBool('Log window', 'Warn', false);
  CH_N_WARN.Checked := ini.ReadBool('Log window', 'sWarn', false);

  CH_ERR.Checked := ini.ReadBool('Log window', 'Err', false);
  CH_N_ERR.Checked := ini.ReadBool('Log window', 'sErr', false);

  ch_debug.Checked := ini.ReadBool('Log window', 'Debug', false);
  CH_N_DEBUG.Checked := ini.ReadBool('Log window', 'sDebug', false);

  ch_dev.Checked := ini.ReadBool('Log window', 'DevDebug', false);
  CH_N_DEV.Checked := ini.ReadBool('Log window', 'sDev', false);

  if (not ch_debug.Checked) then begin
     ch_n_debug.Enabled := false;
     ch_n_debug.Checked := false;
  end else ch_n_debug.Enabled := true;

  if (not ch_dev.Checked) then begin
     ch_n_dev.Enabled := false;
     ch_n_dev.Checked := false;
  end else ch_n_dev.Enabled := true;

  if (not ch_err.Checked) then begin
     ch_n_err.Enabled := false;
     ch_n_err.Checked := false;
  end else ch_n_err.Enabled := true;

  if (not ch_warn.Checked) then begin
     ch_n_warn.Enabled := false;
     ch_n_warn.Checked := false;
  end else ch_n_warn.Enabled := true;

  if (not ch_info.Checked) then begin
     ch_n_info.Enabled := false;
     ch_n_info.Checked := false;
  end else ch_n_info.Enabled := true;

  ini.Free;

  dt:=StrToDate(LB_LASTARCDATE.Caption);
  dt := now - dt;
  hw := Trunc(dt);
  if(vi=1) then ChBI.Checked:=true else ChBI.Checked:=false;
  LB_DAYS.Caption:='('+IntToStr(hw) + ' дней назад)';
  if (hw >= SP_ARCPERIOD.Value*7) then begin
    LB_LASTARCDATE.Font.Color:=clRed;
    LB_DAYS.Font.color:=clRed;
    LB_ARCNOW.Show;
    TabbedNotebook1.Pages[1]:= 'Архивация(!)';
  end else
    begin
     LB_LASTARCDATE.Font.Color:=clGreen;
     LB_Days.Font.Color:=clGreen;
     LB_ARCNOW.Hide;
     TabbedNotebook1.Pages[1]:= 'Архивация';
    end;
    if (SP_ARCPERIOD.Value=0) then begin
      LB_ARCNOW.Hide;
      LB_LASTARCDATE.Font.Color:=clBlack;
      LB_Days.Font.Color:=clBlack;
      TabbedNotebook1.Pages[1]:= 'Архивация';
    end;

    TabbedNotebook1.PageIndex:=0;
    Y:=strtoint(copy(DateToStr(Now),7,4));
    for i:=Y-10 to Y do CmbOldPat.Items.Add(inttostr(i));
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.BTN_ARCNOWClick(Sender: TObject);
begin
   Archivate;
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.CH_DEBUGClick(Sender: TObject);
begin
   if (not ch_debug.Checked) then begin
     ch_n_debug.Enabled := false;
     ch_n_debug.Checked := false;
  end else ch_n_debug.Enabled := true;
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.CH_DEVClick(Sender: TObject);
begin
   if (not ch_dev.Checked) then begin
     ch_n_dev.Enabled := false;
     ch_n_dev.Checked := false;
  end else ch_n_dev.Enabled := true;
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.CH_INFOClick(Sender: TObject);
begin
   if (not ch_info.Checked) then begin
     ch_n_info.Enabled := false;
     ch_n_info.Checked := false;
  end else ch_n_info.Enabled := true;
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.CH_WARNClick(Sender: TObject);
begin
   if (not ch_warn.Checked) then begin
     ch_n_warn.Enabled := false;
     ch_n_warn.Checked := false;
  end else ch_n_warn.Enabled := true;
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.CH_ERRClick(Sender: TObject);
begin
     if (not ch_err.Checked) then begin
     ch_n_err.Enabled := false;
     ch_n_err.Checked := false;
  end else ch_n_err.Enabled := true;
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.CMB_COMDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TComboBox).Canvas do begin
   FillRect(Rect);
   Draw(rect.Left+3,rect.Top+1,IMGC.Picture.Bitmap);
   TextOut(Rect.Left+20,(Rect.Top+(Rect.Bottom-Rect.Top+font.Height) div 2)-1,CMB_COM.Items[Index]);
  end;
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.Button1Click(Sender: TObject);
begin
  Close;
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.list_bakClickCheck(Sender: TObject);
var i : integer;
begin
  for i:=1 to 5 do
     if (list_bak.Checked[i-1]) then bak_opts[i] := '1' else bak_opts[i] := '0';
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.OnPatold(Sender: TObject);
begin
  pat_old:=strtoint(CmbOldPat.Text);
end;
//-------------------------------------------------------------------------------
procedure TF_Cfg.OnVI(Sender: TObject);
begin
   if (ChBI.Checked) then vi:=1 else vi:=0;
end;
//-------------------------------------------------------------------------------
end.
