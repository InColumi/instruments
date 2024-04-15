import os
import shutil
from config import config
from functools import wraps
from app.work_with_db import Excecutor

def json_wrapper(foo):
    @wraps(foo)
    def wrapper(*args, **kwargs):
        return f"select json_agg(row_to_json(row)) from ({foo(*args, **kwargs)}) row"
    return wrapper

@json_wrapper
def create_sql_query(schema: str, limit: int = None) -> str:
    return f"""
        select
            p.proname
        ,	pg_get_functiondef(p.oid)||';\n' body
        ,	case when obj_description(p."oid") is not null then concat('comment on function ', n.nspname, '.',p.proname ,'(',r.data_type,') is ''', obj_description(p."oid") , ''';') else null end "comment"
        ,	p.prokind
        ,	p.proargnames
        ,	cardinality(p.proargnames)
        from 
            pg_catalog.pg_namespace n
        inner join pg_catalog.pg_proc p on p.pronamespace = n.oid
        left join information_schema.routines r on r.routine_name = p.proname
        where 1=1
            and r.external_language != 'C'
            and n.nspname = '{schema}'
        order by p.proname {'' if limit is None else f' limit {limit}'}"""

def get_params(body: str):
    return body[body.find('(') + 1: body.find(')')]

def cut_long_name(name: str):
    print(f'WARNING : "{name}" more then 255 symbols')
    end = '...).sql'
    return ''.join([name[:255 - len(end)], end])

def save_schema(schema: str, path):
    sql = create_sql_query(schema)
    data = Excecutor.excecute_raw_fetchone(sql)[0]
    for item in data:
        params = get_params(item['body'])
        file_name = ''.join([item['proname'], '(', params, ')', '.sql'])
        if len(file_name) > 255:
            file_name = cut_long_name(file_name)
        new_path_file = os.path.join(path, file_name)
        with open(new_path_file, 'w') as file:
            file.write(item['body'])
            file.write('\n')
            if item['comment']:
                file.write(item['comment'])


def main():
    schemes = ['logs', 'public', 'reports']
    for schema in schemes:
        path = os.path.join(config.DIR_FOR_TRACKING_CHANGES, schema)
        if os.path.isdir(path):
            shutil.rmtree(path)
        os.mkdir(path)
        save_schema(schema, path)



if __name__ == '__main__':
    main()
