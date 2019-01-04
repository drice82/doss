FROM python:2.7.15-alpine3.8

COPY /root /
COPY entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

WORKDIR /shadowsocksr

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]

CMD ["python", "/shadowsocksr/server.py"]
