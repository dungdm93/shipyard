`postgresql`
============

## 1. Tuning Your PostgreSQL Server
* Inc `max_connections`
    ```sql
    ALTER SYSTEM SET max_connections = 1024;
    ALTER SYSTEM SET shared_buffers = '1024MB';
    ```

    ref:
    * https://stackoverflow.com/a/32584211
    * https://www.postgresql.org/docs/current/sql-altersystem.html
    * https://www.postgresql.org/docs/current/sql-show.html
