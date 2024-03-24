import os

import pymysql
from dotenv import load_dotenv

from sql_utils import run_sql_file


class Database:
    def __init__(self):
        load_dotenv()
        self.host = os.environ.get("HOST")
        self.port = int(os.environ.get("PORT"))
        self.database = os.environ.get("DATABASE")
        self.user = os.environ.get("USER")
        self.password = os.environ.get("PASSWORD")

        self._open_sql_connection()

        self.migration_counter = 0

    def _open_sql_connection(self):
        self.connection = pymysql.connect(
            host=self.host,
            port=self.port,
            user=self.user,
            password=self.password,
            db=self.database,
            autocommit=True
        )

        self.cursor = self.connection.cursor()

    def verifyConnexion(self, req):
        self.cursor.execute(req)
        return self.cursor.fetchone()

    def addValuestoDb(self, req):
        self.cursor.execute(req)