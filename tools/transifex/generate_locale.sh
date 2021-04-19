#!/bin/bash
# ------------------------------------------------------------------------------
# pgRouting Scripts
# Copyright(c) pgRouting Contributors
#
# Initially create POT files (probably not necessary)
# ------------------------------------------------------------------------------

cd "$(git rev-parse --show-toplevel)" || exit

mkdir -p build || exit
cd build || exit
cmake -D LOCALE=ON ..
make locale
cd ..

echo "*************************************************************************"
echo "Configure resources"
echo "*************************************************************************"
sphinx-intl --config build/docs/conf.py update-txconfig-resources --pot-dir locale/pot --transifex-project-name pgrouting-workshop

echo "*************************************************************************"
echo "Ready to push to transifex ise command:"
echo "tx push -s"
echo "*************************************************************************"
