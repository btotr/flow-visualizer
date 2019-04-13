<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/2000/svg" 
	xmlns:xlink="http://www.w3.org/1999/xlink"
	 xmlns:core="http://flow.recipes/ns/core#"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:schema="http://schema.org/"
  xmlns:viz="http://flow.recipes/ns/flow-visualiser#">
	
	<xsl:output method="xml" 
		doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd" 
		doctype-public="-//W3C//DTD SVG 1.1//EN" 
		indent="yes" />


	<xsl:variable name="header">
			<script type="application/ecmascript" xlink:href="scripts/controller.js"/>
			<defs>  
		        <g id="node" class="node">
		            <circle class="end" cx="120" cy="14" r="10">
		                <set attributeName="fill" to="#78CFE4;" begin="mousedown" end="mouseup" dur="indefinite" />
		            </circle>
		        </g>
		    </defs>
	</xsl:variable>	

	<xsl:template match="/rdf:RDF">
		<xsl:processing-instruction name="xml-stylesheet">
			href="stylesheets/screen.css" 
			type="text/css"
		</xsl:processing-instruction>		
		
		<svg version="1.1" x="0" y="0" width="100%" height="100%" onload="new Controller()">
			<xsl:copy-of select="$header" />
		    <xsl:if test="owl:NamedIndividual[not(rdf:type/@rdf:resource='http://flow.recipes/ns/core#Instruction')]">
				<text id="recipeName"><xsl:value-of select="owl:NamedIndividual/rdfs:label"/></text>
			</xsl:if>
			<xsl:call-template name="instruction">
    			<xsl:with-param name="instruction" select="owl:NamedIndividual[rdf:type/@rdf:resource='http://flow.recipes/ns/core#Instruction' and not(core:depVariationInstruction)][1]" />
    		</xsl:call-template>
		</svg>
	</xsl:template>

	
	<xsl:template name="instruction">
		<xsl:param name="instruction" />
		<g>
			<!-- should use label -->
			<text><xsl:value-of select="substring-after($instruction/core:hasMethod/@rdf:resource, '#')" /></text>
			<xsl:for-each select="$instruction/core:hasComponentUnit/rdf:Description">
				<xsl:call-template name="componentUnit">
		    		<xsl:with-param name="componentUnit" select="self::node()" />
		    	</xsl:call-template>
	    	</xsl:for-each>
	    	<xsl:if test="$instruction/core:directions">
				<text><xsl:value-of select="$instruction/core:directions/text()" /></text>
			</xsl:if>
			<xsl:variable name="current" select="$instruction/@rdf:about" />
			<text><xsl:value-of select="$current" /></text>
				<!-- xslt recursion :-) -->
				<xsl:if test="//owl:NamedIndividual[core:depVariationInstruction/@rdf:resource=$current]">
				<xsl:call-template name="instruction">
	    			<xsl:with-param name="instruction" select="//owl:NamedIndividual[core:depVariationInstruction/@rdf:resource=$current]" />
	    		</xsl:call-template> 
    		</xsl:if>

		</g>
	</xsl:template>
	    		
	<xsl:template name="componentUnit">
		<xsl:param name="componentUnit" />
		<g>
			<xsl:if test="$componentUnit/core:weight">
				<text><xsl:value-of select="$componentUnit/core:weight/text()" /></text>
			</xsl:if>
			<text><xsl:value-of select="$componentUnit/core:hasComponent/@rdf:resource" /></text>
			<xsl:if test="$componentUnit/core:componentAddition">
				<text>(<xsl:value-of select="$componentUnit/core:componentAddition/text()" />)</text>
			</xsl:if>
		</g>
	</xsl:template>
</xsl:stylesheet>