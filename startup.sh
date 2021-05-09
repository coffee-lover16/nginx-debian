# build container
docker build -t nginx1
# run container
docker run --name nginx1 -d -p 8081:80/tcp --rm nginx1
