/*
Created: 18.04.2017
Modified: 27.04.2017
Model: Carlink-db-0.1
Database: PostgreSQL 9.5
*/

-- Create user data types section -------------------------------------------------

CREATE TYPE "carl_prof"."t_prof_list" AS
 ( "prof_id" int4, "user_name" varchar, "is_active" varchar, "corp_name" varchar, "prof_type" varchar )
;

-- Create tables section -------------------------------------------------

-- Table carl_auct.auction

CREATE TABLE "carl_auct"."auction"(
 "id" Serial NOT NULL,
 "lot_id" Integer
)
;
ALTER TABLE "carl_auct"."auction" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "carl_auct"."auction" ALTER COLUMN "lot_id" SET STORAGE PLAIN
;

-- Create indexes for table carl_auct.auction

CREATE INDEX "idx_auction" ON "carl_auct"."auction" ("lot_id")
;

-- Add keys for table carl_auct.auction

ALTER TABLE "carl_auct"."auction" ADD CONSTRAINT "pk_auction" PRIMARY KEY ("id")
;

-- Table carl_auct.auction_bid

CREATE TABLE "carl_auct"."auction_bid"(
 "id" Serial NOT NULL,
 "summ" Numeric(10,2) NOT NULL,
 "profile_id" Integer NOT NULL,
 "auction_id" Integer
)
;
ALTER TABLE "carl_auct"."auction_bid" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "carl_auct"."auction_bid" ALTER COLUMN "summ" SET STORAGE MAIN
;
ALTER TABLE "carl_auct"."auction_bid" ALTER COLUMN "profile_id" SET STORAGE PLAIN
;
ALTER TABLE "carl_auct"."auction_bid" ALTER COLUMN "auction_id" SET STORAGE PLAIN
;

COMMENT ON TABLE "carl_auct"."auction_bid" IS 'Ставки'
;
COMMENT ON COLUMN "carl_auct"."auction_bid"."summ" IS 'Величина ставки'
;

-- Create indexes for table carl_auct.auction_bid

CREATE INDEX "idx_bid" ON "carl_auct"."auction_bid" ("profile_id")
;

CREATE INDEX "idx_bid_0" ON "carl_auct"."auction_bid" ("auction_id")
;

-- Add keys for table carl_auct.auction_bid

ALTER TABLE "carl_auct"."auction_bid" ADD CONSTRAINT "Key1" PRIMARY KEY ("id")
;

ALTER TABLE "carl_auct"."auction_bid" ADD CONSTRAINT "pk_bid" UNIQUE ("id")
;

-- Table carl_prof.corporate

CREATE TABLE "carl_prof"."corporate"(
 "id" Serial NOT NULL,
 "name" Character varying(255),
 "inn" Varchar,
 "ogrn" Varchar,
 "kpp" Varchar
)
;
ALTER TABLE "carl_prof"."corporate" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "carl_prof"."corporate" ALTER COLUMN "name" SET STORAGE EXTENDED
;
ALTER TABLE "carl_prof"."corporate" ALTER COLUMN "inn" SET STORAGE EXTENDED
;
ALTER TABLE "carl_prof"."corporate" ALTER COLUMN "ogrn" SET STORAGE EXTENDED
;
ALTER TABLE "carl_prof"."corporate" ALTER COLUMN "kpp" SET STORAGE EXTENDED
;

COMMENT ON TABLE "carl_prof"."corporate" IS 'Юр лицо'
;

-- Add keys for table carl_prof.corporate

ALTER TABLE "carl_prof"."corporate" ADD CONSTRAINT "pk_corporate" PRIMARY KEY ("id")
;

ALTER TABLE "carl_prof"."corporate" ADD CONSTRAINT "pk_corporate_0" UNIQUE ("inn")
;

-- Table carl_prof.individual

CREATE TABLE "carl_prof"."individual"(
 "id" Serial NOT NULL,
 "inn" Varchar,
 "Attribute1" Serial
)
;
ALTER TABLE "carl_prof"."individual" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "carl_prof"."individual" ALTER COLUMN "inn" SET STORAGE EXTENDED
;

-- Add keys for table carl_prof.individual

ALTER TABLE "carl_prof"."individual" ADD CONSTRAINT "pk_individual" PRIMARY KEY ("id")
;

-- Table carl_auct.lot

CREATE TABLE "carl_auct"."lot"(
 "id" Serial NOT NULL,
 "name" Character varying(100)
)
;
ALTER TABLE "carl_auct"."lot" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "carl_auct"."lot" ALTER COLUMN "name" SET STORAGE EXTENDED
;

-- Add keys for table carl_auct.lot

ALTER TABLE "carl_auct"."lot" ADD CONSTRAINT "pk_lot" PRIMARY KEY ("id")
;

-- Table carl_prof.profile

CREATE TABLE "carl_prof"."profile"(
 "id" Serial NOT NULL,
 "name" Varchar,
 "user_id" Integer NOT NULL,
 "trade_unit_id" Integer,
 "is_active" Character varying(1) DEFAULT 'N'::character varying
)
;
ALTER TABLE "carl_prof"."profile" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "carl_prof"."profile" ALTER COLUMN "name" SET STORAGE EXTENDED
;
ALTER TABLE "carl_prof"."profile" ALTER COLUMN "user_id" SET STORAGE PLAIN
;
ALTER TABLE "carl_prof"."profile" ALTER COLUMN "trade_unit_id" SET STORAGE PLAIN
;
ALTER TABLE "carl_prof"."profile" ALTER COLUMN "is_active" SET STORAGE EXTENDED
;
COMMENT ON COLUMN "carl_prof"."profile"."id" IS 'Идентификатор'
;
COMMENT ON COLUMN "carl_prof"."profile"."is_active" IS 'Признак того включен или выключен данный профиль.'
;

-- Create indexes for table carl_prof.profile

CREATE INDEX "idx_profile" ON "carl_prof"."profile" ("user_id")
;

CREATE INDEX "idx_profile_0" ON "carl_prof"."profile" ("trade_unit_id")
;

-- Add keys for table carl_prof.profile

ALTER TABLE "carl_prof"."profile" ADD CONSTRAINT "pk_profile" PRIMARY KEY ("id")
;

-- Table carl_prof.trade_unit

CREATE TABLE "carl_prof"."trade_unit"(
 "id" Serial NOT NULL,
 "corporate_id" Integer,
 "individual_id" Integer,
 "balance_summ" Numeric(10,2),
 "is_active" Character varying(1) DEFAULT 'N'::character varying,
 "admin_user_id" Integer
)
;
ALTER TABLE "carl_prof"."trade_unit" ALTER COLUMN "id" SET STORAGE PLAIN
;
ALTER TABLE "carl_prof"."trade_unit" ALTER COLUMN "corporate_id" SET STORAGE PLAIN
;
ALTER TABLE "carl_prof"."trade_unit" ALTER COLUMN "individual_id" SET STORAGE PLAIN
;
ALTER TABLE "carl_prof"."trade_unit" ALTER COLUMN "balance_summ" SET STORAGE MAIN
;
ALTER TABLE "carl_prof"."trade_unit" ALTER COLUMN "is_active" SET STORAGE EXTENDED
;
ALTER TABLE "carl_prof"."trade_unit" ALTER COLUMN "admin_user_id" SET STORAGE PLAIN
;

COMMENT ON TABLE "carl_prof"."trade_unit" IS 'Обобщенная сущность для юр и физ лиц
Нужно ввести правило что (corporate_id != null and individual_id == null) or (corporate_id == null and individual_id != null)

'
;
COMMENT ON COLUMN "carl_prof"."trade_unit"."is_active" IS 'Признак того включен или выключен данный профиль.'
;

-- Create indexes for table carl_prof.trade_unit

CREATE INDEX "idx_trade_unit" ON "carl_prof"."trade_unit" ("corporate_id")
;

CREATE INDEX "idx_trade_unit_0" ON "carl_prof"."trade_unit" ("individual_id")
;

CREATE INDEX "idx_trade_unit_1" ON "carl_prof"."trade_unit" ("admin_user_id")
;

-- Add keys for table carl_prof.trade_unit

ALTER TABLE "carl_prof"."trade_unit" ADD CONSTRAINT "pk_trade_unit" PRIMARY KEY ("id")
;

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

-- Table carl_prof.invitation

CREATE TABLE "carl_prof"."invitation"(
 "id" Serial NOT NULL,
 "admin_user_id" Integer,
 "email" Varchar,
 "dt_send" Timestamp DEFAULT now() NOT NULL,
 "dt_accept" Timestamp,
 "trade_unit_id" Integer
)
;

COMMENT ON TABLE "carl_prof"."invitation" IS 'Приглашение стать представителями отправленные другим пользователя.'
;
COMMENT ON COLUMN "carl_prof"."invitation"."admin_user_id" IS 'Лицо отправившее приглашение'
;
COMMENT ON COLUMN "carl_prof"."invitation"."email" IS 'Адрес электронной почты на которое выслано приглашение.'
;
COMMENT ON COLUMN "carl_prof"."invitation"."dt_send" IS 'Когда отправлено'
;
COMMENT ON COLUMN "carl_prof"."invitation"."dt_accept" IS 'Когда принято'
;

-- Create indexes for table carl_prof.invitation

CREATE INDEX "IX_Relationship5" ON "carl_prof"."invitation" ("trade_unit_id")
;

-- Add keys for table carl_prof.invitation

ALTER TABLE "carl_prof"."invitation" ADD CONSTRAINT "pk_invitation" PRIMARY KEY ("id")
;

-- Table carl_auth.verify_code

CREATE TABLE "carl_auth"."verify_code"(
 "id" Serial NOT NULL,
 "user_id" Integer,
 "code_type" Varchar,
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
COMMENT ON COLUMN "carl_auth"."verify_code"."code_type" IS 'Тип кода. Сейчас реализовано: ''E_MAIL'',''PHONE'''
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

CREATE UNIQUE INDEX "Index1" ON "carl_auth"."verify_code" ("code_type","user_id")
;

-- Add keys for table carl_auth.verify_code

ALTER TABLE "carl_auth"."verify_code" ADD CONSTRAINT "pk_verify_code" PRIMARY KEY ("id")
;

-- Table carl_comm.message

CREATE TABLE "carl_comm"."message"(
 "code" Varchar NOT NULL,
 "locale" Varchar DEFAULT 'RU' NOT NULL,
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

-- Create relationships section ------------------------------------------------- 

ALTER TABLE "carl_auct"."auction" ADD CONSTRAINT "fk_auction" FOREIGN KEY ("lot_id") REFERENCES "carl_auct"."lot" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_prof"."trade_unit" ADD CONSTRAINT "fk_trade_unit" FOREIGN KEY ("corporate_id") REFERENCES "carl_prof"."corporate" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_prof"."trade_unit" ADD CONSTRAINT "fk_trade_unit_individual" FOREIGN KEY ("individual_id") REFERENCES "carl_prof"."individual" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_prof"."trade_unit" ADD CONSTRAINT "fk_trade_unit_0" FOREIGN KEY ("admin_user_id") REFERENCES "carl_auth"."users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_prof"."profile" ADD CONSTRAINT "fk_profile" FOREIGN KEY ("user_id") REFERENCES "carl_auth"."users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_prof"."profile" ADD CONSTRAINT "fk_profile_trade_unit" FOREIGN KEY ("trade_unit_id") REFERENCES "carl_prof"."trade_unit" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_auct"."auction_bid" ADD CONSTRAINT "fk_bid_auction" FOREIGN KEY ("auction_id") REFERENCES "carl_auct"."auction" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_auct"."auction_bid" ADD CONSTRAINT "fk_bid_profile" FOREIGN KEY ("profile_id") REFERENCES "carl_prof"."profile" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_prof"."invitation" ADD CONSTRAINT "fk_invitation_trade_unit" FOREIGN KEY ("trade_unit_id") REFERENCES "carl_prof"."trade_unit" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
;

ALTER TABLE "carl_auth"."verify_code" ADD CONSTRAINT "fk_verif_code_users" FOREIGN KEY ("user_id") REFERENCES "carl_auth"."users" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
;


-- Grant permissions section -------------------------------------------------


