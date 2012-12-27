unit WRec_Log;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList, IniFiles, wrec_main, ClipBrd,
  CPortCtl;

type
  TF_Log = class(TForm)
    Bevel1: TBevel;
    msgList: TListBox;
    BTN_SAVE: TButton;
    IMG_LOG: TImageList;
    DLG_SAV: TSaveDialog;
    Button1: TButton;
    Button2: TButton;
    procedure BTN_SAVEClick(Sender: TObject);
    procedure msgListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Log     : TF_Log;
  ic        : array [0..4] of TBitmap;
  opts, opt : array [0..4] of Boolean;

  procedure WriteLog(text: string; icon : byte);
  procedure DebugMsg(text: string);
  procedure DebugDev(text: string);
implementation

{$R *.dfm}

procedure TF_Log.BTN_SAVEClick(Sender: TObject);
begin
  if (dlg_sav.Execute) then msgList.Items.SaveToFile(dlg_sav.FileName);
end;

procedure TF_Log.msgListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do begin
   FillRect(Rect);
   TextOut(Rect.Left+3,(Rect.Top+(Rect.Bottom-Rect.Top+font.Height) div 2) - 3, msgList.Items[Index]);
   Draw(rect.Left + 5, rect.Top + 3, TBitmap((Control as TListBox).Items.Objects[Index]));
  end;
end;

procedure TF_Log.FormCreate(Sender: TObject);
var i : byte;
begin
   for i:=0 to 4 do begin
      ic[i] := TBitmap.Create;
      IMG_LOG.GetBitmap(i, ic[i]);
   end;
end;

procedure WriteLog(text: string; icon : byte);
begin
     text := '[' + DateTimeToStr(now) + '] ' + text;
     case icon of
      0 : text := '(i) ' + text;
      1 : text := '(!) ' + text;
      2 : text := '(x) ' + text;
      3 : text := '(D) ' + text;
      4 : text := '(>) ' + text;
     end;
     if ((opt[0]) and (icon = 0)) then f_log.msgList.Items.AddObject(text, ic[icon]);
     if ((opt[1]) and (icon = 1)) then f_log.msgList.Items.AddObject(text, ic[icon]);
     if ((opt[2]) and (icon = 2)) then f_log.msgList.Items.AddObject(text, ic[icon]);
     if ((opt[3]) and (icon = 3)) then f_log.msgList.Items.AddObject(text, ic[icon]);
     if ((opt[4]) and (icon = 4)) then f_log.msgList.Items.AddObject(text, ic[icon]);
     if (f_log.msglist.Items.Count > 0) then f_log.msgList.ItemIndex := f_log.msgList.Items.Count - 1;
     if ((opts[0]) and (icon = 0)) then f_log.Show;
     if ((opts[1]) and (icon = 1)) then f_log.Show;
     if ((opts[2]) and (icon = 2)) then f_log.Show;
     if ((opts[3]) and (icon = 3)) then f_log.Show;
     if ((opts[4]) and (icon = 4)) then f_log.Show;
end;

procedure DebugMsg(text: string);
begin
   if opt[3] then WriteLog(text, 3);
end;

procedure DebugDev(text: string);
begin
   if opt[4] then WriteLog(text, 4);
end;

procedure TF_Log.Button2Click(Sender: TObject);
begin
   msgList.Items.Clear;
end;

procedure TF_Log.FormShow(Sender: TObject);
begin
   if (f_log.msglist.Items.Count > 0) then f_log.msgList.ItemIndex := f_log.msgList.Items.Count - 1;
end;

procedure TF_Log.Button1Click(Sender: TObject);
begin
  hide;
end;

end.
