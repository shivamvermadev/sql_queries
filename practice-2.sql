-- Unions - combining rows from multiple tables
use sql_store;
select o.order_id, o.order_date, 'ACTIVE' as status from orders o where o.order_date >= '2019-01-01' 
union
select o.order_id, o.order_date, 'ARCHIVE' as status from orders o where o.order_date < '2019-01-01';

select first_name from customers union 
select name from shippers; -- this will bring all the customers and shippers, note both select queries should return same number of columns

insert into customers (first_name, last_name, birth_date, phone, address, city, state, points) values 
('shan', 'mukharjee', '1987-01-01', NULL, 'add', 'city', 'AB', default);

select * from customers;

-- insert hierarichal data
insert into orders (customer_id, order_date, status) values (1, '2019-01-02', 1);
select * from orders;

select last_insert_id();
select * from order_items;
insert into order_items values (last_insert_id(), 1, 1, 2.95);

-- copy one table to another
create table orders_archive as select * from orders; -- mysql will not include attributes like primary key and auto increment
select * from orders_archive;
truncate orders_archive; -- remove all the data from the table

insert into orders_archive select * from orders;

use sql_invoicing;
select * from invoices;
select * from clients;

create table invoice_archive as select i.invoice_id, i.number, i.client_id, i.invoice_total, i.payment_total, i.invoice_date, i.due_date, i.payment_date
from invoices i join clients c on c.client_id = i.client_id;
drop table invoice_archive;

-- updating single row 
update invoices set payment_total = 10, payment_date = '2019-03-01' where invoice_id = 1;
select * from invoices;

-- updating multiple rows
use sql_invoicing;
update invoices set payment_total = invoice_total * 0.5, payment_date = due_date where client_id = 3; -- this statement will not work as my sql allows only one row at a time, to change this we need to update some settings

-- subquries in sql
update invoices set payment_total = invoice_total * 0.5, payment_date = due_date where client_id = (select client_id from clients where name = "myworks"); -- select client_id from clients where name = "myworks"; is a subquery
update invoices set payment_total = invoice_total * 0.5, payment_date = due_date where client_id in (select client_id from clients where state in ('CA', 'NY'));
select * from invoices;

-- deleting rows from table
delete from invoices where client_id = (select client_id from clients where name = 'myworks');


