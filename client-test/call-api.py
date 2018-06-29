# -*- coding: utf-8 -*-

import requests
import json


def search_with_topic():
    data={
        'function' : 'search',
        'query_string' : '滅失 当時 の 本件 商品 の 価額 が 六 〇 万 円 で ある こと は すで に 述べ た とおり （ 原判決 七 枚 目 裏 四 行 目 から 同 八 枚 目 表 三行 目 まで ） で ある が 、 もし 被控訴人 が れ 以下 で ある と 主張 する もの で ある なら ば 、 被控訴人 の 方 で これ を 立証 す べき 責任 が ある 。',
        'topic_index' : 1,
        'type' : 'tfidf',
        'map' : 'y'
    }

    r = requests.post("http://uv.jaist.ac.jp:8765/api/search_topic/", data)
    print(r.status_code, r.reason)

    response = json.loads(r.text)
    with open("sample1.json", "w") as f:
        json.dump(response, f, indent=4)


def search_with_tfidf():
    data = {
        'query_string': '滅失 当時 の 本件 商品 の 価額 が 六 〇 万 円 で ある こと は すで に 述べ た とおり （ 原判決 七 枚 目 裏 四 行 目 から 同 八 枚 目 表 三行 目 まで ） で ある が 、 もし 被控訴人 が れ 以下 で ある と 主張 する もの で ある なら ば 、 被控訴人 の 方 で これ を 立証 す べき 責任 が ある 。',
        'type': 'tfidf',
        'map': 'y'
    }

    r = requests.post("http://uv.jaist.ac.jp:8765/api/search/", data)
    print(r.status_code, r.reason)

    response = json.loads(r.text)
    with open("sample2.json", "w") as f:
        json.dump(response, f, indent=4)

def get_topic_list():
    data = {
        'function': 'get_topic',
        'n': '50' # top-n words
    }

    r = requests.post("http://uv.jaist.ac.jp:8765/api/search_topic/", data)
    print(r.status_code, r.reason)

    response = json.loads(r.text)
    with open("sample3.json", "w") as f:
        json.dump(response, f, indent=4)



if __name__ == '__main__':
    search_with_topic()
    # search_with_tfidf()
    # get_topic_list()
