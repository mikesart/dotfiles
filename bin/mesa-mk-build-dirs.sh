#! /bin/bash

set -eu

ESC="$(printf '\033')"
NORMAL="${ESC}[0m"
YELLOW="${ESC}[1;33m"
CYAN="${ESC}[36m"

execcmd()
{
    ARG="$@"
    border=$(printf "%0.s=" {1..50})

    echo
    echo ${YELLOW}${border}${NORMAL}
    echo "${CYAN}${ARG}${NORMAL}"
    echo ${YELLOW}${border}${NORMAL}

    eval "$@"
}

mkdir -p build/debug/install
mkdir -p build/release/install

ARGS_REL='--buildtype=release '
ARGS_REL+='--prefix=$PWD/build/release/install '
ARGS_REL+='-Dc_args="-g -O3 -fno-omit-frame-pointer -march=native" '
ARGS_REL+='-Dcpp_args="-g -O3 -fno-omit-frame-pointer -march=native" '
ARGS_REL+='-Db_ndebug=true '

ARGS_DBG='--buildtype=debug '
ARGS_DBG+='--prefix=$PWD/build/debug/install '
ARGS_DBG+='-Dc_args="-g -O0" '
ARGS_DBG+='-Dcpp_args="-g -O0" '

if lsmod | grep -q 'amdgpu'; then

echo Creating amdgpu $PWD/build dirs

execcmd "meson ${ARGS_DBG} -Dgallium-drivers=radeonsi -Dvulkan-drivers=amd -Dglvnd=true -Dgallium-extra-hud=true -Dtools=nir,glsl build/debug"
execcmd "meson ${ARGS_REL} -Dgallium-drivers=radeonsi -Dvulkan-drivers=amd -Dglvnd=true -Dgallium-extra-hud=true build/release"

else

echo Creating i965 $PWD/build dirs

execcmd "meson ${ARGS_DBG} -Dgallium-drivers= -Dvulkan-drivers=intel -Dglvnd=true -Ddri-drivers=i965 -Dtools=intel,nir,glsl,intel-ui build/debug"
execcmd "meson ${ARGS_REL} -Dgallium-drivers= -Dvulkan-drivers=intel -Dglvnd=true -Ddri-drivers=i965 build/release"

fi
