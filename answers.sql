CREATE TABLE ProductDetail (
  OrderID INT,
  CustomerName VARCHAR(100),
  Products VARCHAR(200)
);

INSERT INTO ProductDetail VALUES
(101, 'John Doe',    'Laptop, Mouse'),
(102, 'Jane Smith',  'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark',  'Phone');
| OrderID | CustomerName | Product  |
| ------- | ------------ | -------- |
| 101     | John Doe     | Laptop   |
| 101     | John Doe     | Mouse    |
| 102     | Jane Smith   | Tablet   |
| 102     | Jane Smith   | Keyboard |
| 102     | Jane Smith   | Mouse    |
| 103     | Emily Clark  | Phone    |

WITH RECURSIVE split_cte AS (
  SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(Products, ',', 1)) AS Product,
    TRIM(SUBSTR(Products, LENGTH(SUBSTRING_INDEX(Products, ',', 1)) + 2)) AS rest
  FROM ProductDetail
  UNION ALL
  SELECT
    OrderID,
    CustomerName,
    TRIM(SUBSTRING_INDEX(rest, ',', 1)),
    TRIM(
      SUBSTR(
        rest,
        LENGTH(SUBSTRING_INDEX(rest, ',', 1)) + 2
      )
    )
  FROM split_cte
  WHERE rest <> ''
)
SELECT OrderID, CustomerName, Product
FROM split_cte
ORDER BY OrderID;


QUESTION 2
| OrderID | CustomerName | Product  | Quantity |
| ------- | ------------ | -------- | -------- |
| 101     | John Doe     | Laptop   | 2        |
| 101     | John Doe     | Mouse    | 1        |
| 102     | Jane Smith   | Tablet   | 3        |
| 102     | Jane Smith   | Keyboard | 1        |
| 102     | Jane Smith   | Mouse    | 2        |
| 103     | Emily Clark  | Phone    | 1        |
-- 1. Create Orders table:
CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  CustomerName VARCHAR(100)
);

-- 2. Create normalized OrderDetails table:
CREATE TABLE OrderDetails2NF (
  OrderID INT,
  Product VARCHAR(100),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- 3. Insert data into Orders from the original table:
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- 4. Insert data into OrderDetails2NF:
INSERT INTO OrderDetails2NF (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

