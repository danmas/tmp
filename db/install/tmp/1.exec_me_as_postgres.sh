
psql -U postgres -f ./sql/create_db.sql

psql -U carl -d carlinkng -f ./sql/create_tables.sql

psql -U carl -d carlinkng -f ./sql/api_procedures.sql
psql -U carl -d carlinkng -f ./sql/play_scenario.sql


# создание тестовой таблицы пользователей (users)
# create_insert_car_mark.sql - миграция car_mark из старой системы
# create_insert_car_model.sql - миграция car_model из старой системы
# create_insert_car_serie.sql 
# create_insert_car_modification.sqlмиграция  car_modification
# move_to_old_carlink24.sql Создаем схему old_carlink24 и перемещаем туда объекты миграции

