# HBase in Docker
#
# Version 0.3

# http://docs.docker.io/en/latest/use/builder/

FROM ubuntu:xenial
MAINTAINER Dave Beckett <dave@dajobe.org>

COPY *.sh /build/

ENV HBASE_VERSION 1.2.4

RUN /build/prepare-hbase.sh && \
    cd /opt/hbase && /build/build-hbase.sh \
    cd / && /build/cleanup-hbase.sh && rm -rf /build

VOLUME /data
ADD ./hbase-site.xml /opt/hbase/conf/hbase-site.xml
ADD ./zoo.cfg /opt/hbase/conf/zoo.cfg
ADD ./replace-hostname /opt/replace-hostname
ADD ./hbase-server /opt/hbase-server
ADD ./hbase-start /opt/hbase-start
ADD ./hbase-create.hbase /opt/

RUN hbase master start | sleep 10 | hbase shell /opt/hbase-create.hbase | hbase master stop

EXPOSE 8080 8085 9090 9095 2181 16010
CMD ["/opt/hbase-start"]
