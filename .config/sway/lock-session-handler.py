#!/bin/env python

import os
import sys
import argparse
import subprocess
from functools import partial
import dbus
import dbus.mainloop.glib
from gi.repository import GLib

def run(cmd):
    subprocess.run(cmd, shell=True)

def get_login_session(session_id):
    system_bus = dbus.SystemBus()

    login_manager = dbus.Interface(
        system_bus.get_object(
            'org.freedesktop.login1',
            '/org/freedesktop/login1'
        ),
        'org.freedesktop.login1.Manager'
    )

    session_path = login_manager.GetSession(session_id)

    session = system_bus.get_object(
        'org.freedesktop.login1',
        session_path
    )

    return session

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Runs commands on lock and unlock signals'
    )
    parser.add_argument(
        'lock',
        type=str,
        nargs='?',
        help='Command to run on lock signal'
    )
    parser.add_argument(
        'unlock',
        type=str,
        nargs='?',
        help='Command to run on unlock signal'
    )
    parser.add_argument(
        '--session-id', 
        type=int,
        dest='session_id',
        nargs='?',
        help='Optional session id, defaults to $XDG_SESSION_ID'
    )

    args = parser.parse_args()

    if not args.lock and not args.unlock:
        parser.error('Nothing to bind to signals')


    if args.session_id:
        session_id = args.session_id
    else:
        session_id = os.environ.get('XDG_SESSION_ID', None)

    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

    login_session = get_login_session(session_id)

    if not login_session:
        parser.error('Invalid session-id')

    if args.lock:
        login_session.connect_to_signal('Lock', partial(run, args.lock))

    if args.unlock:
        login_session.connect_to_signal('Unlock', partial(run, args.unlock))

    try:
        GLib.MainLoop().run()
    except:
        sys.exit(0)
