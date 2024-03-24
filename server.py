from flask import Flask, render_template, Response, request

from database import Database

app = Flask(__name__)
ProfileUtilisateur = {}

database = Database()

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
        return render_template('accueil.html', profile=ProfileUtilisateur)
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
        return render_template('accueil.html', profile=ProfileUtilisateur)
    return render_template('inscription.html', message="NOM D'UTILISATEUR DÉJÀ EXISTANT")

@app.route("/inscription")
def inscriptionpage():
    return render_template('inscription.html')

@app.route("/connexion")
def connexionpage():
    return render_template('connexion.html')

if __name__ == "__main__":
    app.run()