-- Sample Table: Employees--
CREATE TABLE Employees (
    EmpID INT PRIMARY KEY,
    Name TEXT,
    Department TEXT,
    Salary INT,
    JoinDate DATE
);
-- Step 1: Insert Sample Data--
INSERT INTO Employees VALUES
(1, 'Alice', 'HR', 50000, '2020-01-15'),
(2, 'Bob', 'Engineering', 70000, '2019-03-10'),
(3, 'Charlie', 'Engineering', 72000, '2021-07-23'),
(4, 'David', 'HR', 48000, '2022-02-11'),
(5, 'Eve', 'Marketing', 55000, '2020-09-01');
-- Step 2: Create a View --
CREATE VIEW HighEarners AS
SELECT Name, Department, Salary
FROM Employees
WHERE Salary > 60000;
-- Step 3: Use the View --
-- Select from the view
SELECT * FROM HighEarners;
