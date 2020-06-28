/* UserCode */

%%
/* Options and declarations */

%standalone

Imagen = class=\"image\">
Audio = (class=\"mediaContainer\")|(class=\"unicode\saudiolink\")
Video = class=\"PopUpMediaTransform\"

Gallery = (class=\"gallerybox\")

ExtImagen = (\.jpg)|(\.JPG)|(\.jpeg)|(\.JPEG)|(\.png)|(\.PNG)|(\.svg)|(\.SVG)|(\.gif)|(\.GIF)
LinkImagen = https:\/\/commons\.wikimedia\.org\/wiki\/File:\S+{ExtImagen}

ExtVideo = (\.ogv)|(\.OGV)
LinkVideo = https:\/\/upload\.wikimedia\.org\/wikipedia\/commons\/\S+{ExtVideo}

Destacados = (Featured_pictures)|(Valued_images)

%state GAL, VID

%{
    public String link_dest = "";
%}

%%
/* Lexical rules */

{Gallery}                                   { yybegin(GAL); }
{Video}                                     { WikiCrawler.nVideo++; yybegin(VID); }

<GAL> {
    {LinkImagen}                            { WikiCrawler.enlacesImagenes.add(yytext()); link_dest = yytext(); } //link antes
    {Imagen}                                { WikiCrawler.nImg++; }
    {Destacados}                            { WikiCrawler.enlacesDestacados.add(link_dest); yybegin(YYINITIAL);}
    \<\/p>                                  { yybegin(YYINITIAL); }
}

<VID> {
    {LinkVideo}/\"                          { WikiCrawler.enlacesVideo.add(yytext()); yybegin(YYINITIAL); }
}

{Audio}                                     { WikiCrawler.nAudio++; yybegin(YYINITIAL); }

[^]                                         { /* ignorar */ }