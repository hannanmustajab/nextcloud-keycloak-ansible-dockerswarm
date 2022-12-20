-- Create a user with a password
CREATE USER nextcloud WITH PASSWORD 'nextcloud';
-- Create a database
CREATE DATABASE nextcloud WITH OWNER = nextcloud;
