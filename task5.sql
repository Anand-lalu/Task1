SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    D.DepartmentName
FROM
    Employees AS E
INNER JOIN
    Departments AS D ON E.DepartmentID = D.DepartmentID;