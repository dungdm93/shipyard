NOTE
====

## 1. Commands Reference
```bash
pip list
conda list
jupyter nbextension list
jupyter labextension list
jupyter serverextension list
```

## 2. Configuration
## 2.1 pip
```bash
pip config [--site] set install.user yes
```

References:
* [pip config](https://pip.pypa.io/en/stable/reference/pip_config/)
* [config file](https://pip.pypa.io/en/stable/user_guide/#config-file)

## 2.2 conda
```bash
conda config --show
conda config --describe

conda config --add channels conda-forge [--system | --env]
conda config --remove channels conda-forge [--system | --env]

conda config --set use_local True
```

## 2.3 Jupyter
Generate configs via:
```bash
jupyter notebook --generate-config
jupyter lab --generate-config
jupyter server --generate-config
```

* [The IPython directory](https://ipython.readthedocs.io/en/stable/config/intro.html#systemwide-configuration)
* [Common Directories and File Locations](https://jupyter.readthedocs.io/en/latest/use/jupyter-directories.html)
