-- triggers - A block of sql code that automatically gets executed before or after an insert, update and delete statement
-- combinations of triggers
-- after insert, after update, after delete, before insert,  before update, before delete
-- in trigger we can modify any table except for the table for which the trigger is for like in this case payments

delimiter $$
create trigger payment_after_insert
	after insert on payments
    for each row
		begin
			update invoices 
            set payment_total = payment_total + new.amount  -- new.amount from payments table
            where invoice_id = new.invoice_id; -- new.invoice_id from payments table
        end $$
delimiter ;

delimiter $$ 
create trigger payment_after_delete
	after delete on payments 
		for each row 
			begin 
				update invoices
				set payment_total = payment_total - old.amount
                where invoice_id = old.invoice_id;
			end $$
delimiter ;

-- show triggers to show triggers;
show triggers;

-- dropping a trigger
drop trigger if exists payment_after_insert;