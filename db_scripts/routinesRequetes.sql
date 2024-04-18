--requête permettant de trier tous les films en ordre décroissant en fonction de leur note :
SELECT nomFilm, annee, genre, sousGenre, acteurs, noteGlobale FROM films ORDER BY noteGlobale DESC;
--requête permettant de trier toutes les séries en ordre décroissant en fonction de leur note :
SELECT nomSerie, annee, genre, sousGenre, acteurs, saison, noteGlobale FROM series ORDER BY noteGlobale DESC;
--procédure permettant de filtrer les films en fonction de plusieurs critères :
DELIMITER //
CREATE PROCEDURE filtrerFilms (IN nomFilm2 varchar(100), IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN annee2 varchar(6), IN acteur varchar(100),IN nbVoteMin integer, IN noteMin double)
BEGIN
SELECT * FROM films WHERE nomFilm LIKE nomFilm2 AND genre LIKE nomGenre AND sousGenre LIKE nomSousGenre AND annee LIKE annee2 AND acteurs LIKE acteur AND nbVotes >= nbVoteMin AND noteGlobale >= noteMin ORDER BY noteGlobale DESC LIMIT 100;
END //
DELIMITER ;
--procédure permettant de filtrer les séries en fonction de plusieurs critères :
DELIMITER //
CREATE PROCEDURE filtrerSeries (IN nomSerie2 varchar(100), IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN annee2 varchar(6), IN acteur varchar(100), IN saison2 varchar(10),IN nbVoteMin integer, IN noteMin double)
BEGIN
SELECT * FROM series WHERE nomSerie LIKE nomSerie2 AND genre LIKE nomGenre AND sousGenre LIKE nomSousGenre AND annee LIKE annee2 AND acteurs LIKE acteur AND nbVotes >= nbVoteMin AND noteGlobale >= noteMin AND saison LIKE saison2 ORDER BY noteGlobale DESC LIMIT 100;
END //
DELIMITER ;
--procédure permettant de filtrer les films dun utilisateur spécifique en fonction de plusieurs critères :
DELIMITER //
CREATE PROCEDURE filtrerFilmsUtilisateur (IN nomFilm2 varchar(100), IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN annee2 varchar(6), IN acteur varchar(100),IN nbVoteMin integer, IN noteMin double, IN nomUser varchar(50))
BEGIN
SELECT F.*, V.nomUtilisateur, V.note  FROM films F, votesFilms V WHERE F.nomFilm LIKE nomFilm2 AND F.genre LIKE nomGenre AND F.sousGenre LIKE nomSousGenre AND F.annee LIKE annee2 AND F.acteurs LIKE acteur AND F.nbVotes >= nbVoteMin AND F.noteGlobale >= noteMin AND F.idFilm = V.idFilm AND V.nomUtilisateur = nomUser ORDER BY noteGlobale DESC;
END //
DELIMITER ;
--procédure permettant de filtrer les séries dun utilisateur spécifique en fonction de plusieurs critères :
DELIMITER //
CREATE PROCEDURE filtrerSeriesUtilisateur (IN nomSerie2 varchar(100), IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN annee2 varchar(6), IN acteur varchar(100), IN saison2 varchar(10),IN nbVoteMin integer, IN noteMin double, IN nomUser varchar(50))
BEGIN
SELECT S.*, V.nomUtilisateur, V.note  FROM series S, votesSeries V WHERE S.nomSerie LIKE nomSerie2 AND S.genre LIKE nomGenre AND S.sousGenre LIKE nomSousGenre AND S.annee LIKE annee2 AND S.acteurs LIKE acteur AND S.nbVotes >= nbVoteMin AND S.noteGlobale >= noteMin AND S.saison LIKE saison2  AND S.idSerie = V.idSerie AND V.nomUtilisateur = nomUser ORDER BY noteGlobale DESC;
END //
DELIMITER ;
--procédure permettant de créer des films :
DELIMITER //
CREATE PROCEDURE creerFilm (IN nomFilm varchar(100), IN annee YEAR, IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN acteurs longtext)
BEGIN
DECLARE idActuel int;
SELECT max(idFilm) FROM films INTO idActuel;
INSERT INTO films VALUES (idActuel + 1, nomFilm, annee, nomGenre, nomSousGenre, acteurs, 0, 0.0, 0.0);
END //
DELIMITER ;
--procédure permettant de créer des séries :
DELIMITER //
CREATE PROCEDURE creerSerie (IN nomSerie varchar(100), IN annee YEAR, IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN acteurs longtext, IN saison integer)
BEGIN
DECLARE idActuel int;
SELECT max(idSerie) FROM series INTO idActuel;
INSERT INTO series VALUES (idActuel + 1, nomSerie, annee, nomGenre, nomSousGenre, acteurs, 0, 0.0, 0.0, saison);
END //
DELIMITER ;
--procédure permettant de créer des utilisateurs :
DELIMITER //
CREATE PROCEDURE creerUtilisateur (IN nomUtilisateur varchar(50), IN motDePasse varchar(300), IN roleUtilisateur enum('admin', 'user'))
BEGIN
INSERT INTO utilisateurs VALUES (nomUtilisateur, motDePasse, roleUtilisateur);
END //
DELIMITER ;
--procédure permettant de créer des acteurs :
DELIMITER //
CREATE PROCEDURE creerActeur (IN prenom varchar(100), IN nom varchar(100), IN ddn DATE, IN sexe enum('masculin', 'feminin', 'non-binaire'), nationnalite varchar(100))
BEGIN
DECLARE idActuel integer;
SELECT max(id) FROM acteurs INTO idActuel;
INSERT INTO acteurs VALUES (idActuel+1, prenom, nom, ddn, sexe, nationnalite);
END //
DELIMITER ;
--procédure permettant de rajouter un vote avec ou sans commentaire pour un film :
DELIMITER //
CREATE PROCEDURE rajouterVoteFilm (IN nomUtilisateur varchar(50), IN idFilm2 integer, IN note double, IN contenuCommentaire longtext)
BEGIN
DECLARE idActuelVoteFilm integer;
SELECT max(id) FROM votesFilms INTO idActuelVoteFilm;
INSERT INTO votesFilms VALUES (idActuelVoteFilm+1, nomUtilisateur, idFilm2, ROUND(note,2));
UPDATE films SET noteTotale = noteTotale + ROUND(note,2) WHERE idFilm = idFilm2;
UPDATE films SET nbVotes = nbVotes + 1 WHERE idFilm = idFilm2;
UPDATE films SET noteGlobale = ROUND(noteTotale / nbVotes,2) WHERE idFilm = idFilm2;
IF contenuCommentaire <> "" THEN
	INSERT INTO commentairesFilms VALUES (idActuelVoteFilm+1, contenuCommentaire);
END IF;
END //
DELIMITER ;
--procédure permettant de rajouter un vote avec ou sans commentaire pour une série :
DELIMITER //
CREATE PROCEDURE rajouterVoteSerie (IN nomUtilisateur varchar(50), IN idSerie2 integer, IN note double, IN contenuCommentaire longtext)
BEGIN
DECLARE idActuelVoteSerie integer;
SELECT max(id) FROM votesSeries INTO idActuelVoteSerie;
INSERT INTO votesSeries VALUES (idActuelVoteSerie+1, nomUtilisateur, idSerie2, ROUND(note,2));
UPDATE series SET noteTotale = (noteTotale + ROUND(note,2)) WHERE idSerie = idSerie2;
UPDATE series SET nbVotes = nbVotes + 1 WHERE idSerie = idSerie2;
UPDATE series SET noteGlobale = ROUND(noteTotale / nbVotes,2) WHERE idSerie = idSerie2;
IF contenuCommentaire <> "" THEN
	INSERT INTO commentairesSeries VALUES (idActuelVoteSerie+1, contenuCommentaire);
END IF;
END //
DELIMITER ;
--procédure permettant de rajouter un genre :
DELIMITER //
CREATE PROCEDURE creerGenre (IN nomGenre varchar(50))
BEGIN
INSERT INTO genres VALUES (nomGenre);
END //
DELIMITER ;
--procédure permettant de voir les commentaires et notes des utilisateurs dun film en particulier :
DELIMITER //
CREATE PROCEDURE voirCommentairesNotesUtilisateursFilms (IN idFilm2 integer)
BEGIN
SELECT V.nomUtilisateur, V.note, C.contenu FROM votesFilms V, commentairesFilms C WHERE V.idFilm = idFilm2 AND V.id = C.id ;
END //
DELIMITER;
--procédure permettant de voir les commentaires et notes des utilisateurs dune série en particulier :
DELIMITER //
CREATE PROCEDURE voirCommentairesNotesUtilisateursSeries (IN idSerie2 integer)
BEGIN
SELECT V.nomUtilisateur, V.note, C.contenu FROM votesSeries V, commentairesSeries C WHERE V.idSerie = idSerie2 AND V.id = C.id ;
END //
DELIMITER ;
--procédure permettant de rechercher des films
DELIMITER //
CREATE PROCEDURE rechercherFilms (IN nomFilm2 varchar(100))
BEGIN
SELECT * FROM films WHERE nomFilm LIKE nomFilm2 ORDER BY noteGlobale DESC;
END //
DELIMITER ;
--procédure permettant de rechercher des séries
DELIMITER //
CREATE PROCEDURE rechercherSeries (IN nomSerie2 varchar(100))
BEGIN
SELECT * FROM series WHERE nomSerie LIKE nomSerie2 ORDER BY noteGlobale DESC;
END //
DELIMITER ;

