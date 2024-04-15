"""Работа с БД."""
from config import config
from sqlalchemy import create_engine, text
from sqlalchemy.exc import DisconnectionError


__all__ = ['Excecutor']


class DatabaseEgine:
    """Подлючение к БД и создание подлючения."""

    @classmethod
    def get_connection(cls):
        """Подлючение к БД и создание подлючения."""
        try:
            print('Start connection')
            connect = create_engine(config.SQLALCHEMY_DATABASE_URI).connect()
            print('Connected success')
        except DisconnectionError as err:
            raise Exception(f'OperationalError: {err}')
        except KeyError as err:
            raise Exception('Check config', str(err))
        except Exception as e:
            raise Exception(f'Database connection error... Details: {str(e)}')
        else:
            return connect


class Excecutor:
    """Исполнитель sql строк."""

    def __new__(cls):
        """При создании нового объекта. Проверить."""
        if not hasattr(cls, 'instance'):
            cls.instance = super(Excecutor, cls).__new__(cls)
        return cls.instance

    @classmethod
    def excecute_raw_fetchone(cls, sql: str):
        """Сырое выполенние sql строки."""
        with DatabaseEgine.get_connection() as connection:
            try:
                return connection.execute(text(sql)).fetchone()
            except Exception as e:
                print('Excecutor', str(e))
                exit()

