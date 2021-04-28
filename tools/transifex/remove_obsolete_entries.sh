#!/bin/bash
# ------------------------------------------------------------------------------
# pgRouting Scripts
# Copyright(c) pgRouting Contributors
#
# Remove all the obsolete entries, i.e. lines starting with #~ from .po files
# ------------------------------------------------------------------------------

# For all the chapter files
for file in locale/en/LC_MESSAGES/chapters/*.po; do
    if grep -q '#~' $file; then
        perl -pi -0777 -e 's/#~.*//s' $file
        git add $file
    fi
done

# For the index.po file
file=locale/en/LC_MESSAGES/index.po
if grep -q '#~' $file; then
    perl -pi -0777 -e 's/#~.*//s' $file
    git add $file
fi
