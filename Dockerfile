FROM ubuntu:18.04

ENV QT_VERSION v5.11.2
ENV QT_CREATOR_VERSION v4.7.0

# Update ubuntu
RUN apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade && apt-get -y autoremove && apt-get -y autoclean 

# Build prerequisites
RUN apt-get -y update && apt-get -y install qtbase5-dev \
	libxcb-xinerama0-dev \
	build-essential \
	python \
	perl

# Other useful tools
RUN apt-get -y update && apt-get -y install tmux \
	wget \
	zip \
	git \
	vim

# Simple root password in case we want to customize the container
RUN echo "root:root" | chpasswd

RUN useradd -G video -ms /bin/bash user

RUN mkdir -p /qt/build

WORKDIR /qt/build

ADD build_qt.sh /qt/build/build_qt.sh
RUN bash -c "export QT_VERSION=${QT_VERSION} && export QT_CREATOR_VERSION=${QT_CREATOR_VERSION} && /qt/build/build_qt.sh"

USER user

WORKDIR /qt

CMD ["bash"]
