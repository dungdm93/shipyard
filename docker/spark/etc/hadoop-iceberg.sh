#!/usr/bin/env bash

if hadoop_verify_entry HADOOP_TOOLS_OPTIONS "hadoop-iceberg"; then
  hadoop_add_profile "hadoop-iceberg"
fi

function _hadoop-iceberg_hadoop_classpath
{
  local jars=(
    "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/"iceberg-spark-runtime-*.jar
  )
  for jar in "${jars[@]}"; do
    if [[ -f "$jar" ]]; then
        hadoop_add_classpath "$jar"
    fi
  done
}

if hadoop_verify_entry HADOOP_TOOLS_OPTIONS "hadoop-iceberg-aws"; then
  hadoop_add_profile "hadoop-iceberg"
  hadoop_add_profile "hadoop-iceberg-aws"
fi

function _hadoop-iceberg-aws_hadoop_classpath
{
  local jars=(
    "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}"/awssdk-bundle-*.jar
    "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}"/awssdk-url-connection-client-*.jar
  )
  for jar in "${jars[@]}"; do
    if [[ -f "$jar" ]]; then
        hadoop_add_classpath "$jar"
    fi
  done
}
