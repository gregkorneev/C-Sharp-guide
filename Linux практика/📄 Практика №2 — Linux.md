Ниже — пошаговый план для **ALT Linux** по файлу задания. Основа задания: две лабораторные — **«Права доступа»** и **«Процессы и ресурсы ОС»**.  

## **1. Лабораторная «Права доступа»**

### **Шаг 1. Войти под своим пользователем**

Проверь логин:

```bash
whoami
pwd
```

Должно быть примерно:

```bash
/home/ваш_логин
```

---

### **Шаг 2. Создать 3 файла в домашнем каталоге**

```bash
cd ~
touch file1 file2 file3
```

Проверить:

```bash
ls -l
```

---

### **Шаг 3. Сохранить список файлов в**

**`home_files1`**

В задании важно смотреть **права, владельца и группу**, поэтому лучше использовать `ls -l`:

```bash
ls -l ~ > home_files1
```

Просмотреть файл:

```bash
cat home_files1
```

---

### **Шаг 4. Создать файлы от имени root**

Перейти в root:

```bash
su -
```

Ввести пароль root.

Перейти в домашний каталог своего пользователя:

```bash
cd /home/ваш_логин
```

Создать файлы:

```bash
touch rfile1 rfile2 rfile3
```

Выйти из root:

```bash
exit
```

---

### **Шаг 5. Дописать новый список файлов в**

**`home_files1`**

```bash
ls -l ~ >> home_files1
cat home_files1
```

Сравни:

```text
file1, file2, file3     владелец: твой пользователь
rfile1, rfile2, rfile3  владелец: root
```

---

### **Шаг 6. Попробовать изменить файлы**

```bash
echo "test user file1" >> file1
echo "test root file1" >> rfile1
```

Скорее всего, `rfile1` не даст изменить обычному пользователю, потому что владелец — root.

---
### **Шаг 7. Изменить права для**

**`file1`** **и** **`rfile1`**

Перейти в root:

```bash
su -
cd /home/ваш_логин
```

Для `file1`: запретить запись владельцу и группе:

```bash
chmod ug-w file1
```

Для `rfile1`: разрешить запись всем:

```bash
chmod a+w rfile1
```

Проверить:

```bash
ls -l file1 rfile1
```

Выйти из root:

```bash
exit
```

---

### **Шаг 8. Проверить изменение файлов пользователем**

```bash
echo "new text" >> file1
echo "new text" >> rfile1
```

Ожидаемо:

```text
file1  — изменить нельзя
rfile1 — изменить можно
```

---

### **Шаг 9. Изменить владельца**

**`file1`** **и** **`file2`** **на root**

Перейти в root:

```bash
su -
cd /home/ваш_логин
```

Посмотреть группу пользователя:

```bash
id ваш_логин
```

Обычно группа может быть такой же, как логин, либо `users`.

Изменить владельца:

```bash
chown root:users file1 file2
```

Если группы `users` нет, используй группу из команды `id`.

Проверить:

```bash
ls -l file1 file2
```

Выйти:

```bash
exit
```

---

### **Шаг 10. Попробовать изменить** **`file2`**

**обычным пользователем**

```bash
echo "try edit file2" >> file2
```

Если прав на запись нет — будет ошибка доступа.

---
## **2. Создание каталогов**

**`/home/shared`**

Перейти в root:

```bash
su -
```

Создать каталоги:

```bash
mkdir -p /home/shared/pub
mkdir -p /home/shared/upload
mkdir -p /home/shared/temp
```

Назначить владельцев, группы и права:

```bash
chown root:users /home/shared/pub
chmod 775 /home/shared/pub

chown nobody:users /home/shared/upload
chmod 130 /home/shared/upload

chown ваш_логин:users /home/shared/temp
chmod 777 /home/shared/temp
```

Проверить:

```bash
ls -ld /home/shared /home/shared/pub /home/shared/upload /home/shared/temp
```

Выйти:

```bash
exit
```

---

## **3. Проверка копирования, чтения и удаления**

Проверять можно так:

```bash
cp file1 /home/shared/pub/
cat /home/shared/pub/file1
rm /home/shared/pub/file1
```

То же самое для:

```bash
/home/shared/upload
/home/shared/temp
```

И для файлов:

```bash
file1 file2 file3 rfile1 rfile2 rfile3
```

От root проверка:

```bash
su -
cd /home/ваш_логин
cp file1 /home/shared/pub/
rm /home/shared/pub/file1
exit
```

---

## **4. Каталог-файлообменник**

По заданию нужно сделать каталог, где:

```text
создавать файлы могут все,
удалять файлы может только владелец файла
```

Для этого используется **sticky bit**.

От root:

```bash
su -
mkdir -p /home/shared/exchange
chmod 1777 /home/shared/exchange
ls -ld /home/shared/exchange
exit
```

Должно быть примерно:

```bash
drwxrwxrwt
```

Буква `t` в конце означает, что включён sticky bit.

---

# **5. Лабораторная «Процессы и ресурсы ОС»**

## **Шаг 1. Справка по**

**`ps`**

```bash
man ps
```

Выйти из справки:

```bash
q
```

Можно кратко:

```bash
ps --help
```

---

## **Шаг 2. Краткий список процессов текущего терминала**

```bash
ps
```

PID текущей оболочки можно определить так:

```bash
echo $$
```

---

## **Шаг 3. Подробный список процессов**

```bash
ps aux
```

Процесс с максимальной памятью:

```bash
ps aux --sort=-%mem | head
```

Процесс с максимальной нагрузкой CPU:

```bash
ps aux --sort=-%cpu | head
```

---
## **Шаг 4. Найти процесс**

**`init`**

```bash
ps aux | grep init
```

Или:

```bash
ps -p 1 -f
```

Обычно PID у `init`:

```text
1
```

---

## **Шаг 5. Открыть новый сеанс и запустить nano**

Во втором терминале:

```bash
nano
```

В первом терминале найти PID:

```bash
ps aux | grep nano
```

---

## **Шаг 6. Завершить все процессы nano**

```bash
killall nano
```

Если не завершились:

```bash
killall -9 nano
```

---

## **Шаг 7. Запустить top**

```bash
top
```

Выйти:

```bash
q
```

`top` удобнее, чем `ps`, потому что показывает процессы в реальном времени.

---
## **Шаг 8. Запустить поиск**

**`.html`**

**и приостановить**

```bash
find / -name "*.html" 2>/dev/null
```

Приостановить:

```text
Ctrl + Z
```

---
## **Шаг 9. Запустить**

**`man bash`**

**и приостановить**

```bash
man bash
```

Приостановить:

```text
Ctrl + Z
```

---

## **Шаг 10. Посмотреть задачи**

```bash
jobs
```

Будет примерно:

```text
[1]+  Stopped find / -name "*.html"
[2]-  Stopped man bash
```

---

## **Шаг 11. Продолжить**

**`man bash`**

Например, если `man bash` — задача №2:

```bash
fg %2
```

Выйти из `man bash`:

```bash
q
```

---

## **Шаг 12. Завершить**

**`find`**

Сначала посмотреть задачи:

```bash
jobs
```

Если `find` — задача №1:

```bash
kill %1
```

Проверить:

```bash
jobs
```

---

# **Что нужно сохранить для отчёта**

Сделай скриншоты:

1. `ls -l` после создания `file1 file2 file3`.
2. `cat home_files1` после добавления файлов root.
3. `ls -l file1 rfile1` после изменения прав.
4. `ls -ld /home/shared/pub /home/shared/upload /home/shared/temp`.
5. Проверку каталога-файлообменника `drwxrwxrwt`.
6. `ps`, `ps aux --sort=-%mem | head`, `ps aux --sort=-%cpu | head`.
7. `ps -p 1 -f`.
8. `jobs` после остановки `find` и `man bash`.
