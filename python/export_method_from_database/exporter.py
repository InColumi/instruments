import os
import aiofiles
from database import Executor
from dataclasses import dataclass

@dataclass
class Exporter:
    __excecutor: Executor
    __white_list_schema: tuple = tuple()
    __white_list_methods: tuple = tuple()
    __black_list_schema: tuple = tuple()
    __blask_list_methods: tuple = tuple()

    @classmethod
    def __create_sql_query(cls, schema: str, limit: int = None) -> str:
        slq = f"""
            select
                p.proname
            ,	pg_get_functiondef(p.oid)||';\n' body
            ,	case when obj_description(p."oid") is not null 
                        then concat('comment on function ', n.nspname, '.',p.proname ,'(',r.data_type,') is ''', obj_description(p."oid") , ''';') 
                        else null 
                end "comment"
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

        return f"select json_agg(row_to_json(row)) from ({slq}) row"

    @staticmethod
    def __get_params(body: str):
        return body[body.find('(') + 1: body.find(')')]

    @staticmethod
    def __cut_long_name(name: str):
        print(f'WARNING : "{name}" more then 255 symbols')
        end = '...).sql'
        return ''.join([name[:255 - len(end)], end])

    async def __save_schema(self, schema: str, path):
        sql = self.__create_sql_query(schema)
        data = self.__excecutor.excecute_raw_fetchone(sql)[0]
        for item in data:
            params = self.__get_params(item['body'])
            file_name = ''.join([item['proname'], '(', params, ')', '.sql'])
            if len(file_name) > 255:
                file_name = self.__cut_long_name(file_name)
            new_path_file = os.path.join(path, file_name)
            async with aiofiles.open(new_path_file, 'w') as file:
                await file.write(item['body'])
                await file.write('\n')
                if item['comment']:
                    await file.write(item['comment'])

    async def export(self, path_to_save: str):
        import shutil
        for schema in self.__white_list_schema:
            path = os.path.join(path_to_save, schema)
            print(path)
            if os.path.isdir(path):
                shutil.rmtree(path)
            os.makedirs(path, exist_ok=True)
            await self.__save_schema(schema, path)
