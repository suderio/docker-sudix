# docker run -it -v /mnt/lfs:/LFS .

FROM debian:stretch-slim as toolchain

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
    chown -v -R lfs $LFS/tools && \
    chown -v -R lfs $LFS/sources
USER lfs
COPY .bash_profile /home/lfs/
COPY .bashrc /home/lfs/
RUN source ~/.bash_profile
# Temporary System
COPY build-package.sh /LFS/sources/
COPY toolchain /LFS/sources/
WORKDIR $LFS/sources
RUN $LFS/sources/build-package.sh binutils-2.29.tar.bz2 binutils_pass1.sh
RUN $LFS/sources/build-package.sh gcc-7.2.0.tar.xz gcc_pass1.sh
RUN $LFS/sources/build-package.sh linux-4.12.7.tar.xz linux_headers.sh
RUN $LFS/sources/build-package.sh glibc-2.26.tar.xz glibc.sh
RUN $LFS/sources/build-package.sh glibc-2.26.tar.xz libstdc.sh
RUN $LFS/sources/build-package.sh binutils-2.29.tar.bz2 binutils_pass2.sh
RUN $LFS/sources/build-package.sh gcc-7.2.0.tar.xz gcc_pass2.sh
RUN $LFS/sources/build-package.sh tcl-core8.6.7-src.tar.gz tcl_core.sh
RUN $LFS/sources/build-package.sh expect5.45.tar.gz expect.sh
RUN $LFS/sources/build-package.sh dejagnu-1.6.tar.gz dejagnu.sh
RUN $LFS/sources/build-package.sh check-0.11.0.tar.gz check.sh
RUN $LFS/sources/build-package.sh ncurses-6.0.tar.gz ncurses.sh
RUN $LFS/sources/build-package.sh bash-4.4.tar.gz bash.sh
RUN $LFS/sources/build-package.sh bison-3.0.4.tar.xz bison.sh
RUN $LFS/sources/build-package.sh bzip2-1.0.6.tar.gz bzip2.sh
RUN $LFS/sources/build-package.sh coreutils-8.27.tar.xz coreutils.sh
RUN $LFS/sources/build-package.sh diffutils-3.6.tar.xz diffutils.sh
RUN $LFS/sources/build-package.sh file-5.31.tar.gz file.sh
RUN $LFS/sources/build-package.sh findutils-4.6.0.tar.gz findutils.sh
RUN $LFS/sources/build-package.sh gawk-4.1.4.tar.xz gawk.sh
RUN $LFS/sources/build-package.sh gettext-0.19.8.1.tar.xz gettext.sh
RUN $LFS/sources/build-package.sh grep-3.1.tar.xz grep.sh
RUN $LFS/sources/build-package.sh gzip-1.8.tar.xz gzip.sh
RUN $LFS/sources/build-package.sh m4-1.4.18.tar.xz m4.sh
RUN $LFS/sources/build-package.sh make-4.2.1.tar.bz2 make.sh
RUN $LFS/sources/build-package.sh patch-2.7.5.tar.xz patch.sh
RUN $LFS/sources/build-package.sh perl-5.26.0.tar.xz perl.sh
RUN $LFS/sources/build-package.sh sed-4.4.tar.xz sed.sh
RUN $LFS/sources/build-package.sh tar-1.29.tar.xz tar.sh
RUN $LFS/sources/build-package.sh texinfo-6.4.tar.xz texinfo.sh
RUN $LFS/sources/build-package.sh util-linux-2.30.1.tar.xz util_linux.sh
RUN $LFS/sources/build-package.sh xz-5.2.3.tar.xz xz.sh

COPY stripping.sh /LFS/sources/
RUN $LFS/sources/stripping.sh

ENTRYPOINT ["/bin/sh"]

