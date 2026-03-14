create database bakery;
use bakery;
show tables;

CREATE TABLE CUSTOMERS (
    cid VARCHAR(50) PRIMARY KEY,
    lname VARCHAR(50),
    fname VARCHAR(50)
);

CREATE TABLE PRODUCTS (
    pid VARCHAR(20) PRIMARY KEY,
    flavor VARCHAR(50),
    food VARCHAR(50),
    price DECIMAL(10, 2)
);

CREATE TABLE RECEIPTS (
    rno INT PRIMARY KEY,
    rdate DATE,
    cid VARCHAR(50),
    FOREIGN KEY (cid) REFERENCES CUSTOMERS(cid)
);

CREATE TABLE ITEM_LIST (
    rno INT,
    ordinal INT,
    item VARCHAR(20),
    PRIMARY KEY (rno, ordinal),
    FOREIGN KEY (rno) REFERENCES RECEIPTS(rno),
    FOREIGN KEY (item) REFERENCES PRODUCTS(pid)
);

SELECT * FROM CUSTOMERS;
SELECT * FROM PRODUCTS;
SELECT * FROM RECEIPTS;
SELECT * FROM ITEM_LIST;




-- drop table ITEM_LIST;
-- drop table RECEIPTS;
-- drop table PRODUCTS;
-- drop table CUSTOMERS;


-- q1
SELECT * FROM PRODUCTS 
WHERE pid NOT IN (SELECT item FROM ITEM_LIST);




-- q2
SELECT * FROM CUSTOMERS 
WHERE cid IN (
    SELECT cid 
    FROM RECEIPTS 
    GROUP BY cid, rdate 
    HAVING COUNT(rno) > 2
);


-- q3 
SELECT * FROM PRODUCTS 
WHERE pid IN (
    SELECT item 
    FROM ITEM_LIST 
    GROUP BY item 
    HAVING COUNT(*) >= ALL (
        SELECT COUNT(*) 
        FROM ITEM_LIST 
        GROUP BY item
    )
);


-- q4
SELECT COUNT(DISTINCT rno) 
FROM ITEM_LIST 
WHERE item IN (
    SELECT p1.pid 
    FROM PRODUCTS p1 
    WHERE p1.price > (
        SELECT AVG(p2.price) 
        FROM PRODUCTS p2 
        WHERE p1.food = p2.food
    )
);




-- q5
SELECT c.fname, c.lname, r.rno, r.rdate
FROM CUSTOMERS c, RECEIPTS r
WHERE c.cid = r.cid 
AND NOT EXISTS (
    SELECT * FROM RECEIPTS r2 
    WHERE MONTH(r.rdate) = MONTH(r2.rdate) 
      AND YEAR(r.rdate) = YEAR(r2.rdate)
      AND r2.rdate > r.rdate
);







-- q6
SELECT rno, SUM(price)
FROM ITEM_LIST, PRODUCTS
WHERE item = pid 
AND rno IN (
    SELECT rno 
    FROM ITEM_LIST il, PRODUCTS p 
    WHERE il.item = p.pid AND p.food = 'Twist'
)
GROUP BY rno
HAVING COUNT(ordinal) = 5 AND SUM(price) > 25;




-- q7
SELECT c.fname, c.lname, r.rno, il.item
FROM CUSTOMERS c, RECEIPTS r, ITEM_LIST il
WHERE c.cid = r.cid AND r.rno = il.rno AND il.item IN (
    SELECT item 
    FROM ITEM_LIST il2, RECEIPTS r2
    WHERE il2.rno = r2.rno
    GROUP BY item
    HAVING COUNT(DISTINCT r2.cid) <= ALL (
        SELECT COUNT(DISTINCT r3.cid) 
        FROM ITEM_LIST il3, RECEIPTS r3
        WHERE il3.rno = r3.rno
        GROUP BY item
    )
);


-- q8
SELECT c.fname, c.lname, r.rno
FROM CUSTOMERS c, RECEIPTS r
WHERE c.cid = r.cid 
AND NOT EXISTS (
    (SELECT flavor FROM PRODUCTS WHERE food = 'Meringue')
    EXCEPT
    (SELECT p.flavor 
     FROM ITEM_LIST il, PRODUCTS p 
     WHERE il.item = p.pid AND il.rno = r.rno)
);



SELECT C.*, R.rno, R.rdate
FROM CUSTOMERS C, RECEIPTS R
WHERE C.cid = R.cid
AND R.rdate = LAST_DAY(R.rdate);


SELECT R.rno,
       (SELECT SUM(P.price)
        FROM ITEM_LIST I2, PRODUCTS P
        WHERE I2.item = P.pid
        AND I2.rno = R.rno) AS total_price
FROM RECEIPTS R
WHERE R.rno IN (
    SELECT I.rno
    FROM ITEM_LIST I, PRODUCTS P
    WHERE I.item = P.pid
    AND P.food = 'Twist'
)
AND 5 = (
    SELECT COUNT(*)
    FROM ITEM_LIST I
    WHERE I.rno = R.rno
)
AND (
    SELECT SUM(P.price)
    FROM ITEM_LIST I3, PRODUCTS P
    WHERE I3.item = P.pid
    AND I3.rno = R.rno
) > 25;

SELECT C.*, R.rno, I.item
FROM CUSTOMERS C, RECEIPTS R, ITEM_LIST I
WHERE C.cid = R.cid
AND R.rno = I.rno
AND I.item = (
    SELECT item
    FROM ITEM_LIST
    GROUP BY item
    HAVING COUNT(DISTINCT rno) <= ALL (
        SELECT COUNT(DISTINCT rno)
        FROM ITEM_LIST
        GROUP BY item
    )
);

SELECT C.*, R.rno
FROM CUSTOMERS C, RECEIPTS R
WHERE C.cid = R.cid
AND NOT EXISTS (
    SELECT *
    FROM PRODUCTS P
    WHERE P.food = 'Meringue'
    AND NOT EXISTS (
        SELECT *
        FROM ITEM_LIST I
        WHERE I.rno = R.rno
        AND I.item = P.pid
    )
);


