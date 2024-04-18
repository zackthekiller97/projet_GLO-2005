from flask import Flask, render_template, Response, request, flash, redirect, url_for
import bcrypt
import os
from werkzeug.utils import secure_filename
from flask_wtf import FlaskForm
from wtforms import FileField, SubmitField
from database import Database

ALLOWED_EXTENSIONS = set(['jpg'])


app = Flask(__name__)
ProfileUtilisateur = {} #informations sur l'utilisateur connecté
connexionApprouvee = False #indique si l'utilisateur s'est connecté avant d'ouvrir d'autres pages (token)
tableType = "films" #type de table à choisir lors des requêtes (films ou séries)
filmChoisi = "" #film choisi lors de l'ouverture de la page infoFilm
typeAjout = "film" #type d'élément à créer
app.config['SECRET_KEY'] = 'supersecretkey'
database = Database()

class UploadFileForm(FlaskForm):
    file = FileField("File")
    submit = SubmitField("Upload File")

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
    commentaire = ""
    if (database.verifieVoteUser(user, nomfilm, table)!=[]):
        commentaire = database.get_comments_movieserieUser(table, (database.verifieVoteUser(user, nomfilm, table)[0][0]))
    table_dict = {
        "entries": database.verifieVoteUser(user, nomfilm, table),
        "commentaire": commentaire
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
    database = Database()
    return render_template('connexion.html')

#route qui vérifie la connection de l'utilisateur
@app.route("/login", methods={'POST'})
def connexion():
    database = Database()
    username = '"'+request.form.get('username')+'"'
    mdp = request.form.get('password')
    bytes = mdp.encode('utf-8')
    hash = bcrypt.hashpw(bytes, bcrypt.gensalt(rounds=12))
    cmd='SELECT motDePasse FROM utilisateurs WHERE nomUtilisateur = '+username+';'
    passeVrai = database.verifyConnexion(cmd)
    print(hash)

    if (passeVrai==None):
        return render_template('connexion.html', message="NOM D'UTILISATEUR OU MOT DE PASSE INVALIDE")

    motdepasse = passeVrai[0].replace("b'", "")
    motdepasse = motdepasse.replace("'", "")
    motdepasse = motdepasse.encode('utf-8')
    if (passeVrai != None) and (bcrypt.checkpw(bytes,motdepasse)):
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
    database = Database()
    username = request.form.get('username')
    mdp = request.form.get('password')
    mdp = mdp.encode('utf-8')
    salt = bcrypt.gensalt(rounds=12)
    mdp = bcrypt.hashpw(mdp, salt)
    print(mdp)
    cmd=f"SELECT nomUtilisateur FROM utilisateurs WHERE nomUtilisateur = '{username}';"
    utilisateurPresent = database.verifyConnexion(cmd)
    if (utilisateurPresent == None):
        cmd2 = f'INSERT INTO utilisateurs VALUES ("{username}", "{mdp}", "user")' #on insère le nouvel utilisateur dans la db
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
    database = Database()
    return render_template('inscription.html')

#route permettant d'afficher la page de connexion
@app.route("/connexion")
def connexionpage():
    database = Database()
    return render_template('connexion.html')

#route permettant d'afficher la page d'accueil avec le classement des films
@app.route("/accueil")
def accueilPage():
    database = Database()
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        global tableType #on affiche les données de la table des films
        tableType = "films"
        genres = database.select_genres() #on va chercher la liste des genres de la db genres pour le futur filtrage
        table = fetchTableData(tableType, "", "", "", "", "", "0", "0.0", "") #on va chercher les infos des films sans filtre spécifique
        table = fetchTableData(tableType, "", "", "", "", "", "0", "0.0", "") #on va chercher les infos des films sans filtre spécifique
        return render_template('accueil.html', genres=genres, profile=ProfileUtilisateur, table=table, type=tableType)

#route permettant d'afficher la page d'accueil avec le classement des séries
@app.route("/accueilSeries")
def accueilSeries():
    database = Database()
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
    database = Database()
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
    database = Database()
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
    database = Database()
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
    database = Database()
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
    database = Database()
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
    database = Database()
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
    database = Database()
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
    database = Database()
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        nomFilm = request.form.get('nomfilm')
        global tableType
        table = fetchTableDataResearch(tableType, nomFilm) #aucune erreur ne peut arriver ici, si le film n'existe pas, rien n'est retourné et la page l'indique à l'utilisateur (via le code html)
        return render_template('rechercher.html', table=table, type=tableType, profile=ProfileUtilisateur)

#route permettant d'afficher les infos d'un film ou d'une série
@app.route("/infofilm", methods={'GET'})
def infoFilmSerie():
    database = Database()
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        nom = request.args.get('nom')
        global filmChoisi
        filmChoisi = nom
        form = UploadFileForm()
        table = fetchTableDataFilm(tableType, nom) #impossible qu'il y ait d'erreur ici, le lien contient forcément l'id du film via son paramètre
        voteUser = fetchUserVote(tableType, nom, ProfileUtilisateur["username"]) #on va chercher le vote de l'utilisateur, s'il y en a aucun, on ne retourne rien
        commentaires = fetchCommentaires(tableType, nom) #on va chercher les commentaires du films, si aucun on ne retourne rien
        return render_template('infofilm.html', table=table, type=tableType, profile=ProfileUtilisateur, voteUser=voteUser, commentaires=commentaires, form=form)

#route permettant de voter un film ou une série
@app.route("/vote", methods={'POST'})
def vote():
    database = Database()
    message = ""
    note = request.form.get('votefilm')
    try:
        note2 = float(note)
        if note2 < 0 or note2 > 10: #on vérifie que la note soit un chiffre valide entre 0 et 10
            table = fetchTableDataFilm(tableType, filmChoisi) #on va chercher les infos du film choisi
            voteUser = fetchUserVote(tableType, filmChoisi, ProfileUtilisateur["username"]) #on va chercher le vote et le commentaire de l'utilisateur
            commentaires = fetchCommentaires(tableType, filmChoisi) #on va chercher les commentaires du film ou de la série
            message = "Note invalide, veuillez entrer un chiffre (à virgule ou non) entre 0 et 10" #on indique à l'utilisateur que sa note est invalide
            form = UploadFileForm()
            return render_template('infofilm.html', table=table, type=tableType, profile=ProfileUtilisateur, voteUser=voteUser, commentaires=commentaires, message=message, form=form)
        commentaire = request.form.get('commentairefilm')
        if commentaire is None:
            commentaire = ""
        database.voter_film_serie(tableType, ProfileUtilisateur["username"], note, commentaire, filmChoisi) #on entre le vote de l'utilisateur dans la db

        message = "Vote enregistré avec succès !"
        table = fetchTableDataFilm(tableType, filmChoisi)
        voteUser = fetchUserVote(tableType, filmChoisi, ProfileUtilisateur["username"])
        commentaires = fetchCommentaires(tableType, filmChoisi)
        form = UploadFileForm()
        return render_template('infofilm.html', table=table, type=tableType, profile=ProfileUtilisateur, voteUser=voteUser, commentaires=commentaires, message=message, form=form)

    except ValueError:
        table = fetchTableDataFilm(tableType, filmChoisi) #on va chercher les infos du film choisi
        voteUser = fetchUserVote(tableType, filmChoisi, ProfileUtilisateur["username"]) #on va chercher le vote et le commentaire de l'utilisateur
        commentaires = fetchCommentaires(tableType, filmChoisi) #on va chercher les commentaires du film ou de la série
        message="Entrer une note valide"
        form = UploadFileForm()
        return render_template('infofilm.html', table=table, type=tableType, profile=ProfileUtilisateur, voteUser=voteUser,commentaires=commentaires, message=message, form=form)

@app.route("/ajouter", methods={'GET', 'POST'})
def ajouterPage():
    database = Database()
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        genres = database.select_genres()  # on va chercher la liste des genres de la db genres pour le futur filtrage
        global typeAjout
        typeAjout = request.args.get('type')
        message = ""
        return render_template('ajouter.html', profile=ProfileUtilisateur, typeAjout=typeAjout, message=message, genres=genres)

@app.route("/creer", methods={'POST'})
def ajouter():
    database = Database()
    if (connexionApprouvee == False): #vérifie si l'utilisateur s'est connecté
        return render_template('connexion.html')
    else:
        genres = database.select_genres()  # on va chercher la liste des genres de la db genres pour le futur filtrage
        global typeAjout
        if (typeAjout == "film"):
            try:
                nom = request.form.get('nomfilm')
                genre = request.form.get('genres')
                sgenre = request.form.get('sgenres')
                annee = request.form.get('annee')
                acteurs = request.form.get('acteur')
                if (nom == "" or genre == "" or sgenre == "" or annee == "" or acteurs == ""):
                    return render_template('ajouter.html', profile=ProfileUtilisateur, typeAjout=typeAjout, message="Aucune case ne peut être vide", genres=genres)
                database.ajouterFilm(nom,annee,genre,sgenre,acteurs)
                message="film ajouté avec succès!"
            except:
                message="Valeurs incorrectes, veuillez recommencer"
        elif (typeAjout == "serie"):
            try:
                nom = request.form.get('nomfilm')
                genre = request.form.get('genres')
                sgenre = request.form.get('sgenres')
                annee = request.form.get('annee')
                acteurs = request.form.get('acteur')
                saison = request.form.get('saison')
                if (nom == "" or genre == "" or sgenre == "" or annee == "" or acteurs == "" or saison == ""):
                    return render_template('ajouter.html', profile=ProfileUtilisateur, typeAjout=typeAjout, message="Aucune case ne peut être vide", genres=genres)
                database.ajouterSerie(nom,annee,genre,sgenre,acteurs, saison)
                message="série ajouté avec succès!"
            except:
                message="Valeurs incorrectes, veuillez recommencer"
        elif (typeAjout == "genre"):
            try:
                nom = request.form.get('nomGenre')
                if (nom == ""):
                    return render_template('ajouter.html', profile=ProfileUtilisateur, typeAjout=typeAjout, message="Aucune case ne peut être vide", genres=genres)
                database.ajouterGenre(nom)
                message="genre ajouté avec succès!"
            except:
                message="Valeurs incorrectes, veuillez recommencer"
        else:
            try:
                prenom = request.form.get('prenom')
                nom = request.form.get('nom')
                ddn = request.form.get('ddn')
                sexe = request.form.get('sexe')
                nationnalite = request.form.get('nationnalite')
                if (nom == "" or prenom == "" or ddn == "" or sexe == "" or nationnalite == ""):
                    return render_template('ajouter.html', profile=ProfileUtilisateur, typeAjout=typeAjout, message="Aucune case ne peut être vide", genres=genres)
                database.ajouterActeur(prenom, nom, ddn, sexe, nationnalite)
                message = "acteur ajouté avec succès!"
            except:
                message = "Valeurs incorrectes, veuillez recommencer"
        return render_template('ajouter.html', profile=ProfileUtilisateur, typeAjout=typeAjout, message=message, genres=genres)

@app.route("/upload", methods = ['POST', 'GET'])
def upload_file():
    database = Database()
    global tableType
    if connexionApprouvee==True:
        formi = UploadFileForm()
        if formi.validate_on_submit():
            file = formi.file.data
            if tableType == "films":
                app.config['UPLOAD_FOLDER'] = "./static/images/films"
            else:
                app.config['UPLOAD_FOLDER'] = "./static/images/series"
            file.save(os.path.join(os.path.abspath(os.path.dirname(__file__)),app.config['UPLOAD_FOLDER'],secure_filename(file.filename)))
        tableType = "films"
        genres = database.select_genres()
        table = fetchTableData(tableType, "", "", "", "", "", "0", "0.0","")  # on va chercher les infos des films sans filtre spécifique
        return render_template('accueil.html', profile=ProfileUtilisateur, genres=genres, table=table, type=tableType)
    else:
        return render_template('connexion.html')

if __name__ == "__main__":
    app.run()