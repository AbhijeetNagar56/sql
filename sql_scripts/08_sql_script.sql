use COMPANY;

CREATE TABLE IF NOT EXISTS past_employee (
    Ssn CHAR(9) PRIMARY KEY,
    Fname VARCHAR(15),
    Lname VARCHAR(15),
    Salary DECIMAL(10, 2),
    Deletion_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Q1
DELIMITER //

CREATE TRIGGER validate_employee_salary
BEFORE INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    IF NEW.Salary < 20000 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: Salary must be at least $20,000.00';
    END IF;
END //

DELIMITER ;



-- Q2
DELIMITER //

CREATE TRIGGER archive_past_employee
AFTER DELETE ON EMPLOYEE
FOR EACH ROW
BEGIN
    INSERT INTO past_employee (Ssn, Fname, Lname, Salary)
    VALUES (OLD.Ssn, OLD.Fname, OLD.Lname, OLD.Salary);
END //

DELIMITER ;




-- TEST 1
INSERT INTO EMPLOYEE (Fname, Lname, Ssn, Salary) 
VALUES ('Test', 'User', '999887777', 15000);


-- TEST 2
-- Step A: Remove the restrictive constraint
ALTER TABLE DEPENDENT DROP FOREIGN KEY fk_dep_emp;

-- Step B: Add a new one that allows deletion
ALTER TABLE DEPENDENT 
ADD CONSTRAINT fk_dep_emp 
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn) 
ON DELETE CASCADE;


-- Step 1: Remove the existing restrictive constraint
ALTER TABLE WORKS_ON 
DROP FOREIGN KEY fk_works_emp;

-- Step 2: Add it back with ON DELETE CASCADE
ALTER TABLE WORKS_ON 
ADD CONSTRAINT fk_works_emp 
FOREIGN KEY (Essn) REFERENCES EMPLOYEE(Ssn) 
ON DELETE CASCADE;


DELETE FROM EMPLOYEE WHERE Ssn = '123456789';
SELECT * FROM past_employee;



