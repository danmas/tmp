drop database if exists :db_name;
drop owned by :db_user cascade;
drop role if exists :db_user;
