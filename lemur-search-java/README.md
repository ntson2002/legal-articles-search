### Java version 
	Requirments: JavaSE 1.8	
	Errror when using JavaSE < 1.8:
	Exception in thread "main" java.lang.UnsupportedClassVersionError: com/interf/test/TestRemote : Unsupported major.minor version 52.0

### Start Search api server (Lemur), this API can be called from a java program such as JSP 
    
folder: **scripts**

requirements: config.json, lemur lib folder, index folder

```json
{
    "indexs": [    	
    	"/Users/sonnguyen/Downloads/civil-code-index"
    ],
    "rmi-port": "52366",
    "rmi-id": "LEGAL-API",
    "lemurlib": "lemur-installed/lib"
}
```

```sh
#!/bin/bash
JARFOLDRER=~/Bitbucket/legal-articles-search/lemur-search-java/search-api-server/target
java -jar $JARFOLDRER/search-api.one-jar.jar   
```
    
### Indexing documents (Java Interface)
```sh
    
    LEMURLIB=/Users/sonnguyen/Bitbucket/legal-articles-search/lemur-search-java/search-api-server/lemur-installed/lib
    
    JARFOLDRER=/Users/sonnguyen/Bitbucket/legal-search/lemur2016/lib
    
    # start indexing program 
    java -Djava.library.path=$LEMURLIB -jar $JARFOLDRER/IndexUI.jar

```
### Query (Java Interface)
```sh 
    LEMURLIB=/Users/sonnguyen/Bitbucket/legal-articles-search/lemur-search-java/search-api-server/lemur-installed/lib
    JARFOLDRER=/Users/sonnguyen/Bitbucket/legal-search/lemur2016/lib
    
    java -Djava.library.path=$LEMURLIB -jar $JARFOLDRER/RetUI.jar
```

  
 
 
    
    