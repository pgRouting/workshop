#!/bin/bash
# ------------------------------------------------------------------------------
# pgRouting Scripts
# Copyright(c) pgRouting Contributors
#
# Initially create POT files (probably not necessary)
# ------------------------------------------------------------------------------

ROOT=$(pwd)
CONFIG="."
DOCDIR="i18n"

echo "*************************************************************************"
echo "Create POT files"
echo "*************************************************************************"
sphinx-build -b gettext -a -E -c "${CONFIG}" ${ROOT} "${DOCDIR}/pot"
