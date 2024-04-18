//boucle qui va itérer parmis tous les elements qui ont le name nom et changer leur code html pour un href avec param
var compteur = 1 //compteur pour la position du film dans le classement
var compteurSeries = 0 //compteur pour la position de la série dans le classement

function ajouterHref()
{
    var elements = document.getElementsByName("nom"); //on effectue l'action pour chaque élément avec le name nom (film)
    var elements2 = document.getElementsByName("saison"); //on effectue l'action pour chaque élément avec le name saison (série)
    elements.forEach(addHref)
    elements2.forEach(addHrefS)
}

function addHref(item) {
    var nom = item.innerText;
    var nom2 = nom.replace(/\s/g, '%');
    item.innerHTML = "<a href='infofilm?nom=" + nom2 + "'>" + compteur + "</a>"
    compteur += 1
}

function addHrefS(item) {
    var nom = item.innerText;
    var nom2 = nom.replace(/\s/g, '%');
    item.innerHTML = "<a href='infofilm?nom=" + nom2 + "'>" + compteurSeries + "</a>"
    compteurSeries += 1
}
