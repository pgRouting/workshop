# pgRouting Workshop
## Requirements

* python

## Working virtual environment

  ``` 
  python3 -m venv py-env
  source py-env/bin/activate
  pip install -r REQUIREMENTS.txt
  ```
* If you are using Python 3, then you should already have the venv module from the standard library installed. If you don't have it then do:

  ``` sudo apt-get install python3-venv ```

## Build

### Build the workshop:

```bash
cd docs
make html
```
### Building PDF

Install prerequisite:
```bash
sudo apt-get install texlive-latex-extra
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
* [Paragon Corporation](https://www.paragoncorporation.com)
