#! /bin/bash

mkdir -p build/debug/install
mkdir -p build/release/install

### Use -Dc_args=...

C_ARGS_REL='-g -O3 -march=native -fno-omit-frame-pointer' 
C_ARGS_DBG='-g -O0'

CPP_ARGS_REL='-g -O0'
CPP_ARGS_DBG='-g -O3 -fno-omit-frame-pointer -march=native' 

if lsmod | grep -q 'amdgpu'; then

echo Creating amdgpu $PWD/build dirs

CFLAGS='-g -O0' CXXFLAGS='-g -O0' meson --buildtype=debug --prefix=$PWD/build/debug/install -Dgallium-drivers=radeonsi -Dvulkan-drivers=amd -Dglvnd=true -Dtools=nir,glsl -Dgallium-extra-hud=true build/debug

CFLAGS='-g -O3 -march=native -fno-omit-frame-pointer' CXXFLAGS='-g -O3 -fno-omit-frame-pointer -march=native' meson --buildtype=release --prefix=$PWD/build/release/install -Dvulkan-drivers=amd -Dgallium-drivers=radeonsi -Dglvnd=true -Db_ndebug=true -Dgallium-extra-hud=true build/release

else

echo Creating i965 $PWD/build dirs

CFLAGS='-g -O0' CXXFLAGS='-g -O0' meson --buildtype=debug --prefix=$PWD/build/debug/install -Ddri-drivers=i965 -Dgallium-drivers= -Dvulkan-drivers=intel -Dglvnd=true -Dtools=intel,nir,glsl,intel-ui build/debug

CFLAGS='-g -O3 -march=native -fno-omit-frame-pointer' CXXFLAGS='-g -O3 -fno-omit-frame-pointer -march=native' meson --buildtype=release --prefix=$PWD/build/release/install -Ddri-drivers=i965 -Dvulkan-drivers=intel -Dgallium-drivers= -Dglvnd=true -Db_ndebug=true build/release

fi
