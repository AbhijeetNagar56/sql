create database BAKERY;
use BAKERY;
show tables;




CREATE TABLE CUSTOMERS (
    cid INT PRIMARY KEY,
    fname VARCHAR(50),
    lname VARCHAR(50)
);



CREATE TABLE PRODUCTS (
    pid VARCHAR(50) PRIMARY KEY,
    flavor VARCHAR(50),
    food VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE RECEIPTS (
    rno INT PRIMARY KEY,
    rdate DATE,
    cid INT
);

CREATE TABLE ITEM_LIST (
    rno INT,
    ordinal INT,
    item VARCHAR(50)
);


-- A 

-- q1
SELECT 
    C.cid, C.fname, C.lname,
    R.rno, R.rdate
FROM CUSTOMERS C
JOIN RECEIPTS R ON C.cid = R.cid
WHERE R.rdate = LAST_DAY(R.rdate);

-- q2

SELECT 
    R.rno,
    SUM(P.price) AS Total_Price
FROM RECEIPTS R
JOIN ITEM_LIST I ON R.rno = I.rno
JOIN PRODUCTS P ON I.item = P.pid
WHERE R.rno IN (
    SELECT rno
    FROM ITEM_LIST
    WHERE item LIKE '%TW%' OR item LIKE '%TWIST%'
)
GROUP BY R.rno
HAVING SUM(P.price) > 25;


-- q3
SELECT 
    C.cid, C.fname, C.lname,
    R.rno, I.item
FROM CUSTOMERS C
JOIN RECEIPTS R ON C.cid = R.cid
JOIN ITEM_LIST I ON R.rno = I.rno
WHERE I.item = (
    SELECT item
    FROM ITEM_LIST
    GROUP BY item
    ORDER BY COUNT(DISTINCT rno) ASC
    LIMIT 1
);



-- q4
SELECT 
    C.cid, C.fname, C.lname,
    R.rno
FROM CUSTOMERS C
JOIN RECEIPTS R ON C.cid = R.cid
JOIN ITEM_LIST I ON R.rno = I.rno
JOIN PRODUCTS P ON I.item = P.pid
WHERE P.food = 'Meringue'
GROUP BY C.cid, C.fname, C.lname, R.rno
HAVING COUNT(DISTINCT P.flavor) = (
    SELECT COUNT(DISTINCT flavor)
    FROM PRODUCTS
    WHERE food = 'Meringue'
);



-- B part 
use COMPANY;

-- q1
CREATE VIEW Research_Employees AS
SELECT 
    E.Fname || ' ' || E.Lname AS Employee_Name,
    S.Fname || ' ' || S.Lname AS Supervisor_Name,
    E.Salary
FROM EMPLOYEE E
JOIN EMPLOYEE S ON E.Super_ssn = S.Ssn
JOIN DEPARTMENT D ON E.Dno = D.Dnumber
WHERE D.Dname = 'Research';

-- q2
INSERT INTO Research_Employees (Employee_Name, Supervisor_Name, Salary)
VALUES ('Test Emp', 'Test Sup', 20000);


-- q3
CREATE VIEW Dept_Manager AS
SELECT 
    D.Dname AS Department_Name,
    E.Fname || ' ' || E.Lname AS Manager_Name,
    E.Salary AS Manager_Salary
FROM DEPARTMENT D
JOIN EMPLOYEE E ON D.Mgr_ssn = E.Ssn;



-- q4
CREATE VIEW Dept_Manager_Count AS
SELECT 
    DM.Department_Name,
    DM.Manager_Name,
    COUNT(E.Ssn) AS Num_Employees
FROM Dept_Manager DM
JOIN DEPARTMENT D ON DM.Department_Name = D.Dname
JOIN EMPLOYEE E ON D.Dnumber = E.Dno
GROUP BY DM.Department_Name, DM.Manager_Name;




-- q5
INSERT INTO Dept_Manager_Count (Department_Name, Manager_Name, Num_Employees)
VALUES ('NewDept', 'New Manager', 0);


-- q6
CREATE VIEW Project_Info AS
SELECT 
    P.Pname AS Project_Name,
    D.Dname AS Department_Name,
    COUNT(DISTINCT W.Essn) AS Num_Employees,
    SUM(W.Hours) AS Total_Hours
FROM PROJECT P
JOIN DEPARTMENT D ON P.Dnum = D.Dnumber
JOIN WORKS_ON W ON P.Pnumber = W.Pno
GROUP BY P.Pname, D.Dname;


-- q7 
CREATE VIEW Project_Info_MultiEmp AS
SELECT *
FROM Project_Info
WHERE Num_Employees > 1;
