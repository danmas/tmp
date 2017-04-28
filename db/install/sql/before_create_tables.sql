-- Create schemas section -------------------------------------------------

CREATE SCHEMA "carl_auth";
CREATE SCHEMA "carl_prof";
CREATE SCHEMA "carl_comm";
CREATE SCHEMA "carl_auct";


drop type if exists t_prof_list cascade;
create type t_prof_list as (
  prof_id   int,
  user_name varchar, 
  is_active varchar(1),
  corp_name varchar, 
  prof_type varchar
);

/*
drop type if exists en_user_status;
create type en_user_status as enum ('UNKNOWN', 'CONFIRMED_SINGLE', 'CONFIRMED', 'ADMIN');	
-- UNKNOWN          - новый незарегистрированный пользователь  
-- CONFIRMED_SINGLE - если подтвержден только мэйл
-- CONFIRMED        - если подтвержден телефон
-- ADMIN            - администратор системы  
*/

--drop type if exists en_verify_code_type;
--create type en_verify_code_type as enum ('E_MAIL', 'PHONE');	

