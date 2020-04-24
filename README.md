# Gaffer

## Keyboard trainer

ENG:
 The source code was written in 2005 while I was studying at Modern University for the Humanities. During the development of the program, Shahijanyan 's analog program "Solo on Keyboard" was studied.
 The program is intended to carry out practical trainings on learning the set on the keyboard of individual letters and numbers, words and sentences using the register of input of capital and lower letters. Training is divided into 3 levels which in turn consist of tasks. You can modify the content of tasks by editing the ini file using any text editor.
 The output of the program is a numerical estimate of the speed and number of errors in typing. This information is temporary and is not stored longer than the task time.
 The program supports multi-user mode by tracking the performance of each user (trainee). Information about the trainee, data about the achieved level and the job number are saved in the ini-file and initialized from this file by entering the user name and password, which are requested when the program starts or the trainee changes.
 The program is based on three modular units: "main," testing "and" input. "
The main tasks of the "main" software module are to collect information about the user, name and password, with a record in the ini file, as well as to extract data about already authorized users from the data file. If the password is entered correctly or after the new user is authorized, the program proceeds to the next "testing" block.
The main task of the testing module is to extract user information from the ini file, such as name, level, task and output in the information window. From this software module, the user can return to the previous main module by clicking the Change User button or go to the next input module by clicking the Start button.
The "input" software module is the main part of the program. Accordingly, its function is to teach dialing on a keyboard, which in turn consists of a number of tasks:
- Output of the current job with indication of symbol required for the set;
- Validation of the typed character;
- Error counter with determination of percentage of correctly dialed characters;
- Designation of pressed key in keyboard layout window;
- Timer of the current time;
- Timer of time spent on word set;
- Determination of the current speed of dialing;
- Defines the average speed of dialing.

  The main information part of the system is the data file. The file has the structure of an ini file and contains all the information stored in the system.
The format of ini files is very simple. The Ini file is a text file. The parameter group is merged into sections. In the text, the title of the section is highlighted by square brackets. The data is stored as "< Key Name > = < Value >." To access the key value, the function is called, whose parameters pass the partition name and the key name.
The "dat.ini" settings file stores the program settings.

RUS:
 Исходный код был написан в 2005 году во время моего обучения в СГА. При разработке программы была изучена программа-аналог  «Соло на клавиатуре» Шахиджаняна.
 Программа предназначена для проведения практических тренировок по освоению набора на клавиатуре  отдельных букв и чисел, слов и предложений с использованием регистра ввода прописных и строчных букв. Обучение разбито на 3 уровня которые в свою очередь состоят из заданий. Содержание заданий можно изменять, редактируя ini-файл используя любой текстовый редактор.
 Выходными данными программы являются численная оценка скорости и количества ошибок при наборе текста. Данная информация временная и не хранится дольше времени прохождения задач. 
 Программа поддерживает многопользовательский режим, отслеживая показатели каждого пользователя (обучаемого). Информация об обучаемом, данные о достигнутом уровне и номере задания сохраняется в ini-файле и инициализируется из этого файла вводом имени и пароля пользователя которые запрашивается при запуске программы или смены обучаемого.
 Основу программы составляют три модульных блока: «main», «testing» и «input». 
Основные задачи программного модуля «main», это сбор информации о пользователе, имени и пароля, с записью в ini-файл, а также извлечение данных об уже авторизованных пользователях из файла с данными. При правильно введенном пароле или после авторизации нового пользователя, программа переходит с следующему блоку «testing».
Основная задача модуля «testing» извлечение информации о пользователе из ini-файла, это имя, уровень, задание и вывод ее в информационном окне. Из этого программного модуля пользователь может вернутся в предыдущий модуль «main», нажав кнопку «Смена пользователя» или перейти к следующему модулю «input» нажав кнопку «Запуск».
Программный модуль «input» является основной частью программы. Соответственно его функцией является обучение набору на клавиатуре, которая в свою очередь состоит из ряда задач:
- вывод текущего задания с индикацией требуемого к набору символу;
- проверка правильности набранного символа;
- счетчик ошибок с определением процентного отношения к правильно набранным символам;
- обозначение нажатой клавиши в окне клавиатурной раскладки;
- таймер текущего времени;
- таймер времени затраченного на набор слова;
- определение текущей скорости набора;
- определение средней скорости набора.

  Основной информационной частью системы является файл с данными. Файл имеет структуру ini-файла и содержит всю хранящуюся в системе информацию.
Формат ini-файлов очень прост. Ini-файл представляет собой текстовый файл. Группа параметров объединяются в секции. В тексте название секции выделяется квадратными скобками. Данные хранятся в виде строки: «<Имя ключа>=<Значение>». Для доступа к значению ключа вызывается функция, параметрами которой передаются имя секции и имя ключа. 
В файле настроек «dat.ini» хранятся настройки программы.
