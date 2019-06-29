# 使用phusion/baseimage作为基础镜像,去构建你自己的镜像,需要下载一个明确的版本,千万不要使用`latest`.
# 查看https://github.com/phusion/baseimage-docker/blob/master/Changelog.md,可用看到版本的列表.
FROM phusion/baseimage:0.11

# 设置正确的环境变量.
ENV HOME /root

# 生成SSH keys,baseimage-docker不包含任何的key,所以需要你自己生成.你也可以注释掉这句命令,系统在启动过程中,会生成一个.
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh

# 初始化baseimage-docker系统
CMD ["/sbin/my_init"]

# 这里可以放置你自己需要构建的命令
RUN apt-get update \
    && apt-get install -y iproute2 python python-pip gawk vnstat python-dev build-essential libssl-dev libffi-dev libxml2-dev libxslt1-dev zlib1g-dev \
    && pip install psutil \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
#创建init和runit app的文件夹
    && mkdir -p /etc/my_init.d \
    && mkdir /etc/service/ssr \
    && mkdir /etc/service/status

#copy application
COPY /root /

#copy init
COPY /init/ss_config.sh /etc/my_init.d/ss_config.sh
COPY /init/srvstatus-config.sh /etc/my_init.d/srvstatus-config.sh

#copy scripts
COPY /runit/ssr.sh /etc/service/ssr/run
COPY /runit/status.sh /etc/service/status/run

#文件权限
RUN chmod u+x /etc/my_init.d/ss_config.sh \
    && chmod u+x /etc/my_init.d/srvstatus-config.sh \
    && chmod u+x /etc/service/ssr/run \
    && chmod u+x /etc/service/status/run

EXPOSE 443
