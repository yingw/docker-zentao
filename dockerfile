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
ADD http://dl.cnezsoft.com/zentao/$ZENTAO_VERSION/ZenTaoPMS.$ZENTAO_VERSION.stable.zip /var/www/html/

# 解压
RUN unzip /var/www/html/ZenTaoPMS.$ZENTAO_VERSION.stable.zip && rm -f /var/www/html/ZenTaoPMS.$ZENTAO_VERSION.stable.zip

WORKDIR /var/www/html/zentaopms

# 准备工作，目录，权限
RUN touch ./www/ok.txt \
  && mkdir -p ./lib/ldap \
  && chmod 777 . \
  && chmod -R 777 ./lib/ldap \
  && chmod -R 777 ./module/user/ext \
  && mkdir -p /var/www/html/zentaopms/tmp/backup \
  && chmod 777 /var/www/html/zentaopms/tmp/backup

# LDAP 插件
RUN curl -o ./module/extension/ext/ldap-master.zip https://codeload.github.com/iboxpay/ldap/zip/master \
  && unzip ./module/extension/ext/ldap-master.zip -d ./module/extension/ext/ \
  && mv ./module/extension/ext/ldap-master ./module/extension/ext/ldap \
  && cp -r ./module/extension/ext/ldap/lib/* ./lib/ \
  && cp -r ./module/extension/ext/ldap/module/* ./module/ \
  && mkdir -p ./tmp/extension/ \
  && mv ./module/extension/ext/ldap-master.zip ./tmp/extension/ldap.zip

# 加上自动跳转页面  
RUN echo "<html>\n<head>\n<meta http-equiv=\"refresh\" content=\"0;url=/zentaopms/www/\">\n</head>\n</html>" > /var/www/html/index.html

# 备份目录挂载卷
VOLUME /var/www/html/zentaopms/tmp/backup