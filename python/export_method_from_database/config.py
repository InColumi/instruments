"""Config application."""
from pydantic_settings import BaseSettings

__all__ = ['config']


class Settings(BaseSettings):
    SQLALCHEMY_DATABASE_URI: str
    DIR_FOR_TRACKING_CHANGES: str

    class Config:
        env_file = '.env'


try:
    config = Settings()
except Exception as err:
    print('Config err: ', str(err))
    exit()
