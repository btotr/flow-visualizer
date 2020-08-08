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
		
		
	<!-- method width -->
	<xsl:variable name="mw" select="80" /> 
	 <!-- method height -->
	<xsl:variable name="mh" select="30" />
	<!-- components width -->
	<xsl:variable name="cw" select="90" />
	<!-- components height -->
	<xsl:variable name="ch" select="50" />	
	<!-- components space -->
	<xsl:variable name="cs" select="40" />
	<!-- instruction width -->
	<xsl:variable name="iw" select="100" />
	<!-- instruction start x -->
	<xsl:variable name="ix" select="50" />	
		<!-- instruction start y -->
	<xsl:variable name="iy" select="20" />	
		<!-- instruction space -->
	<xsl:variable name="is" select="20" />
	<!-- description space -->
	<xsl:variable name="ds" select="50" />

	<xsl:variable name="header">
			<script type="application/ecmascript" xlink:href="https://flow.recipes/flow-visualizer/scripts/controller.js"/>
			<defs>
		    	<rect id="process" rx="10" ry="10" width="{$mw}" height="{$mh}">
			       	<set attributeName="fill" to="red" begin="mousedown" end="mouseup" dur="4s" />
		    	</rect>

			    <g id="timeProcess" >
					<polygon points="7.687,0 3.843,3.844 0,0 3.843,0 "/>
					<polygon  points="0,8.043 3.844,4.199 7.687,8.043 3.844,8.043 "/>
				</g>
		    	
		    	<rect id="components" rx="0" ry="0" x="{-(($cw - $mw) div 2 )}" width="{$cw}" height="{$ch}">
			       	<set attributeName="fill" to="yellow" begin="mousedown" end="mouseup" dur="4s" />
		    	</rect>
		    </defs>
	</xsl:variable>

	<xsl:template match="/rdf:RDF">

		<xsl:processing-instruction name="xml-stylesheet">
			href="https://flow.recipes/flow-visualizer/stylesheets/screen.css" 
			type="text/css"
		</xsl:processing-instruction>

		<svg version="1.1" onload="new Controller()">
			<xsl:copy-of select="$header" />
		    <xsl:if test="rdf:Description[rdf:type/@rdf:resource='https://flow.recipes/ns/core#Recipe']">
		    		<title id="recipeName"><xsl:value-of select="rdf:Description/rdfs:label"/></title>
				<text id="recipeName"><xsl:value-of select="rdf:Description/rdfs:label"/></text>
			</xsl:if>
			<circle cx="{$ix - $is - 10}" cy="{$ch+$cs+($mh div 2 )}" r="10" id="startProcess"/>
			<xsl:call-template name="instruction">
				<!-- find a instruction without dependency which must be the first. -->
    			<xsl:with-param name="instruction" select="rdf:Description[rdf:type/@rdf:resource='https://flow.recipes/ns/core#Instruction' and not(core:depVariationInstruction)][1]" />
				<xsl:with-param name="x" select="$ix" />
				<xsl:with-param name="y" select="0" />
    		</xsl:call-template>
		</svg>
	</xsl:template>
	

	<xsl:template name="instruction">
		<xsl:param name="instruction" />
		<xsl:param name="depIRIBase" />
		<xsl:param name="x" />
		<xsl:param name="y" />
		<xsl:variable name="currentInstruction" select="$instruction/@rdf:about" />
		<xsl:message>Current instruction: <xsl:value-of select="$currentInstruction" /></xsl:message>
		<g>
			<xsl:attribute name="class">instruction</xsl:attribute>
			<g>
				<xsl:attribute name="style">transform: translate(<xsl:value-of select="$x" />px, <xsl:value-of select="$iy + $y" />px)</xsl:attribute>
				<xsl:variable name="iriComponentUnit" select="$instruction/core:hasComponentUnit/@rdf:nodeID" />
				<xsl:for-each select="$iriComponentUnit">
					<xsl:variable name="pos" select="position()" />
					<xsl:if test="$pos = '1'">
						<use xlink:href="#components" />
						<xsl:element name="line">
							<xsl:attribute name="class">processConnection</xsl:attribute>
							<xsl:attribute name="x1"><xsl:value-of select="$cw div 2 - (($cw - $mw) div 2 )" />px</xsl:attribute>
							<xsl:attribute name="x2"><xsl:value-of select="$cw div 2 - (($cw - $mw) div 2 )" />px</xsl:attribute>
							<xsl:attribute name="y1"><xsl:value-of select="$ch" />px</xsl:attribute>
							<xsl:attribute name="y2"><xsl:value-of select="$ch+$cs" />px</xsl:attribute>
						</xsl:element>
					</xsl:if>
					<xsl:call-template name="componentUnit">
				   		<xsl:with-param name="componentUnit" select="//rdf:Description[@rdf:nodeID=$iriComponentUnit][$pos]" />
				   		<xsl:with-param name="x" select="$x" />
				   		<xsl:with-param name="y" select="position()" />
				   	</xsl:call-template>
			   	</xsl:for-each>
		   		<xsl:if test="$instruction/core:direction">
					<xsl:element name="line">
						<xsl:attribute name="class">descriptionConnection</xsl:attribute>
						<xsl:attribute name="x1"><xsl:value-of select="30" />px</xsl:attribute>
						<xsl:attribute name="x2"><xsl:value-of select="($mw div 2)" />px</xsl:attribute>
						<xsl:attribute name="y1"><xsl:value-of select="$y+$mh+$ch+35" />px</xsl:attribute>
						<xsl:attribute name="y2"><xsl:value-of select="($y+$mh+$ch+$cs+$ds)-20" />px</xsl:attribute>
					</xsl:element>
					<text class="direction" x="10" y="{$y+$mh+$ch+$cs+$ds}"><xsl:value-of select="$instruction/core:direction/text()" /></text>
				</xsl:if>
	   		</g>
			<xsl:variable name="iriMethod" select="$instruction/core:hasMethod/@rdf:resource" />
			<xsl:call-template name="method">
				<xsl:with-param name="method" select="//rdf:Description[@rdf:about=$iriMethod]" />
				<xsl:with-param name="time" select="$instruction/core:time" />
				<xsl:with-param name="x" select="$x" />
				<xsl:with-param name="y" select="$y" />
			</xsl:call-template>
		</g>

		<xsl:variable name="depIRI" select="//rdf:Description[core:depVariationInstruction/@rdf:resource=$currentInstruction]/@rdf:about" />
		<xsl:variable name="variationIRI" select="//rdf:Description[core:variation/@rdf:resource=$depIRI]/@rdf:about" />
		
		
		<xsl:for-each select="//rdf:Description[(core:depVariationInstruction/@rdf:resource=$depIRIBase) or (core:depVariationInstruction/@rdf:resource=$currentInstruction)]">
			<xsl:variable name="pos" select="position()" />
			<xsl:variable name="nextY">
			  <xsl:choose>
			    <xsl:when test="$y &gt; 1 ">0
					<!--FIXME:  and not(//rdf:Description[(core:depVariationInstruction/@rdf:resource=$depIRIBase) or (core:depVariationInstruction/@rdf:resource=$currentInstruction)][$pos]/@rdf:about = $currentInstruction/@rdf:about) -->
			    	<!--xsl:value-of select="$y" /-->
			    </xsl:when>
			    <xsl:otherwise><xsl:value-of  select="(number($pos)-1) * ($mh+$ch+$cs)" /></xsl:otherwise>
			  </xsl:choose>
			</xsl:variable>
			<xsl:if test="$depIRI or $depIRIBase">
				<xsl:choose>
					<!-- xslt recursion :-) -->
					<xsl:when test="$variationIRI">
						<xsl:call-template name="instruction">
				    		<xsl:with-param name="instruction" select="//rdf:Description[core:variation]" />
				    		<xsl:with-param name="x" select="$x + $iw" />
				    		<xsl:with-param name="depIRIBase" select="$depIRI" />
				    		<xsl:with-param name="y" select="0" />
				    	</xsl:call-template> 
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="instruction">
				    		<xsl:with-param name="instruction" select="//rdf:Description[(core:depVariationInstruction/@rdf:resource=$depIRIBase) or (core:depVariationInstruction/@rdf:resource=$currentInstruction)][$pos]" />
				    		<xsl:with-param name="x" select="$x + $iw" />
				    		<xsl:with-param name="y" select="$nextY" />
				    	</xsl:call-template> 
			    	</xsl:otherwise>
		    	</xsl:choose>
		    	
	    	</xsl:if>
		   	<xsl:if test="$pos &gt; 1">
		   		<!-- draw fork -->
				<xsl:element name="line">
					<xsl:attribute name="class">fork</xsl:attribute>
					<xsl:attribute name="x1"><xsl:value-of select="$x + ($is div 2) + $mw" />px</xsl:attribute>
					<xsl:attribute name="x2"><xsl:value-of select="$x + ($is div 2) + $mw" />px</xsl:attribute>
					<xsl:attribute name="y1"><xsl:value-of select="(number($pos)-1) * ($mh+$ch+$cs) - ($mh div 2)" />px</xsl:attribute>
					<xsl:attribute name="y2"><xsl:value-of select="number($pos) * ($mh+$ch+$cs) - ($mh div 2)" />px</xsl:attribute>
				</xsl:element>
			</xsl:if>
			
		</xsl:for-each>

		<xsl:if test="not($depIRI or $depIRIBase)">
		    <!-- draw end node -->
    		<xsl:variable name="ex" select="$x+$mw+$is+10" />
			<xsl:variable name="ey" select="$ch+$cs+($mh div 2 )" />
    		<xsl:element name="line">
				<xsl:attribute name="x1"><xsl:value-of select="$x+$mw" />px</xsl:attribute>
				<xsl:attribute name="x2"><xsl:value-of select="$ex" />px</xsl:attribute>
				<xsl:attribute name="y1"><xsl:value-of select="$ey" />px</xsl:attribute>
				<xsl:attribute name="y2"><xsl:value-of select="$ey" />px</xsl:attribute>
			</xsl:element>
			<g id="endProcess">
				<circle cx="{$ex}" cy="{$ey}" r="10" />
				<circle cx="{$ex}" cy="{$ey}" r="7" style="stroke:white; stroke-width:2px;"/>
			</g>
		</xsl:if>
		<!-- FIXME: if y > 1 don't draw -->
	</xsl:template>
	 	    		
	<xsl:template name="method">
		<xsl:param name="method" />
		<xsl:param name="time" />
		<xsl:param name="x" />
		<xsl:param name="y" />
		<xsl:element name="g">
			<xsl:attribute name="style">transform: translate(<xsl:value-of select="$x" />px, <xsl:value-of select="$ch+$cs+$y" />px)</xsl:attribute>

			<xsl:variable name="methodY">
			  <xsl:choose>
			    <xsl:when test="$time"><xsl:value-of select="$mh div 2 - 20" /></xsl:when>
			    <xsl:otherwise><xsl:value-of  select="$mh div 2" /></xsl:otherwise>
			  </xsl:choose>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$time">
					<use x="{$mw div 2 - 7}" y="{$mh div 2 - 7}" xlink:href="#timeProcess" />
					<xsl:element name="line">
						<xsl:attribute name="x1"><xsl:value-of select="0" />px</xsl:attribute>
						<xsl:attribute name="x2"><xsl:value-of select="$mw" />px</xsl:attribute>
						<xsl:attribute name="y1"><xsl:value-of select="$mh div 2" />px</xsl:attribute>
						<xsl:attribute name="y2"><xsl:value-of select="$mh div 2" />px</xsl:attribute>
					</xsl:element>
					<text class="time" y="35">
						<xsl:attribute name="text-anchor">middle</xsl:attribute>	
						<xsl:attribute name="alignment-baseline">central</xsl:attribute>
						<xsl:attribute name="x"><xsl:value-of select="$mw div 2" />px</xsl:attribute>
						<xsl:value-of select="$time/text()" />
					</text>
				</xsl:when>
				<xsl:otherwise><use xlink:href="#process" /></xsl:otherwise>
	    	</xsl:choose>
	    	
			<text class="method">
				<xsl:attribute name="x"><xsl:value-of select="$mw div 2" />px</xsl:attribute>
				<xsl:attribute name="y"><xsl:value-of select="$methodY" />px</xsl:attribute>
				<xsl:attribute name="text-anchor">middle</xsl:attribute>	
				<xsl:attribute name="alignment-baseline">central</xsl:attribute>	
				<xsl:choose>
			      <xsl:when test="$method/skos:prefLabel">
			        <xsl:value-of select="$method/skos:prefLabel/text()" />
			      </xsl:when>
			      <xsl:otherwise>
			        <xsl:value-of select="$method/@rdf:about" />
			      </xsl:otherwise>
			    </xsl:choose>
			</text>
			
			
			<xsl:variable name="startX">
			  <xsl:choose>
			    <xsl:when test="$y &gt; 1"><xsl:value-of select="$is div 2" /></xsl:when>
			    <xsl:otherwise>0</xsl:otherwise>
			  </xsl:choose>
			</xsl:variable>
			
			<xsl:element name="line">
				<xsl:attribute name="x1"><xsl:value-of select="-($is) + $startX" />px</xsl:attribute>
				<xsl:attribute name="x2"><xsl:value-of select="0" />px</xsl:attribute>
				<xsl:attribute name="y1"><xsl:value-of select="$mh div 2" />px</xsl:attribute>
				<xsl:attribute name="y2"><xsl:value-of select="$mh div 2" />px</xsl:attribute>
			</xsl:element>
		</xsl:element>
	</xsl:template>
	    		
	<xsl:template name="componentUnit">
		<xsl:param name="componentUnit" />
		<xsl:param name="y" />
		<xsl:param name="x" />
		<xsl:element name="text">
			<xsl:attribute name="style">transform: translate(2px, <xsl:value-of select="$y*8+2" />px);</xsl:attribute>
			<xsl:attribute name="class">componentUnit</xsl:attribute>
			<xsl:if test="$componentUnit/core:weight">
				<tspan class="weight"><xsl:value-of select="$componentUnit/core:weight/text()" /></tspan>
			</xsl:if>
			<tspan class="ingredient">
				<xsl:variable name="iriComponent" select="$componentUnit/core:hasComponent/@rdf:resource" />
				<xsl:call-template name="component">
			   		<xsl:with-param name="component" select="//rdf:Description[@rdf:about=$iriComponent]" />
			   	</xsl:call-template>
		   	</tspan>
			<xsl:if test="$componentUnit/core:componentAddition">
				<tspan class="addition">(<xsl:value-of select="$componentUnit/core:componentAddition/text()" />)</tspan>
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