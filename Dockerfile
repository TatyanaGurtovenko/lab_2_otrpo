FROM python:3.9-slim AS build-stage

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libgtk-3-dev \
    libboost-all-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    libv4l-dev \
    libxvidcore-dev \
    libx264-dev \
    libatlas-base-dev \
    gfortran \
    python3-dev

WORKDIR /opt

RUN git clone https://github.com/opencv/opencv.git && \
    git clone https://github.com/opencv/opencv_contrib.git

RUN cd opencv && mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
          -D CMAKE_INSTALL_PREFIX=/usr/local \
          -D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib/modules \
          -D WITH_TBB=ON \
          -D WITH_V4L=ON \
          -D WITH_QT=OFF \
          -D WITH_OPENGL=ON .. && \
    make -j$(nproc) && \
    make install && \
    ldconfig

FROM python:3.9-slim

COPY --from=build-stage /usr/local /usr/local

RUN pip install numpy opencv-python

WORKDIR /app
COPY app.py .
COPY img.png .

CMD ["python", "app.py"]
