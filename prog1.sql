create database Mosh;
use Mosh;

create table if not exists shivam(id int(10) auto_increment primary key,firstName varchar(10) not null ,lastName varchar(10) not null);
select * from shivam;
drop table shivam; 

CREATE TABLE IF NOT EXISTS `user_details`(
`user_id` int NOT NULL AUTO_INCREMENT,
`username` varchar(255) DEFAULT NULL,
`first_name` varchar(255) DEFAULT NULL,
`last_name` varchar(255) DEFAULT NULL,
`marks` int DEFAULT NULL,
PRIMARY KEY (`user_id`)
);
insert into `user_details` (`user_id`,`username`,`first_name`,`last_name`,`marks`) values -- these variables are used as to insert data into these column only
(1,"shivamvermadev","shivam","verma",10),
(2,"SKS","Saurabh","Singh",20),
(3,"drmadly","Nitesh","Khurcha",30),
(4,"BillBishnoi","Prashant","Bishnoi",40);

select * from user_details;

select marks, marks+10 from user_details; 
select marks, marks+10  AS new_marks from user_details;   -- AS is used as and alias for the new column name

select username from user_details order by username; -- order by is used to make a particular order (ascending or descending)

select marks from user_details order by marks desc;  -- desc to order in descending order

insert into user_details values(5,"AshishViLove","Ashish","Kumar Singh",60);
insert into user_details values(6,"vedicVed", "Dev", "verma",70),(7,"kediaJatin","jatin", "Kedia",100);

select distinct last_name from user_details; -- distinct is used to see distinct data rather the repeated data

-- Relational operators in sql 
-- < , <=, >, >=, !=, <>
select username from user_details where marks > 50;

-- query to select second max of the given data;
select username, first_name,last_name from user_details where marks = (select max(marks) from user_details where marks < (select max(marks) from user_details));

create table if not exists newUsers (userid int,username varchar(20),first_name varchar(20),last_name varchar(20),birthday date);
 
insert into newUsers values
(1,"shivamvermadev","shivam","verma","1997-10-29"),
(2,"SKS","Saurabh","Singh","1998-08-19"),
(3,"drmadly","Nitesh","Khurcha","1997-01-06"),
(4,"BillBishnoi","Prashant","Bishnoi","1997-03-18");

insert into newUsers value(5,"gauronelove","priyanshu","Gaur","1997-10-08");

alter table newUsers add marks int; -- used to add new column to the table

update newUsers set marks = 100 where userid = 1;

select * from newUsers;

select * from user_details where marks not in (10,40);

select * from user_details where marks >= 10 AND marks <=40;
-- or
select * from user_details where marks between 10 and 40;
select * from newusers;

select * from newusers where birthday >='1997-01-01' and birthday <='1997-08-30';
select * from newusers where birthday between '1997-01-01' and '1997-08-30';

select * from newusers where username like '%v%';  -- % for any number of characters 

-- regular expression is used in place of (like) as they are more poweful

select * from newusers where username REGEXP 'ver'; -- is equal to   like %ver% 
-- ^ is used for startswith 
-- $ is used for endswith
-- | is used to include different patterens for ex (ver|pra|K)  searches for ver or pra or K
-- [a-h] represents range
-- [vkb][se] -- vs, ve, ks, ke, bs, be

select * from newusers where username REGEXP ('ver|pra|K');
select * from newusers where username regexp '^shi';
select * from newusers where username regexp 'v$';

select * from newusers;

select * from newusers where username regexp '[k-]';

select * from newusers where username regexp '[vkb][se]'; -- vs, ve, ks, ke, bs, be

select * from newusers where marks is null;
select * from newusers where marks is not null;

select * from newusers order by username;
select * from newusers order by username desc;
select * from newusers order by username desc, first_name;

-- ofset to skip the records
-- limit to limit the number of records
select * from newusers limit 3;

-- suppose we want to skip first few records then use the offset and limit together

select * from newusers limit 2,3;  -- here 2 is offset


-- performing joins
-- inner join or join works the same is used to combine columns from different tables
select * from tab;
select * from newusers;

select * from newusers join tab on newusers.userid = tab.userid;

select username, first_name,last_name,birthday,marks,subject,grades  from newusers join tab on newusers.userid = tab.userid;
-- when two column in two tables have same name then selecting the one column should be prefix by its respective column name

select * from newusers nu join user_details ud on nu.userid = ud.user_id; 

-- join tables across multiple databases
select * from bldbank.bregister;
select * from newusers join bldbank.bregister br on newusers.userid = br.bid;

-- performing self joins
select * from newusers n join newusers u on n.userid = u.marks;  

alter table tab add result varchar(10);
update tab set result = 'pass' where userid = 1;
update tab set result = 'pass' where userid = 2;
update tab set result = 'fail' where userid = 3;


-- droping a table
alter table tab drop column marks;

-- performing join on more than two tables
select nu.userid,nu.username, nu.first_name,nu.last_name,nu.marks,t.result from newusers nu 
	join user_details ud 
		on nu.userid = ud.user_id
			join tab t 
				on t.userid = nu.userid; 

select * from tab;
alter table tab add rollno int;
update tab set rollno = 2 where userid=1;
update tab set rollno = 3 where userid=2;
update tab set rollno = 4 where userid=3;

-- when we hava the primary key as the combination of two columns then we use compound join conditions

select * from newusers nu join tab t on nu.userid = t.userid and nu.userid = t.rollno;

-- implicit join syntax 
select * from newusers nu join tab t on nu.userid = t.userid; -- is equivalent to the implicit join syntax;
-- implicit join syntax now 
select * from newusers nu, tab t where nu.userid = t.userid;

-- Outer join are of two types : Left join and Right join
-- Left join : return all the entries from the left table whether the on condition is true or false;
-- Right join : return all the entries from the right table whether the on condition is true or false;
-- left join or  left outer join
-- right join or right outer join
select * from newusers Left join tab on newusers.userid = tab.userid;
select * from newusers right join tab on newusers.userid = tab.userid;
select * from tab right join newusers on newusers.userid = tab.userid;

insert into tab values(10,'bio','z',11,'pass');

select * from tab; select * from newusers; select * from user_details;

select * from tab right join newusers on tab.userid = newusers.userid; 
select * from newusers right join tab on newusers.userid = tab.userid;
select * from tab right join newusers on newusers.userid = tab.userid right join user_details on user_details.user_id = tab.userid;
select * from newusers right join tab on newusers.userid = tab.userid right join user_details on user_details.user_id = tab.userid;
select * from newusers right join tab on newusers.userid = tab.userid left join user_details on user_details.user_id = tab.userid;

-- self outer join
select * from employees e join employees m on e.report_to = m.employee_id; -- this generates every employee but the manager itself
select * from employees e left join employees m on e.report_to = m.employee_id;