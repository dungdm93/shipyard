#!/usr/bin/env bash

if hadoop_verify_entry HADOOP_TOOLS_OPTIONS "hadoop-gcs"; then
  hadoop_add_profile "hadoop-gcs"
fi

function _hadoop-gcs_hadoop_classpath
{
  local jar="${HADOOP_TOOLS_HOME}/${HADOOP_TOOLS_LIB_JARS_DIR}/gcs-connector-hadoop3-2.1.4.jar"
  if [[ -f "$jar" ]]; then
    hadoop_add_classpath "$jar"
  fi
}
