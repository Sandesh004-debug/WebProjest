-- Create the database
CREATE DATABASE LearnEase;
GO

USE LearnEase;
GO

-- Create the Users table
CREATE TABLE Users (
    UserId INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Password NVARCHAR(255) NOT NULL, 
    UserType NVARCHAR(20) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);