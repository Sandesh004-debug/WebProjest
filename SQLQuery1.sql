CREATE DATABASE LMS_DB;
GO
USE LMS_DB;
GO
CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Password NVARCHAR(100) NOT NULL,
    Role NVARCHAR(20) NOT NULL -- Student, Teacher, Admin
);
INSERT INTO Users (FullName, Email, Password, Role) VALUES
('Admin User', 'admin@lms.com', 'admin123', 'Admin'),
('John Student', 'student@lms.com', 'student123', 'Student'),
('Sara Teacher', 'teacher@lms.com', 'teacher123', 'Teacher');

select * from users

CREATE TABLE Courses (
    CourseId INT IDENTITY(1,1) PRIMARY KEY,
    CourseTitle NVARCHAR(150) NOT NULL,
    CourseDescription NVARCHAR(500),
    TeacherEmail NVARCHAR(100),
    CreatedDate DATETIME DEFAULT GETDATE()
);

INSERT INTO Courses (CourseTitle, CourseDescription, TeacherEmail)
VALUES
('C# Basics', 'Introduction to C# and .NET', 'teacher@lms.com'),
('ASP.NET Web Forms', 'Build web apps using ASP.NET', 'teacher@lms.com'),
('SQL Server Fundamentals', 'Learn SQL queries and database design', 'teacher@lms.com');

select * from courses


CREATE TABLE Enrollments (
    EnrollmentId INT IDENTITY(1,1) PRIMARY KEY,
    CourseId INT,
    StudentEmail NVARCHAR(100),
    EnrollDate DATETIME DEFAULT GETDATE()
);

INSERT INTO Enrollments (CourseId, StudentEmail)
VALUES (1, 'student@lms.com');

select * from Enrollments

ALTER TABLE Enrollments
ADD
    FullName NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(200);

    ALTER TABLE Courses
ADD TeacherEmail NVARCHAR(100);