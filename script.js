function chooseFrame(){
    var el = document.getElementById('iframe-dropdown');
    var option = el.selectedIndex;
    switch(option){
        case 0:
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
    chooseFrame();
}