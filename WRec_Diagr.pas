unit WRec_Diagr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, StdCtrls, Series;

type
  TF_Diagr = class(TForm)
    Chart1: TChart;
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Series1: TBarSeries;
    DLG_PRINT: TPrintDialog;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Series1BeforeDrawValues(Sender: TObject);
    procedure Series1AfterDrawValues(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  F_Diagr: TF_Diagr;
  
  data   : array[0..23] of byte;
  point  : array[0..11] of ANSIString;
  MyColors : array[0..4] of TColor;

  percent: double;
implementation

{$R *.dfm}

procedure TF_Diagr.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TF_Diagr.Button1Click(Sender: TObject);
begin
   chart1.PrintProportional := True;
   if DLG_PRINT.Execute then chart1.PrintLandscape;
end;

procedure TF_Diagr.FormShow(Sender: TObject);
begin
   data[0] := 40; data[1] := 45; data[2] := 65;
   data[3] := 80; data[4] := 50; data[5] := 30;
   data[6] := 20; data[7] := 10; data[8] := 40;
   data[9] := 30; data[10] := 70; data[11] := 90;
   data[12] := 60; data[13] := 20; data[14] := 40;
   data[15] := 50; data[16] := 60; data[17] := 40;
   data[18] := 30; data[19] := 35; data[20] := 50;
   data[21] := 20; data[22] := 70; data[23] := 40;

   point[0] := 'P9'; point[1] := 'MC7'; point[2] := 'C7';
   point[3] := 'IG4'; point[4] := 'TR4'; point[5] := 'GI5';
   point[6] := 'PR3'; point[7] := 'F3'; point[8] := 'R3';
   point[9] := 'V65'; point[10] := 'VB40'; point[11] := 'E42';
end;

procedure TF_Diagr.FormCreate(Sender: TObject);
var cl : TColor;
    fl : boolean;
    deltaX : double;
    i : integer;
begin
  Series1.CustomBarWidth := 10;
  fl := false;
  Series1.Clear;
  deltaX := 625/24;
  for i := 0 to 23 do begin
     if (data[i]<=19) then cl := clBlack;
     if ((data[i]>19) and (data[i]<=41)) then cl := clBlue;
     if ((data[i]>41) and (data[i]<=55)) then cl := clYellow;
     if ((data[i]>55) and (data[i]<=72)) then cl := clGreen;
     if (data[i]>72) then cl := clRed;
     if (not fl) then Series1.AddXY(deltaX*i,data[i],'L',cl)
         else Series1.AddXY(deltaX*(i-1)+deltaX/1.4,data[i],'R',cl);
     fl := not fl;
     Series1.ValueColor[i] := cl;
   end;
   Percent := 68;
end;

procedure TF_Diagr.Series1BeforeDrawValues(Sender: TObject);
var
   YPosition, partial, t : integer;
   tmpYCenterValue : double;
   tmpRect : TRect;
   fl : boolean;
begin
     MyColors[0] := clNavy;
     MyColors[1] := clGreen;
     MyColors[2] := clYellow;
     MyColors[3] := clRed;
     MyColors[4] := $000080;

     tmpRect := Chart1.ChartRect;
     tmpRect.Right := tmpRect.Left;
     partial := Chart1.ChartWidth div 12;
     // change the brush style
     Chart1.Canvas.Brush.Style := bsSolid;
     Chart1.Canvas.Pen.Style := psClear;
     fl := false;

     for t := 1 to 12 do begin
         tmpRect.Right := tmpRect.Right+partial;
         if (not fl) then Chart1.Canvas.Brush.Color := clSilver
           else Chart1.Canvas.Brush.Color := clBtnFace;
         fl := not fl;
         Chart1.Canvas.Rectangle(
         tmpRect.Left+Chart1.Width3D,
         tmpRect.Top-Chart1.Height3D,
         tmpRect.Right+Chart1.Width3D,
         tmpRect.Bottom-Chart1.Height3D);
         tmpRect.Left := tmpRect.Right;
     end;

     YPosition := Chart1.LeftAxis.CalcYPosValue(64);

     Chart1.Canvas.Pen.Width := 1;
  Chart1.Canvas.Pen.Style := psSolid;
  Chart1.Canvas.Pen.Color := clBlack;
  Chart1.Canvas.MoveTo(Chart1.ChartRect.Left,YPosition);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Left+Chart1.Width3D,
    YPosition-Chart1.Height3D);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Right+Chart1.Width3D,
    YPosition-Chart1.Height3D);

  Chart1.Canvas.Pen.Width := 1;
  Chart1.Canvas.Pen.Style := psDashDot;
  YPosition := Chart1.LeftAxis.CalcYPosValue(19);
  Chart1.Canvas.MoveTo(Chart1.ChartRect.Left,YPosition);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Left+Chart1.Width3D,
    YPosition-Chart1.Height3D);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Right+Chart1.Width3D,
    YPosition-Chart1.Height3D);

  YPosition := Chart1.LeftAxis.CalcYPosValue(41);
  Chart1.Canvas.Pen.Color := clBlue;
  Chart1.Canvas.MoveTo(Chart1.ChartRect.Left,YPosition);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Left+Chart1.Width3D,
    YPosition-Chart1.Height3D);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Right+Chart1.Width3D,
    YPosition-Chart1.Height3D);

  YPosition := Chart1.LeftAxis.CalcYPosValue(55);
  Chart1.Canvas.Pen.Color := clYellow;
  Chart1.Canvas.MoveTo(Chart1.ChartRect.Left,YPosition);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Left+Chart1.Width3D,
    YPosition-Chart1.Height3D);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Right+Chart1.Width3D,
    YPosition-Chart1.Height3D);

  YPosition := Chart1.LeftAxis.CalcYPosValue(72);
  Chart1.Canvas.Pen.Color := clRed;
  Chart1.Canvas.MoveTo(Chart1.ChartRect.Left,YPosition);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Left+Chart1.Width3D,
    YPosition-Chart1.Height3D);
  Chart1.Canvas.LineTo(Chart1.ChartRect.Right+Chart1.Width3D,
    YPosition-Chart1.Height3D);
end;

procedure TF_Diagr.Series1AfterDrawValues(Sender: TObject);
var partial, pos, i : integer;
    tmpRect : TRect;
begin
  partial := Chart1.ChartWidth div 12;
  tmpRect := Chart1.ChartRect;
  Chart1.Canvas.Font.Height := -16;   // <-- express font size in "Height", NOT "Size"
  Chart1.Canvas.Font.Color := clBlue;
  Chart1.Canvas.Font.Style := [fsBold];
  pos := tmpRect.Left+10;
  for i:=0 to 11 do begin
    Chart1.Canvas.TextOut(pos,tmpRect.top-20,point[i]);
    pos:=pos+partial;
  end;
end;

end.
