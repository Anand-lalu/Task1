-- Create a sample table
CREATE TABLE Employees (
    EmployeeID INTEGER PRIMARY KEY AUTOINCREMENT,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT UNIQUE,
    Phone TEXT DEFAULT NULL,
    HireDate DATE NOT NULL,
    Salary REAL DEFAULT NULL
);

-- Insert data into the Employees table using INSERT INTO
INSERT INTO Employees (FirstName, LastName, Email, Phone, HireDate, Salary) VALUES
('Raunaksingh', 'singh', 'rkkkkk.doe@example.com', '123-456-7890', '2023-01-15', 60000),
('Anandsingh', 'singh', 'akkkk.smith@example.com', NULL, '2023-02-20', 65000),  -- Phone is NULL
('hellll', 'Johnson', 'alice.johnson@example.com', '987-654-3210', '2023-03-10', NULL),  -- Salary is NULL
('Bobby', 'Brown', NULL, '555-555-5555', '2023-04-05', 55000);  -- Email is NULL

-- Update an employee's information using WHERE condition
UPDATE Employees
SET Phone = '111-222-3333', Salary = 70000
WHERE EmployeeID = 1;  -- Update John Doe's phone and salary

-- Update an employee's email to NULL using WHERE condition
UPDATE Employees
SET Email = NULL
WHERE EmployeeID = 2;  -- Update Jane Smith's email to NULL

-- Delete an employee record using WHERE condition
DELETE FROM Employees
WHERE EmployeeID = 4;  -- Delete Bob Brown's record

-- Select all employees to see the current state of the table
SELECT * FROM Employees;