from flask import Flask, render_template, Response, request

from database import Database

app = Flask(__name__)
ProfileUtilisateur = {} #informations sur l'utilisateur connecté
connexionApprouvee = False #indique si l'utilisateur s'est connecté avant d'ouvrir d'autres pages (token)
tableType = "films" #type de table à choisir lors des requêtes (films ou séries)
filmChoisi = "" #film choisi lors de l'ouverture de la page infoFilm

database = Database()

#fonction qui permet d'aller chercher les données des Films ou Séries
def fetchTableData(table, nomfilm, genre, sousgenre, annee, acteur, nbvote, note, saison): #
    table_dict = {
        "entries": database.get_table_data(table, nomfilm,genre,sousgenre,annee,acteur,nbvote,note, saison)
    }
    return table_dict

#fonction qui permet d'aller chercher les données des Films ou Séries votés par l'utilisateur connecté
def fetchTableDataUser(table, nomfilm, genre, sousgenre, annee, acteur, nbvote, note, saison, username):
    table_dict = {
        "entries": database.get_table_data_user(table, nomfilm,genre,sousgenre,annee,acteur,nbvote,note, saison, username)
    }
    return table_dict

#fonction qui permet d'aller chercher les données des films ou des séries recherchés par l'utilisateur
def fetchTableDataResearch(table, nomfilm):
    table_dict = {
        "entries": database.get_table_data_research(table, nomfilm)
    }
    return table_dict

#fonction qui permet d'aller chercher les infos du film/série cliqué pour aller vers la page des informations de ce film/série
def fetchTableDataFilm(table, nomfilm):
    table_dict = {
        "entries": database.get_movieserie_data(table, nomfilm)
    }
    return table_dict

#fonction qui permet d'aller chercher le vote et le commentaire de l'utilisateur connecté sur un film/série s'il y en a un
def fetchUserVote(table, nomfilm, user):
    table_dict = {
        "entries": database.verifieVoteUser(user, nomfilm, table),
        "commentaire": database.get_comments_movieserieUser(table, (database.verifieVoteUser(user, nomfilm, table)[0][0] if database.verifieVoteUser(user, nomfilm, table)!=[] else ""))
    }
    return table_dict

#fonction qui permet d'aller les commentaires et leurs notes d'un film/série
def fetchCommentaires(table, nomfilm):
    table_dict = {
        "entries": database.get_comments_movieserie(table, nomfilm)
    }
    return table_dict

#route qui affiche la page de connexion du site
@app.route("/")
def main():
    return render_template('connexion.html')

#route qui vérifie la connection de l'utilisateur
@app.route("/login", methods={'POST'})
def connexion():
    username = '"'+request.form.get('username')+'"'
    mdp = request.form.get('password')
    cmd='SELECT motDePasse FROM utilisateurs WHERE nomUtilisateur = '+username+';'
    passeVrai = database.verifyConnexion(cmd)
    if (passeVrai != None) and (mdp==passeVrai[0]):
        cmd2 = 'SELECT * FROM utilisateurs WHERE nomUtilisateur = '+username+';'
        info = database.verifyConnexion(cmd2)
        global ProfileUtilisateur #on entre les infos de l'utilisateur dans la variable globale
        ProfileUtilisateur["username"]=username
        ProfileUtilisateur["role"]=info[2]
        global connexionApprouvee #on indique que l'utilisateur s'est connecté au site donc il peut ouvrir les autres pages
        connexionApprouvee = True
        genres = database.select_genres()
        global tableType #la table par défaut sera les films
        tableType = "films"
        table = fetchTableData(tableType,"","","","","","0","0.0","") #on va chercher les infos des films sans filtre spécifique
        return render_template('accueil.html', profile=ProfileUtilisateur, genres=genres, table=table, type=tableType)
    return render_template('connexion.html', message="NOM D'UTILISATEUR OU MOT DE PASSE INVALIDE") #on retourne un message d'erreur si les informations de connexion sont erronées

#route d'inscription d'un utilisateur
@app.route("/inscription", methods={'POST'})
def inscription():
    username = '"' + request.form.get('username') + '"'
    mdp = request.form.get('password')
    cmd='SELECT nomUtilisateur FROM utilisateurs WHERE nomUtilisateur = '+username+';'
    utilisateurPresent = database.verifyConnexion(cmd)
    if (utilisateurPresent == None):
        cmd2 = f"INSERT INTO utilisateurs VALUES ('{username}', '{mdp}', 'user')" #on insère le nouvel utilisateur dans la db
        database.addValuestoDb(cmd2)
        global ProfileUtilisateur #on entre les infos de l'utilisateur dans la variable globale
        ProfileUtilisateur["username"]=username
        ProfileUtilisateur["role"]='user'
        global connexionApprouvee #on indique que l'utilisateur s'est connecté au site donc il peut ouvrir les autres pages
        connexionApprouvee = True
        global tableType #la table par défaut sera les films
        tableType = "films"
        genres = database.select_genres()
        table = fetchTableData(tableType,"","","","","","0","0.0","") #on va chercher les infos des films sans filtre spécifique
        return render_template('accueil.html', profile=ProfileUtilisateur, genres=genres, table=table, type=tableType)
    return render_template('inscription.html', message="NOM D'UTILISATEUR DÉJÀ EXISTANT") #retourne un message d'erreur si l'utilisateur existe déjà

#route permettant d'afficher la page d'inscription
@app.route("/inscription")
def inscriptionpage():
    return render_template('inscription.html')

#route permettant d'afficher la page de connexion
@app.route("/connexion")
def connexionpage():
    return render_template('connexion.html')

#route permettant d'afficher la page d'accueil avec le classement des films
@app.route("/accueil")
def accueilPage():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        global tableType #on affiche les données de la table des films
        tableType = "films"
        genres = database.select_genres() #on va chercher la liste des genres de la db genres pour le futur filtrage
        table = fetchTableData(tableType, "", "", "", "", "", "0", "0.0", "") #on va chercher les infos des films sans filtre spécifique
        print(table)
        return render_template('accueil.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

#route permettant d'afficher la page d'accueil avec le classement des séries
@app.route("/accueilSeries")
def accueilSeries():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        genres = database.select_genres() #on va chercher la liste des genres de la db genres pour le futur filtrage
        global tableType #on affiche les données de la table des séries
        tableType = "series"
        table = fetchTableData(tableType, "", "", "", "", "", "0", "0.0", "") #on va chercher les infos des films sans filtre spécifique
        return render_template('accueil.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

#route permettant de filtrer des films ou des séries de la page d'accueil
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
        genres = database.select_genres() #on va chercher la liste des genres de la db genres pour le futur filtrage
        table = {}
        try: #on essaye d'aller chercher les films ou séries avec les filtres, si erreur on ne retourne aucune données et on indique à l'utilisateur (via la page html)
            table = fetchTableData(tableType, nomFilm, genre, sgenre, annee, acteur, nbvote, note, saison)
        except:
            table = {"entries" : []}
        return render_template('accueil.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

#route permettant d'afficher le classement des films de l'utilisateur
@app.route('/monclassement')
def monclassementFilms():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        genres = database.select_genres() #on va chercher la liste des genres de la db genres pour le futur filtrage
        global tableType
        tableType = "films"
        table = fetchTableDataUser(tableType, "", "", "", "", "", "0", "0.0", "", ProfileUtilisateur["username"]) #on va chercher les infos des films sans filtre spécifique
        return render_template('monclassement.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

#route permettant d'afficher le classement des séries de l'utilisateur
@app.route('/monclassementSeries')
def monclassementSeries():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        genres = database.select_genres() #on va chercher la liste des genres de la db genres pour le futur filtrage
        global tableType
        tableType = "series"
        table = fetchTableDataUser(tableType, "", "", "", "", "", "0", "0.0", "", ProfileUtilisateur["username"]) #on va chercher les infos des séries sans filtre spécifique
        return render_template('monclassement.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

#route permettant de filtrer les films/séries du classement de l'utilisateur
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
        genres = database.select_genres() #on va chercher la liste des genres de la db genres pour le futur filtrage
        table = {}
        try: #on essaye d'aller chercher les films ou séries avec les filtres, si erreur on ne retourne aucune données et on indique à l'utilisateur (via la page html)
            table = fetchTableDataUser(tableType, nomFilm, genre, sgenre, annee, acteur, nbvote, note, saison, ProfileUtilisateur["username"])
        except:
            table = {"entries": []}
        return render_template('monclassement.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

#route permettant à l'utilisateur de se déconnecter et de retourner à la page de connection
@app.route('/logout')
def logout():
    global connexionApprouvee
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        connexionApprouvee = False #on indique qu'aucun utilisateur n'est connecté sur le site
        global ProfileUtilisateur
        ProfileUtilisateur = {} #on reset la variable globale qui contenait les infos de l'utilisateur anciennement connecté
        return render_template('connexion.html')

#route permettant d'afficher la page de recherche de films
@app.route("/rechercher")
def rechercher():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        global tableType
        tableType = "films"
        table={} #par défaut aucun film n'est affiché dans les résultats de recherche
        return render_template('rechercher.html', type=tableType, table=table, profile=ProfileUtilisateur)

#route permettant d'afficher la page de recherche de séries
@app.route("/rechercherSeries")
def rechercherSeries():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        global tableType
        tableType = "series"
        table={} #par défaut aucune série n'est affiché dans les résultats de recherche
        return render_template('rechercher.html', type=tableType, table=table, profile=ProfileUtilisateur)

#route permettant de rechercher des films ou des séries
@app.route("/rechercherFilmSerie", methods={'POST'})
def rechercherFilmSerie():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        nomFilm = request.form.get('nomfilm')
        global tableType
        table = fetchTableDataResearch(tableType, nomFilm) #aucune erreur ne peut arriver ici, si le film n'existe pas, rien n'est retourné et la page l'indique à l'utilisateur (via le code html)
        return render_template('rechercher.html', table=table, type=tableType, profile=ProfileUtilisateur)

#route permettant d'afficher les infos d'un film ou d'une série
@app.route("/infofilm", methods={'GET', 'POST'})
def infoFilmSerie():
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        nom = request.args.get('nom')
        global filmChoisi
        filmChoisi = nom
        table = fetchTableDataFilm(tableType, nom) #impossible qu'il y ait d'erreur ici, le lien contient forcément l'id du film via son paramètre
        voteUser = fetchUserVote(tableType, nom, ProfileUtilisateur["username"]) #on va chercher le vote de l'utilisateur, s'il y en a aucun, on ne retourne rien
        commentaires = fetchCommentaires(tableType, nom) #on va chercher les commentaires du films, si aucun on ne retourne rien
        return render_template('infofilm.html', table=table, type=tableType, profile=ProfileUtilisateur, voteUser=voteUser, commentaires=commentaires)

#route permettant de voter un film ou une série
@app.route("/vote", methods={'POST'})
def vote():
    message = ""
    note = request.form.get('votefilm')
    if type(note) == str or (note < 0 or note > 10): #on vérifie que la note soit un chiffre valide entre 0 et 10
        table = fetchTableDataFilm(tableType, filmChoisi) #on va chercher les infos du film choisi
        voteUser = fetchUserVote(tableType, filmChoisi, ProfileUtilisateur["username"]) #on va chercher le vote et le commentaire de l'utilisateur
        commentaires = fetchCommentaires(tableType, filmChoisi) #on va chercher les commentaires du film ou de la série
        message = "Note invalide, veuillez entrer un chiffre (à virgule ou non) entre 0 et 10" #on indique à l'utilisateur que sa note est invalide
        return render_template('infofilm.html', table=table, type=tableType, profile=ProfileUtilisateur, voteUser=voteUser, commentaires=commentaires, message=message)
    commentaire = request.form.get('commentairefilm')
    database.voter_film_serie(tableType, ProfileUtilisateur["username"], note, commentaire, filmChoisi) #on entre le vote de l'utilisateur dans la db
    table = fetchTableDataFilm(tableType, filmChoisi) #on va chercher les infos du film choisi
    voteUser = fetchUserVote(tableType, filmChoisi, ProfileUtilisateur["username"]) #on va chercher le vote et le commentaire de l'utilisateur
    commentaires = fetchCommentaires(tableType, filmChoisi) #on va chercher les commentaires du film ou de la série
    return render_template('infofilm.html', table=table, type=tableType, profile=ProfileUtilisateur, voteUser=voteUser,commentaires=commentaires, message=message)


if __name__ == "__main__":
    app.run()