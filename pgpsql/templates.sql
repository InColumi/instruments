CREATE OR REPLACE FUNCTION SCHEMA.CRUD_(json_input json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
declare 
	_res			json;
	_message_info	text;
	_current_schema	text;
	
	_action			text;
	_s				text;
	
begin 
	begin	
		
				
		if _action is null 
		then
			raise exception '';
		end if;
	
		if _action = 'create'
		then

			_res = public.create_log_info(status=>2, message=>'Не реализован!');
		elsif _action = 'read'
		then
			
			raise notice '%', _s;
			_s = concat('select json_agg(row_to_json(row)) from(', _s,' ) row');
			_res = public.create_log_info(status=>0, log_data=>_res);
		elsif _action = 'update' or _action = 'delete'
		then
			if exists (select 1)
			then
				if _action = 'update'
				then
									
					_res = public.create_log_info(status=>2, message=>'Не реализован!');
				else 
						
					_res = public.create_log_info(status=>2, message=>'Не реализован!');
				end if;
			else

				raise exception 'Ключ: (%) отсутствует в таблице', _id;
			end if;		
		else
			raise exception 'action принимает недопустимое значени (%)', _action;
		end if;
							
		exception when others 
		then
			get stacked diagnostics _message_info = message_text;

		    _res = public.create_log_info(status=>1, message=>_message_info);
		end;
	return _res;
end

$function$
;

CREATE OR REPLACE FUNCTION SCHEMA.NAME(json_input json)
 RETURNS json
 LANGUAGE plpgsql
AS $function$
declare 
	_res			json;
	_message_info	text;

	_sql_query		text;
begin 
	begin
		
		
							
	exception
	when others 
	then
		get stacked diagnostics _message_info = message_text;
	    _res = public.create_log_info(status=>1, message=>_message_info);
	end;
return _res;
end

$function$
;



do $$
declare
	_test json = '{
	  "date_start": "2024-08-15T15:10:53+03:00",
	  "date_end": "2024-09-04T15:10:53+03:00",
	  "demand_head_id": "",
	  "action": "read"
	}';

	_s		text;
	_key	text;
	_schema	text = 'public';
	_table	text = 'panov_t';
	_fields	text;

	_fields_for_udate	text[];
begin 
	with keys as (
		select *
		from jsonb_object_keys('{
			"date_start": "2024-08-15T15:10:53+03:00",
		  "date_end": "2024-09-04T15:10:53+03:00",
		  "demand_head_id": "",
		  "action": "read"
		}'::jsonb) val
		where val not in ('action', 'demand_head_id')
	)
	select array_agg(concat_ws(' = ',quote_ident(k.val), coalesce(nullif(_test->>k.val, ''), 'null')))
	into _fields_for_udate
	from keys k;
	
	_s = concat('
	update ', _schema, '.', _table, '
	set ', array_to_string(_fields_for_udate, ', '), ' where table_key=', '3333');

	raise notice '%', _s;
end $$







