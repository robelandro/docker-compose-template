FROM apache/superset:latest

USER root

# Install PyMySQL globally so Superset sees it
RUN pip install --no-cache-dir pymysql

USER superset
