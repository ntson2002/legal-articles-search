#!/bin/bash

TOPICPATH=/home/s1520203/Bitbucket/legal-articles-search/topic-based-retrieval-py/output/english/topic.pickle
INDEXFOLDER=index-civil-code
PROGRAM=/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/whoosh
export PYTHONPATH=$PROGRAM:$PYTHONPATH


python $PROGRAM/query-api.py --port 8765 --index_folder $INDEXFOLDER --topic_path $TOPICPATH
