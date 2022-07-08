-- transactions
-- a transaction is group of sql statements that represent a single unit of work
-- a transaction has 4 properties, known as ACID properties
-- A - atmoicity, it means a transactions is like atoms , they are unbreakable, each transaction is a single unit of work no matter how many statements it contains
-- C - consistency, it means with all these transactions our DB should be in a consistent state
-- I - isolation, it means that all our transactions are isolated or protected from eachother if they try to modify the same data, so two transactions cannot interfere with each other
-- D - durability, it means that once a transaction is commited, the changes made by a transaction are permanent, so if we have a power failure or system crash, we are not going to loose changes

-- creating transaction
start transaction;
-- sql code to be executed
commit;

-- mysql by default uses transaction on update delete operations 

-- concurrency when two user are trying to modify a same piece of data


-- blobs 
-- binary large object, used to store large binary data like images, videos
-- blobs present in mysql are 
-- tinyblob 255byes, blob 65KB,  mediumblob 16MB, longblob 4GB