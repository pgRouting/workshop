#!/bin/bash
# ------------------------------------------------------------------------------
# pgRouting Scripts
# Copyright(c) pgRouting Contributors
#
# Initially create POT files (probably not necessary)
# ------------------------------------------------------------------------------

cd $(git rev-parse --show-toplevel)/docs

echo "*************************************************************************"
echo "Create POT files"
echo "*************************************************************************"
make gettext BUILDDIR=$(git rev-parse --show-toplevel)/locale/pot
cd ..

echo "*************************************************************************"
echo "Configure resources"
echo "*************************************************************************"
sphinx-intl update-txconfig-resources --pot-dir locale/pot --transifex-project-name pgrouting-workshop

echo "*************************************************************************"
echo "tx push -s"
echo "*************************************************************************"
