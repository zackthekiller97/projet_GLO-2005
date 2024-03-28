from flask import Flask, render_template, Response, request

from database import Database

app = Flask(__name__)
ProfileUtilisateur = {}
connexionApprouvee = False
tableType = "films"

database = Database()

def fetchTableData(table, nomfilm, genre, sousgenre, annee, acteur, nbvote, note, saison):
    table_dict = {
        "columns": database.get_table_columns(table),
        "entries": database.get_table_data(table, nomfilm,genre,sousgenre,annee,acteur,nbvote,note, saison)
    }
    return table_dict

def fetchTableDataUser(table, nomfilm, genre, sousgenre, annee, acteur, nbvote, note, saison, username):
    table_dict = {
        "columns": database.get_table_columns(table),
        "entries": database.get_table_data_user(table, nomfilm,genre,sousgenre,annee,acteur,nbvote,note, saison, username)
    }
    return table_dict

def fetchTableDataResearch(table, nomfilm):
    table_dict = {
        "entries": database.get_table_data_research(table, nomfilm)
    }
    return table_dict

@app.route("/")
def main():
    return render_template('connexion.html')

@app.route("/login", methods={'POST'})
def connexion():
    username = '"'+request.form.get('username')+'"'
    mdp = request.form.get('password')
    cmd='SELECT motDePasse FROM utilisateurs WHERE nomUtilisateur = '+username+';'
    passeVrai = database.verifyConnexion(cmd)
    if (passeVrai != None) and (mdp==passeVrai[0]):
        cmd2 = 'SELECT * FROM utilisateurs WHERE nomUtilisateur = '+username+';'
        info = database.verifyConnexion(cmd2)
        global ProfileUtilisateur
        ProfileUtilisateur["username"]=username
        ProfileUtilisateur["role"]=info[2]
        global connexionApprouvee
        connexionApprouvee = True
        genres = database.select_genres()
        global tableType
        tableType = "films"
        table = fetchTableData(tableType,"","","","","","0","0.0","")
        return render_template('accueil.html', profile=ProfileUtilisateur, genres=genres, table=table, type=tableType)
    return render_template('connexion.html', message="NOM D'UTILISATEUR OU MOT DE PASSE INVALIDE")

@app.route("/inscription", methods={'POST'})
def inscription():
    username = '"' + request.form.get('username') + '"'
    mdp = request.form.get('password')
    cmd='SELECT nomUtilisateur FROM utilisateurs WHERE nomUtilisateur = '+username+';'
    utilisateurPresent = database.verifyConnexion(cmd)
    if (utilisateurPresent == None):
        cmd2 = f"INSERT INTO utilisateurs VALUES ('{username}', '{mdp}', 'user')"
        database.addValuestoDb(cmd2)
        global ProfileUtilisateur
        ProfileUtilisateur["username"]=username
        ProfileUtilisateur["role"]='user'
        global connexionApprouvee
        connexionApprouvee = True
        global tableType
        tableType = "films"
        genres = database.select_genres()
        table = fetchTableData(tableType,"","","","","","0","0.0","")
        return render_template('accueil.html', profile=ProfileUtilisateur, genres=genres, table=table, type=tableType)
    return render_template('inscription.html', message="NOM D'UTILISATEUR DÉJÀ EXISTANT")

@app.route("/inscription")
def inscriptionpage():
    return render_template('inscription.html')

@app.route("/connexion")
def connexionpage():
    return render_template('connexion.html')

@app.route("/accueil")
def accueilPage():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        global tableType
        tableType = "films"
        genres = database.select_genres()
        table = fetchTableData(tableType, "", "", "", "", "", "0", "0.0", "")
        return render_template('accueil.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

@app.route("/accueilSeries")
def accueilSeries():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        genres = database.select_genres()
        global tableType
        tableType = "series"
        table = fetchTableData(tableType, "", "", "", "", "", "0", "0.0", "")
        return render_template('accueil.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

@app.route('/filtrer', methods={'POST'})
def filtrerfilmsseries():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        nomFilm = request.form.get('nomfilm')
        genre = request.form.get('genres')
        sgenre = request.form.get('sgenres')
        annee = request.form.get('annee')
        acteur = request.form.get('acteur')
        nbvote = request.form.get('nbvotes')
        note = request.form.get('note')
        saison = request.form.get('saison')
        global tableType
        genres = database.select_genres()
        print(tableType,nomFilm,genre,sgenre,annee,acteur,nbvote,note,saison)
        table = fetchTableData(tableType, nomFilm, genre, sgenre, annee, acteur, nbvote, note, saison)
        return render_template('accueil.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

@app.route('/monclassement')
def monclassementFilms():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        genres = database.select_genres()
        global tableType
        tableType = "films"
        print(ProfileUtilisateur["username"])
        table = fetchTableDataUser(tableType, "", "", "", "", "", "0", "0.0", "", ProfileUtilisateur["username"])
        return render_template('monclassement.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

@app.route('/monclassementSeries')
def monclassementSeries():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        genres = database.select_genres()
        global tableType
        tableType = "series"
        table = fetchTableDataUser(tableType, "", "", "", "", "", "0", "0.0", "", ProfileUtilisateur["username"])
        return render_template('monclassement.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

@app.route('/filtrerUser', methods={'POST'})
def filtrerfilmsseriesUser():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        nomFilm = request.form.get('nomfilm')
        genre = request.form.get('genres')
        sgenre = request.form.get('sgenres')
        annee = request.form.get('annee')
        acteur = request.form.get('acteur')
        nbvote = request.form.get('nbvotes')
        note = request.form.get('note')
        saison = request.form.get('saison')
        global tableType
        genres = database.select_genres()
        print(tableType,nomFilm,genre,sgenre,annee,acteur,nbvote,note,saison)
        table = fetchTableDataUser(tableType, nomFilm, genre, sgenre, annee, acteur, nbvote, note, saison, ProfileUtilisateur["username"])
        return render_template('monclassement.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

@app.route('/logout')
def logout():
    global connexionApprouvee
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        connexionApprouvee = False
        global ProfileUtilisateur
        ProfileUtilisateur = {}
        return render_template('connexion.html')

@app.route("/rechercher")
def rechercher():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        global tableType
        tableType = "films"
        table={}
        return render_template('rechercher.html', type=tableType, table=table, profile=ProfileUtilisateur)

@app.route("/rechercherSeries")
def rechercherSeries():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        global tableType
        tableType = "series"
        table={}
        return render_template('rechercher.html', type=tableType, table=table, profile=ProfileUtilisateur)

@app.route("/rechercherFilmSerie", methods={'POST'})
def rechercherFilmSerie():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        nomFilm = request.form.get('nomfilm')
        global tableType
        table = fetchTableDataResearch(tableType, nomFilm)
        return render_template('rechercher.html', table=table, type=tableType, profile=ProfileUtilisateur)

@app.route("/infoFilmSerie", methods={'POST'})
def infoFilmSerie():
    nom = request.args.get('nom')

if __name__ == "__main__":
    app.run()