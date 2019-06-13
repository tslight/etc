#!/usr/bin/env python

import os
import fnmatch
import xdg.DesktopEntry as dentry
import xdg.Exceptions as exc
import xdg.BaseDirectory as bd


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
    command = de.getExec()
    command = remove_command_keys(command, desktopfile)

    if (os.path.exists('/usr/bin/x-terminal-emulator')):
        terminal_app = '/usr/bin/x-terminal-emulator'
    elif (os.path.exists('/usr/bin/stterm')):
        terminal_app = 'usr/bin/stterm'
    elif (os.path.exists('/usr/bin/urxvt')):
        terminal_app = '/usr/bin/urxvt'
    elif (os.path.exists('/usr/bin/uxterm')):
        terminal_app = '/usr/bin/uxterm'
    else:
        terminal_app = 'xterm'

    terminal = de.getTerminal()
    if terminal:
        command = '{} -e {}'.format(terminal_app, command)

    return name, command


def get_desktop_files():
    # some directories are mentioned twice in bd.xdg_data_dirs, once
    # with and once without a trailing /
    dirs = set([d.rstrip('/') for d in bd.xdg_data_dirs])
    filelist = []
    df_temp = []
    for d in dirs:
        xdgdir = '{}/applications'.format(d)
        if os.path.isdir(xdgdir):
            for root, dirnames, filenames in os.walk(xdgdir):
                for i in fnmatch.filter(filenames, '*.desktop'):
                    # for duplicate .desktop files that exist in more
                    # than one locations, only keep the first occurrence.
                    if i not in df_temp:
                        df_temp.append(i)
                        filelist.append(os.path.join(root, i))
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
        name, command = app
        print('("{}" "{}")'.format(name, command))
    print(')')


if __name__ == "__main__":
    main()
