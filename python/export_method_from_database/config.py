"""Config application."""
from pydantic_settings import BaseSettings

__all__ = ['config']


class Settings(BaseSettings):
    MEDACCOUNT_DATABASE_URI: str
    MEDACCOUNT_DIR_FOR_TRACKING_CHANGES: str

    REESTR_LLO_DATEBASE_URI: str
    REESTR_LLO_DIR_FOR_TRACKING_CHANGES: str

    class Config:
        env_file = '/home/user/Desktop/Projects/instruments/python/export_method_from_database/.env'


try:
    config = Settings()
except Exception as err:
    print('Config err: ', str(err))
    exit()
