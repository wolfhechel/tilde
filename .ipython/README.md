# IPython README

This is the IPython directory.

For more information on configuring IPython, do:

ipython -h

or to create an empty default profile, populated with default config files:

ipython profile create

# Installing IPython on OS X

Requires [homebrew](http://brew.sh/)

First make sure you're using a homebrew provided python environment:
```
which python pip easy_install

# Should output
# /usr/local/bin/python
# /usr/local/bin/pip
# /usr/local/bin/easy_install
```

brew install zeromq --universal
brew install freetype libpng

pip install 'ipython[all]'
```

Additional requirements for dot extension

```
brew install graphviz

pip install pydot
```
