FROM python:2.7.14-alpine
RUN apk update && apk add \
        libsodium \
        wget \
    && pip install cymysql \
    && rm -rf /tmp/*

COPY /root /
COPY run.sh /run.sh
RUN chmod u+rwx /run.sh

WORKDIR /shadowsocksr

EXPOSE 443

ENTRYPOINT ["/run.sh"]

CMD ["python", "/shadowsocksr/server.py"]
