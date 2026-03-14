SHOW DATABASES;
USE COMPANY;

CREATE TABLE EMPLOYEE (
    Fname      VARCHAR(15),
    Minit      CHAR(1),
    Lname      VARCHAR(15),
    Ssn        CHAR(9),
    Bdate      DATE,
    Address    VARCHAR(60),
    Sex        CHAR(1),
    Salary     DECIMAL(10,2),
    Super_ssn  CHAR(9),
    Dno        INT,
    PRIMARY KEY (Ssn)
);


CREATE TABLE DEPARTMENT (
    Dname          VARCHAR(20),
    Dnumber        INT,
    Mgr_ssn        CHAR(9),
    Mgr_start_date DATE,
    PRIMARY KEY (Dnumber),
    UNIQUE (Dname)
);


CREATE TABLE DEPT_LOCATIONS (
    Dnumber   INT,
    Dlocation VARCHAR(20),
    PRIMARY KEY (Dnumber, Dlocation)
);

CREATE TABLE PROJECT (
    Pname     VARCHAR(20),
    Pnumber   INT,
    Plocation VARCHAR(20),
    Dnum      INT,
    PRIMARY KEY (Pnumber),
    UNIQUE (Pname)
);


CREATE TABLE WORKS_ON (
    Essn  CHAR(9),
    Pno   INT,
    Hours DECIMAL(4,1),
    PRIMARY KEY (Essn, Pno)
);








CREATE TABLE DEPENDENT (
    Essn           CHAR(9),
    Dependent_name VARCHAR(20),
    Sex            CHAR(1),
    Bdate          DATE,
    Relationship   VARCHAR(10),
    PRIMARY KEY (Essn, Dependent_name)
);





ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk_emp_dept
FOREIGN KEY (Dno) REFERENCES DEPARTMENT(Dnumber);

ALTER TABLE EMPLOYEE
ADD CONSTRAINT fk_emp_super
FOREIGN KEY (Super_ssn) REFERENCES EMPLOYEE(Ssn);

ALTER TABLE DEPARTMENT
ADD CONSTRAINT fk_dept_mgr
FOREIGN KEY (Mgr_ssn) REFERENCES EMPLOYEE(Ssn);

ALTER TABLE DEPT_LOCATIONS
ADD CONSTRAINT fk_dept_loc
FOREIGN KEY (Dnumber) REFERENCES DEPARTMENT(Dnumber);

ALTER TABLE PROJECT
ADD CONSTRAINT fk_proj_dept
FOREIGN KEY (Dnum) REFERENCES DEPARTMENT(Dnumber);

ALTER TABLE WORKS_ON
ADD CONSTRAINT fk_works_emp
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn),
ADD CONSTRAINT fk_works_proj
FOREIGN KEY (Pno) REFERENCES PROJECT(Pnumber);

ALTER TABLE DEPENDENT
ADD CONSTRAINT fk_dep_emp
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn);




INSERT INTO EMPLOYEE
(Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_ssn, Dno)
VALUES
('John','B','Smith','123456789','1965-01-09','731 Fondren, Houston, TX','M',30000,NULL,NULL),
('Franklin','T','Wong','333445555','1955-12-08','638 Voss, Houston, TX','M',40000,NULL,NULL),
('Alicia','J','Zelaya','999887777','1968-01-19','3321 Castle, Spring, TX','F',25000,NULL,NULL),
('Jennifer','S','Wallace','987654321','1941-06-20','291 Berry, Bellaire, TX','F',43000,NULL,NULL),
('Ramesh','K','Narayan','666884444','1962-09-15','975 Fire Oak, Humble, TX','M',38000,NULL,NULL),
('Joyce','A','English','453453453','1972-07-31','5631 Rice, Houston, TX','F',25000,NULL,NULL),
('Ahmad','V','Jabbar','987987987','1969-03-29','980 Dallas, Houston, TX','M',25000,NULL,NULL),
('James','E','Borg','888665555','1937-11-10','450 Stone, Houston, TX','M',55000,NULL,NULL);

INSERT INTO DEPARTMENT VALUES
('Research',5,'333445555','1988-05-22'),
('Administration',4,'987654321','1995-01-01'),
('Headquarters',1,'888665555','1981-06-19');







UPDATE EMPLOYEE SET
Dno = 5, Super_ssn = '333445555'
WHERE Ssn = '123456789';

UPDATE EMPLOYEE SET
Dno = 5, Super_ssn = '888665555'
WHERE Ssn = '333445555';

UPDATE EMPLOYEE SET
Dno = 4, Super_ssn = '987654321'
WHERE Ssn = '999887777';

UPDATE EMPLOYEE SET
Dno = 4, Super_ssn = '888665555'
WHERE Ssn = '987654321';

UPDATE EMPLOYEE SET
Dno = 5, Super_ssn = '333445555'
WHERE Ssn IN ('666884444','453453453');

UPDATE EMPLOYEE SET
Dno = 4, Super_ssn = '987654321'
WHERE Ssn = '987987987';

UPDATE EMPLOYEE SET
Dno = 1
WHERE Ssn = '888665555';



INSERT INTO DEPT_LOCATIONS VALUES
(1,'Houston'),
(4,'Stafford'),
(5,'Bellaire'),
(5,'Sugarland'),
(5,'Houston');


INSERT INTO PROJECT VALUES
('ProductX',1,'Bellaire',5),
('ProductY',2,'Sugarland',5),
('ProductZ',3,'Houston',5),
('Computerization',10,'Stafford',4),
('Reorganization',20,'Houston',1),
('Newbenefits',30,'Stafford',4);

INSERT INTO WORKS_ON VALUES
('123456789',1,32.5),
('123456789',2,7.5),
('666884444',3,40.0),
('453453453',1,20.0),
('453453453',2,20.0),
('333445555',2,10.0),
('333445555',3,10.0),
('333445555',10,10.0),
('333445555',20,10.0),
('999887777',30,30.0),
('999887777',10,10.0),
('987987987',10,35.0),
('987987987',30,5.0),
('987654321',30,20.0),
('987654321',20,15.0),
('888665555',20,NULL);
	




INSERT INTO DEPENDENT VALUES
('333445555','Alice','F','1986-04-05','Daughter'),
('333445555','Theodore','M','1983-10-25','Son'),
('333445555','Joy','F','1958-05-03','Spouse'),
('987654321','Alice','F','1988-12-30','Daughter'),
('123456789','Michael','M','1988-01-04','Son'),
('123456789','Abner','M','1988-01-04','Son'),
('123456789','Elizabeth','F','1967-05-05','Spouse');
		



SELECT * FROM EMPLOYEE;
SELECT * FROM DEPARTMENT;		
SELECT * FROM WORKS_ON;
SELECT * FROM DEPENDENT;
SELECT * FROM DEPT_LOCATIONS;
SELECT * FROM PROJECT;

SHOW TABLES;






# 27 JAN 2025

SELECT Bdate, Address
FROM EMPLOYEE
WHERE Fname = 'John' AND Minit = 'B' AND Lname = 'Smith';







SELECT E.Fname, E.Lname, E.Address
FROM EMPLOYEE E, DEPARTMENT D
WHERE E.Dno = D.Dnumber
AND D.Dname = 'Research';


SELECT P.Pnumber, P.Dnum, E.Lname, E.Address, E.Bdate
FROM PROJECT P, DEPARTMENT D, EMPLOYEE E
WHERE P.Dnum = D.Dnumber
AND D.Mgr_ssn = E.Ssn
AND P.Plocation = 'Stafford';



SELECT E.Fname AS Employee_Fname, E.Lname AS Employee_Lname,
       S.Fname AS Supervisor_Fname, S.Lname AS Supervisor_Lname
FROM EMPLOYEE E
LEFT JOIN EMPLOYEE S
ON E.Super_ssn = S.Ssn;




SELECT Fname, Lname
FROM EMPLOYEE
WHERE Dno = 5
AND Salary BETWEEN 30000 AND 40000;


SELECT E.Fname, E.Lname
FROM EMPLOYEE E, EMPLOYEE S
WHERE E.Super_ssn = S.Ssn
AND S.Fname = 'Franklin'
AND S.Lname = 'Wong';

SELECT E.Fname, E.Lname
FROM EMPLOYEE E, WORKS_ON W, PROJECT P
WHERE E.Ssn = W.Essn
AND W.Pno = P.Pnumber
AND E.Dno = 5
AND P.Pname = 'ProductX'
AND W.Hours > 10;




SELECT E.Fname, E.Lname
FROM EMPLOYEE E, DEPENDENT DSELECT Fname, Lname
FROM EMPLOYEE
WHERE Address LIKE '%Houston, TX%';

WHERE E.Ssn = D.Essn
AND E.Fname = D.Dependent_name;




SELECT DISTINCT P.Pnumber
FROM PROJECT P, WORKS_ON W, EMPLOYEE E
WHERE P.Pnumber = W.Pno
AND W.Essn = E.Ssn
AND E.Lname = 'Smith'

UNION

SELECT DISTINCT P.Pnumber
FROM PROJECT P, DEPARTMENT D, EMPLOYEE E
WHERE P.Dnum = D.Dnumber
AND D.Mgr_ssn = E.Ssn
AND E.Lname = 'Smith';






SELECT Fname, Lname
FROM EMPLOYEE
WHERE Address LIKE '%Houston, TX%';





SELECT Fname, Lname
FROM EMPLOYEE
WHERE Bdate BETWEEN '1950-01-01' AND '1959-12-31';
# 27 JAN 2025



SELECT E.Fname, E.Lname, E.Salary * 1.10 AS Increased_Salary
FROM EMPLOYEE E, WORKS_ON W, PROJECT P
WHERE E.Ssn = W.Essn
AND W.Pno = P.Pnumber
AND P.Pname = 'ProductX';
