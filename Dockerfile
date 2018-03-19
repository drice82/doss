FROM python:2.7.14-alpine
RUN apk update && apk add \
        libsodium \
        wget \
    && pip install cymysql \
    && rm -rf /tmp/*

COPY /root /
#COPY run.sh /run.sh
#RUN chmod u+rwx /run.sh

EXPOSE 8012
EXPOSE 9001
EXPOSE 6666
EXPOSE 20000-23000

#ENTRYPOINT ["/run.sh"]

CMD ["python", "/shadowsocks/server.py"]
