-- Online Retail Store Database Project
----------------------------------------------------------------------------------------------------------------------------------------------
-- 1. Create Database
CREATE DATABASE OnlineRetailStore_NEW;
USE OnlineRetailStore_NEW;
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

USE OnlineRetailStore_NEW;
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone, City, state) VALUES
(4,'Arjun','Reddy','arjunreddy@gmail.com','9001112233','Hyderabad','Telangana'),
(5,'Kavya','Sharma','kavyasharma@gmail.com','9112233445','Chennai','Tamil Nadu'),
(6,'Rahul','Mehta','rahulmehta@gmail.com','9223344556','Mumbai','Maharashtra'),
(7,'Sneha','Patel','snehapatel@gmail.com','9334455667','Ahmedabad','Gujarat'),
(8,'Vignesh','Krishnan','vigneshk@gmail.com','9445566778','Madurai','Tamil Nadu'),
(9,'Ramesh','Kumar','rameshkumar@gmail.com','9556677889','Coimbatore','Tamil Nadu'),
(10,'Priya','Nair','priyanair@gmail.com','9667788990','Kochi','Kerala'),
(11,'Vikram','Singh','vikramsingh@gmail.com','9778899001','Jaipur','Rajasthan'),
(12,'Meena','Joshi','meenajoshi@gmail.com','9889900112','Pune','Maharashtra'),
(13,'Suresh','Rao','sureshrao@gmail.com','9991001223','Bangalore','Karnataka'),
(14,'Divya','Kapoor','divyakapoor@gmail.com','9002113344','Delhi','Delhi'),
(15,'Anand','Shah','anandshah@gmail.com','9113224455','Surat','Gujarat'),
(16,'Lakshmi','Iyer','lakshmiiyer@gmail.com','9224335566','Chennai','Tamil Nadu'),
(17,'Kiran','Das','kirandas@gmail.com','9335446677','Kolkata','West Bengal'),
(18,'Neha','Verma','nehaverma@gmail.com','9446557788','Lucknow','Uttar Pradesh'),
(19,'Ajay','Menon','ajaymenon@gmail.com','9557668899','Trivandrum','Kerala'),
(20,'Pooja','Rathore','poojarathore@gmail.com','9668779900','Indore','Madhya Pradesh'),
(21,'Manoj','Gupta','manojgupta@gmail.com','9779880011','Patna','Bihar'),
(22,'Shalini','Pillai','shalinipillai@gmail.com','9880991122','Chennai','Tamil Nadu'),
(23,'Deepak','Chowdhury','deepakch@gmail.com','9991002233','Kolkata','West Bengal'),
(24,'Aarti','Mishra','aartimishra@gmail.com','9001223344','Kanpur','Uttar Pradesh'),
(25,'Rohit','Bansal','rohitbansal@gmail.com','9112334455','Delhi','Delhi'),
(26,'Gayathri','Sundar','gayathris@gmail.com','9223445566','Coimbatore','Tamil Nadu'),
(27,'Nikhil','Jain','nikhiljain@gmail.com','9334556677','Jaipur','Rajasthan'),
(28,'Swathi','Rao','swathirao@gmail.com','9445667788','Hyderabad','Telangana'),
(29,'Varun','Kapoor','varunkapoor@gmail.com','9556778899','Mumbai','Maharashtra'),
(30,'Anitha','Krishnan','anithak@gmail.com','9667889900','Madurai','Tamil Nadu'),
(31,'Santosh','Patel','santoshpatel@gmail.com','9778990011','Ahmedabad','Gujarat'),
(32,'Bhavana','Shah','bhavanashah@gmail.com','9889001122','Surat','Gujarat'),
(33,'Rajesh','Nair','rajeshnair@gmail.com','9990112233','Kochi','Kerala'),
(34,'Snehal','Joshi','snehaljoshi@gmail.com','9001333444','Pune','Maharashtra'),
(35,'Harish','Reddy','harishreddy@gmail.com','9112444555','Hyderabad','Telangana'),
(36,'Megha','Iyer','meghaiyer@gmail.com','9223555666','Chennai','Tamil Nadu'),
(37,'Ashok','Menon','ashokmenon@gmail.com','9334666777','Trivandrum','Kerala'),
(38,'Sunita','Verma','sunitaverma@gmail.com','9445777888','Lucknow','Uttar Pradesh'),
(39,'Karthik','Rao','karthikrao@gmail.com','9556888999','Bangalore','Karnataka'),
(40,'Anjali','Kapoor','anjalikapoor@gmail.com','9667999000','Delhi','Delhi');

-- Products (IDs 101–140 for variety)
----------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Products (ProductID, ProductName, Category, Price, Stock) VALUES
(106,'Wireless Keyboard','Accessories',60.00,40),
(107,'Monitor 24-inch','Electronics',180.00,12),
(108,'External Hard Drive','Electronics',95.00,25),
(109,'Desk Lamp','Furniture',35.00,30),
(110,'Bookshelf','Furniture',120.00,15),
(111,'Fitness Band','Electronics',75.00,18),
(112,'Coffee Maker','Appliances',85.00,20),
(113,'Air Purifier','Appliances',150.00,10),
(114,'Power Bank','Accessories',40.00,50),
(115,'Wireless Router','Electronics',110.00,22),
(116,'Gaming Keyboard','Accessories',70.00,15),
(117,'Smart TV','Electronics',550.00,8),
(118,'Microwave Oven','Appliances',200.00,12),
(119,'Office Desk','Furniture',250.00,5),
(120,'Refrigerator','Appliances',600.00,6),
(121,'Printer','Electronics',130.00,14),
(122,'Camera','Electronics',400.00,9),
(123,'Shoes','Fashion',50.00,100),
(124,'T-Shirt','Fashion',20.00,200),
(125,'Jeans','Fashion',40.00,150),
(126,'Watch','Fashion',90.00,80),
(127,'Bag','Accessories',35.00,60),
(128,'Table Fan','Appliances',45.00,25),
(129,'Water Bottle','Accessories',10.00,300),
(130,'Notebook','Stationery',5.00,500),
(131,'Pen','Stationery',2.00,1000),
(132,'Chair','Furniture',75.00,40),
(133,'Sofa','Furniture',400.00,10),
(134,'Bed','Furniture',700.00,5),
(135,'Dining Table','Furniture',350.00,7),
(136,'Curtains','Home Decor',60.00,30),
(137,'Wall Clock','Home Decor',25.00,50),
(138,'Painting','Home Decor',150.00,12),
(139,'Carpet','Home Decor',200.00,8),
(140,'Mirror','Home Decor',80.00,20);

----------------------------------------------------------------------------------------------------------------------------------------------
-- Orders (IDs 455–495 for variety)
----------------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount) VALUES
(463,4,'2025-08-09',180.00),
(464,5,'2025-08-10',95.00),
(465,6,'2025-08-11',240.00),
(466,7,'2025-08-12',120.00),
(467,8,'2025-08-13',75.00),
(468,9,'2025-08-14',300.00),
(469,10,'2025-08-15',85.00),
(470,11,'2025-08-16',150.00),
(471,12,'2025-08-17',110.00),
(472,13,'2025-08-18',200.00),
(473,14,'2025-08-19',400.00),
(474,15,'2025-08-20',250.00),
(475,16,'2025-08-21',175.00),
(476,17,'2025-08-22',90.00),
(477,18,'2025-08-23',600.00),
(478,19,'2025-08-24',320.00),
(479,20,'2025-08-25',450.00),
(480,21,'2025-08-26',220.00),
(481,22,'2025-08-27',130.00),
(482,23,'2025-08-28',95.00),
(483,24,'2025-08-29',67.00);

-- Find all customers from Kerala 
SELECT * FROM Customers WHERE state = 'kerala';

-- List all products with stock less than 20 
SELECT ProductName, Stock FROM Products WHERE Stock < 20;

-- Total sales by each customer 
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID;

-- Top-selling product across all orders 
SELECT p.ProductName, SUM(od.Quantity) AS TotalSold
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductID
ORDER BY TotalSold DESC
LIMIT 5;

-- STORED UPDATED_PROCEDURE
DELIMITER //
CREATE PROCEDURE GetOrdersByCustomer(IN cust_id INT)
BEGIN
    SELECT o.OrderID, o.OrderDate, o.TotalAmount,
           c.FirstName, c.LastName, c.City, c.state
    FROM Orders o
    JOIN Customers c ON o.CustomerID = c.CustomerID
    WHERE o.CustomerID = cust_id;
END //
DELIMITER ;

CALL GetOrdersByCustomer(12);

-- CTE: High-spending customers
WITH HighSpenders AS (
    SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpent
    FROM Customers c
    JOIN Orders o ON c.CustomerID = o.CustomerID
    GROUP BY c.CustomerID
    HAVING SUM(o.TotalAmount) > 300
)
SELECT * FROM HighSpenders;

-- Subquery: Products priced above average
SELECT ProductID, ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);  

-- Trigger: Update order total after new order detail
DELIMITER //
CREATE TRIGGER UpdateOrderTotal
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET TotalAmount = TotalAmount + 
        (SELECT Price * NEW.Quantity 
         FROM Products 
         WHERE ProductID = NEW.ProductID)
    WHERE OrderID = NEW.OrderID;
END;
//
DELIMITER ;




