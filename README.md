# docker-zentao
'Zentao'（禅道 http://www.zentao.net） docker files.

## dockerfiles

- version: 10.4.stable, 10, latest [dockerfile](https://github.com/yingw/docker-zentao/blob/master/dockerfile)
- version: 9.8.3, 9 [dockerfile](https://github.com/yingw/docker-zentao/blob/9/dockerfile)
- Zentao Pro (for Trial) [dockerfile](https://github.com/yingw/docker-zentao/blob/master/README.md)

## Requirement

- docker version >= 1.12
- docker-compose version >= 1.13

## Run

### Zentao V10
```
docker run -d --restart always \
  -p 80:80 -v /opt/zentao/backup:/var/www/html/zentaopms/tmp/backup\
  --name=zentao yinguowei/zentao
```

### Zentao V9
```
docker run -d --restart always \
  -p 80:80 -v /opt/zentao/backup:/var/www/html/zentaopms/tmp/backup \
  --name=zentao yinguowei/zentao:9
```

### Start with a mysql container

```
docker run -d --name mysql mysql
docker run -d --link mysql:mysql --name zentao yinguowei/zentao
```

### Or Start with a mysql using docker-compose

```
docker-compose up -d
```

Visit website： [http://localhost/](http://localhost/)
