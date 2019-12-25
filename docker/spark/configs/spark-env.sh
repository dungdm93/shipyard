JAVA_HOME="$(readlink -f /usr/bin/java | sed "s:/bin/java::")"

HADOOP_CONF_DIR="${HADOOP_CONF_DIR:-$HADOOP_HOME/etc/hadoop}"
YARN_CONF_DIR="${YARN_CONF_DIR:-$HADOOP_HOME/etc/hadoop}"
HDFS_CONF_DIR="${HDFS_CONF_DIR:-$HADOOP_HOME/etc/hadoop}"

SPARK_DIST_CLASSPATH="$(${HADOOP_HOME}/bin/hadoop classpath)"
if [ ! -z "${SPARK_EXTRA_CLASSPATH}" ]; then
    SPARK_DIST_CLASSPATH="${SPARK_DIST_CLASSPATH}:${SPARK_EXTRA_CLASSPATH}"
fi
