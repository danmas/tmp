set autocommit off;

truncate table profile    restart identity cascade;
truncate table trade_unit restart identity cascade;
truncate table invitation;
delete from corporate;
delete from individual;
delete from users;

-- Сценарий:

-- Есть четыре человека:

-- Дима Холод   
-- Лёша Пчелкин 
-- Рома Дедуган 
-- Старикашка Эдельвейс 

-- Insert USER 1.1-1
-- Все они зарегистрировались и авторизовались 


/*
-- Тестирование процедуры регистрации
-- 
user_id = registerNewUser('Вася', 'Логинер', 'v.loginer@gmail.com', null, 'AJGHRKWFWVSDJLKFSSFF'); -- '+7 916 695 20 75', 'ZZZZXXXXXCCCCCVVVV');

-- генерится пароль 
setCode(user_id, '123456'); 
*/




select createNewUser('email1@gamil.com','password1','Дима', 'Холод');
select createNewUser('email2@gamil.com','password2','Лёша', 'Пчелкин');
select createNewUser('email3@gamil.com','password3','Рома', 'Дед');
select createNewUser('email4@gamil.com','password1','Старикашка', 'Эдельвейс');

    
-- 1. ДХ - открывает фирму 'Звездолёты Инк' (автоматически становится админом)
--    заполняет все данные, подписывает Договор, 
select createNewCorporate(getUserIdByEmail('email1@gamil.com'),'Звездолёты Инк', '7324598745630496', 'OGRN7856763');

-- кладет деньги на счет (после этого может торговать).
select increaseBalance4CorpId(getCorpIdByName('Звездолёты Инк'),1999.01::money);
 
select info();

-- А вот ещё раз с таким названием фирму не создашь. Exception!
-- select createNewCorporate(getUserIdByEmail('email2@gamil.com'),'Звездолёты Инк');


-- 2. ЛП - создает торговый профиль как физик
--    заполняет все данные, подписывает Договор, кладет деньги на счет.
select createNewIndivProfile(getUserIdByEmail('email2@gamil.com'), '07324598745630496');

select info();

-- кладет деньги на счет (после этого может торговать).
select increaseBalance4IndivId(getIndivIdByUserId(getUserIdByEmail('email2@gamil.com')),99.02::money);

select info();

-- 3. ДХ - приглашает ЛП стать продавцом 'Звездолёты Инк'
-- 4. ЛП - входит и становится представителем 'Звездолёты Инк'
select createNewCorpProfile(getCorpIdByName('Звездолёты Инк'), getUserIdByEmail('email2@gamil.com')); 

select info();

-- 5. РД - регистрируется как физик
-- 2. ЛП - создает торговый профиль как физик
--    заполняет все данные, подписывает Договор, кладет деньги на счет.
select createNewIndivProfile(getUserIdByEmail('email3@gamil.com'), '00324598745630496');

select info();

--6. CЭ - регистрируется и открывает фирму 'Австралопитек'
--    заполняет все данные, подписывает Договор, 
select createNewCorporate(getUserIdByEmail('email4@gamil.com'),'Австралопитек', '22222222222222222', 'OGRN222');

select info();

-- 7. СЭ - приглашает ЛП стать продавцом 'Австралопитек'
-- 8. ЛП - входит и становится представителем 'Австралопитек'
select createNewCorpProfile(getCorpIdByName('Австралопитек'), getUserIdByEmail('email2@gamil.com')); 

select info();

-- текущая ситуация:

/*
ЛП - физик, продавец*2
РД - физик
ДХ - админ
СЭ - админ
*/

-- 9. СЭ - приглашает ДХ в 'Австралопитек'
-- 10. ДХ - становится продавец
-- 10. ДХ - входит и становится представителем 'Австралопитек'
select createNewCorpProfile(getCorpIdByName('Австралопитек'), getUserIdByEmail('email1@gamil.com')); 

select info();

-- (TODO: Не реализовано переназначение админа) 11. СЭ назначает ДХ - админом

-- 12. СЭ становится физиком
--    создает торговый профиль как физик
--    заполняет все данные, подписывает Договор, кладет деньги на счет.
select createNewIndivProfile(getUserIdByEmail('email4@gamil.com'), '4444444444444444');

-- кладет деньги на счет (после этого может торговать).
select increaseBalance4IndivId(getIndivIdByUserId(getUserIdByEmail('email4@gamil.com')),199.02::money);

select info();

-- текущая ситуация:
/*
ЛП - физик, продавец*2
РД - физик
ДХ - админ*2
СЭ - админ, физик
*/

SELECT p.id as prof_id, getUserSmartName(p.user_id) as user
	, p.is_active is_active, c.name, 
	case when i.id is not null then 'Физ.лицо' else 'Юр.лицо' end as type
	FROM
		profile p, trade_unit t left join corporate c on (t.corporate_id = c.id)
		left join individual i on (i.id = t.individual_id)	 
		WHERE ( p.trade_unit_id = t.id ) 
		-- AND p.user_id = 
		ORDER BY p.user_id;

/*		
 prof_id |         user         | is_active |      name      |   type   
---------+----------------------+-----------+----------------+----------
       7 | Дима Холод           | N         | Австралопитек  | Юр.лицо
       1 | Дима Холод           | N         | Звездолёты Инк | Юр.лицо
       3 | Лёша Пчелкин         | N         | Звездолёты Инк | Юр.лицо
       2 | Лёша Пчелкин         | N         |                | Физ.лицо
       6 | Лёша Пчелкин         | N         | Австралопитек  | Юр.лицо
       4 | Рома Дед             | N         |                | Физ.лицо
       8 | Старикашка Эдельвейс | N         |                | Физ.лицо
       5 | Старикашка Эдельвейс | N         | Австралопитек  | Юр.лицо
(8 rows)
*/		

-- торгуются торги

-- На торги выставляется лот - 'Мертвого осла уши'

select createNewLot('Мертвого осла уши');
select createNewLot('Пепелац с Плюка');
select createNewLot('Гравицапа для пепелаца с Плюка');


-- select getUserIdByEmail('email2@gamil.com'::text);

-- ЛП выбирает профиль для участия в торгах
-- получает список профилей
--select getProfileList4User(getUserIdByEmail('email2@gamil.com'::text));

-- выбирает рабочий profile_id = 3 (Звездолёты Инк | Юр.лицо)

------------------------------------------------------
-- проверка функции registerNewUser()
------------------------------------------------------

select registerNewUser('Почтальон', 'Печкин', null, '+7 916 695 20 75', 'ZZZZXXXXXCCCCCVVVV');
/*
-- здесь исключение
select registerNewUser('Кот', 'Матроскин ', null, '+7 916 695 20 75', '+ZZZXXXXXCCCCCVVVV');
-- OK
select registerNewUser('Кот', 'Матроскин ', 'matros@eml.ru', null, '+ZZZXXXXXCCCCCVVVV');
-- здесь исключение
select registerNewUser('Шарик', 'Пёс', 'matros@eml.ru', null, '+ZZZXXXXXCCCCCVVVV');
*/

