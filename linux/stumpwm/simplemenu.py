#!/usr/bin/env python3

import os
import glob
import xdg.DesktopEntry as dentry
import xdg.Exceptions as exc
import xdg.BaseDirectory as bd


def remove_keys(cmd, desktopfile):
    '''
    Some KDE apps have this "-caption %c" in a few variations. %c is "The
    translated name of the application as listed in the appropriate Name key
    in the desktop entry" according to freedesktop.

    The location of the desktop file as either a URI (if for example gotten
    from the vfolder system) or a local filename or empty if no location is
    known.

    Removing any remaining keys and trailing options from the command.
    '''
    cmd = cmd.replace('-caption "%c"', '')
    cmd = cmd.replace("-caption '%c'", '')
    cmd = cmd.replace('-caption %c', '')
    cmd = cmd.replace('"%k"', desktopfile)
    cmd = cmd.replace("'%k'", desktopfile)
    cmd = cmd.replace('%k', desktopfile)
    cmd = cmd.partition(' %')[0]
    return cmd


def get_terminal():
    '''
    Dictionaries are insertion ordered as of 3.6+
    https://stackoverflow.com/a/39980744
    '''
    paths = {
        '/usr/bin/x-terminal-emulator': '-e',
        '/usr/bin/xfce4-terminal': '-x',
        '/usr/bin/gnome-terminal': '-x',
        '/usr/bin/mate-terminal': '-x',
        '/usr/bin/lxterminal': '-x',
        '/usr/bin/konsole': '-x',
        '/usr/bin/stterm': '-e',
        '/usr/bin/uxterm': '-e',
        '/usr/bin/urxvt': '-e',
        '/usr/bin/xterm': '-e',
    }
    for path, opt in paths.items():
        if os.path.exists(path):
            return path + ' ' + opt


def get_desktop_info(desktopfile):
    de = dentry.DesktopEntry(filename=desktopfile)

    # skip processing the entry if any of these attributes are set.
    only = de.getOnlyShowIn()
    hidden = de.getHidden()
    nodisplay = de.getNoDisplay()
    if (only != []) or hidden or nodisplay:
        return None

    name = de.getName().encode('utf-8')
    name = name.decode()
    cmd = de.getExec()
    cmd = remove_keys(cmd, desktopfile)

    terminal = get_terminal()
    run_in_terminal = de.getTerminal()
    if run_in_terminal:
        cmd = f'{terminal} {cmd}'

    return name, cmd


def get_desktop_files():
    # some directories are mentioned twice in bd.xdg_data_dirs, once
    # with and once without a trailing /
    dirs = set([d.rstrip('/') for d in bd.xdg_data_dirs])
    filelist = []

    for d in dirs:
        files = glob.glob(os.path.join(d, 'applications/*.desktop'))
        for f in files:
            filelist.append(f)

    return filelist


def menu():
    applist = []
    for desktopfile in get_desktop_files():
        try:
            entry = get_desktop_info(desktopfile)
            if entry is not None:
                applist.append(entry)
        except exc.ParsingError:
            pass

    # https://stackoverflow.com/a/10695161
    return sorted(applist, key=lambda x: x[0].lower())


def main():
    print('\'(')
    for app in menu():
        name, cmd = app
        print(f'("{name}" "{cmd}")')
    print(')')


if __name__ == "__main__":
    main()
