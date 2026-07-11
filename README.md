\# PostgreSQL Performance Lab



A hands-on learning journey into PostgreSQL internals, query optimization,

and database engineering thinking — built while preparing for a

Database Administration internship.



This repository is not a tutorial. It documents real experiments,

real measurements, and real reasoning behind each decision.



\---



\## 🎯 Goal



To understand, from first principles, how PostgreSQL executes queries —

and how to diagnose and fix performance problems the way a database

engineer would in production.



Core question driving this project:



> "A dashboard query that used to take one second now takes one minute.

> How would you investigate and fix it?"



\---



\## 🧠 What This Project Covers



\- PostgreSQL fundamentals (tables, keys, constraints)

\- Indexes: how they work, and their tradeoffs

\- Query execution plans (`EXPLAIN`, `EXPLAIN ANALYZE`)

\- Sequential Scan vs Index Scan — measured, not assumed

\- Performance benchmarking at scale (100,000+ rows)

\- (Upcoming) MVCC, VACUUM, transactions, replication, backups



\---



\## 🛠️ Setup



\- \*\*Database:\*\* PostgreSQL

\- \*\*Client:\*\* pgAdmin

\- \*\*Test dataset:\*\* `users` table, populated with 100,000 synthetic rows

&#x20; via `generate\_series`



\---



\## 📊 Key Experiment: Seq Scan vs Index Scan



\*\*Question:\*\* Does an index actually matter at scale, and by how much?



\*\*Setup:\*\* `users` table, 100,000 rows, searching by `email`.



| Metric            | Before Index (Seq Scan) | After Index (Index Scan) |

|-------------------|--------------------------|----------------------------|

| Scan type         | Seq Scan                | Index Scan                |

| Rows examined     | 100,001                 | \~1                         |

| Buffers accessed  | 935                      | 4 (1 hit + 3 read)         |

| Execution Time    | 17.521 ms                | 0.163 ms                   |



\*\*Result: \~100x improvement in execution time.\*\*



\### Why this happens



A Sequential Scan reads every row in the table and checks it against the

filter — similar to searching a book page by page with no index.



An Index Scan uses a B-Tree structure, which is sorted, so PostgreSQL can

jump directly to the matching value in a small number of steps instead of

scanning everything.



See \[`sql/05\_explain\_analyze.sql`](sql/05\_explain\_analyze.sql) for the

exact queries and \[`notes/Day04.md`](notes/Day04.md) for the full writeup.



Screenshots: 

\- `screenshots/seq\_scan\_before\_index.png`

\- `screenshots/index\_scan\_after\_index.png`



\---



\## 📁 Repository Structure



\\```

postgresql-performance-lab/

├── README.md

├── notes/              # Daily learning logs, written in my own words

├── sql/                # All SQL scripts used, in chronological order

└── screenshots/        # pgAdmin screenshots of key experiments

\\```



\---



\## 📓 Learning Log



| Day | Topic |

|-----|-------|

| \[Day 01](notes/Day01.md) | PostgreSQL setup, first table, SERIAL vs AUTO\_INCREMENT |

| \[Day 02](notes/Day02.md) | Basic INSERT/SELECT, exploring the MySQL → PostgreSQL differences |

| \[Day 03](notes/Day03.md) | Indexes conceptually — what they are, why they help, why they cost |

| \[Day 04](notes/Day04.md) | EXPLAIN ANALYZE, real benchmark: Seq Scan vs Index Scan on 100k rows |



\---



\## 🚧 Status



Actively in progress. Next topics: MVCC, VACUUM/autovacuum, transactions,

locks, and query planner statistics.

