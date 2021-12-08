# a-blog cms Docker Images

## example

run docker-compose up

```
version: '2'
services:
    # mysql
    mysql:
        image: mysql:5.8
        ports:
            - "3306:3306"
        environment:
            MYSQL_ROOT_PASSWORD: root
    # proxy
    proxy:
        image: jwilder/nginx-proxy:latest
        volumes:
            - /var/run/docker.sock:/tmp/docker.sock:ro
        ports:
            - "80:80"
            - "443:443"
    # www
    www:
        image: atsu666/acms:8.0
        privileged: true
        volumes:
            - ./www:/var/www/html
            - /etc/localtime:/etc/localtime:ro
        links:
            - mysql:mysql
        environment:
            - VIRTUAL_HOST=example.lab
            - APACHE_DOCUMENT_ROOT=/var/www/html
```

