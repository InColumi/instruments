CREATE SCHEMA logs;

-- logs.method_history definition

-- Drop table

-- DROP TABLE logs.method_history;

CREATE TABLE logs.method_history (
	id serial4 NOT NULL,
	date_create timestamp NULL DEFAULT now(),
	schema_name text NULL,
	function_name text NULL,
	tag text NULL,
	function_body text NULL,
	object_type text NULL,
	client_addr inet NOT NULL DEFAULT inet_client_addr(),
	application_name text NULL,
	proargtypes oidvector NULL,
	tg_tag text NULL,
	CONSTRAINT function_log_pk PRIMARY KEY (id)
);

-- Table Rules

-- DROP RULE forbid_update_fun_logs ON logs.method_history;

CREATE RULE forbid_update_fun_logs AS
    ON UPDATE TO logs.method_history DO INSTEAD NOTHING;

CREATE RULE forbid_update_fun_logs AS
    ON UPDATE TO logs.method_history DO INSTEAD NOTHING;
    
-- DROP FUNCTION logs.write_method_history();

CREATE OR REPLACE FUNCTION logs.write_method_history()
 RETURNS event_trigger
 LANGUAGE plpgsql
AS $function$
declare
  _row     record;
  _comment  text;
  _type_arg  text[];
  _proargtypes  oidvector;
  _comment_splitter  text  = '---';
begin  
  if tg_tag != 'COMMENT'
  then
    for _row in select 
            n.nspname
          ,  p.proname
          ,  e.command_tag
          ,  p.oid p_oid
          ,  e.object_type
          ,  p.proargtypes
          from pg_event_trigger_ddl_commands() e
          inner join pg_proc p on p.oid = e.objid
          inner join pg_namespace n on n.oid = p.pronamespace
    loop
      insert into logs.method_history(
        schema_name
      ,  function_name
      ,  tag
      ,  function_body
      ,  object_type
      ,  application_name
      ,  proargtypes
      ,  tg_tag
      )
         values( 
           _row.nspname
         ,  _row.proname
         ,  _row.command_tag
         ,  pg_get_functiondef(_row.p_oid)
         ,  _row.object_type
         ,  (select application_name from pg_stat_activity p where p.pid = pg_backend_pid() limit 1)
         ,  _row.proargtypes
         ,  tg_tag
         );
       
         if tg_tag in ('CREATE FUNCTION', 'ALTER FUNCTION', 'CREATE PROCEDURE', 'ALTER PROCEDURE')
         then
           select 
          concat('Date edit: ', to_char(now(), 'DD.MM.YYYY HH24:MI:SS:MS'), chr(10)
          ,  'Editor: ', inet_client_addr(), chr(10)
          ,  _comment_splitter,  chr(10)
          ,  right(d.description, length(d.description) - strpos(d.description, _comment_splitter) - length(_comment_splitter))
          )
        into _comment
        from pg_proc p
        left join pg_description d
        on d.objoid = p.oid
        where 1=1
          and p.proname = _row.proname;
        
        select p.proargtypes
        into _proargtypes
        from pg_catalog.pg_proc p
        where p.oid = _row.p_oid;
        
        with tp as (
          select * from unnest(_proargtypes) WITH ORDINALITY AS p(type_oid, num)
        )
        select array_agg(p.typname order by tp.num)
        into _type_arg
        from tp
        inner join pg_type p on p.oid = tp.type_oid;
      
        _comment = concat('comment on ', _row.object_type, ' '
          ,  _row.nspname, '.', _row.proname, '(', array_to_string(_type_arg, ', '), ')'
          ,  ' is ', quote_literal(_comment) 
        );    
      
        execute _comment;
         end if;
    end loop;
  end if;
end
$function$
;


create event trigger trigger_write_method_history
on ddl_command_end 
when tag in (
	'CREATE FUNCTION'
,	'ALTER FUNCTION'
,	'DROP FUNCTION'
,	'CREATE PROCEDURE'
,	'ALTER PROCEDURE'
,	'DROP PROCEDURE'
,	'CREATE TRIGGER'
,	'ALTER TRIGGER'
,	'DROP TRIGGER'
)
execute procedure logs.write_method_history();
