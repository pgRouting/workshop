#!/bin/bash
# ------------------------------------------------------------------------------
# pgRouting Scripts
# Copyright(c) pgRouting Contributors
#
# Initially create POT files (probably not necessary)
# ------------------------------------------------------------------------------

ROOT=$(git rev-parse --show-toplevel)
CONFIG="docs/source"
DOCDIR="locale"
LANGUAGES="en de es ja fr"
MINPERCENT=100

echo "CONFIGURATION"
echo ROOT ${ROOT}
echo DOCDIR ${DOCDIR}
echo LANGUAGES ${LANGUAGES}


