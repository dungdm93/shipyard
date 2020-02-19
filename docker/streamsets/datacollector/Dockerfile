ARG SDC_VERSION=3.13.0
FROM maven:3.6-jdk-8 AS downloader

WORKDIR /app/
COPY ./pom.xml /app/
RUN set -eux; \
    mvn dependency:resolve; \
    mvn dependency:copy-dependencies -DoutputDirectory=jars/;

FROM streamsets/datacollector:${SDC_VERSION}
LABEL maintainer="Teko's DataOps Team <dataops@teko.vn>"
SHELL [ "/bin/bash", "-c" ]

RUN set -eux; \
    function join { local IFS="$1"; echo "${*:2}"; }; \
    SDC_LIBS=( \
        streamsets-datacollector-aws-lib        \
        streamsets-datacollector-jdbc-lib       \
        streamsets-datacollector-mongodb_3-lib  \
    ); \
    "${SDC_DIST}/bin/streamsets" stagelibs -install="$(join ',' ${SDC_LIBS[@]})"

COPY --from=downloader /app/jars/ "${STREAMSETS_LIBRARIES_EXTRA_DIR}/streamsets-datacollector-jdbc-lib/lib"
