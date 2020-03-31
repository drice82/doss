
FROM phusion/baseimage:0.11


# 设置正确的环境变量.
ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 10109
ENV PASSWORD=
ENV METHOD	chacha20-ietf-poly1305
ENV TIMEOUT	300
ENV DNS_ADDRS	8.8.8.8,8.8.4.4
ENV TZ UTC
ENV ARGS=

#copy app and config
COPY /root/serverstatus/client-linux.py /usr/bin/srvstatus/

# 生成SSH keys,baseimage-docker不包含任何的key,所以需要你自己生成.你也可以注释掉这句命令,系统在启动过程中,会生成一个.
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# 初始化baseimage-docker系统
CMD ["/sbin/my_init"]

# 这里可以放置你自己需要构建的命令
RUN apt-get update \
    && apt-get install -y iproute2 shadowsocks-libev \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 

#copy init
COPY /init /etc/my_init.d/

#copy scripts
COPY /runit /etc/service/

#文件权限
RUN chmod u+x /etc/service/srvstatus/run \
    && chmod u+x /etc/service/ss-server/run \
    && chmod u+x /etc/my_init.d/* 

EXPOSE 10109
