-- aggregate functions eg : max(), min(), avg(), sum(), count()
use sql_invoicing;
select max(invoice_total) as heighest, min(invoice_total) as lowest, avg(invoice_total) as average, sum(invoice_total) as total, count(invoice_total) as total_count from invoices;
-- the above functions can also be applied to dates and string
select max(payment_date) as highest from invoices;
-- the above function works only on non null values column 
select 
max(invoice_total) as heighest, 
min(invoice_total) as lowest, avg(invoice_total) as average, 
sum(invoice_total) as total, count(invoice_total) as total_count, count(payment_date) from invoices;

select count(*) from invoices; -- this will return number of records present in table irrespective of their null values

-- group by clause
select sum(invoice_total) as total_sales from invoices;
select client_id, sum(invoice_total) as total_sales from invoices group by client_id; -- total sales per client
select client_id, sum(invoice_total) as total_sales from invoices where invoice_date >= '2019-07-01' group by client_id; -- total sales per client
-- order of clauses - select -> from -> where -> group by -> order by 
select * from clients; 
select * from invoices;
select client_id, state, city, sum(invoice_total) as total_shares from invoices i join clients using (client_id) group by state, city;

-- having by clause
select client_id, sum(invoice_total) as total_sales from invoices group by client_id having total_sales > 500; -- having clause is used to filter data after grouping is done, where clause is used to filter data before groping
select client_id, sum(invoice_total) as total_sales, count(*) as number_of_invoices from invoices group by client_id having total_sales > 500 and number_of_invoices > 5;
-- with having clause, we can only have it over columns that are present in select clause

-- subqueries
use sql_store;
select * from products;
select * from products where unit_price > (select unit_price from products where product_id = 3);

-- find the products that have never been ordered
select * from products where product_id not in (select distinct product_id from order_items);
