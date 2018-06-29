# -*- coding: utf-8 -*-

from whoosh.qparser import QueryParser, OrGroup
import whoosh.index as index
from whoosh import scoring
from utils import getStopWords
from sklearn.feature_extraction.text import TfidfVectorizer
from scipy.spatial import distance
from sklearn import manifold
import numpy as np

def get_doc(ix, path):
    with ix.searcher() as searcher:
        doc = searcher.document(path=path)
        # print type(doc)
        # print doc
        return doc

def do_query(ix, q, type):
    if type == "bm25":
        weighting_model = scoring.BM25F()
    else:
        weighting_model = scoring.TF_IDF()
    print "******** HELLO ***********"
    matched_docs = []
    with ix.searcher(weighting=weighting_model) as searcher:
        qp = QueryParser("content", ix.schema, group=OrGroup)
        query = qp.parse(q)
        results = searcher.search(query, limit=50)
        print "found: ", results.scored_length()
        for r in results:
            # print r.fields()["content"][:30], r.fields()["path"], r.score, r.docnum
            matched_docs.append({"path": r.fields()["path"],
                                 "score": r.score,
                                 "terms": "",
                                 # "text": r.fields()["content"]
                                 "text": r.fields()["content"]
                                 })

    return matched_docs


def do_query_topic_based(ix, q, type, topic_pickle):
    matched_docs = do_query(ix, q, type)
    [_, topic_vectors, vocab] = topic_pickle



def compute_map_data(q, matched_docs):
    def convert_to_mds(matrix, dimensions=50):

        mds = manifold.MDS(n_components=dimensions, dissimilarity='precomputed', random_state=np.random.seed(12345), max_iter=5000, eps=1e-5)
        mdsMatrix = mds.fit_transform(matrix)
        return mdsMatrix

    def convert_into_vector(train_set):
        stopWords = getStopWords("japanese")
        vectorizer = TfidfVectorizer(stop_words=stopWords, use_idf=True, sublinear_tf=False, norm='l2', smooth_idf=True)

        # vectorizer = CountVectorizer(stop_words = stopWords, min_df=1)
        trainVectorizerArray = vectorizer.fit_transform(train_set)
        return trainVectorizerArray

    def convert_scale(xmin, xmax, ymin, ymax, y):
        xmax = 1
        xmin = 0.1
        return xmin + (ymax - y) * (xmax - xmin) / (ymax - ymin)

    train_set = []
    import time
    start = time.time()
    for doc in matched_docs:
        train_set.append(doc["text"])
    train_set.append(q)

    vectors = convert_into_vector(train_set).toarray()


    # np.set_printoptions(precision=3)
    D = distance.cdist(vectors, vectors, 'cosine')
    # print D.shape
    qIndex = len(matched_docs)
    # print D[qIndex]
    # print D[5][1]
    # print D[1][5]
    xmin = np.min(D[qIndex][:qIndex-1])
    xmax = np.max(D[qIndex][:qIndex-1])
    # print "min distance cosine: ", x1
    # print "max distance cosine: ", x2
    arr = np.array([matched_docs[i]["score"] for i in range(len(matched_docs))])
    ymin = np.min(arr)
    ymax = np.max(arr)

    for i in range(len(matched_docs)):
        y = matched_docs[i]["score"]
        x = convert_scale(xmin, xmax, ymin, ymax, y)
        print D[qIndex][i], matched_docs[i]["score"], x
        D[qIndex][i] = x
        D[i][qIndex] = x

    #
    # for i in range(len(vectors)):
    #     print distance.cosine(vectors[len(matched_docs)], vectors[i])

    mds_xy = convert_to_mds(D, 2)


    mds_xy = mds_xy - mds_xy[len(matched_docs)]
    print mds_xy
    map_info = [(mds_xy[i][0], mds_xy[i][1], matched_docs[i]["path"], '#%02X%02X%02X' % (255, (i * 255)/len(matched_docs), 0), 20) for i in range(len(matched_docs))]
    map_info.append((mds_xy[len(matched_docs)][0], mds_xy[len(matched_docs)][1], "query", "#00f", 25))
    map_data = {
        "animation": {"duration": 10000},
        "datasets": [{"label": t[2].split("/")[-1].replace(".txt", ""), "backgroundColor": t[3], "data": [{"x": t[0], "y": t[1], "r": t[4]}]} for t in
                     map_info]
    }
    print time.time() - start
    # from pprint import pprint
    # pprint (map_data)
    # data["map_data"] = map_data
    return map_data

def print_term_of_doc(ix, path):
    with ix.searcher(weighting=scoring.TF_IDF()) as searcher:
        docnum = searcher.document_number(path=path)
        matcher = searcher.vector(docnum, "content") # get all term in docnum
        while matcher.is_active():
            print "#", matcher.id(), matcher.weight(), matcher.all_items()
            matcher.next()



if __name__ == '__main__':
    # ix = index.open_dir("legal_doc_index_with_data")
    # q = u"滅失 当時 の 本件 商品 の 価額 が 六 〇 万 円 で ある こと は すで に 述べ た とおり （ 原判決 七 枚 目 裏 四 行 目 から 同 八 枚 目 表 三行 目 まで ） で ある が 、 もし 被控訴人 が   れ 以下 で ある と 主張 する もの で ある なら ば 、 被控訴人 の 方 で これ を 立証 す べき 責任 が ある 。"
    # do_query(ix, q)

    ix = index.open_dir("legal_doc_index_with_data_nostop")
    print_term_of_doc(ix, u"/hoge2/B5522839.txt")