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

echo "usage:  bash tools/transifex/download_translation.sh [lang] [%] [resource]"

if [ $1 ]; then
	LANGUAGES=$1
fi

if [ $2 ]; then
	MINPERCENT="$2"
fi

if [ $3 ]; then
	RESOURCE='-r'
fi

echo LANGUAGES ${LANGUAGES}
echo MINPERCENT ${MINPERCENT}

echo "*************************************************************************"
echo "Download translations from Transifex (>${MINPERCENT}% translated)"
echo "*************************************************************************"
for i in ${LANGUAGES}; do
  echo "*************************************************************************"
  echo "Downloading ${i}  (>${MINPERCENT}% translated)"
  echo "*************************************************************************"
  sleep 3
  echo "tx pull $RESOURCE $3 -l "${i}" -f --minimum-perc=${MINPERCENT}"
	tx pull $RESOURCE $3 -l "${i}" -f --minimum-perc=${MINPERCENT}
done

