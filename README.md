# doss
docker shadowsocks
mysql config file: /root/shadowsocks/usermysql.conf

docker build -t doss:v0.1 .

docker run -d \
--net=host \
-e MYSQL_HOST=mysqlhost \
-e MYSQL_PORT=mysqlport \
-e MYSQL_USER=mysqluser \
-e MYSQL_PASSWORD=mysqlpasswd \
-e MYSQL_DBNAME=mysqldb \
doss:v1
