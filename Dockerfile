FROM ubuntu:20.04 as build 
RUN apt-get update
RUN apt-get install -yqq wget git

WORKDIR /build
RUN wget https://openresty.org/download/openresty-1.19.9.1.tar.gz && tar -xf openresty-1.19.9.1.tar.gz
RUN wget https://github.com/slact/nchan/archive/refs/tags/v1.2.15.tar.gz && tar -xf v1.2.15.tar.gz
RUN cd openresty-1.19.9.1 && ./configure --add-module=../nchan-1.2.15 && make
