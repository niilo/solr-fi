FROM solr:6.4.1
USER root
RUN echo "deb http://http.us.debian.org/debian testing main non-free contrib" >> /etc/apt/sources.list && \
  echo "deb-src http://http.us.debian.org/debian testing main non-free contrib" >> /etc/apt/sources.list && \
  apt-get update && apt-get -y upgrade && apt-get -yqq install libvoikko1/testing && apt-get clean
COPY solrvoikko*.jar /opt/solr/server/solr/lib/
RUN cd /opt/solr/server/solr/lib/ && \
    wget http://download.icu-project.org/files/icu4j/58.2/icu4j-58_2.jar && \
    wget http://download.icu-project.org/files/icu4j/58.2/icu4j-charset-58_2.jar && \
    wget http://download.icu-project.org/files/icu4j/58.2/icu4j-localespi-58_2.jar && \
    wget http://central.maven.org/maven2/net/java/dev/jna/jna/4.3.0/jna-4.3.0.jar && \
    wget http://central.maven.org/maven2/org/apache/lucene/lucene-analyzers-icu/6.4.1/lucene-analyzers-icu-6.4.1.jar && \
    wget http://central.maven.org/maven2/org/puimula/voikko/libvoikko/4.0.1/libvoikko-4.0.1.jar && \
    chown -R solr.solr /opt/solr/server/solr/lib/*
RUN cd /opt/solr/server/solr-webapp/webapp/WEB-INF/lib && \
    wget http://central.maven.org/maven2/com/vividsolutions/jts-core/1.14.0/jts-core-1.14.0.jar && \
    chown -R solr.solr /opt/solr/server/solr-webapp/webapp/WEB-INF/lib/*
RUN mkdir /etc/voikko && cd /etc/voikko && \
    wget http://www.puimula.org/htp/testing/voikko-snapshot-v5/dict-morphoid.zip && \
    unzip dict-morphoid.zip && rm dict-morphoid.zip
USER solr
