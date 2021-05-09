# build container
docker build -t nginx1 .
# run container
docker run --name nginx1 -d -p 8081:80/tcp --rm nginx1

# run container with configuration file in /conf/nginx.conf -> /usr/local/nginx/conf/nginx.conf
docker run --name nginx1 -d -p 8081:80/tcp --rm \
 --mount type=bind,source="$(pwd)"/conf/nginx.conf,target=/usr/local/nginx/conf/nginx.conf \
 nginx1

# nginx releases:
#
# http://nginx.org/download/
