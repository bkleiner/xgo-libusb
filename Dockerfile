FROM techknowlogick/xgo:go-1.15.x

ENV LIBUSB_VERSION 1.0.23
ENV PATH /go/bin/:$PATH
ENV GO111MODULE on

ADD run-env.sh /run-env.sh
RUN chmod u+x /run-env.sh && mkdir /deps && mkdir /src
ADD https://github.com/libusb/libusb/releases/download/v$LIBUSB_VERSION/libusb-$LIBUSB_VERSION.tar.bz2 /deps/libusb-$LIBUSB_VERSION.tar.bz2

RUN echo "Building for linux/amd64" && \
  export HOST=x86_64-linux PREFIX=/usr/local && \
  tar -C /deps -xf /deps/libusb-$LIBUSB_VERSION.tar.bz2 && \
  (cd /deps/libusb-$LIBUSB_VERSION && ./configure --disable-shared --disable-udev --host=$HOST --prefix=$PREFIX) && \
  (cd /deps/libusb-$LIBUSB_VERSION && make -j install) && \
  rm -rf /deps/libusb-$LIBUSB_VERSION

RUN echo "Building for windows/amd64" && \
  export CC=x86_64-w64-mingw32-gcc-posix CXX=x86_64-w64-mingw32-g++-posix HOST=x86_64-w64-mingw32 PREFIX=/usr/x86_64-w64-mingw32  && \
  tar -C /deps -xf /deps/libusb-$LIBUSB_VERSION.tar.bz2 && \
  (cd /deps/libusb-$LIBUSB_VERSION && ./configure --disable-shared --host=$HOST --prefix=$PREFIX) && \
  (cd /deps/libusb-$LIBUSB_VERSION && make -j install) && \
  rm -rf /deps/libusb-$LIBUSB_VERSION

RUN echo "Building for darwin/amd64" && \
  export CC=o64-clang CXX=o64-clang++ HOST=x86_64-apple-darwin15 PREFIX=/usr/x86_64-apple-darwin  && \
  tar -C /deps -xf /deps/libusb-$LIBUSB_VERSION.tar.bz2 && \
  (cd /deps/libusb-$LIBUSB_VERSION && ./configure --disable-shared --host=$HOST --prefix=$PREFIX) && \
  (cd /deps/libusb-$LIBUSB_VERSION && make -j install) && \
  rm -rf /deps/libusb-$LIBUSB_VERSION

WORKDIR /src
ENTRYPOINT ["/bin/bash"]