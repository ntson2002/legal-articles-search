### Java version 
	Requirments: JavaSE 1.8	
	Errror when using JavaSE < 1.8:
	Exception in thread "main" java.lang.UnsupportedClassVersionError: com/interf/test/TestRemote : Unsupported major.minor version 52.0

### Start Search api server (Lemur)
    
folder: **scripts**

requirements: config.json, lemur lib folder, index folder

```sh
#!/bin/bash
JARFOLDRER=~/Bitbucket/legal-articles-search/lemur-search-java/search-api-server/target
java -jar $JARFOLDRER/search-api.one-jar.jar   
```
    
### Indexing documents 

    LEMURLIB=/Users/sonnguyen/Bitbucket/legal-articles-search/lemur-search-java/search-api-server/lemur-installed/lib
    JARFOLDRER=/Users/sonnguyen/Bitbucket/legal-search/lemur2016/lib
    
    java -Djava.library.path=$LEMURLIB -jar $JARFOLDRER/IndexUI.jar

### Query (Java Interface)

    LEMURLIB=/Users/sonnguyen/Bitbucket/legal-articles-search/lemur-search-java/search-api-server/lemur-installed/lib
    JARFOLDRER=/Users/sonnguyen/Bitbucket/legal-search/lemur2016/lib
    
    java -Djava.library.path=$LEMURLIB -jar $JARFOLDRER/RetUI.jar
     
    
 
 
    
    