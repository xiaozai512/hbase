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

ADD ./hbase-create.hbase /opt/

# REST API
# REST Web UI at :8085/rest.jsp
# Thrift API
# Thrift Web UI at :9095/thrift.jsp
# HBase's Embedded zookeeper cluster
# HBase Master web UI at :16010/master-status;  ZK at :16010/zk.jsp
EXPOSE 8080 8085 9090 9095 2181 16010
ENTRYPOINT ["/opt/hbase-server"]
CMD ["hbase shell /opt/hbase-create.hbase"]
