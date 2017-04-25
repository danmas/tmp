SET PGCLIENTENCODING=utf-8
chcp 65001
set PGPASSWORD=postgres
psql -f ./sql/0.create_db.sql -d postgres -L log.txt -U postgres -w
set PGPASSWORD=cng@carlink1
psql -f ./sql/1.create_users.sql -d carlinkng -L log.txt -U carl -w
psql -f ./sql/1.insert_users.sql -d carlinkng -L log.txt -U carl -w

psql -f ./sql/3.api_procedures.sql -d carlinkng -L log.txt -U carl -w
psql -f ./sql/3.api_tests.sql -d carlinkng -L log.txt -U carl -w


REM создание тестовой таблицы пользователей (users)
REM create_insert_car_mark.sql - миграция car_mark из старой системы
REM create_insert_car_model.sql - миграция car_model из старой системы
REM create_insert_car_serie.sql 
REM create_insert_car_modification.sqlмиграция  car_modification
REM move_to_old_carlink24.sql Создаем схему old_carlink24 и перемещаем туда объекты миграции

