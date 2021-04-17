#!/usr/bin/python

import sys
import subprocess
import urllib.parse
import os

class PinEntryRofi:

    _out_fd = None
    _in_fd = None

    _running = True
    _ok = True

    _prompt = None
    _desc = None
    _prompt_error = None
    
    def __init__(self, out_fd, in_fd, display):
        self._prompt = ''
        self._desc = ''

        self._out_fd = out_fd
        self._in_fd = in_fd
        
        self.env = self._create_environment()
        self.env['DISPLAY'] = display

    def _create_environment(self):
        env = {}

        result = subprocess.run(
            ['systemctl', '--user', 'show-environment'], 
            capture_output=True,
            encoding='utf-8'
        )

        for env_line in result.stdout.split('\n'):
            if not env_line:
                continue

            key, value = env_line.split('=', 1)
            env[key] = value

        return env

    def _send(self, cmd):
        self._out_fd.write(cmd + "\n")
        self._out_fd.flush()

    def _read(self):
        line = self._in_fd.readline()

        return line

    def _close(self):
        self._running = False

    def handle_setprompt(self, prompt):
        self._prompt = prompt.replace(':', '').strip()

    def handle_seterror(self, error):
        self._prompt_error = error

    def handle_setdesc(self, desc):
        self._desc = urllib.parse.unquote(desc).replace('<', '&lt;').strip()

    def handle_getpin(self, *args):
        if self._prompt_error:
            error = '<span foreground="red">%s</span>\n' % self._prompt_error
        else:
            error = ''

        result = subprocess.run(
            [
                'rofi', 
                '-p', self._prompt, 
                '-mesg', error + self._desc,
                '-dmenu',
                '-input', '/dev/null',
                '-password',
                '-lines', '0',
                '-disable-history',
                '-markup-rows'

            ],
            capture_output=True, 
            encoding='utf-8',
            env=self.env
        )
        
        if result.returncode == 0:
            self._send('D %s' % result.stdout)
        else:
            self._send('ERR 83886179 Operation cancelled <rofi>')
            self._ok = False
            self._close()

    def handle_bye(self, *args):
        self._close()

    def run(self):
        self._send('OK Please go ahead')

        while self._running:
            args = self._read().split(' ', 1)

            cmd = args[0].strip()
            args = args[1:]

            method = getattr(self, 'handle_%s' % cmd.lower(), None)

            if method:
                method(*args)

            if self._ok:
                self._send('OK')


if len(sys.argv) > 2:
    # If we're missing display argument then we have very little to do anyway.
    pinentry = PinEntryRofi(sys.stdout, sys.stdin, sys.argv[2])

    pinentry.run()
