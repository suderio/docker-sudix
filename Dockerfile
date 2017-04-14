FROM debian:stretch-slim

RUN apt-get update && apt-get upgrade -y
# Preparing the host system
RUN apt-get install -y \
    binutils \
    bison \
    bzip2 \
    gawk \
    gcc \
    g++ \
    make \
    patch \
    texinfo \
    wget \
    xz-utils
COPY *.sh /
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN bash version-check.sh
RUN bash library-check.sh
RUN mkdir LFS
ENV LFS /LFS
# Packages and patches
COPY wget-list /
RUN mkdir -v $LFS/sources && chmod -v a+wt $LFS/sources
RUN wget --input-file=wget-list --continue --directory-prefix=$LFS/sources
COPY md5sums $LFS/sources/
RUN pushd $LFS/sources && md5sum -c md5sums && popd
# Final preparations
RUN mkdir -v $LFS/tools && ln -sv $LFS/tools /
RUN groupadd lfs && \
    useradd -s /bin/bash -g lfs -m -k /dev/null lfs && \
    echo "lfs:lfs" | chpasswd && \
    chown -v lfs $LFS/tools && \
    chown -v lfs $LFS/sources
USER lfs
COPY .bash_profile /home/lfs/
COPY .bashrc /home/lfs/
RUN source ~/.bash_profile
# Temporary System
COPY build-package.sh /LFS/sources/ && chmod u+x /LFS/sources/build-package.sh
COPY toolchain /LFS/sources/
RUN $LFS/sources/build-package.sh binutils-2.27.tar.bz2 toolchain/binutils.sh

