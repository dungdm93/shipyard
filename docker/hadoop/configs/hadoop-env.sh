export JAVA_HOME="${JAVA_HOME:-$(readlink -f "$(which java)" | sed "s:/bin/java::")}"

export HADOOP_OS_TYPE="${HADOOP_OS_TYPE:-$(uname -s)}"
export HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${HADOOP_HOME}/share/hadoop/tools/lib/*"
