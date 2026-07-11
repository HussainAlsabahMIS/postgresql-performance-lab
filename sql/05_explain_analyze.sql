-- Day 04: Comparing Seq Scan vs Index Scan on users.email
-- Table size: 100,000 rows

-- ============================================
-- BEFORE: No index on email (Sequential Scan)
-- ============================================
EXPLAIN ANALYZE
SELECT * FROM users WHERE email = 'user50000@example.com';

-- Result:
-- Seq Scan on users (actual time=8.369..17.478 rows=1 loops=1)
-- Rows Removed by Filter: 100001
-- Buffers: shared hit=935
-- Execution Time: 17.521 ms

-- ============================================
-- Index created
-- ============================================
-- CREATE INDEX idx_users_email ON users(email);
-- (see 03_indexes.sql)

-- ============================================
-- AFTER: Index on email (Index Scan)
-- ============================================
EXPLAIN ANALYZE
SELECT * FROM users WHERE email = 'user50000@example.com';

-- Result:
-- Index Scan using idx_users_email on users (actual time=0.131..0.132 rows=1 loops=1)
-- Buffers: shared hit=1 read=3
-- Execution Time: 0.163 ms

-- ============================================
-- Summary: ~100x faster execution time after indexing
-- Rows examined dropped from 100,001 to ~1
-- Buffers accessed dropped from 935 to 4
-- ============================================