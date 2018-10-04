#!/bin/bash
# ------------------------------------------------------------------------------
# pgRouting Scripts
# Copyright(c) pgRouting Contributors
#
# Download translations and build localized documentation
# ------------------------------------------------------------------------------

cd $(git rev-parse --show-toplevel)

source tools/transifex/configuration.sh

echo "CONFIGURATION"
echo ROOT ${ROOT}
echo DOCDIR ${DOCDIR}
echo LANGUAGES ${LANGUAGES}
echo MINPERCENT ${MINPERCENT}
SOURCE=docs/source

if [ $1 ]; then
	LANGUAGES=$1
fi

echo "*************************************************************************"
echo "Build HTML documentation"
echo "*************************************************************************"
for i in ${LANGUAGES}; do
	sphinx-build -b html -a -E -v -D language="${i}" -c "${SOURCE}" ${SOURCE} _build/doc/html/${i}

done
exit 0

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

