-- triggers
-- a trigger is a block of sql code that automatically gets executed before or after an insert, update or delete statement
-- a trigger cannot be performed on the same table for which it is updating or deleting data as that will lead to infinite loop
-- the below example the trigger is placed on payments table and we are updating payment_total in invoices table

delimiter $$
create trigger payments_after_insert
	after insert on payments
    for each row 
begin
	update invoices
    set payment_total = payment_total + new.amount -- new will return the latest updated row in payments table
    where invoice_id = new.invoice_id;
end$$
delimiter ;

insert into payments values (default, 1, 6, '2019-01-04', 10, 1);

-- create a trigger that gets fired when we delete a payment
delimiter $$
create trigger payments_after_delete
	after delete on payments
    for each row
begin
	update invoices 
    set payment_total = payment_total - old.amount
    where invoice_id = old.invoice_id;
end$$
delimiter ;

delete from payments where payment_id = 10; -- replace payment_id with new payment id generated

show triggers;

drop trigger if exists payments_after_delete;


-- events
-- an event is a task or a block of sql code that gets executed according to a schedule- schedule can be per day per month etc
-- example of event - copying data from one table to archive table 

show variables like 'event%';
set global event_scheduler = ON;