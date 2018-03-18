#!/bin/sh

sed -ri 's/inputhost/$MYSQL_HOST/' /shadowsocks/usermysql.json
sed -ri 's/inputport/$MYSQL_PORT/' /shadowsocks/usermysql.json
sed -ri 's/inputuser/$MYSQL_USER/' /shadowsocks/usermysql.json
sed -ri 's/inputpassword/$MYSQL_PASSWORD/' /shadowsocks/usermysql.json
sed -ri 's/inputdb/$MYSQL_DBNAME/' /shadowsocks/usermysql.json
sed -ri 's/inputmul/1.0/' /shadowsocks/usermysql.json
