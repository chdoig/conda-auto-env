# conda-auto-env

Automatically activate a conda environment when entering a folder with an environment.yml file.

If the environment doesn't exist, conda-auto-env creates it and activates it for you.

This functionality was inspired by [conda auto activate](https://github.com/sotte/conda_auto_activate), [virtualenv auto activate](https://gist.github.com/garyjohnson/394c58e22a2adfa103e2) and [autoenv](https://github.com/kennethreitz/autoenv).

## Install

To install add this line to your .bashrc or .bash-profile:

       source /path/to/conda_auto_env.sh

### Remote environments

Alternatively, if you would also like to have support remote anaconda.org environments. Change those instructions to ``source /path/to/conda_auto_env_remote.sh``. To specify a remote environment create an ``environment-remote.yml`` file with the name and channel of your environment:

```yaml
name: pyladies-bokeh
channel: chdoig
```
