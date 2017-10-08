# pgRouting Workshop

## Install:

For building HTML documentation you need the following packages:

```
sudo apt update
sudo apt install cmake python-pip
sudo pip install -r REQUIREMENTS.txt
```

For building the documentation as PDF the following packages need to be installed:

```
sudo apt install texlive-latex-extra
```

For translations (needs to be confirmed):

```
sudo apt install texinfo
```

## Build:

To build the workshop documentation with all further steps, go into `docs` directory and run::

```
cd docs
make html
```

To build the documentation as PDF:

```
cd docs
make latexpdf
cd _build/latex/
pdflatex -interaction=nonstopmode pgRoutingWorkshop.tex
```


## License

This workshop is licensed under a [Creative Commons Attribution-Share Alike 3.0 License](http://creativecommons.org/licenses/by-sa/3.0/).

## Supported by

* [Georepublic](https://georepublic.info)

<p>
	<a href="http://flattr.com/thing/977418/pgRouting-Workshop" target="_blank">
		<img src="http://api.flattr.com/button/flattr-badge-large.png" alt="Flattr this" title="Flattr this" border="0" />
	</a>
</p>
