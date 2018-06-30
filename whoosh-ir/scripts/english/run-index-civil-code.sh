#!/bin/bash

PROGRAM=/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/whoosh
export PYTHONPATH=$PROGRAM:$PYTHONPATH
mkdir -p index-civil-code
python $PROGRAM/index.py --folder all-articles --index_folder index-civil-code --language english
