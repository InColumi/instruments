from dataclasses import dataclass
from abc import ABC, abstractmethod
from sqlalchemy import create_engine, text
from sqlalchemy.exc import DisconnectionError

class DatabaseEgineBase(ABC):

    @classmethod
    @abstractmethod
    def get_connection(cls, database_uri: str):
        pass

class DatabaseEgine(DatabaseEgineBase):
    """Подлючение к БД и создание подлючения."""

    @classmethod
    def get_connection(cls, database_uri: str):
        """Подлючение к БД и создание подлючения."""
        try:
            print('Start connection')
            connect = create_engine(database_uri).connect()
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

    __connection: DatabaseEgineBase
    """Исполнитель sql строк."""

    def excecute_raw_fetchone(self, sql: str):
        """Сырое выполенние sql строки."""
        with self.__connection as connection:
            try:
                yield connection.execute(text(sql)).fetchone()
                connection.close()
            except Exception as e:
                print('Excecutor', str(e))
