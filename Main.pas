unit Main;
//форма входа
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  inifiles,ExtCtrls, StdCtrls, Buttons;

type
  TFrmMain = class(TForm)
    GroupBox1: TGroupBox;
    Combo: TComboBox;
    Epassw: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    BtnStart: TBitBtn;
    BtnClose: TBitBtn;
    BitBtn1: TBitBtn;
    BtnDelUser: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BtnDelUserClick(Sender: TObject);
  private
    { Private declarations }
  public
    function AppHelp(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean;
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;
  ini:tIniFile;     // ини-шник со всеми данныма
  maxuser:integer;  // количество пользователей
implementation
uses testing;
{$R *.DFM}

//помощь
function TFrmMain.AppHelp(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean;
begin
  CallHelp := True;
end;

//создание формы
procedure TFrmMain.FormCreate(Sender: TObject);
var i:integer;
    s:string;
begin
  Application.OnHelp :=AppHelp; //обработчик на помощь
  Epassw.Clear; //стирание содержимого пол¤ "пароль"
  s:=extractfilepath(paramstr(0))+'dat.ini';    //ини-шник в текущей директории
  ini:=tIniFile.Create(s); //создать ини-шник
  caption := ini.ReadString('main','title','Untitled test');  //считывание заголовок окна
  i:=0;
  Combo.Items.Clear; //стереть список пользователей
  while true do  //бесконечный цикл
  begin
    s:=ini.ReadString('userlist',IntToStr(i),'');     //грузим i го юзера
    if s='' then break; //если нет, то выход из цикла
    Combo.Items.AddObject(s,pointer(i)); //добавить пользовател¤
    inc(i); //следующий номер
  end;
  maxuser:=i; //количество пользователей
  combo.ItemIndex:=ini.ReadInteger('main','lastuser',0);  //индекс на последнего входившего
end;


procedure TFrmMain.BtnStartClick(Sender: TObject);  // запуск
begin
 if Epassw.Text='' then                // без парол¤ не пущать
 begin
   ShowMessage('ѕароль не может быть пустым');
   Epassw.SetFocus;
   exit;
 end;
 if combo.ItemIndex = -1 then              // ввели нового юзера
 begin
   ini.WriteString('userlist',IntToStr(maxuser),combo.text);    //сохраним его
   ini.WriteString('userlist','p'+IntToStr(maxuser),epassw.Text);
   ini.WriteString('userlevel',IntToStr(maxuser),'1,0');
   combo.Items.addobject(combo.text,pointer(maxuser));
   combo.ItemIndex:=maxuser;
   inc(maxuser);                                  //количество больше
 end else
 if ini.ReadString('userlist','p'+IntToStr(combo.ItemIndex),'')
     <>Epassw.text then                                //проверка парол¤
  begin
   ShowMessage('Ќеправильный пароль');
   Epassw.SetFocus;                               //фигу
   exit;                                          //выходим
  end;
 ini.WriteInteger('main','lastuser',combo.ItemIndex);   //все ќ 
 if not assigned(FrmUsr) then
         Application.CreateForm(TFrmUsr, FrmUsr);      //форма с инфо
 FrmUsr.caption:=caption;
 hide;                                              //эту скроем
 with FrmUsr do
 begin
   Ename.text:=combo.text;                     //заголовок
   usrstr:=ini.readstring('userlevel',IntToStr(combo.itemindex),'1,0'); //о юзере
   FrmUsr.Tag:=combo.itemindex;
   PrepareUsr;                      // грузим инфо о юзере
   if showmodal=mrCancel then       //запуск окна
   begin
     FrmUsr.free;             //значит выход
     halt;
     exit;
   end;
 end;
 show;             //значит смена пользовател¤


end;

//помощь
procedure TFrmMain.BitBtn1Click(Sender: TObject);
begin
Application.HelpContext(1000); //открыть помощь
end;

//удалить пользовател¤
procedure TFrmMain.BtnDelUserClick(Sender: TObject);
var i:integer;
begin
 i:=combo.ItemIndex;
 if ini.ReadString('userlist','p'+IntToStr(i),'') //пароль пользовател¤
     <>Epassw.text then                                //проверка парол¤
  begin
   ShowMessage('Ќеправильный пароль');
   Epassw.SetFocus;                               //фигу
   exit;                                          //выходим
  end;
  if messageDlg('¬ы действительно хотите удалить этого пользовател¤?',
    mtConfirmation, [mbYes, mbNo, mbCancel],0) <>mrYes then exit;

  while ini.ValueExists('userlist',IntToStr(i+1)) do   //пока есть следующий пользователь
  begin
    //записываем в поизицию i значени¤ из i+1
    ini.WriteString('userlist',IntToStr(i),ini.ReadString('userlist',IntToStr(i+1),''));
    ini.WriteString('userlist','p'+IntToStr(i),ini.ReadString('userlist','p'+IntToStr(i+1),''));
    inc(i);
  end;
  ini.DeleteKey('userlist',IntToStr(i));      //теперь удал¤ем последнего
  ini.DeleteKey('userlist','p'+IntToStr(i));

  messageDlg('ѕользоваетль удален.',mtInformation, [mbOK],0);
  ini.Free;             //освободить пам¤ть из под ини-шника
  FormCreate(nil); //запуск процедуры создани¤ формы(там пользователи груз¤тс¤)
end;

end.
