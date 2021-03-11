
example docker compose
```
version: '3'
services:
  db:
    image: mariadb:10.4
    volumes:
      - odm-db-data:/var/lib/mysql
    environment:
      - MYSQL_DATABASE=opendocman
      - MYSQL_USER=opendocman
      - MYSQL_PASSWORD=opendocman
      - MYSQL_ROOT_PASSWORD=rootpass
    ports:
      - 3306:3306


  app:
    build: .
    depends_on:
      - db
    ports:
      - 80:80
      - 443:443
      - 9000:9000
    hostname: odm.local
    environment:
      - APP_DB_HOST=db
      - DB_PORT=3306
      - APP_DB_NAME=opendocman
      - APP_DB_USER=opendocman
      - APP_DB_PASS=opendocman
      - ODM_DATA_DIR=/var/www/document_repository
      - IS_DOCKER=true
    command: ["./wait-for-mysql.sh", "db", "/start.sh"]
    volumes:
      - odm-files-data:/var/www/document_repository
      - odm-docker-configs:/var/www/html/docker-configs

volumes:
  odm-files-data:
  odm-db-data:
  odm-docker-configs:
```