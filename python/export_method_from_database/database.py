from dataclasses import dataclass
from abc import ABC, abstractmethod
from sqlalchemy import create_engine, text, Engine
from sqlalchemy.exc import DisconnectionError

class DatabaseEgineBase(ABC):

    @classmethod
    @abstractmethod
    def get_engine(cls, database_uri: str):
        pass

class DatabaseEgine(DatabaseEgineBase):
    """Подлючение к БД и создание подлючения."""

    @classmethod
    def get_engine(cls, database_uri: str):
        """Подлючение к БД и создание подлючения."""
        try:
            print('Start connection')
            connect = create_engine(database_uri)
            print('Connected success')
        except DisconnectionError as err:
            raise Exception(f'OperationalError: {err}')
        except KeyError as err:
            raise Exception('Check config', str(err))
        except Exception as e:
            raise Exception(f'Database connection error... Details: {str(e)}')
        else:
            return connect


@dataclass
class Executor:

    __engine: Engine
    """Исполнитель sql строк."""

    def excecute_raw_fetchone(self, sql: str):
        """Сырое выполенние sql строки."""
        with self.__engine.connect() as connection:
            try:
                return connection.execute(text(sql)).fetchone()
            except Exception as e:
                connection.close()
                print('Excecutor', str(e))
