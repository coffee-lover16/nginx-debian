FROM debian:9 AS build

# install packages
RUN apt update && apt install -y wget gcc libpcre3 libpcre3-dev zlib1g zlib1g-dev make
# download nginx
RUN wget http://nginx.org/download/nginx-1.7.10.tar.gz && tar xvfz nginx-1.7.10.tar.gz

WORKDIR /nginx-1.7.10

# install nginx with default configuration
RUN ./configure && make && make install

# EXPOSE 8081/tcp
FROM debian:9

WORKDIR /usr/local/nginx
# copy all the content of the /usr/local/nginx - where nginx server is installed
COPY --from=build /usr/local/nginx/ .
# by default nginx is run under tcp 80 port
EXPOSE 80/tcp

CMD ["./sbin/nginx", "-g", "daemon off;"]
