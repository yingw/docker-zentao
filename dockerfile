FROM php:7.2.8-apache-stretch

LABEL maintainer="yinguowei@gmail.com"

ENV DEBIAN_FRONTEND noninteractive

RUN set -x \
    && apt-get -y update \
    && apt-get install -y --no-install-recommends apt-utils unzip libldap2-dev \
    && rm -rf /var/lib/apt/lists/*

# 安装禅道需要的组件
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
  && docker-php-ext-install -j$(nproc) pdo_mysql \
  && docker-php-ext-install ldap \
  && mkdir /php_session_path \
  && chmod o=rwx -R /php_session_path \
  && echo "session.save_path = \"/php_session_path\"">>/usr/local/etc/php/php.ini

ENV ZENTAO_VERSION 10.4

# 获取源码包
#ADD http://dl.cnezsoft.com/zentao/$ZENTAO_VERSION/ZenTaoPMS.$ZENTAO_VERSION.stable.zip /var/www/html/
ADD ZenTaoPMS.$ZENTAO_VERSION.stable.zip /var/www/html/
RUN unzip /var/www/html/ZenTaoPMS.$ZENTAO_VERSION.stable.zip && rm -f /var/www/html/ZenTaoPMS.$ZENTAO_VERSION.stable.zip

WORKDIR /var/www/html/zentaopms

# 准备工作，目录，权限
RUN touch www/ok.txt \
  && mkdir -p lib/ldap \
  && chmod 777 . \
  && chmod -R 777 lib/ldap \
  && chmod -R 777 module/user/ext \
  && mkdir -p /var/www/html/zentaopms/tmp/backup \
  && chmod 777 /var/www/html/zentaopms/tmp/backup

# LDAP 插件
#RUN curl -o module/extension/ext/ldap-master.zip https://codeload.github.com/iboxpay/ldap/zip/master \
ADD /ldap-master.zip module/extension/ext/
RUN unzip module/extension/ext/ldap-master.zip -d module/extension/ext/ \
  && mv module/extension/ext/ldap-master module/extension/ext/ldap \
  && cp -r module/extension/ext/ldap/lib/* lib/ \
  && cp -r module/extension/ext/ldap/module/* module/ \
  && mkdir -p tmp/extension/ \
  && mv module/extension/ext/ldap-master.zip tmp/extension/ldap.zip

# 加上自动跳转页面  
RUN echo "<html>\n<head>\n<meta http-equiv=\"refresh\" content=\"0;url=/zentaopms/www/\">\n</head>\n</html>" > /var/www/html/index.html

# LDAP 相关环境变量
ENV LDAP_HOST=10.229.253.36
ENV LDAP_PORT=389
ENV LDAP_ROOT_DN=dc=wilmar,dc=cn
ENV LDAP_UID_FIELD=sAMAccountName
ENV LDAP_BIND_DN=yourdn@wilmar.cn
ENV LDAP_BIND_PASSWORD=yourpassword
ENV LDAP_DOMAIN=wilmar.cn

# ldap.php
RUN sed -i 's/^\$config->ldap->ldap_server.*$/\$config->ldap->ldap_server = '\''ldap:\/\/'\'' \. getenv('\''LDAP_HOST'\'') \. '\'':'\'' \. getenv('\''LDAP_PORT'\'');/' module/user/ext/config/ldap.php \
  && sed -i 's/^\$config->ldap->ldap_root_dn.*$/\$config->ldap->ldap_root_dn = getenv('\''LDAP_ROOT_DN'\'');/' module/user/ext/config/ldap.php \
  && sed -i 's/^\$config->ldap->ldap_uid_field.*$/\$config->ldap->ldap_uid_field = getenv('\''LDAP_UID_FIELD'\'');/' module/user/ext/config/ldap.php \
  && sed -i 's/^\$config->ldap->ldap_bind_dn.*$/\$config->ldap->ldap_bind_dn = getenv('\''LDAP_BIND_DN'\'');/' module/user/ext/config/ldap.php \
  && sed -i 's/^\$config->ldap->ldap_bind_passwd.*$/\$config->ldap->ldap_bind_passwd = getenv('\''LDAP_BIND_PASSWORD'\'');/' module/user/ext/config/ldap.php \
  && sed -i 's/#\$config->ldap->ldap_organization/\$config->ldap->ldap_organization/' module/user/ext/config/ldap.php

# login.js
RUN sed -i 's/md5(md5(password) + rand)/password/' module/user/js/login.js

# ldap.class.php 
# $t_dn = $t_info[$i]['dn']; 改为：  $t_dn = "{$t_info[$i]['samaccountname'][0]}@{$_ENV['LDAP_DOMAIN']}";
RUN sed -i 's/$t_dn =.*$/$t_dn = $t_info[$i]['\''samaccountname'\''][0] . "@" . $_ENV['\''LDAP_DOMAIN'\''];/' lib/ldap/ldap.class.php

# 备份目录挂载卷
VOLUME /var/www/html/zentaopms/tmp/backup