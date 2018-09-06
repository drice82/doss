FROM phusion/baseimage:v0.11
    
RUN apt-get update \
    && apt-get install -y python-pip libsodium18 \
    && pip install cymysql \
    && rm -rf /tmp/*
    
COPY /root /
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+rwx /entrypoint.sh

WORKDIR /shadowsocksr

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]

CMD ["python", "/shadowsocksr/server.py"]
