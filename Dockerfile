FROM phusion/baseimage:0.11 as builder

RUN apt-get update
RUN apt-get install curl -y
RUN curl -L -o /tmp/go.sh https://install.direct/go.sh
RUN chmod +x /tmp/go.sh
RUN /tmp/go.sh

FROM phusion/baseimage:0.11

COPY --from=builder /usr/bin/v2ray/v2ray /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/v2ctl /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geoip.dat /usr/bin/v2ray/
COPY --from=builder /usr/bin/v2ray/geosite.dat /usr/bin/v2ray/

# 设置正确的环境变量.
ENV HOME /root
ENV PATH /usr/bin/v2ray:$PATH

#copy app and config
COPY /root/v2ray/config.json /etc/v2ray/config.json
COPY /root/v2muser /usr/bin/v2muser/
COPY /root/caddy/Caddyfile /etc/caddy/Caddyfile
COPY /root/serverstatus/client-linux.py /usr/bin/srvstatus/

# 生成SSH keys,baseimage-docker不包含任何的key,所以需要你自己生成.你也可以注释掉这句命令,系统在启动过程中,会生成一个.
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# 初始化baseimage-docker系统
CMD ["/sbin/my_init"]

# 这里可以放置你自己需要构建的命令
RUN apt-get update \
    && apt-get install -y python vnstat iproute2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
#创建init和runit app的文件夹
    && mkdir -p /etc/my_init.d \
    && mkdir /etc/service/v2ray \
    && mkdir /etc/service/srvstatus \
    && mkdir /etc/service/v2muser

#install caddy
RUN curl https://getcaddy.com | bash -s personal

#copy init
COPY /init/v2muser_config.sh /etc/my_init.d/v2muser_config.sh
COPY /init/caddy_config.sh /etc/my_init.d/caddy_config.sh
COPY /init/srvstatus_config.sh /etc/my_init.d/srvstatus_config.sh

#copy scripts
COPY /runit/v2ray.sh /etc/service/v2ray/run
COPY /runit/v2muser.sh /etc/service/v2muser/run
COPY /runit/caddy.sh /etc/service/caddy/run
COPY /runit/status.sh /etc/service/srvstatus/run

#文件权限
RUN chmod u+x /etc/service/v2ray/run \
    && chmod u+x /etc/my_init.d/v2muser_config.sh \
    && chmod u+x /etc/service/v2muser/run \
    && chmod u+x /etc/my_init.d/caddy_config.sh \
    && chmod u+x /etc/service/caddy/run \
    && chmod u+x /etc/my_init.d/srvstatus_config.sh \
    && chmod u+x /etc/service/srvstatus/run


EXPOSE 80 443 8081
