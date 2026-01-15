COPY products
FROM 'C:\Program Files\PostgreSQL\18\data\imports\products.csv'
DELIMITER ','
CSV HEADER;

COPY customers
FROM 'C:\Program Files\PostgreSQL\18\data\imports\customers.csv'
DELIMITER ','
CSV HEADER;

COPY regions
FROM 'C:\Program Files\PostgreSQL\18\data\imports\regions.csv'
DELIMITER ','
CSV HEADER;

COPY transactions
FROM 'C:\Program Files\PostgreSQL\18\data\imports\transactions_4000.csv'
DELIMITER ','
CSV HEADER;


