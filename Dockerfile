FROM ubuntu:xenial
MAINTAINER Xuejie Xiao <xxuejie@gmail.com>

RUN apt-get update && apt-get install -y git python python-dev python-setuptools gcc libtinfo-dev zlib1g-dev wget

RUN echo "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" >> /etc/apt/sources.list.d/llvm.list
RUN echo "deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-6.0 main" >> /etc/apt/sources.list.d/llvm.list
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

RUN apt-get update && apt-get install -y clang-6.0 clang-tools-6.0 clang-6.0-doc libclang-common-6.0-dev libclang-6.0-dev libclang1-6.0 libllvm6.0 llvm-6.0 llvm-6.0-dev

RUN git clone --recursive https://github.com/dmlc/tvm /tvm
RUN cp /tvm/make/config.mk /tvm/config.mk
RUN echo "LLVM_CONFIG=llvm-config-6.0" >> /tvm/config.mk
RUN cd /tvm && make -j4
RUN cd /tvm/nnvm && make -j4

ENV PYTHONPATH="/tvm/python:/tvm/topi/python:/tvm/nnvm/python:${PYTHONPATH}"
RUN cd /tvm/python && python setup.py install
RUN cd /tvm/topi/python && python setup.py install
RUN cd /tvm/nnvm/python && python setup.py install
