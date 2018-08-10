#!/bin/sh
dropAndCreateDBQuery="DROP DATABASE IF EXISTS ${MYSQL_DM_STATS_DATABASE}_new;CREATE DATABASE ${MYSQL_DM_STATS_DATABASE}_new"

cd /home/scripts/sql

# Create database ${MYSQL_DM_STATS_DATABASE}_new
mysql -v -uroot -p${MYSQL_PASSWORD} -h ${MYSQL_DM_STATS_HOST} -e "$dropAndCreateDBQuery"
mysql -v -uroot -p${MYSQL_PASSWORD} -h ${MYSQL_DM_STATS_HOST} ${MYSQL_DM_STATS_DATABASE}_new < ddl/derived-from-dm/auteurs_pseudos_simple.sql
mysql -v -uroot -p${MYSQL_PASSWORD} -h ${MYSQL_DM_STATS_HOST} ${MYSQL_DM_STATS_DATABASE}_new < ddl/derived-from-dm/numeros_simple.sql
mysql -v -uroot -p${MYSQL_PASSWORD} -h ${MYSQL_DM_STATS_HOST} ${MYSQL_DM_STATS_DATABASE}_new < ddl/create-stats-tables.sql

# Temporarily re-create auteurs_pseudos_simple in the COA host (in a new DB) to perform stats operations
mysql -uroot -p${MYSQL_PASSWORD} -h ${MYSQL_COA_HOST} -e "$dropAndCreateDBQuery"

mysql -uroot -p${MYSQL_PASSWORD} -h ${MYSQL_COA_HOST} ${MYSQL_DM_STATS_DATABASE}_new < ddl/derived-from-dm/auteurs_pseudos_simple.sql
