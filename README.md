# doss
docker ss manyuser

### git
        git clone https://github.com/drice82/doss/
### build
        docker build -t doss:0.1 .

### run
    docker run -d \
    -p 443:443 \
    -p 443:443/upd \
    --restart=always \
    -e MYSQL_HOST=mysqlhost \
    -e MYSQL_PORT=mysqlport \
    -e MYSQL_USER=mysqluser \
    -e MYSQL_PASSWORD=mysqlpasswd \
    -e MYSQL_DBNAME=mysqldb \
    -e SETMUL=1.0 \
    -e STATUS_ADDRESS=ip \
    -e STATUS_USER=us1 \
    doss:0.1

### connection information
port: 443
Pubpassword: pubpwd
method: aes-128-ctf
protocol: auth_aes128_md5
protocol_param: userport:userpassword
obfs: tls1.2_ticket_auth
