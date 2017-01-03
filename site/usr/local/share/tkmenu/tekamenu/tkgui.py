#!/usr/bin/env python
# -*- coding:Utf-8 -*- 

# Dépendances : python3, python3-tk, python3-pil

import sys
if sys.version_info >= (3, 0):
    from tkinter import *
    from tkinter import ttk
    from tkinter import messagebox
else:
    from Tkinter import *
    import ttk
    import tkMessageBox as messagebox
from PIL import Image, ImageTk


import tkinter
from subprocess import Popen
from tekamenu.const import *
from tekamenu.tools import *

def change_colors(style, color="light"):
    if color == "dark":
        theme = {
            'disabledfg':"#000000",
            'dark': "#222222",
            'darker': "#111111",
            'darkest': "#000000",
            'lighter': "#333333",
            'lightest': "#eeeeee",
            'selectbg': "#28952D",
            'selectfg': "#dddddd",
            'foreground': "#eeeeee",
            'background': "#000000",
            'borderwidth': 0,
            'font': ("Droid Sans", 10),
            'tabfont': ("Droid Sans", 10, "bold")
            }
    else:
        theme = {
            'disabledfg':"#eeeeee",
            'dark': "#777777",
            'darker': "#333333",
            'darkest': "#777777",
            'lighter': "#777777",
            'lightest': "#ffffff",
            'selectbg': "#41B1FF",
            'selectfg': "#cccccc",
            'foreground': "#111111",
            'background': "#dddddd",
            'borderwidth': 0,
            'font': ("Droid Sans", 10),
            'tabfont': ("Droid Sans", 10, "bold")
            }

    style.configure(".", padding=5, relief="flat", 
            background=theme['background'],
            foreground=theme['foreground'],
            bordercolor=theme['darkest'],
            darkcolor=theme['dark'],
            lightcolor=theme['lighter'],
            troughcolor=theme['darker'],
            selectbackground=theme['selectbg'],
            selectforeground=theme['selectfg'],
            selectborderwidth=theme['borderwidth'],
            font=theme['font']
            )

    style.map(".",
        foreground=[('pressed', theme['darkest']), ('active', theme['selectfg'])],
        background=[('pressed', '!disabled', 'black'), ('active', theme['lighter'])]
        )

    style.configure("TButton", relief="flat")
    style.map("TButton", 
        background=[('disabled', theme['disabledfg']), ('pressed', theme['selectbg']), ('active', theme['selectbg'])],
        foreground=[('disabled', theme['disabledfg']), ('pressed', theme['selectfg']), ('active', theme['selectfg'])],
        )

    style.configure('TNotebook', tabposition='n', bordercolor=theme['lighter'])
    style.configure('TNotebook.Tab', borderwidth=0, font=theme['tabfont'])
    style.map("TNotebook.Tab", 
        background=[('selected', theme['background']), ('pressed', theme['selectbg']), ('active', theme['selectbg'])],
        foreground=[('disabled', theme['disabledfg']), ('selected', theme['selectbg']), ('active', theme['selectfg'])],
        lightcolor=[('disabled', theme['disabledfg']), ('selected', theme['lighter'])],
        darkcolor=[('disabled', theme['disabledfg']), ('selected', theme['lighter'])],
        )


def Popup(txt):
    messagebox.showinfo(message = txt)

class Executor():
    def __init__(self, name, cmd, icon, cf):
        self.name = name
        self.cmd = cmd
        self.icon = icon
        self.cf = cf

    def start(self):
        Popen(self.cmd, shell="True")

        add_recent(self.name, self.cmd, self.icon, self.cf)

        if closeafter(self.cf):
            sys.exit()


class TKMenu():
    def __init__(self, configfile):
        fullconfig = get_config(configfile)
        self.config = read_config(fullconfig)

        # main window
        self.root = Tk()

        # style
        #('clam', 'alt', 'default', 'classic')
        style = ttk.Style()
        style.theme_use("clam")

        theme = "light"
        if fullconfig.has_option("DEFAULT","theme"):
            theme = fullconfig.get("DEFAULT","theme")
        change_colors(style, theme)

        self.root.title(appname)
        # no title bar
        #self.root.overrideredirect(True)

        # to have a border
        self.root.configure(background='#336699')

        mainframe = ttk.Frame(self.root)
        mainframe.pack(fill=BOTH,expand=True, padx=1, pady=1)

        # Décommenter pour avoir un titre
        #label = ttk.Label(mainframe,text=appname, font=("Liberation Sans", 24))
        #label.pack()

        self.ntbk = ttk.Notebook(mainframe)
        self.ntbk.enable_traversal()
        self.ntbk.pack(fill=BOTH,expand=True)

        # to show the box checked if necessary
        closeaftervar=IntVar(self.root)
        if fullconfig.has_option("DEFAULT","closeafterrun"):
            closeaftervar.set(fullconfig.getboolean("DEFAULT","closeafterrun"))

        # bottom box
        btmbox = ttk.Frame(mainframe)
        btmbox.pack(fill=X, expand=True)

        chk = ttk.Checkbutton(btmbox, text="Fermer",
                command=lambda: toggle_closeafter(configfile), variable=closeaftervar)
        chk.pack(side=LEFT)

        exitbtn = ttk.Button(btmbox, text="✗", width=3, command=self.stop)
        exitbtn.pack(side=RIGHT)

        aboutbtn = ttk.Button(btmbox, text="?", width=3, command=lambda: Popup(abouttxt))
        aboutbtn.pack(side=RIGHT)

        allappbtn = ttk.Button(btmbox, text="Toutes les applications", 
                command=self.full_app_launcher)
        allappbtn.pack(side=RIGHT)

        # create a popup menu
        self.menu = Menu(self.root, tearoff=0)
        self.menu.add_command(label="Configurer", command=lambda:edit_config(configfile))

        # to drag the window
        #for widget in [mainframe, label]:
        for widget in [mainframe]:
            widget.bind("<ButtonPress-1>", self.StartMove)
            widget.bind("<ButtonRelease-1>", self.StopMove)
            widget.bind("<B1-Motion>", self.OnMotion)

        # uncomment if it's a really big menu
        #self.root.after(0, self.make_tabs)
        self.make_tabs()
        self.center()
        self.root.mainloop()

    def make_tabs(self):
        for s in self.config.keys():
            self.make_tab(s)
            """
            self.root.update_idletasks()
            self.root.geometry("{}x{}".format(
                self.root.winfo_reqwidth() , self.root.winfo_reqheight()))
            self.center()
            """

    def make_tab(self,s):
        col, r= 0, 0

        frame = ttk.Frame(self.ntbk)
        frame.grid_rowconfigure(0, weight=1)
        frame.grid_columnconfigure(0, weight=1)

        self.ntbk.add(frame, text = s)

        btn_container = ttk.Frame(frame)
        btn_container.grid()

        # pour la configuration
        frame.bind("<Button-3>", self.popup)
        btn_container.bind("<Button-3>", self.popup)


        for l in self.config[s]:
            name, cmd, icon_path = l
        
            if os.path.isfile(icon_path):
                image = Image.open(icon_path)
                image = image.resize((icon_w, icon_h), Image.ANTIALIAS)
                icon = ImageTk.PhotoImage(image)
            else:
                icon=None

            e = Executor(name, cmd, icon_path, configfile)

            b = ttk.Button(btn_container, text=name, 
                    compound=TOP, image=icon,
                    command=e.start)
            b.image = icon
            b.bind("<Button-3>", self.popup)
            b.grid(column=col, row=r, sticky=(E,W))

            col += 1
            if col > maxcol:
                col = 0
                r += 1

    def full_app_launcher(self):
        app = try_to_run(['thelauncher', 'xfce4-appfinder', 'krunner', 'gnome-run', 'fbrun'])
        if app:
            Popen(app)
        else:
            Popup("Désolé, aucun lanceur trouvé")


    def StartMove(self, event):
        self.x = event.x
        self.y = event.y

    def StopMove(self, event):
        self.x = None
        self.y = None

    def OnMotion(self, event):
        deltax = event.x - self.x
        deltay = event.y - self.y
        x = self.root.winfo_x() + deltax
        y = self.root.winfo_y() + deltay
        self.root.geometry("+%s+%s" % (x, y))

    def stop(self):
        self.root.destroy()

    def popup(self,event):
        self.menu.post(event.x_root, event.y_root)

    def center(self):
        self.root.update_idletasks()
        w = self.root.winfo_screenwidth()
        h = self.root.winfo_screenheight()
        size = tuple(int(_) for _ in self.root.geometry().split('+')[0].split('x'))
        x = w/2 - size[0]/2
        y = h/2 - size[1]/2
        self.root.geometry("%dx%d+%d+%d" % (size + (x, y)))


        
