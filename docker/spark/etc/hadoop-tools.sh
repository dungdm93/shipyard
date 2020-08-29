#!/usr/bin/env bash

export HADOOP_TOOLS_HOME=${HADOOP_TOOLS_HOME:-"${SPARK_HOME}/hadoop"}
export HADOOP_TOOLS_LIB_JARS_DIR=${HADOOP_TOOLS_LIB_JARS_DIR:-"lib/tools"}
export HADOOP_LIBEXEC_DIR=${HADOOP_LIBEXEC_DIR:-"${SPARK_HOME}/hadoop/libexec"}

source "${HADOOP_LIBEXEC_DIR}/hadoop-functions.sh"
hadoop_import_shellprofiles
hadoop_shellprofiles_classpath

echo "${CLASSPATH}"
