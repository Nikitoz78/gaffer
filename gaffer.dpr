program gaffer;
{
Проект : программа обучения набору на клавиатурой
}
uses
  Forms,
  Main in 'Main.pas' {FrmMain},
  testing in 'testing.pas' {FrmUsr},
  input in 'input.pas' {FrmTest};

{$R *.RES}

begin
  Application.Initialize;
  Application.ShowMainForm:=false;
//не показывать главную форму
// это для того чтобы сначала вывелась форма с паролем
  Application.HelpFile := 'gaffer.hlp';
  Application.CreateForm(TFrmMain, FrmMain);
  FrmMain.show; //теперь покажем главную форму
  Application.Run;
end.
