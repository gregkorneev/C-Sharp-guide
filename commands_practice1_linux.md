# Команды из отчёта «Практическое задание 1 — Linux»

## 1. Подключение по SSH

```bash
ip a
```

> В отчёте указано, что подключение к ВМ было выполнено из терминала macOS, но сама команда `ssh ...` в тексте отчёта не приведена.

## 2. Работа с файлами

### 2.1. Определение текущего каталога

```bash
pwd
```

### 2.2. Создание каталога и подкаталогов

```bash
mkdir practice
mkdir dir1 dir2 dir3
```

### 2.3. Создание файлов

```bash
touch file1.txt file2.txt
```

### 2.4. Копирование файла

```bash
cp file1.txt dir1/
```

### 2.5. Перемещение файла

```bash
mv file2.txt dir2/
```

### 2.6. Проверка содержимого каталогов

```bash
cd ./practice
ls
cd ..
ls
```

### 2.7. Удаление файла и каталога

```bash
rm file1.txt
rm -r dir3
```

### 2.8. Проверка чувствительности к регистру

```bash
touch test.txt
touch Test.txt
```

## 3. Архивирование файлов

### 3.1. Создание файлов

```bash
touch file1.txt file2.txt file3.txt
```

### 3.2. Создание архива

```bash
tar -cvf archive.tar file1.txt file2.txt file3.txt
```

### 3.3. Просмотр содержимого архива

```bash
tar -tvf archive.tar
```

### 3.4. Распаковка архива

```bash
tar -xvf archive.tar
```

### 3.5. Создание сжатого архива

```bash
tar -czvf archive.tar.gz file1.txt file2.txt file3.txt
```

## 4. Разметка диска и монтирование разделов

### 4.1. Просмотр дисков

```bash
lsblk
```

### 4.2. Определение файловых систем

```bash
lsblk -f
```

### 4.3. Проверка монтирования

```bash
df -h
```

### 4.4. Проверка точек монтирования

```bash
ls /mnt
```

### 4.5. Проверка содержимого точек монтирования

```bash
ls /mnt/disk1
ls /mnt/disk2
```

## 5. Все команды одним блоком

```bash
ip a

pwd

mkdir practice
mkdir dir1 dir2 dir3

touch file1.txt file2.txt

cp file1.txt dir1/

mv file2.txt dir2/

cd ./practice
ls
cd ..
ls

rm file1.txt
rm -r dir3

touch test.txt
touch Test.txt

touch file1.txt file2.txt file3.txt

tar -cvf archive.tar file1.txt file2.txt file3.txt

tar -tvf archive.tar

tar -xvf archive.tar

tar -czvf archive.tar.gz file1.txt file2.txt file3.txt

lsblk

lsblk -f

df -h

ls /mnt

ls /mnt/disk1
ls /mnt/disk2
```
