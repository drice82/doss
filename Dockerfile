FROM phusion/baseimage:0.10.2
    
RUN apt-get update \
    && apt-get install -y python-pip \
    && pip install cymysql \
    && rm -rf /tmp/*
    
COPY /root /
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+rwx /entrypoint.sh

WORKDIR /shadowsocksr

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]

CMD ["python", "/shadowsocksr/server.py"]
