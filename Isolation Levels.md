# Database Transaction Isolation Levels

Isolation level defines how much one database transaction is isolated
from other concurrently executing transactions.

In simple terms, it determines:

> If two transactions access or modify the same data simultaneously,
> what can one transaction see about the other's changes?

Isolation levels are part of the **ACID** properties of database
transactions.

## 1. Why do we need isolation levels?

Suppose a bank account has a balance of ₹10,000.

Two transactions execute simultaneously:

-   **T1:** Withdraw ₹2,000.
-   **T2:** Withdraw ₹3,000.

Both transactions read the initial balance of ₹10,000.

Without appropriate concurrency control, they might both calculate their
updates independently, resulting in a **lost update**. Transaction
isolation and concurrency-control mechanisms help address this problem.

## 2. Four standard isolation levels

SQL defines four standard isolation levels:

1.  Read Uncommitted
2.  Read Committed
3.  Repeatable Read
4.  Serializable

They provide progressively stronger guarantees, generally at the cost of
concurrency.

### A. Read Uncommitted

**Weakest isolation level**

A transaction can read data modified by another transaction even if that
transaction hasn't committed. This creates a problem called a **dirty
read**.

**Example**

Initial balance = ₹10,000.

    Step Transaction T1            Transaction T2
  ------ ------------------------- -----------------------
       1 Reads balance = 10,000    
       2 Updates balance = 5,000   
       3                           Reads balance = 5,000
       4 Rolls back                
       5                           Still has read 5,000

T2 read data that was never committed. This is called a **dirty read**.

**Where is it useful?**

It is rarely appropriate for business transactions. It may be acceptable
for certain approximate, non-critical reporting workloads.

### B. Read Committed

**Common default isolation level**

A transaction can read only committed data. However, if the same query
executes twice within the same transaction, it might return different
results. This creates a **non-repeatable read**.

**Example**

Initial balance = ₹10,000.

    Step Transaction T1           Transaction T2
  ------ ------------------------ -------------------------
       1 Reads balance = 10,000   
       2                          Updates balance = 7,000
       3                          Commits
       4 Reads balance = 7,000    

T1 reads two different values within the same transaction.

**Why?**

Because T2 committed an update between T1's two reads.

**Important:** Read Committed prevents dirty reads, but does not
guarantee that repeated reads return the same value.

### C. Repeatable Read

**Stronger isolation**

If a transaction reads a particular row, subsequent reads of that row
return the same value within that transaction.

This prevents:

-   Dirty reads.
-   Non-repeatable reads.

**Example**

Initial balance = ₹10,000.

    Step Transaction T1           Transaction T2
  ------ ------------------------ -------------------------
       1 Reads balance = 10,000   
       2                          Updates balance = 7,000
       3                          Commits
       4 Reads balance = 10,000   

T1 continues to see the original value.

However, there is another problem to understand: **phantom read**.

Suppose T1 executes:

``` sql
SELECT * FROM users WHERE age > 25;
```

It gets 10 records.

Meanwhile, T2 inserts a new user with age = 30 and commits.

T1 executes the same query again. Depending on the database and
isolation implementation, it may now see 11 records.

The newly appearing row is called a **phantom row**.

**How does this relate to MVCC?**

MVCC (Multi-Version Concurrency Control) allows a database to retain
multiple versions of a row. A transaction can continue reading an older
version of a row that was visible to it earlier.

A phantom read is different: it occurs when the *set of rows matching a
condition* changes between executions of the same query. For example, a
newly inserted row may now satisfy `age > 25`.

Whether that new row becomes visible depends on the database's
implementation of Repeatable Read. Some databases use a
transaction-level snapshot for ordinary reads and therefore do not
expose the newly inserted row to that transaction. Other implementations
may allow phantom rows under Repeatable Read, as permitted by the SQL
standard.

### D. Serializable

**Strongest standard isolation level**

Transactions behave as though they were executed sequentially rather
than concurrently.

The database ensures the outcome is equivalent to some serial execution
order.

This prevents the standard dirty-read, non-repeatable-read and
phantom-read anomalies.

However, it can significantly reduce concurrency.

Databases may implement this using:

-   Range locks.
-   Predicate locks.
-   Serialization conflict detection and transaction retries.

## 3. Quick comparison

  -----------------------------------------------------------------------
  Isolation              Dirty read     Non-repeatable       Phantom read
  level                                           read 
  -------------- ------------------ ------------------ ------------------
  Read                     Possible           Possible           Possible
  Uncommitted                                          

  Read Committed          Prevented           Possible           Possible

  Repeatable              Prevented          Prevented Possible under the
  Read                                                       SQL standard

  Serializable            Prevented          Prevented          Prevented
  -----------------------------------------------------------------------

> **Database implementation note:** The table above summarizes the
> SQL-standard guarantees. Actual behavior can be stronger and differs
> between database engines. For example, PostgreSQL and InnoDB in MySQL
> use MVCC, and their Repeatable Read implementations prevent phantom
> rows for ordinary snapshot reads. Locking reads and writes can have
> additional database-specific behavior.
