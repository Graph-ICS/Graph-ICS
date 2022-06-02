# Building the Graph-ICS Documentation

**NOTE: To this date the documentation is still empty!**

## Doxygen Sphinx Breathe pipeline

The Documentation consists of three steps.

1. Extracting API Documentation from the source code using [Doxygen](https://www.doxygen.nl/index.html).
2. [Sphinx](https://www.sphinx-doc.org/en/master/) (hand-written) Documentation configuration.
3. Using the Sphinx extension [Breathe](https://breathe.readthedocs.io/en/latest/) to get the Doxygen output inside Sphinx.

## How to Build the documentation

### Dependencies

- [Doxygen](https://www.doxygen.nl/download.html)
- [Python](https://www.python.org/downloads/) (greater 3.6)
- You can check your python installation using

```sh
python --version
```

- Sphinx

```sh
pip install sphinx
```

- Sphinx ReadTheDocs Theme

```sh
pip install sphinx-rtd-theme
```

- Breathe

```sh
pip install breathe
```

**Note:** On Windows make sure that your python scripts folder is added to PATH (e.g. C:\Users\graphics\AppData\Roaming\Python\Python39\Scripts)

Now you just need to enable the CMake cache variable GRAPHICS_BUILD_DOCUMENTATION using the CMake GUI or editing the CMakeCache.txt in the build directory.
