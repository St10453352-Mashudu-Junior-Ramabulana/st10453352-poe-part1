-- ==========================================
-- RaceDay Database Script (MySQL Version)
-- Student: Mashudu Junior Ramabulana
-- Student Number: ST10453352
-- Module: Part 1 - System Planning
-- ==========================================

DROP DATABASE IF EXISTS RaceDayDB;

-- Create and select the database
CREATE DATABASE RaceDayDB;
USE RaceDayDB;




CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_role CHECK (Role IN ('Organiser', 'Participant'))
);

-- 2. Event Table
CREATE TABLE Events (
    EventID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    EventDate DATETIME NOT NULL,
    Description VARCHAR(500),
    OrganiserID INT NOT NULL,
    FOREIGN KEY (OrganiserID) REFERENCES Users(UserID)
);

-- 3. Category Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL, 
    Distance DECIMAL(5,2) NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL,
    EventID INT NOT NULL,
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

-- 4. Enrollment Table
CREATE TABLE Enrollments (
    EnrollmentID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrollmentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Status VARCHAR(20) DEFAULT 'Confirmed',
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- 5. Result Table
CREATE TABLE Results (
    ResultID INT PRIMARY KEY AUTO_INCREMENT,
    EnrollmentID INT NOT NULL UNIQUE, 
    FinishTime TIME NOT NULL,
    Position INT,
    FOREIGN KEY (EnrollmentID) REFERENCES Enrollments(EnrollmentID)
);

-- 6. RouteInfo Table
CREATE TABLE RouteInfo (
    RouteID INT PRIMARY KEY AUTO_INCREMENT,
    EventID INT NOT NULL UNIQUE,
    RouteMapUrl VARCHAR(255),
    ElevationGain INT,
    WeatherConditions VARCHAR(100),
    FOREIGN KEY (EventID) REFERENCES Events(EventID)
);

-- ==========================================
-- SEEDING DATA (INSERT STATEMENTS)
-- ==========================================

-- Insert 2 Organisers
INSERT INTO Users (FirstName, LastName, Email, PasswordHash, Role) VALUES 
('John', 'Doe', 'john@raceday.co.za', 'hashedpass123', 'Organiser'),
('Jane', 'Smith', 'jane@raceday.co.za', 'hashedpass456', 'Organiser');

-- Insert 2 Participants
INSERT INTO Users (FirstName, LastName, Email, PasswordHash, Role) VALUES 
('Mashudu', 'Ramabulana', 'mashudu@student.com', 'hashedpass789', 'Participant'),
('Alice', 'Brown', 'alice@gmail.com', 'hashedpass101', 'Participant');

-- Insert 3 Events (Assigned to Organisers UserID 1 and 2)
INSERT INTO Events (Name, Location, EventDate, Description, OrganiserID) VALUES 
('Comrades Marathon', 'Pietermaritzburg to Durban', '2024-06-09 05:30:00', 'The Ultimate Human Race.', 1),
('Cape Town Cycle Tour', 'Cape Town', '2024-03-10 06:00:00', 'The worlds largest timed cycle race.', 2),
('Soweto Marathon', 'Soweto', '2024-11-03 06:00:00', 'A vibrant run through Soweto.', 1);

-- Insert Categories for Events (EventID 1, 2, 3)
INSERT INTO Categories (Name, Distance, EntryFee, EventID) VALUES 
('Ultra Marathon', 89.00, 500.00, 1),
('Half Marathon', 21.10, 250.00, 1),
('109km Cycle', 109.00, 600.00, 2),
('42km Cycle', 42.00, 350.00, 2),
('42km Run', 42.20, 300.00, 3);

-- Insert Enrollments (UserID 3 and 4 enrolling in CategoryID 1 and 3)
INSERT INTO Enrollments (UserID, CategoryID, Status) VALUES 
(3, 1, 'Confirmed'),
(4, 3, 'Confirmed');

-- Insert Results for sample enrollments (EnrollmentID 1 and 2)
INSERT INTO Results (EnrollmentID, FinishTime, Position) VALUES 
(1, '11:30:00', 450),
(2, '03:15:00', 120);

-- Insert Route Info for Events (EventID 1, 2, 3)
INSERT INTO RouteInfo (EventID, RouteMapUrl, ElevationGain, WeatherConditions) VALUES 
(1, 'https://maps.comrades.com', 1200, 'Sunny, 22C'),
(2, 'https://maps.cycletour.com', 800, 'Windy, 18C'),
(3, 'https://maps.soweto.com', 400, 'Clear, 25C');