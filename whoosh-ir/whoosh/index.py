
import os
from glob import glob
from whoosh.index import create_in, exists_in, open_dir
from whoosh.fields import *
from utils import getStopWords
from whoosh.analysis import StandardAnalyzer

def get_files(path):
    result = []
    for root, dirs, files in os.walk(path):
        for file in files:
            if file.endswith(".txt"):
                 result.append(os.path.join(root, file))
    return result

def get_files_recursive(path):
    result = [y for x in os.walk(path) for y in glob(os.path.join(x[0], '*.txt'))]
    return result

def get_text_from_file(path):
    with open(path, 'r') as content_file:
        content = content_file.read()
        return content


def index(root_folder, files, output, language):
    # schema = Schema(title=TEXT(stored=True), path=ID(stored=True), content=TEXT(stored=True))
    my_analyzer = StandardAnalyzer(stoplist=getStopWords())
    schema = Schema(title=TEXT(stored=True), path=ID(stored=True), content=TEXT(stored=True, vector=True, analyzer=my_analyzer))
    ix = create_in(output, schema)
    total = len(files)
    i = 1
    for f in files:
        print i, "/", total, ":", f
        text = get_text_from_file(f)
        writer = ix.writer()
        writer.add_document(title=unicode(f.replace(root_folder, ""), "utf-8"), path=unicode(f.replace(root_folder, ""), "utf-8"),
                            content=unicode(text, "utf-8"))


        writer.commit()
        i = i + 1



def main_test():
    path = "/home/s1520203/nomura-data/all_documents"
    files = get_files_recursive(path)
    output = "legal_doc_index_with_data_nostop"
    index(path, files, output)

def sys_args_initialization():
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--folder', help='folder contain all documents', default="")
    parser.add_argument('--index_folder', help='output index folder',default="")
    parser.add_argument('--language', help='english, japanese',default="")

    args = parser.parse_args()
    return args

if __name__ == "__main__":
    
    args = sys_args_initialization()    
    files = get_files_recursive(args.folder)
    index(args.folder, files, args.index_folder,args.language)


