FROM rust:1.61-slim-buster AS build_stage

WORKDIR /tmp

RUN apt-get update && apt-get install -y\
    build-essential \
    clang \
    cmake \
    libclang-dev \
    libssl-dev \
    libusb-1.0-0-dev \
    llvm-dev \
    pkg-config \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/steve-m/librtlsdr/archive/refs/heads/master.zip && \
    unzip master.zip && \
    cd librtlsdr-master && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make
    # cmake .. -DINSTALL_UDEV_RULES=ON && \
    # make && \
    # sudo make install && \
    # sudo ldconfig

# ARG LIB_PATH=$(find `pwd -P` -name *.so | grep -oP "\K.+(?=\/)")
# ARG HEADER_FILEPATH=$(find `pwd -P` -name *rtl-sdr.h)

COPY librtlsdr-rs /tmp/librtlsdr-rs
# WORKDIR /tmp/librtlsdr-rs

RUN LIB_PATH=$(find `pwd -P` -name *.so | grep -oP '\K.+(?=\/)') && \
    HEADER_FILEPATH=$(find `pwd -P` -name *rtl-sdr.h) && \
    cd /tmp/librtlsdr-rs && \
    cargo build

# FROM build_stage AS export_stage
# COPY /tmp/librtlsdr-rs librtlsdr-rs