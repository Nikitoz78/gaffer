program gaffer;
{
������ : ��������� �������� ������ �� �����������
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
//�� ���������� ������� �����
// ��� ��� ���� ����� ������� �������� ����� � �������
  Application.HelpFile := 'gaffer.hlp';
  Application.CreateForm(TFrmMain, FrmMain);
  FrmMain.show; //������ ������� ������� �����
  Application.Run;
end.
