from config import config
import asyncio
from exporter import Exporter
from database import DatabaseEgine, Executor


async def export(schemes: tuple, uri: str, path_to_save: str):
    engine_medaccount = DatabaseEgine().get_engine(uri)
    executor = Executor(engine_medaccount)
    await Exporter(executor, schemes).export(path_to_save)

async def main():
    schemes_medaccount = ('logs', 'public', 'reports', 'wadm')

    await export(schemes_medaccount,
                 config.MEDACCOUNT_DATABASE_URI,
                 config.MEDACCOUNT_DIR_FOR_TRACKING_CHANGES)

    schemes_reest_llo = ('frllo', 'zayavka')

    await export(schemes_reest_llo,
                 config.REESTR_LLO_DATEBASE_URI,
                 config.REESTR_LLO_DIR_FOR_TRACKING_CHANGES)


if __name__ == '__main__':
    asyncio.run(main())
