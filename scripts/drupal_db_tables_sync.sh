#!/bin/bash

# Local variables
mysql_path="/usr/local/mysql/bin/mysql"
db_user="root"
db_password="19GdB*82"
db_active="drupal_taxonomy"
db_source="drupal"
db_prefix="main"

# Log into mysql and source that sucker
echo "* Getting a list of tables that start with the specified prefix"
table_listing=$($mysql_path -u$db_user -p$db_password << eof
use $db_source;
show tables like "${db_prefix}%"
eof)

for table in $table_listing; do
  if [[ $table == $db_prefix* ]]; then
    echo "* Updating table $table from source database $db_source"
    $mysql_path -u$db_user -p$db_password << eof
drop table if exists ${db_active}.${table};
create table ${db_active}.${table} like ${db_source}.$table;
insert into ${db_active}.${table} SELECT * FROM ${db_source}.$table;
eof
  fi
done
