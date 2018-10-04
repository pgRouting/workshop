#!/bin/bash
# ------------------------------------------------------------------------------
# pgRouting Scripts
# Copyright(c) pgRouting Contributors
#
# Initially create POT files (probably not necessary)
# ------------------------------------------------------------------------------

cd $(git rev-parse --show-toplevel)

echo "*************************************************************************"
echo "Create POT files"
echo "*************************************************************************"
sphinx-build -b gettext  $(git rev-parse --show-toplevel)/docs/source $(git rev-parse --show-toplevel)/locale/pot


echo "*************************************************************************"
echo "Configure resources"
echo "*************************************************************************"
sphinx-intl update-txconfig-resources --pot-dir locale/pot --transifex-project-name pgrouting-workshop

echo "*************************************************************************"
echo "tx push -s"
echo "*************************************************************************"
