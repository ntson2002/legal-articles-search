
import os
from glob import glob
from whoosh.index import create_in, exists_in, open_dir
from whoosh.analysis import StandardAnalyzer, StopFilter, RegexTokenizer, LowercaseFilter, NgramTokenizer, NgramFilter

from whoosh.fields import *
from nltk.corpus import stopwords

def get_schema(stopword_list=None):
    # stopword_list = stopwords.words('english')
    my_analyzer = StandardAnalyzer(stoplist=stopword_list)
    schema = Schema(title=TEXT(stored=True), path=ID(stored=True, unique=True),
                    content=TEXT(stored=True, vector=True, analyzer=my_analyzer))
    return schema


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

def index(files, output_folder):

    schema = get_schema()
    ix = create_in(output_folder, schema)
    total = len(files)
    i = 1
    for f in files:
        print i, "/", total, ":", f
        text = get_text_from_file(f)
        writer = ix.writer()
        if get_docnum(ix, f) == None:
            writer.add_document(title=unicode(f, "utf-8"), path=unicode(f, "utf-8"), content=unicode(text, "utf-8"))
        else:
            writer.update_document(title=unicode(f, "utf-8"), path=unicode(f, "utf-8"), content=unicode(text, "utf-8"))

        writer.commit()
        i = i + 1

def append(files, ix):
    total = len(files)
    iadd = 0
    iupdate = 0
    i = 1
    for f in files:

        print i, "/", total, ":", f
        text = get_text_from_file(f)
        writer = ix.writer()
        if get_docnum(ix, f) == None:
            writer.add_document(title=unicode(f, "utf-8"), path=unicode(f, "utf-8"), content=unicode(text, "utf-8"))
            iadd += 1
        else:
            writer.update_document(title=unicode(f, "utf-8"), path=unicode(f, "utf-8"), content=unicode(text, "utf-8"))
            iupdate += 1

        writer.commit()
        i = i + 1

    print "** add: ", iadd
    print "** update: ", iupdate


def get_docnum(ix, path):
    with ix.searcher() as searcher:
        docnum = searcher.document_number(path=path)
        return docnum

def delete_doc(path, ix):
    docnum = get_docnum(ix, path=path)
    writer = ix.writer()
    writer.delete_document(docnum)
    writer.commit()
    print "deleted: ", docnum, path

if __name__ == '__main__':
    # path = "/home/s1520203/nomura-data/all_documents"
    path = "/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/data/sample"
    output_folder = "sample-index"
    files = get_files_recursive(path)
    print files
    index(files, output_folder)

    ix = open_dir(output_folder)
    path2 = "/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/data/sample-2"
    files2 = get_files_recursive(path2)
    append(files2, ix)
    append(files2, ix)

    print ix.doc_count_all()
    print ix.doc_count()
    append(files2, ix)
    append(files2, ix)
    print ix.doc_count()

    delete_doc("/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/data/sample-2/7.txt", ix)

    print ix.doc_count_all()
    print ix.doc_count()


