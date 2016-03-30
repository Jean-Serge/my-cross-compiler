# Cross-compiler for my-kernel project

*See [my-kernel](https://github.com/jean-serge/my-kernel)*

This project is made to build a docker image for building a [*GCC-Cross-Compiler*](http://wiki.osdev.org/GCC_Cross_Compiler) producing binaries in the **i386-elf** format, regardless of the platform on which you are working. 

## Usage

If you want to build this image

`docker build -t i386-elf-compiler .`

*Note : obviously you can change the tag (-t option) by anything you want.*

And if you want to run it here is a sample bash script to run this container.

```shell

#!/bin/bash

docker run  --tty                             \
            --interactive                     \
            --rm                              \
            --name dev-kernel                 \
            --volume /home/js/my-kernel:/tmp  \
            cross-compiler:latest


```

*Note : In this example, the ran container mounted a folder into the container's **/tmp**, as it is an ephemeral container, this is enough for building your binaries.*

## Docker Image

This image can be cut in steps :

+ Prepare the build by installing all needed packages
+ Download *binutils* and *gcc* sources
+ Build and install the new version of *binutils*
+ Build and install the new version of *gcc*

## Specifications

This cross-compiler is made to build **i386-elf** binaries for x86 architecture.

It compiles *GCC-5.3.0* and *binutils-2.26*.
