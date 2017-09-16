#!/usr/bin/env python
# -*- coding:Utf-8 -*- 

# Dépendances : python3, python3-tk, python3-pil

import sys
from tkinter import *
from tkinter import ttk
from tkinter import messagebox
from PIL import Image, ImageTk

from subprocess import Popen
from tekamenu.const import *
from tekamenu.tools import *

def change_colors(style, color="light"):
    if color == "dark":
        theme = {
            'disabledfg':"#111111",
            'selectbg': "#28952D",
            'selectfg': "#444444",
            'foreground': "#dddddd",
            'background': "#111111",
            'dark': "#111111",
            'lighter': "#111111",
            'borderwidth': 0,
            'font': ("Droid Sans", 10),
            'tabfont': ("Droid Sans", 10, "bold")
            }
    else:
        theme = {
            'disabledfg':"#eeeeee",
            'dark': "#2E3436",
            'selectbg': "#4A90D9",
            'selectfg': "#E8E8E7",
            'foreground': "#2E3436",
            'background': "#e8e8e7",
            'lighter': "#2E3436",
            'borderwidth': 0,
            'font': ("Droid Sans", 10),
            'tabfont': ("Droid Sans", 10, "bold")
            }

    style.configure(".", padding=5, relief="flat", 
            background=theme['background'],
            foreground=theme['foreground'],
            window=theme['background'],
            frame=theme['foreground'],
            bordercolor=theme['foreground'],
            indicatorcolor=theme['selectbg'],
            focuscolor=theme['selectbg'],
            darkcolor=theme['dark'],
            lightcolor=theme['lighter'],
            troughcolor=theme['foreground'],
            selectbackground=theme['selectbg'],
            selectforeground=theme['selectfg'],
            troughtcolor=theme['selectbg'],
            highlightcolor=theme['selectbg'],
            selectborderwidth=theme['borderwidth'],
            font=theme['font']
            )

    style.configure("TButton", relief="flat")
    style.map("TButton", 
        background=[('disabled', theme['disabledfg']), ('pressed', theme['selectbg']), ('active', theme['selectbg']) ],
        foreground=[('disabled', theme['disabledfg']), ('pressed', theme['selectfg']), ('active', theme['selectfg'])],
        )
    style.configure("TLabel", borderwidth=0)
    style.configure("TFrame", borderwidth=0)

    style.configure('TNotebook', tabposition='n', bordercolor=theme['background'], borderwidth=0)
    style.configure('TNotebook.Tab', borderwidth=0, font=theme['tabfont'])
    style.map("TNotebook.Tab", 
        background=[('selected', theme['selectbg']), ('active', theme['background'])],
        foreground=[('selected', theme['selectfg']), ('active', theme['selectbg'])],
        lightcolor=[('selected', theme['selectbg']), ('active', theme['background'])],
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

        config = get_config(self.cf)
        if config.has_option("DEFAULT","closeafterrun"):
            closeafterrun =  config.getboolean("DEFAULT","closeafterrun")
            if closeafterrun:
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
        if not toggle(configfile,"titlebar"):
            # no title bar
            self.root.overrideredirect(True)

        # to have a border
        self.root.configure(background='#336699')

        mainframe = ttk.Frame(self.root)
        mainframe.pack(fill=BOTH,expand=True, padx=1, pady=1)

        # Décommenter pour avoir un titre
        if toggle(configfile,"title"):
            label = ttk.Label(mainframe,text=appname, font=("Droid Sans", 32))
            label.pack()

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

        self.make_tabs()
        self.center()
        self.root.mainloop()

    def make_tabs(self):
        for s in self.config.keys():
            self.make_tab(s)
        self.root.update_idletasks()
        self.root.geometry("{}x{}".format(
            self.root.winfo_reqwidth() , self.root.winfo_reqheight()))

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


        
