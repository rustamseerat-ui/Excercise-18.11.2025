Part 1

-- 1. Create Cars table
CREATE TABLE Cars (
    CarID INTEGER PRIMARY KEY AUTOINCREMENT,
    Brand TEXT NOT NULL,
    Model TEXT NOT NULL, 
    Year INTEGER NOT NULL,
    DailyPrice DECIMAL(10,2) NOT NULL
);

-- 2. Create Customers table
CREATE TABLE Customers (
    CustomerID INTEGER PRIMARY KEY AUTOINCREMENT,
    FullName TEXT NOT NULL,
    Email TEXT NOT NULL,
    Phone TEXT NOT NULL
);

-- 3. Create Rentals table
CREATE TABLE Rentals (
    RentalID INTEGER PRIMARY KEY AUTOINCREMENT,
    CarID INTEGER NOT NULL,
    CustomerID INTEGER NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    TotalCost DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (CarID) REFERENCES Cars(CarID),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);



Part 2 

-- Insert 8 cars
INSERT INTO Cars (Brand, Model, Year, DailyPrice) VALUES
('Toyota', 'Camry', 2022, 65.00),
('Honda', 'Civic', 2021, 55.00),
('Ford', 'Mustang', 2023, 120.00),
('BMW', 'X5', 2020, 150.00),
('Tesla', 'Model 3', 2023, 110.00),
('Nissan', 'Altima', 2019, 45.00),
('Audi', 'A4', 2021, 95.00),
('Hyundai', 'Elantra', 2018, 40.00);

-- Insert 6 customers
INSERT INTO Customers (FullName, Email, Phone) VALUES
('John Smith', 'john.smith@email.com', '604-123-4567'),
('Sarah Johnson', 'sarah.j@email.com', '604-234-5678'),
('Mike Davis', 'mike.davis@email.com', '778-345-6789'),
('Lisa Brown', 'lisa.b@email.com', '604-456-7890'),
('Tom Wilson', 'tom.w@email.com', '250-567-8901'),
('Emma Garcia', 'emma.g@email.com', '604-678-9012');

-- Insert 10 rental records
INSERT INTO Rentals (CarID, CustomerID, StartDate, EndDate, TotalCost) VALUES
(1, 1, '2024-01-10', '2024-01-15', 325.00),  -- 5 days * 65
(2, 2, '2024-01-12', '2024-01-14', 110.00),  -- 2 days * 55
(3, 3, '2024-01-15', '2024-01-20', 600.00),  -- 5 days * 120
(4, 4, '2024-01-18', '2024-01-25', 1050.00), -- 7 days * 150
(5, 5, '2024-01-20', '2024-01-22', 220.00),  -- 2 days * 110
(1, 2, '2024-01-25', '2024-01-30', 325.00),  -- 5 days * 65
(6, 3, '2024-02-01', '2024-02-10', 405.00),  -- 9 days * 45
(7, 4, '2024-02-05', '2024-02-08', 285.00),  -- 3 days * 95
(8, 5, '2024-02-10', '2024-02-15', 200.00),  -- 5 days * 40
(3, 1, '2024-02-12', '2024-02-14', 240.00);  -- 2 days * 120



Part 3

-- 1. List all cars sorted by DailyPrice descending
SELECT * FROM Cars ORDER BY DailyPrice DESC;

-- 2. Show all customers whose name contains 'a'
SELECT * FROM Customers WHERE FullName LIKE '%a%';

-- 3. Display all rentals with StartDate in the last 30 days
-- (Using current date - adjust as needed)
SELECT * FROM Rentals 
WHERE StartDate >= date('now','-30 days');



part 4

-- 1. Cars older than 2018
SELECT * FROM Cars WHERE Year < 2018;

-- 2. Customers with phone numbers starting with '604'
SELECT * FROM Customers WHERE Phone LIKE '604%';

-- 3. Rentals longer than 5 days
SELECT *, 
       julianday(EndDate) - julianday(StartDate) as DurationDays 
FROM Rentals 
WHERE julianday(EndDate) - julianday(StartDate) > 5;

-- 4. Cars with price between 50 and 100
SELECT * FROM Cars WHERE DailyPrice BETWEEN 50 AND 100;


Part 5 

-- 1. List all rentals with car & customer details
SELECT 
    r.RentalID,
    c.Brand,
    c.Model,
    cust.FullName,
    r.StartDate,
    r.EndDate,
    r.TotalCost
FROM Rentals r
JOIN Cars c ON r.CarID = c.CarID
JOIN Customers cust ON r.CustomerID = cust.CustomerID;

-- 2. Show cars that have never been rented (LEFT JOIN)
SELECT 
    c.CarID,
    c.Brand,
    c.Model,
    c.Year
FROM Cars c
LEFT JOIN Rentals r ON c.CarID = r.CarID
WHERE r.RentalID IS NULL;

-- 3. List customers who rented cars priced over 80/day
SELECT DISTINCT
    cust.CustomerID,
    cust.FullName,
    c.Brand,
    c.Model,
    c.DailyPrice
FROM Customers cust
JOIN Rentals r ON cust.CustomerID = r.CustomerID
JOIN Cars c ON r.CarID = c.CarID
WHERE c.DailyPrice > 80;
 
 
Part 6 

-- 1. Count total rentals
SELECT COUNT(*) as TotalRentals FROM Rentals;

-- 2. Average rental duration
SELECT 
    ROUND(AVG(julianday(EndDate) - julianday(StartDate)), 2) as AvgRentalDays 
FROM Rentals;

-- 3. Total revenue generated
SELECT SUM(TotalCost) as TotalRevenue FROM Rentals;

-- 4. Count rentals per customer
SELECT 
    cust.FullName,
    COUNT(r.RentalID) as RentalCount
FROM Customers cust
LEFT JOIN Rentals r ON cust.CustomerID = r.CustomerID
GROUP BY cust.CustomerID, cust.FullName;


part 7
-- 1. Total revenue per customer
SELECT 
    cust.FullName,
    SUM(r.TotalCost) as TotalSpent
FROM Customers cust
JOIN Rentals r ON cust.CustomerID = r.CustomerID
GROUP BY cust.CustomerID, cust.FullName
ORDER BY TotalSpent DESC;

-- 2. Customers with more than 2 rentals
SELECT 
    cust.FullName,
    COUNT(r.RentalID) as RentalCount
FROM Customers cust
JOIN Rentals r ON cust.CustomerID = r.CustomerID
GROUP BY cust.CustomerID, cust.FullName
HAVING COUNT(r.RentalID) > 2;

-- 3. Cars that generated over 500 total income
SELECT 
    c.Brand,
    c.Model,
    SUM(r.TotalCost) as TotalIncome
FROM Cars c
JOIN Rentals r ON c.CarID = r.CarID
GROUP BY c.CarID, c.Brand, c.Model
HAVING SUM(r.TotalCost) > 500;


Part 8

-- 1. Create a list with customer emails and car brands in one column
SELECT Email as CombinedList FROM Customers
UNION
SELECT Brand FROM Cars
ORDER BY CombinedList;


Part 9

-- 1. UPPER() → customer names
SELECT FullName, UPPER(FullName) as UpperCaseName 
FROM Customers;

-- 2. LENGTH() → car model names
SELECT Model, LENGTH(Model) as NameLength 
FROM Cars;

-- 3. DATE calculations → rental length
SELECT 
    RentalID,
    StartDate,
    EndDate,
    julianday(EndDate) - julianday(StartDate) as DurationDays,
    (julianday(EndDate) - julianday(StartDate)) * 24 as DurationHours
FROM Rentals;

-- 4. ROUND() → average rental income rounded to 2 decimals
SELECT ROUND(AVG(TotalCost), 2) as AvgRentalCost FROM Rentals;



part 10


-- 1. SELF JOIN: customers who share the same email domain
SELECT 
    c1.FullName as Customer1,
    c1.Email as Email1,
    c2.FullName as Customer2, 
    c2.Email as Email2
FROM Customers c1
JOIN Customers c2 ON substr(c1.Email, instr(c1.Email, '@')) = substr(c2.Email, instr(c2.Email, '@'))
WHERE c1.CustomerID < c2.CustomerID;

-- 2. CROSS JOIN: show all possible car/customer combinations (first 20 only)
SELECT 
    c.Brand,
    c.Model,
    cust.FullName
FROM Cars c
CROSS JOIN Customers cust
LIMIT 20;

-- 3. Multi-table JOIN: Rentals + Cars + Customers with calculated rental duration
SELECT 
    r.RentalID,
    cust.FullName,
    c.Brand,
    c.Model,
    r.StartDate,
    r.EndDate,
    julianday(r.EndDate) - julianday(r.StartDate) as CalculatedDays,
    r.TotalCost
FROM Rentals r
JOIN Cars c ON r.CarID = c.CarID
JOIN Customers cust ON r.CustomerID = cust.CustomerID;


Part 11

-- 1. Find the most rented car
SELECT 
    c.Brand,
    c.Model,
    COUNT(r.RentalID) as RentalCount
FROM Cars c
JOIN Rentals r ON c.CarID = r.CarID
GROUP BY c.CarID, c.Brand, c.Model
ORDER BY RentalCount DESC
LIMIT 1;

-- 2. Find customers who generated the highest revenue
SELECT 
    cust.FullName,
    SUM(r.TotalCost) as TotalRevenue
FROM Customers cust
JOIN Rentals r ON cust.CustomerID = r.CustomerID
GROUP BY cust.CustomerID, cust.FullName
ORDER BY TotalRevenue DESC
LIMIT 3;

-- 3. List all rentals where the car model name contains the same letter twice

SELECT
    r.RentalID,
    c.Brand,
    c.Model,
    cust.FullName
FROM Rentals r
JOIN Cars c ON r.CarID = c.CarID
JOIN Customers cust ON r.CustomerID = cust.CustomerID
WHERE c.Model LIKE '%aa%' 
   OR c.Model LIKE '%bb%'
   OR c.Model LIKE '%cc%'
   OR c.Model LIKE '%dd%'
   OR c.Model LIKE '%ee%'
   OR c.Model LIKE '%ff%'
   OR c.Model LIKE '%gg%'
   OR c.Model LIKE '%hh%'
   OR c.Model LIKE '%ii%'
   OR c.Model LIKE '%jj%'
   OR c.Model LIKE '%kk%'
   OR c.Model LIKE '%ll%'
   OR c.Model LIKE '%mm%'
   OR c.Model LIKE '%nn%'
   OR c.Model LIKE '%oo%'
   OR c.Model LIKE '%pp%'
   OR c.Model LIKE '%qq%'
   OR c.Model LIKE '%rr%'
   OR c.Model LIKE '%ss%'
   OR c.Model LIKE '%tt%'
   OR c.Model LIKE '%uu%'
   OR c.Model LIKE '%vv%'
   OR c.Model LIKE '%ww%'
   OR c.Model LIKE '%xx%'
   OR c.Model LIKE '%yy%'
   OR c.Model LIKE '%zz%';
 

-- 4. Create a view: ActiveRentalsView listing rentals where EndDate >= today
CREATE VIEW ActiveRentalsView AS
SELECT 
    r.RentalID,
    cust.FullName,
    c.Brand,
    c.Model,
    r.StartDate,
    r.EndDate,
    r.TotalCost
FROM Rentals r
JOIN Cars c ON r.CarID = c.CarID
JOIN Customers cust ON r.CustomerID = cust.CustomerID
WHERE r.EndDate >= date('now');

-- Test the view
SELECT * FROM ActiveRentalsView;

-- 5. Create a summary table with aggregated statistics
CREATE TABLE RentalSummary AS
SELECT 
    'TotalRentals' as Metric,
    COUNT(*) as Value
FROM Rentals

UNION ALL

SELECT 
    'TotalRevenue',
    SUM(TotalCost)
FROM Rentals

UNION ALL

SELECT 
    'AvgRentalDuration',
    ROUND(AVG(julianday(EndDate) - julianday(StartDate)), 2)
FROM Rentals

UNION ALL

SELECT 
    'TotalCustomers',
    COUNT(*)
FROM Customers;

-- Check the summary table
SELECT * FROM RentalSummary;



Final part: Verification

-- Check all our database objects
SELECT name FROM sqlite_master WHERE type IN ('table', 'view');

-- See some sample data from each
SELECT * FROM Cars LIMIT 3;
SELECT * FROM Customers LIMIT 3; 
SELECT * FROM Rentals LIMIT 3;
SELECT * FROM ActiveRentalsView;
SELECT * FROM RentalSummary;





