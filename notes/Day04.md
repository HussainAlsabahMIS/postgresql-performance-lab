\# Day 04 — EXPLAIN ANALYZE, and the real cost of a missing index



\## What I did today



\- Generated 100,000 fake rows in the `users` table using `generate\_series`

\- Ran `EXPLAIN ANALYZE` on a query filtering by `email` — before any index existed

\- Created an index on `email`

\- Ran the exact same query again and compared the execution plans



\## The experiment



\*\*Query used (same in both cases):\*\*

\\```sql

SELECT \* FROM users WHERE email = 'user50000@example.com';

\\```



| Metric            | Before Index (Seq Scan) | After Index (Index Scan) |

|-------------------|--------------------------|----------------------------|

| Scan type         | Seq Scan                | Index Scan                |

| Rows examined     | 100,001                 | \~1                         |

| Buffers accessed  | 935                      | 4 (1 hit + 3 read)         |

| Execution Time    | 17.521 ms                | 0.163 ms                   |



\*\*Result: \~100x faster.\*\*



\## Why this happens



Without an index, PostgreSQL has no way to know where a matching row

might be — so it reads every single row in the table and checks it

against the filter. This is a Sequential Scan. It's like searching for

a name in a phone book by reading every page from the start.



An index on `email` is stored as a B-Tree — a sorted structure.

Instead of reading every row, PostgreSQL can navigate directly toward

the matching value in a small number of steps. This is an Index Scan.



The bigger the table, the bigger this gap becomes. On a small table

(2 rows), the difference was invisible (0.25ms either way). On 100,000

rows, the difference became dramatic. On a production table with

millions of rows, an unindexed lookup like this could easily be the

root cause of a "query that used to take 1 second, now takes 1 minute."



\## Key terms I learned



\- \*\*Seq Scan\*\*: reads the entire table, row by row

\- \*\*Index Scan\*\*: uses a sorted index structure (B-Tree) to jump

&#x20; directly to matching rows

\- \*\*Buffers\*\*: units of data PostgreSQL reads from memory/disk;

&#x20; fewer buffers = less work

\- \*\*Rows Removed by Filter\*\*: rows PostgreSQL had to read and then

&#x20; discard because they didn't match — a strong signal of an unindexed scan



\## Open question I still need to answer



If indexes make lookups this much faster, why doesn't PostgreSQL just

put an index on every column automatically? What's the tradeoff?

(To explore in Day 05)

