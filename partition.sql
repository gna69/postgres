-- Суммарный размер всех баз данных
select pg_size_pretty(sum(pg_database_size(datname))) from pg_database;

-- Размер БД по имени
select pg_size_pretty( pg_database_size( 'postgres' ) );

-- Размер таблицы (только данные)
select pg_size_pretty(pg_relation_size('Task'));

-- Размер таблицы (включая индексы и другие связанные с ней пространства)
select pg_size_pretty(pg_total_relation_size('Task'));

-- Размер столбца
select pg_column_size('Task_Code') from Task;

-- секционирование средствами postgres
create table Logs(
    Log serial,
    Time TIMESTAMP,
    Action varchar(100)
)partition by range (Log);


select insert(1000000);
create table Logs1_250000 partition of Logs for values from (1) to (250001);
create table Logs250001_500000 partition of Logs for values from (250001) to (500001);
create table Logs500001_750000 partition of Logs for values from (500001) to (750001);
create table Logs750001_1000000 partition of Logs for values from (750001) to (1000001);

-- собственная реализация
create table Logs1(
    Log serial,
    Time TIMESTAMP,
    Action varchar(100)
);

create table Logs1_1(
    Log serial,
    Time TIMESTAMP,
    Action varchar(100)
)inherits (Logs1);

create table Logs1_2(
    Log serial,
    Time TIMESTAMP,
    Action varchar(100)
)inherits (Logs1);


-- функция заполнения таблицы
create function insert(int)
returns void as $$
declare
   i int := 0;
   min int := 0;
begin
   loop
      exit when i = $1;
      i := i + 1;
      insert into Logs values (default,  clock_timestamp(), 'qwerty');
   end loop;
end;
$$ language plpgsql;

-- заполнение таблицы с секционированием
create function insert(int)
returns void as $$
declare
   i int := 0;
   min int := 0;
begin
   loop
      exit when i = $1;
      i := i + 1;
      insert into Logs values (default,  clock_timestamp(), floor(random()*(100000-1+1))+1);
   end loop;
end;
$$ language plpgsql;


