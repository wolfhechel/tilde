"""
`%hierarchy` and `%%dot` magics for IPython
===========================================

This extension provides two magics.

First magic is ``%hierarchy``.  This magic command draws hierarchy of
given class or the class of given instance.  For example, the
following shows class hierarchy of currently running IPython shell.::

    %hierarchy get_ipython()


Second magic is ``%%dot``.  You can write graphiz dot language in a
cell using this magic.  Example::

    %%dot -- -Kfdp
    digraph G {
        a->b; b->c; c->d; d->b; d->a;
    }
"""
from IPython.core.magic import Magics, magics_class, line_cell_magic
from IPython.core.display import display_svg


def run_dot(code):
    # mostly copied from sphinx.ext.graphviz.render_dot
    import os
    from subprocess import Popen, PIPE
    from sphinx.util.osutil import EPIPE, EINVAL

    dot_args = ['dot', '-T', 'svg']
    if os.name == 'nt':
        # Avoid opening shell window.
        # * https://github.com/tkf/ipython-hierarchymagic/issues/1
        # * http://stackoverflow.com/a/2935727/727827
        p = Popen(dot_args, stdout=PIPE, stdin=PIPE, stderr=PIPE,
                  creationflags=0x08000000)
    else:
        p = Popen(dot_args, stdout=PIPE, stdin=PIPE, stderr=PIPE)
    wentwrong = False
    try:
        # Graphviz may close standard input when an error occurs,
        # resulting in a broken pipe on communicate()
        stdout, stderr = p.communicate(code.encode('utf-8'))
    except (OSError, IOError) as err:
        if err.errno != EPIPE:
            raise
        wentwrong = True
    except IOError as err:
        if err.errno != EINVAL:
            raise
        wentwrong = True
    if wentwrong:
        # in this case, read the standard output and standard error streams
        # directly, to get the error message(s)
        stdout, stderr = p.stdout.read(), p.stderr.read()
        p.wait()
    if p.returncode != 0:
        raise RuntimeError('dot exited with error:\n[stderr]\n{0}'
                           .format(stderr.decode('utf-8')))
    return stdout


@magics_class
class GraphvizMagic(Magics):

    @line_cell_magic
    def dot(self, line, cell=None):
        """Draw a figure using Graphviz dot command."""

        if cell is None:
            s = line
        else:
            s = line + '\n' + cell

        data = run_dot(s)

        if data:
            display_svg(data, raw=True)


def load_ipython_extension(ip):
    """Load the extension in IPython."""
    global _loaded

    if not _loaded:
        ip.register_magics(GraphvizMagic)
        _loaded = True

_loaded = False
