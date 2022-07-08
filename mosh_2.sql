use sql_hr;

select * from employees e join employees m on e.reports_to = m.employee_id;

-- if the name of columns are same on the ON condition in join then we can use the USING clause 
use sql_store;

select o.order_id, c.first_name from orders o join customers c 
using (customer_id); -- o.customer_id = c.customer_id

-- natural join - not recommended to use as the join condition is decided by database engine
select o.order_id, c.first_name from orders o 
	natural join customers c; -- join condition is not specified
    
-- cross join - used to join every record from first table to every record in second table 
-- ie every record from first table is joined with every record in second table
select c.first_name, p.name as product from customers c cross join products p order by c.first_name;
-- or 
select c.first_name, p.name as product from customers c, products p order by c.first_name;
select * from shippers s cross join products p;
select * from shippers s, products p;

-- union is used to combine rows from multiple queries results number of columns should be same for both the queries
select order_id, order_date, 'Active' as status from orders where order_date >= '2019-01-01'
union 
select order_id, order_date, 'Archived' as status from orders where order_date < '2019-01-01';

select customer_id, first_name, points, 'Bronze' as type from customers where points <= 2000
union
select customer_id, first_name, points, 'Silver' as type from customers where points between 2001 and 3000
union
select customer_id, first_name, points, 'Gold' as type from customers where points > 2000 order by first_name;

-- creating a exact copy of table 
create table orders_archived as select * from orders; -- by this technique primary key and auto increment is not implemented

-- delete all the data from table
truncate orders_archived;

-- select statement as sub-squery
insert into orders_archived select * from orders where order_date < '2019-01-01';

-- updating data in table 
update customers set phone = '101-201-1337', points = 4000 where customer_id = 5;
use invoicing;
select * from invoices;
update invoices set payment_total = invoice_total * 0.5, 
	payment_date = due_date where invoice_id = 1;

-- updating multiple rows in a table -- uncheck the safe updates from the preferences 
update invoices set payment_total = invoice_total * 0.5, payment_date = due_date
	where client_id = 3;

use sql_store;
select * from customers;
update customers set points = points + 50 where birth_date < '1990-01-01';

-- deleting a row from a table
use invoicing;
delete from invoices where invoice_id = 1;

select 
	max(invoice_total) as highest,
	min(invoice_total) as lowest, 
	avg(invoice_total) as average,
    sum(invoice_total) as sum, 
    count(invoice_total) as 'number of invoices', 
    count(payment_date) as 'number of payments' from invoices;
    
-- group by - is used to group items based on some column
use invoicing;
select client_id, sum(invoice_total) from invoices where invoice_date >= '2019-07-01' group by client_id;
-- group by multiple columns - every combination of selected columns in (group by) clause is made 
select state, city, sum(invoice_total) as total_sales 
	from invoices i join clients c on i.client_id = c.client_id group by state, city; 
select date, name, sum(amount) as total_payments from payments p 
	join payment_methods pm 
	on p.payment_method = pm.payment_method_id
	group by date, payment_method order by total_payments desc;
    
-- having clause - is used to filter data after the (group by) clause if we use where clause before (group by) clause mysql gives the error 
select * from (select client_id, sum(invoice_total) as total_sales from invoices group by client_id) as fasdf where total_sales > 800;
-- or
select client_id, sum(invoice_total) as total_sales, count(*) as number_of_invoices  
	from invoices group by client_id having total_sales > 800 and number_of_invoices > 5;
use sql_store;
select * from customers;

-- rollup - used to total the sum formed by (group by ) clause
use invoicing;
select client_id, sum(invoice_total) as total_sales from invoices group by client_id with rollup;
