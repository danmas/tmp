
--drop schema if exists carl_tests cascade;
create schema if not exists carl_tests;
comment on schema carl_tests is 'The schema for unit tests on carlinkng';

-- \i ./tests/sql/create_tests.sql

/*
	Функция проверки процедуры ввода нового пользователя в систему
	
	select carl_tests.test_check_auth('carl');
*/	
drop function if exists    carl_tests.test_check_auth(varchar);
create or replace function carl_tests.test_check_auth(p_db_user varchar)
returns setof text as
$$
declare
	_user_id       int;
	_user_id2      int;
	_user_id3      int;
	_user_email    varchar = 'v.loginer@gmail.com';
	_user_email2   varchar = 'v.loginer2@gmail.com';
	_user_email3   varchar = 'v.loginer3@gmail.com';
	_ans           varchar(1);
	_status        varchar;
	_err_txt1 text;
	_err_txt2 text;
	_err_txt3 text;	
	_err_txt4 text;	
begin
	begin
		delete from users where id = getUserIdByEmail(_user_email)::int;
	exception when others then
		null;
	end;
	
	-- 1
	_user_id = registerNewUser('Вася', 'Логинер', _user_email, null
		, 'AJGHRKWFWVSDJLKFSSFF'); -- '+7 916 695 20 75', 'ZZZZXXXXXCCCCCVVVV');
	return next (select is(getUserIdByEmail(_user_email), _user_id
		, 'id пользователя '||_user_email||'='||_user_id)); 
	-- 2
	return next (select lives_ok('select setVerifyCode('||_user_id||', ''123456'', ''E_MAIL'')'
		,'проверка выполнения setVerifyCode() для е-мэйла'));
	/**/	
	-- 3	
	--return next (select lives_ok('select setVerifyCode('||_user_id||', ''654321'', ''PHONE'')'
	--	,'проверка выполнения setVerifyCode() для телефона'));
	-- 4	
	return next (select is(checkVerifyCode(_user_id, '123456') --, 'E_MAIL')
		, 'Y'
		, 'Код мыла проверен')); 
	-- 5	
	--return next (select is(checkVerifyCode(_user_id, '654321') --, 'PHONE')
	--	, 'Y'
	--	, 'Код телефона проверен')); 
	-- 6
	return next (select is(checkVerifyCode(_user_id, '+123456') --, 'E_MAIL')
		, 'N'
		, 'Неверный код')); 
	-- 7	
	return next (select is(checkVerifyCode(_user_id, '+654321') --, 'PHONE')
		, 'N'
		, 'Неверный код')
		); 
	-- 8	
	return next (select throws_like('select setVerifyCode('||_user_id||', ''1234567'', ''+E_MAIL'')'
	    , _getMessage('VERIFY_CODE_BAD_TYPE')||'%'
		,'проверка выбрасывания исключения на неверный тип в setVerifyCode()'));
    -- 9
	--return next (select throws_like('select _isVerifCodeCorrect('||_user_id+1||', ''123456'', ''+E_MAIL'')'
	--   , _getMessage('VERIFY_CODE_BAD_TYPE')||'%'
	--	,'проверка выбрасывания исключения на неверный тип в _isVerifCodeCorrect()'));
	-- 10
	return next (select throws_ok('select checkVerifyCode('||_user_id+1||', ''+++++'')' --, ''E_MAIL'')'
	    , _getMessage('VERIFY_CODE_NOT_FOUND')
		,'проверка выбрасывания исключения VERIFY_CODE_NOT_FOUND в checkVerifyCode()'));
	-- 11
	--+ проверка протухания кода	
	update verify_code set dt_send = now() - interval '25 hours'
		where user_id = _user_id;
	
	return next (select throws_ok('select checkVerifyCode('||_user_id||', ''123456'')' -- , ''E_MAIL'')'
	    , _getMessage('VERIFY_CODE_TIMEOUT')
		,'проверка выбрасывания исключения VERIFY_CODE_TIMEOUT в checkVerifyCode()'));
	

	/*
		Проверка изменения статуса после получения кода
	*/
	begin
		delete from users where id = getUserIdByEmail(_user_email2)::int;
	exception when others then
		null;
	end;
	
	_user_id2 := registerNewUser('Вася2', 'Логинер2', _user_email2, null, 'AJGHRKWFWVSDJLKFSSFF'); 
	
	-- 12	
	return next (select is(_getUserStatus(_user_id2), 'UNKNOWN'
		, 'Статус нового юзера - UNKNOWN id '||_user_id2 )); 
	-- 13
	perform setVerifyCode(_user_id2, '0113456', 'E_MAIL');
	_ans := checkVerifyCode(_user_id2, '0113456'); --, 'E_MAIL');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED_SINGLE'
		, 'Статус после подтверждения кода по мэйлу - CONFIRMED_SINGLE')); 
	
	perform setVerifyCode(_user_id2, '111456', 'PHONE');
	_ans := checkVerifyCode(_user_id2, '111456'); --, 'PHONE');
	-- 14
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Статус после подтверждения кода по телефону - CONFIRMED')); 
	-- 15	
	begin
		delete from users where id = getUserIdByEmail(_user_email2)::int;
	exception when others then
		null;
	end;
	_user_id2 := registerNewUser('Вася2', 'Логинер2', _user_email2, null, 'AJGHRKWFWVSDJLKFSSFF'); 
	return next (select is(_getUserStatus(_user_id2), 'UNKNOWN'
		, 'Статус нового юзера - UNKNOWN')); 
	-- 16
	perform setVerifyCode(_user_id2, '111456', 'PHONE');
	_ans := checkVerifyCode(_user_id2, '111456'); --, 'PHONE');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Статус после подтверждения кода по телефону - CONFIRMED')); 
	-- 17
	perform setVerifyCode(_user_id2, '113456', 'E_MAIL');
	_ans := checkVerifyCode(_user_id2, '113456'); --, 'E_MAIL');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Статус после подтверждения кода по мэйлу не изменился - CONFIRMED')); 
	-- 18
	_ans := checkVerifyCode(_user_id2, '++1456'); --, 'PHONE');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Ошибочный ввод кода по телефону не меняет статус - CONFIRMED')); 
	-- 19	
	_ans := checkVerifyCode(_user_id2, '++1456'); --, 'E_MAIL');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Ошибочный ввод кода по мылу не меняет статус - CONFIRMED')); 
		
	/*
		Проверка невозможности одинаковых кодов пользователя для мэйла и тел
	*/
	begin
		delete from users where id = getUserIdByEmail(_user_email3)::int;
	exception when others then
		null;
	end;

	_user_id3 := registerNewUser('Вася3', 'Логинер3', _user_email3, null, 'AJGHRKWFWVSDJLKFSSFF'); 
	return next (select is(_getUserStatus(_user_id3), 'UNKNOWN'
		, 'Статус нового юзера - UNKNOWN')); 
		
	perform setVerifyCode(_user_id3, 'Q13456', 'E_MAIL');
	return next (select throws_ok('select setVerifyCode('||_user_id3||', ''Q13456'', ''PHONE'')' 
	    , _getMessage('VERIFY_CODE_DUPLICATE')
		,'проверка выбрасывания исключения VERIFY_CODE_DUPLICATE в checkVerifyCode()'));

	return next (select is(checkVerifyCode(_user_id3, '+654321') --, 'PHONE')
		, 'N'
		, 'Неверный код')
		); 
		
	return next (select * from finish());
exception when others then
  get stacked diagnostics _err_txt1 = message_text,
                          _err_txt2 = table_name,
                          _err_txt3 = schema_name,
						  _err_txt4 = pg_exception_context;
	return next 'Exeption: '|| _err_txt1 ||CHR(13)||'Context: '|| _err_txt4;	
end;
$$ language plpgsql;



/*
	Функция проверки правильности структуры базы
	для пользователя p_db_user
	
	select carl_tests.test_db_struct('carl');
*/	
drop function if exists    carl_tests.test_db_struct(varchar);
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
		, array[ 'setverifycode', 'checkverifycode'
			,'_setuserstatus','_getuserstatus','_isverifcodecorrect' ]
		, 'в схеме carl_auth все необходимые функции имеются'));	
	return next (select functions_are(
		'carl_comm'
		, array[ '_setmessage', '_getmessage','random_text','createnewcorporate','createnewindivprofile','createauction4lot'
		, 'increasebalance4individ','registernewuser','getlotidbyname','getuseridbyindivid','getprofilelist4user'
		, 'info','getindividbyuserid','getusersmartname','getuseridbyemail','getcorpidbyname'
		, 'increasebalance4corpid','createnewcorpprofile','criptpassword','createnewlot','createnewuser' ]
		, 'в схеме carl_comm все необходимые функции имеются'));	
		
	-- проверка наличия типов	
	return next (select types_are(
		'carl_comm'
		, array[ 't_prof_list', 'en_user_status', 'en_verify_code_type','en_role' ]
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
drop function if exists    carl_tests.test_check_play_scetario(varchar );
create or replace function carl_tests.test_check_play_scetario(p_db_user varchar )
returns setof text as
$$
declare
 p_dima_id       varchar = '1';
 p_copr_stars_id varchar = '1';
 _prof_id  		 int;
 _srole    		 text; 
 _srole2   		 text; 
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
			
			
	_prof_id := 1;
	_srole := 'subscriber';
	_srole2 := 'buyer';
	
	begin
		perform removeRole(_prof_id, _srole);
		perform removeRole(_prof_id, _srole2);
	exception when others then
		null;
	end;	
	
	return next (select lives_ok('select addRole('||_prof_id ||','''||_srole||''')'
		, 'Добавление роли '||_srole||' юрику (profile.id) '||_prof_id));
	
	return next (select is(hasRole(_prof_id,_srole),'Y'
		, 'роль '||_srole||' есть у юрика (profile.id) '||_prof_id));
	
	return next (select is(hasRole(_prof_id,_srole2),'N'
		, 'роли '||_srole2||' у юрика (profile.id) '||_prof_id||' нет'));

	return next (select lives_ok('select addRole('||_prof_id ||','''||_srole2||''')'
		, 'Добавление роли '||_srole2||' юрику (profile.id) '||_prof_id));
		
	return next (select is(hasRole(_prof_id,_srole2),'Y'
		, 'роль '||_srole2||' есть у юрика (profile.id) '||_prof_id));
		
	
	return next (select is(getRoleList(_prof_id)::text,_srole||','||_srole2
		, 'роли юрика (profile.id) '||_prof_id||' теперь '||_srole||','||_srole2));
	
	
	return next (select lives_ok('select removeRole('||_prof_id ||','''||_srole2||''')'
		, 'Удаление роли '||_srole2||' у юрика (profile.id) '||_prof_id));

	return next (select is(hasRole(_prof_id,_srole2),'N'
		, 'роли '||_srole2||' у юрика (profile.id) '||_prof_id||' нет'));
		
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


/*
	Функция проверки процедуры ввода нового пользователя в систему
	
	select carl_tests.test_check_auth('carl');
*/	
/*
drop function if exists    carl_tests.test_check_auth(varchar);
create or replace function carl_tests.test_check_auth(p_db_user varchar)
returns setof text as
$$
declare
	_user_id       int;
	_user_id2      int;
	_user_email    varchar = 'v.loginer@gmail.com';
	_user_email2   varchar = 'v.loginer2@gmail.com';
	_ans           varchar(1);
	_status        varchar;
	_err_txt1 text;
	_err_txt2 text;
	_err_txt3 text;	
	_err_txt4 text;	
begin
	begin
		delete from users where id = getUserIdByEmail(_user_email)::int;
	exception when others then
		null;
	end;
	
	-- 1
	_user_id = registerNewUser('Вася', 'Логинер', _user_email, null
		, 'AJGHRKWFWVSDJLKFSSFF'); -- '+7 916 695 20 75', 'ZZZZXXXXXCCCCCVVVV');
	return next (select is(getUserIdByEmail(_user_email), _user_id
		, 'id пользователя '||_user_email||'='||_user_id)); 
	-- 2
	return next (select lives_ok('select setVerifyCode('||_user_id||', ''123456'', ''E_MAIL'')'
		,'проверка выполнения setVerifyCode() для е-мэйла'));
	-- 3	
	return next (select lives_ok('select setVerifyCode('||_user_id||', ''654321'', ''PHONE'')'
		,'проверка выполнения setVerifyCode() для телефона'));
	-- 4	
	return next (select is(_isVerifCodeCorrect(_user_id, '123456', 'E_MAIL')
		, 'Y'
		, 'Код мыла проверен')); 
	-- 5	
	return next (select is(_isVerifCodeCorrect(_user_id, '654321', 'PHONE')
		, 'Y'
		, 'Код телефона проверен')); 
	-- 6
	return next (select is(_isVerifCodeCorrect(_user_id, '+123456', 'E_MAIL')
		, 'N'
		, 'Неверный код мыла')); 
	-- 7	
	return next (select is(_isVerifCodeCorrect(_user_id, '+654321', 'PHONE')
		, 'N'
		, 'Неверный код телефона')
		); 
	-- 8	
	return next (select throws_like('select setVerifyCode('||_user_id||', ''123456'', ''+E_MAIL'')'
	    , _getMessage('VERIFY_CODE_BAD_TYPE')||'%'
		,'проверка выбрасывания исключения на неверный тип в setVerifyCode()'));
    -- 9
	return next (select throws_like('select _isVerifCodeCorrect('||_user_id+1||', ''123456'', ''+E_MAIL'')'
	    , _getMessage('VERIFY_CODE_BAD_TYPE')||'%'
		,'проверка выбрасывания исключения на неверный тип в _isVerifCodeCorrect()'));
	-- 10
	return next (select throws_ok('select _isVerifCodeCorrect('||_user_id+1||', ''+++++'', ''E_MAIL'')'
	    , _getMessage('VERIFY_CODE_NOT_FOUND')
		,'проверка выбрасывания исключения VERIFY_CODE_NOT_FOUND в _isVerifCodeCorrect()'));
	-- 11
	--+ проверка протухания кода	
	update verify_code set dt_send = now() - interval '25 hours'
		where user_id = _user_id;
	
	return next (select throws_ok('select _isVerifCodeCorrect('||_user_id||', ''123456'', ''E_MAIL'')'
	    , _getMessage('VERIFY_CODE_TIMEOUT')
		,'проверка выбрасывания исключения VERIFY_CODE_TIMEOUT в _isVerifCodeCorrect()'));
	
	--setUserStatus(_user_id,'GUEST');

	begin
		delete from users where id = getUserIdByEmail(_user_email2)::int;
	exception when others then
		null;
	end;
	
	_user_id2 := registerNewUser(...)
	'Статус нового юзера - UNKNOWN'
	
	setVerifyCode(_user_id2, '113456', 'E_MAIL');
	_ans := _isVerifCodeCorrect(_user_id2, '113456', 'E_MAIL');
	'Статус после подтверждения кода по мэйлу - CONFIRMED_SINGLE'
	
	setVerifyCode(_user_id2, '111456', 'PHONE');
	_ans := _isVerifCodeCorrect(_user_id2, '111456', 'PHONE');
	'Статус после подтверждения кода по телефону - CONFIRMED'
	
	setVerifyCode(...
	
	_user_id2 := registerNewUser('Вася2', 'Логинер2', _user_email2, null
		, 'AJGHRKWFWVSDJLKFSSFF'); -- '+7 916 695 20 75', 'ZZZZXXXXXCCCCCVVVV');
	-- 12	
	return next (select is(_getUserStatus(_user_id2), 'UNKNOWN'
		, 'Статус нового юзера - UNKNOWN')); 
	-- 13
	perform setVerifyCode(_user_id2, '113456', 'E_MAIL');
	_ans := _isVerifCodeCorrect(_user_id2, '113456', 'E_MAIL');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED_SINGLE'
		, 'Статус после подтверждения кода по мэйлу - CONFIRMED_SINGLE')); 
	
	perform setVerifyCode(_user_id2, '111456', 'PHONE');
	_ans := _isVerifCodeCorrect(_user_id2, '111456', 'PHONE');
	-- 14
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Статус после подтверждения кода по телефону - CONFIRMED')); 
	-- 15	
	begin
		delete from users where id = getUserIdByEmail(_user_email2)::int;
	exception when others then
		null;
	end;
	_user_id2 := registerNewUser('Вася2', 'Логинер2', _user_email2, null
		, 'AJGHRKWFWVSDJLKFSSFF'); -- '+7 916 695 20 75', 'ZZZZXXXXXCCCCCVVVV');
	return next (select is(_getUserStatus(_user_id2), 'UNKNOWN'
		, 'Статус нового юзера - UNKNOWN')); 
	-- 16
	perform setVerifyCode(_user_id2, '111456', 'PHONE');
	_ans := _isVerifCodeCorrect(_user_id2, '111456', 'PHONE');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Статус после подтверждения кода по телефону - CONFIRMED')); 
	-- 17
	perform setVerifyCode(_user_id2, '113456', 'E_MAIL');
	_ans := _isVerifCodeCorrect(_user_id2, '113456', 'E_MAIL');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Статус после подтверждения кода по мэйлу не изменился - CONFIRMED')); 
	-- 18
	_ans := _isVerifCodeCorrect(_user_id2, '++1456', 'PHONE');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Ошибочный ввод кода по телефону не меняет статус - CONFIRMED')); 
	-- 19	
	_ans := _isVerifCodeCorrect(_user_id2, '++1456', 'E_MAIL');
	return next (select is(_getUserStatus(_user_id2), 'CONFIRMED'
		, 'Ошибочный ввод кода по мылу не меняет статус - CONFIRMED')); 
	
	return next (select * from finish());
exception when others then
  get stacked diagnostics _err_txt1 = message_text,
                          _err_txt2 = table_name,
                          _err_txt3 = schema_name,
						  _err_txt4 = pg_exception_context;
	return next 'Exeption: '|| _err_txt1 ||CHR(13)||'Context: '|| _err_txt4;	
end;
$$ language plpgsql;
*/

\q
