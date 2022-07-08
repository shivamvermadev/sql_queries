-- limit and offset
use sql_store;
select * from customers limit 3;
select * from customers limit 6, 3; -- 6 is offset here means skip first 6 records and then print next 3 records

select * from customers order by points desc limit 3;

-- inner join
select * from orders;
select * from customers;

select * from customers join orders on customers.customer_id = orders.customer_id;
select order_id, first_name, last_name, orders.customer_id from customers 
	join orders on orders.customer_id = customers.customer_id;


-- limit and offset
use sql_store;
select * from customers limit 3;
select * from customers limit 6, 3; -- 6 is offset here means skip first 6 records and then print next 3 records

select * from customers order by points desc limit 3;

-- inner join
select * from orders;
select * from customers;

select * from customers join orders on customers.customer_id = orders.customer_id;
select order_id, first_name, last_name, orders.customer_id from customers 
	join orders on orders.customer_id = customers.customer_id;

select order_id, p.product_id, quantity, name from products p join order_items o on p.product_id = o.product_id; 

-- joining across tables of different databases 
select * from order_items o join sql_inventory.products p on o.product_id = p.product_id; 

-- self join
use sql_hr;
select * from employees e join employees m on e.reports_to = m.employee_id;
select e.employee_id, e.first_name, m.first_name as manager from employees e join employees m on e.reports_to = m.employee_id;

-- joining more than two tables 
use sql_store;
select * from customers c join orders o on c.customer_id = o.customer_id
	join order_statuses os on os.order_status_id = o.status;
select c.customer_id, c.first_name, c.last_name, os.name from customers c join orders o on c.customer_id = o.customer_id
	join order_statuses os on os.order_status_id = o.status;

use sql_invoicing;
select  c.client_id, c.name, pm.name as 'payment method' from clients c join payments p on c.client_id = p.client_id
	join payment_methods pm on p.payment_id = pm.payment_method_id;
	
-- compound join condition
-- composite primary key - contains more than one column for the primary key
use sql_store;
select * from order_items oi join order_item_notes oin
 on oi.order_id = oin.order_id and oi.product_id = oin.product_id;

-- outer join -- outer word is optional 
-- left join or right join or left outer join or right outer join
-- left join returns all the data from the left table whether the condition on the join is true or false;
-- right join returns all the data from the right table whether the condition on the join is true or false;

select c.customer_id, c.first_name, o.order_id from customers c 
	left join orders o on c.customer_id = o.customer_id;
select c.customer_id, c.first_name, o.order_id from customers c 
	right join orders o on c.customer_id = o.customer_id;
    
-- outer join on multiple tables
select c.customer_id, c.first_name, o.order_id, sh.name as shipper from customers c 
	left join orders o on c.customer_id = o.customer_id
		left join shippers sh on o.shipper_id = sh.shipper_id;
	