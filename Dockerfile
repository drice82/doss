FROM python:2.7.15-alpine

COPY /root /
COPY entrypoint.sh /entrypoint.sh

RUN chmod u+x /entrypoint.sh

WORKDIR /shadowsocksr

EXPOSE 8000-24000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["python", "/shadowsocksr/server.py"]
