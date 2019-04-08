<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/2000/svg" 
	xmlns:xlink="http://www.w3.org/1999/xlink"
	 xmlns:core="http://flow.recipes/ns/core#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:schema="http://schema.org/">
	
	<xsl:output method="xml" 
		doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd" 
		doctype-public="-//W3C//DTD SVG 1.1//EN" 
		indent="yes" />
		

	<xsl:template match="/rdf:RDF">
		<xsl:processing-instruction name="xml-stylesheet">
			href="stylesheets/screen.css" 
			type="text/css"
		</xsl:processing-instruction>
		<svg version="1.1"
			 x="0" y="0" width="100%" height="100%" onload="new Controller()">
			<script type="application/ecmascript" xlink:href="scripts/controller.js"/>
			<defs>  
		        <g id="node" class="node endpoint">
		        	<rect rx="8" ry="8" width="80" height="28" x="0" y="0"/>    	
		            <text y="14" x="40">pipe</text>
		            <line class="connection" x1="80" y1="14" x2="120" y2="14"/>
		            <circle class="end" cx="120" cy="14" r="10">
		                <set attributeName="fill" to="#78CFE4;" begin="mousedown" end="mouseup" dur="indefinite" />
		            </circle>
		        </g>
		    </defs>
		    <g id="start" class="endpoint"  transform="translate(50,100)">
		        <circle class="start" cx="0" cy="14" r="10">
		            <animate id="startAnimation" 
							restart="whenNotActive"
							begin="indefinite" 
							end="indefinite"
		                    attributeName="r" dur="2s" values="10; 15; 10" repeatDur="indefinite" calcMode="linear" fill="remove"/>
		            <set attributeName="fill" to="#78CFE4;" begin="startAnimation.begin" end="startAnimation.end" dur="indefinite" />
		        </circle>
		        <line class="connection"  x1="10" y1="14" x2="50" y2="14"/>
		    </g>
			<xsl:for-each select="owl:NamedIndividual">
				<xsl:if test="not(rdf:type/@rdf:resource='http://flow.recipes/ns/core#Instruction')">
					<text><xsl:value-of select="rdfs:label"/></text>
				</xsl:if>
				<xsl:if test="rdf:type/@rdf:resource='http://flow.recipes/ns/core#Instruction'">
					<text><xsl:value-of select="core:hasMethod/@rdf:resource"/></text>
				</xsl:if>
			 </xsl:for-each>
		</svg>
	</xsl:template>
</xsl:stylesheet>