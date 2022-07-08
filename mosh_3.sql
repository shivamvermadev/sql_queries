-- views - these are the results of sql queries that are used as temporary tables for future use of processing queries so that we do not have to write the queries again. Views dont store data they are just results of queries 
-- suppose  we are not allowed to modify table then we can create a view of table and do modifications on that view

use invoicing;
create view sales_by_client as 
	select c.client_id, c.name, sum(invoice_total) as total_sales
    from clients c join invoices i on i.client_id = c.client_id
    group by client_id, name;
select * from sales_by_client where total_sales > 500;
select * from sales_by_client s join clients c on c.client_id = s.client_id;

create view clients_balance as 
	select c.client_id, c.name, sum(invoice_total-payment_total) from invoices i join clients c 
    on c.client_id = i.client_id group by i.client_id;
    
-- dropping a view;
drop view sales_by_client;

-- altering the view
create or replace view sales_by_client as
	select c.client_id, c.name, sum(invoice_total-payment_total) from invoices i join clients c 
    on c.client_id = i.client_id group by i.client_id;

-- updatable views - if view does not contain (distinct, aggregate function (min, max, sum), group by / having, union then we can use update, insert and delete statemets in view
create view invoices_with_balance as 
	select invoice_id, number, client_id, invoice_total, payment_total, 
    (invoice_total-payment_total) as balance,
    invoice_date, due_date, payment_date from invoices where (invoice_total-payment_total) > 0;
delete from invoices_with_balance where invoice_id = 19;

-- with check option in view - this prevents view from modifying other wise modifying view can lead to data loss inside a view
create or replace view invoices_with_balance as 
	select invoice_id, number, client_id, invoice_total, payment_total, 
    (invoice_total-payment_total) as balance,
    invoice_date, due_date, payment_date from invoices where (invoice_total-payment_total) > 0 with check option;