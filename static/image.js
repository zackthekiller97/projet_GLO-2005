function setimgsrc() {
    var src = document.getElementById("id").innerText
    var type = document.getElementById("type").innerText
    var image = document.getElementById("image")
    if (type == "series") {
        image.src = "../static/images/series/" + src + ".jpg"
    } else {
        image.src = "../static/images/films/" + src + ".jpg"
    }

}