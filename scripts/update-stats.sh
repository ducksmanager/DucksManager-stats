#!/bin/bash

sh_dir=/home/scripts
csv_results_dir=${sh_dir}/csv_results

envvars=(\
  MYSQL_HOST \
  MYSQL_DM_DATABASE \
  MYSQL_HOST \
  MYSQL_DM_STATS_DATABASE \
  MYSQL_HOST \
  MYSQL_COA_DATABASE \
  MYSQL_PASSWORD \
  csv_results_dir \
)

for envvar in "${envvars[@]}"; do
  [ -z "${!envvar}" ] && echo "$envvar is empty, aborting" && exit 1
done

find ${sh_dir}/sql -name '*.sql' | while read -r file; do
  for envvar in "${envvars[@]}"; do
    sed -i "s#$envvar#${!envvar}#g" $file
  done
done

. ${sh_dir}/1_init-db.sh && \
. ${sh_dir}/2_calculate-stats.sh && \
. ${sh_dir}/3_rename-db.sh
