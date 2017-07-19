from whoosh.qparser import QueryParser
import whoosh.index as index

ix = index.open_dir("indexdir")
with ix.searcher() as searcher:
    query = QueryParser("content", ix.schema).parse("Third")
    results = searcher.search(query)

    print results[0]