FROM debian:latest

## Update package list
RUN apt-get update

## Install package to download source
RUN apt-get install -y wget

## Install all needed packages to build the Cross-Compiler
RUN apt-get install -y gcc g++ texinfo bison flex libgmp3-dev libmpfr-dev libmpc-dev make

## Change workdir to build the Cross-Compiler
WORKDIR /root

## Download sources
RUN wget -O- http://ftpmirror.gnu.org/binutils/binutils-2.26.tar.gz | tar -xz
RUN wget -O- http://ftpmirror.gnu.org/gcc/gcc-5.3.0/gcc-5.3.0.tar.gz | tar -xz

## Renamming sources
RUN mv gcc-5.3.0 gcc-src
RUN mv binutils-2.26 binutils-src

## Prepare the cross-compiler build
RUN mkdir /root/cross
ENV PREFIX /root/cross
ENV TARGET i386-elf
ENV PATH ${PREFIX}/bin:${PATH}

## Build binutils
WORKDIR /root/binutils
RUN ../binutils-src/configure --target=${TARGET}  \
                              --prefix=${PREFIX}  \
                              --with-sysroot      \
                              --disable-nls       \
                              --disable-werror
RUN make
RUN make install

## Build GCC
WORKDIR /root/gcc
RUN ../gcc-src/configure  --target=${TARGET}    \
                          --prefix=${PREFIX}    \
                          --disable-nls         \
                          --enable-languages=c  \
                          --without-headers
RUN make all-gcc
RUN make all-target-libgcc
RUN make install-gcc
RUN make install-target-libgcc

WORKDIR /tmp
