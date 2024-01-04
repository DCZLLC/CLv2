#!/bin/bash

# Install dependencies
sudo apt-get update
sudo apt-get install -y build-essential libtool autotools-dev automake pkg-config bsdmainutils curl nsis

#permissions
chmod +x contrib/install_db4.sh
chmod +x depends/config.guess
chmod +x depends/config.sub

# Install Berkeley DB 4.8
./contrib/install_db4.sh .

# Building for 64-bit Ubuntu
sudo apt-get install -y g++-mingw-w64-x86-64 mingw-w64-x86-64-dev

# Build using depends
cd depends
make HOST=x86_64-w64-mingw32
cd ..

./autogen.sh
#export BDB_PREFIX='/home/legends/Desktop/CryptoLuck/Cryptoluck/db4'
#./configure BDB_LIBS="-L${BDB_PREFIX}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I${BDB_PREFIX}/include" CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site --prefix=/usr/local/
CONFIG_SITE=$PWD/depends/x86_64-w64-mingw32/share/config.site ./configure --prefix=/

make
