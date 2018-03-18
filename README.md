# doss
docker shadowsocks
mysql config file: /root/shadowsocks/usermysql.conf

docker build -t doss:v0.1 .

docker run -d --net=host --restart=always doss:v0.1
