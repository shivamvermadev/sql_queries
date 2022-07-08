-- views in sql
-- we know that writing sub-queries might get complex, we can save these queries or sub queries in a view and this will help our select statement 
use sql_invoicing; 
select c.client_id, c.name, sum(invoice_total) as total_sales -- we can save this query as view to use it in future
from clients c join invoices i where i.client_id = c.client_id group by i.client_id, name;

create view sales_by_client as 
select c.client_id, c.name, sum(invoice_total) as total_sales
from clients c join invoices i where i.client_id = c.client_id group by i.client_id, name;
-- a view behaves like a virtual table, views dont store data - a view just provide a view to underlying table

-- altering or dropping a view
drop view sales_by_client;

create or replace view sales_by_client as 
select c.client_id, c.name, sum(invoice_total) as total_sales
from clients c join invoices i where i.client_id = c.client_id group by i.client_id, name;

SELECT * FROM sql_invoicing.sales_by_client;

-- updatable view
-- if a view dont contains any of the following (distinct, aggregate functions, group by, having by, union) 
-- then that view is called updatable view that mean we can update data through it. we can use this view in insert, update and delete statements
select * from invoices;
create or replace view invoices_with_balance as 
select invoice_id, number, client_id, invoice_total, payment_total, invoice_total - payment_total as balance, invoice_date, due_date, payment_date
from invoices where (invoice_total - payment_total) > 0;

delete from invoices_with_balance where invoice_id = 1;
select * from invoices_with_balance;

-- the with check option in view
-- when we update some row in a view there might be a scenario that, the updated row might get deleted from view and to prevent that we use WITH CHECK OPTION
create or replace view invoices_with_balance as 
select invoice_id, number, client_id, invoice_total, payment_total, invoice_total - payment_total as balance, invoice_date, due_date, payment_date
from invoices where (invoice_total - payment_total) > 0
with check option;
