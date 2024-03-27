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

    def select_genres(self):
        self.cursor.execute("SELECT * FROM genres")
        genres = [x[0] for x in self.cursor.fetchall()]
        return genres

    def get_table_columns(self, table):
        self.cursor.execute(f"SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '{table}' AND TABLE_SCHEMA = '{self.database}' ORDER BY ORDINAL_POSITION;")
        res = [x[0] for x in self.cursor.fetchall()]
        return res

    def get_table_data(self, table, nomfilm,genre,sousgenre,annee,acteur,nbvote,note, saison):
        if (table == "films") :
            req = f"CALL filtrerFilms('%{nomfilm}%', '%{genre}%', '%{sousgenre}%', '%{annee}%', '%{acteur}%', {nbvote}, {note})"
        else :
            req = f"CALL filtrerSeries('%{nomfilm}%', '%{genre}%', '%{sousgenre}%', '%{annee}%', '%{acteur}%', '%{saison}%', {nbvote}, {note})"

        self.cursor.execute(req)

        return [list(x) for x in self.cursor.fetchall()]

    def get_table_data_user(self, table, nomfilm,genre,sousgenre,annee,acteur,nbvote,note, saison, username):
        if (table == "films") :
            req = f"CALL filtrerFilmsUtilisateur('%{nomfilm}%', '%{genre}%', '%{sousgenre}%', '%{annee}%', '%{acteur}%', {nbvote}, {note}, {username})"
        else :
            req = f"CALL filtrerSeriesUtilisateur('%{nomfilm}%', '%{genre}%', '%{sousgenre}%', '%{annee}%', '%{acteur}%', '%{saison}%', {nbvote}, {note}, {username})"

        self.cursor.execute(req)

        return [list(x) for x in self.cursor.fetchall()]

    def get_table_data_research(self, table, nomfilm):
        if (table == "films") :
            req = f"CALL rechercherFilms('%{nomfilm}%')"
        else :
            req = f"CALL rechercherSeries('%{nomfilm}%')"

        self.cursor.execute(req)

        return [list(x) for x in self.cursor.fetchall()]