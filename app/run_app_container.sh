#!/bin/bash
docker container stop enhancer_web_app_container
docker container rm enhancer_web_app_container

#docker container rm enhancer_web_app_container

docker container run \
	  -d \
	  --name enhancer_web_app_container \
	  -p 4202:4200 \
	  phoenixenhancer/enhancer-web-app


#	  --rm \

#copy the modified config file into container
docker cp  config-docker.json enhancer_web_app_container:/app/assets/config/.

#reload nginx service 
docker exec enhancer_web_app_container sh -c "nginx -s reload"
