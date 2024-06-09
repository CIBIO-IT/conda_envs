#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#
# create a conda environment
ENV="$1"

if [ "$ENV-" == "-" ]; then
    #CDIR="$(basename "$PWD")"
    ENV="$(basename "$0" .sh)"
fi
set  -o pipefail
if conda env list | grep ".*${ENV}.*" >/dev/null 2>&1; then
    echo "conda $ENV already exists, skipping creation..."
else
    echo "env $ENV does not exist, creating it..."
    conda create -n "$ENV" -y
fi

if [ ! -e rnammer-1.2 ] || [ ! -d rnammer-1.2 ]; then
    echo "ERROR: Expected rnammer-1.2 folder"
    exit 1
fi

# Next line is needed in otder to be able to activate the environment
CUR_SHELL=shell.$(basename -- "${SHELL}")
eval "$(conda "$CUR_SHELL" hook)"

#
set -e
conda activate "$ENV"
echo "INFO: conda environment $ENV created and activated"

REPOS=(-c bioconda)

# Packages to install
conda install -n "$ENV" -y "${REPOS[@]}" hmmer2 perl-getopt-Long perl-xml-simple perl-xml-sax  perl-xml-libxml
#
# Expects a rnammer-1.2 folder with the rnammer scripts
sed -i "s|my \$INSTALL_PATH = .*|my \$INSTALL_PATH = \"$PWD/rnammer-1.2/\";|" rnammer-1.2/rnammer
sed -i "s|\$HMMSEARCH_BINARY = .*| \$HMMSEARCH_BINARY = \"$PWD/rnammer-1.2/hmmsearch\";|" rnammer-1.2/rnammer

cd rnammer-1.2
rm -f hmmsearch
ln -s $(whereis hmmsearch2|cut -f 2 -d:) hmmsearch


# ADD rnammer to path
DIR=`dirname $(whereis hmmsearch2|cut -f 2 -d:)`
cp -r hmmsearch core-rnammer rnammer lib $DIR
cp  man/*  $DIR/../man

echo "Created the following conda environments: $ENV"
# Edit the rn
echo "All done."

exit 0
