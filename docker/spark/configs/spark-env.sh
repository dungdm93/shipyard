JAVA_HOME="${JAVA_HOME:-$(readlink -f "$(which java)" | sed "s:/bin/java::")}"

if [ -n "${HADOOP_HOME}"  ] && [ -z "${SPARK_DIST_CLASSPATH}"  ]; then
  SPARK_DIST_CLASSPATH="$(${HADOOP_HOME}/bin/hadoop classpath)"
fi
