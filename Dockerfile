FROM debian:bullseye-slim AS builder

RUN apt-get update
RUN apt-get install -y \
  wget \
  build-essential \
  libz-dev \
  zlib1g-dev

WORKDIR /graalvm
RUN wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-21.3.3/graalvm-ce-java11-linux-amd64-21.3.3.tar.gz
RUN tar xvzf graalvm-ce-java11-linux-amd64-21.3.3.tar.gz
ENV PATH /graalvm/graalvm-ce-java11-21.3.3/bin:$PATH
ENV JAVA_HOME /graalvm/graalvm-ce-java11-21.3.3
RUN gu install native-image

WORKDIR /toolchain
RUN wget http://more.musl.cc/10/x86_64-linux-musl/x86_64-linux-musl-native.tgz
RUN tar xvzf x86_64-linux-musl-native.tgz
ENV PATH /toolchain/x86_64-linux-musl-native/bin:$PATH
ENV CC /toolchain/x86_64-linux-musl-native/bin/gcc

WORKDIR /zlib
RUN wget https://zlib.net/zlib-1.2.13.tar.gz
RUN tar xvzf zlib-1.2.13.tar.gz
RUN ./zlib-1.2.13/configure --prefix=/toolchain/x86_64-linux-musl-native --static
RUN make
RUN make install
