-- Online Retail Store Database Project
----------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Create Database
CREATE DATABASE OnlineRetailStore;
USE OnlineRetailStore;
----------------------------------------------------------------------------------------------------------------------------------------------
-- 2. Create Tables
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    City VARCHAR(50),
    state VARCHAR(50));
    
select*from customers;

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Stock INT);

select*from products;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID));

select*from orders;

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID));

select*from orderdetails;

----------------------------------------------------------------------------------------------------------------------------------------------
-- 3. Insert Sample Data

INSERT INTO Customers (customerID,FirstName, LastName, Email, Phone, City, state) VALUES
('1','murali', 'sathyanarayanan', 'muralisathya@gmail.com', '9876333210', 'trichy', 'tamil nadu'),
('2','mohamad', 'aslam', 'aslam56@gmail.com', '9123566780', 'nellore', 'andhra pradesh'),
('3','anjali', 'b menon', 'anjalib@gmail.com', '9957876655', 'kozhikode', 'kerala');

select*from customers;

INSERT INTO Products (productID,ProductName, Category, Price, Stock) VALUES
('101','Laptop', 'Electronics', 750.00, 10),
('201','Smartphone', 'Electronics', 500.00, 25),
('301','Headphones', 'Accessories', 50.00, 100);

select*from products;

INSERT INTO Orders (orderID,CustomerID, OrderDate, TotalAmount) VALUES
(455,1, '2025-08-01', 1250.00),
(456,2, '2025-08-02', 500.00);

select*from orders;

INSERT INTO OrderDetails (orderdetailID,OrderID, ProductID, Quantity) VALUES
(1,455,101,2),
(2,456,201,1);

select*from orderdetails;

----------------------------------------------------------------------------------------------------------------------------------------------
-- 4. Queries

-- Find all customers from India

SELECT * FROM Customers WHERE state = 'kerala';

-- List all products with stock less than 20

SELECT ProductName, Stock FROM Products WHERE Stock < 20;

-- total sales using agregrate function

SELECT c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;

-- Get top-selling product

SELECT p.ProductName, SUM(od.Quantity) AS TotalSold
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID
ORDER BY TotalSold DESC
LIMIT 1;
----------------------------------------------------------------------------------------------------------------------------------------------
-- 5. store procedure
-- list products with low stock

DELIMITER //
CREATE PROCEDURE GetLowStockProducts(IN threshhold INT)
BEGIN
    SELECT ProductName, Stock FROM Products WHERE Stock < threshold;
END //
DELIMITER ;

CALL GetLowStockProducts(20);

---------------------------------------------------------------------------------------------------------------------------------------------
-- 6. cte
-- customer by state 

WITH tamilcustomers AS (SELECT * FROM Customers WHERE state = 'tamil nadu')
SELECT * FROM tamilcustomers;
----------------------------------------------------------------------------------------------------------------------------------------------
-- 7. sub query
-- customers from andra pradesh

SELECT * FROM Customers 
WHERE CustomerID IN (SELECT CustomerID FROM Customers 
    WHERE state = 'andhra pradesh');
----------------------------------------------------------------------------------------------------------------------------------------------
-- 8.triggers
-- update product stock after new orderdetail

DELIMITER //
CREATE TRIGGER UpdateStockAfterOrder
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Products
    SET Stock = Stock - NEW.Quantity
    WHERE ProductID = NEW.ProductID;
END;
//
DELIMITER ;
----------------------------------------------------------------------------------------------------------------------------------------------