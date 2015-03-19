<?xml version="1.0" encoding="iso-8859-1" standalone="yes"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:pom="http://maven.apache.org/POM/4.0.0"
                xmlns:graphml="http://graphml.graphdrawing.org/xmlns"
                xmlns:y="http://www.yworks.com/xml/graphml"
                xmlns="http://maven.apache.org/POM/4.0.0"
                exclude-result-prefixes="#all">
	
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	
	<xsl:param name="bom-uri"/>
	
	<xsl:variable name="bom" select="doc($bom-uri)"/>
	
	<xsl:template match="/pom:project">
		<xsl:copy>
			<xsl:apply-templates select="*"/>
			<xsl:if test="not(pom:groupId)">
				<xsl:call-template name="groupId"/>
			</xsl:if>
			<xsl:if test="not(pom:build)">
				<build>
					<plugins>
						<xsl:call-template name="plugins"/>
					</plugins>
				</build>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/pom:project/pom:groupId">
		<xsl:call-template name="groupId"/>
	</xsl:template>
	
	<xsl:template name="groupId">
		<groupId>test</groupId>
	</xsl:template>
	
	<xsl:template match="/pom:project/pom:artifactId">
		<xsl:copy>test</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/pom:project/pom:version">
		<xsl:copy>0</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/pom:project/pom:dependencies">
		<xsl:copy>
			<xsl:variable name="dependencies" as="element()*" select="*"/>
			<xsl:variable name="bom-dependencies" as="element()*"
			              select="$bom/pom:project/pom:dependencyManagement/pom:dependencies/*"/>
			<xsl:variable name="all-dependencies" as="element()*">
				<xsl:apply-templates select="doc(resolve-uri('tree.graphml',base-uri(/*)))"/>
			</xsl:variable>
			<xsl:variable name="self-groupId" as="xs:string"
			              select="normalize-space(string((/pom:project/pom:groupId,/pom:project/pom:parent/pom:groupId)[1]))"/>
			<xsl:variable name="self-artifactId" as="xs:string"
			              select="normalize-space(string(/pom:project/pom:artifactId))"/>
			<xsl:for-each select="$all-dependencies">
				<xsl:variable name="groupId" as="xs:string" select="pom:groupId/normalize-space(string(.))"/>
				<xsl:variable name="artifactId" as="xs:string" select="pom:artifactId/normalize-space(string(.))"/>
				<xsl:variable name="type" as="xs:string?" select="pom:type/normalize-space(string(.))"/>
				<xsl:variable name="version" as="xs:string" select="pom:version/normalize-space(string(.))"/>
				<xsl:variable name="scope" as="xs:string?" select="pom:scope/normalize-space(string(.))"/>
				<xsl:variable name="bom-version" as="xs:string?"
				              select="$bom-dependencies[pom:is-dependency(.,$groupId,$artifactId,$type)]
				                      /pom:version/normalize-space(string(.))"/>
				<xsl:variable name="is-direct" as="xs:boolean"
				              select="exists($dependencies[pom:is-dependency(.,$groupId,$artifactId,$type)])"/>
				<xsl:choose>
					<xsl:when test="$bom-version and not($bom-version[1]=$version)">
						<xsl:if test="$is-direct">
							<xsl:message select="concat('[WARNING] A version is declared on ',
								                        string-join(($groupId,$artifactId,$type),':'),
								                        '. Move to BOM?')"/>
						</xsl:if>
						<xsl:sequence select="pom:dependency($groupId,$artifactId,$type,$bom-version,$scope)"/>
					</xsl:when>
					<xsl:when test="$is-direct">
						<xsl:sequence select="."/>
					</xsl:when>
					<xsl:when test="$groupId=$self-groupId and $artifactId=$self-artifactId">
						<xsl:sequence select="."/>
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="/pom:project/pom:modules"/>
	
	<xsl:template match="/pom:project/pom:build">
		<xsl:copy>
			<xsl:apply-templates select="*"/>
			<xsl:if test="not(pom:plugins)">
				<plugins>
					<xsl:call-template name="plugins"/>
				</plugins>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="plugins">
		<xsl:call-template name="disable-maven-compiler-plugin"/>
		<xsl:call-template name="disable-maven-resources-plugin"/>
	</xsl:template>
	
	<xsl:template match="/pom:project/pom:build/pom:plugins">
		<xsl:copy>
			<xsl:apply-templates select="*"/>
			<xsl:call-template name="disable-maven-compiler-plugin"/>
			<xsl:call-template name="disable-maven-resources-plugin"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="disable-maven-compiler-plugin">
		<plugin>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-compiler-plugin</artifactId>
			<executions>
				<execution>
					<id>default-compile</id>
					<phase>none</phase>
				</execution>
			</executions>
		</plugin>
	</xsl:template>
	
	<xsl:template name="disable-maven-resources-plugin">
		<plugin>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-resources-plugin</artifactId>
			<executions>
				<execution>
					<id>default-resources</id>
					<phase>none</phase>
				</execution>
			</executions>
		</plugin>
	</xsl:template>
	
	<xsl:template match="/pom:project/pom:build/pom:plugins/pom:plugin/pom:executions/pom:execution">
		<xsl:if test="not(pom:phase)
		              or normalize-space(string(pom:phase))
		                 =('generate-test-sources',
		                   'process-test-sources',
		                   'generate-test-resources',
		                   'process-test-resources',
		                   'test-compile',
		                   'process-test-classes',
		                   'test')">
			<xsl:next-match/>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="/graphml:graphml">
		<xsl:for-each select="graphml:graph/graphml:node/graphml:data/y:ShapeNode/y:NodeLabel">
			<xsl:variable name="tokens" as="xs:string*" select="tokenize(tokenize(normalize-space(string(.)),' ')[1],':')"/>
			<xsl:sequence select="pom:dependency($tokens[1],
			                                     $tokens[2],
			                                     if ($tokens[3]='bundle') then () else $tokens[3],
			                                     $tokens[4],
			                                     $tokens[5])"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:function name="pom:dependency" as="element()">
		<xsl:param name="groupId" as="xs:string"/>
		<xsl:param name="artifactId" as="xs:string"/>
		<xsl:param name="type" as="xs:string?"/>
		<xsl:param name="version" as="xs:string"/>
		<xsl:param name="scope" as="xs:string?"/>
		<dependency>
			<groupId>
				<xsl:value-of select="$groupId"/>
			</groupId>
			<artifactId>
				<xsl:value-of select="$artifactId"/>
			</artifactId>
			<xsl:if test="$type and not($type='jar')">
				<type>
					<xsl:value-of select="$type"/>
				</type>
			</xsl:if>
			<version>
				<xsl:value-of select="$version"/>
			</version>
			<xsl:if test="$scope and not($scope='compile')">
				<scope>
					<xsl:value-of select="$scope"/>
				</scope>
			</xsl:if>
		</dependency>
	</xsl:function>
	
	<xsl:function name="pom:is-dependency" as="xs:boolean">
		<xsl:param name="context" as="node()"/>
		<xsl:param name="groupId" as="xs:string"/>
		<xsl:param name="artifactId" as="xs:string"/>
		<xsl:sequence select="pom:is-dependency($context,$groupId,$artifactId,())"/>
	</xsl:function>
	
	<xsl:function name="pom:is-dependency" as="xs:boolean">
		<xsl:param name="context" as="node()"/>
		<xsl:param name="groupId" as="xs:string"/>
		<xsl:param name="artifactId" as="xs:string"/>
		<xsl:param name="type" as="xs:string?"/>
		<xsl:sequence select="exists($context[
		                        self::pom:dependency
		                        and normalize-space(string(pom:groupId))=$groupId
		                        and normalize-space(string(pom:artifactId))=$artifactId
		                        and ($type,'jar')[1]=(pom:type/normalize-space(string(.)),'jar')[1]])"/>
	</xsl:function>
	
</xsl:stylesheet>
