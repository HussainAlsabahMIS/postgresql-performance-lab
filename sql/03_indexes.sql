-- Day 04: Creating an index on email
-- Goal: Speed up lookups on email (used heavily in WHERE clauses)

CREATE INDEX idx_users_email ON users(email);

-- Result: CREATE INDEX
-- Execution time: ~1.222 seconds