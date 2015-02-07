def _set_path():
    import os

    extra_paths = [
        '/usr/local/bin'
    ]

    paths = os.environ.get('PATH', '').split(os.pathsep)

    path_string = os.pathsep.join(
        paths + [extra_path for extra_path in extra_paths if extra_path not in paths]
    )

    os.environ['PATH'] = path_string

_set_path()

del _set_path