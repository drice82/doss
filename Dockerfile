FROM python:2

WORKDIR /usr/src/app

RUN pip install cymysql

COPY /root /
#ADD enterpoint.sh /enterpoint.sh
#RUN chmod +x /enterpoint.sh

EXPOSE 8012
EXPOSE 20000-23000

#ENTRYPOINT ["/enterpoint.sh"]

CMD ["python", "/shadowsocks/server.py"]
