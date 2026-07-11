-- Day 01: Creating the users table
-- Learning goal: Understand SERIAL vs AUTO_INCREMENT, and basic column types

CREATE TABLE users (
    id           SERIAL PRIMARY KEY,
    username     VARCHAR(100),
    email        VARCHAR(150),
    password     VARCHAR(255),
    profile_pic  VARCHAR(255)
);