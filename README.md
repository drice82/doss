# doss
docker ss manyuser

git clone https://github.com/drice82/doss/

docker build -t doss:0.1 .

docker run -d \\
--net=host \\
-e MYSQL_HOST=mysqlhost \\
-e MYSQL_PORT=mysqlport \\
-e MYSQL_USER=mysqluser \\
-e MYSQL_PASSWORD=mysqlpasswd \\
-e MYSQL_DBNAME=mysqldb \\
-e SETMUL=1.0 \\
doss:0.1
