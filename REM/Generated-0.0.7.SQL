/*
Created: 18.04.2017
Modified: 24.04.2017
Model: Carlink-db-0.1
Database: PostgreSQL 9.5
*/


-- Drop relationships section -------------------------------------------------

ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "fk_verify_code_users"
;
ALTER TABLE "invitation" DROP CONSTRAINT IF EXISTS "fk_invitation_trade_unit"
;
ALTER TABLE "auction_bid" DROP CONSTRAINT IF EXISTS "fk_bid_profile"
;
ALTER TABLE "auction_bid" DROP CONSTRAINT IF EXISTS "fk_bid_auction"
;
ALTER TABLE "profile" DROP CONSTRAINT IF EXISTS "fk_profile_trade_unit"
;
ALTER TABLE "profile" DROP CONSTRAINT IF EXISTS "fk_profile"
;
ALTER TABLE "trade_unit" DROP CONSTRAINT IF EXISTS "fk_trade_unit_0"
;
ALTER TABLE "trade_unit" DROP CONSTRAINT IF EXISTS "fk_trade_unit_individual"
;
ALTER TABLE "trade_unit" DROP CONSTRAINT IF EXISTS "fk_trade_unit"
;
ALTER TABLE "auction" DROP CONSTRAINT IF EXISTS "fk_auction"
;




-- Drop keys for tables section -------------------------------------------------

ALTER TABLE "verify_code" DROP CONSTRAINT IF EXISTS "Key3"
;
ALTER TABLE "invitation" DROP CONSTRAINT IF EXISTS "pk_invitation"
;
ALTER TABLE "users" DROP CONSTRAINT IF EXISTS "pk_users"
;
ALTER TABLE "trade_unit" DROP CONSTRAINT IF EXISTS "pk_trade_unit"
;
ALTER TABLE "profile" DROP CONSTRAINT IF EXISTS "pk_profile"
;
ALTER TABLE "lot" DROP CONSTRAINT IF EXISTS "pk_lot"
;
ALTER TABLE "individual" DROP CONSTRAINT IF EXISTS "pk_individual"
;
ALTER TABLE "corporate" DROP CONSTRAINT IF EXISTS "pk_corporate"
;
ALTER TABLE "corporate" DROP CONSTRAINT IF EXISTS "pk_corporate_0"
;
ALTER TABLE "auction_bid" DROP CONSTRAINT IF EXISTS "Key1"
;
ALTER TABLE "auction_bid" DROP CONSTRAINT IF EXISTS "pk_bid"
;
ALTER TABLE "auction" DROP CONSTRAINT IF EXISTS "pk_auction"
;


-- Drop indexes section -------------------------------------------------

DROP INDEX IF EXISTS "IX_Relationship5"
;
DROP INDEX IF EXISTS "IX_Relationship1"
;
DROP INDEX IF EXISTS "idx_trade_unit"
;
DROP INDEX IF EXISTS "idx_trade_unit_0"
;
DROP INDEX IF EXISTS "idx_trade_unit_1"
;
DROP INDEX IF EXISTS "idx_profile"
;
DROP INDEX IF EXISTS "idx_profile_0"
;
DROP INDEX IF EXISTS "idx_bid"
;
DROP INDEX IF EXISTS "idx_bid_0"
;
DROP INDEX IF EXISTS "idx_auction"
;

-- Drop tables section ---------------------------------------------------

DROP TABLE IF EXISTS "verify_code" CASCADE
;
DROP TABLE IF EXISTS "invitation" CASCADE
;
DROP TABLE IF EXISTS "users" CASCADE
;
DROP TABLE IF EXISTS "trade_unit" CASCADE
;
DROP TABLE IF EXISTS "profile" CASCADE
;
DROP TABLE IF EXISTS "lot" CASCADE
;
DROP TABLE IF EXISTS "individual" CASCADE
;
DROP TABLE IF EXISTS "corporate" CASCADE
;
DROP TABLE IF EXISTS "auction_bid" CASCADE
;
DROP TABLE IF EXISTS "auction" CASCADE
;

-- Drop user data types section --------------------------------------------------- 

DROP TYPE IF EXISTS "public"."t_prof_list"
;

-- Create user data types section -------------------------------------------------

CREATE TYPE "public"."t_prof_list" AS
 ( "prof_id" int4, "user_name" varchar, "is_active" varchar, "corp_name" varchar, "prof_type" varchar )
;

-- Create tables section -------------------------------------------------

-- Table auction

CREATE TABLE "auction"(
 "id" Serial NOT NULL,
 "lot_id" Integer
)
;
ALTER TABLE "auction" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "auction" ALTER COLUMN "lot_id" SET STORAGE PLAIN
;

-- Create indexes for table auction

CREATE INDEX "idx_auction" ON "auction" ("lot_id")
;

-- Add keys for table auction

ALTER TABLE "auction" ADD CONSTRAINT "pk_auction" PRIMARY KEY ("id")
;

-- Table auction_bid

CREATE TABLE "auction_bid"(
 "id" Serial NOT NULL,
 "summ" Numeric(10,2) NOT NULL,
 "profile_id" Integer NOT NULL,
 "auction_id" Integer
)
;
ALTER TABLE "auction_bid" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "auction_bid" ALTER COLUMN "summ" SET STORAGE MAIN
;
ALTER TABLE "auction_bid" ALTER COLUMN "profile_id" SET STORAGE PLAIN
;
ALTER TABLE "auction_bid" ALTER COLUMN "auction_id" SET STORAGE PLAIN
;

COMMENT ON TABLE "auction_bid" IS 'Ставки'
;
COMMENT ON COLUMN "auction_bid"."summ" IS 'Величина ставки'
;

-- Create indexes for table auction_bid

CREATE INDEX "idx_bid" ON "auction_bid" ("profile_id")
;

CREATE INDEX "idx_bid_0" ON "auction_bid" ("auction_id")
;

-- Add keys for table auction_bid

ALTER TABLE "auction_bid" ADD CONSTRAINT "Key1" PRIMARY KEY ("id")
;

ALTER TABLE "auction_bid" ADD CONSTRAINT "pk_bid" UNIQUE ("id")
;

-- Table corporate

CREATE TABLE "corporate"(
 "id" Serial NOT NULL,
 "name" Character varying(255),
 "inn" Varchar,
 "ogrn" Varchar,
 "kpp" Varchar
)
;
ALTER TABLE "corporate" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "corporate" ALTER COLUMN "name" SET STORAGE EXTENDED
;
ALTER TABLE "corporate" ALTER COLUMN "inn" SET STORAGE EXTENDED
;
ALTER TABLE "corporate" ALTER COLUMN "ogrn" SET STORAGE EXTENDED
;
ALTER TABLE "corporate" ALTER COLUMN "kpp" SET STORAGE EXTENDED
;

COMMENT ON TABLE "corporate" IS 'Юр лицо'
;

-- Add keys for table corporate

ALTER TABLE "corporate" ADD CONSTRAINT "pk_corporate" PRIMARY KEY ("id")
;

ALTER TABLE "corporate" ADD CONSTRAINT "pk_corporate_0" UNIQUE ("inn")
;

-- Table individual

CREATE TABLE "individual"(
 "id" Serial NOT NULL,
 "inn" Varchar,
 "Attribute1" Serial
)
;
ALTER TABLE "individual" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "individual" ALTER COLUMN "inn" SET STORAGE EXTENDED
;

-- Add keys for table individual

ALTER TABLE "individual" ADD CONSTRAINT "pk_individual" PRIMARY KEY ("id")
;

-- Table lot

CREATE TABLE "lot"(
 "id" Serial NOT NULL,
 "name" Character varying(100)
)
;
ALTER TABLE "lot" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "lot" ALTER COLUMN "name" SET STORAGE EXTENDED
;

-- Add keys for table lot

ALTER TABLE "lot" ADD CONSTRAINT "pk_lot" PRIMARY KEY ("id")
;

-- Table profile

CREATE TABLE "profile"(
 "id" Serial NOT NULL,
 "name" Varchar,
 "user_id" Integer NOT NULL,
 "trade_unit_id" Integer,
 "is_active" Character varying(1) DEFAULT 'N'::character varying
)
;
ALTER TABLE "profile" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "profile" ALTER COLUMN "name" SET STORAGE EXTENDED
;
ALTER TABLE "profile" ALTER COLUMN "user_id" SET STORAGE PLAIN
;
ALTER TABLE "profile" ALTER COLUMN "trade_unit_id" SET STORAGE PLAIN
;
ALTER TABLE "profile" ALTER COLUMN "is_active" SET STORAGE EXTENDED
;
COMMENT ON COLUMN "profile"."id" IS 'Идентификатор'
;
COMMENT ON COLUMN "profile"."is_active" IS 'Признак того включен или выключен данный профиль.'
;

-- Create indexes for table profile

CREATE INDEX "idx_profile" ON "profile" ("user_id")
;

CREATE INDEX "idx_profile_0" ON "profile" ("trade_unit_id")
;

-- Add keys for table profile

ALTER TABLE "profile" ADD CONSTRAINT "pk_profile" PRIMARY KEY ("id")
;

-- Table trade_unit

CREATE TABLE "trade_unit"(
 "id" Serial NOT NULL,
 "corporate_id" Integer,
 "individual_id" Integer,
 "balance_summ" Numeric(10,2),
 "is_active" Character varying(1) DEFAULT 'N'::character varying,
 "admin_user_id" Integer
)
;
ALTER TABLE "trade_unit" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "trade_unit" ALTER COLUMN "corporate_id" SET STORAGE PLAIN
;
ALTER TABLE "trade_unit" ALTER COLUMN "individual_id" SET STORAGE PLAIN
;
ALTER TABLE "trade_unit" ALTER COLUMN "balance_summ" SET STORAGE MAIN
;
ALTER TABLE "trade_unit" ALTER COLUMN "is_active" SET STORAGE EXTENDED
;
ALTER TABLE "trade_unit" ALTER COLUMN "admin_user_id" SET STORAGE PLAIN
;

COMMENT ON TABLE "trade_unit" IS 'Обобщенная сущность для юр и физ лиц
Нужно ввести правило что (corporate_id != null and individual_id == null) or (corporate_id == null and individual_id != null)

'
;
COMMENT ON COLUMN "trade_unit"."is_active" IS 'Признак того включен или выключен данный профиль.'
;

-- Create indexes for table trade_unit

CREATE INDEX "idx_trade_unit" ON "trade_unit" ("corporate_id")
;

CREATE INDEX "idx_trade_unit_0" ON "trade_unit" ("individual_id")
;

CREATE INDEX "idx_trade_unit_1" ON "trade_unit" ("admin_user_id")
;

-- Add keys for table trade_unit

ALTER TABLE "trade_unit" ADD CONSTRAINT "pk_trade_unit" PRIMARY KEY ("id")
;

-- Table users

CREATE TABLE "users"(
 "id" Serial NOT NULL,
 "first_name" Character varying(255),
 "middle_name" Character varying(255),
 "last_name" Character varying(255),
 "email" Varchar,
 "phone" Varchar,
 "status" Character varying(50) DEFAULT 'UNKNOWN'::character varying NOT NULL,
 "password_hash" Character varying(255) DEFAULT '$2y$10$1qaz2wsx3edc4rfv5tgb6uPqXjlGqJ9xUzpN5InbzS49xXsE.T9E2' NOT NULL,
 "verify_code_id" Integer,
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
ALTER TABLE "users" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "users" ALTER COLUMN "first_name" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "middle_name" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "last_name" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "email" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "phone" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "status" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "password_hash" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "verify_code_id" SET STORAGE PLAIN
;
ALTER TABLE "users" ALTER COLUMN "is_deleted" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "is_blocked" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "bad_pass_count" SET STORAGE PLAIN
;
ALTER TABLE "users" ALTER COLUMN "dt_created" SET STORAGE PLAIN
;
ALTER TABLE "users" ALTER COLUMN "dt_registered" SET STORAGE PLAIN
;
ALTER TABLE "users" ALTER COLUMN "dt_last_login" SET STORAGE PLAIN
;
ALTER TABLE "users" ALTER COLUMN "last_ip" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "last_session_id" SET STORAGE EXTENDED
;
ALTER TABLE "users" ALTER COLUMN "locale" SET STORAGE EXTENDED
;

COMMENT ON TABLE "users" IS 'Таблица пользователей'
;
COMMENT ON COLUMN "users"."first_name" IS 'Имя'
;
COMMENT ON COLUMN "users"."middle_name" IS 'Отчество'
;
COMMENT ON COLUMN "users"."last_name" IS 'Фамилия'
;
COMMENT ON COLUMN "users"."email" IS 'Электронный адрес'
;
COMMENT ON COLUMN "users"."phone" IS 'Мобильный телефон'
;
COMMENT ON COLUMN "users"."status" IS 'Статус UNKNOWN, CONFIRMED_SINGLE, CONFIRMED'
;
COMMENT ON COLUMN "users"."password_hash" IS 'Зашифрованный пароль'
;
COMMENT ON COLUMN "users"."verify_code_id" IS 'Код отправленный по электронной почте'
;
COMMENT ON COLUMN "users"."is_deleted" IS 'Признак того, что пользователь удален Y/N'
;
COMMENT ON COLUMN "users"."is_blocked" IS 'Признак блокировки Y/N'
;
COMMENT ON COLUMN "users"."bad_pass_count" IS 'Количество введенных неверных паролей'
;
COMMENT ON COLUMN "users"."dt_created" IS 'Дата.время создания'
;
COMMENT ON COLUMN "users"."dt_registered" IS 'Дата.время регистрации пользователя'
;
COMMENT ON COLUMN "users"."dt_last_login" IS 'Дата.время последнего успешного входа'
;
COMMENT ON COLUMN "users"."last_ip" IS 'IP последнего входа'
;
COMMENT ON COLUMN "users"."last_session_id" IS 'ID последней сессии'
;
COMMENT ON COLUMN "users"."locale" IS 'Локализация'
;

-- Create indexes for table users

CREATE INDEX "IX_Relationship1" ON "users" ("verify_code_id")
;

-- Add keys for table users

ALTER TABLE "users" ADD CONSTRAINT "pk_users" PRIMARY KEY ("id")
;

-- Table invitation

CREATE TABLE "invitation"(
 "id" Serial NOT NULL,
 "admin_user_id" Integer,
 "email" Varchar,
 "dt_send" Timestamp DEFAULT now() NOT NULL,
 "dt_accept" Timestamp,
 "trade_unit_id" Integer
)
;

COMMENT ON TABLE "invitation" IS 'Приглашение стать представителями отправленные другим пользователя.'
;
COMMENT ON COLUMN "invitation"."admin_user_id" IS 'Лицо отправившее приглашение'
;
COMMENT ON COLUMN "invitation"."email" IS 'Адрес электронной почты на которое выслано приглашение.'
;
COMMENT ON COLUMN "invitation"."dt_send" IS 'Когда отправлено'
;
COMMENT ON COLUMN "invitation"."dt_accept" IS 'Когда принято'
;

-- Create indexes for table invitation

CREATE INDEX "IX_Relationship5" ON "invitation" ("trade_unit_id")
;

-- Add keys for table invitation

ALTER TABLE "invitation" ADD CONSTRAINT "pk_invitation" PRIMARY KEY ("id")
;

-- Table verify_code

CREATE TABLE "verify_code"(
 "id" Serial NOT NULL,
 "type" Varchar,
 "code" Varchar,
 "dt_send" Timestamp DEFAULT current_timestamp,
 "code_received" Varchar,
 "dt_received" Timestamp
)
;

COMMENT ON TABLE "verify_code" IS 'Коды верификации'
;
COMMENT ON COLUMN "verify_code"."type" IS 'Тип кода. Сейчас реализовано: ''E_MAIL'',''PHONE'''
;
COMMENT ON COLUMN "verify_code"."code" IS 'Отправленный пользователю код'
;
COMMENT ON COLUMN "verify_code"."dt_send" IS 'Когда отправлен код.'
;
COMMENT ON COLUMN "verify_code"."code_received" IS 'Последний код полученный от пользователя'
;
COMMENT ON COLUMN "verify_code"."dt_received" IS 'Дата получения от пользователя'
;

-- Add keys for table verify_code

ALTER TABLE "verify_code" ADD CONSTRAINT "Key3" PRIMARY KEY ("id")
;

-- Create relationships section ------------------------------------------------- 

ALTER TABLE "auction" ADD CONSTRAINT "fk_auction" FOREIGN KEY ("lot_id") REFERENCES "lot" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "trade_unit" ADD CONSTRAINT "fk_trade_unit" FOREIGN KEY ("corporate_id") REFERENCES "corporate" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "trade_unit" ADD CONSTRAINT "fk_trade_unit_individual" FOREIGN KEY ("individual_id") REFERENCES "individual" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "trade_unit" ADD CONSTRAINT "fk_trade_unit_0" FOREIGN KEY ("admin_user_id") REFERENCES "users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "profile" ADD CONSTRAINT "fk_profile" FOREIGN KEY ("user_id") REFERENCES "users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "profile" ADD CONSTRAINT "fk_profile_trade_unit" FOREIGN KEY ("trade_unit_id") REFERENCES "trade_unit" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "auction_bid" ADD CONSTRAINT "fk_bid_auction" FOREIGN KEY ("auction_id") REFERENCES "auction" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "auction_bid" ADD CONSTRAINT "fk_bid_profile" FOREIGN KEY ("profile_id") REFERENCES "profile" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "invitation" ADD CONSTRAINT "fk_invitation_trade_unit" FOREIGN KEY ("trade_unit_id") REFERENCES "trade_unit" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
;

ALTER TABLE "users" ADD CONSTRAINT "fk_verify_code_users" FOREIGN KEY ("verify_code_id") REFERENCES "verify_code" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
;


-- Grant permissions section -------------------------------------------------


