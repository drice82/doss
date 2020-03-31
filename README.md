# doss
docker ss manyuser

### git
        git clone https://github.com/drice82/doss/
### build
        docker build -t doss:0.1 .

### run
docker run -d \
--name=Mipha \
--restart=always \
-p 10109:10109 \
-p 10109:10109/udp \
-e PASSWORD='passwd' \
-e STATUS_ADDRESS=address \
-e STATUS_USER=s03 \
doss:0.1

### connection information
port: 443
Pubpassword: pubpwd
method: aes-128-ctf
protocol: auth_aes128_md5
protocol_param: userport:userpassword
obfs: tls1.2_ticket_auth
