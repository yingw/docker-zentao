FROM php:7.2.8-apache-stretch

LABEL maintainer="yinguowei@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
    && apt-get -y update \
    && apt-get install -y --no-install-recommends apt-utils unzip \
    && rm -rf /var/lib/apt/lists/*

# 安装禅道需要的组件
RUN docker-php-ext-install -j$(nproc) pdo_mysql \
    && mkdir /php_session_path \
    && chmod o=rwx -R /php_session_path \
    && echo "session.save_path = \"/php_session_path\"">>/usr/local/etc/php/php.ini

ENV ZENTAO_VERSION 9.8.3

# 获取源码包
ADD http://dl.cnezsoft.com/zentao/$ZENTAO_VERSION/ZenTaoPMS.$ZENTAO_VERSION.zip /var/www/html/

# 解压
RUN unzip /var/www/html/ZenTaoPMS.$ZENTAO_VERSION.zip && rm -f /var/www/html/ZenTaoPMS.$ZENTAO_VERSION.zip

RUN echo "<html>\n<head>\n<meta http-equiv=\"refresh\" content=\"0;url=/zentaopms/www/\">\n</head>\n</html>" > /var/www/html/index.html

# 备份目录挂载卷
RUN mkdir -p /var/www/html/zentaopms/tmp/backup && chmod 777 /var/www/html/zentaopms/tmp/backup
VOLUME /var/www/html/zentaopms/tmp/backup