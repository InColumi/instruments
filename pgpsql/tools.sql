select pg_sleep(10);

select p.query, p.query_start, p.state_change, (p.state_change - p.query_start) diff, p.client_addr, p.*
from pg_catalog.pg_stat_activity p
where p.client_addr = '192.168.0.144'
order by p.pid

select p.client_addr, count(1)
from pg_catalog.pg_stat_activity p
where p.state = 'idle in transaction'
group by p.client_addr 
order by p.client_addr 



sele
ct 

select * 
from pg_stat_activity
where (state = 'idle in transaction')
    and xact_start is not null
    

select 1
--,	pg_terminate_backend(p.pid)
,	p.query
,	* 
from pg_stat_activity p
where 1=1
	and p.datname = 'reest_llo' 
	and p.pid <> pg_backend_pid()
	and p.state = 'active'

    
select 
	pg_column_size(row()) s
,	pg_column_size(row('01.01.2023'::timestamp))
--,	pg_column_size(row(0::bigint, 0::bool))
--,	pg_column_size(row(0::int, '1e328189-aa1e-4251-9473-785c283f8632'::uuid))
--,	pg_column_size(row())



select pg_column_size(row(
	'1e328189-aa1e-4251-9473-785c283f8632'::uuid
,	0::float8
,	0::float8
,	0::float8
,	'01.01.2022'::timestamptz
,	0::int4
,	0::int4
,	0::int4
,	0::int4
,	'01.01.2022'::date
,	'01.01.2022'::date
,	'01.01.2022'::date
,	'01.01.2022'::date
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
,	''::varchar
))

show work_mem;

show from_collapse_limit;

SELECT a.attname, t.typname, t.typalign, t.typlen
  FROM pg_class c
  JOIN pg_attribute a ON (a.attrelid = c.oid)
  JOIN pg_type t ON (t.oid = a.atttypid)
WHERE c.relname = 'bt'
   AND a.attnum >= 0
 ORDER BY t.typlen desc;
 

select *
from pg_class 


select a.attname, t.typname, t.typalign, t.typlen
from pg_class c
inner join pg_catalog.pg_attribute a on a.attrelid = c.oid
inner join pg_type t ON t.oid = a.atttypid
where 1=1
	and c.relname = 'bt'
	and c.reltype = 13800667
	and a.attnum >= 0
order by t.typlen desc
	


SELECT datname FROM pg_database;

pg_size_pretty( pg_database_size('dbname')

select 
	datname
,	pg_size_pretty( pg_database_size(datname))
from pg_catalog.pg_database 

select public.crud_trzn('{
  "action": "read",
  "tradenmr": "a",
  "drugid_int": ""
}')




























	

































