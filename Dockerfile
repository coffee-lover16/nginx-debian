FROM debian:9 AS build

# nevironment variables
#
# NGINX version, for LUA the we need min 1.6.0 version
ENV VER_NGINX=1.7.10
# nginx_devel_kit (NDK) versio
ENV VER_NGINX_DEVEL_KIT=0.2.19
# LUA NGINX module version
ENV VER_LUA_NGINX_MODULE=0.9.16
# LUA JIT version
ENV VER_LUAJIT=2.0.4

ENV NGINX_DEVEL_KIT ngx_devel_kit-${VER_NGINX_DEVEL_KIT}
ENV LUA_NGINX_MODULE lua-nginx-module-${VER_LUA_NGINX_MODULE}

# location of the LUA JIT (for NGINX)
ENV LUAJIT_LIB /usr/local/lib
ENV LUAJIT_INC /usr/local/include/luajit-2.0

# install packages
RUN apt update && apt install -y wget gcc libpcre3 libpcre3-dev zlib1g zlib1g-dev make

# download and untar:
#
# 1. Nginx
# 2. LUA JIT
# 3. nginx_devel_kit
# 4. LUA Nginx

# download nginx
RUN wget http://nginx.org/download/nginx-${VER_NGINX}.tar.gz && tar xvfz nginx-${VER_NGINX}.tar.gz
# download lua jit
RUN wget http://luajit.org/download/LuaJIT-${VER_LUAJIT}.tar.gz && tar -xzvf LuaJIT-${VER_LUAJIT}.tar.gz
# download nginx_devel_kit
RUN wget https://github.com/simpl/ngx_devel_kit/archive/v${VER_NGINX_DEVEL_KIT}.tar.gz -O ${NGINX_DEVEL_KIT}.tar.gz && \
 tar -xzvf ${NGINX_DEVEL_KIT}.tar.gz
# download lua nginx
RUN wget https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz -O ${LUA_NGINX_MODULE}.tar.gz && \
 tar -xzvf ${LUA_NGINX_MODULE}.tar.gz 

# LuaJIT
WORKDIR /LuaJIT-${VER_LUAJIT}
RUN make && make install

WORKDIR /nginx-${VER_NGINX}

# install nginx with default configuration
RUN ./configure --prefix=/usr/local/nginx --with-ld-opt="-Wl,-rpath,${LUAJIT_LIB}" --add-module=/${NGINX_DEVEL_KIT} \
 --add-module=/${LUA_NGINX_MODULE} && make -j2 && make install

# EXPOSE 8081/tcp
FROM debian:9

WORKDIR /usr/local/lib
COPY --from=build /usr/local/lib/ .

WORKDIR /usr/local/include/luajit-2.0
COPY --from=build /usr/local/include/luajit-2.0/ .

WORKDIR /usr/local/nginx
# copy all the content of the /usr/local/nginx - where nginx server is installed
COPY --from=build /usr/local/nginx/ .
# by default nginx is run under tcp 80 port
EXPOSE 80/tcp

CMD ["./sbin/nginx", "-g", "daemon off;"]
