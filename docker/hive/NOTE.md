NOTE
====

## 0. Hive Standalone Metastore
* [Tutorial](https://techjogging.com/standalone-hive-metastore-presto-docker.html)
* [AdminManual Guide](https://cwiki.apache.org/confluence/display/Hive/AdminManual+Metastore+3.0+Administration)

## 1. Known Issues
* Hive 3.1.2 incompatible with Hadoop 3.1.1+
* Missing JDBC drivers: MySQL, Microsoft SQL Server, Oracle

## 2. Improvement
* Use Ivy to download extra packages (`HIVE_EXTRA_PACKAGES` comma seperated, package in format `groupId:artifactId:version`)
* Script auto init/upgrade database

## 3. Commands
```bash
schematool -dbType <databaseType> -initSchema -verbose
schematool -dbType <databaseType> -upgradeSchema -verbose
schematool -dbType <databaseType> -info

hive --service metastore
```
