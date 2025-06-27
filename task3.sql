CREATE DATABASE task3_db;
USE task3_db;

CREATE TABLE students (
  id INT PRIMARY KEY,
  name VARCHAR(50),
  age INT,
  gender VARCHAR(10),
  course VARCHAR(50),
  marks INT
);

INSERT INTO students VALUES
(1, 'Ananya', 20, 'Female', 'Data Science', 85),
(2, 'Rohan', 21, 'Male', 'Cybersecurity', 90),
(3, 'Priya', 22, 'Female', 'AI', 78),
(4, 'Aman', 20, 'Male', 'AI', 65),
(5, 'Riya', 23, 'Female', 'Networking', 95);