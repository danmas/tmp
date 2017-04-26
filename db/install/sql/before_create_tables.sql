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


drop type if exists en_user_state;
create type en_user_state as enum ('UNKNOWN', 'CONFIRMED_SINGLE', 'CONFIRMED');	


drop type if exists en_verif_code_type;
create type en_verif_code_type as enum ('E_MAIL', 'PHONE');	

