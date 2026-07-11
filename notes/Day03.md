\# Day 03 — Indexes, conceptually



\## What I learned (before running any real experiments)

\- An index is a separate structure that stores a column's values

&#x20; plus a pointer to the actual row — not a copy of the full row

\- Indexes speed up lookups because PostgreSQL doesn't have to scan

&#x20; every row to find a match

\- Indexes are not free: they take up disk space and slow down

&#x20; writes (INSERT/UPDATE/DELETE), because the index has to be

&#x20; updated too

\- PostgreSQL doesn't always use an index even if one exists —

&#x20; the query planner decides based on cost estimates

\- Two scan types I need to understand in practice:

&#x20; - \*\*Sequential Scan\*\*: reads the whole table

&#x20; - \*\*Index Scan\*\*: uses the index to jump to matching rows



\## Open question going into Day 04

Why would PostgreSQL ever choose NOT to use an index if one is

available? What's the query planner actually weighing?

