/*
Created: 18.04.2017
Modified: 25.04.2017
Model: Carlink-db-0.1
Database: PostgreSQL 9.5
*/

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

-- Table carl_auth.users

CREATE TABLE "carl_auth"."users"(
 "id" Serial NOT NULL,
 "first_name" Character varying(255),
 "middle_name" Character varying(255),
 "last_name" Character varying(255),
 "email" Varchar,
 "phone" Varchar,
 "status" Character varying(50) DEFAULT 'UNKNOWN'::character varying NOT NULL,
 "password_hash" Character varying(255) DEFAULT '$2y$10$1qaz2wsx3edc4rfv5tgb6uPqXjlGqJ9xUzpN5InbzS49xXsE.T9E2' NOT NULL,
 "is_deleted" Character varying(1) DEFAULT 'N'::character varying NOT NULL,
 "is_blocked" Character varying(1) DEFAULT 'N'::character varying NOT NULL,
 "bad_pass_count" Integer DEFAULT 0,
 "dt_created" Timestamp DEFAULT now() NOT NULL,
 "dt_registered" Timestamp,
 "dt_last_login" Timestamp,
 "last_ip" Varchar,
 "last_session_id" Varchar,
 "locale" Varchar
)
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "first_name" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "middle_name" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "last_name" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "email" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "phone" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "status" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "password_hash" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "is_deleted" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "is_blocked" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "bad_pass_count" SET STORAGE PLAIN
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "dt_created" SET STORAGE PLAIN
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "dt_registered" SET STORAGE PLAIN
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "dt_last_login" SET STORAGE PLAIN
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "last_ip" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "last_session_id" SET STORAGE EXTENDED
;
ALTER TABLE "carl_auth"."users" ALTER COLUMN "locale" SET STORAGE EXTENDED
;

COMMENT ON TABLE "carl_auth"."users" IS 'Таблица пользователей'
;
COMMENT ON COLUMN "carl_auth"."users"."first_name" IS 'Имя'
;
COMMENT ON COLUMN "carl_auth"."users"."middle_name" IS 'Отчество'
;
COMMENT ON COLUMN "carl_auth"."users"."last_name" IS 'Фамилия'
;
COMMENT ON COLUMN "carl_auth"."users"."email" IS 'Электронный адрес'
;
COMMENT ON COLUMN "carl_auth"."users"."phone" IS 'Мобильный телефон'
;
COMMENT ON COLUMN "carl_auth"."users"."status" IS 'Статус UNKNOWN, CONFIRMED_SINGLE, CONFIRMED'
;
COMMENT ON COLUMN "carl_auth"."users"."password_hash" IS 'Зашифрованный пароль'
;
COMMENT ON COLUMN "carl_auth"."users"."is_deleted" IS 'Признак того, что пользователь удален Y/N'
;
COMMENT ON COLUMN "carl_auth"."users"."is_blocked" IS 'Признак блокировки Y/N'
;
COMMENT ON COLUMN "carl_auth"."users"."bad_pass_count" IS 'Количество введенных неверных паролей'
;
COMMENT ON COLUMN "carl_auth"."users"."dt_created" IS 'Дата.время создания'
;
COMMENT ON COLUMN "carl_auth"."users"."dt_registered" IS 'Дата.время регистрации пользователя'
;
COMMENT ON COLUMN "carl_auth"."users"."dt_last_login" IS 'Дата.время последнего успешного входа'
;
COMMENT ON COLUMN "carl_auth"."users"."last_ip" IS 'IP последнего входа'
;
COMMENT ON COLUMN "carl_auth"."users"."last_session_id" IS 'ID последней сессии'
;
COMMENT ON COLUMN "carl_auth"."users"."locale" IS 'Локализация'
;

-- Add keys for table carl_auth.users

ALTER TABLE "carl_auth"."users" ADD CONSTRAINT "pk_users" PRIMARY KEY ("id")
;

-- Table carl_auth.verify_code

CREATE TABLE "carl_auth"."verify_code"(
 "id" Serial NOT NULL,
 "user_id" Integer,
 "type" Varchar
        CONSTRAINT "CheckType" CHECK (type in ('E_MAIL','PHONE')),
 "code" Varchar,
 "dt_send" Timestamp DEFAULT current_timestamp,
 "code_received" Varchar,
 "dt_received" Timestamp
)
;

COMMENT ON TABLE "carl_auth"."verify_code" IS 'Коды верификации'
;
COMMENT ON COLUMN "carl_auth"."verify_code"."user_id" IS 'id пользователя'
;
COMMENT ON COLUMN "carl_auth"."verify_code"."type" IS 'Тип кода. Сейчас реализовано: ''E_MAIL'',''PHONE'''
;
COMMENT ON COLUMN "carl_auth"."verify_code"."code" IS 'Отправленный пользователю код'
;
COMMENT ON COLUMN "carl_auth"."verify_code"."dt_send" IS 'Когда отправлен код.'
;
COMMENT ON COLUMN "carl_auth"."verify_code"."code_received" IS 'Последний код полученный от пользователя'
;
COMMENT ON COLUMN "carl_auth"."verify_code"."dt_received" IS 'Дата получения от пользователя'
;

-- Create indexes for table carl_auth.verify_code

CREATE INDEX "IX_Relationship2" ON "carl_auth"."verify_code" ("user_id")
;

-- Add keys for table carl_auth.verify_code

ALTER TABLE "carl_auth"."verify_code" ADD CONSTRAINT "Key3" PRIMARY KEY ("id")
;

-- Create relationships section ------------------------------------------------- 

ALTER TABLE "carl_auth"."verify_code" ADD CONSTRAINT "fk_verif_code_users" FOREIGN KEY ("user_id") REFERENCES "carl_auth"."users" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
;


-- Grant permissions section -------------------------------------------------


