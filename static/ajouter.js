function SupprimerContenu()
{
    var elements = document.getElementsByTagName("input");
    elements.foreach(supprime)
}

function supprime(item) {
    item.innerHTML = ""
}