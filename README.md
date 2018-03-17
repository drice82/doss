# doss
docker shadowsocks
docker run -d --name=doss \
-p 20000-25000:20000-25000 \
-p 8012:8012 \
-p 9001:9001 \
-p 6666:6666 \
doss:v0.1
