unit WRec_NakDesc;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls;

type
  TF_Nak_Desc = class(TForm)
    Panel1: TPanel;
    IMG_ORG: TImage;
    RCH_ORG: TRichEdit;
    Bevel1: TBevel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Nak_Desc: TF_Nak_Desc;

implementation

{$R *.dfm}

procedure TF_Nak_Desc.Button1Click(Sender: TObject);
begin
close;
end;

end.
