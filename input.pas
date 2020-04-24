unit input;
// Форма ввода слов
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

// карта клавиатуры
// здесь в массиве находятся все кнопки клавиатуры
// 4 линии на клавиатуре
// 4 режима клавиатуры  русские или английские + большие или мальеньки
const keymap: array[0..3,0..3] of string =
                                 ( ('`1234567890-=\',
                                   'qwertyuiop[]',
                                   'asdfghjkl;''',
                                   'zxcvbnm,./'),
                                   ('`1234567890-=\',
                                   'QWERTYUIOP[]',
                                   'ASDFGHJKL;''',
                                   'ZXCVBNM,./'),
                                   ('ё1234567890-=\',
                                   'йцукенгшщзхъ',
                                   'фывапролджэ',
                                   'ячсмитьбю.'),
                                   ('Ё1234567890-=\',
                                   'ЙЦУКЕНГШЩЗХЪ',
                                   'ФЫВАПРОЛДЖЭ',
                                   'ЯЧСМИТЬБЮ.'));
type
  TFrmTest = class(TForm)
    Im: TImage;
    GroupBox1: TGroupBox;
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    l1: TLabel;
    l2: TLabel;
    l3: TLabel;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    e1: TLabel;
    e2: TLabel;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    l4: TLabel;
    L5: TLabel;
    Label5: TLabel;
    a1: TLabel;
    a2: TLabel;
    keyb: TImage;           //это изображение клавиатуры
    rec: TShape;            //это изображение прямоугольника
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
   procedure DrawStr;            //вывод строки на экран
   procedure preparedata;        //загрузка списка слов
   procedure Start;              //новое слово
   procedure LoadData(i,j:integer); //загрузка конкрктной строки
   procedure ShowButton(Key: Char);
    { Public declarations }
  end;

var
  FrmTest: TFrmTest;
  Shows:string;        // текущее слово на экране
  l:tStringList;       // список всех оставшихся слов
  CurPos,              // индекс вводимого символа
  curitem,             // индекс текущего слова
  ErrCount,            // количество ошибок в задании
  ChCount:integer;     // всего сиволов введено (правильно)
  Startms:integer=-1;  // время начала ввода
  StartCount:integer;  // всего слов вначале
  AvgSpeed:real;       // средняя скорость ввода
implementation
uses testing,main;
{$R *.DFM}

//Здесь выводится вводимая строка
procedure TFrmTest.DrawStr;
var i:integer;
    s,s2:string;
begin
 with im.Canvas do                //сюда рисуем
 begin
   Rectangle(0,0,width-1,height-1);      //прямоугольник стирает все содержимое
   font.Size:=16;                        //размер шпифта
   font.Style:=[fsbold];                 //стиль - жирный
//расчет позиции первого символа
// = середина изображения - половина ширины строки
   i:=(im.Width div 2) - (TextWidth(Shows) div 2);
//копируем в s из всей строки часть от начала до текущего символа
   s:=copy(shows,1,CurPos-1);
   font.Color:=clBlue;                    //шрифт - синий
   TextOut(i,10,Shows);   //выводим все слово с расчитанной позиции
   font.Color:=clgray;    //шрифт - серый
   if s<>'' then          //если начало строки не пустое
      TextOut(i,10,s);    //выводим его (серым)
   font.Color:=clRed;     //шрифт - красный
   i:=i+TextWidth(s);     //расчет позиции выделенного символа (старый + ширина начала строки)
   Textout(i,10,shows[curpos]);   //выводим текущий символ (красным)
 end;
end;

//загрузка слов без подсписков, те без []
procedure TFrmTest.LoadData(i,j:integer);
var s:string;
    ls:tStringList;       //список строк
    t:integer;
begin
 s:=ini.ReadString('level'+intToStr(i),intToStr(j),'');   //чтение из ini-файла строки
 ls:=tStringList.create; //создание списка строк
 ls.CommaText:=s;        //копирование загруженной строки в список строк
                         // CommaText - разобьет на отдельные строки по запятым
 for t:=0 to ls.Count-1 do  //по элементам списка
 begin
   if ls[t][1]='[' then continue; //если встерили начало подсписка, то не обрабатываем
   l.Add(ls[t]);                 //остальное в рабочий список
 end;
 ls.Free;                     //память освобождаем
end;

//загрузка всего
procedure TFrmTest.PrepareData;
var s:string;
    i:integer;
    ls:tStringList; //список строк
begin
//загрузка из ini по значению уровня пользователя
//и его задачи
 s:=ini.ReadString('level'+intToStr(frmusr.elevel.Tag),
                    intToStr(frmusr.etask.Tag),'');
 ls:=tStringList.create;      //создаем список
 l.Clear;
 ls.CommaText:=s;          //копирование с разделением по строкам
 for i:=0 to ls.Count-1 do       //здесь обрабатывам все подсписки
 begin
   if ls[i][1]='[' then      //если подсписок
   begin
     s:=ls[i];                 //берем значение
     delete(s,1,1);             //удаляем первый символ [
     delete(s,length(s),1);    //и последний  ] - остался номер списка
     loaddata(frmusr.elevel.Tag,StrToInt(s));    //загружаем по номеру списка
   end;
 end;
 loaddata(frmusr.elevel.Tag,frmusr.etask.Tag);  //загрузка из текущего
 ls.Free;                    //инициализируем переменные
 CurPos:=-1;                //позиция
 curitem:=-1;               //элемент
 ErrCount := 0;             //ошибок
 ChCount:=0;                //символов
 StartCount := l.Count;     //стартовое количество элементов
end;

//создание формы
procedure TFrmTest.FormCreate(Sender: TObject);
begin
 randomize;                //генератор случ чисел
 l:=TStringList.Create;    //создаем список слов
 preparedata;              //подготовка
 start;                    //первое слово
end;

procedure TFrmTest.Start;    //получение следующего слова из списка оставшихся
begin
   curitem:=random(l.count);  //случайно из всех слов
   ShowS:=l[curitem];  //показываемое слово берем из списка
   CurPos:=1;  //позиция набираемого символа
   drawStr;   //вывод слова на экран
   ChCount:=ChCount+length(ShowS); //колич. символов
   startms:=-1 //секунды не стартовали
end;

//показть кнопку на клавиутуре
procedure TFrmTest.ShowButton(Key: Char);
var i,j,p,r:integer;
begin
 r:=-1;
 for i:=0 to 3 do             //перебор всех символов на карте клавиатуре
 begin
   for j:=0 to 3 do
   begin
     if pos(key,keymap[i,j])<>0 then  //есть символ в текщей строке
     begin
       p:=pos(key,keymap[i,j]); //позиция сивола
       r:=j;          //ряд
       break;
     end;
   end;
   if r<>-1 then break;
 end;
 if r=-1 then exit;
 rec.Visible:=true;    //квадратик видим
 case r of                      //в зависимости от ряда расчет
   0: rec.Top := keyb.Top + 3;    //первая линия сдвиг сверху
   1: rec.Top := keyb.Top + 44;     //2
   2: rec.Top := keyb.Top + 85;     //3
   3: rec.Top := keyb.Top + 124;    //4
 end;
 case r of
   0: rec.left := keyb.left + 0;      //сдвиги слева
   1: rec.left := keyb.left + 62;
   2: rec.left := keyb.left + 85;
   3: rec.left := keyb.left + 102;
 end;
  rec.Left:=rec.Left+ 41*(p-1);   //сдвиг слева + индекс символа*ширину буквы
end;

//нажатие кнопки
procedure TFrmTest.FormKeyPress(Sender: TObject; var Key: Char);
var s:string;
    f:real;
    j:integer;
begin
 ShowButton(Key);        //показть набранную букву
 if Startms=-1 then     //старт таймера если еще не запущен
 begin
   l1.caption := timeToStr(now);  //время начала
   startms:=gettickcount;     //текуще количество милисекунд
 end;
 if key=shows[curpos] then   //правильно нажато
 begin
   inc(CurPos);              //следующ индекс
 end else inc(ErrCount);     //иначе ошибка +1

 if CurPos>length(shows) then   //если слово кончилось
 begin
   j:=GetTickCount;                  //текуще значение мс
   if j=startms then inc(j);         //не меньше 1
   f:=(length(shows)*1000)/(j-startms);  //расчет текущ скорость
   Startms:=-1; //не начато
   AvgSpeed := (AvgSpeed*(StartCount-l.Count) +  f)/(StartCount-l.Count+1);
   a1.Caption:=format('%1.2f cмв/сек',[AvgSpeed]);   //подсч средн скорости
   a2.Caption:=format('%1.2f cмв/мин',[AvgSpeed*60]);//и вывод
   l.Delete(CurItem);        //этот элемент удаляется
   if l.Count=0 then         //больше нет
   begin
     If ErrCount>0 then      //ошибки есть
     begin
       ShowMessage('Вы допустили '+IntToStr(errCount)+' ошибок. '#13+
        'Придется повторить. Для перехода надо пройти упражнение безошибочно');
       preparedata;   //все заново
       start;
       exit;
     end else
     begin
       ShowMessage('Отлично!');   //прошли
       //последн в списке задач для текущего уровня
       if ini.ReadInteger('level'+IntToStr(frmusr.elevel.Tag),'tasks',0)-1=frmusr.etask.tag then
        if frmusr.elevel.Tag<3 then begin    // не последний уровень
                                         frmusr.elevel.Tag:=frmusr.elevel.Tag+1;//увеличиваем уровень
                                         frmusr.etask.tag:=0;//задача # 0
                                    end
                               else begin //последний
                                         ShowMessage('Вы прошли все');
                                         close;
                                         exit;
                                    end
        else
        begin
          frmusr.etask.tag:=frmusr.etask.tag+1; //следующее задание
        end;
     end;
     s:=format('%d,%d',[frmusr.elevel.tag,frmusr.etask.tag]); //формат строки
     usrstr:=s;
     ini.Writestring('userlevel',IntToStr(frmusr.tag),s);  //запись в файл
     frmusr.PrepareUsr;                     //обновление на форме юзера
     preparedata;                           //загрузка следующ данных
   end;
   start;                            //сдедующ слово
 end;

 DrawStr;     //перерисовать строку

end;




procedure TFrmTest.Timer1Timer(Sender: TObject); //на таймере
var j:integer;
begin
 l2.Caption:= timeToStr(now);    //текущее время
try
 if Startms>-1 then     //таймер запущен
 begin
   l3.Caption:=IntToStr(gettickcount-startms)+' мс';    //прошло времени
   if curpos=0 then begin l4.Caption:='--';l5.Caption:='--';end
   else begin     //текущая скорость
     j:=gettickcount;
     if j=startms then  inc(j);
     l4.Caption:=format('%1.2f cмв/сек',[(CurPos*1000)/(j-startms)]);
     l5.Caption:=format('%1.2f cмв/мин',[(CurPos*60000)/(j-startms)]);
     end;
 end;

 e1.Caption:=IntToStr(ErrCount);   //ошибок
 if chCount=0 then e2.Caption:=''     //в процентах
 else e2.Caption:=format('%1.2f%%',[100*Errcount/Chcount])
 except
 end;
end;


//закрыть форму
procedure TFrmTest.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 l.free   //освободить память из-под списка слов
end;

end.
