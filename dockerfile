FROM ubuntu:trusty

# 9.2.1 ok 的，版本是老的 9.2.1
# ADD https://ncu.dl.sourceforge.net/project/zentao/9.2.1/ZenTaoPMS.9.2.1.zbox_64.tar.gz /tmp
# 9.5.1 下载只有 100 多 k，不知道 why
# ADD https://nchc.dl.sourceforge.net/project/zentao/9.5.1/ZenTaoPMS.9.5.1.zbox_64.tar.gz /tmp/
ADD https://jaist.dl.sourceforge.net/project/zentao/9.5.1/ZenTaoPMS.9.5.1.zbox_64.tar.gz /tmp/

# PRO 专业版
# ADD   https://jaist.dl.sourceforge.net/project/zentao/Pro6.1/ZenTaoPMS.Pro6.1.stable.zbox_64.tar.gz  /tmp

RUN tar -zxvf /tmp/ZenTaoPMS.9.5.1.zbox_64.tar.gz -C /opt \
    && rm -rf /tmp/ZenTaoPMS.9.5.1.zbox_64.tar.gz /tmp/zbox*

COPY ./entrypoint.sh /usr/local/bin/

EXPOSE 80

ENTRYPOINT  ["/usr/local/bin/entrypoint.sh"]


#COPY  ./boot.sh   /usr/local/boot.sh
#RUN   chmod +x    /usr/local/boot.sh

#ENTRYPOINT  ["/usr/local/boot.sh"]



