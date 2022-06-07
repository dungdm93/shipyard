#!/usr/bin/env bash

if hadoop_verify_entry HADOOP_TOOLS_OPTIONS "hadoop-bigquery"; then
  hadoop_add_profile "hadoop-bigquery"
fi

function _hadoop-bigquery_hadoop_classpath
{
  # BigQuery connector for Hadoop
  local jar="${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/bigquery-connector-hadoop3-1.1.4.jar"
  if [[ -f "$jar" ]]; then
    hadoop_add_classpath "$jar"
  fi

  # BigQuery connector for Spark
  local jar="${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/spark-bigquery-with-dependencies_2.12-0.17.1.jar"
  if [[ -f "$jar" ]]; then
    hadoop_add_classpath "$jar"
  fi
}
