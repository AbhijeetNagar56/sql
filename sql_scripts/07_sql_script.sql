
use COMPANY;
SHOW TABLES;
-- q1
DROP FUNCTION IF EXISTS get_job_profile;

CREATE FUNCTION get_job_profile(emp_salary DECIMAL(10,2))
RETURNS VARCHAR(50)
DETERMINISTIC
RETURN
    CASE
        WHEN emp_salary <= 35125 THEN 'Intern'
        WHEN emp_salary <= 45000 THEN 'Senior Engineer'
        ELSE 'Team Leader'
    END;





SELECT 
    CONCAT(Fname, ' ', Minit, ' ', Lname) AS Full_Name,
    get_job_profile(Salary) AS Job_Profile
FROM EMPLOYEE;


SHOW FUNCTION STATUS WHERE Db = 'COMPANY';


-- q2

USE COMPANY;

DROP TABLE IF EXISTS emp_super;

CREATE TABLE emp_super (
    person VARCHAR(50),
    supervisor VARCHAR(50)
);

INSERT INTO emp_super VALUES
('Bob', 'Alice'),
('Mary', 'Susan'),
('Alice', 'David'),
('David', 'Mary');


select * from emp_super;

DROP PROCEDURE IF EXISTS get_supervisors;

CREATE PROCEDURE get_supervisors()
BEGIN
    DECLARE current_person VARCHAR(50) DEFAULT 'Bob';
    DECLARE cnt INT DEFAULT 0;

    CREATE TEMPORARY TABLE IF NOT EXISTS supervisor_chain (
        supervisor VARCHAR(50) PRIMARY KEY
    );

    DELETE FROM supervisor_chain;

    WHILE current_person IS NOT NULL AND cnt < 4 DO
        
        SELECT supervisor INTO current_person
        FROM emp_super
        WHERE person = current_person
        LIMIT 1;

        IF current_person IS NOT NULL THEN
            INSERT IGNORE INTO supervisor_chain VALUES (current_person);
        END IF;

        SET cnt = cnt + 1;

    END WHILE;

    SELECT * FROM supervisor_chain;
END;

CALL get_supervisors;



