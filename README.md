# flow visualizer

Flow visualizer transforms your recipe (created with the flow recipe model) into a flow process according to the flow methodology

# instructions

1. create a recipe (see: https://github.com/btotr/recipes for instructions)
2. save the result to a rdf/xml file (nested elements arn't implemented)
3. add the following line below the xml prolog: 
    <?xml-stylesheet type="text/xsl" href="http://flow.recipes/flow-visualizer/flow-visualiser.xsl" ?>
4. open the file in a xslt aware webbrowser (tested with Google Chrome and Mozilla Firefox)
