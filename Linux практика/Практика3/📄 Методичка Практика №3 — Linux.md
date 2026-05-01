Лабораторная работа №3 — PostgreSQL в Docker (ALT Linux)

1. Подготовка рабочей директории

Перейти в папку с файлами лабораторной:

ls

Проверить наличие файлов:

docker-compose.yaml
dump.sql

⸻

2. Установка Docker и Docker Compose

sudo dnf install docker docker-compose -y
sudo systemctl enable --now docker
systemctl status docker

Добавить пользователя в группу Docker:

sudo usermod -aG docker $USER
newgrp docker

При необходимости:

sudo chmod 666 /var/run/docker.sock

⸻

Скриншот 1 – Установка Docker и проверка службы Docker

⸻

3. Запуск контейнера PostgreSQL

docker-compose up -d

Проверка контейнера:

docker ps

Проверка готовности PostgreSQL:

docker exec pg_lab_container pg_isready -U postgres

⸻

Скриншот 2 – Запуск PostgreSQL контейнера через docker-compose и проверка статуса

⸻

4. Создание базы данных lab_db

Создать файл:

nano create_db.sh

Содержимое:

#!/bin/bash
docker exec pg_lab_container psql -U postgres -c "CREATE DATABASE lab_db;"
if [ $? -eq 0 ]; then
    echo "База данных lab_db создана"
else
    echo "Ошибка при создании базы данных"
fi

Сделать исполняемым:

chmod +x create_db.sh

Запуск:

./create_db.sh

⸻

Скриншот 3 – Выполнение скрипта create_db.sh и создание базы данных

⸻

5. Импорт дампа в созданную БД

Создать файл:

nano import_dump.sh

Содержимое:

#!/bin/bash
docker exec -i pg_lab_container psql -U postgres -d lab_db < dump.sql
if [ $? -eq 0 ]; then
    echo "Дамп успешно импортирован"
else
    echo "Ошибка при импорте дампа"
fi

Сделать исполняемым:

chmod +x import_dump.sh

Запуск:

./import_dump.sh

⸻

Скриншот 4 – Импорт dump.sql в базу данных через import_dump.sh

⸻

6. Проверка подключения к PostgreSQL

docker exec -it pg_lab_container psql -h localhost -p 5432 -U postgres -d lab_db

После подключения:

\dt

Выйти:

\q

⸻

Скриншот 5 – Подключение к базе данных и вывод списка таблиц

⸻

7. Создание JDBC-строки подключения

echo "jdbc:postgresql://localhost:5432/lab_db?user=postgres&password=lab_password" > jdbc.txt

Проверка:

cat jdbc.txt

⸻

Скриншот 6 – Содержимое файла jdbc.txt с JDBC-строкой подключения

⸻

8. Факультативно — клиент с интерактивным меню

Создать:

nano db_client.sh

Содержимое:

#!/bin/bash
while true
do
    echo "=============================="
    echo "Клиент для работы с PostgreSQL"
    echo "=============================="
    echo "1. Показать список таблиц"
    echo "2. Выполнить SQL запрос"
    echo "3. Показать JDBC строку"
    echo "4. Выход"
    read -p "Выберите пункт меню: " choice
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
            exit 0
            ;;
        *)
            echo "Неверный пункт"
            ;;
    esac
done

Сделать исполняемым:

chmod +x db_client.sh

Запуск:

./db_client.sh

⸻

Скриншот 7 – Работа интерактивного клиента db_client.sh (если выполняется факультативное задание)

⸻

Итоговый комплект скриншотов для отчёта:

№	Что должно быть на скриншоте
1	Установка Docker + systemctl status docker
2	docker-compose up -d + docker ps
3	create_db.sh
4	import_dump.sh
5	psql подключение + \dt
6	jdbc.txt
7	db_client.sh (по желанию)

⸻

Финальный результат лабораторной:

* PostgreSQL контейнер поднят
* База lab_db создана
* Дамп импортирован
* JDBC строка сохранена
* Подключение проверено
* Bash-скрипты реализованы
* (Дополнительно) клиентское меню создано
