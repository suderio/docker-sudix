#!/bin/sh

./configure --prefix=/tools --without-guile

make

make check

make install
