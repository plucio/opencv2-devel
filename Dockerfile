FROM docker.io/library/debian:bullseye-slim AS opencv-2.4-devel

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --assume-yes --no-install-recommends \
    ca-certificates \
    git \
    cmake \
    build-essential \
    libgtk2.0-dev \
    libavutil-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    && rm -rf /var/lib/apt/lists/*

# Compile Opencv 2.4
ENV OPENCV_SRC_DIR="/usr/local/src/opencv"
RUN git clone --depth 1 --branch 2.4.13.7 https://github.com/opencv/opencv.git ${OPENCV_SRC_DIR} \
    && mkdir ${OPENCV_SRC_DIR}/build \
    && cd ${OPENCV_SRC_DIR}/build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE .. \
    && make \
    && make install \
    && rm -rf ${OPENCV_SRC_DIR}

