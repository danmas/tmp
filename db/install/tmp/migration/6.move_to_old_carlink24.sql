--
-- Миграция таблицы car_mark из "carlink24" в 
--

CREATE SCHEMA old_carlink24;


-- --------------------------------------------------------
ALTER TABLE "car_mark" SET SCHEMA old_carlink24;
ALTER TABLE "car_model" SET SCHEMA old_carlink24;
ALTER TABLE "car_serie" SET SCHEMA old_carlink24;
ALTER TABLE "car_modification" SET SCHEMA old_carlink24;

