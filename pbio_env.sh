#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#
# create a conda environment
ENV="$1"

if [ "$ENV-" == "-" ]; then
    CDIR=$(basename "$PWD")
    ENV="${CDIR}_env"
fi
set  -o pipefail
if conda env list | grep ".*${ENV}.*" >/dev/null 2>&1; then
    echo "conda $ENV already exists, skipping creation..."
else
    echo "env $ENV does not exist, creating it..."
    conda create -n "$ENV" -y
fi

# Next line is needed in otder to be able to activate the environment
CUR_SHELL=shell.$(basename -- "${SHELL}")
eval "$(conda "$CUR_SHELL" hook)"

#
set -e
conda activate "$ENV"
echo "INFO: conda environment $ENV created and activated"

REPOS=(-c r -c conda-forge)

# Packages to install
conda install -n "$ENV" -y "${REPOS[@]}" perl
conda install -n "$ENV" -y "${REPOS[@]}" python=3.9
conda install -n "$ENV" -y "${REPOS[@]}" r-essentials
conda install -n "$ENV" -y "${REPOS[@]}" r-base
conda install -n "$ENV" -y "${REPOS[@]}" fastqc
conda install -n "$ENV" -y "${REPOS[@]}" trimmomatic
conda install -n "$ENV" -y "${REPOS[@]}" cutadapt
conda install -n "$ENV" -y "${REPOS[@]}" bwa
conda install -n "$ENV" -y "${REPOS[@]}" bowtie2
conda install -n "$ENV" -y "${REPOS[@]}" bioconductor-deseq2
conda install -n "$ENV" -y "${REPOS[@]}" samtools
conda install -n "$ENV" -y "${REPOS[@]}" bcftools
conda install -n "$ENV" -y "${REPOS[@]}" vcftools
conda install -n "$ENV" -y "${REPOS[@]}" angsd
conda install -n "$ENV" -y "${REPOS[@]}" fastme
conda install -n "$ENV" -y "${REPOS[@]}" picard
conda install -n "$ENV" -y "${REPOS[@]}" freebayes
conda install -n "$ENV" -y "${REPOS[@]}" gatk
conda install -n "$ENV" -y "${REPOS[@]}" lumpy-sv
conda install -n "$ENV" -y "${REPOS[@]}" breakdancer
# complete here


echo "All done."
exit 0
