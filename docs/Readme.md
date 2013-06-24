# Workshop documentation

# About

The docs directory contains the workshop documentation.

## Install:

```
sudo apt-get install python-sphinx texlive-full
```

## Build:

```
make html
make latex
cd _build/latex/
pdflatex -interaction=nonstopmode pgRoutingWorkshop.tex
```
