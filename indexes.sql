create table T1 (
	F1 int, 
	F2 varchar(80)
);

create table T2 (
	F1 int, 
	F2 varchar(80)
);
-- индекс
create index T2_F1_i on T2(F1);

create table T3 (
	F1 int, 
	F2 varchar(80)
);

-- уникальный индекс
create unique index T3_F1 on T3(F1);

create table T4 (
	F1 int, 
	F2 varchar(80)
);

-- индекс по выражению
create index T4_F1 on T4(lower(F2));

create function for_T5(x int) returns int as $$
begin
	if mod(x, 1) = 0
	then return 1 + x;
 	else return 1 - x;
	end if;
end;
$$ language plpgsql immutable;

create table T5 (
	F1 int, 
	F2 varchar(80)
);

-- индекс по функции
create index T5_F1 on T5(for_T5(F1));

-- Функции вставки значений в таблицы

create function random_text()
returns text as $$
declare 
  possible_chars text := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  output text := '';
  i int;
  chars_size int;
begin
  chars_size := length(possible_chars);
  for i in 1..(floor(random()*(5-1+1))+1) loop 
    output := output || substr(
      possible_chars,
      (1 + floor((chars_size + 1) * random() ))::int, 1);
  end loop ;
  return output;
end;
$$ language plpgsql;



create function insert(stop int)
returns void as $$
declare
   i int := 0;
   min int := 0;
    rand_int int := 0;
    rand_text varchar := 0;
begin
   loop
      exit when i = stop;
      i := i + 1;
      min := 0;
      rand_int := floor(random()*(100000-1+1))+1;
      rand_text := random_text();
      insert into T1 values (rand_int, rand_text);
      insert into T2 values (rand_int, rand_text);
   end loop;
end;
$$ language plpgsql;

-- Функция замера времени выполнения 100 обращений к таблице (аналогично для Т2)

create  function time_of_select_T1(stop int)
returns text as $$
declare
    start timestamp;
    stopp interval;
begin
    start := clock_timestamp();
    for i in 1 .. stop
    loop
        perform F1 from T1 where F1 > 9 and F1 < 19999;
    end loop;
    stopp := clock_timestamp() - start;
    return(stopp);
end;
$$ language plpgsql;


-- Функция замера времени выполнения вставки (аналогично для всех таблиц)


create  function time_of_insert_T1(count int)
returns text as $$
declare
    start timestamp;
    stopp interval;
begin
    start := clock_timestamp();
    perform insert_T1(count);
    stopp := clock_timestamp() - start;
    return(stopp);
end;
$$ language plpgsql;


-- Функция замера времени выполнения обновления (аналогично для всех таблиц)

create  function time_of_update_T5()
returns text as $$
declare
    start timestamp;
    stopp interval;
begin
    start := clock_timestamp();
    update T5
        set F1 = F1 - 9;
    stopp := clock_timestamp() - start;
    return(stopp);
end;
$$ language plpgsql;


