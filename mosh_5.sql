-- transactions - A group of SQL statements that represent a single unit of work
-- acid properties - (A - atomicity), (C - consistency), (I-isolation), (D- durability)

-- Atomictiy - Each transactions are like atoms they are unbreakable. Each trasaction is a single unit of work no matter how many statemnts it contains. Either all the statements are executed successfully and trasaction is comitted or the transaction is rolled back and all the changes are undone
-- Consistency - This means our database should be in consistent state
-- Isolation - These transactions are isolated from each other or protected from each other if they try to modify the same data. Two transactions cannot interfere with each other. If multiple transactions are to update the same row then one transaction must wait for other transaction to wait for first to complete
-- Durability - Once the transactions are comitted, the changes made by the transaction are permanent. So if we have the power failure or system crash we are not loosing the changes made 
-- Rolling back - Undoing of changes made by the transaction is called rolled back
use sql_store;
start transaction;
insert into orders(customer_id, order_date, status) values (1, '2019-01-01', 1);
insert into order_items values (last_insert_id(), 1, 1, 1);
commit;

-- rollback - is used to undone the changes made by the transaction

-- concurrency - Concurrency is a situation that arises in a database due to the transaction process. Concurrency occurs when two or more than two users are trying to access the same data or information. DBMS concurrency is considered a problem because accessing data simultaneously by two different users can lead to inconsistent results or invalid behaviour
-- concurrency control is most of time is managed by mysql by locking the one transaction
-- concurrency problems - Lost updates, dirty reads, non - repeating, phantom reads
-- lost updates - this is automatically managed by mysql by locking mechanism
-- dirty reads - this occurs when one transaction reads the uncommited data
-- non - repeating - this occurs when second transaction reads two different values because of first transaction
-- phantom(ghost) reads - this occurs when data changes suddeny on some changes made by transaction and is eligible for some processing. like select * from table where points > 10 but some transaction b chages some records in table and increse there value to > 10 and now those records also need processing so these new records are considered to be phantom data
use sql_store;
start transaction;
update customers set points = points + 10 where customer_id = 1;
commit;

-- deadlocks -- it is condition when two transaction try to access the same data at same point of time
use sql_store;
start transaction;
update customers set state = 'VA' where customer_id = 1;
update orders set status = 1 where order_id = 1;
commit;

-- suppose the below code when runned under the different instance of mysql workbench

use sql_store;
start transaction;
update orders set status = 1 where order_id = 1;
update customers set state = 'VA' where customer_id = 1;
commit;