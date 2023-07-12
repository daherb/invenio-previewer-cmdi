<?xml version="1.0"?>
<xsl:stylesheet xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:cmd="http://www.clarin.eu/cmd/" xmlns:cmde="http://www.clarin.eu/cmd/1" xmlns:functx="http://www.functx.com" xmlns:foo="foo.com" xmlns:fn="http://www.w3.org/2005/xpath-functions" version="1.0" exclude-result-prefixes="xs xd functx">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Jan 24, 2017</xd:p>
      <xd:p><xd:b>Author:</xd:b> ttrippel, czinn</xd:p>
      <xd:p/>
    </xd:desc>
  </xd:doc>

  <!-- Stylesheets with templates used in multiple places:  -->
  <xsl:output method="html" indent="yes"/><xsl:template match="*" mode="comma-separated-text">
    <xsl:if test="text()">
      <xsl:value-of select="text()"/>
      <xsl:if test="last() &gt; 1 and position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template><xsl:template match="*" mode="link-to-url">
    <xsl:param name="link-text" select="./text()"/>
    <xsl:param name="same-as" select="false()"/>
    <xsl:element name="a">
      <xsl:if test="$same-as">
        <xsl:attribute name="itemprop">sameAs</xsl:attribute>
      </xsl:if>
      <xsl:attribute name="href">
        <xsl:value-of select="./text()"/>
      </xsl:attribute>
      <xsl:value-of select="$link-text"/>
    </xsl:element>
  </xsl:template><xsl:template match="@*[local-name() = 'src']" mode="link-to-url">
    <xsl:param name="link-text" select="../text()"/>
    <xsl:element name="a">
      <xsl:attribute name="href">
        <xsl:value-of select="."/>
      </xsl:attribute>
      <xsl:value-of select="$link-text"/>
    </xsl:element>
  </xsl:template><xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
	<xsl:value-of select="substring-before($text,$replace)"/>
	<xsl:value-of select="$with"/>
	<xsl:call-template name="replace-string">
	  <xsl:with-param name="text" select="substring-after($text,$replace)"/>
	  <xsl:with-param name="replace" select="$replace"/>
	  <xsl:with-param name="with" select="$with"/>
	</xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template match="*[local-name() = 'Descriptions']">
    <xsl:for-each select="*[local-name() = 'Description']">
      <xsl:if test="./text()">
        <xsl:element name="p">
          <xsl:if test="@xml:lang != ''">
            <xsl:attribute name="lang">
              <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:if>
    </xsl:for-each>
  </xsl:template><xsl:template match="       *[local-name() = 'CreationToolInfo' or       local-name() = 'AnalysisToolInfo' or       local-name() = 'AnnotationToolInfo' or       local-name() = 'DeploymentToolInfo' or       local-name() = 'DerivationToolInfo']" mode="list-item">

    <!-- first child (CreationTool, AnnotationTool, etc.) contains name:-->
    <xsl:variable name="toolName" select="./*[1]/text()"/>
    <xsl:if test="$toolName">
      <li>
        <p>
          <xsl:choose>
            <xsl:when test="./*[local-name() = 'Url']/text()">
              <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
                <xsl:with-param name="link-text" select="$toolName"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$toolName"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="./*[local-name() = 'ToolType']/text()">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="normalize-space(./*[local-name() = 'ToolType'])"/>
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:if test="./*[local-name() = 'Version']/text()">
            <xsl:text>, version </xsl:text>
            <xsl:value-of select="normalize-space(./*[local-name() = 'Version'])"/>
          </xsl:if>
        </p>
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      </li>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'AuthoritativeIDs']" mode="link-tags">
    <xsl:apply-templates select="./*[local-name() = 'AuthoritativeID']/*[local-name() = 'id' and text()]" mode="link-tag"/>
  </xsl:template><xsl:template match="*[local-name() = 'id']" mode="link-tag">
    <xsl:element name="link">
      <xsl:attribute name="itemprop">sameAs</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="./text()"/>
      </xsl:attribute>
    </xsl:element>
  </xsl:template><xsl:template match="*[local-name() = 'AuthoritativeID']" mode="link-with-comma">
    <xsl:if test="./*[local-name() = 'id']/text()">
      <xsl:apply-templates select="./*[local-name() = 'id']" mode="link-to-url">
        <xsl:with-param name="link-text" select="./*[local-name() = 'issuingAuthority']"/>
        <xsl:with-param name="same-as" select="true()"/>
      </xsl:apply-templates>
      <xsl:if test="last() &gt; 1 and position() != last()">
        <xsl:text>, </xsl:text>
      </xsl:if>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'Person']" mode="list-item-with-role">
    <xsl:variable name="fullName">
      <xsl:value-of select="./*[local-name() = 'firstName']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'lastName']"/>
    </xsl:variable>

    <li itemscope="" itemtype="https://schema.org/Person">
      <span itemprop="name">
        <xsl:value-of select="$fullName"/>
      </span>
      <xsl:if test="./*[local-name() = 'role'] != ''">
        <xsl:text>, </xsl:text>
        <xsl:value-of select="./*[local-name() = 'role']"/>
      </xsl:if>

      <xsl:if test="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']">
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']" mode="link-with-comma"/>
      </xsl:if>
    </li>
  </xsl:template><xsl:template match="*[local-name() = 'SubjectLanguages']" mode="details">
    <details>
      <summary>Subject languages</summary>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <ul>
        <xsl:apply-templates select="./*[local-name() = 'SubjectLanguage']" mode="list-item"/>
      </ul>
    </details>
  </xsl:template><xsl:template match="*[local-name() = 'SubjectLanguage']" mode="list-item">
    <li>
      <p>
        <xsl:value-of select=".//*[local-name() = 'LanguageName']"/>
        <xsl:apply-templates select="." mode="language-roles"/>
      </p>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    </li>
  </xsl:template><xsl:template match="*[local-name() = 'SubjectLanguage']" mode="language-roles">
    <xsl:if test="         ./*[local-name() = 'DominantLanguage' or         local-name() = 'SourceLanguage' or         local-name() = 'TargetLanguage']">

      <xsl:text> (</xsl:text>
      <xsl:for-each select="           ./*[(local-name() = 'DominantLanguage' or           local-name() = 'SourceLanguage' or           local-name() = 'TargetLanguage')           and text() = 'true']">

        <xsl:value-of select="             concat(substring-before(local-name(), 'Language'),             ' language')"/>
        <xsl:if test="last() &gt; position()">
          <xsl:text>, </xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'TypeSpecificSizeInfo']" mode="list">
    <xsl:variable name="referenceid">
      <xsl:value-of select="@*[local-name() = 'ref']"/>
    </xsl:variable>
    <xsl:variable name="title">
      <xsl:value-of select="../../../..//*[local-name() = 'ResourceProxyListInfo']/*[local-name() = 'ResourceProxyInfo'][@*[local-name()='ref']=$referenceid]/*[local-name() = 'ResProxItemName']"/>
    </xsl:variable>

    <xsl:if test=".//*[local-name() = 'Size' and text()]">
      <xsl:if test="$title != ''">
        <h4><xsl:value-of select="$title"/></h4>
      </xsl:if>
      <ul>
        <xsl:apply-templates select="./*[local-name() = 'TypeSpecificSize']" mode="list-item"/>
      </ul>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'TypeSpecificSize']" mode="list-item">
    <li>
      <xsl:value-of select="./*[local-name() = 'Size']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'SizeUnit']"/>
    </li>
  </xsl:template>

  <!-- Stylesheets for individual components: -->
  <xsl:output method="html" indent="yes"/><xsl:template match="*[local-name() = 'GeneralInfo']" mode="def-list">
    <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
    <dl>
      <dt>Resource Name</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ResourceName']"/>
      </dd>

      <dt>Resource Title</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ResourceTitle']"/>
      </dd>

      <xsl:if test="//*[local-name() = 'IsPartOfList']/*[local-name() = 'IsPartOf']/text()">
        <dt>Part of Collection</dt>
        <dd>
          <ul>
            <xsl:for-each select="//*[local-name() = 'IsPartOfList']/*[local-name() = 'IsPartOf']">
              <li>
                <xsl:apply-templates select="." mode="link-to-url"/>
              </li>
            </xsl:for-each>
          </ul>
        </dd>
      </xsl:if>

      <dt>Resource Class</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ResourceClass']"/>
      </dd>

      <dt>Version</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'Version']"/>
      </dd>

      <dt>Life Cycle Status</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'LifeCycleStatus']"/>
      </dd>

      <dt>Start Year</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'StartYear']"/>
      </dd>

      <dt>Completion Year</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'CompletionYear']"/>
      </dd>

      <dt>Publication Date</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'PublicationDate']"/>
      </dd>

      <dt>Last Update</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'LastUpdate']"/>
      </dd>

      <dt>Time Coverage</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'TimeCoverage']"/>
      </dd>

      <dt>Legal Owner</dt>
      <dd>
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'LegalOwner']/text()">
            <xsl:value-of select="./*[local-name() = 'LegalOwner']"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Not specified</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </dd>

      <dt>Genre</dt>
      <dd>
        <xsl:apply-templates select="./*[local-name() = 'Genre']" mode="comma-separated-text"/>
      </dd>

      <dt>Field of Research</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'FieldOfResearch']"/>
      </dd>

      <dt>Location</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'Location']/*[local-name() = 'Country']/*[local-name() = 'CountryName']"/>
      </dd>

      <dt>Tags</dt>
      <dd>
        <xsl:apply-templates select="*[local-name() = 'tags']/*[local-name() = 'tag']" mode="comma-separated-text"/>
      </dd>

      <dt>Modality Info</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ModalityInfo']//*[local-name() = 'Modalities']"/>
        <xsl:apply-templates select="./*[local-name() = 'ModalityInfo']/*[local-name() = 'Descriptions']"/>
      </dd>
    </dl>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template match="*[local-name() = 'Project']" mode="def-list">
    <xsl:call-template name="ProjectTitleAsHeadline"/>
    <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
    <xsl:if test="./*[local-name() = 'Person']">
      <h3>Project members</h3>
      <ol>
        <xsl:apply-templates select="./*[local-name() = 'Person']" mode="list-item-with-role"/>
      </ol>
    </xsl:if>

    <xsl:apply-templates select="./*[local-name() = 'Cooperations']" mode="list"/>

    <h3>Institutional details</h3>
    <dl>
      <dt>Project ID</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'ProjectID']"/>
      </dd>

      <dt>Url</dt>
      <dd>
        <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url"/>
      </dd>

      <dt>Funder</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'Funder']/*[local-name() = 'fundingAgency']"/>
        <xsl:if test="./*[local-name() = 'Funder']/*[local-name() = 'fundingReferenceNumber'] != ''">
          <xsl:text>, with reference: </xsl:text>
          <xsl:value-of select="./*[local-name() = 'Funder']/*[local-name() = 'fundingReferenceNumber']"/>
        </xsl:if>
      </dd>

      <dt>Institution</dt>
      <dd>
        <xsl:apply-templates select="*[local-name() = 'Institution']"/>
      </dd>

      <dt>Duration</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'Duration']/*[local-name() = 'StartYear']"/>
        <xsl:if test="./*[local-name() = 'Duration']/*[local-name() = 'CompletionYear'] != ''">
          <xsl:text>–</xsl:text>
          <xsl:value-of select="./*[local-name() = 'Duration']/*[local-name() = 'CompletionYear']"/>
        </xsl:if>
      </dd>

    </dl>

  </xsl:template><xsl:template match="*[local-name() = 'Institution']">
    <xsl:choose>
      <xsl:when test="./*[local-name() = 'Url']/text()">
        <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
          <xsl:with-param name="link-text" select="./*[local-name() = 'Department']"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="*[local-name() = 'Department']"/>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
    <xsl:for-each select="./*[local-name() = 'Organisation']">
      <span itemscope="" itemtype="https://schema.org/Organization">
        <span itemprop="name">
          <xsl:value-of select="./*[local-name() = 'name']"/>
        </span>
        <xsl:apply-templates select="./*[local-name() = 'AuthoritativeIDs']" mode="link-tags"/>
      </span>
      <br/>
    </xsl:for-each>
  </xsl:template><xsl:template match="*[local-name() = 'name']">
    <xsl:if test="./@xml:lang">
      <xsl:if test="./@xml:lang = 'nl'"> Dutch: <xsl:value-of select="."/><br/>
      </xsl:if>
      <xsl:if test="./@xml:lang = 'en'"> English: <xsl:value-of select="."/><br/>
      </xsl:if>
      <xsl:if test="./@xml:lang = 'de'"> German: <xsl:value-of select="."/><br/>
      </xsl:if>
    </xsl:if>
    <xsl:if test="not(./@xml:lang = 'en' or ./@xml:lang = 'de' or ./@xml:lang = 'nl')"> Other:
        <xsl:value-of select="."/><br/>
    </xsl:if>
  </xsl:template><xsl:template name="ProjectTitleAsHeadline">
    <h3>
      <xsl:value-of select="./*[local-name() = 'ProjectTitle']"/>
      <xsl:text> (</xsl:text>
      <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
        <xsl:with-param name="link-text">
          <xsl:value-of select="./*[local-name() = 'ProjectName']"/>
        </xsl:with-param>
      </xsl:apply-templates>
      <xsl:text>)</xsl:text>
    </h3>
  </xsl:template><xsl:template match="*[local-name() = 'Cooperations']" mode="list">
    <xsl:if test="./*[local-name() = 'Cooperation']/*[local-name() = 'CooperationPartner']/text()">
      <h3>Cooperation</h3>
      <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
      <ol>
        <xsl:apply-templates select="./*[local-name() = 'Cooperation']" mode="list-item"/>
      </ol>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'Cooperation']" mode="list-item">
    <xsl:variable name="partnerName">
      <xsl:value-of select="./*[local-name() = 'CooperationPartner']"/>
        <xsl:if test="./*[local-name() = 'Department']/text()">
          <xsl:text>, </xsl:text>  
          <xsl:value-of select="./*[local-name() = 'Department']"/>
        </xsl:if>
        <xsl:if test="./*[local-name() = 'Organisation']/text()">
          <xsl:text>, </xsl:text>  
          <xsl:value-of select="./*[local-name() = 'Organisation']"/>
        </xsl:if>
    </xsl:variable>

    <li>
      <p>
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'Url']/text()">
            <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
              <xsl:with-param name="link-text">
                <xsl:value-of select="$partnerName"/>
              </xsl:with-param>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$partnerName"/>
          </xsl:otherwise>
        </xsl:choose>
      </p>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    </li>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template match="*[local-name() = 'Publications']">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <xsl:choose>
      <xsl:when test=".//*[local-name() = 'PublicationTitle' and text()]">
        <ol>
          <xsl:apply-templates select="./*[local-name() = 'Publication']" mode="list-item"/>
        </ol>
      </xsl:when>
      <xsl:otherwise>
        <p>No information is available about publications related to this resource.</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template match="*[local-name() = 'Publication']" mode="list-item">
    <li itemscope="" itemtype="https://schema.org/ScholarlyArticle">
      <p>
        <!-- authors -->
        <xsl:apply-templates select="./*[local-name() = 'Author']" mode="name-with-links-in-list"/>
        <!-- title -->
        <cite>
          <xsl:value-of select="./*[local-name() = 'PublicationTitle']"/>
        </cite>
        <xsl:text>. </xsl:text>
        <!-- link -->
        <xsl:apply-templates select="./*[local-name() = 'resolvablePID']" mode="link-to-url">
          <xsl:with-param name="same-as" select="true()"/>
        </xsl:apply-templates>
      </p>
      <xsl:if test=".//*[local-name() = 'Description' and text()]">
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/> 
      </xsl:if>
    </li>
  </xsl:template><xsl:template match="*[local-name() = 'Author']" mode="name-with-links-in-list">
    <xsl:variable name="authorName">
      <xsl:value-of select="./*[local-name() = 'firstName']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'lastName']"/>
    </xsl:variable>

    <xsl:if test="$authorName != ' '">
      <!-- the name and links: -->
      <span itemscope="" itemprop="author" itemtype="https://schema.org/Person">
        <xsl:apply-templates select="./*[local-name() = 'AuthoritativeIDs']" mode="link-tags"/>
        <!-- name comes *after* <link>s because they introduce phantom space in rendered HTML:-->
        <xsl:value-of select="$authorName"/>
      </span>
      <!-- following punctuation in the list: -->
      <xsl:choose>
        <xsl:when test="position() = last() - 1">
          <xsl:text> and </xsl:text>
        </xsl:when>
        <xsl:when test="last() &gt; position()">
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:when test="last() = position() and last() &gt; 0">
          <!-- only generate a period at the end of nonempty lists -->
          <xsl:text>. </xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:if>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template match="*[local-name() = 'Creation']">
    <!-- TODO: topic? This looks more like "keywords" rather than anything that can usefully be printed  -->
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>

    <xsl:apply-templates select="./*[local-name() = 'Creators']" mode="section"/>
    <section>
      <h3>Creation process</h3>
      <xsl:call-template name="SourcesDetails"/>
      <xsl:apply-templates select="./*[local-name() = 'Annotation']" mode="details"/>
      <xsl:call-template name="CreationToolsSection"/>
    </section>

  </xsl:template><xsl:template match="*[local-name() = 'Creators']" mode="section">
    <section>
      <h3>Creators</h3>
      <xsl:choose>
        <!-- avoid generating an empty list when there are no last names: -->
        <xsl:when test="./*[local-name() = 'Person']/*[local-name() = 'lastName']/text()">
          <address>
            <ol>
              <xsl:apply-templates select="./*[local-name() = 'Person']" mode="list-item-with-role"/>
            </ol>
          </address>
        </xsl:when>
        <xsl:otherwise>
          <p>No information available about the creators of this resource.</p>
        </xsl:otherwise>
      </xsl:choose>
    </section>
  </xsl:template><xsl:template name="SourcesDetails">
    <!-- we call this by name because there is no <Sources> wrapper element
         under which <Source> elements are collected, somewhat exceptionally -->

    <xsl:if test="./*[local-name() = 'Source']">
      <details>
        <summary>Original Sources</summary>
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'Source']/*[local-name() = 'OriginalSource']/text()">
            <ol>
              <xsl:apply-templates select="./*[local-name() = 'Source']" mode="list-item"/>
            </ol>
          </xsl:when>
          <xsl:otherwise>
            <p>No information on original sources available for this resource.</p>
          </xsl:otherwise>
        </xsl:choose>
      </details>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'Source']" mode="list-item">
    <li>
      <p>
        <cite>
          <xsl:value-of select="./*[local-name() = 'OriginalSource']"/>
        </cite>
        <xsl:if test="./*[local-name() = 'SourceType'] != ''">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="./*[local-name() = 'SourceType']"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </p>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <xsl:apply-templates select="./*[local-name() = 'MediaFiles']" mode="details"/>
      <xsl:apply-templates select="./*[local-name() = 'Derivation']" mode="details"/>
    </li>
  </xsl:template><xsl:template match="*[local-name() = 'MediaFiles']" mode="details">
      <details>
        <summary>Media files</summary>
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
        <xsl:choose>
          <xsl:when test="./*[local-name() = 'MediaFile']">
            <ol>
              <xsl:apply-templates select="./*[local-name() = 'MediaFile']" mode="list-item"/>
            </ol>
          </xsl:when>
          <xsl:otherwise>
            <p>No information about media files is available for this source.</p>
          </xsl:otherwise>
        </xsl:choose>
      </details>
  </xsl:template><xsl:template match="*[local-name() = 'MediaFile']" mode="list-item">
    <xsl:if test="./*[local-name() = 'CatalogueLink' and text()]"> 
      <li>
        <xsl:apply-templates select="./*[local-name() = 'CatalogueLink']" mode="link-to-url"/> 
        <xsl:if test="./*[local-name() = 'Type' and (text() != 'Unknown' or text() != 'Unspecified')]">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="./*[local-name() = 'Type']"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      </li>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'Derivation']" mode="details">
      <details>
        <summary>Derivation</summary>
        <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
        <dl>
          <dt>Organisation</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'Organisation']"/>
          </dd>
 
          <dt>Date</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'DerivationDate']"/>
          </dd>
                          
          <dt>Mode</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'DerivationMode']"/>
          </dd>
 
          <dt>Type</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'DerivationType']"/>
          </dd>
 
          <dt>Workflow</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'DerivationWorkflow']"/>
          </dd>

          <dt>Derivation tools</dt>
          <dd>
            <ul>
              <xsl:apply-templates select="./*[local-name() = 'DerivationToolInfo']" mode="list-item"/>
            </ul>
          </dd>

        </dl>
      </details>
  </xsl:template><xsl:template match="*[local-name() = 'Annotation']" mode="details">
    <details>
      <summary>Annotation</summary>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <dl>
        <dt>Annotation mode</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'AnnotationMode']"/>
        </dd>

        <dt>Annotation standoff</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'AnnotationStandoff']"/>
        </dd>

        <dt>Interannotator agreement</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'InterannotatorAgreement']"/>
        </dd>

        <dt>Annotation format</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'AnnotationFormat']"/>
        </dd>

        <dt>Segmentation units</dt>
        <dd>
          <xsl:if test=".//*[local-name() = 'SegmentationUnit']">
            <p>
              <xsl:apply-templates select=".//*[local-name() = 'SegmentationUnit']" mode="comma-separated-text"/>
            </p>
          </xsl:if>
          <xsl:apply-templates select="./*[local-name() = 'SegmentationUnits']/*[local-name() = 'Descriptions']"/>
        </dd>
        
        <dt>Annotation types</dt>
        <dd>
          <dl>
            <dt>Levels</dt>
            <dd>
              <xsl:apply-templates select=".//*[local-name() = 'AnnotationLevelType']" mode="comma-separated-text"/>
            </dd>
            
            <dt>Modes</dt>
            <dd>
              <xsl:apply-templates select=".//*[local-name() = 'AnnotationMode']" mode="comma-separated-text"/>
            </dd>
            
            <dt>Tag sets</dt>
            <dd>
              <xsl:apply-templates select=".//*[local-name() = 'Tagset']" mode="comma-separated-text"/>
            </dd>
          </dl>
          <xsl:apply-templates select="./*[local-name() = 'AnnotationTypes']/*[local-name() = 'Descriptions']"/>
        </dd>

        <dt>Annotation tools</dt>
        <dd>
          <ul>
            <xsl:apply-templates select="./*[local-name() = 'AnnotationToolInfo']" mode="list-item"/>
          </ul>
        </dd>

      </dl>
    </details>
  </xsl:template><xsl:template name="ViolationText">
      <!-- Provides the contents of the "Report Violation" tab -->
      <p>
      	To report a violation on this resource, please click on the following link to send an email: 
	<xsl:element name="a">
	  <xsl:attribute name="href">
	    <xsl:text>mailto:data-steward@ids-mannheim.de?subject=Report%20Violation:</xsl:text> <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
	    <xsl:text>&amp;body=Dear IDS repository team! I'd like to report a violation with regard to resource mentioned in the subject line. The reasons are as follows: PLEASE GIVE  REASONS HERE</xsl:text>
	  </xsl:attribute>
	  <bf>CLICK HERE TO REPORT VIOLATION.</bf>
	</xsl:element>
      </p>	  
    </xsl:template><xsl:template name="CitationExamples">
    <!-- Provides the contents of the "Cite data set" tab -->
    <p>Please cite the data set itself as follows:</p>
    <blockquote>
      <xsl:call-template name="DatasetCitation"/>
    </blockquote>
    <xsl:if test="count(//*[local-name() = 'ResourceType' and text() = 'Resource']) &gt; 1">
      <p>
        Individual items in the data set may be cited using their
        persistent identifiers (see <a href="#data-files">Data files</a>).
        For example, cite the file
        <code><xsl:value-of select="substring-after((//*[local-name() = 'ResourceRef' and preceding-sibling::*[text() = 'Resource']])[2], '@')"/></code>
        as follows:
      </p>
      <blockquote>
        <xsl:call-template name="InDatasetCitation"/>
      </blockquote>  
    </xsl:if>
  </xsl:template><xsl:template name="DatasetCitation">
    <!-- Provides a citation for the whole dataset -->
      <xsl:call-template name="CreatorsAsCommaSeparatedText"/>
      <xsl:call-template name="CreationDatesAsText"/>
      <xsl:call-template name="TitleAsCite"/>
      Data set in IDS Repository. 
      <br/>Persistent identifier:
      <xsl:apply-templates select="//*[local-name() = 'MdSelfLink']" mode="link-to-url"/>
  </xsl:template><xsl:template name="InDatasetCitation">
    <!-- Provides an example citation of an individual item in the
         collection, using the second ResourceRef element in the document.
         (We use the second because the first might be the landing page and have the same 
         PID as the data set itself.
    -->
      <xsl:call-template name="CreatorsAsCommaSeparatedText"/>
      <xsl:call-template name="CreationDatesAsText"/>
      <xsl:value-of select="substring-after((//*[local-name() = 'ResourceRef'])[2], '@')"/>
      <xsl:text>. </xsl:text>
      In: <xsl:call-template name="TitleAsCite"/>
      Data set in IDS Repository. 
      <br/>Persistent identifier:
      <xsl:apply-templates select="(//*[local-name() = 'ResourceRef'])[2]" mode="link-to-url"/>
  </xsl:template><xsl:template name="CreatorsAsCommaSeparatedText">
    <!-- Get the list of creators, last name followed by initial, comma separated -->
    <xsl:for-each select="//*[local-name() = 'Creators']/*[local-name() = 'Person']/.">
      <xsl:choose>
        <!-- when ID is available, markup the creator's name as an author -->
        <!-- See: https://html.spec.whatwg.org/multipage/links.html#link-type-author -->
        <xsl:when test="./*[local-name() = 'AuthoritativeIDs']/*[local-name() = 'AuthoritativeID']/*[local-name() = 'id'] != ''">
          <xsl:element name="a">
            <xsl:attribute name="author">
              <xsl:value-of select=".//*[local-name() = 'AuthoritativeID'][1]/*[local-name() = 'id']"/>
            </xsl:attribute>
            <xsl:value-of select="*[local-name() = 'lastName']"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="substring(*[local-name() = 'firstName'], 1, 1)"/>
          </xsl:element>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="*[local-name() = 'lastName']"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="substring(*[local-name() = 'firstName'], 1, 1)"/>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:choose>
        <xsl:when test="position() = last()">
          <xsl:text>.</xsl:text>
        </xsl:when>
        <xsl:when test="position() = last() - 1">
          <xsl:text>. &amp; </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>., </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template><xsl:template name="CreationDatesAsText">
      <!-- Provides publication date and last update like (YYYY): or (YYYY-YYYY): --> 
      <!-- Assumes the first 4 characters in PublicationDate and LastUpdate refer to the year -->
      <xsl:variable name="startDate" select="substring(normalize-space(//*[local-name() = 'PublicationDate']), 0, 5)"/>
      <xsl:variable name="endDate" select="substring(normalize-space(//*[local-name() = 'LastUpate']), 0, 5)"/>

      <xsl:text> (</xsl:text>
      <xsl:value-of select="$startDate"/>
      <xsl:if test="$endDate != ''">
	<xsl:text>–</xsl:text>
	<xsl:value-of select="$endDate"/>
      </xsl:if>            
      <xsl:text>): </xsl:text>
  </xsl:template><xsl:template name="TitleAsCite">
    <cite>
      <xsl:choose>
        <xsl:when test="//*[local-name() = 'ResourceTitle']/text()">
          <xsl:choose>
            <!-- If the title is available in English, display it -->
            <xsl:when test="//*[local-name() = 'ResourceTitle']/@xml:lang = 'en'">
              <xsl:value-of select="//*[local-name() = 'ResourceTitle'][@xml:lang = 'en']"/>
            </xsl:when>
            <!-- If not, display the title in available language (might still be English but not specified as such) -->
            <xsl:otherwise>
              <xsl:value-of select="//*[local-name() = 'ResourceTitle']"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="//*[local-name() = 'ResourceName']/text()"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="//*[local-name() = 'Version']/text()">
        <xsl:text>, version </xsl:text>
        <xsl:value-of select="//*[local-name() = 'Version']/text()"/>
      </xsl:if>
    </cite>
    <xsl:text>. </xsl:text>
  </xsl:template><xsl:template name="CreationToolsSection">
    <details>
      <summary>Creation tools</summary>
      <xsl:choose>
        <xsl:when test="./*[local-name() = 'CreationToolInfo']/*[local-name() = 'CreationTool']/text()">
          <ul>
            <xsl:apply-templates select="./*[local-name() = 'CreationToolInfo']" mode="list-item"/>
          </ul>
        </xsl:when>
        <xsl:otherwise>
          <p>No information available about the tools used to create this resource.</p>
        </xsl:otherwise>
      </xsl:choose>
    </details>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template match="*[local-name() = 'Documentations']" mode="list">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <xsl:choose>
      <xsl:when test="./*[local-name() = 'Documentation']/*/text()">
        <ol>
          <xsl:apply-templates select="./*[local-name() = 'Documentation']" mode="list-item"/>
        </ol>
      </xsl:when>
      <xsl:otherwise>
        <p>No information about documentation is available for this resource.</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template match="*[local-name() = 'Documentation']" mode="list-item">
    <li>
        <xsl:apply-templates select="./*[local-name() = 'Url']" mode="link-to-url">
          <xsl:with-param name="link-text">
            <xsl:apply-templates select="./*[local-name() = 'DocumentationType']" mode="comma-separated-text"/>
          </xsl:with-param>
        </xsl:apply-templates>

        <xsl:if test=".//*[local-name() = 'LanguageName']">
          <br/>
          <xsl:text>In: </xsl:text>
          <xsl:apply-templates select=".//*[local-name() = 'LanguageName']" mode="comma-separated-text"/>
        </xsl:if>
        <xsl:if test="./*[local-name() = 'FileName']/text()">
          <br/>
          <xsl:text>Files: </xsl:text>
          <xsl:apply-templates select="./*[local-name() = 'FileName']" mode="comma-separated-text"/>
        </xsl:if>
    </li>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template match="*[local-name() = 'Access']" mode="def-list">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <dl>
        <dt>Persistent Identifier (PID) of this digital object</dt>
        <dd>
	  <xsl:element name="a">
	    <xsl:attribute name="href">
	      <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
	    </xsl:attribute>
	    <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
	  </xsl:element>
        </dd>

        <dt>Archive Contact</dt>
        <dd>
	  <xsl:element name="a">
	    <xsl:attribute name="href">
	      <xsl:text>mailto:data-steward@ids-mannheim.de?subject=Request%20Access:%20</xsl:text> <xsl:value-of select="//*[local-name() = 'MdSelfLink']"/>
	      <xsl:text>&amp;body=Dear IDS repository team! I'd like to get access to data in the repository.</xsl:text>
	    </xsl:attribute>
	    <bf>CLICK HERE to contact archivist to get access to data.</bf>
	  </xsl:element>		    
        </dd>
	
        <dt>Availability</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'Availability']"/>
        </dd>
	
        <dt>Distribution Medium</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'DistributionMedium']"/>
        </dd>
        
        <dt>Catalogue Link</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'CatalogueLink']" mode="link-to-url"/>
        </dd>
        
        <dt>Price</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'Price']"/>
        </dd>
        
        <dt>Licence</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Licence']" mode="name-with-link"/>
        </dd>
        
        <dt>Contact</dt>
        <dd itemscope="" itemtype="https://schema.org/Person">
          <xsl:apply-templates select="./*[local-name() = 'Contact']" mode="contact-data"/>
        </dd>
        
        <dt>Deployment Tool Info</dt>
        <dd>
          <xsl:if test="./*[local-name() = 'DeploymentToolInfo']">
            <ul>
              <xsl:apply-templates select="./*[local-name() = 'DeploymentToolInfo']" mode="list-item"/>
            </ul>
          </xsl:if>
        </dd>
    </dl>
  </xsl:template><xsl:template match="*[local-name() = 'Contact']" mode="contact-data">
    <span itemprop="name">
      <xsl:value-of select="./*[local-name() = 'firstname']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'lastname']"/>
    </span>
    <xsl:if test="./*[local-name() = 'role'] != ''">
      <xsl:text>, </xsl:text>
      <xsl:value-of select="./*[local-name() = 'role']"/>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'email'] != ''">
      <br/>
      <xsl:element name="a">
        <xsl:attribute name="href">mailto:<xsl:value-of select="./*[local-name() = 'email']"/></xsl:attribute>
        <xsl:attribute name="itemprop">email</xsl:attribute>
        <xsl:value-of select="./*[local-name() = 'email']"/>
      </xsl:element>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'telephoneNumber'] != ''">
      <br/>
      <span itemprop="telephone">
        <xsl:value-of select="./*[local-name() = 'telephoneNumber']"/>
      </span>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'Address']">
      <br/>
      <xsl:apply-templates select="./*[local-name() = 'Address']" mode="address-data"/>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'Address']" mode="address-data">
    <span itemprop="address">
      <xsl:value-of select="./*[local-name() = 'street']"/>
      <br/>
      <xsl:value-of select="./*[local-name() = 'ZIPCode']"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="./*[local-name() = 'city']"/>
    </span>
  </xsl:template><xsl:template match="*[local-name() = 'Licence']" mode="name-with-link">
    <xsl:variable name="licenseName" select="./text()"/>
    <xsl:choose>
      <xsl:when test="./@*[local-name() = 'src']">
        <xsl:apply-templates select="./@*[local-name() = 'src']" mode="link-to-url"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$licenseName"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template name="ResourceProxyListSection" match="*[local-name() = 'ResourceProxyList']">

    <p>Persistent Identifier (PID) of this resource: <xsl:apply-templates select="//*[local-name() = 'MdSelfLink']" mode="link-to-url"/>
    </p>
    
    <p>Landing page for this resource: <xsl:for-each select="./*">
        <xsl:if test="./*[local-name() = 'ResourceType'] = 'LandingPage'">
          <xsl:apply-templates select="./*[local-name() = 'ResourceRef']" mode="link-to-url"/>
        </xsl:if>
      </xsl:for-each>
    </p>

    <h3>Subordinate resources</h3>

    <xsl:choose>
      <xsl:when test="count(./*[local-name() = 'ResourceProxy']/*[local-name() = 'ResourceType' and text() = 'Metadata']) &gt; 0">
        <p>This data set contains the following subordinate resources:</p>
        <ul>
          <xsl:apply-templates select="./*[local-name() = 'ResourceProxy']/*[local-name() = 'ResourceType' and text() = 'Metadata']" mode="list-item"/>
        </ul>

      </xsl:when>
      <xsl:otherwise>
        <p>This data set contains no subordinate resources.</p>
      </xsl:otherwise>
    </xsl:choose>

    <h3>Files</h3>
    <xsl:choose>
      <xsl:when test="count(./*[local-name() = 'ResourceProxy']/*[local-name() = 'ResourceType' and text() = 'Resource']) &gt; 0">
        <p>This data set contains the following files: </p>
        <xsl:apply-templates select="./*[local-name() = 'ResourceProxy']"/>
      </xsl:when>
      <xsl:otherwise>
        <p>There are no files in this data set.</p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template name="ResourceProxyAsDetails" match="*[local-name() = 'ResourceProxy']">
    <!-- Renders each ResourceProxy with ResourceType 'Resource' as a <details> element -->

    <xsl:if test="./*[local-name() = 'ResourceType']/text() = 'Resource'">

      <!-- id holds the current ResourceProxy's id=... attribute value: -->
      <xsl:variable name="id" select="./*[local-name() = 'ResourceType']/../@id"/>
      <!-- infoNode holds the corresponding ResourceProxyInfo node,
           i.e., the one whose ref=... value matches the current ResourceProxy's id=... value: -->
      <xsl:variable name="infoNode" select="//*[local-name() = 'ResourceProxyInfo'][@*[local-name() = 'ref' and . = $id]]"/>

      <details>
        <summary>
          <xsl:apply-templates select="./*[local-name() = 'ResourceRef']" mode="link-to-url">
            <xsl:with-param name="link-text" select="normalize-space($infoNode/*[local-name() = 'ResProxFileName'])"/>
          </xsl:apply-templates>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']"/>
          <xsl:choose>
            <xsl:when test="$infoNode/*[local-name() = 'SizeInfo']">
              <xsl:text>, </xsl:text>
              <xsl:apply-templates select="$infoNode/*[local-name() = 'SizeInfo']"/>
            </xsl:when>
            <xsl:when test="$infoNode/*[local-name() = 'FileSize']">
              <xsl:text>, </xsl:text>
              <xsl:apply-templates select="$infoNode/*[local-name() = 'FileSize']"/>
            </xsl:when>
            <xsl:otherwise><!-- no comma when size unspecified --></xsl:otherwise>
          </xsl:choose>
          <xsl:text>) </xsl:text>
        </summary>

        <dl>
          <!-- TODO: display ResourceType here? or is it basically always just "Resource"? -->
          <xsl:if test="$infoNode/*[local-name() = 'ResProxItemName']/text()">
            <dt>Item name</dt>
            <dd>
              <xsl:value-of select="$infoNode/*[local-name() = 'ResProxItemName']/text()"/>
            </dd>
          </xsl:if>
          <xsl:if test="$infoNode/*[local-name() = 'ResProxFileName']/text()">
            <dt>Original file name</dt>
            <dd>
              <xsl:value-of select="$infoNode/*[local-name() = 'ResProxFileName']/text()"/>
            </dd>
          </xsl:if>

          <dt>Persistent identifier</dt>
          <dd>
            <xsl:apply-templates select="./*[local-name() = 'ResourceRef']" mode="link-to-url"/>
          </dd>

          <xsl:if test="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']">
            <dt>MIME Type</dt>
            <dd>
              <xsl:value-of select="./*[local-name() = 'ResourceType']/@*[local-name() = 'mimetype']"/>
            </dd>
          </xsl:if>
          
          <dt>File size</dt>
          <dd>
            <xsl:choose>
              <xsl:when test="$infoNode/*[local-name() = 'SizeInfo']">
                <xsl:apply-templates select="$infoNode/*[local-name() = 'SizeInfo']"/>
              </xsl:when>
              <xsl:when test="$infoNode/*[local-name() = 'FileSize']">
                <xsl:apply-templates select="$infoNode/*[local-name() = 'FileSize']"/>
              </xsl:when>
            </xsl:choose>
          </dd>

          <xsl:apply-templates select="$infoNode/*[local-name() = 'Checksums']"/>
          <!-- TODO: other info potentially in $infoNode:-->
          <!-- LanguageScripts? LanguagesScriptGrp? Descriptions?-->
        </dl>
      </details>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'SizeInfo']">
    <xsl:choose>
      <xsl:when test="./*[local-name() = 'TotalSize']/*[local-name() = 'SizeUnit'] != 'B'">
        <xsl:value-of select="./*[local-name() = 'TotalSize']/*[local-name() = 'Size']"/> 
        <xsl:text> </xsl:text>
        <xsl:value-of select="./*[local-name() = 'TotalSize']/*[local-name() = 'SizeUnit']"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="SizeAsHumanText">
          <xsl:with-param name="size" select="number(./*[local-name() = 'TotalSize']/*[local-name() = 'Size'])"/>
        </xsl:call-template>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template match="*[local-name() = 'FileSize']">
    <!-- TODO: is FileSize always in bytes? -->
    <xsl:call-template name="SizeAsHumanText">
      <xsl:with-param name="size" select="number(text())"/>
    </xsl:call-template>
  </xsl:template><xsl:template name="SizeAsHumanText">
    <!-- turns param $size, in bytes, into readable text with units of KB, MB, etc. -->
    <xsl:param name="size"/>
    <xsl:choose>
      <xsl:when test="$size &lt; 1024">
        <xsl:value-of select="$size"/> B</xsl:when>
      <xsl:when test="$size &lt; 1024 * 1024">
        <xsl:value-of select="format-number($size div 1024, '#.#')"/> KB</xsl:when>
      <xsl:when test="$size &lt; 1024 * 1024 * 1024">
        <xsl:value-of select="format-number($size div (1024 * 1024), '#.#')"/> MB</xsl:when>
      <xsl:when test="$size &lt; 1024 * 1024 * 1024 * 1024">
        <xsl:value-of select="format-number($size div (1024 * 1024 * 1024), '#.#')"/> GB</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="format-number($size div (1024 * 1024 * 1024 * 1024), '#.#')"/>
        TB</xsl:otherwise>
    </xsl:choose>
  </xsl:template><xsl:template name="ChecksumsAsDefinitions" match="*[local-name() = 'Checksums']">
    <!-- Returns checksum values as dt/dd pairs. The outer <dl> is
         *not* supplied, so these can be inserted into an existing
         definition list -->
    <xsl:if test="./*[local-name() = 'md5']/text()">
      <dt>MD5</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'md5']"/>
      </dd>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'sha1']/text()">
      <dt>SHA1</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'sha1']"/>
      </dd>
    </xsl:if>
    <xsl:if test="./*[local-name() = 'sha256']/text()">
      <dt>SHA256</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'sha256']"/>
      </dd>
    </xsl:if>
  </xsl:template><xsl:template match="*[local-name() = 'ResourceProxyListInfo']">
    <!-- suppress default template -->
    <!-- ResourceProxyInfo nodes are rendered by the templates for the
         corresponding ResourceProxy node (see above). But because
         they're not in the same part of the document tree, the rules
         for default templates end up being applied to them and
         dumping the text of the checksums, etc. directly into the
         page unless we suppress them. -->
  </xsl:template><xsl:template match="*[local-name() = 'ResourceType' and text() = 'Metadata']" mode="list-item">
    <xsl:variable name="selfLink" select="//*[local-name() = 'MdSelfLink']/text()"/>
    <!-- exclude link to self as a subordinate resource: -->
    <xsl:if test="not(contains(normalize-space(../*[local-name() = 'ResourceRef']/text()), normalize-space($selfLink)))">
      <li>
        <xsl:apply-templates select="../*[local-name() = 'ResourceRef']" mode="link-to-url"/>
        <xsl:if test="./@*[local-name() = 'mimetype']">
          <xsl:text> (</xsl:text>
          <xsl:value-of select="./@*[local-name() = 'mimetype']"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:output method="html" indent="yes"/><xsl:template name="LexicalResourceContextAsSection">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <xsl:apply-templates select="." mode="def-list"/>  
    <xsl:apply-templates select="./*[local-name() = 'SubjectLanguages']" mode="details"/>
    <xsl:apply-templates select="./*[local-name() = 'AuxiliaryLanguages']" mode="details"/>  
    <details>
      <summary>Size information</summary>
        <xsl:apply-templates select="./*[local-name() = 'TypeSpecificSizeInfo']" mode="list"/>
    </details>
  </xsl:template><xsl:template match="*[local-name() = 'LexicalResourceContext']" mode="def-list">
    <dl>
      <dt>Lexicon type(s)</dt>
      <dd>
        <xsl:apply-templates select="./*[local-name() = 'LexiconType']" mode="comma-separated-text"/>
      </dd>
     
      <dt>Headword type(s)</dt>
      <dd>
        <xsl:apply-templates select="./*[local-name() = 'HeadwordType']/*[local-name() = 'LexicalUnit']" mode="comma-separated-text"/>
        <xsl:apply-templates select="./*[local-name() = 'HeadwordType']/*[local-name() = 'Descriptions']"/>
      </dd>
      
    </dl>
  </xsl:template><xsl:template match="*[local-name() = 'AuxiliaryLanguages']" mode="details">
    <details>
      <summary>Auxiliary languages</summary>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <ul>
        <xsl:apply-templates select="./*[local-name() = 'Language']" mode="list-item"/>
      </ul>
    </details>
  </xsl:template><xsl:template match="*[local-name() = 'Language']" mode="list-item">
    <li>
        <xsl:value-of select="./*[local-name() = 'LanguageName']"/>
    </li>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template name="ExperimentContextAsSection" match="*[local-name() = 'ExperimentContext']">
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <xsl:apply-templates select="./*[local-name() = 'ExperimentalStudy']" mode="section"/>
  </xsl:template><xsl:template match="*[local-name() = 'ExperimentalStudy']" mode="section">
    <section class="study">
    <!-- TODO: do we have any examples where an ExperimentContext
         contains more than one ExperimentalStudy? If so, perhaps we
         need another heading here  -->
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <xsl:apply-templates select="./*[local-name() = 'Experiment']" mode="section"/>
    </section>
  </xsl:template><xsl:template name="ExperimentSection" match="*[local-name() = 'Experiment']" mode="section">
    <section class="experiment">
      <xsl:call-template name="ExperimentInfoAsHeading"/>
      <!-- TODO: ExperimentalParadigm? -->
      <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 

      <xsl:apply-templates select="./*[local-name() = 'Hypotheses']" mode="details"/>
      <xsl:apply-templates select="./*[local-name() = 'Method']" mode="details"/>
      <xsl:apply-templates select="./*[local-name() = 'Results']" mode="details"/>
      <xsl:apply-templates select="./*[local-name() = 'Materials']" mode="details"/> 
      <xsl:apply-templates select="./*[local-name() = 'SubjectLanguages']" mode="details"/> 
      <xsl:call-template name="AnalysisToolsAsDetails"/> 
      <!-- TODO: ExperimentalQuality? TypeSpecificSizeInfo? -->
    </section>
  </xsl:template><xsl:template name="ExperimentInfoAsHeading">
    <h3>
      <xsl:choose>
        <xsl:when test="./*[local-name() = 'ExperimentTitle']/text()">
          Experiment: <xsl:value-of select="./*[local-name() = 'ExperimentTitle']"/>
          <xsl:if test="./*[local-name() = 'ExperimentName']">
            (<xsl:value-of select="./*[local-name() = 'ExperimentName']"/>)
          </xsl:if>
        </xsl:when>
        <xsl:when test="./*[local-name() = 'ExperimentName']/text()">
          Experiment: <xsl:value-of select="./*[local-name() = 'ExperimentName']"/>
        </xsl:when>
        <xsl:otherwise>
          Experiment <xsl:value-of select="position()"/>
        </xsl:otherwise>
      </xsl:choose>
    </h3>
  </xsl:template><xsl:template match="*[local-name() = 'Hypotheses']" mode="details">
    <details>
      <summary>Hypotheses</summary>
      <xsl:choose>
        <xsl:when test=".//*[local-name() = 'Description' and text()]">
          <ol>
            <xsl:apply-templates select="./*[local-name() = 'Hypothesis']" mode="list-item"/>
          </ol>
        </xsl:when>
        <xsl:otherwise>
          <p>No hypothesis information is available for this experiment.</p>
        </xsl:otherwise>
      </xsl:choose>
    </details>
  </xsl:template><xsl:template match="*[local-name() = 'Hypothesis']" mode="list-item">
    <li>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    </li>
  </xsl:template><xsl:template match="*[local-name() = 'Results']" mode="details">
    <details>
      <summary>Results</summary>
      <xsl:choose>
        <xsl:when test=".//*[local-name() = 'Description' and text()]">
          <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
        </xsl:when>
        <xsl:otherwise>
          <p>No results information is available for this experiment.</p>
        </xsl:otherwise>
      </xsl:choose>
    </details>
  </xsl:template><xsl:template match="*[local-name() = 'Method']" mode="details">
    <details>
      <summary>Methods</summary>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
      <dl>

        <dt>Research approach</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']/*[local-name() = 'ResearchApproach']" mode="comma-separated-text"/>
        </dd>

        <dt>Research design</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']/*[local-name() = 'ResearchDesign']" mode="comma-separated-text"/>
        </dd>

        <dt>Study model</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']/*[local-name() = 'ElicitationModel']" mode="comma-separated-text"/>
        </dd>

        <dt>Timeframe</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']/*[local-name() = 'ElicitationTimeframe']" mode="comma-separated-text"/>
        </dd>


        <dt>Procedure</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Procedure']/*[local-name() = 'Descriptions']"/>
        </dd>

        <dt>Experiment type</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']//*[local-name() = 'ExperimentType' or                                                            local-name() = 'SurveyType' or                                                            local-name() = 'TestType']" mode="comma-separated-text"/>
        </dd>

        <dt>Neuroimaging technique</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'Elicitation']//*[local-name() = 'NeuroimagingTechnique']"/>
        </dd>

        <dt>Elicitation instrument</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationInstrument']" mode="comma-separated-text"/>
        </dd>

        <dt>Elicitation software</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Elicitation']//*[local-name() = 'ElicitationSoftware']" mode="comma-separated-text"/>
        </dd>

        <dt>Variables</dt>
        <dd>
          <xsl:if test="./*[local-name() = 'Elicitation']/*[local-name() = 'Variables']/*[local-name() = 'Variable']">
            <ul>
              <xsl:for-each select="./*[local-name() = 'Elicitation']/*[local-name() = 'Variables']/*[local-name() = 'Variable']">
                <li>
                  <xsl:value-of select="./*[local-name() = 'VariableName']"/>
                  <xsl:if test="./*[local-name() = 'VariableType'] != ''">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="./*[local-name() = 'VariableType']"/>
                    <xsl:text>)</xsl:text>
                  </xsl:if>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:if>
        </dd>

        <dt>Participant data</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Participants']" mode="def-list"/>
        </dd>
      </dl>
      
        
    </details>
  </xsl:template><xsl:template match="*[local-name() = 'Participants']" mode="def-list">
      <dl>   

        <dt>Populations</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'Population']" mode="comma-separated-text"/>
        </dd>

        <dt>Data rejections</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'DataRejection']" mode="comma-separated-text"/>
        </dd>

        <dt>Anonymization flags</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'AnonymizationFlag']" mode="comma-separated-text"/>
        </dd>

        <dt>Sampling methods</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'SamplingMethod']" mode="comma-separated-text"/>
        </dd>
        
        <dt>Sample sizes</dt>
        <dd>
          <ul>
            <xsl:apply-templates select="./*[local-name() = 'SampleSize']" mode="list-item"/>
          </ul>
        </dd>
        
        <dt>Sex distribution</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'SexDistribution']" mode="table"/>
        </dd>
        
        <dt>Age distribution</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'AgeDistribution']" mode="table"/>
        </dd>
        
        <dt>Language varieties</dt>
        <dd>
          <xsl:if test="./*[local-name() = 'LanguageVariety']/*[local-name() = 'VarietyGrp']"> 
            <ul>
              <xsl:apply-templates select="./*[local-name() = 'LanguageVariety']/*[local-name() = 'VarietyGrp']" mode="list-item"/>
            </ul>
          </xsl:if>
        </dd>

        <dt>Participant profession</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'ParticipantProfession']" mode="comma-separated-text"/>
        </dd>

        <dt>Recruitment</dt>
        <dd>
          <xsl:apply-templates select="./*[local-name() = 'ParticipantRecruitment']/*[local-name() = 'Descriptions']"/> 
        </dd>

      </dl>
  </xsl:template><xsl:template match="*[local-name() = 'SexDistribution']" mode="table">
    <table>
      <tbody>
        <xsl:for-each select="./*[local-name() = 'SexDistributionInfo']">
          <tr>
            <td><xsl:value-of select="./*[local-name() = 'ParticipantSex']"/></td>
            <td><xsl:value-of select="./*[local-name() = 'Size']"/></td>
          </tr>
        </xsl:for-each>
      </tbody>
    </table>
  </xsl:template><xsl:template match="*[local-name() = 'AgeDistribution']" mode="table">
    <table>
      <tbody>
        <xsl:if test="./*[local-name() = 'ParticipantMeanAge']">
          <tr>
            <td>Mean age</td>
            <td>
              <xsl:value-of select="./*[local-name() = 'ParticipantMeanAge']"/>
              <xsl:if test="./*[local-name() = 'ParticipantMeanAgeSTD']">
                (std = <xsl:value-of select="./*[local-name() = 'ParticipantMeanAgeSTD']"/>)
              </xsl:if>
            </td>
          </tr>
        </xsl:if>
        <xsl:if test="./*[local-name() = 'ParticipantAgeRange']">
          <tr>
            <td>Youngest</td>
            <td><xsl:value-of select="./*[local-name() = 'ParticipantAgeRange']/*[local-name() = 'Youngest']"/></td>
          </tr>
          <tr>
            <td>Oldest</td>
            <td><xsl:value-of select="./*[local-name() = 'ParticipantAgeRange']/*[local-name() = 'Oldest']"/></td>
          </tr>
        </xsl:if>
      </tbody>
    </table>
  </xsl:template><xsl:template match="*[local-name() = 'SampleSize']" mode="list-item">
    <li>
      <xsl:value-of select="./*[local-name() = 'Size']"/>
      <xsl:if test="./*[local-name() = 'SizeUnit' and text()]">
        <xsl:text> </xsl:text>
        <xsl:value-of select="./*[local-name() = 'SizeUnit']"/>
      </xsl:if>

      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    </li>
  </xsl:template><xsl:template match="*[local-name() = 'VarietyGrp']" mode="list-item">
    <li>
      <xsl:apply-templates select="./*[local-name() = 'VarietyName']" mode="comma-separated-text"/>
      <xsl:if test="./*[local-name() = 'NoParticipants']"> 
        <xsl:text>: </xsl:text>
        <xsl:value-of select=".//*[local-name() = 'NoParticipants']"/> participants
      </xsl:if>
    </li>
  </xsl:template><xsl:template match="*[local-name() = 'Materials']" mode="details">
    <details>
      <summary>Materials</summary>
      <xsl:apply-templates select="*[local-name() = 'Descriptions']"/>
      <ul>
        <xsl:for-each select="./*[local-name() = 'Material']">
          <li>
            <xsl:value-of select="./*[local-name() = 'Domain']"/>
            <xsl:if test="./*[local-name() = 'Descriptions']/*[local-name() = 'Description' and text()]">
              <xsl:text>: </xsl:text>
              <xsl:apply-templates select="*[local-name() = 'Descriptions']"/> 
            </xsl:if>
          </li>
        </xsl:for-each>
      </ul>
    </details>
  </xsl:template><xsl:template name="AnalysisToolsAsDetails">
    <details>
      <summary>Analysis Tools</summary>
      <xsl:if test="./*[local-name() = 'AnalysisToolInfo']">
        <ul>
          <xsl:apply-templates select="./*[local-name() = 'AnalysisToolInfo']" mode="list-item"/>
        </ul>
      </xsl:if>
    </details>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template name="ToolContextAsTable" match="*[local-name() = 'ToolContext']">
    <table>
      <!-- TODO: table header? -->
      <tbody>
        <tr>
          <td>
            <b>Tool Classification: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'ToolClassification']/*[local-name() = 'ToolType']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Distribution: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Distribution']/*[local-name() = 'DistributionType']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Size: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'TotalSize']/*[local-name() = 'Size']"/>
            <xsl:value-of select="./*[local-name() = 'TotalSize']/*[local-name() = 'SizeUnit']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Input(s): </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Inputs']//*[local-name() = 'Description']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Output(s): </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Outputs']//*[local-name() = 'Description']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Implementatation(s): </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Implementations']//*[local-name() = 'ImplementationLanguage']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Install Environment(s): </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'InstallEnv']//*[local-name() = 'OperatingSystem']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Prerequisite(s): </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'Prerequisites']//*[local-name() = 'PrerequisiteName']"/>
          </td>
        </tr>
        <tr>
          <td>
            <b>Tech Environment(s): </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'TechEnv']//*[local-name() = 'ApplicationType']"/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template name="SpeechCorpusContextAsSection">
    <!-- TODO: SpeechCorpusContext appears to have no top-level
         <Descriptions> as other *Context components do...add here in
         a future version? -->

    <xsl:apply-templates select="./*[local-name() = 'SpeechCorpus']" mode="def-list"/> 
    <xsl:apply-templates select="./*[local-name() = 'SubjectLanguages']" mode="details"/> 
    <xsl:apply-templates select="./*[local-name() = 'AnnotationTypes']" mode="details"/> 
    <!-- Even though this is part of SpeechCorpus, we extract it here
         and put it behind <details> to keep the basic data uncluttered: -->
    <xsl:apply-templates select="./*[local-name() = 'SpeechCorpus']/*[local-name() = 'SpeechTechnicalMetadata']" mode="details"/> 

  </xsl:template><xsl:template match="*[local-name() = 'SpeechCorpus']" mode="def-list">
    <dl>
      <dt>Duration (effective speech)</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'DurationOfEffectiveSpeech']"/>
      </dd>

      <dt>Duration (full database)</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'DurationOfFullDatabase']"/>
      </dd>

      <dt>Number of speakers</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'NumberOfSpeakers']"/>
      </dd>

      <dt>Size information</dt>
      <dd>
        <xsl:apply-templates select="../*[local-name() = 'TypeSpecificSizeInfo']" mode="list"/>
      </dd>

      <dt>Recording Environment</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'RecordingEnvironment']"/>
      </dd>

      <dt>Speaker demographics</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'SpeakerDemographics']"/>
      </dd>

      <dt>Quality</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'Quality']"/>
      </dd>

      <dt>Recording Platform (hardware)</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'RecordingPlatformHardware']"/>
      </dd>
      
      <dt>Recording Platform (software)</dt>
      <dd>
        <xsl:value-of select="./*[local-name() = 'RecordingPlatformSoftware']"/>
      </dd>

      <dt>Multilingual</dt>
      <dd>
        <xsl:value-of select="../*[local-name() = 'Multilinguality']/*[local-name() = 'Multilinguality']"/>
      </dd>

    </dl>
  </xsl:template><xsl:template match="*[local-name() = 'AnnotationTypes']" mode="details">
    <details>
      <summary>Annotation</summary>
      <xsl:choose>
        <xsl:when test="./*[local-name() = 'AnnotationType']">
          <ul>
            <xsl:apply-templates select="./*[local-name() = 'AnnotationType']" mode="list-item"/> 
          </ul>
        </xsl:when>
      </xsl:choose>
    </details>
  </xsl:template><xsl:template match="*[local-name() = 'AnnotationType']" mode="list-item">
    <!-- TODO: is this really a completely different element as in Creation?? -->
    <li>
      <p>
        <xsl:apply-templates select="./*[local-name() = 'AnnotationType']" mode="comma-separated-text"/>
      </p>
      <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    </li>

  </xsl:template><xsl:template match="*[local-name() = 'SpeechTechnicalMetadata']" mode="details">
    <details>
      <summary>Technical metadata</summary>
      <dl>
        <dt>Sampling frequency</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'SamplingFrequency']"/>
        </dd>
        
        <dt>Number of channels</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'NumberOfChannels']"/>
        </dd>
        
        <dt>Byte order</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'ByteOrder']"/>
        </dd>

        <dt>Compression</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'Compression']"/>
        </dd>

        <dt>Bit resolution</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'BitResolution']"/>
        </dd>

        <dt>Speech coding</dt>
        <dd>
          <xsl:value-of select="./*[local-name() = 'SpeechCoding']"/>
        </dd>

      </dl>
    </details>
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template name="TextCorpusContextAsSection">
    <xsl:apply-templates select="./*[local-name() = 'Descriptions']"/>
    <xsl:apply-templates select="." mode="def-list"/> 
    <xsl:apply-templates select="./*[local-name() = 'SubjectLanguages']" mode="details"/>
  </xsl:template><xsl:template match="*[local-name() = 'TextCorpusContext']" mode="def-list">

      <dl>
          <dt>Corpus type</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'CorpusType']"/>
          </dd>
        
          <dt>Temporal classification</dt>
          <dd>
            <xsl:value-of select="./*[local-name() = 'TemporalClassification']"/>
          </dd>
        
          <dt>Validation</dt>
          <dd>
	    <!-- TODO: validation type? mode? level? -->
            <xsl:apply-templates select="./*[local-name() = 'ValidationGrp']/*[local-name() = 'Descriptions']"/>
          </dd>

          <dt>Size information</dt>
          <dd>
            <xsl:apply-templates select="./*[local-name() = 'TypeSpecificSizeInfo']" mode="list"/>
          </dd>
      </dl>
    
  </xsl:template>
  <xsl:output method="html" indent="yes"/><xsl:template name="CourseProfileSpecificAsTable" match="*[local-name() = 'CourseProfileSpecific']">
    <table>
      <!-- TODO: table header? -->
      <tbody>
        <tr>
          <td>
            <b>Course Targeted at: </b>
          </td>
          <td>
            <ul>
              <xsl:apply-templates select="*[local-name() = 'CourseTargetedAt']"/>
            </ul>
          </td>
        </tr>
        <tr>
          <td>
            <b>First held: </b>
          </td>
          <td>
            <xsl:value-of select="./*[local-name() = 'FirstHeldAt']"/>
            <xsl:value-of select="./*[local-name() = 'FirstHeldOn']"/>
          </td>
        </tr>
      </tbody>
    </table>
  </xsl:template><xsl:template match="*[local-name() = 'CourseTargetedAt']">
    <li>
      <xsl:value-of select="."/>
    </li>
  </xsl:template>
  <!-- <xsl:include href="xsl/JSONLD.xsl"/> -->

  <xsl:output method="html" indent="yes"/>

  <!-- <xsl:strip-space elements="cmd:Description"/> -->
  <xsl:strip-space elements="*"/>

<!-- ToolProfile:            clarin.eu:cr1:p_1447674760338 
		 TextCorpusProfile:      clarin.eu:cr1:p_1442920133046
		 LexicalResourceProfile: clarin.eu:cr1:p_1445542587893
		 ExperimentProfile:      clarin.eu:cr1:p_1447674760337
		 

new ExperimentProfile: clarin.eu:cr1:p_1524652309872 
new TextCorpusProfile: clarin.eu:cr1:p_1524652309874
new ToolProfile: clarin.eu:cr1:p_1524652309875
new LexicalResourceProfile: clarin.eu:cr1:p_1524652309876
new CourseProfile: clarin.eu:cr1:p_1524652309877
new SpeechCorpusProfile: clarin.eu:cr1:p_1524652309878 
		 
    -->

  <!-- This need to be OR'ed for all valid NaLiDa-based profiles -->
  <xsl:template match="/cmd:CMD">
    <xsl:choose>
      <xsl:when test="           contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1447674760338')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1442920133046')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1445542587893')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1485173990943')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1447674760337')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1505397653792')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1288172614026')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1288172614023')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1302702320451')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1290431694579')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1290431694580')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1320657629644')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1320657629649')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309872')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309874')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309875')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309876')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309877')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309878')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176122')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176123')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176124')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176125')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176126')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176127')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176128')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1548239945774')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1559563375778')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1659015263839')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176128')           or contains(/cmd:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1562754657343')">
        <!-- CMDI 1.1 -->
        <xsl:call-template name="mainProcessing"/>
      </xsl:when>
      <xsl:otherwise>
        <error>
          <xsl:text>
		  Please use a valid CMDI schema v1.1 from the NaLiDa project.
		  Currently the following profiles are being supported:
		
		  - ToolProfile (clarin.eu:cr1:p_1447674760338),
		  - TextCorpusProfile ('clarin.eu:cr1:p_1442920133046),
		  - LexicalResourceProfile (clarin.eu:cr1:p_1445542587893), 
		  - SpeechCorpusProfile (clarin.eu:cr1:p_1485173990943), and
		  - ExperimentProfile (clarin.eu:cr1:p_1447674760337)
		  - CourseProfile (clarin.eu:cr1:p_1505397653792).
		  
		  Additional we suppor the following profiles, which are utilized by the CLARIN-D-Centre in Tübingen
		  - OLAC-DcmiTerms: clarin.eu:cr1:p_1288172614026
		  - DcmiTerms: clarin.eu:cr1:p_1288172614023
		  
		  Older version of the profiles are partly supported, currently only if used  in CMDI 1.2 files: 
		  - ExperimentProfile: clarin.eu:cr1:p_1302702320451
		  - LexicalResourceProfile: clarin.eu:cr1:p_1290431694579
		  - TextCorpusProfile: clarin.eu:cr1:p_1290431694580
		  - ToolProfile: clarin.eu:cr1:p_1290431694581
		  - WebLichtWebService: clarin.eu:cr1:p_1320657629644
		  - Resource Bundle: clarin.eu:cr1:p_1320657629649
		  
		  Newer version of the profiles are partly, currently only if used  in CMDI 1.2 files: 
		  - ExperimentProfile: clarin.eu:cr1:p_1524652309872 
		  - TextCorpusProfile: clarin.eu:cr1:p_1524652309874
		  - ToolProfile: clarin.eu:cr1:p_1524652309875
		  - LexicalResourceProfile: clarin.eu:cr1:p_1524652309876
		  - CourseProfile: clarin.eu:cr1:p_1524652309877
		  - SpeechCorpusProfile: clarin.eu:cr1:p_1524652309878 
		  
	  
		</xsl:text>
        </error>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/cmde:CMD/cmde:Header">
    <!-- ignore header -->
  </xsl:template>
  
  <xsl:template match="/cmde:CMD">
    <!-- <xsl:choose> -->
    <!--   <xsl:when -->
    <!--     test=" -->
    <!--       contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1447674760338') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1442920133046') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1445542587893') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1485173990943') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1447674760337') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1505397653792') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1288172614026') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1288172614023') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1302702320451') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1290431694579') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1290431694580') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1320657629644') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1320657629649') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309872') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309874') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309875') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309876') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309877') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1524652309878') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176122') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176123') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176124') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176125') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176126') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176127') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176128') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1548239945774') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1562754657343') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1559563375778') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1659015263839') -->
    <!--       or contains(/cmde:CMD/@xsi:schemaLocation, 'clarin.eu:cr1:p_1527668176128') -->
    <!--       "> -->
    <!--     <!-\- CMDI 1.2 -\-> -->
        <xsl:call-template name="mainProcessing"/>
    <!--   </xsl:when> -->
    <!--   <xsl:otherwise> -->
    <!--     <error> -->
    <!--       <xsl:text> -->
    <!-- 		Please use a valid CMDI v1.2 schema from the NaLiDa project. -->
    <!-- 		Currently the following profiles are being supported: -->
		
    <!-- 		- ToolProfile (clarin.eu:cr1:p_1447674760338), -->
    <!-- 		- TextCorpusProfile ('clarin.eu:cr1:p_1442920133046) -->
    <!-- 		- LexicalResourceProfile (clarin.eu:cr1:p_1445542587893) -->
    <!-- 		- SpeechCorpusProfile (clarin.eu:cr1:p_1485173990943) -->
    <!-- 		- ExperimentProfile (clarin.eu:cr1:p_1447674760337) -->
    <!-- 		- CourseProfile (clarin.eu:cr1:p_1505397653792) -->

    <!-- 		  - ExperimentProfile: clarin.eu:cr1:p_1524652309872 -->
    <!-- 		  - TextCorpusProfile: clarin.eu:cr1:p_1524652309874 -->
    <!-- 		  - ToolProfile: clarin.eu:cr1:p_1524652309875 -->
    <!-- 		  - LexicalResourceProfile: clarin.eu:cr1:p_1524652309876 -->
    <!-- 		  - CourseProfile: clarin.eu:cr1:p_1524652309877 -->
    <!-- 		  - SpeechCorpusProfile: clarin.eu:cr1:p_1524652309878 -->
		  
    <!-- 		    - TextCorpusProfile: clarin.eu:cr1:p_1527668176122 -->
    <!-- 		    - LexicalResourceProfile: clarin.eu:cr1:p_1527668176123 -->
    <!-- 		    - ToolProfile: clarin.eu:cr1:p_1527668176124 -->
    <!-- 		    - CourseProfile: clarin.eu:cr1:p_1527668176125 -->
    <!-- 		    - ExperimentProfile: clarin.eu:cr1:p_1527668176126 -->
    <!-- 		    - ResourceBundle: clarin.eu:cr1:p_1527668176127 -->
    <!-- 		    - SpeechCorpusProfile: clarin.eu:cr1:p_1527668176128 -->
		
    <!-- Additionally we support the following profiles, which are utilized by the CLARIN-D-Centre in Tübingen -->
    <!-- 		  - OLAC-DcmiTerms: clarin.eu:cr1:p_1288172614026 -->
    <!-- 		  - DcmiTerms: clarin.eu:cr1:p_1288172614023 -->
		  
    <!-- 		  Older versions of the profiles are partly supported, currently only if used in CMDI 1.2 files: -->
    <!-- 		  - ExperimentProfile: clarin.eu:cr1:p_1302702320451 -->
    <!-- 		  - LexicalResourceProfile: clarin.eu:cr1:p_1290431694579 -->
    <!-- 		  - TextCorpusProfile: clarin.eu:cr1:p_1290431694580 -->
    <!-- 		  - ToolProfile: clarin.eu:cr1:p_1290431694581 -->
    <!-- 		  - WebLichtWebService: clarin.eu:cr1:p_1320657629644 -->
    <!-- 		  - Resource Bundle: clarin.eu:cr1:p_1320657629649 -->
		  
                    
    <!--                 </xsl:text> -->
    <!--     </error> -->
    <!--   </xsl:otherwise> -->
    <!-- </xsl:choose> -->
  </xsl:template>

  <xsl:template name="mainProcessing">
    <html>
      <head>
        <title>
          <xsl:value-of select="//*[local-name() = 'ResourceName']"/>
          - <xsl:value-of select="//*[local-name() = 'ResourceClass']"/>
          in IDS Repository 
        </title>
        <link rel="stylesheet" type="text/css" href="https://talar.sfb833.uni-tuebingen.de/assets/main.css"/>

        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <!-- <xsl:call-template name="meta-description" /> -->
        <!-- <xsl:call-template name="JSONLD"/> -->

        <style>
/* TODO: migrate these definitions into the main.css file once completed */
body {          
  max-width: 1200px;
  margin: 0 auto 0 auto;
  padding: 0 0.2em 0 0.2em;
}


nav#toc {
  padding: 0;
  display: block;
}

nav#toc ul {
  padding: 0;
  display: flex;
  flex-flow: row wrap;
  justify-content: flex-start;
  align-items: center;
  margin: 0; /* reset from main.css... */
}

nav#toc ul li {
  display: inline-block;
  border: 1px solid #e8e8e8;
  border-radius: 0.2em;
  padding: 0.5em;
  margin-bottom: 0.5em;
  margin-right: 0.2em;
}

article.tabs {
  display: block;
  min-height: 50vh;
}

article.tabs &gt; section {
  display: none;
}

/* turn on the :target tab, or the last tab as default when no other selected. */
article.tabs &gt; section:target, 
article.tabs &gt; section:last-child
{
  display: block;
}

/* turn off default tab when another tab is :target.
The default tab must appear last in the HTML, rather than first, because CSS
has no analogous way to select the first when it has a following :target sibling. */
article.tabs section:target ~ section:last-child { 
  display: none;
}

blockquote {
  /* TODO: reset these in main.css */
  letter-spacing: normal;
  font-style: normal;
}

/* Sorry, this is an ugly hack until main.css gets updated... */
@media (min-width: 600px) {
  nav.site-nav .trigger {
    height: 100%;
    display: flex;
    align-items: center;
  }
}

details {
  margin-left: 1em;
}

dl {
  border: 1px solid #e8e8e8;
}
dt {
  font-weight: bold;
  padding: 0.5em 1em 0 1em;
}
dt:after {
  content: ":";
}
dt:nth-of-type(even) {
  background-color: #f7f7f7;
}
dd {
  padding: 0 1em 0.5em 1em;
}
dd:nth-of-type(even) {
  background-color: #f7f7f7;
}
dd:empty {
  padding: 1em 0 0 0;
}

address {
  font-style: normal;
}

header {
  display: flex;
  flex-flow: row wrap;
  justify-content: space-between;
  border-bottom: 3px solid #e8e8e8;
  min-height: 55.95px;
}

footer {
  display: flex;
  font-size: small;
  justify-content: flex-end;
  padding-top: 1em;
  margin-top: 1em;
  border-top: 1px solid #e8e8e8;
}
        </style>
      </head>


      <body>
     
        <main>
          <h1>
            Resource:
            <xsl:value-of select="//*[local-name() = 'GeneralInfo']/*[local-name() = 'ResourceName']"/>
          </h1>

          <nav id="toc">
            <ul>
              <li>
                <a href="#general-info">General Info</a>
              </li>
              <xsl:if test="//*[local-name() = 'Project']">
                <li>
                  <a href="#project">Project</a>
                </li>
              </xsl:if>
              <xsl:if test="//*[local-name() = 'Publications']">
                <li>
                  <a href="#publications">Publications</a>
                </li>
              </xsl:if>
              <xsl:if test="//*[local-name() = 'Creation']">
                <li>
                  <a href="#creation">Creation</a>
                </li>
              </xsl:if>
              <xsl:if test="//*[local-name() = 'Documentations']">
                <li>
                  <a href="#documentation">Documentation</a>
                </li>
              </xsl:if>
              <xsl:if test="//*[local-name() = 'Access']">
                <li>
                  <a href="#access">Access</a>
                </li>
              </xsl:if>
              <!--      <xsl:if test="not(contains(//*:Components/*/local-name(), 'DcmiTerms'))"><li><a href="#tabs-7">Resource-specific information</a></li></xsl:if> -->
              <li>
                <a href="#resource-specific">Resource-specific information</a>
              </li>
              <li>
                <a href="#data-files">Data files</a>
              </li>
              <li>
                <a href="#citation">Cite data set</a>
              </li>
	      <li>
                <a href="#violation">Report violation</a>
              </li>
            </ul>
          </nav>

          <article class="tabs">
            <xsl:call-template name="ProjectSection"/>
            <xsl:call-template name="PublicationsSection"/>
            <xsl:call-template name="CreationSection"/>
            <xsl:call-template name="DocumentationSection"/>
            <xsl:call-template name="AccessSection"/>
            <xsl:apply-templates select="//*[local-name() = 'LexicalResourceContext' or                                          local-name() = 'ExperimentContext' or                                          local-name() = 'ToolContext' or                                          local-name() = 'SpeechCorpusContext' or                                          local-name() = 'TextCorpusContext' or                                          local-name() = 'CourseProfileSpecific'] "/>
                                         
            <xsl:call-template name="DataFilesSection"/>
            <xsl:call-template name="CitationSection"/>
            <xsl:call-template name="ReportViolation"/>
            <!-- General info is rendered *last* in the HTML so it can be displayed by default; see CSS.  -->
            <xsl:call-template name="GeneralInfoSection"/>
          </article>
        </main>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="GeneralInfoSection">
    <section id="general-info">
      <h2>General Information</h2>
      <xsl:apply-templates select="//*[local-name() = 'GeneralInfo']" mode="def-list"/>
    </section>
  </xsl:template>

  <xsl:template name="ProjectSection">
    <section id="project">
      <h2>Project</h2>
      <xsl:apply-templates select="//*[local-name() = 'Project']" mode="def-list"/>
    </section>
  </xsl:template>

  <xsl:template name="PublicationsSection">
    <section id="publications">
      <h2>Publications</h2>
      <xsl:apply-templates select="//*[local-name() = 'Publications']"/>
    </section>
  </xsl:template>

  <xsl:template name="CreationSection">
    <section id="creation">
      <h2>Creation</h2>
      <xsl:apply-templates select="//*[local-name() = 'Creation']"/>
    </section>
  </xsl:template>

  <xsl:template name="CitationSection">
    <section id="citation">
      <h2>Citation Information</h2>
      <xsl:call-template name="CitationExamples"/>
    </section>
  </xsl:template>

  <xsl:template name="ReportViolation">
    <section id="violation">
      <h2>Report Violation</h2>
      <xsl:call-template name="ViolationText"/>
    </section>
  </xsl:template>

  <xsl:template name="DocumentationSection">
    <section id="documentation">
      <h2>Documentation</h2>
      <xsl:apply-templates select="//*[local-name() = 'Documentations']" mode="list"/>
    </section>
  </xsl:template>

  <xsl:template name="AccessSection">
    <section id="access">
      <h2>Access</h2>
      <!-- Only grab the <Access> node which is a direct child of the profile: -->
      <xsl:apply-templates select="/*/*/*/*[local-name() = 'Access']" mode="def-list"/>
    </section>
  </xsl:template>

  <xsl:template name="DataFilesSection">
    <section id="data-files">
      <h2>Data Files</h2>
      <xsl:apply-templates select="//*[local-name() = 'ResourceProxyList']"/> 
    </section>
  </xsl:template>

  <!-- Resource type specific templates -->

  <xsl:template match="*[local-name() = 'LexicalResourceContext']">
    <section id="resource-specific">
      <h2>Lexical Resource</h2>
      <xsl:call-template name="LexicalResourceContextAsSection"/> 
    </section>
  </xsl:template>

  <xsl:template match="*[local-name() = 'ExperimentContext']">
    <section id="resource-specific">
      <h2>Experiment(s)</h2>
      <xsl:call-template name="ExperimentContextAsSection"/> 
    </section>
  </xsl:template>

  <xsl:template match="*[local-name() = 'ToolContext']">
    <section id="resource-specific">
      <h2>Tool(s)</h2>
      <xsl:call-template name="ToolContextAsTable"/> 
    </section>
  </xsl:template> 

  <xsl:template match="*[local-name() = 'SpeechCorpusContext']">
    <section id="resource-specific">
      <h2>Speech Corpus</h2>
      <xsl:call-template name="SpeechCorpusContextAsSection"/> 
    </section>
  </xsl:template>

  <xsl:template match="*[local-name() = 'TextCorpusContext']">
    <section id="resource-specific">
      <h2>Text Corpus</h2>
      <xsl:call-template name="TextCorpusContextAsSection"/> 
    </section>
  </xsl:template>

  <xsl:template match="*[local-name() = 'CourseProfileSpecific']">
    <section id="resource-specific">
      <h2>Course Information</h2>
      <xsl:call-template name="CourseProfileSpecificAsTable"/> 
    </section>
  </xsl:template>

  <!-- <xsl:template name="meta-description"> -->
  <!--   <xsl:element name="meta"> -->
  <!--     <xsl:attribute name="name">description</xsl:attribute> -->
  <!--     <xsl:attribute name="content"> -->
  <!--       <!-\- TODO! This can be important for SEO. Resource class? -->
  <!--            Genre? profile type? Descriptions? -\-> -->
  <!--     </xsl:attribute> -->
  <!--   </xsl:element> -->
  <!-- </xsl:template> -->

  <!-- <xsl:template name="social-media-links"> -->
  <!--   <ul class="social-media-list"> -->
  <!--     <li> -->
  <!--       <a href="https://www.facebook.com/clarindeutschland"> -->
  <!--         <svg class="svg-icon" id="facebook" fill-rule="evenodd" clip-rule="evenodd" -->
  <!--              stroke-linejoin="round" stroke-miterlimit="1.414"> -->
  <!--           <path -->
  <!--               d="M15.117 0H.883C.395 0 0 .395 0 .883v14.234c0 .488.395.883.883.883h7.663V9.804H6.46V7.39h2.086V5.607c0-2.066 1.262-3.19 3.106-3.19.883 0 1.642.064 1.863.094v2.16h-1.28c-1 0-1.195.48-1.195 1.18v1.54h2.39l-.31 2.42h-2.08V16h4.077c.488 0 .883-.395.883-.883V.883C16 .395 15.605 0 15.117 0" -->
  <!--               /> -->
  <!--         </svg> -->
  <!--         <span class="username">clarindeutschland</span> -->
  <!--       </a> -->
  <!--     </li> -->
  <!--     <li> -->
  <!--       <a href="https://www.twitter.com/CLARIN_D"> -->
  <!--         <svg class="svg-icon" id="twitter" fill-rule="evenodd" clip-rule="evenodd" -->
  <!--              stroke-linejoin="round" stroke-miterlimit="1.414"> -->
  <!--           <path -->
  <!--               d="M16 3.038c-.59.26-1.22.437-1.885.517.677-.407 1.198-1.05 1.443-1.816-.634.37-1.337.64-2.085.79-.598-.64-1.45-1.04-2.396-1.04-1.812 0-3.282 1.47-3.282 3.28 0 .26.03.51.085.75-2.728-.13-5.147-1.44-6.766-3.42C.83 2.58.67 3.14.67 3.75c0 1.14.58 2.143 1.46 2.732-.538-.017-1.045-.165-1.487-.41v.04c0 1.59 1.13 2.918 2.633 3.22-.276.074-.566.114-.865.114-.21 0-.41-.02-.61-.058.42 1.304 1.63 2.253 3.07 2.28-1.12.88-2.54 1.404-4.07 1.404-.26 0-.52-.015-.78-.045 1.46.93 3.18 1.474 5.04 1.474 6.04 0 9.34-5 9.34-9.33 0-.14 0-.28-.01-.42.64-.46 1.2-1.04 1.64-1.7z" -->
  <!--               /> -->
  <!--         </svg> -->
  <!--         <span class="username">CLARIN_D</span> -->
  <!--       </a> -->
  <!--     </li> -->
  <!--     <li> -->
  <!--       <a href="https://youtube.com/CLARINGermany"> -->
  <!--         <svg class="svg-icon" id="youtube" fill-rule="evenodd" clip-rule="evenodd" -->
  <!--              stroke-linejoin="round" stroke-miterlimit="1.414"> -->
  <!--           <path -->
  <!--               d="M0 7.345c0-1.294.16-2.59.16-2.59s.156-1.1.636-1.587c.608-.637 1.408-.617 1.764-.684C3.84 2.36 8 2.324 8 2.324s3.362.004 5.6.166c.314.038.996.04 1.604.678.48.486.636 1.588.636 1.588S16 6.05 16 7.346v1.258c0 1.296-.16 2.59-.16 2.59s-.156 1.102-.636 1.588c-.608.638-1.29.64-1.604.678-2.238.162-5.6.166-5.6.166s-4.16-.037-5.44-.16c-.356-.067-1.156-.047-1.764-.684-.48-.487-.636-1.587-.636-1.587S0 9.9 0 8.605v-1.26zm6.348 2.73V5.58l4.323 2.255-4.32 2.24z" -->
  <!--               /> -->
  <!--         </svg> -->
  <!--         <span class="username">CLARINGermany</span> -->
  <!--       </a> -->
  <!--     </li> -->
  <!--   </ul> -->
  <!-- </xsl:template> -->
</xsl:stylesheet>
