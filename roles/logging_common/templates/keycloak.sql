-- Create a user with a password
CREATE USER keycloak WITH PASSWORD 'keycloak';
-- Create a database
CREATE DATABASE keycloak WITH OWNER = keycloak;
