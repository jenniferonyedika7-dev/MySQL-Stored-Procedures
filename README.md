# MySQL-Stored-Procedures
A collection of MySQL stored procedures for managing accounts, orders, students, courses, books and mobile money reports.


A collection of MySQL stored procedures built using MySQL 8.4 and phpMyAdmin 5.2.3.

## Procedures

- **accountTypeReport** — Compares account orders and customer activity between two date ranges.
- **generate_school_report** — Generates a student grade report with performance evaluation and class average comparison.
- **getBooks** — Retrieves books and their authors within a specified publication year range.
- **getCourses** — Returns the first course name enrolled by a specific student.
- **getMostExpensiveItems** — Lists the most expensive items belonging to a specific user.
- **get_MobileMoney_report** — Reports total orders and discounted amounts for a specific mobile money scheme.

## How to Use
Import the `stored_procedures.sql` file into your MySQL database using phpMyAdmin.
