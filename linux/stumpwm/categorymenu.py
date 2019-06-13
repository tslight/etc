#!/usr/bin/env python

import os
import sys
import glob
import re
import fnmatch
import xdg.DesktopEntry as dentry
import xdg.Exceptions as exc
import xdg.BaseDirectory as bd
from operator import attrgetter

# the following line gets changed by the Makefile. If it is set to
# 'not_set' it looks in the currect directory tree for the .directory
# files. If it is actually set to something else, it looks under there
# for them, where they should be if this was installed properly


class App:
    '''
    A class to keep individual app details in.
    '''

    def __init__(self, name, command, path):
        self.name = name
        self.command = command
        self.path = path

    def __repr__(self):
        return repr((self.name, self.command,
                     self.path))


class MenuEntry:
    '''
    A class for each menu entry. Includes the class category and app details
    from the App class.
    '''

    def __init__(self, category, app):
        self.category = category
        self.app = app

    def __repr__(self):
        return repr((self.category, self.app.name,
                     self.app.command, self.app.path))


class MenuCategory:
    '''
    A class for each menu category. Keeps the category name and the list of
    apps that go in that category.
    '''

    def __init__(self, category, applist):
        self.category = category
        self.applist = applist


def get_categories():
    desktop_dir = '/usr/share/desktop-directories/'
    if not os.path.isdir(desktop_dir):
        sys.exit('ERROR: Could not find {}'.format(desktop_dir))
    menutype = 'lxde'
    directories = glob.glob(os.path.join(desktop_dir, menutype + "*"))
    regex = '.*' + menutype + '\-(.+?)\.directory'
    categories = [re.search(regex, d).group(1) for d in directories]
    category_names = []

    for c in categories:
        de = dentry.DesktopEntry(filename=desktop_dir +
                                 '{}-{}.directory'.format(menutype, c))
        category = de.getName().encode('utf-8')
        category_name = category.decode()
        category_names.append(category_name)

    return set(sorted(category_names))


def clean_up_categories(app_categories):
    categories = get_categories()
    for candidate in app_categories:
        name = candidate.decode()
        if name in categories and candidate != 'Other':
            return candidate
    return app_categories[0]


def remove_command_keys(command, desktopfile):
    # some KDE apps have this "-caption %c" in a few variations. %c is "The
    # translated name of the application as listed in the appropriate Name key
    # in the desktop entry" according to freedesktop. All apps launch without a
    # problem without it as far as I can tell, so it's better to remove it than
    # have to deal with extra sets of nested quotes which behave differently in
    # each WM. This is not 100% failure-proof. There might be other variations
    # of this out there, but we can't account for every single one. If someone
    # finds one another one, I can always add it later.
    command = command.replace('-caption "%c"', '')
    command = command.replace("-caption '%c'", '')
    command = command.replace('-caption %c', '')
    # replace the %k key. This is what freedesktop says about it: "The
    # location of the desktop file as either a URI (if for example gotten from
    # the vfolder system) or a local filename or empty if no location is
    # known."
    command = command.replace('"%k"', desktopfile)
    command = command.replace("'%k'", desktopfile)
    command = command.replace('%k', desktopfile)
    # removing any remaining keys from the command. That can potentially remove
    # any other trailing options after the keys,
    command = command.partition(' %')[0]
    return command


def get_entry_info(desktopfile):
    de = dentry.DesktopEntry(filename=desktopfile)
    # skip processing the rest of the desktop entry if the item is to not be
    # displayed anyway
    only = de.getOnlyShowIn()
    hidden = de.getHidden()
    nodisplay = de.getNoDisplay()
    if (only != []) or hidden or nodisplay:
        return None

    name = de.getName().encode('utf-8')
    command = de.getExec()
    command = remove_command_keys(command, desktopfile)

    terminal_app = os.getenv("XDGMENUMAKERTERM")
    if not terminal_app:
        if (os.path.exists('/etc/alternatives/x-terminal-emulator')
                and os.path.exists('/usr/bin/x-terminal-emulator')):
            terminal_app = '/usr/bin/x-terminal-emulator'
        else:
            terminal_app = 'xterm'

    terminal = de.getTerminal()
    if terminal:
        command = '{term} -e {cmd}'.format(term=terminal_app, cmd=command)

    path = de.getPath()
    if not path:
        path = None

    categories = de.getCategories()
    category = clean_up_categories(categories)

    app = App(name, command, path)
    return MenuEntry(category, app)


def sortedcategories(applist):
    categories = []
    for e in applist:
        categories.append(e.category)
    categories = set(sorted(categories))
    return categories


def desktopfilelist():
    # if this env variable is set to 1, then only read .desktop files from the
    # tests directory, not systemwide. This gives a standard set of .desktop
    # files to compare against for testing.
    testing = os.getenv('XDGMENUMAKER_TEST')
    if testing == "1":
        dirs = ['../tests']
    else:
        dirs = []
        # some directories are mentioned twice in bd.xdg_data_dirs, once
        # with and once without a trailing /
        for i in bd.xdg_data_dirs:
            i = i.rstrip('/')
            if i not in dirs:
                dirs.append(i)
    filelist = []
    df_temp = []
    for d in dirs:
        xdgdir = '{}/applications'.format(d)
        if os.path.isdir(xdgdir):
            for root, dirnames, filenames in os.walk(xdgdir):
                for i in fnmatch.filter(filenames, '*.desktop'):
                    # for duplicate .desktop files that exist in more
                    # than one locations, only keep the first occurence.
                    # That one should have precedence anyway (e.g.
                    # ~/.local/share/applications has precedence over
                    # /usr/share/applications
                    if i not in df_temp:
                        df_temp.append(i)
                        filelist.append(os.path.join(root, i))
    return filelist


def menu():
    applist = []
    for desktopfile in desktopfilelist():
        try:
            entry = get_entry_info(desktopfile)
            if entry is not None:
                applist.append(entry)
        except exc.ParsingError:
            pass

    sortedapplist = sorted(applist, key=attrgetter('category', 'app.name'))

    menu = []
    for c in sortedcategories(applist):
        appsincategory = []
        for i in sortedapplist:
            if i.category == c:
                appsincategory.append(i.app)
        menu_category = MenuCategory(c, appsincategory)
        menu.append(menu_category)
    return menu


def main():
    print('\'(')
    for menu_category in menu():
        category = menu_category.category
        cat_name = category.decode()
        print('("{}"'.format(cat_name))
        for app in menu_category.applist:
            name = app.name.decode()
            command = app.command
            print('("{}" "{}")'.format(name, command))
        print(')')
    print(')')


if __name__ == "__main__":
    main()
