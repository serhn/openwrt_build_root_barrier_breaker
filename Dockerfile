FROM debian:jessie

ENV CC_COMMIT 4e6115d12bd90db0b8eaeb78936dc88e873ec79b

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install sudo asciidoc bash bc binutils bzip2 fastjar flex git-core gcc util-linux gawk libgtk2.0-dev intltool jikespg zlib1g-dev  make genisoimage libncurses5-dev libssl-dev patch perl-modules rsync ruby sdcc unzip wget gettext xsltproc zlib1g-dev libboost1.55-dev libxml-parser-perl libusb-dev bin86 bcc sharutils perl-modules python2.7-dev git git-core build-essential libssl-dev libncurses5-dev unzip gawk subversion mercurial openjdk-7-jdk openssh-sftp-server
RUN useradd -m dev && echo "dev:dev" | chpasswd && adduser dev sudo
USER dev
WORKDIR /home/dev
RUN git clone -b barrier_breaker https://github.com/openwrt/archive.git
RUN mv archive barrier_breaker
WORKDIR /home/dev/barrier_breaker
RUN git checkout $CC_COMMIT
RUN wget -P dl https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.10.49.tar.xz
RUN wget -P dl https://www.kernel.org/pub/linux/utils/util-linux/v2.24/util-linux-2.24.1.tar.xz
RUN scripts/feeds update -a && scripts/feeds install -a
RUN rm .config
RUN wget -O .config https://raw.githubusercontent.com/serhn/openwrt_build_root_barrier_breaker/master/configs/wr703n.config
RUN make V=s
WORKDIR /home/dev/
USER root
CMD service ssh start && cd /home/dev/barrier_breaker && su -s /bin/bash dev
