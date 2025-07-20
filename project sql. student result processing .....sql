-- Student Result Processing System
-- Objective: Build SQL system to manage grades and CGPA.
-- Tool: MySQL

-- 1. Design Schema

-- Drop tables if they already exist to ensure a clean start
DROP TABLE IF EXISTS Grades;
DROP TABLE IF EXISTS Courses;
DROP TABLE IF EXISTS Semesters;
DROP TABLE IF EXISTS Students;

-- Students Table
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Semesters Table
CREATE TABLE Semesters (
    semester_id INT PRIMARY KEY AUTO_INCREMENT,
    semester_name VARCHAR(50) UNIQUE NOT NULL, -- e.g., 'Fall 2023', 'Spring 2024'
    start_date DATE,
    end_date DATE
);

-- Courses Table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(10) UNIQUE NOT NULL, -- e.g., 'CS101', 'MA202'
    course_name VARCHAR(100) NOT NULL,
    credits DECIMAL(3, 1) NOT NULL -- e.g., 3.0, 4.0
);

-- Grades Table
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    marks_obtained DECIMAL(5, 2), -- Raw marks, e.g., 85.50
    grade_letter VARCHAR(2), -- A+, A, B+, etc.
    grade_point DECIMAL(3, 2), -- Corresponding grade points, e.g., 4.0, 3.7
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES Semesters(semester_id) ON DELETE CASCADE,
    UNIQUE (student_id, course_id, semester_id) -- A student can only have one grade for a course in a given semester
);


-- 2. Insert Student and Exam Data

-- Insert Students
INSERT INTO Students (first_name, last_name, date_of_birth, email) VALUES
('Alice', 'Smith', '2004-03-15', 'alice.smith@example.com'),
('Bob', 'Johnson', '2003-11-20', 'bob.johnson@example.com'),
('Charlie', 'Brown', '2005-01-10', 'charlie.brown@example.com'),
('Diana', 'Prince', '2003-07-22', 'diana.prince@example.com'),
('Ethan', 'Hunt', '2004-09-01', 'ethan.hunt@example.com');

-- Insert Semesters
INSERT INTO Semesters (semester_name, start_date, end_date) VALUES
('Fall 2023', '2023-09-01', '2023-12-31'),
('Spring 2024', '2024-01-15', '2024-05-31'),
('Fall 2024', '2024-09-01', '2024-12-31');

-- Insert Courses
INSERT INTO Courses (course_code, course_name, credits) VALUES
('CS101', 'Introduction to Programming', 3.0),
('MA201', 'Calculus I', 4.0),
('PH101', 'Physics Fundamentals', 3.0),
('EN101', 'English Composition', 3.0),
('CS201', 'Data Structures', 4.0),
('MA202', 'Calculus II', 4.0);

-- Insert Grades (Raw Marks)
-- Fall 2023 Grades
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained) VALUES
(1, 1, 1, 88.5), -- Alice, CS101, Fall 2023
(1, 2, 1, 75.0), -- Alice, MA201, Fall 2023
(1, 3, 1, 92.0), -- Alice, PH101, Fall 2023
(2, 1, 1, 78.0), -- Bob, CS101, Fall 2023
(2, 2, 1, 65.5), -- Bob, MA201, Fall 2023
(2, 3, 1, 80.0), -- Bob, PH101, Fall 2023
(3, 1, 1, 95.0), -- Charlie, CS101, Fall 2023
(3, 2, 1, 88.0), -- Charlie, MA201, Fall 2023
(3, 3, 1, 70.0), -- Charlie, PH101, Fall 2023
(4, 1, 1, 60.0), -- Diana, CS101, Fall 2023
(4, 2, 1, 55.0), -- Diana, MA201, Fall 2023
(4, 3, 1, 68.0); -- Diana, PH101, Fall 2023

-- Spring 2024 Grades (for some students)
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained) VALUES
(1, 4, 2, 80.0), -- Alice, EN101, Spring 2024
(1, 5, 2, 85.0), -- Alice, CS201, Spring 2024
(2, 4, 2, 70.0), -- Bob, EN101, Spring 2024
(2, 5, 2, 75.0), -- Bob, CS201, Spring 2024
(3, 4, 2, 90.0), -- Charlie, EN101, Spring 2024
(3, 5, 2, 92.0); -- Charlie, CS201, Spring 2024

-- Fall 2024 Grades (for some students)
INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained) VALUES
(1, 6, 3, 78.0), -- Alice, MA202, Fall 2024
(2, 6, 3, 62.0); -- Bob, MA202, Fall 2024


-- 3. Write Queries for GPA and Pass/Fail Statistics

-- Function to calculate Grade Point from Marks
-- This would typically be a stored function or handled by a trigger.
-- For demonstration, let's include it in a CTE.

-- Calculate Semester GPA for each student
WITH GradePoints AS (
    SELECT
        g.student_id,
        s.first_name,
        s.last_name,
        sem.semester_name,
        c.course_name,
        c.credits,
        g.marks_obtained,
        CASE
            WHEN g.marks_obtained >= 90 THEN 4.0
            WHEN g.marks_obtained >= 85 THEN 3.7
            WHEN g.marks_obtained >= 80 THEN 3.3
            WHEN g.marks_obtained >= 75 THEN 3.0
            WHEN g.marks_obtained >= 70 THEN 2.7
            WHEN g.marks_obtained >= 65 THEN 2.3
            WHEN g.marks_obtained >= 60 THEN 2.0
            WHEN g.marks_obtained >= 55 THEN 1.7
            WHEN g.marks_obtained >= 50 THEN 1.3
            ELSE 0.0
        END AS calculated_grade_point,
        CASE
            WHEN g.marks_obtained >= 90 THEN 'A+'
            WHEN g.marks_obtained >= 85 THEN 'A'
            WHEN g.marks_obtained >= 80 THEN 'B+'
            WHEN g.marks_obtained >= 75 THEN 'B'
            WHEN g.marks_obtained >= 70 THEN 'C+'
            WHEN g.marks_obtained >= 65 THEN 'C'
            WHEN g.marks_obtained >= 60 THEN 'D'
            ELSE 'F'
        END AS calculated_grade_letter
    FROM
        Grades g
    JOIN
        Students s ON g.student_id = s.student_id
    JOIN
        Courses c ON g.course_id = c.course_id
    JOIN
        Semesters sem ON g.semester_id = sem.semester_id
)
SELECT
    student_id,
    first_name,
    last_name,
    semester_name,
    SUM(calculated_grade_point * credits) / SUM(credits) AS semester_gpa
FROM
    GradePoints
GROUP BY
    student_id, first_name, last_name, semester_name
ORDER BY
    semester_name, student_id;


-- Calculate Cumulative GPA (CGPA) for each student
WITH StudentSemesterGPA AS (
    SELECT
        g.student_id,
        s.first_name,
        s.last_name,
        c.credits,
        CASE
            WHEN g.marks_obtained >= 90 THEN 4.0
            WHEN g.marks_obtained >= 85 THEN 3.7
            WHEN g.marks_obtained >= 80 THEN 3.3
            WHEN g.marks_obtained >= 75 THEN 3.0
            WHEN g.marks_obtained >= 70 THEN 2.7
            WHEN g.marks_obtained >= 65 THEN 2.3
            WHEN g.marks_obtained >= 60 THEN 2.0
            WHEN g.marks_obtained >= 55 THEN 1.7
            WHEN g.marks_obtained >= 50 THEN 1.3
            ELSE 0.0
        END AS grade_point
    FROM
        Grades g
    JOIN
        Students s ON g.student_id = s.student_id
    JOIN
        Courses c ON g.course_id = c.course_id
)
SELECT
    student_id,
    first_name,
    last_name,
    SUM(grade_point * credits) / SUM(credits) AS cumulative_gpa
FROM
    StudentSemesterGPA
GROUP BY
    student_id, first_name, last_name
ORDER BY
    cumulative_gpa DESC;

-- Pass/Fail Statistics per Course
SELECT
    c.course_code,
    c.course_name,
    sem.semester_name,
    COUNT(CASE WHEN g.marks_obtained >= 50 THEN g.student_id END) AS passed_students, -- Assuming 50 is passing mark
    COUNT(CASE WHEN g.marks_obtained < 50 THEN g.student_id END) AS failed_students,
    COUNT(g.student_id) AS total_students,
    (COUNT(CASE WHEN g.marks_obtained >= 50 THEN g.student_id END) * 100.0) / COUNT(g.student_id) AS pass_percentage
FROM
    Grades g
JOIN
    Courses c ON g.course_id = c.course_id
JOIN
    Semesters sem ON g.semester_id = sem.semester_id
GROUP BY
    c.course_code, c.course_name, sem.semester_name
ORDER BY
    sem.semester_name, c.course_name;

-- Overall Pass/Fail Statistics (across all courses/semesters)
SELECT
    COUNT(CASE WHEN g.marks_obtained >= 50 THEN g.student_id END) AS total_passed_grades,
    COUNT(CASE WHEN g.marks_obtained < 50 THEN g.student_id END) AS total_failed_grades,
    COUNT(g.grade_id) AS total_grades,
    (COUNT(CASE WHEN g.marks_obtained >= 50 THEN g.student_id END) * 100.0) / COUNT(g.grade_id) AS overall_pass_percentage
FROM
    Grades g;

-- 4. Create Rank Lists Using Window Functions

-- Semester-wise Rank List (based on Semester GPA)
WITH SemesterGPA AS (
    SELECT
        g.student_id,
        s.first_name,
        s.last_name,
        sem.semester_id,
        sem.semester_name,
        SUM(CASE
            WHEN g.marks_obtained >= 90 THEN 4.0 * c.credits
            WHEN g.marks_obtained >= 85 THEN 3.7 * c.credits
            WHEN g.marks_obtained >= 80 THEN 3.3 * c.credits
            WHEN g.marks_obtained >= 75 THEN 3.0 * c.credits
            WHEN g.marks_obtained >= 70 THEN 2.7 * c.credits
            WHEN g.marks_obtained >= 65 THEN 2.3 * c.credits
            WHEN g.marks_obtained >= 60 THEN 2.0 * c.credits
            WHEN g.marks_obtained >= 55 THEN 1.7 * c.credits
            WHEN g.marks_obtained >= 50 THEN 1.3 * c.credits
            ELSE 0.0 * c.credits
        END) AS total_grade_points,
        SUM(c.credits) AS total_credits_taken
    FROM
        Grades g
    JOIN
        Students s ON g.student_id = s.student_id
    JOIN
        Courses c ON g.course_id = c.course_id
    JOIN
        Semesters sem ON g.semester_id = sem.semester_id
    GROUP BY
        g.student_id, s.first_name, s.last_name, sem.semester_id, sem.semester_name
)
SELECT
    semester_name,
    first_name,
    last_name,
    (total_grade_points / total_credits_taken) AS semester_gpa,
    RANK() OVER (PARTITION BY semester_id ORDER BY (total_grade_points / total_credits_taken) DESC) AS semester_rank
FROM
    SemesterGPA
ORDER BY
    semester_name, semester_rank;

-- Overall Rank List (based on Cumulative GPA)
WITH CumulativeGPA AS (
    SELECT
        g.student_id,
        s.first_name,
        s.last_name,
        SUM(CASE
            WHEN g.marks_obtained >= 90 THEN 4.0 * c.credits
            WHEN g.marks_obtained >= 85 THEN 3.7 * c.credits
            WHEN g.marks_obtained >= 80 THEN 3.3 * c.credits
            WHEN g.marks_obtained >= 75 THEN 3.0 * c.credits
            WHEN g.marks_obtained >= 70 THEN 2.7 * c.credits
            WHEN g.marks_obtained >= 65 THEN 2.3 * c.credits
            WHEN g.marks_obtained >= 60 THEN 2.0 * c.credits
            WHEN g.marks_obtained >= 55 THEN 1.7 * c.credits
            WHEN g.marks_obtained >= 50 THEN 1.3 * c.credits
            ELSE 0.0 * c.credits
        END) AS total_cumulative_grade_points,
        SUM(c.credits) AS total_cumulative_credits_taken
    FROM
        Grades g
    JOIN
        Students s ON g.student_id = s.student_id
    JOIN
        Courses c ON g.course_id = c.course_id
    GROUP BY
        g.student_id, s.first_name, s.last_name
)
SELECT
    first_name,
    last_name,
    (total_cumulative_grade_points / total_cumulative_credits_taken) AS cumulative_gpa,
    RANK() OVER (ORDER BY (total_cumulative_grade_points / total_cumulative_credits_taken) DESC) AS overall_rank
FROM
    CumulativeGPA
ORDER BY
    overall_rank;


-- 5. Add Triggers for GPA Calculation

-- Trigger to automatically calculate grade_letter and grade_point on INSERT or UPDATE of marks_obtained
DELIMITER $$

CREATE TRIGGER trg_grades_before_insert_update
BEFORE INSERT ON Grades
FOR EACH ROW
BEGIN
    -- Calculate grade_letter
    SET NEW.grade_letter =
        CASE
            WHEN NEW.marks_obtained >= 90 THEN 'A+'
            WHEN NEW.marks_obtained >= 85 THEN 'A'
            WHEN NEW.marks_obtained >= 80 THEN 'B+'
            WHEN NEW.marks_obtained >= 75 THEN 'B'
            WHEN NEW.marks_obtained >= 70 THEN 'C+'
            WHEN NEW.marks_obtained >= 65 THEN 'C'
            WHEN NEW.marks_obtained >= 60 THEN 'D'
            ELSE 'F'
        END;

    -- Calculate grade_point
    SET NEW.grade_point =
        CASE
            WHEN NEW.marks_obtained >= 90 THEN 4.0
            WHEN NEW.marks_obtained >= 85 THEN 3.7
            WHEN NEW.marks_obtained >= 80 THEN 3.3
            WHEN NEW.marks_obtained >= 75 THEN 3.0
            WHEN NEW.marks_obtained >= 70 THEN 2.7
            WHEN NEW.marks_obtained >= 65 THEN 2.3
            WHEN NEW.marks_obtained >= 60 THEN 2.0
            WHEN NEW.marks_obtained >= 55 THEN 1.7
            WHEN NEW.marks_obtained >= 50 THEN 1.3
            ELSE 0.0
        END;
END$$

DELIMITER ;

-- Test the trigger by updating/inserting a grade
-- UPDATE Grades SET marks_obtained = 91.0 WHERE grade_id = 1;
-- SELECT * FROM Grades WHERE grade_id = 1;

-- INSERT INTO Grades (student_id, course_id, semester_id, marks_obtained) VALUES
-- (5, 1, 1, 72.0); -- Ethan, CS101, Fall 2023
-- SELECT * FROM Grades WHERE student_id = 5;


-- 6. Export Semester-wise Result Summary

-- This query generates the data for a semester-wise result summary.
-- You would typically export the output of this query to a CSV, PDF, or display it in an application.

SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    sem.semester_name,
    c.course_code,
    c.course_name,
    c.credits,
    g.marks_obtained,
    g.grade_letter,
    g.grade_point,
    (SELECT SUM(gp.grade_point * co.credits) / SUM(co.credits)
     FROM Grades gp
     JOIN Courses co ON gp.course_id = co.course_id
     WHERE gp.student_id = s.student_id AND gp.semester_id = sem.semester_id) AS semester_gpa,
    (SELECT SUM(gp_all.grade_point * co_all.credits) / SUM(co_all.credits)
     FROM Grades gp_all
     JOIN Courses co_all ON gp_all.course_id = co_all.course_id
     WHERE gp_all.student_id = s.student_id AND gp_all.semester_id <= sem.semester_id) AS cumulative_gpa_till_semester -- CGPA calculated up to and including this semester
FROM
    Students s
JOIN
    Grades g ON s.student_id = g.student_id
JOIN
    Courses c ON g.course_id = c.course_id
JOIN
    Semesters sem ON g.semester_id = sem.semester_id
ORDER BY
    sem.semester_name, s.last_name, s.first_name, c.course_code;