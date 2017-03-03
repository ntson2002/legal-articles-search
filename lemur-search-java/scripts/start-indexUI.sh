#!/bin/bash

LEMURLIB=~/Bitbucket/legal-articles-search/lemur-search-java/scripts/lemur/lemur-installed/lib
JARFOLDRER=~/Bitbucket/legal-articles-search/lemur-search-java/scripts/lemur/tools

java -Djava.library.path=$LEMURLIB -jar $JARFOLDRER/IndexUI.jar
