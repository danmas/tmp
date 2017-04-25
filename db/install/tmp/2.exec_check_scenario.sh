
#-- создание тестовых функций
psql -U carl -d carlinkng -f ./sql/unit_tests/create_unit_tests.sql

#-- проверка выполнения сценария  ./sql/play_scenario.sql
psql -U carl -d carlinkng -f ./sql/unit_tests/check_scenario.sql



