FROM php:7.1.10-apache-jessie

LABEL maintainer="yinguowei@gmail.com"

ENV ZENTAO_VERSION 9.5.1
#ENV DEBIAN_FRONTEND noninteractive

# 安装 zip
#RUN set -x \
#    && apt-get -y update \
#    && apt-get install -y --no-install-recommends zip \
#    && rm -rf /var/lib/apt/lists/*

#RUN apt-get autoremove \
#    && apt-get autoclean \
#    && apt-get dist-upgrade

RUN apt-get -y update \
    && apt-get install -y --no-install-recommends apt-utils unzip \
    && rm -rf /var/lib/apt/lists/*

# 安装禅道需要的组件
RUN docker-php-ext-install -j$(nproc) pdo_mysql \
    && mkdir /php_session_path \
    && chmod o=rwx -R /php_session_path \
    && echo "session.save_path = \"/php_session_path\"">>/usr/local/etc/php/php.ini

# 获取源码包
ADD https://nchc.dl.sourceforge.net/project/zentao/$ZENTAO_VERSION/ZenTaoPMS.$ZENTAO_VERSION.zip /var/www/html/
#ADD ZenTaoPMS.$ZENTAO_VERSION.zip /var/www/html/

# 解压
RUN unzip /var/www/html/ZenTaoPMS.$ZENTAO_VERSION.zip && rm -f /var/www/html/ZenTaoPMS.$ZENTAO_VERSION.zip

# 备份目录挂载卷
VOLUME /var/www/html/zentaopms/tmp/backup
