


----------------------------------------------------------------------------------
--  Создание нового юзера
--  Возвращвет: user_id нового юзера
--  Пример: select createNewUser('email1','Дима Холод');
----------------------------------------------------------------------------------
create or replace function CriptPassword(p_password text) returns text
as $$
declare
  v text;
begin
  v = p_password;
  return v;
end
$$ language plpgsql;


----------------------------------------------------------------------------------
--  Создание нового юзера
--  Возвращвет: user_id нового юзера
--  Пример: select createNewUser('email1','Дима Холод');
----------------------------------------------------------------------------------
create or replace function createNewUser(p_email text, p_password text, p_first_name text, p_last_name text) returns int
as $$
declare
  v int;
begin
  insert into users (email, /*password_hash,*/ first_name, last_name) values (p_email, /*CriptPassword(p_password),*/ p_first_name, p_last_name)
     returning id into v;
  raise notice 'Создан юзер "%" с id "%"', p_email, v;
  return v;
end
$$ language plpgsql;

----------------------------------------------------------------------------------
--  Получение id пользователя по логину
----------------------------------------------------------------------------------
--drop function if exists getUserIdByEmail(text);
create or replace function getUserIdByEmail(p_email text) returns int
as $$
declare
  v int;
begin
  select id into v from users where email = p_email;
  -- raise notice 'id for email "%" is "%"', p_email, v;
  return v;
exception
  when no_data_found then
    raise exception 'Не найден пользователь для логина %. ', p_email;
end
$$ language plpgsql;



----------------------------------------------------------------------------------
--  Получение составного имени пользователя по ид
----------------------------------------------------------------------------------
--drop function if exists getUserSmartName(text);
create or replace function getUserSmartName(p_user_id int) returns text
as $$
declare
  ret text;
begin
  select first_name || ' ' || last_name into ret from users where id = p_user_id;
  return ret;
exception
  when no_data_found then
    raise exception 'Не найден пользователь с id %. ', p_user_id;
end
$$ language plpgsql;


----------------------------------------------------------------------------------
--  Получение id юр.лица по названию
----------------------------------------------------------------------------------
--drop function if exists getUserIdByEmail(text);
create or replace function getCorpIdByName(p_name text) returns int
as $$
declare
  v int;
begin
  select id into v from corporate where name = p_name;
  -- raise notice 'id for email "%" is "%"', p_email, v;
  return v;
exception
  when no_data_found then
    raise exception 'Не найдено юр.лицо с названием %', p_name;
end
$$ language plpgsql;



----------------------------------------------------------------------------------
--  Получение id физ.лица по user_id
----------------------------------------------------------------------------------
--drop function if exists getIndivIdByUserId(text);
create or replace function getIndivIdByUserId(p_user_id int) returns int
as $$
declare
  ret int;
begin
  select individual_id into ret from trade_unit where admin_user_id = p_user_id
	and individual_id is not null;
  -- raise notice 'id for email "%" is "%"', p_email, v;
  return ret;
exception
  when no_data_found then
    raise exception 'Не найдено физ.лицо для пользователя id %. ', p_user_id;
end
$$ language plpgsql;



----------------------------------------------------------------------------------
--  Получение user_id по id физ.лица
----------------------------------------------------------------------------------
--drop function if exists ggetUserIdByIndivId(text);
create or replace function getUserIdByIndivId(p_indiv_id int) returns int
as $$
declare
  ret int;
begin
  select admin_user_id into ret from trade_unit where individual_id = p_indiv_id;
  -- raise notice 'id for email "%" is "%"', p_email, v;
  return ret;
exception
  when no_data_found then
    raise exception 'Не найдено пользователя для физ.лица с id %. ', p_indiv_id;
end
$$ language plpgsql;


----------------------------------------------------------------------------------
--  Создание нового юр. лица, создается торговая единица и профиль для администратора
--  Возвращвет: id нового 
--  Исключения: В случае, если уже существует юрлицо с таким названием выбрасывается исключение
--  Пример: select createNewCorporate(getUserIdByEmail('email1'),'Звездолёты Инк', '7324598745630496', 'OGRN7856763');
----------------------------------------------------------------------------------
drop function if exists createNewCorporate(int, text, text, text, text);
create or replace function createNewCorporate(p_admin_user_id int, p_name text
    , p_inn text default null, p_ogrn text default null, p_kpp text default null) returns int
as $$
declare
  ret  int;
  cnt  int;
  tuid int;
begin
  select count(*) into cnt from corporate where name = p_name;
  if(cnt != 0) then
    raise exception 'Уже существет юр.лицо с таким названием.';
  end if;
  
  insert into corporate (name, inn, ogrn, kpp) values (p_name, p_inn, p_ogrn, p_kpp) returning id into ret;
  raise notice 'Создано юр.лицо "%" с id "%"', p_name, ret;

  -- создается торговая единица и профиль для администратора
  insert into trade_unit(admin_user_id, corporate_id/*, balance_summ*/) VALUES (
	p_admin_user_id, ret/*, 0*/ ) 
    returning id into tuid;
  insert into profile(user_id, trade_unit_id) VALUES 
    (p_admin_user_id, tuid);
  raise notice 'Торговый профиль юр.лица %', p_name || ' создан.';	
  return ret;
end
$$ language plpgsql;


----------------------------------------------------------------------------------
--  Создание нового профиля юр.лица(p_corp_id) для юзера(p_user_id)
--  Возвращвет: id нового профиля
--  Исключения: (TODO: пока не все проверки) 
-- 			    'Не существет юр.лица с таким ИД.';
--  Пример: 
----------------------------------------------------------------------------------
--drop function if exists createNewCorpProfile(int, text, text, text, text);
create or replace function createNewCorpProfile(p_corp_id int,  p_user_id int) returns int
as $$
declare
  ret  int;
  cnt  int;
  tuid int;
begin
  	
  select count(*) into cnt from corporate where id = p_corp_id;
  if(cnt = 0) then
    raise exception 'Не существет юр.лица с таким ИД.';
  end if;

  -- получаем торговую единицу и профиль для для юр.лица 
  select id into tuid from trade_unit where corporate_id = p_corp_id;
  if(tuid is null) then 
	raise exception 'Не существет торговой единицы для юр.лица с таким ИД.';
  end if;	
  
  insert into profile(is_active, user_id, trade_unit_id) VALUES 
    ('N', p_user_id, tuid)
	returning id into ret;

  raise notice 'Торговый профиль юр.лица для %', getUserSmartName(p_user_id) || ' создан.';

  return ret;
end
$$ language plpgsql;


----------------------------------------------------------------------------------
--  Создание нового юр. лица, создается торговая единица и профиль для администратора
--  Возвращвет: id нового individual
--  Исключения: В случае, если уже существует юрлицо с таким названием выбрасывается исключение
--  Пример: select createNewIndivProfile(getUserIdByEmail('email1'),'Звездолёты Инк', '7324598745630496', 'OGRN7856763');
----------------------------------------------------------------------------------
--drop function if exists createNewIndivProfile(int, text);
create or replace function createNewIndivProfile(p_user_id int
    , p_inn text default null) returns int
as $$
declare
  ret  int;
  cnt  int;
  tuid int;
begin
  -- raise notice '---------------------------------------------------------------';
  select count(*) into cnt from trade_unit where admin_user_id = p_user_id
	and individual_id is not null;
  if(cnt != 0) then
    raise exception 'Уже существет физ.лицо для этого пользователя.';
  end if;
  
  insert into individual (inn) values (p_inn) returning id into ret;
  raise notice 'Для пользователя с % создано физ.лицо с id "%"', p_user_id, ret;

  -- создается торговая единица и профиль 
  insert into trade_unit(admin_user_id, individual_id/*, balanсe_summ*/) VALUES (p_user_id, ret/*, 0*/ ) 
    returning id into tuid;
  insert into profile(user_id, trade_unit_id) VALUES (p_user_id, tuid);
	
  raise notice 'Торговый профиль физ.лица %', getUserSmartName(p_user_id) || ' создан.';
  
  return ret;
end
$$ language plpgsql;


----------------------------------------------------------------------------------
--  Поступление денег на счет.
--  Возвращвет: 
--  Исключения: выбрасывается исключение в случае ошибки
--  Пример: select increaseBalance4CorpId(getCorpIdByName('Звездолёты Инк'),1999.00);
----------------------------------------------------------------------------------
--drop function if exists increaseBalance4CorpId(int, number);
create or replace function increaseBalance4CorpId(p_corp_id int, p_summ money) returns int
as $$
declare
  ret  int;
  cnt  int;
  tuid int;
begin
  update trade_unit set balance_summ = balance_summ + p_summ::numeric
    where corporate_id = p_corp_id;
  --raise notice 'На счет юр.лица "%" поступила сумма "%"', getCorpNameById(p_corp_id), p_summ;
  -- проверка ,если достаточно то выставляет статус ТЮ Y
  return 1;
end
$$ language plpgsql;



----------------------------------------------------------------------------------
--  Поступление денег на счет.
--  Возвращвет: 
--  Исключения: выбрасывается исключение в случае ошибки
--  Пример: select increaseBalance4IndivId(getCorpIdByName('Звездолёты Инк'),1999.00);
----------------------------------------------------------------------------------
--drop function if exists increaseBalance4IndivId(int, number);
create or replace function increaseBalance4IndivId(p_indiv_id int, p_summ money) returns int
as $$
declare
  ret  int;
  cnt  int;
  tuid int;
begin
  update trade_unit set balance_summ = balance_summ + p_summ::numeric
    where individual_id = p_indiv_id;
  	
  raise notice 'На счет физ.лица "%" поступила сумма "%"', getUserSmartName(getUserIdByIndivId(p_indiv_id)), p_summ;
  -- проверка ,если достаточно то выставляет статус ТЮ Y
  return 1;
end
$$ language plpgsql;



----------------------------------------------------------------------------------
--  Возвращвет список профилей пользователя как тип t_prof_list
----------------------------------------------------------------------------------
-- select getProfileList4User(p_user_id int) 
create or replace function  getProfileList4User(p_user_id int) returns setof t_prof_list
as $$
declare
	_prof_list t_prof_list;
begin
  for _prof_list.prof_id, _prof_list.user_name, _prof_list.is_active
	, _prof_list.corp_name, _prof_list.prof_type in 
  
	select p.id as prof_id, getusersmartname(p.user_id) as user_name
		, p.is_active is_active, c.name as corp_name, 
		case when i.id is not null then 'физ.лицо' else 'юр.лицо' end as prof_type
		from
			profile p, trade_unit t left join corporate c on (t.corporate_id = c.id)
			left join individual i on (i.id = t.individual_id)	 
			where ( p.trade_unit_id = t.id ) 
			and p.user_id = p_user_id
			order by p.user_id
  loop
    return next _prof_list;
  end loop;
  return;
end
$$ language plpgsql;



----------------------------------------------------------------------------------
--  Создание нового лота.
--  Возвращвет: lot_id нового лота
--  Пример: 
----------------------------------------------------------------------------------
create or replace function createNewLot(p_name text) returns int
as $$
declare
  v   int;
  cnt int;
begin
  select count(*) into cnt from lot where name = p_name;	
  if(cnt != 0) then
	raise exception 'Ошибка. Уже есть лот с таким названием %.', p_name;
  end if;
  insert into lot (name) values (p_name)
     returning id into v;
  raise notice 'Создан лот "%" с id "%"', p_name, v;
  return v;
end
$$ language plpgsql;


----------------------------------------------------------------------------------
--  Получение id лота по наименованию
----------------------------------------------------------------------------------
--drop function if exists getUserIdByEmail(text);
create or replace function getLotIdByName(p_name text) returns int
as $$
declare
  v int;
begin
  select id into v from lot where name = p_name;
  return v;
exception
  when no_data_found then
    raise exception 'Не найден лот с названием %. ', p_name;
end
$$ language plpgsql;



----------------------------------------------------------------------------------
--  Создание аукциона для лота.
--  Возвращвет: lot_id нового аукциона
--  Пример: 
----------------------------------------------------------------------------------
create or replace function createAuction4Lot(p_lot_id int) returns int
as $$
declare
  v   int;
  cnt int;
begin
  select count(*) into cnt from auction where lot_id = p_lot_id;	
  if(cnt != 0) then
	raise exception 'Ошибка. Уже есть аукцион для лота(id) %.', p_lot_id;
  end if;
  insert into auction (lot_id) values (p_lot_id)
     returning id into v;
  raise notice 'Создан аукцион "%" для лота с id "%"', v, p_lot_id;
  return v;
end
$$ language plpgsql;



----------------------------------------------------------------------------------
--  Выводит информацию о бизнес-состоянии системы.
--  (логирование не пишется т.к. уровень логирования notice)
----------------------------------------------------------------------------------
create or replace function info() returns void
as $$
declare
    s1 text; s2 text; s3 text; s4 text;
begin
    select 'Пользователей в системе : '||count(*) into s1 from users;
    select 'Юр.лиц   в системе      : '||count(*) into s2 from corporate;
    select 'Физ.лиц  в системе      : '||count(*) into s3 from individual;
    select 'Профилей в системе      : '||count(*) into s4 from profile;
    raise notice '%',s1;
    raise notice '%',s2;
    raise notice '%',s3;
    raise notice '%',s4;
end
$$ language plpgsql;












--	Если пользователь с таким id не найден, то на все функции выбасывается исключение 
--  "Пользователь не найден"
--	Если пользователь с таким id блокирован, то на все функции выбасывается исключение 
--  "Пользователь заблокирован"
--	Если пользователь с таким id удален, то на все функции выбасывается исключение 
--  "Пользователь удален"
 
	
	
----------------------------------------------------------------------------------
--  Регистрация нового юзера
--  Возвращвет: user_id нового юзера
--  Исключения: выбрасывает исключение в случае ошибки
--  Пример: 
----------------------------------------------------------------------------------
create or replace function registerNewUser(p_first_name text
	, p_last_name text, p_email text, p_phone text, p_password_hash text) returns int
as $$
declare
  v int; cnt int;
begin
  -- проверка наличия такого 
  if(p_email is not null) then
	select count(*) into cnt from users where email = p_email;
	if(cnt != 0) then
		-- raise 'Уже существет пользователь с таким е-мэйлом %', p_email USING ERRCODE = 'unique_violation';
		raise exception using message=getMessage('ALREADY_EXIST_USER_WITH_E_MAIL'), ERRCODE = 'unique_violation';
	end if;
  end if;

  if(p_phone is not null) then
	select count(*) into cnt from users where phone = p_phone;
	if(cnt != 0) then
		-- raise 'Уже существет пользователь с таким таким номером телефона %', p_phone USING ERRCODE = 'unique_violation';
		raise exception using message=getMessage('ALREADY_EXIST_USER_WITH_PHONE'), ERRCODE = 'unique_violation';
	end if;
  end if;
  
  insert into users (first_name, last_name, email, phone, password_hash) values (
		 p_first_name, p_last_name, p_email, p_phone, p_password_hash)
    returning id into v;
  raise notice 'Создан пользователь с id "%"', v;
  return v;
end
$$ language plpgsql;

	
----------------------------------------------------------------------------------
--  Сохранение промо кода.
--  дата отправки будет текущей
--  Параметры:   p_user_id - id пользователя, p_code - код
--             , p_code_type - тип кода верификации ('E_MAIL' или 'PHONE')
--  Возвращвет: 
--  Исключения: выбрасывается исключение в случае ошибок (см выше) 
--                    если p_code null или '' "Неверно задан промо код"       
--  Пример: setEmailVerifCode(_user_id,'123456','E_MAIL');
--          setEmailVerifCode(_user_id,'123456','PHONE'); 
----------------------------------------------------------------------------------
create or replace function carl_auth.setVerifCode(p_user_id int, p_code varchar, p_code_type varchar) returns void
as $$
declare
	_id    int;
	_cnt   int;
	_vc_id int;
	_ct    en_verif_code_type;
	text_var1 text;
	text_var2 text;
	text_var3 text;	
	text_var4 text;	
begin

	begin
		_ct = p_code_type::en_verif_code_type;
	exception when others then
		raise exception using message=getMessage('VERIFY_CODE_BAD_TYPE')||p_code_type;
	end;
	
	/*
	select count(*) into _cnt from verify_code where user_id = p_user_id 
		and code_type::varchar = p_code_type;

	if(_cnt = 0) then
		raise exception using message=getMessage('VERIFY_CODE_NOT_FOUND')||'+'||p_code_type;
	end if;
	*/
	
	select id into _vc_id from verify_code where user_id = p_user_id 
		and code_type::varchar = p_code_type;
	
	if(_vc_id is null) then
		insert into verify_code (code_type, code, user_id) values 
			(p_code_type::en_verif_code_type, p_code, p_user_id) returning id into _id;
	else
		update verify_code set code = p_code, code_received = null, dt_received = null
			where id = _vc_id;
	end if;	
exception when others then	
  get stacked diagnostics text_var1 = message_text,
                          text_var2 = table_name,
                          text_var3 = schema_name,
						  text_var4 = pg_exception_context;
	---- raise notice 'Error code:%',SQLSTATE
	--if(sqlstate = '22P02'/*'23514'*/) then 
	--	raise exception using message=getMessage('VERIFY_CODE_BAD_TYPE')||'..'||p_code_type;
	--else
		raise exception using message=text_var1;
	--end if;	
	return;
end
$$ language plpgsql;
	

----------------------------------------------------------------------------------
--  Проверка кода подтверждения отправленного ранее.
--  Параметры:   p_user_id - id пользователя, p_code - код
--             , p_code_type - тип кода верификации ('E_MAIL' или 'PHONE')
--  Возвращвет 'Y' - если промо код совпадает и "не протух" 
--  Исключения: выбрасывается исключение в случае ошибок (см выше), 
--                    если p_code null или '' - "Неверно задан промо код"       
--  Пример: _ans = isVerifCodeCorrect(_user_id,'123456','E_MAIL');
----------------------------------------------------------------------------------
create or replace function carl_auth.isVerifCodeCorrect(p_user_id int
	, p_code varchar, p_code_type varchar) returns varchar(1) 
as $$
declare
	_code    varchar;
	_dt_send timestamp;
	_s       varchar;
	_ct      en_verif_code_type;
begin
	begin
		_ct = p_code_type::en_verif_code_type;
	exception when others then
		raise exception using message=getMessage('VERIFY_CODE_BAD_TYPE')||p_code_type;
	end;
	-- есть код?
	select vc.code, vc.dt_send into _code, _dt_send from verify_code vc where vc.user_id = p_user_id
		and vc.code_type::varchar = p_code_type;
	-- raise notice '_code %',_code;	
	if(_code is null) then
		--raise exception 'Не найден код подтверждения. Код не был отправлен?';
		raise exception using message=getMessage('VERIFY_CODE_NOT_FOUND');
	end if;	
	-- не "протух"?
	if(_dt_send < (now() - interval '24 hours')) then
		-- raise exception 'Превышено время ожидания кода подтверждения.';
		raise exception using message=getMessage('VERIFY_CODE_TIMEOUT');
	end if;
	-- совпадает?
	if(p_code = _code) then
		-- записываем время получения
		update verify_code vc set dt_received=now() where vc.user_id = p_user_id
			and vc.code_type::varchar = p_code_type;
		return 'Y';
	else
		-- записываем последний (неверный код) и время получения
		update verify_code vc set dt_received=now(), code_received=p_code where vc.user_id = p_user_id
			and vc.code_type::varchar = p_code_type;
		return 'N';
	end if;	
end
$$ language plpgsql;
	
	
----------------------------------------------------------------------------------
--  Выставляет статус пользователя
--  Возвращвет: 
--  Исключения: 
--  Пример: setUserStatus(_user_id,'GUEST');
----------------------------------------------------------------------------------
create or replace function carl_auth.setUserStatus(p_user_id int, p_status varchar) returns void
as $$
declare
begin
	update users set status=p_status where id=p_user_id;
end
$$ language plpgsql;
	


----------------------------------------------------------------------------------
--  Запись сообщения системы для кода и локализации
--  Возвращвет: текст сообщения
--  Исключения: выбрасывается исключение в случае ошибок
--  Пример: setMessage('NO_MESSAGE_FOR_CODE','Нет собщения для кода %','RU');
----------------------------------------------------------------------------------
create or replace function carl_comm.setMessage(p_code varchar
	, p_text varchar, p_locale varchar default 'RU') returns void
as $$
declare
	_cnt int = 0;
begin
/*
	insert into message (code, text, locale) values (p_code, p_text, p_locale)
		on conflict (code, locale) do update
		set text = p_text;
*/
	select count(*) into _cnt from message where code=p_code and locale=p_locale;
	if(_cnt = 0) then 
		insert into message (code, text, locale) values (p_code, p_text, p_locale);
	else
		update message set code=p_code, text=p_text, locale=p_locale 
			where code=p_code and locale=p_locale;
	end if;
--exception when no_data_found then
--	raise exception 'Нет собщения для кода %s',p_code;	
end
$$ language plpgsql;


----------------------------------------------------------------------------------
--  Получение сообщения системы по коду для локализации
--  Возвращвет: текст сообщения
--  Исключения: выбрасывается исключение в случае ошибок, 
--                  "Нет собщения для кода %"
--  Пример: getMessage('NO_MESSAGE_FOR_CODE','RU');
----------------------------------------------------------------------------------
create or replace function carl_comm.getMessage(p_code varchar, p_locale varchar default 'RU') returns text
as $$
declare
	_text varchar;
begin
	select text into _text from message where code = p_code and locale = p_locale; 
	return _text;
exception when no_data_found then
	raise exception 'Нет собщения для кода %s',p_code;	
end
$$ language plpgsql;



----------------------------------------------------------------------------------
--  Генерация последовательности случайных букв
--  Возвращвет: текст сообщения
--  Исключения: 
--  Пример: 
----------------------------------------------------------------------------------
create or replace function carl_comm.random_text(len integer) returns text as $$
        select string_agg(chr(trunc(65+random()*26)::integer),'') from generate_series(1,$1);
$$ language sql;


select setMessage('NO_MESSAGE_FOR_CODE','Нет собщения для кода %','RU');
select setMessage('VERIFY_CODE_NOT_FOUND','Не найден код подтверждения. Код не был отправлен?');	
select setMessage('VERIFY_CODE_TIMEOUT','Превышено время ожидания кода подтверждения.');	
select setMessage('VERIFY_CODE_BAD_TYPE','Неверный тип кода верификации: ');

select setMessage('ALREADY_EXIST_USER_WITH_E_MAIL','Уже существет пользователь с таким е-мэйлом.');
select setMessage('ALREADY_EXIST_USER_WITH_PHONE','Уже существет пользователь с таким таким номером телефона.');

/*--------------------------------------------------------------------------------
	exception
        when no_data_found then
            raise exception 'employee % not found', myname;
        when too_many_rows then
            raise exception 'employee % not unique', myname;
----------------------------------------------------------------------------------*/

