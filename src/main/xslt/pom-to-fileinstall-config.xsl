<?xml version="1.0" encoding="iso-8859-1" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:pom="http://maven.apache.org/POM/4.0.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">
	<xsl:param name="id"/>
	<xsl:param name="startLevel"/>
	<xsl:param name="dest"/>
	<xsl:param name="prefix"/>
	<xsl:output method="text" encoding="UTF-8" name="text"/>
	<xsl:template match="/*">
		<xsl:for-each select="//pom:execution[pom:id=$id]/pom:configuration//pom:artifactItem">
			<xsl:variable name="groupId" select="pom:groupId"/>
			<xsl:variable name="artifactId" select="pom:artifactId"/>
			<xsl:variable name="version" select="if (pom:version) then pom:version
			                                     else /pom:project/pom:dependencyManagement//pom:dependency
			                                       [pom:groupId=$groupId and pom:artifactId=$artifactId]/pom:version"/>
			<xsl:variable name="classifier" select="pom:classifier"/>
			<xsl:variable name="classifierSuffix" select="if ($classifier) then concat('-', $classifier) else ''"/>
			<xsl:result-document href="{concat($dest, '/', 'org.apache.felix.fileinstall-', $prefix, '-', $artifactId, $classifierSuffix, '.cfg')}" format="text">
				<xsl:text>felix.fileinstall.start.level=</xsl:text>
				<xsl:value-of select="$startLevel"/>
				<xsl:text>&#xA;</xsl:text>
				<xsl:text>felix.fileinstall.dir=</xsl:text>
				<xsl:value-of select="concat('${user.home}/.m2/repository/', replace($groupId, '\.', '/'), '/', $artifactId, '/', $version)"/>
				<xsl:text>&#xA;</xsl:text>
				<xsl:text>felix.fileinstall.filter=</xsl:text>
				<xsl:value-of select="replace(concat($artifactId, '-', $version,  $classifierSuffix, '.jar'), '\.', '\\\\.')"/>
				<xsl:text>&#xA;</xsl:text>
				<xsl:text>felix.fileinstall.noInitialDelay=true&#xA;</xsl:text>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
