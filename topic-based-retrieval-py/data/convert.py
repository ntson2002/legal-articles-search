from pprint import pprint
import glob
import os
import json
import codecs

def convert_txt_to_json(path, outpath):

    files = glob.glob(path + "/*.txt")
    print 'Total files:', len(files)
    data = []
    for file in files:
        if os.path.isfile(file):
            doc = {}
            with open(file, 'r') as f:
                lines = f.readlines()
                content = ' '.join(lines)  # join all line in a doc
                asentece = {}
                asentece["text"] = content
                asentece["length"] = len(content.split(" "))
                sentences = []
                sentences.append(asentece)
                doc["article_id"] = os.path.basename(file)
                doc["sentences"] = sentences
                doc["description"] = ""
                data.append(doc)


    from pprint import pprint
    pprint (data)

    with codecs.open(outpath, "w", "utf-8") as fout:
        fout.write(json.dumps(data, indent=4))


folder = "/Users/sonnguyen/Bitbucket/legal-articles-search/topic-based-retrieval-py/data/example1"
output = "/Users/sonnguyen/Bitbucket/legal-articles-search/topic-based-retrieval-py/data/example1.json"

convert_txt_to_json(folder, output)

