
--drop schema if exists carl_tests cascade;
create schema if not exists carl_tests;
comment on schema carl_tests is 'The schema for unit tests on carlinkng';

-- \i ./tests/sql/create_tests.sql

/*
	Функция проверки процедуры ввода нового пользователя в систему
	
	select carl_tests.test_check_auth('carl');
*/	
-- drop function carl_tests.test_check_auth(::varchar);
create or replace function carl_tests.test_check_auth(p_db_user varchar)
returns setof text as
$$
declare
	_user_id       int;
	_user_email    varchar = 'v.loginer@gmail.com';
	_ans           varchar(1);
begin
	
	begin
		delete from users where id = getUserIdByEmail(_user_email)::int;
	exception when others then
		null;
	end;	
	
	_user_id = registerNewUser('Вася', 'Логинер', _user_email, null
		, 'AJGHRKWFWVSDJLKFSSFF'); -- '+7 916 695 20 75', 'ZZZZXXXXXCCCCCVVVV');
		
	return next (select is(getUserIdByEmail(_user_email), _user_id
		, 'id пользователя '||_user_email||'='||_user_id)); 
	
	return next (select lives_ok('select setVerifCode('||_user_id||', ''123456'', ''E_MAIL'')'
		,'проверка выполнения setVerifCode() для е-мэйла'));

		
	return next (select lives_ok('select setVerifCode('||_user_id||', ''654321'', ''PHONE'')'
		,'проверка выполнения setVerifCode() для телефона'));
		
	return next (select is(isVerifCodeCorrect(_user_id, '123456', 'E_MAIL')
		, 'Y'
		, 'Код мыла проверен')
		); 
		
	return next (select is(isVerifCodeCorrect(_user_id, '654321', 'PHONE')
		, 'Y'
		, 'Код телефона проверен')
		); 

	return next (select is(isVerifCodeCorrect(_user_id, '+123456', 'E_MAIL')
		, 'N'
		, 'Неверный код мыла')
		); 
		
	return next (select is(isVerifCodeCorrect(_user_id, '+654321', 'PHONE')
		, 'N'
		, 'Неверный код телефона')
		); 
		
	return next (select throws_like('select setVerifCode('||_user_id||', ''123456'', ''+E_MAIL'')'
	    , getMessage('VERIFY_CODE_BAD_TYPE')||'%'
		,'проверка выбрасывания исключения на неверный тип в setVerifCode()'));

	return next (select throws_like('select isVerifCodeCorrect('||_user_id+1||', ''123456'', ''+E_MAIL'')'
	    , getMessage('VERIFY_CODE_BAD_TYPE')||'%'
		,'проверка выбрасывания исключения на неверный тип в isVerifCodeCorrect()'));
	
	return next (select throws_ok('select isVerifCodeCorrect('||_user_id+1||', ''+++++'', ''E_MAIL'')'
	    , getMessage('VERIFY_CODE_NOT_FOUND')
		,'проверка выбрасывания исключения VERIFY_CODE_NOT_FOUND в isVerifCodeCorrect()'));

	--+ проверка протухания кода	
	update verify_code set dt_send = now() - interval '25 hours'
		where user_id = _user_id;
	
	return next (select throws_ok('select isVerifCodeCorrect('||_user_id||', ''123456'', ''E_MAIL'')'
	    , getMessage('VERIFY_CODE_TIMEOUT')
		,'проверка выбрасывания исключения VERIFY_CODE_TIMEOUT в isVerifCodeCorrect()'));
	
	--setUserStatus(_user_id,'GUEST');
	
	
	return next (select * from finish());
	
end;
$$ language plpgsql;



/*
	Функция проверки правильности структуры базы
	для пользователя p_db_user
	
	select carl_tests.test_db_struct('carl');
*/	
create or replace function carl_tests.test_db_struct(p_db_user varchar )
returns setof text as
$$
declare
begin
	-- в схеме должны быть именно эти таблицы
	return next (select tables_are(
		'carl_comm'
		, array[ 'message']
		, 'в схеме carl_comm все таблицы имеются'));
	return next (select tables_are(
		'carl_auth'
		, array[ 'users', 'verify_code']
		, 'в схеме carl_auth все таблицы имеются'));
	return next (select tables_are(
		'carl_prof'
		, array[ 'profile', 'trade_unit', 'invitation', 'corporate', 'individual']
		, 'в схеме carl_prof все таблицы имеются'));
	return next (select tables_are(
		'carl_auct'
		, array[ 'auction_bid', 'auction', 'lot']
		, 'в схеме carl_dev все таблицы имеются'));
	
	-- в схеме должны быть именно эти функции
	return next (select functions_are(
		'carl_auth'
		, array[ 'setuserstatus','isverifcodecorrect', 'setverifcode' ]
		, 'в схеме carl_auth все необходимые функции имеются'));	
	return next (select functions_are(
		'carl_comm'
		, array[ 'setmessage', 'getmessage','random_text','createnewcorporate','createnewindivprofile','createauction4lot'
		, 'increasebalance4individ','registernewuser','getlotidbyname','getuseridbyindivid','getprofilelist4user'
		, 'info','getindividbyuserid','getusersmartname','getuseridbyemail','getcorpidbyname'
		, 'increasebalance4corpid','createnewcorpprofile','criptpassword','createnewlot','createnewuser' ]
		, 'в схеме carl_comm все необходимые функции имеются'));	
		
	-- проверка наличия типов	
	return next (select types_are(
		'carl_comm'
		, array[ 't_prof_list', 'en_user_state', 'en_verif_code_type' ]
		, 'все необходимые типы имеются')
		);		
		
	-- проверка расширений	
	/*select extensions_are(
		:work_schema
		, array[ 'pgtap' ]
		, ' все необходимые расширения установлены.');		
	*/	
	
	return next (select isnt_superuser(
		p_db_user
		,'пользователь db '||p_db_user||' не должен быть суперпользователем')
		);	
	return next (select * from finish());
end;
$$ language plpgsql;


/*
	Функция проверки правильности выполнения начального сценария
	для пользователя p_db_user
	
	select carl_tests.test_check_play_scetario('carl');
*/	
create or replace function carl_tests.test_check_play_scetario(p_db_user varchar )
returns setof text as
$$
declare
 p_dima_id       varchar = '1';
 p_copr_stars_id varchar = '1';
begin
	-- освободить подготовленные операторы
	--deallocate all;

	-- должен быть пользователь
	return next (select results_eq('select first_name::varchar from users where id=getUserIdByEmail(''email1@gamil.com'')'
                ,'select ''Дима''::varchar'
                ,'пользователь Дима присутствует.')
			);
					  
	-- должны быть профили физ лиц
	return next (select results_eq('select prof_id from (
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
			, 'профили физ.лиц в наличии.')
			);

	-- должны быть профили юр лиц
	return next (select results_eq('select prof_id from (
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
			, 'профили юр.лиц в наличии.')
			);
	
	-- проверка функции
	return next (select is(getUserIdByEmail('email1@gamil.com')::int
		, p_dima_id::int
		, 'id Димы равно '||p_dima_id||'?')
		); 

	return next (select results_eq('select count(*)::int from corporate where id = '||p_copr_stars_id
					, 'select 1::int'
					,'корпорация Звездолёты Инк существует')
					);
	
	-- проверка функции и наличия корпорации 
	return next (select is( corporate.*, row(p_copr_stars_id::int,'Звездолёты Инк','7324598745630496','OGRN7856763',null)::corporate
		, 'корпорация Звездолёты Инк существует и все атрибуты правильны.' )
		from corporate
		where id = p_copr_stars_id::int
		);

	-- проверка выбрасывания исключения. (Сообщение исключения тоже проверяется!)		
	return next (select throws_ok('select createNewCorporate(getUserIdByEmail(''email2@gamil.com''),''Звездолёты Инк'')'
		,'Уже существет юр.лицо с таким названием.'
		,'проверка исключения: Уже существет юр.лицо с таким названием.')
		);
		
	--deallocate prp_createNewCorporate;
	prepare prp_createNewCorporate as select createNewCorporate(getUserIdByEmail($1),$2);
	return next (select throws_ok('execute prp_createNewCorporate(''email2@gamil.com'',''Звездолёты Инк'')'
		,'Уже существет юр.лицо с таким названием.'
		,'проверка исключения: Уже существет юр.лицо с таким названием.')
		);
	
	-- проверка быстродействия
	--deallocate fast_query;
	prepare fast_query as select id from users where first_name = 'Дима';
	return next (select performs_ok(
			'fast_query',
			250,
			'прорерка скорости выборки пользователя')
			);
			
	--deallocate fast_query_2;		
	prepare fast_query_2 as select prof_id from (
				select p.id as prof_id, getusersmartname(p.user_id) as user
					, p.is_active is_active, c.name,
					case when i.id is not null then 'Физ.лицо' else 'Юр.лицо' end as type
				from profile p, trade_unit t 
				inner join corporate  c on (t.corporate_id = c.id)
				left  join individual i on (i.id = t.individual_id)
				where ( p.trade_unit_id = t.id )
				order by p.user_id
			) sub order by prof_id;
			
	/*
		Эта функция гарантирует, что SQL-оператор, в среднем, выполняет в ожидаемом окне. 
		Это делается путем запуска запроса по умолчанию 10 раз. Он выбрасывает верхние 
		и нижние 10% прогонов и усредняет средние 80% выполненных прогонов. 
		Если среднее время выполнения выходит за пределы, указанные внутри, тест не будет выполнен.
	*/
	return next (select performs_within('fast_query_2'
			, 0.17  -- не дольше  мс.
			, 0.05  -- отклонение в мс. от среднего  
			, 100  -- 100 раз
			, 'прорерка скорости выполнения связки юриков-физиков для юзера')
			);
	return next (select * from finish());
end;
$$ language plpgsql;


-- select random_text(10);

/*
	Заполнение случайными юриками
	select carl_tests.fill_random_corporate(100);
*/
create or replace function carl_tests.fill_random_corporate(numb integer) returns text as 
$$
	declare
		_user_id int;
		_id int;
	begin
		_user_id = getUserIdByEmail('email4@gamil.com');
		
		for i in 1..numb loop
			_id = createNewCorporate(_user_id, carl_comm.random_text(32)
				, carl_comm.random_text(50), carl_comm.random_text(20));
		end loop;	
		return 'Ok. '||numb|| ' Новых юриков сотворено.';	
	end; 	
$$ language plpgsql;


/*
	Заполнение случайными юриками
		регистрируется новый пользователь
		и для него создается физ.лицо 
	select carl_tests.fill_random_individual(100);
*/
create or replace function carl_tests.fill_random_individual(numb integer) returns text as 
$$
	declare
		_id int;
	begin
		for i in 1..numb loop
			_id = registerNewUser(random_text(32), random_text(32)
				, random_text(25), null, random_text(32));
			_id = createNewIndivProfile(_id, random_text(32));
		end loop;	
		return 'Ok. '||numb||' Новых физиков сотворено.';	
	end; 	
$$ language plpgsql;


/*
create or replace function carl_tests.test_scheme_check_func(p_scheme varchar)
returns setof text as
$$
declare
   v_array text[];
begin   
        select array_agg(f_name)
        into v_array
        from (
                select distinct(n.nspname || '.' || p.proname)  as f_name
                from pg_proc p,
                     pg_namespace n
                where n.oid = p.pronamespace
                and   n.nspname = p_scheme
                except
                select distinct(array_to_string(regexp_matches (descr,'\w+.\w+'),',','*')) as f_name
        from __tresults__
        ) as r;
        return next is(v_array,null,'All functions in schema '||p_scheme||' are covered with tests.');
end;
$$ language plpgsql;
*/
\q
