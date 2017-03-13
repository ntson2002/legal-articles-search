import web
import json

import query as api

data_folder = "output/english"

urls = ('/api/search/(.+)', 'api_query',
        '/api/search_mds/(.*)', 'api_query_mds',
        '/api/search_mds/', 'api_query_mds_post',
        '/api/topics', 'api_topics',
        '/api/search/', 'api_query_post',
        '/api/search2/(.*)/topic/(.+)', 'api_query_topic',
        '/api/search2/', 'api_query_topic_post')


class api_topics:
    def GET(self):
        web.header('Content-Type', 'application/json')
        model = data_folder + '/topic.pickle'
        data = api.getTopics(model)
        return json.dumps(data, indent=4, sort_keys=True)

class api_query:
    def GET(self, q):
        print "function: api_query"
        print "q:", q
        web.header('Content-Type', 'application/json')
        model = data_folder + "/model_TFIDF.pkl"
        data = api.queryTFIDF(model, q, 20)
        return json.dumps(data, indent=4, sort_keys=True)

class api_query_post:
    def POST(self):
        print "function: api_query_post"
        web.header('Content-Type', 'application/json')
        post_data = web.input(_method='post')
        print "q:", post_data["q"]
        q = post_data["q"]
        model = data_folder + "/model_TFIDF.pkl"
        data = api.queryTFIDF(model, q, 20)
        return json.dumps(data, indent=4, sort_keys=True)
            
class api_query_mds:
    def GET(self, q):
        print "function: api_query_mds"
        print "q:", q
        web.header('Content-Type', 'application/json')
        model = data_folder + "/model_TFIDF_MDS.pkl"
        data = api.queryMDS(model, q, 20)
        return json.dumps(data, indent=4, sort_keys=True)

class api_query_mds_post:
    def GET(self, q):
        print "function: api_query_mds_post"
        post_data = web.input(_method='post')
        q = post_data["q"]
        print "q:", q
        web.header('Content-Type', 'application/json')
        model = data_folder + "/model_TFIDF_MDS.pkl"
        data = api.queryMDS(model, q, 20)
        return json.dumps(data, indent=4, sort_keys=True)

class api_query_topic:
    def GET(self, q, t):
        print "function: api_query_topic"
        print "q:", q
        print "t:", t
        web.header('Content-Type', 'application/json')
        model = data_folder + "/model_TFIDF_MDS.pkl"
        topicFile = data_folder + "/topic.pickle"
        data = api.queryTFIDF_topicBased(model, topicFile, q, t, 30)
        return json.dumps(data, indent=4, sort_keys=True, encoding="utf-8")

class api_query_topic_post:
    def POST(self):
        print "function: api_query_topic_post"
        post_data = web.input(_method='post')
        q = post_data["q"]
        t = post_data["t"]
        print "q:", q
        print "t:", t
        web.header('Content-Type', 'application/json')
        model = data_folder + "/model_TFIDF.pkl"
        topicFile = data_folder + "/topic.pickle"
        data = api.queryTFIDF_topicBased(model, topicFile, q, t, 30)
        return json.dumps(data, indent=4, sort_keys=True, encoding="utf-8")        




class SearchAPIApplication(web.application):
    def run(self, port=8080, *middleware):
        func = self.wsgifunc(*middleware)
        return web.httpserver.runsimple(func, ('0.0.0.0', port))

# if __name__ == "__main__":
#     app = SearchAPIApplication(urls, globals())
#     app.run(port=8081)


import optparse
if __name__ == '__main__':
    optparser = optparse.OptionParser()
    optparser.add_option(
        "-p", "--port", default="8081",
        type='int',
        help="port"
    )

    opts = optparser.parse_args()[0]
    app = SearchAPIApplication(urls, globals())
    print "API server started ... "
    app.run(port=opts.port)



