
DROP DATABASE IF EXISTS Apurva_Deore;
CREATE DATABASE Apurva_Deore;
USE Apurva_Deore;

#_____________________________________________________CREATION OF TABLES_______________________________________________________________________

#Creation of the STREAM table to store the streams Cthulhu Studies and Cthulhu Studies+Dagon Studies
CREATE TABLE stream(streamID INT NOT NULL,streamname VARCHAR(10),
PRIMARY KEY(streamID));

#Creation of the table that stores STUDENTS details
CREATE TABLE student(studentID INT NOT NULL,
student_fname VARCHAR(50) NOT NULL,
student_lname VARCHAR(50) NOT NULL,
streamID INT NOT NULL,
DOB DATE NOT NULL,
gender VARCHAR(6) NOT NULL,
nationality VARCHAR(50) NOT NULL,
#GPA INT ZEROFILL NOT NULL,
GPA DECIMAL(4,2) ZEROFILL NOT NULL CHECK (GPA <= 4.2 OR GPA >= 0.0),
PRIMARY KEY(studentID),
FOREIGN KEY(streamID) REFERENCES stream(streamID));

#Creation of the staff table that stores all the details of staff that guides the students
CREATE TABLE staff(staffID INT NOT NULL,
staff_fname VARCHAR(50) NOT NULL,
staff_lname VARCHAR(50) NOT NULL,
streamID INT NOT NULL,
DOB DATE NOT NULL,
gender VARCHAR(6) NOT NULL,
nationality VARCHAR(30) NOT NULL,
PRIMARY KEY(staffID),
FOREIGN KEY(streamID) REFERENCES stream(streamID));

#Creation of PROJECT table
CREATE TABLE projects(
projectID INT NOT NULL,
title VARCHAR(100) NOT NULL UNIQUE ,
streamID INT NOT NULL,
PRIMARY KEY(projectID),
FOREIGN KEY(streamID) REFERENCES stream(streamID));

#Creation of the table : Student Proposed Projects
CREATE TABLE stud_proposed(
projectID INT NOT NULL ,
studentID INT NOT NULL UNIQUE,
staff_assigned INT NOT NULL,
PRIMARY KEY(projectID),
FOREIGN KEY(projectID) REFERENCES projects(projectID),
FOREIGN KEY(studentID) REFERENCES student(studentID),
FOREIGN KEY(staff_assigned) REFERENCES staff(staffID));

#Creation of the table that stores projects proposed by staff
CREATE TABLE staff_proposed(
projectID INT NOT NULL,
staffID INT NOT NULL,
PRIMARY KEY(projectID),
FOREIGN KEY(projectID) REFERENCES projects(projectID),
FOREIGN KEY(staffID) REFERENCES staff(staffID));

#Creating a table to store the preferences provided by a student
CREATE TABLE preference_matrix_stud(
studentID INT NOT NULL,
pref1 INT NOT NULL, pref2 INT, pref3 INT, pref4 INT, pref5 INT, pref6 INT, pref7 INT, pref8 INT, pref9 INT, pref10 INT,
pref11 INT, pref12 INT, pref13 INT, pref14 INT, pref15 INT, pref16 INT, pref17 INT, pref18 INT, pref19 INT, pref20 INT,
PRIMARY KEY(studentID),
FOREIGN KEY(studentID) REFERENCES student(studentID),
FOREIGN KEY(pref1) REFERENCES projects(projectID),
FOREIGN KEY(pref2) REFERENCES projects(projectID),
FOREIGN KEY(pref3) REFERENCES projects(projectID),
FOREIGN KEY(pref4) REFERENCES projects(projectID),
FOREIGN KEY(pref5) REFERENCES projects(projectID),
FOREIGN KEY(pref6) REFERENCES projects(projectID),
FOREIGN KEY(pref7) REFERENCES projects(projectID),
FOREIGN KEY(pref8) REFERENCES projects(projectID),
FOREIGN KEY(pref9) REFERENCES projects(projectID),
FOREIGN KEY(pref10) REFERENCES projects(projectID),
FOREIGN KEY(pref11) REFERENCES projects(projectID),
FOREIGN KEY(pref12) REFERENCES projects(projectID),
FOREIGN KEY(pref13) REFERENCES projects(projectID),
FOREIGN KEY(pref14) REFERENCES projects(projectID),
FOREIGN KEY(pref15) REFERENCES projects(projectID),
FOREIGN KEY(pref16) REFERENCES projects(projectID),
FOREIGN KEY(pref17) REFERENCES projects(projectID),
FOREIGN KEY(pref18) REFERENCES projects(projectID),
FOREIGN KEY(pref19) REFERENCES projects(projectID),
FOREIGN KEY(pref20) REFERENCES projects(projectID));

#Creation of the student project mapping table
CREATE TABLE stud_proj_map(
projectID INT NOT NULL,
studentID INT NOT NULL UNIQUE ,
staffID INT NOT NULL,
preference_assigned INT NOT NULL,
PRIMARY KEY(projectID),
FOREIGN KEY(projectID) REFERENCES projects(projectID),
FOREIGN KEY(studentID) REFERENCES student(studentID),
FOREIGN KEY(staffID) REFERENCES staff(staffID));

#Creation of the table that stores student satisfaction score
CREATE TABLE stud_satisfaction(studentID INT NOT NULL,
stud_satisfaction_score INT NOT NULL,
PRIMARY KEY(studentID),
FOREIGN KEY(studentID) REFERENCES student(studentID));

#Creation of the table that stores staffs satisfaction score
CREATE TABLE staff_satisfaction(staffID INT NOT NULL,
staff_satisfaction_score INT NOT NULL,
PRIMARY KEY(staffID),
FOREIGN KEY(staffID) REFERENCES staff(staffID));


#__________________________________________________PROCEDURES and TRIGGERS_______________________________________________________________________________________

#Procedure to check if a student who has been allocated a project got a project from his/her own stream
DROP PROCEDURE IF EXISTS projectmappingproc;
DELIMITER $$

CREATE PROCEDURE projectmappingproc() 
BEGIN 
IF(SELECT COUNT(s.studentID)
FROM stud_proj_map spm
INNER JOIN student s ON  spm.studentID = s.studentID 
INNER JOIN projects p ON spm.projectID = p.projectID
WHERE s.streamID != p.streamID AND p.streamID != 2 )!= 0 
THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect Stream';
END IF;
END$$

#Trigger that calls the procedure defined above
DELIMITER ;

DROP TRIGGER IF EXISTS map_input_trigger;
DELIMITER $$
CREATE TRIGGER map_input_trigger
AFTER INSERT ON stud_proj_map 
FOR EACH ROW BEGIN CALL projectmappingproc(); END$$
DELIMITER ;

#_______________________________________________INSERTING VALUES_______________________________________________________________________________

#Inserting into the stream table
INSERT INTO stream(streamID, streamname) VALUES(0,'CS'),(1,'CS+DS'),(2,'CS+DS / CS');
#SELECT * FROM stream;

#Inserting values in the student table
INSERT INTO student (studentID, student_fname, student_lname, streamID, DOB, gender, nationality, GPA)
VALUES
(1, 'Edward', 'Collen', '1', '1995-04-18', 'Male', 'Peru', '4.2'),
(2, 'William', 'Mark', '0', '1990-04-12', 'Male', 'Russia', '3.8'),
(3, 'James', 'Harward', '1', '1989-06-01', 'Male', 'Peru', '3.6'),
(4, 'Carl', 'Madison', '0', '1996-01-20', 'Male', 'Thailand', '2.6'),
(5, 'Eddy', 'Teddy', '1', '1995-01-01', 'Male', 'Ireland', '3.66'),
(6, 'Evelyn', 'Stark', '0', '1995-07-08', 'Feale', 'Malaysia', '2.5'),
(7, 'Ella', 'Bridge', '1', '1993-05-20', 'Female', 'Singapore', '3.3'),
(8, 'Sarah', 'Jones', '0', '1995-03-08', 'Female', 'Czech Republic', '3.5'),
(9, 'Marie', 'Jane', '1', '1993-02-20', 'Female', 'India', '3.5'),
(10, 'Rachel', 'James', '0', '1993-03-22', 'Female', 'Malaysia', '3.8');
#SELECT * FROM student;

#Inserting values in the staff table
INSERT INTO staff(staffID, staff_fname, staff_lname, streamID, DOB, gender, nationality)
VALUES
('101', 'Scarlett', 'Johnson', '1', '1945-04-20', 'Female', 'Ireland'),
('102', 'Madison', 'Mark', '0', '1950-03-20', 'Female', 'Italy'),
('103', 'Markle', 'John', '1', '1955-01-10', 'Female', 'Spain'),
('104', 'Jamie', 'Edward', '0', '1960-07-08', 'Male', 'Ireland'),
('105', 'Harry', 'Styles', '1', '1960-05-22', 'Male', 'United Kingdom'),
('106', 'Louis', 'Tomlinson', '0', '1965-06-11', 'Male', 'United Kingdom'),
('107', 'Zayn', 'Malik', '1', '1950-06-10', 'Female', 'Ireland'),
('108', 'John', 'Paul', '0', '1966-01-08', 'Male', 'India'),
('109', 'Harry', 'Jones', '1', '1963-01-20', 'Male', 'United Kingdom'),
('110', 'Sarah', 'Tomlinson', '0', '1970-05-10', 'Female', 'Singapore');
#SELECT * FROM staff;

#Adding various projects in the table with a unique title
INSERT INTO projects(projectID, title, streamID)
VALUES
('201', 'AI for differently abled', '0'),
('202', 'ML for daily chores', '1'),
('203', 'DS or DA', '0'),
('204', 'AI and ML', '1'),
('205', 'ML for cognitive science', '0'),
('206', 'DS for election predictions', '1'),
('207', 'Twitter data analysis', '2'),
('208', 'Data mining and processes', '1'),
('209', 'ML to study behaviours', '2'),
('210', 'ETL implementations', '1'),
('211', 'AI for daily chores', '0'),
('212', 'ML for disease detection', '2'),
('213', 'AI and smartphones', '0'),
('214', 'AI: If not now then when', '2'),
('215', 'ML: If not me then who', '2'),
('216', 'AI for self driving cars', '0'),
('217', 'DS for Sentiment Analysis', '0'),
('218', 'Data Scientists or Data Analysts', '2'),
('219', 'ML for future predictions', '1'),
('220', 'Artificial Intelligence and business intelligence', '0');
#SELECT * FROM projects;

#Inserting projects proposed by students
INSERT INTO stud_proposed(projectID, studentID, staff_assigned)
VALUES
(201,2,102),
(204,3,103);
#SELECT * FROM stud_proposed;

#Inserting values for staff proposed projects
INSERT INTO staff_proposed(projectID, staffID)
VALUES
(202,101),
(203,104),
(205,104),
(206,105),
(207,110),
(208,105),
(209,103),
(210,109),
(211,108),
(212,108),
(213,105),
(214,106),
(215,107),
(216,110),
(217,108),
(218,109),
(219,107),
(220,110);
#SELECT * FROM staff_proposed;


#Inserting preferences by students for various projects
INSERT INTO preference_matrix_stud(studentID, pref1, pref2, pref3, pref4, pref5, pref6, pref7, pref8, pref9, pref10,
pref11, pref12, pref13, pref14, pref15, pref16, pref17, pref18, pref19, pref20)
VALUES 
(1,202,204,206,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(2,201,203,205,211,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(3,204,206,210,208,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(4,201,217,203,211,213,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(5,204,206,208,210,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(6,217,216,213,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(7,204,202,219,210,208,206,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(8,217,216,220,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(9,206,204,202,210,219,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),
(10,216,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
#SELECT * FROM preference_matrix_stud;

#Inserting values in the student project mapping table
INSERT INTO stud_proj_map(projectID, studentID, staffID, preference_assigned)
VALUES
('202','1', '101','1'),
('201','2', '102','1'),
('204','3', '103','1'),
('203','4', '104','3'),
('206','5', '105','2'),
('213','6', '105','3'),
('219','7', '107','3'),
('217','8', '108','1'),
('210','9', '109','4'),
('216','10', '110','1');
#SELECT * FROM stud_proj_map;

#Inserting satisfaction scores for students based on the projects that are assigned to them
INSERT INTO stud_satisfaction(studentID, stud_satisfaction_score)
VALUES 
(1,100),
(2,100),
(3,100),
(4,40),
(5,60),
(6,40),
(7,50),
(8,100),
(9,30),
(10,100);
#SELECT * FROM stud_satisfaction;

#Inserting satisfaction scores for the staffs
INSERT INTO staff_satisfaction (staffID, staff_satisfaction_score)
VALUES 
(101,90),
(102,90),
(103,80),
(104,70),
(105,100),
(106,30),
(107,70),
(108,60),
(109,50),
(110,70);
#SELECT * FROM staff_satisfaction;

#___________________________________PROCEDURE___________________________________________________________________________________________________

#Procedure to get the GPA for a student whos's ID is passed through the procedure
DROP PROCEDURE IF EXISTS displayGPA;

DELIMITER //
CREATE PROCEDURE displayGPA(
IN ID INT)
BEGIN
SELECT studentID, student_fname, student_lname, GPA 
FROM student
WHERE studentID = ID;
END //
DELIMITER ;
CALL displayGPA(10);

#___________________________________________________VIEWS____________________________________________________________________________________


#View that shows projects available for the CS stream
CREATE OR REPLACE VIEW CS_stream_projects AS
SELECT p.projectID, s.streamname, p.title 
FROM projects AS p 
INNER JOIN stream AS s 
ON p.streamID = s.streamID
WHERE streamname = 'CS';

SELECT * FROM CS_stream_projects;

#View that shows projects available for the CS+DS stream
CREATE OR REPLACE VIEW CSDS_stream_projects AS
SELECT p.projectID, s.streamname, p.title 
FROM projects AS p 
INNER JOIN stream AS s 
ON p.streamID = s.streamID
WHERE streamname = 'CS+DS';

SELECT * FROM CSDS_stream_projects;

#View showing students who got their first preference
CREATE OR REPLACE VIEW first_preference_assigned AS
SELECT s.studentID, s.student_fname, s.student_lname, s.GPA, spm.preference_assigned, spm.projectID
FROM student AS s
INNER JOIN stud_proj_map AS spm 
ON s.studentID = spm.studentID
WHERE spm.preference_assigned = 1;

SELECT * FROM first_preference_assigned;

#View to check if the students who self-proposed projects got their own projects
CREATE OR REPLACE VIEW self_prop_proj AS
SELECT sp.studentID, sp.projectID 
FROM stud_proposed AS sp
INNER JOIN stud_proj_map AS spm
WHERE sp.projectID = spm.projectID AND sp.studentID = spm.studentID;

SELECT * FROM self_prop_proj;

#View showing the number of unallocated projects
CREATE OR REPLACE VIEW projects_unallocated AS
SELECT p.*
FROM projects AS p 
LEFT JOIN stud_proj_map AS spm 
ON p.projectID = spm.projectID
WHERE spm.projectID IS NULL;

SELECT * FROM projects_unallocated;

#_____________________________________________________________________________QUERIES________________________________________________________

#Query to find out students that are pursuing the course CS
SELECT studentID, student_fname, student_lname, GPA
FROM student
WHERE streamID = '0';

#Quesry to find out students that are pursuing the course CS+DS
SELECT studentID, student_fname, student_lname, GPA
FROM student
WHERE streamID = '1';

#Query to find out staff belonging to the CS stream and the CS + DS stream
SELECT staffID, staff_fname, staff_lname FROM staff WHERE streamID = '0';
SELECT staffID, staff_fname, staff_lname FROM staff WHERE streamID = '1';

#Query to find out the students that have a 1:1 , ie, GPA above 3.6
SELECT studentID, student_fname, student_lname, GPA
FROM student
WHERE GPA > 3.6;

#Query to find out the GPA of students who got their first preference and the project they wanted
SELECT s.student_fname, s.student_lname, s.GPA, spm.projectID
FROM student s
INNER JOIN stud_proj_map spm ON s.studentID = spm.studentID
WHERE spm.preference_assigned = 1;

#Query to find the number of projects assigned to each staff member
SELECT spm.staffID, s.staff_fname, s.staff_lname, 
COUNT(spm.staffID)
FROM stud_proj_map AS spm 
INNER JOIN staff AS s 
ON spm.staffID = s.staffID 
GROUP BY spm.staffID;

#Query to find out which staff member got no project assigned to themselves
SELECT s.staffID, s.staff_fname, s.staff_lname, s.streamID, s.DOB, s.gender, s.nationality
FROM staff AS s 
LEFT JOIN stud_proj_map AS p 
ON s.staffID = p.staffID
WHERE p.staffID IS NULL;

#Query to find out staff most satisfied
SELECT st.staffID, st.staff_fname, st.staff_lname, sss.staff_satisfaction_score
FROM staff AS st
INNER JOIN staff_satisfaction AS sss
ON st.staffID = sss.staffID
WHERE staff_satisfaction_score = 100;

#Query to find out which staff got projects assigned to them from their own stream
SELECT s.staffID, s.staff_fname, s.staff_lname
FROM staff s
INNER JOIN staff_proposed sp ON s.staffID = sp.staffID
INNER JOIN projects p ON sp.projectID = p.projectID
WHERE  p.streamID = s.streamID;

#Query to find out students who were most satisfied with their projects
SELECT ss.studentID, s.student_fname, s.student_lname, s.GPA, ss.stud_satisfaction_score
FROM student AS s
INNER JOIN stud_satisfaction AS ss
ON s.studentID = ss.studentID
WHERE stud_satisfaction_score = 100;


