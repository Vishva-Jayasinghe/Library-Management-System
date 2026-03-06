[library_sql_full_readme.md](https://github.com/user-attachments/files/25803595/library_sql_full_readme.md)

# Library Management System – SQL Project

## Project Overview
This project demonstrates the design and analysis of a **Library Management System database using PostgreSQL**.

The goal of the project is to build a relational database that manages:

- Library branches
- Employees
- Books
- Members
- Book issuing process
- Book return tracking

The project also includes **SQL queries that solve real business problems** such as identifying overdue books, analyzing branch performance, and tracking active members.

---

# Database Schema Creation

## Branch Table

```sql
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
    branch_id VARCHAR(50) PRIMARY KEY,
    manager_id VARCHAR(50),
    branch_address VARCHAR(50),
    contact_no VARCHAR(20)
);
```

## Employees Table

```sql
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(20) PRIMARY KEY,
    emp_name VARCHAR(20),
    position VARCHAR(20),
    salary INT,
    branch_id VARCHAR(20)
);
```

## Books Table

```sql
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    book_id VARCHAR(20) PRIMARY KEY,
    book_title VARCHAR(75),
    category VARCHAR(10),
    rental_price FLOAT,
    status VARCHAR(15),
    author VARCHAR(50),
    publisher VARCHAR(25)
);
```

## Members Table

```sql
DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR(20) PRIMARY KEY,
    member_name VARCHAR(30),
    member_address VARCHAR(75),
    reg_date DATE
);
```

## Issued Status Table

```sql
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),
    issued_book_name VARCHAR(75),
    issued_date DATE,
    issued_book_id VARCHAR(25),
    issued_emp_id VARCHAR(10)
);
```

## Return Status Table

```sql
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10),
    return_book_name VARCHAR(75),
    return_date DATE,
    return_book_id VARCHAR(20)
);
```

---

# Foreign Key Constraints

```sql
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_id)
REFERENCES books(book_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_return_book
FOREIGN KEY (return_book_id)
REFERENCES books(book_id);
```

---

# Business Problem Queries

## 1 Insert a New Book

```sql
INSERT INTO books(
book_id,book_title,category,rental_price,status,author,publisher
)
VALUES('978-1-60129-456-2',
'To Kill a Mockingbird',
'Classic',
6.00,
'yes',
'Harper Lee',
'J.B. Lippincott & Co.');
```

## 2 Update Member Address

```sql
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
```

## 3 Delete Issued Record

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS121';
```

## 4 Books Issued by Employee

```sql
SELECT issued_emp_id,
issued_id,
issued_book_id,
issued_book_name,
issued_date
FROM issued_status
WHERE issued_emp_id = 'E101';
```

## 5 Members Who Issued More Than One Book

```sql
SELECT s.issued_member_id,
m.member_name
FROM issued_status s
JOIN members m
ON m.member_id = s.issued_member_id
GROUP BY s.issued_member_id,m.member_name
HAVING COUNT(DISTINCT issued_book_id) > 1;
```

## 6 Books Summary Table

```sql
CREATE TABLE books_summary AS
SELECT 
b.book_id,
b.book_title,
COUNT(s.issued_id) AS no_of_issues
FROM books b
JOIN issued_status s
ON s.issued_book_id = b.book_id
GROUP BY b.book_id,b.book_title;
```

## 7 Retrieve Books in a Category

```sql
SELECT *
FROM books
WHERE category = 'Classic';
```

## 8 Rental Income by Category

```sql
WITH category_rent AS (
SELECT 
category,
SUM(rental_price) AS total_rent
FROM books
GROUP BY category
)

SELECT 
b.category,
COUNT(s.issued_id) AS no_of_books,
c.total_rent,
COUNT(s.issued_id) * c.total_rent AS revenue
FROM issued_status s
JOIN books b
ON b.book_id = s.issued_book_id
JOIN category_rent c
ON b.category = c.category
GROUP BY b.category,c.total_rent;
```

## 9 Members Registered in Last 180 Days

```sql
SELECT *
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';
```

## 10 Employees with Branch Details

```sql
SELECT e.emp_id,
e.emp_name,
b.manager_id,
b.branch_id,
b.branch_address
FROM employees e
JOIN branch b
ON e.branch_id = b.branch_id;
```

## 11 Books With Price Greater Than 7

```sql
CREATE TABLE books_price_greater_than_seven AS
SELECT *
FROM books
WHERE rental_price > 7;
```

## 12 Books Not Yet Returned

```sql
SELECT DISTINCT *
FROM issued_status s
LEFT JOIN return_status r
ON r.return_id = s.issued_id
WHERE r.return_id IS NULL;
```

## 13 Overdue Books

```sql
SELECT 
s.issued_member_id,
m.member_name,
b.book_title,
s.issued_date,
CURRENT_DATE - s.issued_date AS over_due
FROM issued_status s
JOIN members m
ON m.member_id = s.issued_member_id
JOIN books b
ON b.book_id = s.issued_book_id
LEFT JOIN return_status r
ON r.issued_id = s.issued_id
WHERE r.return_date IS NULL
AND CURRENT_DATE - s.issued_date > 700;
```

## 14 Branch Performance Report

```sql
CREATE TABLE book_revenue AS
SELECT  
br.branch_id,
br.manager_id,
COUNT(s.issued_id) AS books_issued,
SUM(b.rental_price) AS total_revenue
FROM issued_status s
JOIN employees e
ON e.emp_id = s.issued_emp_id
JOIN branch br
ON e.branch_id = br.branch_id
JOIN books b
ON s.issued_book_id = b.book_id
GROUP BY br.branch_id,br.manager_id;
```

## 15 Active Members (Last 2 Months)

```sql
CREATE TABLE active_members AS
SELECT *
FROM members
WHERE member_id IN (
SELECT DISTINCT issued_member_id
FROM issued_status
WHERE issued_date >= CURRENT_DATE - INTERVAL '2 month'
);
```

## 16 Top Employees Processing Book Issues

```sql
SELECT 
e.emp_name,
b.branch_id,
COUNT(s.issued_id) AS no_book_issued
FROM issued_status s
JOIN employees e
ON e.emp_id = s.issued_emp_id
JOIN branch b
ON e.branch_id = b.branch_id
GROUP BY e.emp_name,b.branch_id
ORDER BY no_book_issued DESC
LIMIT 3;
```

---

# Tools Used

- PostgreSQL
- SQL
- pgAdmin
- ERD Modeling

---

# Author

**Vishva Suraj**  
Aspiring Data Analyst | SQL | Data Analysis | Database Design
