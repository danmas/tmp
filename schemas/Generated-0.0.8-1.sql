/*
Created: 18.04.2017
Modified: 25.04.2017
Model: Carlink-db-0.1
Database: PostgreSQL 9.5
*/









-- Drop tables section ---------------------------------------------------

DROP TABLE IF EXISTS "carl_comm"."message" CASCADE
;

-- Drop schemas section --------------------------------------------------- 

DROP SCHEMA IF EXISTS "carl_auct" CASCADE
;
DROP SCHEMA IF EXISTS "carl_comm" CASCADE
;
DROP SCHEMA IF EXISTS "carl_prof" CASCADE
;
DROP SCHEMA IF EXISTS "carl_auth" CASCADE
;
DROP SCHEMA IF EXISTS "public" CASCADE
;
DROP SCHEMA IF EXISTS "carl_dev" CASCADE
;

-- Create schemas section -------------------------------------------------

CREATE SCHEMA "carl_dev" AUTHORIZATION "carl"
;

CREATE SCHEMA "public" AUTHORIZATION "postgres"
;

COMMENT ON SCHEMA "public" IS 'standard public schema'
;

CREATE SCHEMA "carl_auth"
;

CREATE SCHEMA "carl_prof"
;

CREATE SCHEMA "carl_comm"
;

CREATE SCHEMA "carl_auct"
;

-- Create tables section -------------------------------------------------

-- Table carl_comm.message

CREATE TABLE "carl_comm"."message"(
 "code" Varchar NOT NULL,
 "locale" Varchar DEFAULT RU NOT NULL,
 "text" Varchar NOT NULL
)
;

COMMENT ON TABLE "carl_comm"."message" IS 'Сообщения системы'
;
COMMENT ON COLUMN "carl_comm"."message"."code" IS 'Код сообщения '
;
COMMENT ON COLUMN "carl_comm"."message"."locale" IS 'Локализация'
;
COMMENT ON COLUMN "carl_comm"."message"."text" IS 'Сообщение'
;


-- Grant permissions section -------------------------------------------------


