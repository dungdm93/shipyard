#!/usr/bin/env bash

if hadoop_verify_entry HADOOP_TOOLS_OPTIONS "hadoop-bigquery"; then
  hadoop_add_profile "hadoop-bigquery"
fi

function _hadoop-bigquery_hadoop_classpath
{
  # BigQuery connector for Hadoop
  if [[ -f "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/bigquery-connector-hadoop3-1.1.4.jar" ]]; then
    hadoop_add_classpath "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/bigquery-connector-hadoop3-1.1.4.jar"
  fi

  # BigQuery connector for Spark
  if [[ -f "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/spark-bigquery-with-dependencies_2.12-0.17.1.jar" ]]; then
    hadoop_add_classpath "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/spark-bigquery-with-dependencies_2.12-0.17.1.jar"
  fi
}
