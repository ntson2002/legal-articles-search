from sklearn.feature_extraction.text import TfidfVectorizer
import numpy as np

corpus = ["cat dog lion cat",
          "cat lion chicken",
          "chicken rabbit elephant",
          "elephant fox lemur chicken",
          "elephant cat dog"]
vectorizer = TfidfVectorizer(min_df=0, norm='l2') #default = l2 --> vector will be normalized by norm2
X = vectorizer.fit_transform(corpus)
idf = vectorizer._tfidf.idf_


from pprint import pprint
pprint (dict(zip(vectorizer.get_feature_names(), idf))) #idf = np.log(float(n_samples) / df) + 1.0
# print vectorizer.transform(corpus[0]).t

v = vectorizer.transform(["cat dog lion cat"]).toarray()

print v
# def normalize(v):
#     norm=np.linalg.norm(v, ord=2)
#     print norm
#     if norm==0:
#         norm=np.finfo(v.dtype).eps
#     return v/norm
#
#
# s = 0.0
# for x in v[0]:
#     print x * x
#     s = s + x * x
# print s
# pprint (v)
# pprint (normalize(v))

#https://stackoverflow.com/questions/36966019/how-aretf-idf-calculated-by-the-scikit-learn-tfidfvectorizer