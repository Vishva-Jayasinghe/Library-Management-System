--Project Library Management System
--Create tables
--Branch Table
DROP TABLE IF EXISTS branch;
CREATE TABLE branch(
			branch_id VARCHAR(50) PRIMARY KEY,
			manager_id VARCHAR(50),
			branch_address VARCHAR(50),
			contact_no  VARCHAR(20)

);

--employee table
DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
			 emp_id VARCHAR(20) PRIMARY KEY,
			 emp_name VARCHAR(20),
			 position VARCHAR(20),
			 salary INT,
			 branch_id VARCHAR(20) --FK

);

--books table
DROP TABLE IF EXISTS books;
CREATE TABLE books (
			book_id VARCHAR(20) PRIMARY KEY,
			book_title VARCHAR(75),
			category VARCHAR(10),
			rental_price FLOAT,
			status VARCHAR(15),
			author VARCHAR(50),
			publisher VARCHAR(25)

)
;

---members table
DROP TABLE IF EXISTS members;
CREATE TABLE members (
			member_id VARCHAR(20) PRIMARY KEY,
			member_name VARCHAR(30),
			member_address VARCHAR(75),
			reg_date DATE

);


--issued_statues
DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status(
			issued_id VARCHAR(10) PRIMARY KEY,
			issued_member_id VARCHAR(10),--FK
			issued_book_name VARCHAR(75),
			issued_date DATE,
			issued_book_id VARCHAR(25), --FK
			issued_emp_id VARCHAR(10) --FK 

);


--retutrn_status
DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status(
			return_id VARCHAR(10) PRIMARY KEY,
			issued_id VARCHAR(10), --FK
			return_book_name VARCHAR(75),
			return_date DATE,
			return_book_id VARCHAR(20) --FK

);

--FRORIEGN KEY CONSTRAINS
--issued_member_id
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)         --which column has a foriegn key
REFERENCES   members(member_id);         --In which table and column member_id is a primary key

--issued_book_id
ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_id)     
REFERENCES   books(book_id);        

--issued_emp_id
ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)     
REFERENCES   employees(emp_id);        


--branch_id
ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)    
REFERENCES	branch(branch_id) ;


--issued_id
ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)     
REFERENCES   issued_status(issued_id);    

--return_book_id
ALTER TABLE return_status
ADD CONSTRAINT fk_return_book
FOREIGN KEY (return_book_id)     
REFERENCES   books(book_id);   

