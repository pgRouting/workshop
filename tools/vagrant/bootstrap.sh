#!/bin/bash
# ------------------------------------------------------------------------------
# Vagrant - Virtualized Development 
# Copyright(c) pgRouting Contributors
#
# Virtual environment bootstrap script
# ------------------------------------------------------------------------------

set -e # Exit script immediately on first error.
#set -x # Print commands and their arguments as they are executed.

# Abort provisioning if pgRouting development environment already setup.
# ------------------------------------------------------------------------------
which vim >/dev/null &&
{ echo "pgRouting worksohp development environment already setup."; exit 0; }

# Enable PPA support
# ------------------------------------------------------------------------------
apt-get update -qq
apt-get install -y -qq python-software-properties vim

# Add PPA's'
# ------------------------------------------------------------------------------
apt-add-repository -y ppa:ubuntugis/ubuntugis-unstable
apt-get update -qq

# Run provisioning
# ------------------------------------------------------------------------------
echo "Installing packages ... this may take some time."
apt-get install -y -qq packaging-dev checkinstall postgresql-9.1-pgrouting osm2pgrouting

