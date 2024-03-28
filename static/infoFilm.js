//boucle qui va itérer parmis tous les elements qui ont le name nom et changer leur code html pour un href avec param
function ajouterHref()
{
    var elements = document.getElementsByName("nom");
    elements.forEach(addHref)
}

function addHref(item) {
    var nom = item.innerText;
    var nom2 = nom.replace(/\s/g, '%');
    var text1 = "<a href='infofilm?nom='"
    item.innerHTML = "<a href='infofilm?nom=" + nom2 + "'>" + nom + "</a>"
}