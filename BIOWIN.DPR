program BIOWIN;

uses
  Forms,
  WPat_edit in 'WPat_edit.pas' {PatEdt},
  WPat_main in 'WPat_main.pas' {F_Pat},
  WRec_About in 'WRec_About.pas' {AboutBox},
  WRec_Help in 'WRec_Help.pas' {F_Help},
  WRec_main in 'WRec_main.pas' {Main},
  WRec_print in 'WRec_print.pas' {F_Print},
  WRec_cfg in 'WRec_cfg.pas' {F_Cfg},
  WRec_Diagr in 'WRec_Diagr.pas' {F_Diagr},
  WRec_Nak in 'WRec_Nak.pas' {F_Nak},
  WRec_NakDesc in 'WRec_NakDesc.pas' {F_Nak_Desc},
  WRec_Log in 'WRec_Log.pas' {F_Log},
  WRec_Hlp in 'WRec_Hlp.pas' {F_Hlp};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'BIOCORID+';
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TPatEdt, PatEdt);
  Application.CreateForm(TF_Pat, F_Pat);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TF_Help, F_Help);
  Application.CreateForm(TF_Print, F_Print);
  Application.CreateForm(TF_Cfg, F_Cfg);
  Application.CreateForm(TF_Diagr, F_Diagr);
  Application.CreateForm(TF_Nak, F_Nak);
  Application.CreateForm(TF_Nak_Desc, F_Nak_Desc);
  Application.CreateForm(TF_Log, F_Log);
  Application.CreateForm(TF_Hlp, F_Hlp);
  Application.Run;
end.
