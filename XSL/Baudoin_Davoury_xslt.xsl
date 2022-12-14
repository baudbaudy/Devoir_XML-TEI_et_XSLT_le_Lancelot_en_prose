<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs tei"
    version="2.0">

<!--Sortie HTML-->

   <xsl:output method="html" indent="yes" encoding="UTF-8"/>
   <xsl:strip-space elements="*"/>


<!-- Définition de variables utilisées ultèrieurement -->

    <xsl:variable name="Auteur">
        <xsl:value-of select="//editionStmt/respStmt/persName"/>
    </xsl:variable>
    <xsl:variable name="Date_réalisation">
        <xsl:value-of select="//editionStmt/edition/date"/>
    </xsl:variable>
    <xsl:variable name="Lieu_réalisation">
        <xsl:value-of select="//publicationStmt/pubPlace/name"/>
    </xsl:variable>
    <xsl:variable name="Institution">
        <xsl:value-of select="//editionStmt/respStmt/orgName"/>
    </xsl:variable>


<!-- Récupération du nom et du chemin du fichier courant -->

    <xsl:variable name="witfile">
        <xsl:value-of select="replace(base-uri(.), '.xml', '')"/>
    </xsl:variable>


<!-- Configueration des sorties dans les règles XSL -->

    <xsl:template match="/">

<!-- Définition des variables des chemins des fichiers .html -->

        <xsl:variable name="pathAccueil">
            <xsl:value-of select="concat($witfile, 'page_accueil','.html')"/>
        </xsl:variable>

        <xsl:variable name="pathTranscription">
            <xsl:value-of select="concat($witfile,'Transcription','.html')"/>
        </xsl:variable>

        <xsl:variable name="pathIndex">
            <xsl:value-of select="concat($witfile,'index','.html')"/>
        </xsl:variable>

        <xsl:variable name="pathNumerisation">
            <xsl:value-of select="concat($witfile, 'numerisation', '.html')"/>
        </xsl:variable>

        <xsl:variable name="Titre_du_manuscrit">
            <xsl:value-of select="concat(.//sourceDesc/msDesc/head/title, ' ', '(',.//head/origDate, ')', ' de ', .//author[@xml:id='GM'] )"/>
        </xsl:variable>

<!-- Encodages des pages html. Toutes les pages html contiennent le même en-tête et un lien renvoyant vers le site de la BNF
        avec le manuscrit intégralement numérisé. Hormis le fichier de la page d'accueil, toutes les autres pages html disposent
        d'un renvoi vers la page d'accueil-->

<!-- Encodage de la page d'accueil contenant :
        - présentation du projet
        - informations et descriptions du manuscrit
        - table des matières avec renvoi vers les autres fichiers html -->

        <xsl:result-document href="{$pathAccueil}" method="html" indent="yes">
            <html>
    <!-- En-tête -->
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <title>
                        <xsl:value-of select=".//titleStmt/title"/>
                    </title>

                    <style>
                        .container {
                            display: flex;
                        }

                        div.colonne {
                            float: left;
                            width: 50%;
                            margin: 10px;
                            border-right: dotted 1px;
                            padding-right: 15px;
                            text-align: justify;
                        }

                        img {
                            display: block;
                            text-align: center;
                            margin: 50px;
                        }</style>

                </head>
                <body>
                    <h1><xsl:value-of select="$Titre_du_manuscrit"/></h1>

                    <div>
                      <div>
                    <p><xsl:text>Travaux réalisés par</xsl:text>
                        <xsl:value-of select="$Auteur"/>
                        <xsl:text>au sein de l'</xsl:text>
                        <xsl:value-of select="$Institution"/>
                        <xsl:text> à </xsl:text>
                        <xsl:value-of select="$Lieu_réalisation"/>
                        <xsl:text> le </xsl:text>
                        <xsl:value-of select="$Date_réalisation"/>
                    </p>



                    <span>
                        <a href="{.//titleStmt/title/@ref}">[lien vers le manuscrit numérisé]</a>
                    </span>

                    <p>

                        Le présent travail s'inscrit dans les projets et travaux demandés aux étudiants de l'ENC. Ici vous trouverez le travail de transcription et de mise en forme d'un mansucrit numérisé disponible sur Gallica, la bibliothèque virtuelle de la BNF.
                    </p>

                    <p>On a cherché à eploiter de différentes manières ce manuscrit notamment à travers <em> une
                            transcription</em> ou un <em>index des noms propres</em>.
                    </p>
                  </div>

                  <div>
                    <h2><u>Informations sur le manuscrit</u></h2>
                    <p>
                        <li><u><b>Auteur</b></u>: <xsl:value-of select=".//msItem/author"/></li>
                        <li><u><b>Langue</b></u>: <xsl:value-of select=".//textLang"/></li>
                        <li><u><b>Support</b></u>: <xsl:value-of select=".//support"/></li>
                        <li><u><b>Foliation</b></u>: <xsl:value-of select=".//foliation"/></li>
                    </p>
                  </div>

                  <div>

                    <h2><u>Description du manuscrit</u></h2>

                    <li><u><b>Plats: </b></u>: <xsl:value-of select=".//decoNote [@type='plats'] "/></li>
                    <li><u><b>Dos: </b></u>: <xsl:value-of select=".//decoNote [@type='dos'] "/></li>
                    <li><u><b>Contreplats</b></u>: <xsl:value-of select=".//decoNote [@type='contreplats'] "/></li>
                    <li><u><b>Décorations textuelles</b></u>:<xsl:value-of select=".//decoDesc"/></li>
                    <li><u><b>Forme d'écriture</b></u>: <xsl:value-of select=".//scriptDesc"/></li>
              </div>

              <div>
                    <h2><u>Récit du manuscrit</u></h2>
                    <li><u><b>Chapitre</b></u>: 57</li>
                    <li><u><b>Le ou les personnages principaux</b></u>: <xsl:call-template name="personnages_principaux"/></li>

              </div>

              <div class="colonne" n="2">>
                    <h2><u>Table des matières</u></h2>
                    <ul>
                        <li><a href="{$pathIndex}">Index des noms de personnages</a></li>
                        <li><a href="{$pathTranscription}">Transcription</a></li>
                        <li><a href="{$pathNumerisation}">Numerisation</a></li>
                        <li><a href="{$pathNotices}">Notices</a></li>

                    </ul>

                  </div>

                  <div class="colonne" n="3">
                    <img src="illustration.jpg" class="responsive" width="300px" height="auto"/>

                  </div>

                </div>
                </body>
            </html>
        </xsl:result-document>

<!-- Notices manuscrit -->
        <xsl:result-document href="{$pathNotices}" method="html" indent="yes">
            <html>
                <head>
                    <xsl:call-template name="meta-header"/>
                    <title>
                        <xsl:value-of select="concat($titre, ' - notice')"/>
                    </title>
                </head>
                <body>
                    <div class="container">
                        <div>
                            <a href="{$pathAccueil}">Retour accueil</a>
                        </div>
                        <xsl:call-template name="notice_manuscrit"/>
                    </div>
                </body>
            </html>
        </xsl:result-document>

<!-- Page html de la transcription du manuscrit et contenant -->

        <xsl:result-document href="{$pathTranscription}"
            method="html" indent="yes">
            <html>
    <!-- En-tête -->
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <title>
                        <xsl:value-of select=".//titleStmt/title"/>
                    </title>
                    <style>
                        div.colonne {
                            justify-content: space-between;
                            width: 100%;
                            padding: 20px;
                            border-style: double;
                            margin: 10px;
                            border-color: tan;
                            text-align: justify;
                        }

                        span.initiale {
                            font-size: larger;
                            font-weight: bolder
                        }</style>
                </head>
                <body>
                    <h1><xsl:value-of select="$Titre_du_manuscrit"/></h1>
                    <p><xsl:text>Travaux réalisés par</xsl:text>
                        <xsl:value-of select="$Auteur"/>
                        <xsl:text>au sein de l'</xsl:text>
                        <xsl:value-of select="$Institution"/>
                        <xsl:text> à </xsl:text>
                        <xsl:value-of select="$Lieu_réalisation"/>
                        <xsl:text> le </xsl:text>
                        <xsl:value-of select="$Date_réalisation"/>
                    </p>
                    <div>
                        <a href="{.//titleStmt/title/@ref}">[lien vers le manuscrit numérisé]</a>
                    </div>
                    <div>
                        <a href="{$pathAccueil}">Retour à l'accueil</a>
                    </div>

                    <div>
    <!-- Description des choix de transcription et d'édition -->
                        <p>
                            <it>
                                Dans le cadre de cette transcription, il a été choisi de mettre en avant plusieurs éléments du texte.
                                Ainsi, les lettrines décorées dans le manuscrit sont ici en rouge, les noms des personnages (que l'on peut retrouver dans <a href="{$pathIndex}">l'index</a>) sont en gras. Enfin, les différentes abréviations disposent de leur développement en italique.
                            </it>
                        </p>
                    </div>


                    <h2>Transcription</h2>

    <!-- Récupération du texte transcrit -->

                    <div>
                        <ul><xsl:apply-templates select=".//text//lg"/></ul>
                    </div>
                </body>
            </html>
        </xsl:result-document>


<!-- Encodage de la page html de l'index des noms de personnage -->

        <xsl:result-document href="{$pathIndex}" method="html" indent="yes">
            <html>
                <!-- En-tête -->
                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <title>
                        <xsl:value-of select=".//titleStmt/title"/>
                    </title>
                </head>
                <body>

                    <h1><xsl:value-of select="$Titre_du_manuscrit"/></h1>
                    <p><xsl:text>Travaux réalisés par</xsl:text>
                        <xsl:value-of select="$Auteur"/>
                        <xsl:text>au sein de l'</xsl:text>
                        <xsl:value-of select="$Institution"/>
                        <xsl:text> à </xsl:text>
                        <xsl:value-of select="$Lieu_réalisation"/>
                        <xsl:text> le </xsl:text>
                        <xsl:value-of select="$Date_réalisation"/>
                    </p>
                    <span>
                        <a href="{$pathAccueil}">Retour à l'accueil</a>
                    </span>
                    <div>
                        <a href="{.//titleStmt/title/@ref}">[lien vers le manuscrit numérisé]</a>
                    </div>

                    <h1>Index des noms propres</h1>
                    <div>

    <!-- Appel de l'index -->

                        <ul><xsl:call-template name="index"/></ul>
                    </div>
                </body>
            </html>
        </xsl:result-document>


<!-- Encodage la page contenant les pages numérisées du manuscrit -->

        <xsl:result-document href="{$pathNumerisation}" method="html" indent="yes">
            <html>

    <!-- En-tête -->

                <head>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                    <title>
                        <xsl:value-of select=".//titleStmt/title"/>
                    </title>
                </head>
                <body>
                    <h1><xsl:value-of select="$Titre_du_manuscrit"/></h1>




                    <p><xsl:text>Travaux réalisés par</xsl:text>
                        <xsl:value-of select="$Auteur"/>
                        <xsl:text>au sein de l'</xsl:text>
                        <xsl:value-of select="$Institution"/>
                        <xsl:text> à </xsl:text>
                        <xsl:value-of select="$Lieu_réalisation"/>
                        <xsl:text> le </xsl:text>
                        <xsl:value-of select="$Date_réalisation"/>
                    </p>



                    <span>
                        <a href="{.//titleStmt/title/@ref}">[lien vers le manuscrit numérisé]</a>
                    </span>
                    <div>
                        <a href="{$pathAccueil}">Retour à l'accueil</a>
                    </div>
                    <h2><u>Images numérisées des pages du manuscrit</u></h2>
    <!-- Appel des images -->
                   <xsl:call-template name="images"></xsl:call-template>
                </body>
            </html>
        </xsl:result-document>
 </xsl:template>




<!-- Transcription et mise en forme du texte -->


    <!-- numérotation des rubriques du texte du manuscrit-->
    <xsl:template match="lg">
        <xsl:text>(Rubrique </xsl:text>
            <xsl:number count="lg" level="any" format="I"/>
        <xsl:text>)</xsl:text>
            <xsl:apply-templates/>
    </xsl:template>

    <!-- Récupération des lignes du texte avec numérotation de ces dernières-->
    <xsl:template match="l">
        <xsl:element name="li">
            <xsl:text>(l. </xsl:text>
            <xsl:number count="l" level="any" format="1"/>
            <xsl:text>) </xsl:text>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <!-- Mise en avant des occurences des personnages dans le texte
     en les affichant en gras-->
    <xsl:template match="persName">

            <b>
                <xsl:value-of select="."/>
            </b>

    </xsl:template>


    <!-- Mise en avant des abbréviations dans le texte en mettant leur développement
     en italique et entre parenthèses -->

    <xsl:template match="expan">
        <i>
            <xsl:text>(</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>)</xsl:text>
        </i>
    </xsl:template>

    <!-- Mise en avant des caractères et lettrines ornéeset colorées du texte en
    les affichant en rouge-->

    <xsl:template match="g">
        <font color="#FF0000">
            <xsl:value-of select="."/>
        </font>
    </xsl:template>



<!-- Pour la page d'accueil, condition et récupération des noms des personnages principaux -->
    <xsl:template name="personnages_principaux">
        <xsl:for-each select="//listPerson//persName">
            <xsl:if test="parent::person/@role='personnage_principal'">
                <xsl:copy-of select="."></xsl:copy-of>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


<!-- Récupération et mise en forme de l'index des personnages du manuscrit -->

    <xsl:template name="index">


  <!--Condition pour classer les noms de personnage par ordre alphabétique -->
        <xsl:for-each select="//listPerson//persName">
            <xsl:sort select="parent::person/@xml:id" order="ascending" data-type="text"/>

            <li>

                <xsl:value-of select="."/>
                <xsl:variable name="idPerson">
                    <xsl:value-of select="parent::person/@xml:id"/>
                </xsl:variable>
                <xsl:text> : </xsl:text>

    <!-- Règle afin de relever et d'assigner les lignes où les personnages sont mentionnés-->
                <xsl:for-each select="//body//persName[replace(@ref, '#','')=$idPerson]">

                    <xsl:text> (l. </xsl:text>
                    <xsl:number count="l" level="any" format="1"/>
                    <xsl:text>)</xsl:text>


    <!-- Condition et régle de mise en forme pour l'ajout automatique de "," et de "." -->
                    <xsl:choose>
                        <xsl:when test="position() != last()">, </xsl:when>
                        <xsl:otherwise>.</xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
         </li>
      </xsl:for-each>

    </xsl:template>

<!-- Importation et visualisation des images numérisées -->

    <xsl:template match="facsimile" name="images">
        <div>
    <!-- Récuperation des fichiers images -->
            <xsl:for-each select=".//surface">
                <xsl:variable name="url"
                    select="concat(substring-before($witfile, 'Baudoin DAVOURY_TEI'), ./graphic/@url)"/>

    <!-- alignement et définition de la taille des images sur la page html-->
                <p data-section="{position()}">
                    <a href="{$url}">
                        <img src="{$url}"  height="1000px"/>
                    </a>
                </p>
            </xsl:for-each>
        </div>
    </xsl:template>

    <!-- page de notice du manuscrit -->
    <xsl:template name="notice_manuscrit">
        <h1>
            <xsl:value-of select=".//titleStmt/title"/>
        </h1>
        <h2>
            <xsl:text>Manuscrit </xsl:text>
            <em>
                <xsl:value-of select="TEI//msIdentifier/idno"/>
            </em>
        </h2>

        <div>
            <h3>Identification :</h3>
        </div>
        <dl>
            <dt>
                <b>Institution de conservation :</b>
            </dt>
            <dd>
                <xsl:value-of
                    select="concat(.//country, ' - ', .//institution, ' (', .//settlement, ') ', .//repository)"
                />
            </dd>
            <dt>
                <b>Cote :</b>
            </dt>
            <dd>
                <xsl:value-of select=".//msIdentifier/idno"/>
            </dd>
            <dt>
                <b>Ancienne cote : </b>
            </dt>
            <dd>
                <xsl:value-of select="replace(.//altIdentifier[1]/idno, '(Ancienne cote)', '')"/>
            </dd>
        </dl>

        <h3>Histoire de la conservation du manuscrit :</h3>
        <p>
            <xsl:value-of select=".//provenance/p"/>
        </p>

        <h3>Mentions de responsabilité :</h3>

        <dl>
            <dt>
                <b>Auteur :</b>
            </dt>
            <dd>
                <xsl:value-of select="replace(//msItem/note, 'Walter', ' et/ou Walter')"/>
            </dd>
            <dt>
                <b>Enlumineur :</b>
            </dt>
            <dd>
                <xsl:value-of select=".//msItem//respStmt//persName"/>
            </dd>
        </dl>

        <h3>Description physique :</h3>

        <dl>
            <dt>
                <b>Langue :</b>
            </dt>
            <dd>
                <xsl:value-of select=".//textLang"/>
            </dd>
            <dt>
                <b>Support :</b>
            </dt>
            <dd>
                <xsl:value-of select=".//support"/>
            </dd>
            <dt>
                <b>Format :</b>
            </dt>
            <dd>
                <xsl:value-of select="concat(.//width/@unit, ' x ', .//height/@unit)"/>
            </dd>
            <dt>
                <b>Foliation :</b>
            </dt>
            <dd>
                <xsl:value-of select=".//foliation"/>
            </dd>
            <dt>
                <b>Disposition du texte :</b>
            </dt>
            <dd>
                <xsl:value-of select=".//layout"/>
            </dd>
            <dt>
                <b>Décorations :</b>
            </dt>
            <dd>
                <xsl:apply-templates select="//decoDesc/decoNote"/>
            </dd>
            <div class="column">
                <dt>
                    <b>Reliure :</b>
                </dt>
                <dd>
                    <xsl:value-of
                        select=".//decoNote[@type = 'plats'] | .//decoNote[@type = 'dos'] | .//decoNote[@type = 'contreplats']"
                    />
                </dd>
                <dd>
                    <img class="img" src="armoiries.jpg" width="150px"/>
                </dd>
            </div>


        </dl>

        <h3>Les différentes parties :</h3>

        <dl>
            <dd>
                <xsl:value-of select=".//msContents/summary"/>
            </dd>
            <dt>
                <b>Incipit :</b>
            </dt>
            <dd>
                <xsl:value-of select="concat(' ''', .//incipit, '''')"/>
            </dd>
            <dt>
                <b>Explicit :</b>
            </dt>
            <dd>
                <xsl:value-of select="concat(' ''', .//explicit, '''')"/>
            </dd>
        </dl>


    </xsl:template>


</xsl:stylesheet>
