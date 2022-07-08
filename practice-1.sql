USE sql_store;
show tables;

select * from customers 
-- where customer_id = 1 
order by first_name;

select last_name, first_name, points, points * 10 + 100 from customers; 
select last_name, first_name, points, points * 10 + 100 as new_points from customers;  -- as is used as alias for new columns
select last_name, first_name, points, points * 10 + 100 as 'new points' from customers;  -- as is used as alias for new columns

select state from customers;
select distinct state from customers; -- distinct is used to get unique data like set in c++

select * from customers where points > 3000;
--  few comparision operators <, <=, >, >=, =, !=, <> (<> and != are same)
select * from customers where state <> 'VA';
-- dates and strings are enclosed in single quotes in where clause
select * from customers where birth_date > '1990-01-01';

select * from customers where birth_date > '1990-01-01' and points > 1000; -- both conditions should satisfy
select * from customers where birth_date > '1990-01-01' OR points > 1000; -- or either condition satisfy
select * from customers where birth_date > '1990-01-01' OR points > 1000 and state = 'VA'; -- and > or in precedence 
select * from customers where birth_date > '1990-01-01' OR (points > 1000 and state = 'VA'); -- and > or in precedence 
select * from customers where not (birth_date > '1990-01-01' OR points > 1000);

-- IN operator
select * from customers where state = 'VA' or state = 'GA' or state = 'FL';
-- above statement using IN operator
select * from customers where state in ('VA', 'GA', 'FL');
select * from customers where state not in ('VA', 'GA', 'FL');

-- between operator
select * from customers where points >= 1000 and  points <= 3000;
select * from customers where points between 1000 and 3000;

-- regex without REGEXP operator
select * from customers where last_name like 'b%'; -- customers whose last name starts with b
select * from customers where last_name like '%b%'; -- customers whose last name contains b
select * from customers where last_name like '%y'; -- customers whose last name ending with y

-- we also have underscore _
select * from customers where last_name like '_y'; -- customers having last name lenght = 2 and last character of last name = y
select * from customers where last_name like '_____y'; -- customer having last name length = 6 and last character of last name = y
select * from customers where last_name like 'b____y'; -- customer having last name length = 6 and first character = b and last character = y

-- REGEXP operator
select * from customers where last_name like '%field%';
select * from customers where last_name REGEXP 'field';
select * from customers where last_name REGEXP '^field'; -- ^ charat sign is used to mark the beginning of the string ie last name should start with field
select * from customers where last_name REGEXP 'field$'; -- $ dollar sign is used to mark the end of string ie last name should end with field
select * from customers where last_name REGEXP 'field|mac|rose'; -- customers that have either field, mac, rose in their lastname
select * from customers where last_name REGEXP '^field|mac|rose'; -- customers that have either last name starting with field or having mac in their last name or having rose in their last name
select * from customers where last_name REGEXP 'field$|mac|rose'; -- customers that have either last name ending with field or having mac in their last name or having rose in their last name
select * from customers where last_name regexp '[gim]e'; -- customers having either ge or ie or me in their last name
select * from customers where last_name regexp 'e[gim]'; -- customers having either eg or ei or em in their last name
select * from customers where last_name regexp '[a-h]e'; -- customers having either ae, be, ce, --- he in their last name

-- NULL operator
select * from customers where phone is null;

-- Order by clause
-- default sorting order of any table is its primary key
select * from customers order by first_name;
select * from customers order by first_name desc;
select * from customers order by state, first_name; -- it will sort the customers based on their state and if two customers are from same state, then they are sorted based on their first name
select * from customers order by state DESC, first_name DESC;
select first_name, last_name from customers order by 1, 2; -- 1 = first_name and 2 =  last_name

-- limit clause
select * from customers limit 3; -- only first 3 customers,
-- limit clause should always come in the end

-- offset
select * from customers limit 6, 3; -- 6 is offset, it means skip initial 6 records and then pick next 3
select * from customers order by points desc limit 3;

-- JOIN -- note INNER JOIN is JOIN by default in mysql
select * from orders;
select * from orders join customers on orders.customer_id = customers.customer_id;
select order_id, first_name, last_name from orders join customers on orders.customer_id = customers.customer_id;
select order_id, first_name, customer_id, last_name from orders join customers on orders.customer_id = customers.customer_id; -- throw error as customer id is ambiguos present in both orders and customers table
select order_id, first_name, orders.customer_id, last_name from orders join customers on orders.customer_id = customers.customer_id; 
select order_id, first_name, o.customer_id, last_name from orders o join customers c on o.customer_id = c.customer_id; 

-- join across multiple DB 
select * from order_items oi join sql_inventory.products p on oi.product_id = p.product_id; -- sql_inventory is used as prefix 

-- self join
use sql_hr;
select * from employees;
select * from employees e join employees em on e.reports_to = em.employee_id;
select e.employee_id, e.first_name, em.first_name as reporting_manager from employees e join employees em on e.reports_to = em.employee_id;

-- joining multiple tables
use sql_store;
select * from orders;
select * from customers;
select * from orders o join customers c on o.customer_id = c.customer_id join order_statuses os on os.order_status_id = o.status;
select o.order_id, o.order_date, c.first_name, c.last_name, os.name as status  from orders o join customers c on o.customer_id = c.customer_id join order_statuses os on os.order_status_id = o.status;

use sql_invoicing;
select * from clients;
select * from payment_methods;
select * from payments;
select c.client_id, p.payment_id, p.invoice_id, p.date, pm.name from clients c join payments p on c.client_id = p.client_id join payment_methods pm on p.payment_method = pm.payment_method_id;

-- compound join conditions
use sql_store;
select * from order_items oi join order_item_notes oin on oi.order_id = oin.order_id and oi.product_id = oin.product_id;

-- implicit join syntax
 select * from orders o join customers c on o.customer_id = c.customer_id;
 -- OR can be written as 
 select * from orders o, customers c where o.customer_id = c.customer_id; -- not recommended to use

 -- outer joins
 select c.customer_id, c.first_name, o.order_id from customers c join orders o on o.customer_id = c.customer_id order by c.customer_id; -- here we only see customers who have order id, to fix this issue we use outer join
 -- in sql we have two type of joins - left join and right join-- left join = left outer join and right join = right outer join
 select c.customer_id, c.first_name, o.order_id from customers c left join orders o on o.customer_id = c.customer_id order by c.customer_id; -- by using we get every row from left table (customer ) where join condition holds good or not
select c.customer_id, c.first_name, o.order_id from customers c right join orders o on o.customer_id = c.customer_id order by c.customer_id; 
 
-- self joins
use sql_hr;
select e.employee_id, e.first_name, em.first_name from employees e left join employees em on e.reports_to = em.employee_id;

-- using clause
use sql_store;
select o.order_id, c.first_name from orders o join customers c on o.customer_id = c.customer_id;
-- the above statement can be replaced with using clause, if we have a join on same column
select o.order_id, c.first_name from orders o join customers c using (customer_id);
select o.order_id, c.first_name, sh.name as shipper from orders o join customers c using (customer_id) left join shippers sh using (shipper_id);

-- natural joins
select * from orders o natural join customers c; -- in this query, DB engine will look at the common column present in both table to make a join operation -- not recommended

-- cross joins - we use cross join to join every record from first table to every record in second table
select * from customers cross join products;
-- or we can write above query as
select * from customers, products;