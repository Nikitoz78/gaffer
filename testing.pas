unit testing;
//форма с данными пользователя
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Menus;

type
  TFrmUsr = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Ename: TEdit;
    Label2: TLabel;
    elevel: TEdit;
    Label3: TLabel;
    etask: TEdit;
    BtnStart: TBitBtn;
    BtnExit: TBitBtn;
    BtnReEnter: TBitBtn;
    procedure BtnStartClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure PrepareUsr;
    { Public declarations }
  end;

var
  FrmUsr: TFrmUsr;
  UsrStr:string;      //строка <уровень>,<задание>
implementation
uses main,input;
{$R *.DFM}
procedure tFrmUsr.PrepareUsr; // загрузка инфы по юзеру
var s,st:string;
begin
  s:=UsrStr[1];
  elevel.Text:=ini.ReadString('level'+s,'name',s);  //уровень
  elevel.Tag := StrToInt(s);
  st := UsrStr;
  delete(st,1,2);
  etask.Text:=ini.ReadString('level'+s,'n'+st,st);    //задание
  etask.Tag := StrToInt(st);
end;


procedure TFrmUsr.BtnStartClick(Sender: TObject);  //запуск теста
begin
  Application.CreateForm(TFrmTest, FrmTest);       //создать форму
  FrmTest.ShowModal; //показать
  FrmTest.free;     //освободить память

end;

//выход
procedure TFrmUsr.N2Click(Sender: TObject);
begin
 close; //закрыть форму
end;

//смена пользователя
procedure TFrmUsr.N4Click(Sender: TObject);
begin
 ModalResult := mrretry; //закрыть с этим результатом
end;

//помощб
procedure TFrmUsr.N5Click(Sender: TObject);
begin
Application.HelpContext(1000);

end;

end.
