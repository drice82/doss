FROM python:2.7.15-alpine
ENV MYSQL_PORT=3306 SETMUL=1.0 TZ="Asia/Shanghai"
COPY /root /
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
WORKDIR /shadowsocksr
EXPOSE 443
ENTRYPOINT ["/entrypoint.sh"]
