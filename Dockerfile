FROM ubuntu:20.04 as build 
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -yqq wget git make gcc unzip libpcre3 libpcre3-dev libhiredis-dev libsqlite3-dev
WORKDIR /build

# BUILD OPENRESTY                                                                                                                                                                                 
RUN wget https://openresty.org/download/openresty-1.19.9.1.tar.gz && tar -xf openresty-1.19.9.1.tar.gz
RUN wget https://github.com/slact/nchan/archive/refs/tags/v1.2.15.tar.gz && tar -xf v1.2.15.tar.gz
RUN wget https://luarocks.github.io/luarocks/releases/luarocks-3.8.0.tar.gz && tar -xf luarocks-3.8.0.tar.gz
RUN cd openresty-1.19.9.1 && ./configure --add-module=../nchan-1.2.15 --with-pcre-jit \
        --with-ipv6 --prefix=/opt/openresty \
        && make && make install
RUN cd luarocks-3.8.0 && ./configure --prefix=/opt/openresty/luajit --with-lua=/opt/openresty/luajit \
        --lua-suffix=jit --with-lua-include=/opt/openresty/luajit/include/luajit-2.1 \
        && make && make install

RUN /opt/openresty/luajit/bin/luarocks install pgmoon
RUN /opt/openresty/luajit/bin/luarocks install luasocket
RUN /opt/openresty/luajit/bin/luarocks install lustache
RUN /opt/openresty/luajit/bin/luarocks install lua-cjson
RUN /opt/openresty/luajit/bin/luarocks install lua-resty-openssl
RUN /opt/openresty/luajit/bin/luarocks install lua-resty-mail                                                                                                                                     
RUN /opt/openresty/luajit/bin/luarocks install lua-resty-http
RUN /opt/openresty/luajit/bin/luarocks install lua-resty-uuid
RUN /opt/openresty/luajit/bin/luarocks install lua-resty-acme
RUN /opt/openresty/luajit/bin/luarocks install lsqlite3

# BUILD REDIS                                                                                                                                                                                     
RUN wget https://github.com/zcaudate/redis-luajit/archive/refs/tags/v5.0-luajit.tar.gz && tar -xf v5.0-luajit.tar.gz
RUN wget https://github.com/zcaudate/LuaJIT/archive/refs/tags/2.1-redis.tar.gz && tar -xf 2.1-redis.tar.gz
RUN rm -R redis-luajit-5.0-luajit/deps/LuaJIT
RUN mv LuaJIT-2.1-redis redis-luajit-5.0-luajit/deps/LuaJIT
RUN cd redis-luajit-5.0-luajit && make && make install
