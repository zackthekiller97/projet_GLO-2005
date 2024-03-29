//boucle qui va itérer parmis tous les elements qui ont le name nom et changer leur code html pour un href avec param


function ajouterHref()
{
    var elements = document.getElementsByName("nom");
    var elements2 = document.getElementsByName("saison");
    elements.forEach(addHref)
    elements2.forEach(addHrefS)
}

function addHref(item) {
    var nom = item.innerText;
    var nom2 = nom.replace(/\s/g, '%');
    item.innerHTML = "<a href='infofilm?nom=" + nom2 + "'>" + nom + "</a>"
}

function addHrefS(item) {
    var nom = item.innerText;
    var nom2 = nom.replace(/\s/g, '%');
    item.innerHTML = "<a href='infofilm?nom=" + nom2 + "'>" + nom + "</a>"
}