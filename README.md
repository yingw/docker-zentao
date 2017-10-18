# docker-zentao
'Zentao'（禅道 http://www.zentao.net） docker files.

## dockerfiles

- version 9.5.1 [dockerfile](https://github.com/yingw/docker-zentao/blob/master/dockerfile)
- version 9.2.1
- Zentao Pro (for Trial) [dockerfile](https://github.com/yingw/docker-zentao/blob/master/README.md)

## Requirement

docker version >= 1.12

docker-compose version >= 1.13

## Run

```
docker run -d --restart=always -p=1080:80 -v=/opt/zbox:/opt/zbox --name=zentao yinguowei/zentao
```

Or

```
docker run yinguowei/zentao:9.5.1
```

访问：
Visit website： https://LOCALHOST_IP:1080/
default user/passwd: admin/123456
