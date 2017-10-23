FROM php:7.1.10-apache-jessie

# 安装 zip
RUN set -x \
    && apt-get -y update \
    && apt-get install -y zip \
    && rm -rf /var/lib/apt/lists/*

# 安装禅道需要的组件
RUN docker-php-ext-install -j$(nproc) pdo_mysql \
    && mkdir /php_session_path \
    && chmod o=rwx -R /php_session_path \
    && echo "session.save_path = \"/php_session_path\"">>/usr/local/etc/php/php.ini

# 获取源码包
ADD https://nchc.dl.sourceforge.net/project/zentao/9.5.1/ZenTaoPMS.9.5.1.zip /var/www/html/
#ADD ZenTaoPMS.9.5.1.zip /var/www/html/

# 解压
RUN unzip /var/www/html/ZenTaoPMS.9.5.1.zip && rm -f /var/www/html/ZenTaoPMS.9.5.1.zip

# 备份目录挂载卷
VOLUME /var/www/html/zentaopms/tmp/backup
