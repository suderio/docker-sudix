#!/bin/sh

./configure --prefix=/tools --without-bash-malloc

make

# make tests

make install

ln -sv bash /tools/bin/sh
