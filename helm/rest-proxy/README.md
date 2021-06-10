rest-proxy
==========

## 1. Launching stack
```bash
/etc/confluent/docker/launch
└── /usr/bin/${COMPONENT}-start
    └── /usr/bin/${COMPONENT}-run-class
```

## 2. Docker Configuration Parameters
The Confluent REST Proxy (`cp-kafka-rest`) image uses the REST Proxy configuration setting names. Convert the REST Proxy settings to environment variables as below:
* Prefix with `KAFKA_REST_`.
* Convert to upper-case.
* Replace a period (`.`) with a single underscore (`_`).
* Replace a dash (`-`) with double underscores (`__`).
* Replace an underscore (`_`) with triple underscores (`___`).

[ref](https://docs.confluent.io/platform/current/installation/docker/config-reference.html#crest-long-configuration)

## 3. Generic envs:
* `KAFKAREST_OPTS=""`
* `KAFKAREST_JMX_OPTS="-Dcom.sun.management.jmxremote ..."`
* `KAFKAREST_LOG4J_OPTS="-Dlog4j.configuration=file:/etc/kafka-rest/log4j.properties"`
* `KAFKAREST_HEAP_OPTS="-Xmx256M"`

## 4. Metrics
* [ref](https://docs.confluent.io/platform/current/kafka-rest/production-deployment/rest-proxy/monitoring.html)
* [jmx-opts](https://docs.confluent.io/platform/current/installation/docker/operations/monitoring.html)
