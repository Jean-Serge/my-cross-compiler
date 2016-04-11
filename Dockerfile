FROM debian:latest

## Install all needed packages to build the Cross-Compiler
RUN apt-get update && apt-get install -y  \
    wget                                  \
    gcc                                   \
    g++                                   \
    texinfo                               \
    bison                                 \
    flex                                  \
    libgmp3-dev                           \
    libmpfr-dev                           \
    libmpc-dev                            \
    make                                  \
    && rm -rf /var/lib/apt/lists/*

## Change workdir to build the Cross-Compiler
WORKDIR /root

## Prepare the cross-compiler build
RUN mkdir /root/cross
ENV PREFIX /root/cross
ENV TARGET i386-elf
ENV PATH ${PREFIX}/bin:${PATH}

## Build binutils
RUN wget -O- http://ftpmirror.gnu.org/binutils/binutils-2.26.tar.gz \
    | tar -xz                                                       \
    && mv binutils-2.26 binutils-src                                \
    && ./binutils-src/configure --target=${TARGET}                  \
                                --prefix=${PREFIX}                  \
                                --with-sysroot                      \
                                --disable-nls                       \
                                --disable-werror                    \
    && make                                                         \
    && make install                                                 \
    && make clean                                                   \
    && rm -rf binutils-src

## Build GCC
RUN wget -O- http://ftpmirror.gnu.org/gcc/gcc-5.3.0/gcc-5.3.0.tar.gz  \
    | tar -xz                                                         \
    && mv gcc-5.3.0 gcc-src                                           \
    && ./gcc-src/configure --target=${TARGET}                         \
                            --prefix=${PREFIX}                        \
                            --disable-nls                             \
                            --enable-languages=c                      \
                            --without-headers                         \
    && make all-gcc                                                   \
    && make all-target-libgcc                                         \
    && make install-gcc                                               \
    && make install-target-libgcc                                     \
    && make clean                                                     \
    && rm -rf gcc-src

WORKDIR /tmp
