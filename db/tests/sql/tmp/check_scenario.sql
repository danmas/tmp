-- set autocommit off;

-- освободить подготовленные операторы
deallocate all;

-- устанавливаем пременные
\set dima_id 1
\set copr_stars_id 1
\set work_schema '\'carl_dev\'' 
\set db_user '\'carl\'' 

--begin;
	select plan(6);
	
	-- в схеме должны быть именно эти таблицы
	select tables_are(
		:work_schema
		, array[ 'profile', 'trade_unit', 'invitation', 'corporate', 'individual', 'users'
		,'auction_bid', 'auction', 'lot']
		, 'В схеме '||:work_schema||' все таблицы имеются.');
	
	-- в схеме должны быть именно эти функции
	select functions_are(
		:work_schema
		, array[ 'createnewcorporate','createnewindivprofile','createauction4lot'
		, 'increasebalance4individ','registernewuser','getlotidbyname','getuseridbyindivid','getprofilelist4user'
		, 'info','getindividbyuserid','getusersmartname','getuseridbyemail','getcorpidbyname'
		, 'increasebalance4corpid','createnewcorpprofile','criptpassword','createnewlot','createnewuser' ]
		, ' все необходимые функции имеются.');	
		
	-- проверка наличия типов	
	select types_are(
		:work_schema
		, array[ 't_prof_list' ]
		, ' все необходимые типы имеются.');		
		
	-- проверка расширений	
	/*select extensions_are(
		:work_schema
		, array[ 'pgtap' ]
		, ' все необходимые расширения установлены.');		
	*/	
	select isnt_superuser(
		:db_user
		,'User '||:db_user||' should not be a super user');	
	
	-- должен быть пользователь
	select results_eq('select first_name::varchar from users where id=getUserIdByEmail(''email1@gamil.com'')'
                      ,'select ''Дима''::varchar'
                      ,'Пользователь Дима присутствует.');
					  
	-- должны быть профили физ лиц
	select results_eq('select prof_id from (
				select p.id as prof_id, getusersmartname(p.user_id) as user
					, p.is_active is_active, c.name,
					case when i.id is not null then ''Физ.лицо'' else ''Юр.лицо'' end as type
				from profile p, trade_unit t 
				left join corporate  c on (t.corporate_id = c.id)
				inner join individual i on (i.id = t.individual_id)
				where ( p.trade_unit_id = t.id )
				order by p.user_id
			) sub order by prof_id'
			, array[ 2, 4, 8] 
			, 'Профили физ.лиц в наличии.');

	-- должны быть профили юр лиц
	select results_eq('select prof_id from (
				select p.id as prof_id, getusersmartname(p.user_id) as user
					, p.is_active is_active, c.name,
					case when i.id is not null then ''Физ.лицо'' else ''Юр.лицо'' end as type
				from profile p, trade_unit t 
				inner join corporate  c on (t.corporate_id = c.id)
				left  join individual i on (i.id = t.individual_id)
				where ( p.trade_unit_id = t.id )
				order by p.user_id
			) sub order by prof_id'
			, array[ 1, 3, 5, 6, 7] 
			, 'Профили юр.лиц в наличии.');
	
	-- проверка функции
	select is(getUserIdByEmail('email1@gamil.com')
		,:dima_id
		, 'id Димы равно '||:dima_id||'?'); 
	
	-- 
	select results_eq('select count(*)::int from corporate where id = '||:copr_stars_id
					, 'select 1::int'
					,'Корпорация Звездолёты Инк существует');
	
	-- проверка функции и наличия корпорации 
	select is( corporate.*, row(:copr_stars_id,'Звездолёты Инк','7324598745630496','OGRN7856763',null)::corporate
		, 'Корпорация Звездолёты Инк существует и все атрибуты правильны.' )
		from corporate
		where id = :copr_stars_id;

	-- проверка выбрасывания исключения. (Сообщение исключения тоже проверяется!)		
	select throws_ok('select createNewCorporate(getUserIdByEmail(''email2@gamil.com''),''Звездолёты Инк'')'
		,'Уже существет юр.лицо с таким названием.'
		,'Проверка исключения: Уже существет юр.лицо с таким названием.');
	
	prepare prp_createNewCorporate as select createNewCorporate(getUserIdByEmail($1),$2);
	select throws_ok('execute prp_createNewCorporate(''email2@gamil.com'',''Звездолёты Инк'')'
		,'Уже существет юр.лицо с таким названием.'
		,'Проверка исключения: Уже существет юр.лицо с таким названием.');
	
	-- проверка быстродействия
	prepare fast_query as select id from users where first_name = 'Дима';
	select performs_ok(
			'fast_query',
			250,
			'a select by name should be fast');
	/*
		Эта функция гарантирует, что SQL-оператор, в среднем, выполняет в ожидаемом окне. 
		Это делается путем запуска запроса по умолчанию 10 раз. Он выбрасывает верхние 
		и нижние 10% прогонов и усредняет средние 80% выполненных прогонов. 
		Если среднее время выполнения выходит за пределы, указанные внутри, тест не будет выполнен.
	*/
	select performs_within('fast_query'
			, 0.01  -- не дольше 200 мс.
			, 0.001  -- отклонение в мс. от среднего  
			, 100  -- 100 раз
			, 'a select by name should be fast');
	
	select * from finish();
--rollback;

