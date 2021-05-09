FROM debian:9 as build

# install packages
RUN apt update && apt install -y wget gcc libpcre3 libpcre3-dev zlib1g zlib1g-dev make
# download nginx
RUN wget http://nginx.org/download/nginx-1.0.5.tar.gz && tar xvfz nginx-1.0.5.tar.gz

WORKDIR ./nginx-1.0.5

# install nginx with default configuration
RUN ./configure && make && make install

EXPOSE 8081/tcp
# FROM debian:9

# # RUN mkdir /usr/local/nginx/sbin
# WORKDIR /usr/local/
# COPY --from=build /usr/local/nginx/* .
# WORKDIR /usr/local/nginx/sbin
# RUN mkdir ../logs ../conf && touch ../logs/error.log && chmod +x nginx
# CMD ["./nginx", "-g", "daemon off;"]
CMD echo test...
