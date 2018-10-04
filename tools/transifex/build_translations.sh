#!/bin/bash
# ------------------------------------------------------------------------------
# pgRouting Scripts
# Copyright(c) pgRouting Contributors
#
# Download translations and build localized documentation
# ------------------------------------------------------------------------------

ROOT=$(pwd)
CONFIG="."
DOCDIR="./locale"

LANGUAGES='de es ja fr'

if [ $1 ]; then
	LANGUAGES=$1
fi

echo "*************************************************************************"
echo "Download translations from Transifex (>1% translated)"
echo "*************************************************************************"
for i in ${LANGUAGES}; do
	tx pull -l "${i}" -f --minimum-perc=1
done

echo "*************************************************************************"
echo "Build PO/MO files"
echo "*************************************************************************"
for i in ${LANGUAGES}; do
	sphinx-intl build -l "${i}" -c "${CONFIG}/conf.py" -p "${DOCDIR}/pot" -d "${DOCDIR}"
done

echo "*************************************************************************"
echo "Build HTML documentation"
echo "*************************************************************************"
for i in ${LANGUAGES}; do
	sphinx-build -b html -a -E -D language="${i}" -c "${CONFIG}" ${ROOT} _build/doc/html/${i}
done

echo "*************************************************************************"
echo "Build LATEX documentation"
echo "*************************************************************************"
for i in ${LANGUAGES}; do
	DESTINATION="_build/doc/latex/${i}"
	sphinx-build -b latex -a -E -D language="${i}" -c "${CONFIG}" ${ROOT} ${DESTINATION}
	cd "${DESTINATION}"
	if [ "${i}" = "ja" ]; then
		sed -i "" -e "s/\,dvipdfm\]/\,dvipdfmx\]/g" pgRoutingWorkshop.tex;
		nkf -W -e --overwrite pgRoutingWorkshop.tex;
		platex -interaction=batchmode -kanji=euc -shell-escape pgRoutingWorkshop.tex;
		platex -interaction=batchmode -kanji=euc -shell-escape pgRoutingWorkshop.tex;
		platex -interaction=batchmode -kanji=euc -shell-escape pgRoutingWorkshop.tex;
		dvipdfmx pgRoutingWorkshop.dvi;
	else
		texi2pdf --quiet pgRoutingWorkshop.tex;
		texi2pdf --quiet pgRoutingWorkshop.tex;
		texi2pdf --quiet pgRoutingWorkshop.tex;
	fi
	cd "${ROOT}"
done

