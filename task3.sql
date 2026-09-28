create database if not exists Amazon;
use Amazon;

CREATE TABLE Category (
  Category_ID    INT PRIMARY KEY,
  Category_Name  VARCHAR(50) NOT NULL UNIQUE,
  Description    VARCHAR(255),
  price_range    INT NOT NULL
);

CREATE TABLE Product (
  Product_ID     INT PRIMARY KEY,
  Product_Name   VARCHAR(100) NOT NULL,
  Category_ID    INT NOT NULL,
  P_description  VARCHAR(250),
  Price          INT NOT NULL
);

ALTER TABLE Product
ADD CONSTRAINT link
FOREIGN KEY (Category_ID) REFERENCES category(Category_ID);

INSERT INTO category (Category_ID, Category_Name, Description, price_range) VALUES
(1, 'Phone', 'electronics', 30000),
(2, 'Laptop', 'electronics', 60000),
(3, 'Watch', 'wearables', 8000),
(4, 'Camera', 'electronics', 40000),
(5, 'Joystick', 'Gaming accessories', 2500);

INSERT INTO Product (Product_ID, Product_Name, Category_ID, P_description, Price) VALUES
(1, 'Samsung S21', 1, '8GB RAM,256GB ROM', 45000),
(2, 'Asus Vivobook 15', 2, 'Intel i7 13gen, rtx 3050', 95000),
(3, 'Fastrack', 3, 'automatic', 27000),
(4, 'Canon R10', 4, 'Mirrorless camera', 78000),
(5, 'PlayStation 5', 5, '1TBSSD', 49900);

CREATE TABLE Seller (
  Seller_ID    INT NOT NULL PRIMARY KEY,
  Seller_Name  VARCHAR(50) NOT NULL,
  Phone        BIGINT NOT NULL UNIQUE,
  Email        VARCHAR(50) NOT NULL UNIQUE,
  Address      VARCHAR(150) NOT NULL
);

desc Seller;

create table inventory (
  inventory_id    int not null primary key auto_increment,
  product_id      int not null,
  seller_id       int not null,
  stock_quantity  int not null default 0 check (stock_quantity >= 0),
  stock_status    varchar(100) not null default 'Out of stock'
                  check (stock_status in ('In stock', 'Low stock', 'Out of stock')),
  last_updated    date default (current_date()),
  constraint uq_product_seller unique (product_id, seller_id)
);

ALTER TABLE inventory
ADD CONSTRAINT IS_link
FOREIGN KEY (product_id) REFERENCES Product(Product_ID);

ALTER TABLE inventory
ADD CONSTRAINT IS_seller_link
FOREIGN KEY (seller_id) REFERENCES Seller(Seller_ID);

desc inventory;



ALTER TABLE Product
ADD COLUMN Stock_Quantity INT NOT NULL DEFAULT 0;

ALTER TABLE Product
ADD CONSTRAINT chk_product_price CHECK (Price > 0);

ALTER TABLE Product
ADD CONSTRAINT chk_product_stock CHECK (Stock_Quantity >= 0);

UPDATE Product
SET Stock_Quantity = CASE Product_ID
    WHEN 1 THEN 50
    WHEN 2 THEN 25
    WHEN 3 THEN 80
    WHEN 4 THEN 30
    WHEN 5 THEN 40
END
WHERE Product_ID IN (1, 2, 3, 4, 5);

INSERT INTO Product (Product_ID, Product_Name, Category_ID, P_description, Price, Stock_Quantity) VALUES
(6, 'iPhone 13', 1, '4GB RAM,128GB ROM', 59900, 45),
(7, 'OnePlus 11', 1, '16GB RAM,256GB ROM', 56999, 35),
(8, 'Redmi Note 12', 1, '6GB RAM,128GB ROM', 15999, 200),
(9, 'Realme 11 Pro', 1, '8GB RAM,256GB ROM', 23999, 90),
(10, 'Vivo V27', 1, '8GB RAM,128GB ROM', 32999, 70),
(11, 'HP Pavilion 14', 2, 'Intel i5 12gen, 16GB RAM', 68000, 20),
(12, 'Noise ColorFit Pro', 3, 'smartwatch', 4999, 150);

INSERT INTO Product (Product_ID, Product_Name, Category_ID, P_description, Price, Stock_Quantity)
VALUES (13, 'Wireless Mouse', 5, 'Bluetooth optical mouse', 599, 150);

SELECT * FROM Product;

SELECT * FROM Product WHERE Product_Name = 'Wireless Mouse';

UPDATE Product
SET Price = 549, Stock_Quantity = 140
WHERE Product_Name = 'Wireless Mouse';

DELETE FROM Product WHERE Product_Name = 'Wireless Mouse';

SELECT c.Category_Name, p.Product_Name, p.Price, p.Stock_Quantity
FROM Product p
JOIN category c ON p.Category_ID = c.Category_ID
ORDER BY c.Category_Name;

SELECT c.Category_Name, COUNT(p.Product_ID) AS Total_Products
FROM category c
LEFT JOIN Product p ON c.Category_ID = p.Category_ID
GROUP BY c.Category_Name;

SELECT Product_Name, Price
FROM Product
ORDER BY Price DESC
LIMIT 1;

SELECT c.Category_Name, COUNT(p.Product_ID) AS Total_Products
FROM category c
JOIN Product p ON c.Category_ID = p.Category_ID
GROUP BY c.Category_Name
HAVING COUNT(p.Product_ID) > 5;

SELECT ROUND(AVG(Price), 2) AS Average_Price
FROM Product;

SELECT c.Category_Name, ROUND(AVG(p.Price), 2) AS Average_Price
FROM category c
JOIN Product p ON c.Category_ID = p.Category_ID
GROUP BY c.Category_Name;

ALTER TABLE Product
ADD COLUMN Seller_ID INT NULL;

ALTER TABLE Product
ADD CONSTRAINT product_seller_link
FOREIGN KEY (Seller_ID) REFERENCES Seller(Seller_ID);

INSERT INTO Seller (Seller_ID, Seller_Name, Phone, Email, Address) VALUES
(1, 'TechZone Retailers', 9876543210, 'contact@techzone.com', 'Chennai, Tamil Nadu'),
(2, 'GadgetHub India', 9876543211, 'support@gadgethub.com', 'Bengaluru, Karnataka'),
(3, 'SnapMart', 9876543212, 'sales@snapmart.com', 'Mumbai, Maharashtra'),
(4, 'Gadget World', 9876543213, 'hello@gadgetworld.com', 'Hyderabad, Telangana');

INSERT INTO Seller (Seller_ID, Seller_Name, Phone, Email, Address)
VALUES (5, 'Coimbatore Electronics', 9876543214, 'info@cbeelectronics.com', 'Coimbatore, Tamil Nadu');

UPDATE Product SET Seller_ID = 1 WHERE Product_ID IN (1, 6, 7);
UPDATE Product SET Seller_ID = 2 WHERE Product_ID IN (2, 11, 12);
UPDATE Product SET Seller_ID = 3 WHERE Product_ID IN (3, 4, 5);
UPDATE Product SET Seller_ID = 4 WHERE Product_ID IN (8, 9, 10);

INSERT INTO inventory (product_id, seller_id, stock_quantity, stock_status) VALUES
(1, 1, 50, 'In stock'),
(6, 1, 35, 'In stock'),
(7, 1, 8, 'Low stock'),
(2, 2, 25, 'In stock'),
(11, 2, 0, 'Out of stock'),
(12, 2, 60, 'In stock'),
(3, 3, 45, 'In stock'),
(4, 3, 0, 'Out of stock'),
(5, 3, 6, 'Low stock'),
(8, 4, 120, 'In stock'),
(9, 4, 0, 'Out of stock'),
(10, 4, 15, 'In stock');

SELECT * FROM Seller;

SELECT * FROM inventory;

SELECT s.Seller_ID, s.Seller_Name, p.Product_ID, p.Product_Name, p.Price
FROM Seller s
JOIN Product p ON s.Seller_ID = p.Seller_ID
ORDER BY s.Seller_ID;

SELECT s.Seller_ID, s.Seller_Name, COUNT(p.Product_ID) AS Total_Products
FROM Seller s
LEFT JOIN Product p ON s.Seller_ID = p.Seller_ID
GROUP BY s.Seller_ID, s.Seller_Name;

UPDATE Seller
SET Phone = 9998887770, Address = 'Chennai, Tamil Nadu - 600001'
WHERE Seller_ID = 1;

SELECT p.Product_Name, s.Seller_Name, i.stock_quantity, i.stock_status
FROM inventory i
JOIN Product p ON i.product_id = p.Product_ID
JOIN Seller s ON i.seller_id = s.Seller_ID
WHERE i.stock_quantity > 0;

SELECT p.Product_Name, s.Seller_Name, i.stock_quantity
FROM inventory i
JOIN Product p ON i.product_id = p.Product_ID
JOIN Seller s ON i.seller_id = s.Seller_ID
WHERE i.stock_quantity = 0;

SELECT p.Product_Name, s.Seller_Name, i.stock_quantity
FROM inventory i
JOIN Product p ON i.product_id = p.Product_ID
JOIN Seller s ON i.seller_id = s.Seller_ID
WHERE i.stock_quantity < 10;

UPDATE inventory
SET stock_quantity = 30, stock_status = 'In stock', last_updated = current_date()
WHERE product_id = 11 AND seller_id = 2;

DELETE FROM inventory
WHERE product_id = 9 AND seller_id = 4 AND stock_quantity = 0;

SELECT s.Seller_Name, p.Product_Name, i.stock_quantity, i.stock_status
FROM Seller s
JOIN inventory i ON s.Seller_ID = i.seller_id
JOIN Product p ON i.product_id = p.Product_ID
ORDER BY s.Seller_Name, p.Product_Name;

SELECT stock_status, COUNT(*) AS Product_Count
FROM inventory
GROUP BY stock_status;

SELECT COUNT(*) AS Total_Available_Products
FROM inventory
WHERE stock_quantity > 0;

SELECT p.Product_Name, s.Seller_Name
FROM inventory i
JOIN Product p ON i.product_id = p.Product_ID
JOIN Seller s ON i.seller_id = s.Seller_ID
WHERE i.stock_status = 'Out of stock';

SELECT p.Product_Name, s.Seller_Name, i.stock_quantity
FROM inventory i
JOIN Product p ON i.product_id = p.Product_ID
JOIN Seller s ON i.seller_id = s.Seller_ID
ORDER BY i.stock_quantity DESC
LIMIT 1;

SELECT ROUND(AVG(stock_quantity), 2) AS Average_Inventory_Quantity
FROM inventory;

SELECT s.Seller_Name, ROUND(AVG(i.stock_quantity), 2) AS Average_Stock
FROM Seller s
JOIN inventory i ON s.Seller_ID = i.seller_id
GROUP BY s.Seller_Name;