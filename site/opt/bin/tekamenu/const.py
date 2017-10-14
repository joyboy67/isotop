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


defaultconfig="""
[DEFAULT]
closeafterrun = True
theme = light
titlebar = True
title = False

# [Categorie]
# launcher_name = name, command, /path/to/icon
[Recent]
0.0 = Navigateur web, firefox,     /usr/local/lib/firefox-esr-45.2.0/browser/icons/mozicon128.png 
1.0 = Dossier personnel, thunar,    /usr/local/share/icons/gnome-brave/32x32/places/user-home.png
2.0 = Services Framasoft, firefox https://framasoft.org/,   /usr/local/share/sio2/pixmaps/internet_framasoft.png
3.0 = Suite bureautique, libreoffice, /usr/local/share/icons/hicolor/48x48/apps/libreoffice-startcenter.png


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
Lecteur vidéo = Lecteur vidéo, vlc, /usr/local/share/icons/hicolor/48x48/apps/vlc.png
Gimp = Editeur d'image , gimp, /usr/local/share/icons/hicolor/48x48/apps/gimp.png
Inkscape = Images vectorielles , inkscape, /usr/local/share/icons/hicolor/48x48/apps/inkscape.png

"""

tkmenuicon="""
iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABHNCSVQICAgIfAhkiAAAAAlwSFlz
AAAA2AAAANgBXenH8QAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAIsSURB
VDiNdZFPSFRRFMa/c++MEypMikpNaUE5LRLK2WTQLCIyadEiyGg/C8FKMHHTxqBtgZbKUJm5ihwq
F4aC9ociBpxooZkQgThmZggxOUzz5t57WsQ8Z95rzvK73/md75wLFNRirL8xEY16UaIS0ah3Mdbf
WKgJu/lpf5Nhfm1VpT2lAAjAa5jffooNNLsAWslGJr6ZrW3Oler/XRm0mPiGMWJ/XtueJlQvgVqq
k4mx+djto0Uxjdw43N61Up1M+KjcO8RCxQE8KwL8Sf26BSl2bTUYXbu5c64QwMRDADpzmS+WxXuv
QJt1V4JXj+9dA6GFWD08FbleVwjwQWYAYGZ8plzI7B0w4gBixSuAJgCzkPbX5ELtV3/+7wZlVZal
UnwfEF/t9eyY4CMAhcfOD4drJj8Hnc2BiaVDw+dGTwAU/ud1AOzyeP1Sm0eB5/P1eWn35OI+TXpU
ecr8LrtNIn7ARBc6Ri7+gFELgkVTD5AEgO6B000MXhDkWTeENwI87krQM702CyAttD4IUEQLLvzK
EEARY1QQTLn08bWXrgQEMKa+dd89uyeYNtxJ7I3n3xSJKQG9WSHp3eUXqyOY3ia7bpBRHCKmQSZ1
xp7Cpo2YBjOKQyVvYE/bIRKU4Q6PkonWA9X1AEAkprQ2G6JCzjn9rgTZ1OqyFDimfbpVSvVRSvWB
2bQJyWF/sm7F6SenAAB9fRCV7wPB2eWtSwyYkw0VT3pnvi8RwE7vX7Rw5QJcMGEJAAAAAElFTkSu
QmCC
"""

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

