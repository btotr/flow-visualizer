<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/2000/svg" 
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:core="https://flow.recipes/ns/core#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:owl="http://www.w3.org/2002/07/owl#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:schema="http://schema.org/"
	xmlns:skos="http://www.w3.org/2008/05/skos#"
	xmlns:viz="https://flow.recipes/ns/flow-visualiser#">
	
	<xsl:output method="xml" 
		doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd" 
		doctype-public="-//W3C//DTD SVG 1.1//EN" 
		indent="yes" />

	<xsl:variable name="header">
			<script type="application/ecmascript" xlink:href="https://flow.recipes/flow-visualizer/scripts/controller.js"/>
			<defs>
				<g>
			    	<rect id="process" rx="15" ry="15">
				       	<set attributeName="fill" to="red" begin="mousedown" end="mouseup" dur="4s" />
			    	</rect>
				</g>
				<g>
			    	<rect id="components" rx="5" ry="5">
				       	<set attributeName="fill" to="yellow" begin="mousedown" end="mouseup" dur="4s" />
			    	</rect>
				</g>
		    </defs>
	</xsl:variable>	

	<xsl:template match="/rdf:RDF">
		<xsl:processing-instruction name="xml-stylesheet">
			href="https://flow.recipes/flow-visualizer/stylesheets/screen.css" 
			type="text/css"
		</xsl:processing-instruction>		
		
		<svg version="1.1" x="0" y="0" width="100%" height="100%" onload="new Controller()" viewBox="0.0 0.0 560 400">
			<xsl:copy-of select="$header" />
		    <xsl:if test="owl:NamedIndividual[not(rdf:type/@rdf:resource='https://flow.recipes/ns/core#Instruction')]">
				<text id="recipeName"><xsl:value-of select="owl:NamedIndividual/rdfs:label"/></text>
			</xsl:if>
			<xsl:call-template name="instruction">
				<!-- find a instruction without dependency which must be the first. -->
    			<xsl:with-param name="instruction" select="rdf:Description[rdf:type/@rdf:resource='https://flow.recipes/ns/core#Instruction' and not(core:depVariationInstruction)][1]" />
				<xsl:with-param name="x" select="0" />
    		</xsl:call-template>
		</svg>
	</xsl:template>

	<xsl:template name="instruction">
		<xsl:param name="instruction" />
		<xsl:param name="x" />
		<g>
			<xsl:attribute name="style">transform: translate(<xsl:value-of select="$x" />px, -10px)</xsl:attribute>
			<use xlink:href="#components" />
			<xsl:variable name="iriComponentUnit" select="$instruction/core:hasComponentUnit/@rdf:nodeID" />
			<xsl:for-each select="$iriComponentUnit">
				<xsl:variable name="pos" select="position()" />
				<xsl:call-template name="componentUnit">
			   		<xsl:with-param name="componentUnit" select="//rdf:Description[@rdf:nodeID=$iriComponentUnit][$pos]" />
			   		<xsl:with-param name="x" select="$x" />
			   		<xsl:with-param name="y" select="position()" />
			   	</xsl:call-template>
		   	</xsl:for-each>
	   	</g>
		<xsl:variable name="iriMethod" select="$instruction/core:hasMethod/@rdf:resource" />
		<xsl:call-template name="method">
			<xsl:with-param name="method" select="//rdf:Description[@rdf:about=$iriMethod]" />
			<xsl:with-param name="x" select="$x" />
		</xsl:call-template>
    	<xsl:if test="$instruction/core:directions">
			<text class="direction"><xsl:value-of select="$instruction/core:directions/text()" /></text>
		</xsl:if>


		<!-- xslt recursion :-) -->
		<xsl:variable name="currentInstruction" select="$instruction/@rdf:about" />
		<xsl:if test="//rdf:Description[core:depVariationInstruction/@rdf:resource=$currentInstruction]">
			<xsl:call-template name="instruction">
	    		<xsl:with-param name="instruction" select="//rdf:Description[core:depVariationInstruction/@rdf:resource=$currentInstruction]" />
	    		<xsl:with-param name="x" select="$x + 100" />
	    	</xsl:call-template> 
    	</xsl:if>
	</xsl:template>
	 	    		
	<xsl:template name="method">
		<xsl:param name="method" />
		<xsl:param name="x" />
		<xsl:element name="g">
			<xsl:attribute name="style">transform: translate(<xsl:value-of select="$x" />px, 100px)</xsl:attribute>
    		<xsl:attribute name="class">instruction</xsl:attribute>
			<use xlink:href="#process" />
			<text class="method">
				<xsl:choose>
			      <xsl:when test="$method/skos:prefLabel">
			        <xsl:value-of select="$method/skos:prefLabel/text()" />
			      </xsl:when>
			      <xsl:otherwise>
			        <xsl:value-of select="$method/@rdf:about" />
			      </xsl:otherwise>
			    </xsl:choose>
			</text>
		</xsl:element>
	</xsl:template>
	    		
	<xsl:template name="componentUnit">
		<xsl:param name="componentUnit" />
		<xsl:param name="y" />
		<xsl:param name="x" />
		<xsl:element name="text">
			<xsl:attribute name="style">transform: translate(2px, <xsl:value-of select="$y*8" />px)</xsl:attribute>
			<xsl:attribute name="class">componentUnit</xsl:attribute>
			<xsl:if test="$componentUnit/core:weight">
				<xsl:value-of select="$componentUnit/core:weight/text()" />&#xA0;
			</xsl:if>
			<xsl:variable name="iriComponent" select="$componentUnit/core:hasComponent/@rdf:resource" />
			<xsl:call-template name="component">
		   		<xsl:with-param name="component" select="//rdf:Description[@rdf:about=$iriComponent]" />
		   	</xsl:call-template>
			<xsl:if test="$componentUnit/core:componentAddition">
				&#xA0;(<xsl:value-of select="$componentUnit/core:componentAddition/text()" />)
			</xsl:if>
		</xsl:element>
	</xsl:template>
	
	<xsl:template name="component">
		<xsl:param name="component" />
			<xsl:choose>
		      <xsl:when test="$component/skos:prefLabel">
		        <xsl:value-of select="$component/skos:prefLabel/text()" />
		      </xsl:when>
		      <xsl:otherwise>
		        <xsl:value-of select="$component/@rdf:about" />
		      </xsl:otherwise>
		    </xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>