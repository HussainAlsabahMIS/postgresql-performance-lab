-- Day 04: Creating an index on email
-- Goal: Speed up lookups on email (used heavily in WHERE clauses)

CREATE INDEX idx_users_email ON users(email);

-- Result: CREATE INDEX
-- Execution time: ~1.222 seconds

-- Day 05: Measuring the write cost of an index
-- Question: does an index actually slow down INSERT?

-- Baseline: no index on email
DROP INDEX idx_users_email;

INSERT INTO users (username, email, password)
SELECT
    'benchuser' || i,
    'benchuser' || i || '@example.com',
    'password123'
FROM generate_series(1, 50000) AS i;
-- Result: ~232 ms

-- Recreate index, then repeat the same insert
CREATE INDEX idx_users_email ON users(email);

DELETE FROM users WHERE username LIKE 'benchuser%';

INSERT INTO users (username, email, password)
SELECT
    'benchuser' || i,
    'benchuser' || i || '@example.com',
    'password123'
FROM generate_series(1, 50000) AS i;
-- Result: ~770 ms (roughly 3.3x slower with the index present)

-- Conclusion: indexes speed up reads but add write overhead on every
-- INSERT/UPDATE/DELETE. Not every column should be indexed.