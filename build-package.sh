#!/bin/sh

mkdir $LFS/sources/work
tar -xf $LFS/sources/$1 -C $LFS/sources/work --strip-component=1
cd $LFS/sources/work
bash $LFS/sources/$2
cd $LFS/sources
rm -rf $LFS/sources/work

