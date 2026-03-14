```
SHOW DATABASES;
CREATE DATABASE database_name;
DROP DATABASE database_name;
USE database_name;
```

```
SHOW DATABASES;
CREATE DATABASE database_name;
DROP DATABASE database_name;
USE database_name;

CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    age INT CHECK (age >= 18)
);
```


```
INSERT INTO table_name VALUES (value1, value2);

INSERT INTO table_name (col1, col2)
VALUES (value1, value2);

UPDATE table_name
SET column_name = value
WHERE condition;

DELETE FROM table_name WHERE condition;
```



```
SELECT * FROM table_name;
SELECT column1, column2 FROM table_name;

SELECT DISTINCT column_name FROM table_name;

SELECT * FROM table_name
WHERE condition;

SELECT * FROM table_name
ORDER BY column_name ASC;

SELECT * FROM table_name
LIMIT 5;    
```



```
SELECT COUNT(*) FROM table_name;
SELECT SUM(column_name) FROM table_name;
SELECT AVG(column_name) FROM table_name;
SELECT MAX(column_name) FROM table_name;
SELECT MIN(column_name) FROM table_name;
```


```
SELECT column_name, COUNT(*)
FROM table_name
GROUP BY column_name;

SELECT column_name, COUNT(*)
FROM table_name
GROUP BY column_name
HAVING COUNT(*) > 5;
```



```

SELECT *
FROM table1
INNER JOIN table2
ON table1.id = table2.id;

SELECT *
FROM table1
LEFT JOIN table2
ON table1.id = table2.id;

SELECT *
FROM table1
RIGHT JOIN table2
ON table1.id = table2.id;
```




```
SELECT * FROM table_name
WHERE column_name = (
    SELECT MAX(column_name)
    FROM table_name
);
```

```
CREATE INDEX index_name
ON table_name (column_name);

DROP INDEX index_name ON table_name;
```


```
CREATE VIEW view_name AS
SELECT column1, column2
FROM table_name
WHERE condition;

SELECT * FROM view_name;

DROP VIEW view_name;
```



```
DELIMITER //

CREATE PROCEDURE procedure_name()
BEGIN
    SELECT * FROM table_name;
END //

DELIMITER ;

CALL procedure_name();
```




```
START TRANSACTION;

UPDATE table_name
SET column = value
WHERE id = 1;

COMMIT;
ROLLBACK;
```


```
CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON database_name.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
DROP USER 'username'@'localhost';
```


```
mysqldump -u username -p database_name > backup.sql
mysql -u username -p database_name < backup.sql
```