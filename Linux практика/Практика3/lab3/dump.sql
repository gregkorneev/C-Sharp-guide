-- Пример дампа базы данных для лабораторной работы

-- Создание таблицы пользователей
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Создание таблицы продуктов
CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INTEGER DEFAULT 0
);

-- Создание таблицы заказов
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2)
);

-- Вставка тестовых данных
INSERT INTO users (username, email) VALUES 
    ('ivanov', 'ivanov@example.com'),
    ('petrov', 'petrov@example.com'),
    ('sidorov', 'sidorov@example.com');

INSERT INTO products (name, price, stock) VALUES 
    ('Ноутбук', 45000.00, 10),
    ('Мышь', 1500.00, 50),
    ('Клавиатура', 2500.00, 30);

INSERT INTO orders (user_id, total_amount) VALUES 
    (1, 46500.00),
    (2, 1500.00);

-- Создание индексов для оптимизации
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_id ON orders(user_id);

-- Вывод информации о загруженных данных
SELECT 'Дамп успешно загружен!' as status;
SELECT COUNT(*) as users_count FROM users;
SELECT COUNT(*) as products_count FROM products;
SELECT COUNT(*) as orders_count FROM orders;