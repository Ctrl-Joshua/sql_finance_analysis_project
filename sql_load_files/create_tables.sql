CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL
);

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    segment VARCHAR(50) NOT NULL
);

CREATE TABLE regions (
    region_id VARCHAR(10) PRIMARY KEY,
    region_name VARCHAR(50) NOT NULL
);

CREATE TABLE transactions (
    transaction_id VARCHAR(10) PRIMARY KEY,
    transaction_date DATE NOT NULL,
    product_id VARCHAR(10) NOT NULL,
    customer_id VARCHAR(10) NOT NULL,
    region_id VARCHAR(10) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    revenue NUMERIC(12, 2) NOT NULL CHECK (revenue >= 0),
    cost NUMERIC(12, 2) NOT NULL CHECK (cost >= 0),

    CONSTRAINT fk_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT fk_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_region
        FOREIGN KEY (region_id)
        REFERENCES regions(region_id)
);

CREATE INDEX idx_transactions_date
ON transactions (transaction_date);

CREATE INDEX idx_transactions_product
ON transactions (product_id);

CREATE INDEX idx_transactions_customer
ON transactions (customer_id);

CREATE INDEX idx_transactions_region
ON transactions (region_id);
