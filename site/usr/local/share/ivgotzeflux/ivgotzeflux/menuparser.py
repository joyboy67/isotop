#!/usr/bin/env python
# -*- coding:Utf-8 -*- 

import shutil
import re
import os

default_menupath=os.path.expanduser("~/.fluxbox/menu")


def read_menu(menufile=default_menupath):
    menu, menuContents = [], []
    menufile = os.path.expanduser(menufile)
    if os.path.isfile(menufile):

        with open(menufile, 'r') as cFile:
            menuContents = cFile.readlines()

        # Parse the file
        for menuItem in menuContents:
            menuItem = menuItem.strip()
            if menuItem.startswith('#'):
                isComment = True
            else:
                isComment = False

            # Item's type is marked with [ and ]
            itemType = get_item(menuItem, '[', ']').lower()

            if itemType != '':
                # Name with ( and )
                itemName = get_item(menuItem, '(', ')')
                # Command with { and }
                itemCommand= get_item(menuItem, '{', '}')
                # And icon with < and >
                itemIcon = get_item(menuItem, '<', '>')
         
                menu.append([itemType, itemName, itemCommand, itemIcon, not isComment])

    return menu


def save_menu(menu, filename=default_menupath):
    config = ""
    lines = []
    for e in menu:
        line = "[{}] ({}) {{ {} }} <{}>".format(e[1], e[0], e[2], e[3])
        lines.append(line)

    config += '\n'.join(lines)

    with open(filename, "w") as menufile:
        menufile.write(config)


def backup_menu(menufile=default_menupath):
    if not os.path.isfile(menufile): return 0
    shutil.copy(menufile, menufile+".bak")

def restore_menu():
    shutil.copy(default_menupath+".bak", default_menupath)


def get_item(line, startchar, endchar):
    if startchar == '[':
        startchar = '\['
    elif startchar == '(':
        startchar = '\('
    if endchar == ']':
        endchar = '\]'
    elif endchar == ')':
        endchar = '\)'

    pattern = "{}.*{}".format(startchar, endchar)
    result = re.search(pattern, line)
    if result != None:
        return(result.group()[1:-1]).strip() # [1:-1] to remove startchar & endchar
    else:
        return('')

def main():
    a = read_menu("~/.fluxbox/menu")
    for line in a:
        print(line)

    return 0

if __name__ == '__main__':
	main()


