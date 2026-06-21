-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Jun 20, 2026 at 08:52 PM
-- Server version: 8.4.7
-- PHP Version: 8.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `accountTypeReport`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `accountTypeReport` (IN `v_from_date` DATE, IN `v_to_date` DATE)   BEGIN

drop TEMPORARY TABLE if EXISTS accounts_from;
drop TEMPORARY TABLE if EXISTS accounts_to;

CREATE TEMPORARY TABLE accounts_from
SELECT 
a.account_name as account_name, 
COUNT(o.id) as count_order_id, 
SUM(o.amount-(o.amount * s.discount/100)) 
as total_order_amount, 
COUNT(DISTINCT customer_id) as costomer_count
from accounts as a 
JOIN customers as c on c.id = a.customer_id 
join orders1 as o on a.id = o.account_id
JOIN schemes as s on s.id = a.scheme_id 
where o.order_date < v_from_date
group by a.account_name;


CREATE TEMPORARY TABLE accounts_to
SELECT 
a.account_name as account_name, 
COUNT(o.id) as count_order_id, 
SUM(o.amount-(o.amount * s.discount/100)) 
as total_order_amount, 
COUNT(DISTINCT customer_id) as costomer_count
from accounts as a 
JOIN customers as c on c.id = a.customer_id 
join orders1 as o on a.id = o.account_id
JOIN schemes as s on s.id = a.scheme_id 
where o.order_date < v_to_date
group by a.account_name;

SELECT at.account_name , (at.count_order_id - af.count_order_id )as count_order_diference, 
(at.total_order_amount - af.total_order_amount) as total_order_diference, 
(at.costomer_count - af.costomer_count) as customer_diference
from accounts_from  as af 
JOIN  accounts_to as at 
where at.account_name = af.account_name;

END$$

DROP PROCEDURE IF EXISTS `generate_school_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_school_report` (IN `v_sid` INT UNSIGNED)   BEGIN

SELECT c.id, c.course_name, sc.grade,
CASE 
   WHEN sc.grade >= 90 THEN "Excellent" 
   WHEN sc.grade >= 80 THEN "Very Good"
   WHEN sc.grade >= 70 THEN "Good"
   WHEN sc.grade >= 60 THEN "Satisfactory"
   ELSE "Needs Improvement"
END as grade_state,

avg_scores.average_score,
CASE 
   WHEN sc.grade > avg_scores.average_score THEN
   "Yes" ELSE "No"
END as above_average   
FROM student_courses as sc
JOIN test.courses as c on c.id = sc.course_id 

JOIN (
       SELECT
           course_id,
           AVG(grade) AS average_score
       FROM student_courses
       GROUP BY course_id
    ) AS avg_scores
 ON sc.course_id = avg_scores.course_id    
WHERE sc.student_id = v_sid;



END$$

DROP PROCEDURE IF EXISTS `getBooks`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBooks` (IN `yearFrom` INT, IN `yearTo` INT)   BEGIN

select title, author_name
from books as b
join authors as a on a.id = b.author_id
where published_year between yearFrom and yearTo;

END$$

DROP PROCEDURE IF EXISTS `getCourses`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCourses` (IN `v_student` VARCHAR(50), OUT `v_course` VARCHAR(50))   BEGIN
SELECT course_name 
INTO v_course
from courses as c
JOIN student_courses as sc on c.id = sc.course_id
JOIN students as s on s.id = sc.student_id
where student_name = v_student 
ORDER BY course_name LIMIT 1;
END$$

DROP PROCEDURE IF EXISTS `getMostExpensiveItems`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getMostExpensiveItems` (IN `v_Firstname` VARCHAR(50), IN `v_Lastname` VARCHAR(50), IN `v_count` INT)   BEGIN
SELECT name 
FROM items as i 
JOIN users as u ON u.id = i.user_id
WHERE firstname = v_Firstname and lastname = v_Lastname
order by price DESC 
limit v_count;
END$$

DROP PROCEDURE IF EXISTS `get_MobileMoney_report`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_MobileMoney_report` (IN `v_sch` INT UNSIGNED)   BEGIN

SELECT 
        COUNT(o.id) AS total_orders,
        SUM(o.amount - (o.amount * s.discount / 100)) AS total_amount_after_discount
    FROM orders1 AS o
     JOIN accounts AS a ON o.account_id = a.id
     JOIN schemes AS s ON a.scheme_id = s.id
    WHERE s.scheme_name = v_sch;


END$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
