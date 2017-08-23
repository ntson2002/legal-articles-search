# -*- coding: utf-8 -*-

import os
from glob import glob
from whoosh.index import create_in, open_dir
from whoosh.analysis import StandardAnalyzer
from whoosh.qparser import QueryParser, OrGroup
from whoosh.fields import *
from whoosh import scoring

'''
    def get_files(path): Lấy danh sách file trong một thư mục
    def get_files_recursive(path):  Lấy danh sách file trong một thư mục
    def get_text_from_file(path): Lấy nội dung file
    def get_schema(stopword_list=None): tạo schema
    def index(files, output_folder): Index nhiều file (tạo index mới)
    def append(files, ix): Index thêm nhiều file vào một index cũ
    def get_docnum(ix, path): Lấy docnumber từ path
    def delete_doc(path, ix): Xoá document khỏi index
    def query(ix, q): Thực hiện query
'''

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

def get_schema(stopword_list=None):
    # stopword_list = stopwords.words('english')
    my_analyzer = StandardAnalyzer(stoplist=stopword_list)
    schema = Schema(title=TEXT(stored=True), path=ID(stored=True, unique=True),
                    content=TEXT(stored=True, vector=True, analyzer=my_analyzer))
    return schema


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
    print "#doc: ", ix.doc_count_all(), ix.doc_count()

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

def query(ix, q):
    with ix.searcher(weighting=scoring.TF_IDF()) as searcher:
        qp = QueryParser("content", ix.schema, group=OrGroup)
        query = qp.parse(q)

        results = searcher.search(query, limit=10, terms=True)
        print "\n----all hits -----"
        for r in results:
            print type(r), r.score, r.rank, r.docnum, r, r.fields()['path']


if __name__ == '__main__':
    print "===== # step 1: Index a folder ====="
    path = "/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/data/sample"
    output_folder = "sample-index"
    files = get_files_recursive(path)
    index(files, output_folder)

    print "===== # step 2: Add some files ====="
    ix = open_dir(output_folder)
    path2 = "/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/data/sample-2"
    files2 = get_files_recursive(path2)
    append(files2, ix)
    print "#doc: ", ix.doc_count_all(), ix.doc_count()


    print "===== # step 3: Delete a doc ====="
    ix = open_dir(output_folder)
    delete_doc("/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/data/sample-2/7.txt", ix)
    print "#doc: ", ix.doc_count_all(), ix.doc_count()

    print "===== # step 4: Query ====="
    ix = open_dir(output_folder)
    query(ix, "fox lemur")
