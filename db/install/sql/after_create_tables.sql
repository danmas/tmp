/*
alter table "carl_auth"."users" alter column status drop default;
alter table "carl_auth"."users" alter column status type en_user_status using status::en_user_status;
alter table "carl_auth"."users" alter column status set default 'UNKNOWN';
*/
--alter table "carl_auth"."verify_code" alter column code_type type en_verify_code_type using code_type::en_verify_code_type;
-- 