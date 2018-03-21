# doss
docker shadowsocks
mysql config file: /root/shadowsocks/usermysql.conf

docker build -t doss:v1 .

docker run -d \
--net=host \
-e MYSQL_HOST=mysqlhost \
-e MYSQL_PORT=mysqlport \
-e MYSQL_USER=mysqluser \
-e MYSQL_PASSWORD=mysqlpasswd \
-e MYSQL_DBNAME=mysqldb \
-e SETMUL=1.0 \
doss:v1
