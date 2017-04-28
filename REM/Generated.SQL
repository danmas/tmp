/*
Created: 18.04.2017
Modified: 28.04.2017
Model: Carlink-db-0.1
Database: PostgreSQL 9.5
*/

-- Create user data types section -------------------------------------------------

CREATE TYPE "carl_prof"."t_prof_list" AS
 ( "prof_id" int4, "user_name" varchar, "is_active" varchar, "corp_name" varchar, "prof_type" varchar )
;

CREATE TYPE "en_role" AS ENUM
 ( 'subscriber','buyer','seller' )
;

COMMENT ON TYPE "en_role" IS 'Роли торговых профилей'
;

CREATE TYPE "en_user_state" AS ENUM
 ( 'UNKNOWN', 'CONFIRMED_SINGLE', 'CONFIRMED', 'ADMIN' )
;

COMMENT ON TYPE "en_user_state" IS 'UNKNOWN          - новый незарегистрированный пользователь , CONFIRMED_SINGLE - если подтвержден только мэйл, CONFIRMED        - если подтвержден телефон
, ADMIN            - администратор системы  
'
;

CREATE TYPE "en_verify_code_type" AS ENUM
 ( 'E_MAIL', 'PHONE' )
;

COMMENT ON TYPE "en_verify_code_type" IS 'Типы кодов подтверждения'
;

-- Create relationships section ------------------------------------------------- 

ALTER TABLE "carl_auct"."auction" ADD CONSTRAINT "fk_auction" FOREIGN KEY ("lot_id") REFERENCES "carl_auct"."lot" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_prof"."trade_unit" ADD CONSTRAINT "fk_trade_unit" FOREIGN KEY ("corporate_id") REFERENCES "carl_prof"."corporate" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_prof"."trade_unit" ADD CONSTRAINT "fk_trade_unit_individual" FOREIGN KEY ("individual_id") REFERENCES "carl_prof"."individual" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
;

ALTER TABLE "carl_prof"."trade_unit" ADD CONSTRAINT "fk_trade_unit_0" FOREIGN KEY ("owner_user_id") REFERENCES "carl_auth"."users" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
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


