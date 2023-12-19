# Customized Flink Kubernetes operator Docker image including various filesystem plugins

ARG FLINK_K8S_VERSION=1.1.0

FROM apache/flink-kubernetes-operator:$FLINK_K8S_VERSION
LABEL maintainer="dungdm93"

# https://nightlies.apache.org/flink/flink-docs-master/docs/deployment/filesystems/plugins/
COPY --from=apache/flink:1.15.1 [ \
    "/opt/flink/opt/flink-azure-fs-hadoop-*.jar", \
    "/opt/flink/opt/flink-gs-fs-hadoop-*.jar", \
    "/opt/flink/opt/flink-oss-fs-hadoop-*.jar", \
    "/opt/flink/opt/flink-s3-fs-hadoop-*.jar", \
    "/opt/flink/plugins/flink-fs-hadoop/" \
]
