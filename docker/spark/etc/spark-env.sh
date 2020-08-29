#!/usr/bin/env bash

JAVA_HOME="${JAVA_HOME:-$(readlink -f "$(which java)" | sed "s:/bin/java::")}"

if [ -n "${HADOOP_HOME}" ] && [ -z "${SPARK_DIST_CLASSPATH}"  ]; then
  SPARK_DIST_CLASSPATH="$(${HADOOP_HOME}/bin/hadoop classpath)"
fi

# Teko's stuff to support 'HADOOP_OPTIONAL_TOOLS' function
if [ -z "${HADOOP_HOME}" ] && [ -n "${HADOOP_OPTIONAL_TOOLS}" ] \
    && [ -x "${SPARK_HOME}/hadoop/bin/hadoop-tools.sh" ]; then
  SPARK_DIST_CLASSPATH+=":$(${SPARK_HOME}/hadoop/bin/hadoop-tools.sh)"
fi
