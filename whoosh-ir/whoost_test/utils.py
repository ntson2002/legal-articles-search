
from nltk.corpus import stopwords


def getStopWords(language="english"):
    if language == "english":
        list = stopwords.words('english')
        list.append("iv")
        list.append("v")
        list.append("iii")
        list.append("rrb")
        list.append("lrb")
        list.append("shall")
        list.append("may")
        list.append("article")
        list.append("paragraph")
    else:
        print "Using JAPANESE stopwords:"
        with open("stopwords.japanese", 'rb') as f:
            text = f.read().decode('utf-8')
        words = text.splitlines()
        list = [w.strip() for w in words]
    return list


if __name__ == '__main__':
    words = getStopWords(language="japanese")
    for w in words:
        print "*", w