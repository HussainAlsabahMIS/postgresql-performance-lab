\# Day 05 — The Write Cost of an Index (and why not every column gets one)



\## The question I was trying to answer



If an index makes SELECT queries up to 100x faster, why doesn't

PostgreSQL just index every column automatically?



\## What I initially got wrong



I came in with the SQL Server / MySQL (InnoDB) concept of Clustered

vs Non-Clustered indexes (3-layer vs 4-layer B-Trees, table data

physically sorted by the clustered key). That model does NOT apply

to PostgreSQL.



\*\*Correction:\*\*

\- PostgreSQL has no clustered index concept by default. The table

&#x20; itself is stored as a \*\*Heap\*\* — rows are not physically sorted by

&#x20; any column.

\- Every index in PostgreSQL (unique or not) is a \*\*separate B-Tree\*\*

&#x20; structure containing the indexed value plus a pointer (`ctid`) back

&#x20; to the row's real location in the heap.

\- The only real difference between a unique and a non-unique index in

&#x20; Postgres is that a unique index also performs a constraint check

&#x20; (does this value already exist?) before allowing the insert — not a

&#x20; different physical structure.

\- Postgres does have a `CLUSTER` command, but it's a manual, one-time

&#x20; physical reordering of the table — not an always-on structural

&#x20; difference like SQL Server's clustered index.



\## The experiment: does an index actually slow down writes?



\*\*Setup:\*\* Insert 50,000 rows into `users` twice — once with no index

on `email`, once with an index already in place.



\\```sql

\-- Step 1: remove the index to get a clean baseline

DROP INDEX idx\_users\_email;



\-- Step 2: insert 50,000 rows with NO index on email

INSERT INTO users (username, email, password)

SELECT

&#x20;   'benchuser' || i,

&#x20;   'benchuser' || i || '@example.com',

&#x20;   'password123'

FROM generate\_series(1, 50000) AS i;



\-- Step 3: recreate the index

CREATE INDEX idx\_users\_email ON users(email);



\-- Step 4: clean up and repeat the same insert, now WITH the index present

DELETE FROM users WHERE username LIKE 'benchuser%';



INSERT INTO users (username, email, password)

SELECT

&#x20;   'benchuser' || i,

&#x20;   'benchuser' || i || '@example.com',

&#x20;   'password123'

FROM generate\_series(1, 50000) AS i;

\\```



\## Results



| Scenario                          | Insert time (50,000 rows) |

|-----------------------------------|----------------------------|

| No index on `email`               | 232 ms                     |

| Index on `email` already present  | 770 ms                     |



\*\*The insert was \~3.3x slower with the index in place.\*\*



\## Why this happens



With no index, PostgreSQL only has to write to one place: the table

(heap). With an index present, every single INSERT requires a second

write — updating the index's B-Tree structure so it stays accurate

and sorted. More indexes on a table means more writes per INSERT,

UPDATE, or DELETE — not just on the indexed column, but on every

write operation that touches the row.



\## The rule this experiment proves



An index is a trade-off, not a free win:



| Operation | Without index | With index |

|-----------|----------------|------------|

| SELECT (read) | Slow (Seq Scan) | Very fast (Index Scan) |

| INSERT/UPDATE/DELETE (write) | Fast | Slower — every index must also be updated |



\*\*Rule of thumb:\*\* an index is worth it when a column is read

(SELECT/WHERE) far more often than the table is written to. On a

write-heavy table with rare reads (e.g. a `logs` or `notifications`

table), adding indexes freely does more harm than good — the write

penalty applies to every single insert, while the read benefit is

rarely used.



\## Interview-ready answer



"Would you index every column on a table that receives thousands of

INSERTs per second and is rarely queried?"



No — because every index adds a write cost to every INSERT, not just

reads to the indexed column. On a write-heavy, read-light table, that

cost compounds thousands of times a day for a read benefit that's

barely used. Indexing decisions should be based on the actual

read-to-write ratio of the table, not applied blindly.

