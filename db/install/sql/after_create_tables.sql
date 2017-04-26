
alter table "carl_auth"."users" alter column status drop default;
alter table "carl_auth"."users" alter column status type en_user_state using status::en_user_state;
alter table "carl_auth"."users" alter column status set default 'UNKNOWN';

alter table "carl_auth"."verify_code" alter column code_type type en_verif_code_type using code_type::en_verif_code_type;

-- 