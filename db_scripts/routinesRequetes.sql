--requête permettant de trier tous les films en ordre décroissant en fonction de leur note :
SELECT nomFilm, annee, genre, sousGenre, acteurs, noteGlobale FROM films ORDER BY noteGlobale DESC;
--requête permettant de trier toutes les séries en ordre décroissant en fonction de leur note :
SELECT nomSerie, annee, genre, sousGenre, acteurs, saison, noteGlobale FROM series ORDER BY noteGlobale DESC;
--procédure permettant de filtrer les films en fonction de plusieurs critères :
DELIMITER //
CREATE PROCEDURE filtrerFilms (IN nomFilm2 varchar(100), IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN annee2 varchar(6), IN acteur varchar(100),IN nbVoteMin integer, IN noteMin double)
BEGIN
SELECT * FROM films WHERE nomFilm LIKE nomFilm2 AND genre LIKE nomGenre AND sousGenre LIKE nomSousGenre AND annee LIKE annee2 AND acteurs LIKE acteur AND nbVotes >= nbVoteMin AND noteGlobale >= noteMin ORDER BY noteGlobale DESC;
END //
DELIMITER ;
--procédure permettant de filtrer les séries en fonction de plusieurs critères :
DELIMITER //
CREATE PROCEDURE filtrerSeries (IN nomSerie2 varchar(100), IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN annee2 varchar(6), IN acteur varchar(100), IN saison2 varchar(10),IN nbVoteMin integer, IN noteMin double)
BEGIN
SELECT * FROM series WHERE nomSerie LIKE nomSerie2 AND genre LIKE nomGenre AND sousGenre LIKE nomSousGenre AND annee LIKE annee2 AND acteurs LIKE acteur AND nbVotes >= nbVoteMin AND noteGlobale >= noteMin AND saison LIKE saison2 ORDER BY noteGlobale DESC;
END //
DELIMITER ;
--procédure permettant de filtrer les films d'un utilisateur spécifique en fonction de plusieurs critères :
DELIMITER //
CREATE PROCEDURE filtrerFilmsUtilisateur (IN nomFilm2 varchar(100), IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN annee2 varchar(6), IN acteur varchar(100),IN nbVoteMin integer, IN noteMin double, IN nomUser varchar(50))
BEGIN
SELECT F.*, V.nomUtilisateur, V.note  FROM films F, votesFilms V WHERE F.nomFilm LIKE nomFilm2 AND F.genre LIKE nomGenre AND F.sousGenre LIKE nomSousGenre AND F.annee LIKE annee2 AND F.acteurs LIKE acteur AND F.nbVotes >= nbVoteMin AND F.noteGlobale >= noteMin AND F.idFilm = V.idFilm AND V.nomUtilisateur = nomUser ORDER BY noteGlobale DESC;
END //
DELIMITER ;
--procédure permettant de filtrer les séries d'un utilisateur spécifique en fonction de plusieurs critères :
DELIMITER //
CREATE PROCEDURE filtrerSeriesUtilisateur (IN nomSerie2 varchar(100), IN nomGenre varchar(50), IN nomSousGenre varchar(50), IN annee2 varchar(6), IN acteur varchar(100), IN saison2 varchar(10),IN nbVoteMin integer, IN noteMin double, IN nomUser varchar(50))
BEGIN
SELECT S.*, V.nomUtilisateur, V.note  FROM series S, votesSeries V WHERE S.nomSerie LIKE nomSerie2 AND S.genre LIKE nomGenre AND S.sousGenre LIKE nomSousGenre AND S.annee LIKE annee2 AND S.acteurs LIKE acteur AND S.nbVotes >= nbVoteMin AND S.noteGlobale >= noteMin AND S.saison LIKE saison2  AND S.idSerie = V.idSerie AND V.nomUtilisateur = nomUser ORDER BY noteGlobale DESC;
END //
DELIMITER ;
--procédure permettant de créer des films :
--procédure permettant de créer des séries :
--procédure permettant de créer des utilisateurs :
--procédure permettant de créer des acteurs :
--procédure permettant de rajouter un vote avec ou sans commentaire pour un film :
--procédure permettant de rajouter un vote avec ou sans commentaire pour une série :
--procédure permettant de rajouter un genre :