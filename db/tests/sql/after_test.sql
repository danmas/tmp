/*
drop table if exists cats;
create table cats (
    id serial,
    cname varchar(20),
    ctype varchar(20),
    primary key(id)
);
create index c1 on cats(ctype);

drop sequence if exists ss;
create sequence ss;
 
insert into cats (cname, ctype)
    select
        substring(md5(random()::text), 0, 20),
        (array['big furry', 'small red', 'long tail', 'crafty hunter', 'sudden danger', 'sleeper-eater'
			   , 'black eye', 'sharp claw', 'neko', null])[nextval('ss') % 10 + 1]
    from
        generate_series(1, 25);


drop type if exists cat_type;		
create type cat_type as enum ('big furry', 'small red', 'long tail',
                              'crafty hunter', 'sudden danger', 'sleeper-eater'
							  , 'black eye', 'sharp claw', 'neko');
alter table cats alter column ctype type cat_type using ctype::cat_type;
*/
