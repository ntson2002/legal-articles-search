from whoosh.index import create_in, exists_in, open_dir
from whoosh.fields import *
schema = Schema(title=TEXT(stored=True), path=ID(stored=True), content=TEXT)
#

exists =exists_in("indexdir")
print exists
if exists:
    print "open exists index"
    ix = open_dir("indexdir")
else:
    print "create new index"
    ix = create_in("indexdir", schema)


writer = ix.writer()
writer.add_document(title=u"Third document", path=u"/a",
                    content=u"This is the Third document we've added!")
writer.add_document(title=u"Four document", path=u"/b",
                    content=u"The Four one is even more interesting!")
writer.commit()

