#!/bin/sh

mkdir $LFS/sources/work
tar -xf $1 -C $LFS/sources/work
cd $LFS/sources/work
bash $2
cd $LFS/sources
rm -r $LFS/sources/work

