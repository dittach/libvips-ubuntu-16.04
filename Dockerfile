FROM ubuntu:16.04
LABEL AUTHOR="Adam Stern <adam@dittach.com>"

ENV LIBVIPS_VERSION_MAJOR 8
ENV LIBVIPS_VERSION_MINOR 7
ENV LIBVIPS_VERSION_PATCH 0
ENV LIBVIPS_VERSION $LIBVIPS_VERSION_MAJOR.$LIBVIPS_VERSION_MINOR.$LIBVIPS_VERSION_PATCH

RUN \
  # Install dependencies
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  automake autoconf build-essential curl \
  gobject-introspection gtk-doc-tools libglib2.0-dev libjpeg-turbo8-dev libpng12-dev \
  libwebp-dev libtiff5-dev libgif-dev libexif-dev libxml2-dev libpoppler-glib-dev \
  swig libmagickwand-dev libpango1.0-dev libmatio-dev libopenslide-dev libcfitsio3-dev \
  libgsf-1-dev fftw3-dev liborc-0.4-dev librsvg2-dev pkg-config libexpat1-dev glib-2.0-dev \
	libexpat-dev

RUN \
  # Build libvips
  cd /tmp && \
	curl -O https://codeload.github.com/jcupitt/libvips/tar.gz/v$LIBVIPS_VERSION && \
	mv v$LIBVIPS_VERSION v$LIBVIPS_VERSION.tar.gz && \
	tar xf v$LIBVIPS_VERSION.tar.gz && \
	cd libvips-$LIBVIPS_VERSION && \
	ls -aFC && \
	./autogen.sh && \
  make && \
  make install && \
  ldconfig

RUN \
  # Clean up
  apt-get remove -y curl automake build-essential && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	