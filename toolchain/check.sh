#!/bin/sh

PKG_CONFIG= ./configure --prefix=/tools

make

# make check

make install
