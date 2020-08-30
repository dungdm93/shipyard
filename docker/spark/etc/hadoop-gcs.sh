#!/usr/bin/env bash

if hadoop_verify_entry HADOOP_TOOLS_OPTIONS "hadoop-gcs"; then
  hadoop_add_profile "hadoop-gcs"
fi

function _hadoop-gcs_hadoop_classpath
{
  if [[ -f "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/gcs-connector-hadoop3-2.1.4.jar" ]]; then
    hadoop_add_classpath "${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/gcs-connector-hadoop3-2.1.4.jar"
  fi
}
