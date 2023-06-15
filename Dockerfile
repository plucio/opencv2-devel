FROM docker.io/library/ubuntu:jammy AS opencv-2.4-devel

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
    && cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_CXX_STANDARD=11 .. \
    && make -j 3\
    && make install \
    && rm -rf ${OPENCV_SRC_DIR}


######################################################################
FROM docker.io/library/ubuntu:jammy AS opencv-2.4-runtime

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install --assume-yes --no-install-recommends \
    libgtk2.0-0 \
    libilmbase25 \
    libdc1394-25 \
    libopenexr25 \
    libswscale5 \
    libavutil56 \
    libavcodec58 \
    libavformat58 \
    libgstreamer1.0-0 \
    libgstreamer-plugins-base1.0-0 \
    libgstreamer-plugins-bad1.0-0 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=opencv-2.4-devel /usr/local/lib/ /usr/local/lib/

RUN /bin/rm -f /usr/local/lib/*.a
