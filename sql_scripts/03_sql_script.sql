show databases;
use COMPANY;

show tables;

-- question 1
SELECT P.Pname, SUM(W.Hours) AS Total_Hours
FROM PROJECT P, WORKS_ON W
WHERE P.Pnumber = W.Pno
GROUP BY P.Pname;


-- question 2
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Ssn NOT IN
      (SELECT Essn FROM DEPENDENT);



-- question 3
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Ssn IN
      (SELECT Mgr_ssn FROM DEPARTMENT)
AND Ssn IN
      (SELECT Essn FROM DEPENDENT);



-- question 4
SELECT Dno, COUNT(*) AS No_of_Employees, AVG(Salary) AS Avg_Salary
FROM EMPLOYEE
GROUP BY Dno;




-- question 5
SELECT P.Pnumber, P.Pname, COUNT(W.Essn) AS No_of_Employees
FROM PROJECT P, WORKS_ON W
WHERE P.Pnumber = W.Pno
GROUP BY P.Pnumber, P.Pname;


-- question 6
SELECT P.Pnumber, P.Pname
FROM PROJECT P, WORKS_ON W
WHERE P.Pnumber = W.Pno
GROUP BY P.Pnumber, P.Pname
HAVING COUNT(W.Essn) > 2;




-- question 7
SELECT Dno, COUNT(*) AS No_of_Employees
FROM EMPLOYEE
WHERE Salary > 40000
GROUP BY Dno
HAVING COUNT(*) > 5;



-- question 8
SELECT E.Fname, E.Lname
FROM EMPLOYEE E
WHERE NOT EXISTS
      ( (SELECT P.Pnumber FROM PROJECT P)
        EXCEPT
        (SELECT W.Pno
         FROM WORKS_ON W
         WHERE W.Essn = E.Ssn) );



-- question 9
SELECT Fname, Lname
FROM EMPLOYEE
WHERE Ssn NOT IN
      (SELECT Essn FROM WORKS_ON);




-- question 10
SELECT AVG(Salary) AS Avg_Female_Salary
FROM EMPLOYEE
WHERE Sex = 'F';




-- question 11
SELECT DISTINCT E.Fname, E.Lname, E.Address
FROM EMPLOYEE E
WHERE EXISTS
      (SELECT *
       FROM WORKS_ON W, PROJECT P
       WHERE E.Ssn = W.Essn
       AND W.Pno = P.Pnumber
       AND P.Plocation = 'Houston')
AND NOT EXISTS
      (SELECT *
       FROM DEPT_LOCATIONS D
       WHERE D.Dnumber = E.Dno
       AND D.Dlocation = 'Houston');


	
