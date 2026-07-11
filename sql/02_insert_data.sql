-- Day 03-04: Bulk insert using generate_series
-- Goal: Populate the users table with 100,000 fake rows
-- to simulate a production-scale dataset for performance testing

INSERT INTO users (username, email, password)
SELECT
    'user' || i,
    'user' || i || '@example.com',
    'password123'
FROM generate_series(1, 100000) AS i;

-- Result: INSERT 0 100000
-- Execution time: ~1.182 seconds