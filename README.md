# Intel Aero Documentation

This repository contains the source files for Intel Aero documentation.
In order to use it you need to have mkdocs and its themes/extensions
installed.

There's a Makefile that's mostly a wrapper around mkdocs with some
extra functionality related to this site.

## Setup and build

In order to build the documentation we need only python from the host
system. Additional dependencies are installed via pip. The preferred
method is to install them with:

```bash
make setup
```

This will install all required packages with `pip install --user --upgrade`

## Contributing

To change the documentation and visualize what's being changed, start
mkdocs's webserver:

```bash
# this is just a wrapper to "mkdocs serve"
make serve
```

## Deploying

Set DEST variable and call `make deploy` or `make publish`:

```bash
export DEST=remote-server:/var/www/intel-aero-docs
make deploy
```

Rsync needs to be installed to synchronize the site built locally with
the remote one. If DEST isn't set, it will install to `/tmp/intel-aero-docs`
