#!/usr/bin/env python
# -*- coding:Utf-8 -*- 

import os

### Config
# default config file
configfile = os.path.expanduser("~/.tkmenu")
appname = "TkMeν"
icon_w, icon_h = 48, 48
maxcol = 3
minw, minh = 590,100
max_recents = 8
abouttxt = """
{}
---
Made with love by 3hg team
http://3hg.toile-libre.org

Distributed under MIT licence
---
To configure, right-click anywhere.
You can use "light" or "dark" theme.
Any image format is supported, and any command can be used.
Just use lines like : 
    anything = Name, command, /path/to/icon
""".format(appname)
closeafter=True


defaultconfig="""
[DEFAULT]
closeafterrun = True
theme = light

# [Categorie]
# launcher_name = name, command, /path/to/icon
[Recent]
0 = Navigateur web, firefox,     /usr/local/lib/firefox-esr-45.2.0/browser/icons/mozicon128.png 
1 = Dossier personnel, thunar,    /usr/local/share/icons/gnome-brave/32x32/places/user-home.png
2 = Courriels, thunderbird,     /usr/local/lib/thunderbird-45.2.0/chrome/icons/default/default48.png 
3 = Services Framasoft, firefox https://framasoft.org/,   /usr/local/share/sio2/pixmaps/internet_framasoft.png
4 = Suite bureautique, libreoffice, /usr/local/share/icons/hicolor/48x48/apps/libreoffice-startcenter.png
5 = Crawl , crawl-ss, /usr/local/share/crawl/dat/tiles/stone_soup_icon-512x512.png
6 = Gestion du volume, ovol, /usr/local/share/icons/gnome-brave/32x32/status/stock_volume.png
7 = Configuration WiFi, owi, /usr/local/share/icons/gnome-colors-common/32x32/devices/network-wireless.png


[Internet]
navigateur web = Navigateur web, firefox,     /usr/local/lib/firefox-esr-45.2.0/browser/icons/mozicon128.png 
Courriels = Courriels, thunderbird,     /usr/local/lib/thunderbird-45.2.0/chrome/icons/default/default48.png 
Discuter = Discuter, st poezio, /usr/local/share/sio2/pixmaps/poezio.png
framasoft = Services Framasoft, firefox https://framasoft.org/,   /usr/local/share/sio2/pixmaps/internet_framasoft.png

[Fichiers]
Dossier Personnel = Dossier Personnel, thunar ~, /usr/local/share/icons/gnome-brave/32x32/places/user-home.png
Mes Images = Mes Images, thunar ~/Images, /usr/local/share/icons/gnome-brave/32x32/places/folder-images.png
Mes Documents = Mes Documents, thunar ~/Documents, /usr/local/share/icons/gnome-brave/32x32/places/folder-documents.png
Mes Musiques = Mes Musiques, thunar ~/Musiques, /usr/local/share/icons/gnome-brave/32x32/places/folder-music.png
Mes Vidéos = Mes Vidéos, thunar ~/Vidéos, /usr/local/share/icons/gnome-brave/32x32/places/folder-videos.png
Téléchargements = Mes Téléchargements, thunar ~/Téléchargements, /usr/local/share/icons/gnome-brave/32x32/places/folder-downloads.png
Modeles = Mes Modèles, thunar ~/Modèles, /usr/local/share/icons/gnome-brave/32x32/places/folder-templates.png
Vérifier la poubelle = Vérifier la poubelle, thunar trash:///, /usr/local/share/icons/gnome/48x48/places/gnome-stock-trash.png

[Bureautique]
Lowriter= Texte, lowriter, /usr/local/share/icons/hicolor/48x48/apps/libreoffice-writer.png
Localc= Tableur , localc, /usr/local/share/icons/hicolor/48x48/apps/libreoffice-calc.png
#Dessin = Dessin, lodraw, /usr/local/share/icons/hicolor/48x48/apps/libreoffice-draw.png
Presentation = Présentation, loimpress, /usr/local/share/icons/hicolor/48x48/apps/libreoffice-impress.png
Gummi = Éditeur LaTeX, gummi, /usr/local/share/gummi/icons/gummi.png

[Multimedia]
Simple-scan = Scanner, simple-scan, /usr/local/share/icons/gnome/48x48/devices/scanner.png
Lecteur vidéo = Lecteur vidéo, mpv --profile=pseudo-gui, /usr/local/share/icons/hicolor/64x64/apps/mpv.png
Gimp = Editeur d'image , gimp, /usr/local/share/icons/hicolor/48x48/apps/gimp.png
Inkscape = Images vectorielles , inkscape, /usr/local/share/icons/hicolor/48x48/apps/inkscape.png

[Système]
owi = Configuration WiFi, owi, /usr/local/share/icons/gnome-colors-common/32x32/devices/network-wireless.png
ivgotzeflux = Configuration du menu, ivgotzeflux, /usr/local/share/icons/gnome-brave/32x32/apps/menu-editor.png
ovol = Gestion du volume, ovol, /usr/local/share/icons/gnome-brave/32x32/status/stock_volume.png


"""


# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

