#!/bin/sh

PATH=/bin:/sbin:$PATH
 
set -e
 
if [ "${1:0:1}" = '-' ]; then
    set -- python "$@"
fi
   
sed -ri "s/mysqlhost/$MYSQL_HOST/g" /shadowsocksr/usermysql.json
sed -ri "s/mysqlport/$MYSQL_PORT/g" /shadowsocksr/usermysql.json
sed -ri "s/mysqluser/$MYSQL_USER/g" /shadowsocksr/usermysql.json
sed -ri "s/mysqlpwd/$MYSQL_PASSWORD/g" /shadowsocksr/usermysql.json
sed -ri "s/mysqldb/$MYSQL_DBNAME/g" /shadowsocksr/usermysql.json
sed -ri "s/setmul/$SETMUL/g" /shadowsocksr/usermysql.json
  
exec python /shadowsocksr/server.py
