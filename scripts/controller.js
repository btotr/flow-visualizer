function Controller() {
    console.log("Controller") ;
    var svg = document.querySelector("svg");
    var endProces = svg.getElementById("endProcess")
    var endProcesBB = endProces.getBBox();
    var width = endProcesBB.x + endProcesBB.width + 10;
    svg.setAttribute("viewBox", [0, 0, width,1].join(" "));
    var directions = document.getElementsByClassName("direction");
    for (var i = 0; i < directions.length; i++) {
        var direction = directions[i];
        var multiline = createSVGtext(direction.innerHTML, parseInt(direction.getAttribute("x")), parseInt(direction.getAttribute("y")));
        direction.parentNode.appendChild(multiline);
        direction.parentNode.removeChild(direction);
    }
}

function createSVGtext(caption, x, y) {
    //  This function attempts to create a new svg "text" element, chopping 
    //  it up into "tspan" pieces, if the caption is too long
    //
    var svgText = document.createElementNS('http://www.w3.org/2000/svg', 'text');
    svgText.setAttributeNS(null, 'x', x);
    svgText.setAttributeNS(null, 'y', y);
    svgText.setAttributeNS(null, 'font-size', 12);


    var MAXIMUM_CHARS_PER_LINE = 18;
    var LINE_HEIGHT = 16;

    var words = caption.split(" ");
    var line = "";

    for (var n = 0; n < words.length; n++) {

        var testLine = line + words[n] + " ";
        if (testLine.length > MAXIMUM_CHARS_PER_LINE)
        {
            //  Add a new <tspan> element
            var svgTSpan = document.createElementNS('http://www.w3.org/2000/svg', 'tspan');
            svgTSpan.setAttributeNS(null, 'x', x);
            svgTSpan.setAttributeNS(null, 'y', y);

            var tSpanTextNode = document.createTextNode(line);
            svgTSpan.appendChild(tSpanTextNode);
            svgText.appendChild(svgTSpan);

            line = words[n] + " ";
            y += LINE_HEIGHT;
        }
        else {
            line = testLine;
        }
    }

    var svgTSpan = document.createElementNS('http://www.w3.org/2000/svg', 'tspan');
    svgTSpan.setAttributeNS(null, 'x', x);
    svgTSpan.setAttributeNS(null, 'y', y);

    var tSpanTextNode = document.createTextNode(line);
    svgTSpan.appendChild(tSpanTextNode);

    svgText.appendChild(svgTSpan);

    return svgText;
}

