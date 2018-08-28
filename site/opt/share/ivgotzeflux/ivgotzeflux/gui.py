#!/usr/bin/env python
# -*- coding:Utf-8 -*- 


import sys
import os
if sys.version_info >= (3, 0):
    from tkinter import *
    from tkinter import ttk
    from tkinter import messagebox
    from tkinter import filedialog
else:
    from Tkinter import *
    import ttk
    import tkMessageBox as messagebox
    import tkFileDialog as filedialog
from PIL import Image, ImageTk

from ivgotzeflux.menuparser import *
from ivgotzeflux.const import *

def Popup(txt):
    messagebox.showinfo(message = txt)

class FluxConf():
    def __init__(self, configfile):
        self.icons_reflist = []
        self.configfile = configfile
        self.menu = read_menu(configfile)

        # main window
        self.root = Tk()

        # style
        #('clam', 'alt', 'default', 'classic')
        style = ttk.Style()
        style.theme_use("clam")

        mainframe = ttk.Frame(self.root)
        mainframe.grid(padx=(10,10), pady=(10,10))
        mainframe.rowconfigure(0, weight=1)
        mainframe.columnconfigure(0, weight=1)

        # create a toolbar
        toolbar = ttk.Frame(mainframe)
        col = 0

        b = ttk.Button(toolbar, text="+", command=self.add_new_entry)
        b.grid(column=col, row=0)

        col += 1
        b = ttk.Button(toolbar, text="-", command=self.remove_entry)
        b.grid(column=col, row=0)

        col += 1
        b = ttk.Button(toolbar, text="↑", command=self.move_up)
        b.grid(column=col, row=0)

        col += 1
        b = ttk.Button(toolbar, text="↓", command=self.move_down)
        b.grid(column=col, row=0)

        col += 1
        b = ttk.Button(toolbar, text="Restaurer le menu", command=self.restore_menu)
        b.grid(column=col, row=0)

        toolbar.grid(column=0, row=0, sticky=N+E+S+W)

        # to the bottom
        toolbar = ttk.Frame(mainframe)
        b = ttk.Button(toolbar, text="Sauvegarder", command=self.save_the_current_config)
        b.grid(column=0, row=0)
        b = ttk.Button(toolbar, text="Aide", command=lambda: Popup(helptxt))
        b.grid(column=1, row=0)
        b = ttk.Button(toolbar, text="Quitter", command=self.stop)
        b.grid(column=2, row=0)

        toolbar.grid(column=0, row=2, sticky=N+E+S)

        panedwin = ttk.PanedWindow(mainframe,orient=VERTICAL)
        panedwin.grid(column=0, row=1, sticky=N+E+S+W)

        # the tree containing the whole menu
        self.tree = ttk.Treeview(panedwin)
        panedwin.add(self.tree)

        # Columns Names
        self.tree["columns"]=("label", "type", "cmd", "icon")
        self.tree.heading("#0", text="Icône")
        self.tree.heading("label", text="Label")
        self.tree.heading("type", text="Action")
        self.tree.heading("cmd", text="Commande")

        # Columns width
        self.tree.column("#0",width=50)
        self.tree.column("type",width=100)

        # hide icon column
        self.tree["displaycolumns"]=("label", "type", "cmd")

        self.tree.bind('<<TreeviewSelect>>', self.treeconfigure)
        self.tree.bind('<Double-1>', self.treeconfigure)
        self.tree.bind("<B1-Motion>",self.bMove, add='+')

        self.populate_tree()

        bottom = ttk.LabelFrame(panedwin, text="Configuration de l'élément sélectionné")
        panedwin.add(bottom)

        ## the configuration panel
        # labels
        llabel = ttk.Label(bottom,text="Label")
        alabel = ttk.Label(bottom,text="Action")
        clabel = ttk.Label(bottom,text="Commande")
        ilabel = ttk.Label(bottom,text="Icône")

        llabel.grid(column=0, row=0, sticky=W)
        alabel.grid(column=0, row=1, sticky=W)
        clabel.grid(column=0, row=2, sticky=W)
        ilabel.grid(column=0, row=3, sticky=W)

        
        # label entry
        self.lentry = self.add_entry(bottom)
        self.lentry.grid(column=1, row=0, sticky=W+E)

        # action menu
        self.avar = StringVar()
        self.avar.set(TYPEOPTIONS[1])
        self.avar.trace("w", lambda name, index, mode, sv=self.avar: self.value_modified(self.avar))
        self.amenu = ttk.OptionMenu(bottom, self.avar, *TYPEOPTIONS)
        self.amenu.grid(column=1, row=1, sticky=W+E)

        # command entry
        self.centry = self.add_entry(bottom)
        self.centry.grid(column=1, row=2, sticky=W+E)
        # command file selection
        cmdbtn = ttk.Button(bottom,text=">", command=self.set_cmd_path, width=1)
        cmdbtn.grid(column=2, row=2, sticky=W)

        # icon entry
        self.ientry = self.add_entry(bottom)
        self.ientry.grid(column=1, row=3, sticky=W+E)
        # icon file selection
        iconbtn = ttk.Button(bottom,text=">", command=self.set_icon_path, width=1)
        iconbtn.grid(column=2, row=3, sticky=W)

        self.root.mainloop()
    
    def add_entry(self,parent):
        sv = StringVar()
        sv.trace("w", lambda name, index, mode, sv=sv: self.value_modified(sv))
        return ttk.Entry(parent, textvariable=sv, width=35)

    def populate_tree(self):
        idx = 0
        ref = ""
        idxlist = [ref]
        for line in self.menu:
            type_, label, cmd, icon, iscomment = line

            if type_ == "submenu":
                self.add_to_tree(type_, label, cmd, icon, idx, ref)
                idxlist.append(idx)
                ref = idx
            elif type_ == "end" :
                if len(idxlist) > 1:
                    idxlist.pop()
                    ref = idxlist[-1]
            #elif type_ in ["encoding", "endencoding"]:
            #    continue
            else:
                if type_ == "separator" :
                    label = "---------"
                self.add_to_tree(type_, label, cmd, icon, idx, ref)
            idx += 1


    def add_to_tree(self, type_, label, cmd, icon, idx, ref = ""):
        if os.path.isfile(icon):
            image = Image.open(icon)
            iconpic = ImageTk.PhotoImage(image)
            self.icons_reflist.append(iconpic)

            self.tree.insert(ref , "end", idx,  image=iconpic, values=(label, type_, cmd, icon))

        else:
            self.tree.insert(ref , "end", idx, values=(label, type_, cmd, icon))

    def set_cmd_path(self):

        cmd = filedialog.askopenfilename(
                initialdir=os.path.expanduser('~'),
                parent=self.root,
                title="Choisir une commande")
        if len(cmd) > 0:
            if os.path.isfile(cmd):
                self.centry.delete(0, END)
                self.centry.insert(0,cmd)




    def set_icon_path(self):

        ft = [
        ("Image Files", ("*.jpg", "*.gif", "*.png", "*.xpm")),
        ("JPEG",'*.jpg'),
        ("XPM",'*.xpm'),
        ("PNG",'*.png'),
        ("GIF",'*.gif'),
        ('All','*')
        ]

        iconpath = filedialog.askopenfilename(defaultextension="*.png",
                filetypes=ft,
                initialdir=os.path.expanduser('~'),
                parent=self.root,
                title="Choisir une icône")
        if len(iconpath) > 0:
            if os.path.isfile(iconpath):
                self.ientry.delete(0, END)
                self.ientry.insert(0,iconpath)


    def add_new_entry(self):
        try:
            i = self.tree.selection()[0]
            iparent = self.tree.parent(i)
            n = self.tree.index(i)
            self.tree.insert(iparent , n, values=("Titre", "exec", "commande", "/chemin/vers/icone"))
        except:
            self.tree.insert("" , 0, values=("Titre", "exec", "commande", "/chemin/vers/icone"))

    def remove_entry(self):
        try:
            i = self.tree.selection()[0]
            self.tree.delete(i)
        except: pass

    def move_down(self):
        try:
            i = self.tree.selection()[0]
            iparent = self.tree.parent(i)
            n = self.tree.index(i)
            self.tree.move(i, iparent, n+1)
        except:pass

    def move_up(self):
        try:
            i = self.tree.selection()[0]
            iparent = self.tree.parent(i)
            n = self.tree.index(i)
            self.tree.move(i, iparent, n-1)
        except:pass

    def stop(self):
        self.root.destroy()

    def treeconfigure(self,event=None):
        i = self.tree.selection()[0]
        c = self.tree.item(i)
        label, type_, cmd, icon = c['values']

        self.tree.delete() #clean up
            
        # clean entries
        self.lentry.delete(0, END)
        self.centry.delete(0, END)
        self.ientry.delete(0, END)

        self.lentry.insert(0,label)
        self.avar.set(type_)
        self.centry.insert(0,cmd)
        self.ientry.insert(0,icon)


    def tree_to_config(self, childitem=False):
        theconfig = []
        if childitem:
            cl = childitem
        else:
            cl = self.tree.get_children()

        for child in cl:
            sub = self.tree.get_children(child)
            if len(sub) > 0:
                theconfig.append(self.tree.item(child)["values"])
                for subres in self.tree_to_config(sub):
                    theconfig.append(subres)
                theconfig.append(['','end','',''])
            else:
                theconfig.append(self.tree.item(child)["values"])


        return theconfig


    def save_the_current_config(self):
        conf = self.tree_to_config() #remember to add [end]
        conf.append(['','end','',''])
        save_menu(conf)

    def restore_menu(self):
        restore_menu()
        self.menu = read_menu(self.configfile)
        for i in self.tree.get_children():
            self.tree.delete(i)
        self.populate_tree()



    def value_modified(self,sv):
        try:
            i = self.tree.selection()[0]
            label = self.lentry.get()
            type_ = self.avar.get()
            cmd = self.centry.get()
            icon = self.ientry.get()

            if type_ == "submenu":
                cmd = ""
            elif type_ == "separator" or type_ == "nop":
                label = cmd = icon = ""

            self.tree.item(i, values=(label, type_, cmd, icon))
        except:
            print("Nothing selected")

    def bMove(self, event):
    # To move item in treeview
    # https://stackoverflow.com/questions/11570786/tkinter-treeview-drag-and-drop
        tv = event.widget
        moveto = tv.index(tv.identify_row(event.y))    
        for s in tv.selection():
            tv.move(s, '', moveto)



# vim: tabstop=4 expandtab shiftwidth=4 softtabstop=4

