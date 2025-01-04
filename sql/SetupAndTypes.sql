DROP SCHEMA IF EXISTS biblioteca CASCADE;
CREATE SCHEMA biblioteca;

SET search_path TO biblioteca;

-- tipi di utenti possibili 
CREATE type TIPO_UTENTE AS ENUM ('lettore', 'bibliotecario');

-- tipi di lettori 
CREATE TYPE TIPO_LETTORE AS ENUM ('base', 'premium');
CREATE EXTENSION IF NOT EXISTS pgcrypto;
