ARG ELASTIC_VERSION

FROM docker.elastic.co/elasticsearch/elasticsearch:${ELASTIC_VERSION}

WORKDIR /usr/share/elasticsearch/config
COPY /config/synonym.txt .
COPY /config/userdic.txt .
COPY /config/jobinfo.json .
COPY /config/newsinfo.json .

WORKDIR /usr/share/elasticsearch/bin

RUN elasticsearch-plugin install --batch analysis-nori

#COPY initialize-templates.sh /usr/share/elasticsearch/config/
#ENTRYPOINT ["sh", "/usr/share/elasticsearch/config/initialize-templates.sh"]