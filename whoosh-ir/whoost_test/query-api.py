#!/usr/bin/python
# -*- coding: utf-8 -*-
import web
import json
import whoosh.index as index
from query import do_query, compute_map_data, get_doc
import pickle
import numpy as np
from utils import getStopWords
from sklearn.feature_extraction.text import TfidfVectorizer

urls = ('/api/search/', 'Searcher',
        '/api/search_topic/', 'TopicBased_Searcher',
        '/api/corpus/', 'Corpus',
        '/api/test/(.*)', 'Test')

class Searcher:
    def POST(self):
        ix = web.ix
        web.header('Content-Type', 'application/json')
        post_input = web.input(_method='post')

        query_string = post_input["query_string"].strip()
        type = post_input["type"].strip()
        map = post_input["map"].strip()
        print "map:", map
        print "query_string", query_string
        print "type", type
        matched_docs = do_query(ix, query_string, type)



        if map == "y":
            map_data = compute_map_data(query_string, matched_docs)
            for i in range(len(matched_docs)):
                matched_docs[i]["text"] = "\n".join(matched_docs[i]["text"].split("\n")[:5])
            return json.dumps({"result": matched_docs, "map_data": map_data}, indent=4, sort_keys=True)
        else:
            for i in range(len(matched_docs)):
                matched_docs[i]["text"] = "\n".join(matched_docs[i]["text"].split("\n")[:5])
            return json.dumps({"result": matched_docs}, indent=4, sort_keys=True)


class Corpus:
    def POST(self):
        ix = web.ix
        web.header('Content-Type', 'application/json')
        post_input = web.input(_method='post')

        function = post_input["function"].strip()

        if function == "get_doc":
            path = post_input["path"].strip()
            doc = get_doc(ix, path)

            return json.dumps(doc, indent=4, sort_keys=True)

        return json.dumps({}, indent=4, sort_keys=True)

class TopicBased_Searcher:
    def POST(self):
        def convert_docs_into_vector(train_set):
            stopWords = getStopWords("japanese")
            vectorizer = TfidfVectorizer(stop_words=stopWords, use_idf=True, sublinear_tf=False, norm=None,
                                         smooth_idf=True)

            trainVectorizerArray = vectorizer.fit_transform(train_set)

            return trainVectorizerArray, vectorizer.get_feature_names()


        def getTopics(topic_pickle, n_top_words=500):
            [model, topic_vectors, vocab] = topic_pickle
            data = {}
            for i in range(len(topic_vectors)):

                topic_dist = topic_vectors[i]
                topic_words = np.array(vocab)[np.argsort(topic_dist)][:-(n_top_words + 1):-1]
                a = zip(topic_words, topic_dist[np.argsort(topic_dist)][:-(n_top_words + 1):-1])
                b = [[t[0], t[1]] for t in a]
                data[i] = b

            return data


        '''
            Begin of API definition
        '''

        ix = web.ix
        topic_pickle = web.topic_pickle

        web.header('Content-Type', 'application/json')
        post_input = web.input(_method='post')
        print "function: ", post_input["function"]
        if post_input["function"] == "get_topic":
            n = int(post_input["n"])
            topic_data = getTopics(topic_pickle, n)
            return json.dumps(topic_data, indent=4, sort_keys=True)

        if post_input["function"] == "search":
            [_, topic_vectors, topic_terms] = topic_pickle
            topic_index = post_input["topic_index"]
            query_string = post_input["query_string"].strip()
            map = post_input["map"].strip()
            type = post_input["type"].strip()
            matched_docs = do_query(ix, query_string, type)

            # get all matched docs
            docs = [matched_docs[i]["text"] for i in range(len(matched_docs))]

            # convert this docs into vectors
            doc_vectors, doc_terms = convert_docs_into_vector(docs) # list of vectors and terms of return docs

            # conv
            topic_vec1 = np.array(topic_vectors[int(topic_index)])  # topic vec from topic vectors
            topic_dic = {topic_terms[i]: topic_vec1[i] for i in range(len(topic_terms))}
            topic_vec2 = np.array([])

            for i in range(len(doc_terms)):
                v = 0
                if doc_terms[i] in  topic_dic:
                    v = topic_dic[doc_terms[i]]
                topic_vec2 = np.append(topic_vec2, v)


            scores2 = np.dot(doc_vectors.toarray(), np.transpose(topic_vec2)) # relevant between topic and documents
            scores1 = [matched_docs[i]["score"] for i in range(len(matched_docs))] #orginal scores
            scores3 = [scores1[i] + scores2[i] for i in range(len(scores1))] # combination of two scores
            for i in range(len(matched_docs)):
                matched_docs[i]["score"] = scores3[i]

            print [matched_docs[i]["score"] for i in range(len(matched_docs))]
            matched_docs = sorted(matched_docs, key=lambda k: k['score'], reverse=True)
            print [matched_docs[i]["score"] for i in range(len(matched_docs))]


            if map == "y":
                map_data = compute_map_data(query_string, matched_docs)

                for i in range(len(matched_docs)):
                    matched_docs[i]["text"] = "\n".join(matched_docs[i]["text"].split("\n")[:5]) # keep 5 first lines

                return json.dumps({"result": matched_docs, "map_data": map_data}, indent=4, sort_keys=True)


            else:
                for i in range(len(matched_docs)):
                    matched_docs[i]["text"] = "\n".join(matched_docs[i]["text"].split("\n")[:5]) # keep 5 first lines

                return json.dumps({"result": matched_docs}, indent=4, sort_keys=True)



class Demo:
    def GET(self, q):
        import codecs
        web.header('Content-Type', 'text/html')
        html_text = "<h1>none</h1>"

        with codecs.open("demo.html", "r", "utf-8") as f:
            html_text = f.read()
        return html_text

class Test:
    def GET(self, q):
        web.header('Content-Type', 'application/json')
        # data = api.getTopics()
        data = ["a", "b", "c", "d", q]
        return json.dumps(data, indent=4, sort_keys=True)


class TaggerAPIApplication(web.application):
    def run(self, port=8080, *middleware):
        func = self.wsgifunc(*middleware)
        return web.httpserver.runsimple(func, ('0.0.0.0', port))

def sys_args_initialization():
    import argparse

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', help='port', type=int, default=8765)
    parser.add_argument('--index_folder', help='embeddings',default="legal_doc_index_with_data_nostop")

    args = parser.parse_args()
    return args

if __name__ == "__main__":

    """
        Load the model
    """

    args = sys_args_initialization()
    ix = index.open_dir(args.index_folder)


    # load topic vector from pickle file
    topic_path = "/home/s1520203/nomura-data/index/hoge4/topic.pickle"
    print "load topic vector ... from ",
    with open(topic_path, 'rb') as input:
        topic_pickle = pickle.load(input)
    print "loaded !"

    # args = parse_arguments()
    app = TaggerAPIApplication(urls, globals())
    web.ix = ix
    web.topic_pickle = topic_pickle
    app.run(args.port)


