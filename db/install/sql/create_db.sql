drop database if exists :db_name;
drop owned by :db_user cascade;
drop role if exists :db_user;

create user :db_user with encrypted password :db_pass;
create database :db_name with owner :db_user;
alter user :db_user set search_path = carl_comm,carl_auct,carl_auth,carl_prof,public;