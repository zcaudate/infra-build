FROM ubuntu:20.04 as build 
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -yqq wget git make gcc libpcre3 libpcre3-dev libhiredis-dev
RUN apt-get install -yqq build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev libxml2-utils xsltproc
WORKDIR /build


RUN wget https://openresty.org/download/openresty-1.19.9.1.tar.gz && tar -xf openresty-1.19.9.1.tar.gz
RUN wget https://github.com/slact/nchan/archive/refs/tags/v1.2.15.tar.gz && tar -xf v1.2.15.tar.gz
RUN wget https://luarocks.github.io/luarocks/releases/luarocks-3.8.0.tar.gz && tar -xf luarocks-3.8.0.tar.gz

RUN wget https://github.com/zcaudate/redis-luajit/archive/refs/tags/v6.2-luajit.tar.gz && tar -xf v6.2-luajit.tar.gz
RUN wget https://luajit.org/download/LuaJIT-2.1.0-beta3.tar.gz && tar -xf LuaJIT-2.1.0-beta3.tar.gz
RUN wget https://github.com/postgres/postgres/archive/refs/tags/REL_13_5.tar.gz && tar -xf REL_13_5.tar.gz
RUN mv LuaJIT-2.1.0-beta3 redis-luajit-6.2-luajit/deps/LuaJIT

# BUILD OPENRESTY                                                                                                                                                                                 
RUN cd openresty-1.19.9.1 && ./configure --add-module=../nchan-1.2.15 --with-pcre-jit --with-ipv6 --prefix=/opt/openresty && make && make install
RUN cd luarocks-3.8.0 && ./configure --prefix=/opt/openresty/luajit --with-lua=/opt/openresty/luajit/ --lua-suffix=jit --with-lua-include=/opt/openresty/luajit/include/luajit-2.1
    
