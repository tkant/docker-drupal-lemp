# Usage
```
docker build -t rda_database .
sudo docker run -d -v /home/dawg/db_data:/var/lib/mysql -p 3306:3306 rda_database
docker logs <CONTAINER_ID>
mysql -uadmin -pl0b7V8cjR3Pr -h127.0.0.1
```

### To get IP Address of machine
```
sudo docker inspect <CONTAINER_ID>
172.17.0.2
```