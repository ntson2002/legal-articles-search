# -*- coding: utf-8 -*-
import whoosh.index as index
from whoosh import scoring
from whoosh.searching import Hit
from whoosh.qparser import QueryParser, OrGroup
from whoosh.query import Phrase


def print_term_of_doc(ix, path):
    with ix.searcher(weighting=scoring.TF_IDF()) as searcher:
        docnum = searcher.document_number(path=path)
        matcher = searcher.vector(docnum, "content") # get all term in docnum
        while matcher.is_active():
            print "#", matcher.id(), matcher.weight(), matcher.all_items()
            matcher.next()

def demo_query():
    ix = index.open_dir("sample-index")
    q = u"fox lemur"

    with ix.searcher(weighting=scoring.TF_IDF()) as searcher:
        qp = QueryParser("content", ix.schema, group=OrGroup)
        query = qp.parse(q)

        results = searcher.search(query, limit=10, terms=True)
        print "results", type(results), results
        print "\n----all hits -----"
        for r in results:
            print type(r), r.score, r.rank, r.docnum, r, r.fields()['path']
            # print 'matched terms:', r.matched_terms()
            # print 'document info:', searcher.document(path=r.fields()['path'])

            # docnum = r.docnum
            # fieldobj = searcher.schema["content"]
            #
            #
            # print list(query.docs(searcher))
            #
            # reader = searcher.reader()
            # from array import array
            # doclist = array("I", reader.all_doc_ids())
            #
            # print [docnum for docnum in xrange(searcher.doc_count_all())]
            # print doclist
            # # matcher = searcher.vector(r.docnum, "content") # get all term in docnum
            # matcher = query.matcher(searcher) # get all docs matching with each query
            #
            # while matcher.is_active():
            #     print "#", matcher.id(), matcher.weight(), matcher.score(), matcher.all_items()
            #     print searcher.vector(r.docnum, "content")
            #     matcher.next()


def get_docnum(ix, path):
    with ix.searcher() as searcher:
        docnum = searcher.document_number(path=path)
        return docnum


if __name__ == '__main__':
    demo_query()
    ix = index.open_dir("sample-index")
    # print_term_of_doc(ix, u"/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/data/sample-2/7.txt")
    # print ix.field_length("content")

    # print get_docnum(ix, "/home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/data/sample-2/7.txt")






# from whoosh.searching import Hit
# from whoosh.qparser import QueryParser, OrGroup
# import whoosh.index as index
# from whoosh import scoring
# from whoosh import matching
# from whoosh import reading
#
# ix = index.open_dir("sample-index")
# q = u"fox lemur"
# print ix.doc_count_all()
# print ix.doc_count()
# print ix.field_length("content")
# print ix.field_length("title")
#
#
#
# with ix.searcher(weighting=scoring.TF_IDF()) as searcher:
#     fieldobj = searcher.schema["content"]
#     qp = QueryParser("content", ix.schema, group=OrGroup)
#     # qp = QueryParser("content", ix.schema)
#     query = qp.parse(q)
#     print query
#     print type(query)
#
#     results = searcher.search(query, limit=10, terms=True)
#     print "results", type(results), results
#     print "\n----all hits -----"
#     for r in results:
#         print type(r), r.score, r.rank, r.docnum, r, r.fields()['path']
#         print 'matched terms:', r.matched_terms()
#         print 'document info:', searcher.document(path=r.fields()['path'])
#
#         docnum = r.docnum
#         fieldobj = searcher.schema["content"]
#
#
#         print list(query.docs(searcher))
#
#         reader = searcher.reader()
#         from array import array
#         doclist = array("I", reader.all_doc_ids())
#
#         print [docnum for docnum in xrange(searcher.doc_count_all())]
#         print doclist
#         # matcher = searcher.vector(r.docnum, "content") # get all term in docnum
#         matcher = query.matcher(searcher) # get all docs matching with each query
#
#         while matcher.is_active():
#             print "#", matcher.id(), matcher.weight(), matcher.score(), matcher.all_items()
#             print searcher.vector(r.docnum, "content")
#             # print reader.[matcher.id()]
#             # print searcher.reader().column_reader("content")[matcher.id()]
#
#             matcher.next()
#
#         # print "#", matcher.id(), matcher.weight()
#         # matcher.next()
#         # print "#", matcher.id(), matcher.weight()
#         # matcher.next()
#         # print "#", matcher.id(), matcher.weight()
#         # matcher.next()
#
#
#
#
#
#         for btext in matcher.all_ids():
#             print "  ", btext, fieldobj.from_bytes(btext)
#             print matcher.id(), btext
#             if matcher.id() == btext:
#                 print("MATCH:", fieldobj.from_bytes(btext))
#                 # print matcher.all_as("frequency")
#             # for btext in matcher.all_ids():
#         #     print("  ", fieldobj.from_bytes(btext)
#
#
#
#         # print searcher.document(doc_num=u'/1.txt')
#
#     # print query.matcher(searcher)
#     # print searcher.doc_count()
#
#
#     '''
#     {u'cat': 1.4054651081081644,
#      u'chicken': 1.4054651081081644,
#      u'dog': 1.6931471805599454,
#      u'elephant': 1.4054651081081644,
#      u'fox': 2.09861228866811,
#      u'lemur': 2.09861228866811,
#      u'lion': 1.6931471805599454,
#      u'rabbit': 2.09861228866811}
#     '''
#
#
#
#     # print scoring.TF_IDF().scorer(searcher, 'content', u'elephant').score(query.matcher(searcher))
#     print "cat", searcher.idf('content', u'cat') #ln (N / (n+1)) + 1
#     print "dog", searcher.idf('content', u'dog')
#     matcher = query.matcher(searcher)
#     print matcher.weight()
#     print "value", matcher.score
#     print matcher.weight()
#     print matcher.id()
#     matcher.next()
#     print matcher.weight()
#     print matcher.id()
#
#
#     print scoring.TF_IDF().scorer(searcher, 'content', u'cat').score(query.matcher(searcher))
#
#     # print searcher.idf('content', u'cat')
#     # print scoring.TF_IDF().scorer(searcher, 'content', u'cat').score(query.matcher(searcher))
#     # print query.matcher(searcher).weight()
#     # matcher = query.matcher(searcher)
#     # from pprint import pprint
#     # pprint (matcher)
#     # print type(matcher)
#     # print matcher.weight()
#
#     # print scoring.TF_IDF().scorer(searcher, 'content', u'当事者')
#     # print scoring.BM25F().scorer(searcher, 'content', u'事実').score(query.matcher(searcher))
#
#     # print results.scored_length()
#     # print results
#     # print len(results)
#     # print results[0]
#     # print type(results)
#     # print type(results[0])
#     # print results[:10]
#
#     # https://stackoverflow.com/questions/18670493/how-to-get-tf-idf-score-and-bm25f-score-of-a-term-in-a-document-using-whoosh
#     # scoring.TF_IDF().scorer(searcher, 'content', 'algebra').score(q.matcher(searcher))
#
