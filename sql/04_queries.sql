-- Day 02-03: Basic exploratory queries on the users table

-- View all users
SELECT * FROM users;

-- Find a specific user by email
SELECT * FROM users WHERE email = 'user50000@example.com';

-- Count total rows in the table
SELECT COUNT(*) FROM users;