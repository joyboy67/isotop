#!/usr/bin/env python
# -*- coding:Utf-8 -*- 


"""

Auteur :      3hg team <3hg@lists.toile-libre.org>  
licence :     MIT
Dependences : Tkinter, PIL
    python3-pil python3-tk python3-pil.imagetk

"""

import sys
from ivgotzeflux.gui import *

def main():
    config = os.path.expanduser("~/.fluxbox/menu")

    if not os.path.isfile(config):
        print("Error reading config file : doesn't exist")
        sys.exit(1)

    backup_menu()
    app = FluxConf(config)

    return 0

if __name__ == '__main__':
	main()


# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

