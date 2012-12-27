unit WRec_About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, jpeg;

type
  TAboutBox = class(TForm)
    Image1: TImage;
    Bevel1: TBevel;
    Button1: TButton;
    Panel1: TPanel;
    LO_9X: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure glBitBtn1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.dfm}

procedure TAboutBox.glBitBtn1Click(Sender: TObject);
begin
 aboutBox.Close;
end;

procedure TAboutBox.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TAboutBox.FormShow(Sender: TObject);
begin
  label3.Caption := 'Copyright © 2003-' + FormatDateTime('yyyy', now)+', Developed by A. Galas';
end;

end.
