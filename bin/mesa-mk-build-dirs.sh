#! /bin/bash

mkdir -p build/debug/install
mkdir -p build/release/install

CFLAGS='-g -O0' CXXFLAGS='-g -O0' meson --buildtype=debug --prefix=$PWD/build/debug/install -Ddri-drivers=i965 -Dgallium-drivers= -Dvulkan-drivers=intel -Dglvnd=true -Dtools=intel,nir,glsl,intel-ui build/debug

CFLAGS='-g -O3 -march=native -fno-omit-frame-pointer' CXXFLAGS='-g -O3 -fno-omit-frame-pointer -march=native' meson --buildtype=release --prefix=$PWD/build/release/install -Ddri-drivers=i965 -Dvulkan-drivers=intel -Dgallium-drivers= -Dglvnd=true -Db_ndebug=true build/release
