[library_sql_project_full_readme.md](https://github.com/user-attachments/files/25803492/library_sql_project_full_readme.md)

# Library Management System – SQL Data Analysis Project

## Project Overview
This project demonstrates the design and analysis of a **Library Management System database** using SQL.  
It includes database schema creation, foreign key relationships, and analytical queries that solve business problems related to book issuing, returns, revenue, and library branch performance.

The project simulates a real-world library environment where books are issued to members by employees working in different branches.

---

# Database Schema

## Tables Created
The database contains the following tables:

### 1. Branch
Stores information about library branches.

Columns:
- branch_id (Primary Key)
- manager_id
- branch_address
- contact_no

### 2. Employees
Stores employee details working at each branch.

Columns:
- emp_id (Primary Key)
- emp_name
- position
- salary
- branch_id (Foreign Key → branch.branch_id)

### 3. Books
Stores information about books available in the library.

Columns:
- book_id (Primary Key)
- book_title
- category
- rental_price
- status
- author
- publisher

### 4. Members
Stores registered library members.

Columns:
- member_id (Primary Key)
- member_name
- member_address
- reg_date

### 5. Issued Status
Tracks books issued to members.

Columns:
- issued_id (Primary Key)
- issued_member_id (Foreign Key → members.member_id)
- issued_book_name
- issued_date
- issued_book_id (Foreign Key → books.book_id)
- issued_emp_id (Foreign Key → employees.emp_id)

### 6. Return Status
Tracks returned books.

Columns:
- return_id (Primary Key)
- issued_id (Foreign Key → issued_status.issued_id)
- return_book_name
- return_date
- return_book_id (Foreign Key → books.book_id)

---

# Entity Relationship Design (ERD)

Relationships implemented:

- One Branch → Many Employees
- One Employee → Many Book Issues
- One Member → Many Book Issues
- One Book → Many Issues
- One Issue → One Return

Foreign key constraints enforce data integrity between tables.

---

# SQL Features Used

This project demonstrates several SQL concepts including:

- Table creation
- Primary and foreign keys
- Data manipulation (INSERT, UPDATE, DELETE)
- Joins
- Aggregations
- Grouping and filtering
- Common Table Expressions (CTE)
- Subqueries
- Creating summary tables
- Business analytics queries

---

# Business Problems Solved with SQL

## 1. Add a New Book
Insert a new book into the library system.

Example:
INSERT INTO books
VALUES('978-1-60129-456-2','To Kill a Mockingbird','Classic',6.00,'yes','Harper Lee','J.B. Lippincott & Co.');

---

## 2. Update Member Address
Update address information of an existing member.

Example:
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';

---

## 3. Delete an Issued Record
Remove a book issue record from the system.

Example:
DELETE FROM issued_status
WHERE issued_id = 'IS121';

---

## 4. Retrieve Books Issued by an Employee
Identify books issued by a specific employee.

---

## 5. Members Who Issued More Than One Book
Find active members who have borrowed multiple books.

---

## 6. Create a Book Issue Summary Table
Generate a summary table showing number of times each book was issued.

Table created:
books_summary

---

## 7. Retrieve Books by Category
Example: Find all books in the 'Classic' category.

---

## 8. Calculate Rental Revenue by Category
Uses a **Common Table Expression (CTE)** to compute revenue.

Metrics calculated:
- number of books issued
- total rental price
- revenue generated

---

## 9. Members Registered in the Last 180 Days
Identify recently registered members.

---

## 10. Employee and Branch Information
Retrieve employees along with their branch details and branch manager.

---

## 11. Books Above Rental Price Threshold
Create a table containing books with rental price greater than 7 USD.

Table created:
books_price_greater_than_seven

---

## 12. Books Not Yet Returned
Identify books that have been issued but not returned.

---

## 13. Overdue Books
Detect members who have overdue books based on a 700‑day return policy.

Output includes:
- Member ID
- Member Name
- Book Title
- Issue Date
- Days Overdue

---

## 14. Branch Performance Report
Generate a performance report for each branch.

Metrics:
- Total books issued
- Total revenue generated

Table created:
book_revenue

---

## 15. Active Members
Create a table identifying members who borrowed books within the last two months.

Table created:
active_members

---

## 16. Top Employees by Book Issues
Find the top 3 employees who processed the highest number of book issues.

Metrics displayed:
- Employee name
- Branch details
- Number of books processed

---

# Project Structure

Library-SQL-Project
│
├── schema.sql
├── analysis_queries.sql
├── ERD Diagram
└── README.md

---

# Skills Demonstrated

SQL  
PostgreSQL  
Database Design  
Relational Data Modeling  
Business Data Analysis  
Query Optimization  
Data Aggregation  
Common Table Expressions (CTE)

---

# Author

Vishva Suraj  
Aspiring Data Analyst with a background in **Statistics and Financial Mathematics**.

