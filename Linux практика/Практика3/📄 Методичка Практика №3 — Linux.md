# 📄 Методичка Практика №3 — PostgreSQL в Docker (ALT Linux)

## Цель работы

Развернуть PostgreSQL в Docker-контейнере в ALT Linux, создать базу данных `lab_db`, импортировать дамп `dump.sql`, проверить таблицы и сохранить JDBC-строку подключения.

---

## 1. Подготовка рабочей папки

Перейти в папку лабораторной работы:

```bash
cd ~/lab3
```

Проверить, что в папке есть нужные файлы:

```bash
ls
```

Ожидаемо должны быть файлы:

```text
docker-compose.yaml
dump.sql
```

> Если файлов нет, нужно сначала поместить `docker-compose.yaml` и `dump.sql` в папку `~/lab3`.

---

## 2. Установка Docker в ALT Linux

### 2.1. Ошибка с sudo

Если при выполнении команды через `sudo` появляется ошибка:

```text
gregory отсутствует в файле sudoers
```

значит нужно перейти в режим `root`:

```bash
su -
```

Введите пароль пользователя `root`.

---

### 2.2. Установка Docker Engine и Docker Compose

В ALT Linux пакет называется не `docker`, а `docker-engine`.

Выполнить от имени `root`:

```bash
apt-get update
apt-get install docker-engine docker-compose -y
```

Запустить службу Docker:

```bash
systemctl enable --now docker.service
```

Проверить состояние службы:

```bash
systemctl status docker
```

Ожидаемо должно быть:

```text
Active: active (running)
```

📸 **Скриншот 1 — Установка Docker Engine и запуск службы Docker**

На скриншоте должно быть видно:

- команду `systemctl enable --now docker.service`;
- команду `systemctl status docker`;
- статус `active (running)`.

---

## 3. Добавление пользователя в группу docker

Чтобы запускать Docker без `root`, нужно добавить обычного пользователя в группу `docker`.

От имени `root` выполнить:

```bash
usermod -aG docker gregory
```

Выйти из `root`:

```bash
exit
```

Если появилось сообщение:

```text
Есть остановленные задания.
```

ещё раз выполнить:

```bash
exit
```

Затем нужно выйти из SSH-сессии и подключиться заново:

```bash
exit
```

После повторного входа проверить группы пользователя:

```bash
groups
```

В списке должна быть группа:

```text
docker
```

📸 **Скриншот 2 — Проверка пользователя в группе docker**

На скриншоте должно быть видно:

- команду `groups`;
- наличие группы `docker` в списке.

---

## 4. Исправление docker-compose.yaml

При использовании образа `postgres:latest` может возникнуть ошибка:

```text
unauthorized: authentication required
```

Поэтому лучше заменить `latest` на конкретную версию `postgres:16`.

Открыть файл:

```bash
nano docker-compose.yaml
```

Найти строку:

```yaml
image: postgres:latest
```

Заменить на:

```yaml
image: postgres:16
```

Сохранить файл:

```text
Ctrl + O, Enter, Ctrl + X
```

Итоговый `docker-compose.yaml` должен выглядеть примерно так:

```yaml
services:
  postgres:
    image: postgres:16
    container_name: pg_lab_container
    environment:
      POSTGRES_PASSWORD: lab_password
      POSTGRES_USER: postgres
    ports:
      - "5432:5432"
    volumes:
      - pg_lab_data:/var/lib/postgresql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  pg_lab_data:
    name: pg_lab_data
```

---

## 5. Запуск PostgreSQL-контейнера

Перейти в папку лабораторной:

```bash
cd ~/lab3
```

Скачать образ PostgreSQL:

```bash
docker-compose pull
```

Запустить контейнер:

```bash
docker-compose up -d
```

Проверить контейнер:

```bash
docker ps
```

Проверить готовность PostgreSQL:

```bash
docker exec pg_lab_container pg_isready -U postgres
```

Ожидаемый результат:

```text
/var/run/postgresql:5432 - accepting connections
```

📸 **Скриншот 3 — Запуск PostgreSQL-контейнера и проверка состояния**

На скриншоте должно быть видно:

- `docker-compose pull`;
- `docker-compose up -d`;
- `docker ps`;
- контейнер `pg_lab_container` со статусом `healthy`;
- `pg_isready` с результатом `accepting connections`.

---

## 6. Создание базы данных lab_db

Создать bash-скрипт:

```bash
nano create_db.sh
```

Вставить содержимое:

```bash
#!/bin/bash

docker exec pg_lab_container psql -U postgres -c "CREATE DATABASE lab_db;"

if [ $? -eq 0 ]; then
    echo "База данных lab_db создана"
else
    echo "Ошибка при создании базы данных"
fi
```

Сохранить файл:

```text
Ctrl + O, Enter, Ctrl + X
```

Сделать скрипт исполняемым:

```bash
chmod +x create_db.sh
```

Запустить скрипт:

```bash
./create_db.sh
```

Ожидаемый вывод:

```text
CREATE DATABASE
База данных lab_db создана
```

📸 **Скриншот 4 — Создание базы данных lab_db через create_db.sh**

На скриншоте должно быть видно:

- команду `chmod +x create_db.sh`;
- запуск `./create_db.sh`;
- сообщение `База данных lab_db создана`.

---

## 7. Импорт дампа dump.sql

Создать bash-скрипт импорта:

```bash
nano import_dump.sh
```

Вставить содержимое:

```bash
#!/bin/bash

docker exec -i pg_lab_container psql -U postgres -d lab_db < dump.sql

if [ $? -eq 0 ]; then
    echo "Дамп успешно импортирован"
else
    echo "Ошибка при импорте дампа"
fi
```

Сохранить файл:

```text
Ctrl + O, Enter, Ctrl + X
```

Если при запуске появляется ошибка:

```text
-bash: ./import_dump.sh: Отказано в доступе
```

нужно выдать права на выполнение:

```bash
chmod +x import_dump.sh
```

Запустить скрипт:

```bash
./import_dump.sh
```

Ожидаемый вывод может содержать строки:

```text
CREATE TABLE
INSERT 0 3
CREATE INDEX
Дамп успешно импортирован
```

📸 **Скриншот 5 — Импорт dump.sql в базу данных lab_db**

На скриншоте должно быть видно:

- ошибку `Отказано в доступе`, если она была;
- команду `chmod +x import_dump.sh`;
- запуск `./import_dump.sh`;
- сообщение `Дамп успешно импортирован`.

---

## 8. Проверка таблиц после импорта

Подключиться к базе данных:

```bash
docker exec -it pg_lab_container psql -U postgres -d lab_db
```

Внутри PostgreSQL выполнить:

```sql
\dt
```

Ожидаемо должны появиться таблицы:

```text
public | orders   | table | postgres
public | products | table | postgres
public | users    | table | postgres
```

Выйти из PostgreSQL:

```sql
\q
```

📸 **Скриншот 6 — Проверка таблиц после импорта дампа**

На скриншоте должно быть видно:

- подключение через `psql`;
- команду `\dt`;
- таблицы `orders`, `products`, `users`.

---

## 9. Создание JDBC-строки подключения

Создать файл `jdbc.txt`:

```bash
echo "jdbc:postgresql://localhost:5432/lab_db?user=postgres&password=lab_password" > jdbc.txt
```

Проверить содержимое файла:

```bash
cat jdbc.txt
```

Ожидаемый вывод:

```text
jdbc:postgresql://localhost:5432/lab_db?user=postgres&password=lab_password
```

📸 **Скриншот 7 — JDBC-строка подключения в файле jdbc.txt**

На скриншоте должно быть видно:

- команду создания `jdbc.txt`;
- команду `cat jdbc.txt`;
- JDBC-строку подключения.

---

## 10. Дополнительные скриншоты со скриптами

Для более полного отчёта желательно показать содержимое созданных скриптов.

Показать скрипт создания базы данных:

```bash
cat create_db.sh
```

📸 **Скриншот 8 — Содержимое скрипта create_db.sh**

Показать скрипт импорта дампа:

```bash
cat import_dump.sh
```

📸 **Скриншот 9 — Содержимое скрипта import_dump.sh**

---

## 11. Факультативное задание: интерактивный клиент

Если нужно выполнить дополнительный пункт задания, можно создать простой клиент с меню.

Создать файл:

```bash
nano db_client.sh
```

Вставить содержимое:

```bash
#!/bin/bash

while true
do
    echo "=============================="
    echo "Клиент PostgreSQL"
    echo "=============================="
    echo "1. Показать список таблиц"
    echo "2. Выполнить SQL запрос"
    echo "3. Показать JDBC строку"
    echo "4. Выход"
    echo "=============================="

    read -p "Выберите пункт: " choice

    case $choice in
        1)
            docker exec -it pg_lab_container psql -U postgres -d lab_db -c "\dt"
            ;;
        2)
            read -p "Введите SQL запрос: " sql_query
            docker exec -it pg_lab_container psql -U postgres -d lab_db -c "$sql_query"
            ;;
        3)
            cat jdbc.txt
            ;;
        4)
            echo "Выход из программы"
            exit 0
            ;;
        *)
            echo "Неверный пункт меню"
            ;;
    esac
done
```

Сделать исполняемым:

```bash
chmod +x db_client.sh
```

Запустить:

```bash
./db_client.sh
```

📸 **Скриншот 10 — Работа интерактивного клиента db_client.sh**

Этот скриншот нужен только для факультативного задания.

---

## 12. Частые ошибки и решения

### Ошибка 1. Пользователь не в sudoers

Ошибка:

```text
gregory отсутствует в файле sudoers
```

Решение:

```bash
su -
```

Далее команды выполнять от имени `root`.

---

### Ошибка 2. Пакет docker не найден

Ошибка:

```text
E: Для пакета docker не найдено подходящего кандидата для установки
```

Решение:

```bash
apt-get install docker-engine docker-compose -y
```

---

### Ошибка 3. docker.service не найден

Если Docker ещё не установлен, будет ошибка:

```text
Unit docker.service could not be found
```

Решение:

```bash
apt-get install docker-engine docker-compose -y
systemctl enable --now docker.service
```

---

### Ошибка 4. newgrp docker — отказано в доступе

Ошибка:

```text
/usr/bin/newgrp: Отказано в доступе
```

Решение: выйти из SSH-сессии и подключиться заново.

```bash
exit
```

После повторного входа проверить:

```bash
groups
```

---

### Ошибка 5. postgres:latest не скачивается

Ошибка:

```text
unauthorized: authentication required
```

Решение: заменить в `docker-compose.yaml`:

```yaml
image: postgres:latest
```

на:

```yaml
image: postgres:16
```

Затем выполнить:

```bash
docker-compose pull
docker-compose up -d
```

---

### Ошибка 6. Скрипт не запускается

Ошибка:

```text
-bash: ./import_dump.sh: Отказано в доступе
```

Решение:

```bash
chmod +x import_dump.sh
./import_dump.sh
```

---

## 13. Итоговый список скриншотов для отчёта

| № рисунка | Что показать |
|---|---|
| Рисунок 1 | Установка Docker Engine и статус `active (running)` |
| Рисунок 2 | Проверка группы `docker` у пользователя |
| Рисунок 3 | Запуск контейнера PostgreSQL, `docker ps`, `pg_isready` |
| Рисунок 4 | Создание базы данных `lab_db` через `create_db.sh` |
| Рисунок 5 | Импорт `dump.sql` через `import_dump.sh` |
| Рисунок 6 | Проверка таблиц через `\dt` |
| Рисунок 7 | Создание и просмотр `jdbc.txt` |
| Рисунок 8 | Содержимое `create_db.sh` |
| Рисунок 9 | Содержимое `import_dump.sh` |
| Рисунок 10 | Работа `db_client.sh`, если выполняется факультатив |

---

## 14. Итоговый чек-лист выполнения

| Пункт задания | Статус |
|---|---|
| Docker установлен | ✅ |
| Docker запущен | ✅ |
| Пользователь добавлен в группу docker | ✅ |
| PostgreSQL-контейнер запущен | ✅ |
| База `lab_db` создана | ✅ |
| Дамп `dump.sql` импортирован | ✅ |
| Таблицы проверены | ✅ |
| JDBC-строка сохранена | ✅ |
| Скрипт `create_db.sh` создан | ✅ |
| Скрипт `import_dump.sh` создан | ✅ |

---

## 15. Вывод для отчёта

В ходе выполнения лабораторной работы была настроена контейнеризированная среда PostgreSQL в операционной системе ALT Linux. С помощью Docker Compose был загружен и запущен контейнер PostgreSQL. Далее был создан bash-скрипт для автоматического создания базы данных `lab_db`, а также скрипт для импорта дампа `dump.sql`. После импорта была выполнена проверка структуры базы данных через команду `\dt`, где были отображены таблицы `orders`, `products` и `users`. Также была сформирована JDBC-строка подключения и сохранена в файл `jdbc.txt`. Лабораторная работа выполнена успешно.

