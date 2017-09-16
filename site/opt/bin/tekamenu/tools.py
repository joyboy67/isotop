#!/usr/bin/env python
# -*- coding:Utf-8 -*- 

import sys
import os
from collections import OrderedDict
from time import time
if sys.version_info >= (3, 0):
    import configparser
else:
    import ConfigParser as configparser
from subprocess import Popen
from tekamenu.const import *

def help():
    print("usage : ")
    print("tkmenu -c config_file")
    print("If no config file is specified, ~/.tkmenu.conf is used and generated")
    sys.exit()

def get_config(cf):
    try:
        config = configparser.ConfigParser()
        config.read(cf)
        return config
    except:
        print("Unable to read configuration file")
        sys.exit(1)

def save_config(config, cf):
    with open(cf, 'w') as configfile:
        config.write(configfile)

def read_config(config):
    """Parse config (configparser) and return a dict of sections : 
    {'section_name' : [list of launchers] }

    Each launcher is : 
    launcher = ['name','cmd','icon']

    In the end : 
    config = {'section_name' [ [name, cmd, icon], [name, cmd, icon]] ... }
    """

    cf = OrderedDict()
    for s in config.sections():
        cf[s] = [ [i.strip() for i in infos.split(',') ] 
                        for option, infos in config.items(s)
                        if option != "closeafterrun" \
                                and option != "theme" \
                                and option != "titlebar" \
                                and option != "title" ]
    return cf



def toggle_closeafter(config_file):
    config = get_config(config_file)
    if config.has_option("DEFAULT","closeafterrun"):
        closeafterrun =  config.getboolean("DEFAULT","closeafterrun")

        config.set("DEFAULT","closeafterrun", str(not closeafterrun))
        save_config(config, config_file)

def toggle(config_file,option):
    """return True if  option is set"""
    config = get_config(config_file)
    if config.has_option("DEFAULT",option):
        return config.getboolean("DEFAULT",option)



def add_recent(name, cmd, icon, cf):
    # add new entry in recents
    conf = get_config(cf)
    if len(conf['Recent']) == max_recents:
        # find oldest entry
        oldest = str(min(float(entry) for entry in conf.options('Recent') if is_number(entry)))
        # delete oldest entry
        conf.remove_option('Recent', oldest)

    # add recent entry
    # this is all the launcher names :[ l[1].split(',')[0].strip() for l in conf.items('Recent') ]
    # to avoid doubles
    if name not in [ l[1].split(',')[0].strip() for l in conf.items('Recent') ]:
        conf['Recent'][str(time())] = "{},{},{}".format(name, cmd, icon)
    save_config(conf, cf)


def which(program):
    #https://stackoverflow.com/questions/377017/test-if-executable-exists-in-python/377028#377028
    def is_exe(fpath):
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return False

def try_to_run(app_list):
    """
    return the application in app_list if avaiable
    return False if no app found
    """
    for app in app_list:
        APP = which(app)
        if APP:
            return APP
    return False


def edit_config(cf):
    EDITOR = try_to_run(["geany","gedit","scite","kate", "mousepad", "leafpad"])
    if EDITOR:
        Popen([EDITOR, cf])


def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

