
import os
from glob import glob
from whoosh.index import create_in, exists_in, open_dir
from whoosh.analysis import StandardAnalyzer, StopFilter, RegexTokenizer, LowercaseFilter, NgramTokenizer, NgramFilter

from whoosh.fields import *
from nltk.corpus import stopwords

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


def index(root_folder, files):
    list = stopwords.words('english')
    # my_analyzer = StopFilter()
    # my_analyzer = RegexTokenizer() | LowercaseFilter() | StopFilter()

    my_analyzer = StandardAnalyzer(stoplist=None)
    schema = Schema(title=TEXT(stored=True), path=ID(stored=True), content=TEXT(stored=True, vector=True, analyzer=my_analyzer))
    # schema = Schema(title=TEXT(stored=True), path=ID(stored=True), content=TEXT(stored=True, vector=True, ))


    ix = create_in("sample-index", schema)
    total = len(files)
    i = 1
    for f in files:
        print i, "/", total, ":", f
        text = get_text_from_file(f)
        # print text
        # print type(text)
        writer = ix.writer()
        writer.add_document(title=unicode(f.replace(root_folder, ""), "utf-8"), path=unicode(f.replace(root_folder, ""), "utf-8"),
                            content=unicode(text, "utf-8"))


        writer.commit()
        i = i + 1


if __name__ == '__main__':
    # path = "/home/s1520203/nomura-data/all_documents"
    path = "/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/data/sample"
    files = get_files_recursive(path)
    index(path, files)

