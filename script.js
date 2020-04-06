const MODELS = [
    {
      "id":0,
      "name": "SampleModel.html"
    },
    {
      "id": 1,
      "name":"Fire Simple.html"
    },
    {
      "id": 2,
      "name":"Lattice Land - Explore.html"
    }
  ];

// console.log(document.getElementById('iframe-content').contentWindow.document)

function getiFrames() {
  var iframeDrop = document.getElementById("iframe-dropdown");

  for (i = 0; i < MODELS.length; i++) {
    var newOption = document.createElement("option");  // Create a <option> node
    var newOptionName = document.createTextNode(MODELS[i].name.split(".")[0]);
    newOption.appendChild(newOptionName);
    iframeDrop.appendChild(newOption); ///append Item
  }
}

function chooseFrame(selected) {
  var option = selected.options[selected.selectedIndex].text;
  document.getElementById('iframe-content').src=("models/" + option + ".html");
}

window.onload = function funct() {
  getiFrames();
  chooseFrame();
}
