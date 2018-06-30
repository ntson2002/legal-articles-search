# Run API on UV:

`
cd /home/s1520203/Bitbucket/legal-articles-search/whoosh-ir/scripts/english
. activate legal-search
bash run-search-api-CivilCode.sh
`

Requirements:
`
web.py
nltk
whoosh
sklearn
scipy
lda
`

# Website:

* Copy war `legal-search-web/dist/legal-search-web.war` file into webapps folder of apache tomcat:
* Requirements: JDK 1.8

# Deployment on AWS 150.65.8.41:8080 (has been linked to  150.65.242.97):

* http://150.65.8.41:8080/legal-search-web/
* https://s242-097.jaist.ac.jp/legal-search-web/index.jsp
    