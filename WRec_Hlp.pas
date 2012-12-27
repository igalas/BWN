unit WRec_Hlp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, wrec_main, ShellAPI;

type
  TF_Hlp = class(TForm)
    hlp_list: TListBox;
    Bevel1: TBevel;
    Label1: TLabel;
    hlp_content: TRichEdit;
    Label2: TLabel;
    Button2: TButton;
    img_hlp: TImage;
    procedure hlp_listDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure hlp_listClick(Sender: TObject);   
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Hlp: TF_Hlp;
  SR : TSearchRec;

implementation

{$R *.dfm}

procedure TF_Hlp.hlp_listDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
  with (Control as TListBox).Canvas do begin
   FillRect(Rect);
   Draw(rect.Left + 4, rect.Top + 2, img_hlp.Picture.Bitmap);
   TextOut(Rect.Left + 26,(Rect.Top+(Rect.Bottom-Rect.Top+font.Height) div 2) - 1, hlp_list.Items[Index]);
  end;
end;

procedure TF_Hlp.FormShow(Sender: TObject);
begin
   hlp_list.Items.Clear;
   If (FindFirst(Appdir + 'HELP\*.RTF', faAnyFile, SR) = 0) then begin
      hlp_list.Items.Add(Copy(sr.Name, 1, length(sr.Name) - 4));
      while (FindNext(SR) = 0) do hlp_list.Items.Add(Copy(sr.Name, 1, length(sr.Name) - 4));
      FindClose(SR);
   end;             
   if (hlp_list.Items.Count > 0) then begin
      hlp_list.ItemIndex := 0;
      hlp_listClick(ActiveControl AS TObject);
   end;
end;

procedure TF_Hlp.hlp_listClick(Sender: TObject);
begin
  if (hlp_list.ItemIndex >= 0) then
     hlp_content.Lines.LoadFromFile(Appdir + 'HELP\'+hlp_list.Items[hlp_list.ItemIndex]+'.rtf');
end;

procedure TF_Hlp.Button2Click(Sender: TObject);
begin
   Close;
end;

end.
