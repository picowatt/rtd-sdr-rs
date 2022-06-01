FROM rust:1.61-slim-buster

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

CMD export LIB_PATH=$(find `pwd -P` -name *.so | grep -oP '\K.+(?=\/)') && \
    export INC_PATH=$(find `pwd -P` -name *rtl-sdr.h | grep -oP '\K.+(?=\/)') && \
    export HEADER_FILEPATH=$(find `pwd -P` -name *rtl-sdr.h) && \
    cd /tmp/librtlsdr-rs && \
    cargo clean && \
    rustup component add rustfmt && \
    CARGO_HTTP_MULTIPLEXING=false cargo build --release
