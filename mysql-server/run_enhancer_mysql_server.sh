docker container stop  enhancer_mysql_server_container
docker container kill enhancer_mysql_server_container
docker container rm enhancer_mysql_server_container


docker container run \
  -d \
  --name enhancer_mysql_server_container \
  -e MYSQL_ROOT_PASSWORD=123456 \
  -e MYSQL_DATABASE=phoenix_enhancer \
  -e MYSQL_USER=phoenix_enhancer \
  -e MYSQL_USER_PASSWORD=enhancer123 \
  -p 0.0.0.0:9999:3306 \
  phoenixenhancer/enhancer-mysql-server

