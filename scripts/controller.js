function Controller() {
    console.log("Controller") ;
    var svg = document.querySelector("svg");
    var endProces = svg.getElementById("endProcess")
    var endProcesBB = endProces.getBBox();
    var width = endProcesBB.x + endProcesBB.width + 10;
    svg.setAttribute("viewBox", [0, 0, width,1].join(" "));
    console.log(width)
}

