<?xml version="1.0" encoding="UTF-8" ?>
<!--
  - Copyright (c) 2014 3 Round Stones Inc., Some Rights Reserved
  -
  - Licensed under the Apache License, Version 2.0 (the "License");
  - you may not use this file except in compliance with the License.
  - You may obtain a copy of the License at
  -
  -     http://www.apache.org/licenses/LICENSE-2.0
  -
  - Unless required by applicable law or agreed to in writing, software
  - distributed under the License is distributed on an "AS IS" BASIS,
  - WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  - See the License for the specific language governing permissions and
  - limitations under the License.
  -
  -->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:sparql="http://www.w3.org/2005/sparql-results#"
    exclude-result-prefixes="xhtml sparql">
    <xsl:import href="iriref.xsl" />
    <xsl:output indent="no" method="xml" />
    <xsl:param name="target" />
    <xsl:variable name="name">
        <xsl:choose>
            <xsl:when test="sparql:sparql/sparql:results/sparql:result[1]/sparql:binding[@name='name']/*">
                <xsl:value-of select="sparql:sparql/sparql:results/sparql:result[1]/sparql:binding[@name='name']/*" />
            </xsl:when>
            <xsl:when test="sparql:sparql/sparql:results/sparql:result[1]/sparql:binding[@name='user']/*">
                <xsl:call-template name="iriref">
                    <xsl:with-param name="iri" select="sparql:sparql/sparql:results/sparql:result[1]/sparql:binding[@name='user']/*"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="iriref">
                    <xsl:with-param name="iri" select="$target"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:template match="/">
        <xsl:variable name="modified" select="sparql:sparql/sparql:results/sparql:result[1]/sparql:binding[@name='modified']/*" />
        <html>
            <head>
                <title><xsl:value-of select="sparql:sparql/sparql:results/sparql:result[1]/sparql:binding[@name='modified']/*" /> Changeset</title>
                <link rel="help" href="../../callimachus-for-web-developers" target="_blank" title="Help" />
                <style>
                    .uri, .bnode, .literal { font-size: large; }
                    .bnode, .literal { font-family: monospace; white-space: pre-wrap; }
                    .predicate { font-weight: bold; }
                    .removed { text-decoration: line-through; }
                </style>
                <script type="text/javascript">
                    jQuery(function($){
                        $('time[property="prov:endedAtTime"]').text(function(){
                            return calli.parseDateTime(this).toLocaleString();
                        });
                    });
                </script>
            </head>
            <body>
                <div class="container">
                    <p><xsl:text>Revised on </xsl:text>
                        <time property="prov:endedAtTime" datetime="{$modified}" datatype="{$modified/@datatype}">
                            <xsl:value-of select="$modified" />
                        </time>
                        <xsl:text> by </xsl:text>
                        <a href="{sparql:sparql/sparql:results/sparql:result[1]/sparql:binding[@name='user']/*}">
                            <xsl:value-of select="$name" />
                        </a>
                    </p>
                    <p>
                        <xsl:for-each select="sparql:sparql/sparql:results/sparql:result[sparql:binding/@name='previous']">
                            <a href="{sparql:binding[@name='previous']/*}">←Previous revision</a>
                            <xsl:text> </xsl:text>
                        </xsl:for-each>
                        <xsl:if test="sparql:sparql/sparql:results/sparql:result[sparql:binding/@name='subsequent']">
                            <xsl:text>|</xsl:text>
                        </xsl:if>
                        <xsl:for-each select="sparql:sparql/sparql:results/sparql:result[sparql:binding/@name='subsequent']">
                            <xsl:text> </xsl:text>
                            <a href="{sparql:binding[@name='subsequent']/*}">Subsequent revision→</a>
                        </xsl:for-each>
                    </p>
                    <xsl:for-each-group select="sparql:sparql/sparql:results/sparql:result[sparql:binding/@name='subject']"
                            group-by="sparql:binding[@name='subject']/*">
                        <a href="{sparql:binding[@name='subject']/*}">
                            <xsl:call-template name="iriref">
                                <xsl:with-param name="iri" select="sparql:binding[@name='subject']/*"/>
                            </xsl:call-template>
                        </a>
                        <ul>
                            <xsl:apply-templates select="current-group()" />
                        </ul>
                    </xsl:for-each-group>
                </div>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="sparql:result[sparql:binding/@name='subject']">
        <xsl:variable name="subject" select="sparql:binding[@name='subject']/*" />
        <xsl:variable name="predicate" select="sparql:binding[@name='predicate']/*" />
        <xsl:variable name="object" select="sparql:binding[@name='object']/*" />
        <li resource="{$subject}">
            <label class="predicate">
                <xsl:call-template name="iriref">
                    <xsl:with-param name="iri" select="$predicate"/>
                </xsl:call-template>
            </label>
            <xsl:text> </xsl:text>
            <span>
                <xsl:if test="string(sparql:binding[@name='added']/*)!=$target">
                    <xsl:attribute name="class">
                        <xsl:text>removed</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <xsl:apply-templates select="sparql:binding[@name='object']" />
            </span>
        </li>
    </xsl:template>
    <xsl:template match="sparql:binding">
        <xsl:apply-templates select="*" />
    </xsl:template>
    <xsl:template match="sparql:uri">
        <a href="{text()}" class="uri">
            <xsl:attribute name="rel">
                <xsl:call-template name="iriref">
                    <xsl:with-param name="iri" select="text()" />
                </xsl:call-template>
            </xsl:attribute>
            <xsl:call-template name="iriref">
                <xsl:with-param name="iri" select="text()"/>
            </xsl:call-template>
        </a>
    </xsl:template>
    <xsl:template match="sparql:bnode">
        <span class="bnode">
            <xsl:value-of select="text()" />
        </span>
    </xsl:template>
    <xsl:template match="sparql:literal">
        <span class="literal">
            <xsl:value-of select="text()" />
        </span>
    </xsl:template>
    <xsl:template
        match="sparql:literal[@datatype='http://www.w3.org/1999/02/22-rdf-syntax-ns#XMLLiteral']">
        <span class="literal" datatype="rdf:XMLLiteral">
            <xsl:value-of disable-output-escaping="yes" select="text()" />
        </span>
    </xsl:template>
</xsl:stylesheet>
