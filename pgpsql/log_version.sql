CREATE SCHEMA logs;

CREATE TABLE logs.method_history (
	id serial,
	date_create timestamp NULL,
	schema_name text NULL,
	function_name text NULL,
	tag text NULL,
	function_body text NULL,
	CONSTRAINT function_log_pk PRIMARY KEY (id)
);

CREATE RULE forbid_update_fun_logs AS
    ON UPDATE TO logs.method_history DO INSTEAD NOTHING;
    
create or replace function logs.write_method_history()
    returns event_trigger
    language plpgsql
as $function$
begin
    insert into log_versions.versions(date_create, schema_name, function_name, tag, function_body)
    select now(), nspname, proname, command_tag, pg_get_functiondef(p.oid)
    from pg_event_trigger_ddl_commands() e
    join pg_proc p on p.oid = e.objid
    join pg_namespace n on n.oid = pronamespace;
end
$function$;

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