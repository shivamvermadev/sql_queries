-- stored procedures
-- a stored procedure is a database object that contains a block of sql code, Stored procedures are used to store and organize sql code
-- Most DBMS  perform some kind of optimization to the code in stored procedures, so sql code in stored procedures can sometimes be executed faster
-- stored procedures allows us to enforce data security for ex we can remove direct access to all the tables and allow various operations like inserting  
-- updating and deleting data to be performed  by stored procedures and then we can decice who can execute which stored procedure and this will limit what a user can do with data

-- creating stored procedure
DELIMITER $$
create procedure get_clients() 
begin
select * from clients;
end$$

DELIMITER ;

call get_clients(); -- calling SP

DELIMITER $$
create procedure get_invoices_with_balances()
begin
select * from invoices_with_balance where balance > 0;
end$$

DELIMITER ;


-- dropping a SP
drop procedure if exists get_payments;

-- adding parameters to our SP
delimiter $$
create procedure get_clients_by_state
(
	state char(2)
)
begin
	select * from clients c where c.state = state;
end$$

delimiter ;

call get_clients_by_state('CA'); -- if we don't supply parameter then we will get error as all params are required in mysql 

-- assign default value to a parameter
DELIMITER $$
create procedure get_clients_by_state_new 
(
	state char(2)
)
begin
	if  state is null then set state = 'CA';
	end if;
    
    select * from clients c where c.state = state;
end$$

delimiter ;

call get_clients_by_state_new(NULL);
call get_clients_by_state_new('NY');

DELIMITER $$
create procedure get_clients_by_state_new1
(
	state char(2)
)
begin
	if  state is null then 
		select * from clients c where c.state = 'CA';
	else 
		select * from clients c where c.state = state;
	end if;
    
end$$

delimiter ;

call get_clients_by_state_new1('NY');
call get_clients_by_state_new1(null);

-- parameter validation
delimiter $$
create procedure make_payment 
(
	invoice_id int,
	payment_amount decimal(9, 2),
    payment_date date
)
begin
	if payment_amount <= 0 then signal sqlstate '22003' set message_text = 'invalid payment amount';
    end if;
    
	update invoices i 
    set 
		i.payment_total = payment_amount,
        i.payment_date = payment_date
	where i.invoice_id = invoice_id;
end$$
delimiter ;

-- output params
delimiter $$
create procedure get_unpaid_invoices_for_client 
(
	client_id int,
    out invoices_count int, -- out to mark parameter as output parameter
    out invoices_total decimal(9, 2)
)
begin 
	select count(*), sum(invoice_total) into invoices_count, invoices_total -- reading two values and copying it to output params using into  
    from invoices i where i.client_id = client_id and payment_total = 0;
end $$

delimiter ;

-- variables 
-- user or session variables -stays inside memory untill we disconnect from mysql server
-- SET @invoice_number = 0; -- ex of user or session variable

-- local variables -- declared inside SP or function, goes out of scope as SP excecution completes or function completes

delimiter $$
create procedure get_risk_factor()
begin
	declare risk_factor decimal(9, 2) default 0;
    declare invoices_total decimal(9, 2);
    declare invoices_count INT;
    
    select count(*), sum(invoice_total)
    into invoices_count, invoices_total
    from invoices;
    
    set risk_factor = invoices_total / invoices_count * 5;
		
	select risk_factor;
end$$

delimiter ;

-- functions - difference between funciton and SP is that a function can only return a single values
delimiter $$
create function get_risk_factor_for_client
(
	client_id int
)
returns integer
reads sql data
begin

return 1;
end $$

delimiter ;

select client_id, name, get_risk_factor_for_client(client_id) from clients;

drop function if exists get_risk_factor_for_client; -- to drop a function