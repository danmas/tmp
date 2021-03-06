--
-- Миграция таблицы car_mark из "carlink24" в 
--

-- --------------------------------------------------------

--
-- Структура таблицы "car_mark"
--

DROP TABLE IF EXISTS "car_mark" ;
CREATE TABLE "car_mark" (
  "id_car_mark" serial  primary key,
  "name" varchar NOT NULL check (length(name) <= 250 ),
  "id_object_type" int NOT NULL,
  "name_rus" varchar DEFAULT NULL check (length(name_rus) <= 250 ),
  "is_popular" varchar(1) DEFAULT NULL,
  "date_create" timestamp DEFAULT NULL,
  "date_update" timestamp DEFAULT NULL,
  "int_is_popular" int DEFAULT NULL,
  "int_date_create" int DEFAULT NULL,
  "int_date_update" int DEFAULT NULL
); 

--
-- Дамп данных таблицы "car_mark"
--

INSERT INTO "car_mark" ("id_car_mark", "name", "int_date_create", "int_date_update", "id_object_type", "name_rus", "int_is_popular") VALUES
(1, 'AC', 1398977406, 1463169149, 1, 'АЦ', NULL),
(2, 'Acura', 1398977406, 1463169163, 1, 'Акура', NULL),
(3, 'Alfa Romeo', 1398977406, 1463169172, 1, 'Альфа Ромео', NULL),
(4, 'Alpine', 1398977406, 1463169242, 1, 'Альпине', NULL),
(6, 'Ariel', 1398977406, 1463169243, 1, 'Ариель', NULL),
(7, 'Aro', 1398977406, 1463169244, 1, 'Аро', NULL),
(8, 'Asia', 1398977406, 1463169245, 1, 'Азия', NULL),
(9, 'Aston Martin', 1398977406, 1463169245, 1, 'Астон Мартин', NULL),
(10, 'Audi', 1398977406, 1463169247, 1, 'Ауди', 1),
(11, 'Austin', 1398977406, 1463169248, 1, 'Аустин', NULL),
(14, 'Beijing', 1398977406, 1463169249, 1, 'Бьюджинг', NULL),
(15, 'Bentley', 1398977406, 1463169250, 1, 'Бентли', NULL),
(18, 'BMW', 1398977406, 1463169251, 1, 'БМВ', 1),
(21, 'Brilliance', 1398977406, 1463169252, 1, 'Бриллианс', NULL),
(22, 'Bristol', 1398977406, 1463169252, 1, 'Бристол', NULL),
(24, 'Bugatti', 1398977406, 1463169253, 1, 'Бугатти', NULL),
(25, 'Buick', 1398977406, 1463169254, 1, 'Бьюик', NULL),
(26, 'BYD', 1398977406, 1463169255, 1, 'БИД', NULL),
(28, 'Cadillac', 1398977406, 1463169256, 1, 'Кадилак', NULL),
(29, 'Callaway', 1398977406, 1463169256, 1, 'Каллавэй', NULL),
(30, 'Carbodies', 1398977406, 1463169257, 1, 'Карбодис', NULL),
(31, 'Caterham', 1398977406, 1463169258, 1, 'Катерхам', NULL),
(32, 'Changan', 1398977406, 1463169259, 1, 'Чанган', NULL),
(33, 'ChangFeng', 1398977406, 1463169260, 1, 'ЧангФэнг', NULL),
(34, 'Chery', 1398977406, 1463169261, 1, 'Чери', 1),
(35, 'Chevrolet', 1398977406, 1463169262, 1, 'Шевроле', 1),
(36, 'Chrysler', 1398977406, 1463169263, 1, 'Крайслер', 1),
(37, 'Citroen', 1398977406, 1463169264, 1, 'Ситроен', 1),
(38, 'Cizeta', 1398977406, 1463169265, 1, 'Чизета', NULL),
(39, 'Coggiola', 1398977406, 1463169266, 1, 'Коджиола', NULL),
(40, 'Dacia', 1398977406, 1463169267, 1, 'Дачия', NULL),
(41, 'Dadi', 1398977406, 1463169268, 1, 'Дади', NULL),
(42, 'Daewoo', 1398977406, 1463169269, 1, 'Дэу', 1),
(44, 'Daihatsu', 1398977406, 1463169269, 1, 'Дайхатсу', NULL),
(45, 'Daimler', 1398977406, 1463169270, 1, 'Даймлер', NULL),
(46, 'Dallas', 1398977406, 1463169271, 1, 'Даллас', NULL),
(47, 'Datsun', 1398977406, 1463169272, 1, 'Датсун', NULL),
(48, 'De Tomaso', 1398977406, 1463169273, 1, 'Де Томасо', NULL),
(49, 'DeLorean', 1398977406, 1463169274, 1, 'ДеЛориан', NULL),
(50, 'Derways', 1398977406, 1463169275, 1, 'Дарвэйс', NULL),
(51, 'Dodge', 1398977406, 1463169275, 1, 'Додж', 1),
(52, 'DongFeng', 1398977406, 1463169276, 1, 'ДонгФенг', NULL),
(53, 'Doninvest', 1398977406, 1463169277, 1, 'Донинвест', NULL),
(56, 'Eagle', 1398977406, 1463169302, 1, 'Игл', NULL),
(59, 'FAW', 1398977406, 1463169303, 1, 'ФАВ', NULL),
(60, 'Ferrari', 1398977406, 1463169303, 1, 'Феррари', NULL),
(61, 'Fiat', 1398977406, 1463169305, 1, 'Фиат', 1),
(62, 'Fisker', 1398977406, 1463169306, 1, 'Фискер', NULL),
(63, 'Ford', 1398977406, 1463169307, 1, 'Форд', 1),
(64, 'Foton', 1398977406, 1463169308, 1, 'Фотон', NULL),
(65, 'FSO', 1398977406, 1463169308, 1, 'ФСО', NULL),
(66, 'Fuqi', 1398977406, 1463169310, 1, 'Фуки', NULL),
(67, 'Geely', 1398977406, 1463169311, 1, 'Джили', 1),
(68, 'Geo', 1398977406, 1463169312, 1, 'Гео', NULL),
(69, 'GMC', 1398977406, 1463169313, 1, 'Джи Эм Си', NULL),
(71, 'Great Wall', 1398977406, 1463169314, 1, 'Грейт Волл', 1),
(72, 'Hafei', 1398977406, 1463169314, 1, 'Хафей', NULL),
(73, 'Haima', 1398977406, 1463169315, 1, 'Хайма', NULL),
(74, 'Hindustan', 1398977406, 1463169316, 1, 'Хиндустан', NULL),
(75, 'Holden', 1398977406, 1463169317, 1, 'Холден', NULL),
(76, 'Honda', 1398977406, 1463169318, 1, 'Хонда', 1),
(77, 'HuangHai', 1398977406, 1463169319, 1, 'ХуангХай', NULL),
(78, 'Hummer', 1398977406, 1463169320, 1, 'Хаммер', NULL),
(79, 'Hyundai', 1398977406, 1463169321, 1, 'Хёндай', 1),
(80, 'Infiniti', 1398977406, 1463169322, 1, 'Инфинити', 1),
(81, 'Innocenti', 1398977406, 1463169323, 1, 'Инноченти', NULL),
(82, 'Invicta', 1398977406, 1463169324, 1, 'Инвикта', NULL),
(83, 'Iran Khodro', 1398977406, 1463169325, 1, 'Иран Ходро', NULL),
(84, 'Isdera', 1398977406, 1463169326, 1, 'Исдера', NULL),
(85, 'Isuzu', 1398977406, 1463169327, 1, 'Исузу', NULL),
(86, 'IVECO', 1398977406, 1463169327, 1, 'ИВЕКО', NULL),
(87, 'JAC', 1398977406, 1463169328, 1, 'Джак', NULL),
(88, 'Jaguar', 1398977406, 1463169329, 1, 'Ягуар', 1),
(89, 'Jeep', 1398977406, 1463169330, 1, 'Джип', 1),
(91, 'JMC', 1398977406, 1463169331, 1, 'ДжейЭмСи', NULL),
(92, 'Kia', 1398977406, 1463169332, 1, 'Киа', 1),
(93, 'Koenigsegg', 1398977406, 1463169333, 1, 'Кёнигсегг', NULL),
(95, 'Lamborghini', 1398977406, 1463169334, 1, 'Ламборджини', NULL),
(96, 'Lancia', 1398977406, 1463169335, 1, 'Лянча', NULL),
(97, 'Land Rover', 1398977406, 1463169336, 1, 'Ленд Ровер', 1),
(98, 'Landwind', 1398977406, 1463169337, 1, 'Ландвинд', NULL),
(99, 'Lexus', 1398977406, 1463169338, 1, 'Лексус', 1),
(101, 'Lifan', 1398977406, 1463169339, 1, 'Лифан', 1),
(102, 'Lincoln', 1398977406, 1463169362, 1, 'Линкольн', NULL),
(103, 'Lotus', 1398977406, 1463169363, 1, 'Лотус', NULL),
(104, 'LTI', 1398977406, 1463169364, 1, 'ЛТИ', NULL),
(105, 'Luxgen', 1398977406, 1463169365, 1, 'Люксген', NULL),
(106, 'Mahindra', 1398977406, 1463169365, 1, 'Махиндра', NULL),
(107, 'Marcos', 1398977406, 1463169366, 1, 'Маркос', NULL),
(108, 'Marlin', 1398977406, 1463169367, 1, 'Марлин', NULL),
(109, 'Marussia', 1398977406, 1463169367, 1, 'Маруся', NULL),
(110, 'Maruti', 1398977406, 1463169368, 1, 'Марути', NULL),
(111, 'Maserati', 1398977406, 1463169369, 1, 'Мазерати', NULL),
(112, 'Maybach', 1398977406, 1463169369, 1, 'Майбах', NULL),
(113, 'Mazda', 1398977406, 1463169370, 1, 'Мазда', 1),
(114, 'McLaren', 1398977406, 1463169372, 1, 'Макларен', NULL),
(115, 'Mega', 1398977406, 1463169373, 1, 'Мега', NULL),
(116, 'Mercedes-Benz', 1398977406, 1463169374, 1, 'Мерседес Бенс', 1),
(117, 'Mercury', 1398977406, 1463169375, 1, 'Меркури', NULL),
(118, 'Metrocab', 1398977406, 1463169376, 1, 'Метрокэб', NULL),
(119, 'MG', 1398977406, 1463169377, 1, 'МГ', NULL),
(121, 'Minelli', 1398977406, 1463169378, 1, 'Минелли', NULL),
(122, 'Mini', 1398977406, 1463169379, 1, 'Мини', NULL),
(123, 'Mitsubishi', 1398977406, 1463169380, 1, 'Митсубиши', 1),
(124, 'Mitsuoka', 1398977406, 1463169381, 1, 'Мицуока', NULL),
(125, 'Morgan', 1398977406, 1463169382, 1, 'Морган', NULL),
(127, 'Nissan', 1398977406, 1463169383, 1, 'Ниссан', 1),
(128, 'Noble', 1398977406, 1463169384, 1, 'Нобл', NULL),
(129, 'Oldsmobile', 1398977406, 1463169385, 1, 'Олдсмобиль', NULL),
(130, 'Opel', 1398977406, 1463169386, 1, 'Опель', 1),
(131, 'Osca', 1398977406, 1463169387, 1, 'Оска', NULL),
(132, 'Pagani', 1398977406, 1463169388, 1, 'Пагани', NULL),
(133, 'Panoz', 1398977406, 1463169389, 1, 'Паноз', NULL),
(134, 'Perodua', 1398977406, 1463169390, 1, 'Перодуа', NULL),
(135, 'Peugeot', 1398977406, 1463169391, 1, 'Пежо', 1),
(137, 'Plymouth', 1398977406, 1463169391, 1, 'Плимут', NULL),
(138, 'Pontiac', 1398977406, 1463169392, 1, 'Понтиак', NULL),
(139, 'Porsche', 1398977406, 1463169393, 1, 'Порше', 1),
(140, 'Premier', 1398977406, 1463169394, 1, 'Премьер', NULL),
(141, 'Proton', 1398977406, 1463169395, 1, 'Протон', NULL),
(143, 'Puma', 1398977406, 1463169396, 1, 'Пума', NULL),
(144, 'Qoros', 1398977406, 1463169397, 1, 'Корос', NULL),
(145, 'Qvale', 1398977406, 1463169397, 1, 'Куали', NULL),
(146, 'Reliant', 1398977406, 1463169422, 1, 'Релиант', NULL),
(147, 'Renault', 1398977406, 1463169423, 1, 'Рено', 1),
(148, 'Samsung', 1398977406, 1463169424, 1, 'Рено Самсунг', NULL),
(149, 'Rolls-Royce', 1398977406, 1463169425, 1, 'Роллс-Ройс', NULL),
(150, 'Ronart', 1398977406, 1463169426, 1, 'Ронарт', NULL),
(151, 'Rover', 1398977406, 1463169427, 1, 'Ровер', NULL),
(152, 'Saab', 1398977406, 1463169428, 1, 'Сааб', NULL),
(153, 'Saleen', 1398977406, 1463169428, 1, 'Салин', NULL),
(154, 'Santana', 1398977406, 1463169429, 1, 'Сантана', NULL),
(155, 'Saturn', 1398977406, 1463169430, 1, 'Сатурн', NULL),
(156, 'Scion', 1398977406, 1463169431, 1, 'Сцион', NULL),
(157, 'SEAT', 1398977406, 1463169432, 1, 'Сеат', NULL),
(158, 'ShuangHuan', 1398977406, 1463169433, 1, 'ШуангХуан', NULL),
(159, 'Skoda', 1398977406, 1463169433, 1, 'Шкода', 1),
(160, 'Smart', 1398977406, 1463169434, 1, 'Смарт', NULL),
(161, 'Soueast', 1398977406, 1463169435, 1, 'Сауист', NULL),
(162, 'Spectre', 1398977406, 1463169435, 1, 'Спектр', NULL),
(163, 'Spyker', 1398977406, 1463169436, 1, 'Спайкер', NULL),
(165, 'SsangYong', 1398977406, 1463169437, 1, 'Ссанг Йонг', 1),
(166, 'Subaru', 1398977406, 1463169438, 1, 'Субару', 1),
(167, 'Suzuki', 1398977406, 1463169439, 1, 'Сузуки', 1),
(168, 'Talbot', 1398977406, 1463169439, 1, 'Тэлбот', NULL),
(169, 'Tata', 1398977406, 1463169440, 1, 'ТАТА', NULL),
(170, 'Tatra', 1398977406, 1463169441, 1, 'Татра', NULL),
(172, 'Tesla', 1398977406, 1463169442, 1, 'Тесла', NULL),
(173, 'Tianma', 1398977406, 1463169442, 1, 'Тианма', NULL),
(174, 'Tianye', 1398977406, 1463169443, 1, 'Тианье', NULL),
(175, 'Tofas', 1398977406, 1463169444, 1, 'Тофас', NULL),
(176, 'Toyota', 1398977406, 1463169445, 1, 'Тойота', 1),
(177, 'Trabant', 1398977406, 1463169447, 1, 'Трабант', NULL),
(182, 'Vector', 1398977406, 1463169448, 1, 'Вектор', NULL),
(183, 'Venturi', 1398977406, 1463169449, 1, 'Вентури', NULL),
(184, 'Volkswagen', 1398977406, 1463169450, 1, 'Фольксваген', 1),
(185, 'Volvo', 1398977406, 1463169451, 1, 'Вольво', 1),
(186, 'Vortex', 1398977407, 1463169452, 1, 'Вортекс', NULL),
(187, 'Wartburg', 1398977407, 1463169453, 1, 'Вартбург', NULL),
(188, 'Westfield', 1398977407, 1463169454, 1, 'Вестфилд', NULL),
(189, 'Wiesmann', 1398977407, 1463169454, 1, 'Вайсман', NULL),
(190, 'Xin Kai', 1398977407, 1463169483, 1, 'Ксин Кай', NULL),
(191, 'Zastava', 1398977407, 1463169484, 1, 'Застава', NULL),
(192, 'Zotye', 1398977407, 1463169484, 1, 'Зоти', NULL),
(193, 'ZX', 1398977407, 1463169485, 1, 'ЗетИкс', NULL),
(215, 'ВАЗ (Lada)', 1398978087, 1463169486, 1, 'ВАЗ', 1),
(216, 'ГАЗ', 1398978087, 1463169487, 1, 'ГАЗ', 1),
(217, 'ЗАЗ', 1398978087, 1463169488, 1, 'ЗАЗ', NULL),
(218, 'ЗИЛ', 1398978087, 1463169489, 1, 'ЗИЛ', NULL),
(219, 'ИЖ', 1398978087, 1463169490, 1, 'ИЖ', NULL),
(222, 'ЛуАЗ', 1398978087, 1463169492, 1, 'ЛУАЗ', NULL),
(223, 'Москвич', 1398978087, 1463169493, 1, 'Москвич', NULL),
(224, 'СМЗ', 1398978087, 1463169493, 1, 'СМЗ', NULL),
(226, 'ТагАЗ', 1398978087, 1463169495, 1, 'ТагАЗ', NULL),
(227, 'УАЗ', 1398978087, 1463169496, 1, 'УАЗ', 1),
(282, 'Hawtai', 1411934673, 1463169497, 1, 'Хавтай', NULL),
(284, 'Renaissance Cars', 1411934673, 1463169498, 1, 'Ренессанс', NULL),
(286, 'Paykan', 1414343063, 1463169498, 1, 'Пайкан', NULL),
(290, 'Haval', 1416945499, 1463169499, 1, 'Хавэйл', NULL),
(291, 'Alpina', 1419455832, 1463169496, 1, 'Альпина', NULL),
(3589, 'DS', 1429392621, 1476917840, 1, 'ДС', NULL),
(3664, 'Adler', 1439903763, 1471727597, 1, 'Адлер', NULL),
(3666, 'Packard', 1439903764, 1471727597, 1, 'Пакард', NULL),
(3689, 'Ravon', 1445023148, 1474147250, 1, 'Рэйвон', NULL),
(3705, 'AMC', 1447237267, 1474146857, 1, 'АМЦ', NULL),
(3749, 'Austin Healey', 1462748795, 1474146851, 1, 'Остин Хили', NULL),
(3750, 'Avia', 1462748795, 1464649641, 1, NULL, NULL),
(3751, 'BAW', 1462748795, 1474146867, 1, 'БАВ', NULL),
(3752, 'Chana', 1462748795, 1474146910, 1, 'Чана', NULL),
(3753, 'Changhe', 1462748795, 1474146923, 1, 'Ченже', NULL),
(3754, 'DFSK', 1462748796, 1474147056, 1, 'ДФСК', NULL),
(3755, 'Efini', 1462748796, 1474147047, 1, 'Эфини', NULL),
(3756, 'Excalibur', 1462748796, 1474147037, 1, 'Экскалибур', NULL),
(3757, 'Groz', 1462748796, 1474146961, 1, 'Грос', NULL),
(3758, 'Gac Gonow', 1462748796, 1474147023, 1, 'Гац Гонов', NULL),
(3759, 'HINO', 1462748796, 1474146972, 1, 'ХИНО', NULL),
(3760, 'Hurtan', 1462748796, 1474147095, 1, 'Хуртан', NULL),
(3761, 'Jiangnan', 1462748796, 1474147116, 1, 'Джиангнан', NULL),
(3762, 'Jinbei', 1462748796, 1474147130, 1, 'Джинбей', NULL),
(3763, 'LDV', 1462748796, 1474147144, 1, 'ЛДВ', NULL),
(3764, 'Maxus', 1462748796, 1474147158, 1, 'Максус', NULL),
(3765, 'Monte Carlo', 1462748796, 1474147207, 1, 'Монте Карло', NULL),
(3766, 'NAVECO', 1462748796, 1474147218, 1, 'НАВЕКО', NULL),
(3767, 'Nysa', 1462748796, 1474147233, 1, 'Ныса', NULL),
(3768, 'RAF', 1462748796, 1474147240, 1, 'РАФ', NULL),
(3771, 'Shifeng', 1462748796, 1474147261, 1, 'Шифенг', NULL),
(3772, 'SMA', 1462748796, 1474147286, 1, 'СМА', NULL),
(3773, 'Sokon', 1462748796, 1474147803, 1, 'Сокон', NULL),
(3774, 'Wuling', 1462748796, 1474147838, 1, 'Вулинг', NULL),
(3775, 'Yuejin', 1462748796, 1474147887, 1, 'Юджин', NULL),
(3776, 'Богдан', 1462748796, 1474147909, 1, 'Богдан', NULL),
(3777, 'ВИС', 1462748796, 1474147918, 1, 'ВИС', NULL),
(3778, 'Гуран', 1462748796, 1474147927, 1, 'Гуран', NULL);

update car_mark set date_create = to_timestamp(int_date_create);
update car_mark set date_update = to_timestamp(int_date_update);
update car_mark set is_popular = case int_is_popular when 1 then 'Y' else 'N' end;

ALTER TABLE "car_mark" drop column int_date_create;
ALTER TABLE "car_mark" drop column int_date_update;
ALTER TABLE "car_mark" drop column int_is_popular;

