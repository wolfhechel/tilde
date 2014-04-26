import os, sys

sysname, nodename, release, version, machine = os.uname()

try:
    import readline
except ImportError:
    print 'Module readline not avaliable.'
else:
    import rlcompleter

    if 'libedit' in readline.__doc__:
        readline.parse_and_bind('bind ^I rl_complete')
    else:
        readline.parse_and_bind('tab: complete')

__python_version__ = 'python{0.major}.{0.minor}'.format(sys.version_info)

for local_path in [x % __python_version__ for x in (
    '/usr/local/lib/%s', '/usr/local/lib/%s/site-packages')]:

    if local_path not in sys.path:
        sys.path.append(local_path)
