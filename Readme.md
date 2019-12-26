# pgRouting Workshop

## Install

For building HTML documentation you need the following packages:

```bash
sudo apt update
sudo apt install cmake python-pip
sudo pip install wheel
sudo pip install -r REQUIREMENTS.txt --upgrade
```

For building the documentation as PDF the following packages need to be installed:

```bash
sudo apt install texlive-latex-extra
```

For translations (needs to be confirmed):

```bash
sudo apt install texinfo
```

## Build

To build the workshop documentation with all further steps, go into `docs` directory and run::

```bash
cd docs
make html
```

To build the documentation as PDF:

```bash
cd docs
make latexpdf
cd _build/latex/
pdflatex -interaction=nonstopmode pgRoutingWorkshop.tex
```

## License

This workshop is licensed under a [Creative Commons Attribution-Share Alike 3.0 License](http://creativecommons.org/licenses/by-sa/3.0/).

## Supported by

* [Georepublic](https://georepublic.info)
* [iMaptools](http://imaptools.com)
