#!/usr/bin/env python
# -*- coding:Utf-8 -*- 

helptxt="""
Sélectionnez un élément pour le configurer.

Vous pouvez déplacer chaque élément avec un glisser-déposer (drag'n drop) ou les boutons de déplacement.

Cliquez sur "Restaurer" pour revenir au menu avant toute modification.

Il existe plusieurs types d'entrées : 
    - exec : lance une commande
    - submenu : crée un sous-menu
    - separator : un séparateur
    - nom : une ligne vide
    - wallpaper : un menu automatiquement généré qui peut lancer une commande sur les fichiers listés.

N'oubliez pas de sauvegarder votre menu avant de quitter.
"""

TYPEOPTIONS = ["", "exec", "submenu", "separator", "nop", "wallpaper"]

# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

