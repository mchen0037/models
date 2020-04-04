function getiFrames(){
    var iframeDrop = document.getElementById("iframe-dropdown");

    var response = [{"id":1,"name":"Fire Simple.html"},{"id":2,"name":"Lattice Land - Explore.html"},{"id":3,"name":"SampleModel.html"}] ;

for (i = 0; i < response.length; i++) 
{ 
	var newOption = document.createElement("option");  // Create a <option> node
	var newOptionName = document.createTextNode(response[i].name.split(".")[0]);
	newOption.appendChild(newOptionName); 
	iframeDrop.appendChild(newOption); ///append Item
}

/*
    dir = document.querySelector("/models/*.html");
    var reader = new FileReader;
    file = dir.target.file;
    var newFrame;
    var iFrameList = document.getElementById("iframe-dropdown");
    reader.onload = (function(file){
        reader.readAsText(file);
        var lines = file.split('/n');
        for(var i = 0; i < lines.length; i++){
            newFrame.document.createElement("option");
            newFrame.text = lines[i].split(".")[0];
            iFrameList.appendChild(newFrame).createTextNode(newFrame.text);
        }
    })
    */
}
function chooseFrame(){
    var el = document.getElementById('iframe-dropdown');
    var option = el.selectedIndex;
    switch(option){
        case 3:
            document.getElementById('iframe-content').src="models/SampleModel.html";
            break;
        case 1:
            document.getElementById('iframe-content').src="models/Fire Simple.html";
            break;
        case 2:
            document.getElementById('iframe-content').src="models/Lattice Land - Explore.html";
            break;

    }
}

window.onload = function funct(){
    getiFrames();
    chooseFrame();

}