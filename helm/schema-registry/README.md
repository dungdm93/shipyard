schema-registry
===============

## 1. Launching stack
```bash
/etc/confluent/docker/launch
└── /usr/bin/${COMPONENT}-start
    └── /usr/bin/${COMPONENT}-run-class
```

## 2. Docker Configuration Parameters
For the Schema Registry (`cp-schema-registry`) image, convert the property variables as below and use them as environment variables:
* Prefix with `SCHEMA_REGISTRY_`.
* Convert to upper-case.
* Replace a period (`.`) with a single underscore (`_`).
* Replace a dash (`-`) with double underscores (`__`).
* Replace an underscore (`_`) with triple underscores (`___`).

[ref](https://docs.confluent.io/platform/current/installation/docker/config-reference.html#sr-long-configuration)

## 3. Generic envs:
* `SCHEMA_REGISTRY_OPTS=""`
* `SCHEMA_REGISTRY_JMX_OPTS="-Dcom.sun.management.jmxremote ..."`
* `SCHEMA_REGISTRY_LOG4J_OPTS="-Dlog4j.configuration=file:/etc/kafka-rest/log4j.properties"`
* `SCHEMA_REGISTRY_HEAP_OPTS="-Xmx256M"`

## 4. Metrics
* [ref](https://docs.confluent.io/platform/current/schema-registry/monitoring.html)
* [jmx-opts](https://docs.confluent.io/platform/current/installation/docker/operations/monitoring.html)
