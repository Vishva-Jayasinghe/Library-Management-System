SELECT *
FROM books;

SELECT *
FROM branch;

SELECT *
FROM employees;

SELECT *
FROM issued_status;

SELECT * 
FROM return_status;


SELECT * FROM members ORDER BY member_id;

---REQUIRMENTS


--1 Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(
book_id,book_title,category,rental_price,status,author,publisher
)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

--2 Update an Existing Member's Address
UPDATE members
SET member_address = '125 Main St'
WHERE  member_id = 'C101';
--CHECK
SELECT * FROM members ORDER BY member_id;


--3 Delete a Record from the Issued Status Table 
-- Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE  issued_id  = 'IS121';

--4:Select all books issued by the employee with emp_id = 'E101'.
SELECT issued_emp_id,
	   issued_id,
	   issued_book_id,
	   issued_book_name,
	   issued_date
FROM issued_status
WHERE issued_emp_id = 'E101';

--5: List Members Who Have Issued More Than One Book

SELECT s.issued_member_id,
	   m.member_name
FROM issued_status s
JOIN members m
ON m.member_id = s.issued_member_id
GROUP BY s.issued_member_id,m.member_name
HAVING COUNT(DISTINCT issued_book_id) >1;


--6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
CREATE TABLE books_summary
AS
SELECT 
	 b.book_id,
	 b.book_title,
	 COUNT(s.issued_id) AS no_of_issues
FROM books b
JOIN issued_status s
ON s.issued_book_id = b.book_id
GROUP BY b.book_id,b.book_title;

--7. Retrieve All Books in a Specific Category 'Classic':

SELECT *
FROM books
WHERE category = 'Classic';

--8: Find Total Rental Income by Category
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
GROUP BY b.category, c.total_rent;

-- 9. List Members Who Registered in the Last 180 Days
SELECT * 
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';


--10 List Employees with Their Branch Manager's Name and their branch details
SELECT e.emp_id,
	   e.emp_name,
	   b.manager_id,
	   b.branch_id,
	   b.branch_address
FROM employees e
JOIN branch b
ON e.branch_id = b.branch_id; 



-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM books
WHERE rental_price > 7

SELECT * FROM 
books_price_greater_than_seven;


-- 12: Retrieve the List of Books Not Yet Returned
SELECT DISTINCT * 
FROM issued_status S
LEFT JOIN  return_status r
ON r.return_id = s.issued_id
WHERE r.return_id IS NULL;

-- 13 
--Write a query to identify members who have overdue books (assume a 700-day return period). 
--Display the member's_id, member's name, book title, issue date, and days overdue.

SELECT 
	s.issued_member_id,
	m.member_name,
	b.book_title,
	s.issued_date,
	--r.return_date,
	CURRENT_DATE - s.issued_date AS over_due
FROM issued_status s
JOIN members m
ON m.member_id = s.issued_member_id
JOIN books b
ON b.book_id = s.issued_book_id
LEFT JOIN return_status r
ON r.issued_id = s.issued_id
WHERE r.return_date IS NULL
AND CURRENT_DATE - s.issued_date >700
ORDER BY 1;

--
/*
14: Branch Performance Report
Create a query that generates a performance report for each branch,
showing the number of books issued,the number of books returned, and the total revenue generated from book rentals.
*/
--

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;

--CREATING A REVENUE TABLE
CREATE TABLE book_revenue AS 
		(SELECT  
		    br.branch_id,
		    br.manager_id,
		    COUNT(s.issued_id) AS books_issued,
		    SUM(b.rental_price) AS total_revenue
		FROM issued_status s
		JOIN employees e
		    ON e.emp_id = s.issued_emp_id
		JOIN branch br
		    ON e.branch_id = br.branch_id
		LEFT JOIN return_status r
		    ON r.issued_id = s.issued_id
		JOIN books b
		    ON s.issued_book_id = b.book_id
		GROUP BY 
		    br.branch_id,
		    br.manager_id
);

 --15 create a new table active_members containing members who have 
 --issued at least one book in the last 2 months.

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;
SELECT * FROM active_members;


--16: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. 
--Display the employee name, number of books processed, and their branch.

SELECT 
    e.emp_name,
    b.*,
    COUNT(s.issued_id) as no_book_issued
FROM issued_status s
JOIN
employees  e
ON e.emp_id = s.issued_emp_id
JOIN
branch  b
ON e.branch_id = b.branch_id
GROUP BY 1, 2
ORDER BY  COUNT(s.issued_id) DESC
LIMIT 3;



