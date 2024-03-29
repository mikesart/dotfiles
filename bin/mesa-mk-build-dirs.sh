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

ARGS_REL=('--buildtype=release')
ARGS_REL+=("--prefix=$PWD/build/release/install")
ARGS_REL+=('-Dc_args="-g -O3 -fno-omit-frame-pointer -march=native"')
ARGS_REL+=('-Dcpp_args="-g -O3 -fno-omit-frame-pointer -march=native"')
ARGS_REL+=('-Db_ndebug=true')

ARGS_DBG=('--buildtype=debug')
ARGS_DBG+=("--prefix=$PWD/build/debug/install")
ARGS_DBG+=('-Dc_args="-g -O0"')
ARGS_DBG+=('-Dcpp_args="-g -O0"')

if [ -f /usr/bin/clang-10 ]; then
    export CC=clang-10
    export CXX=clang++-10
fi

if lsmod | grep -q 'amdgpu'; then

echo Creating amdgpu $PWD/build dirs

# execcmd "meson ${ARGS_DBG} -Ddri-drivers= -Dgallium-drivers=radeonsi -Dvulkan-drivers=amd -Dglvnd=true -Dgallium-extra-hud=true -Dvulkan-layers=device-select,overlay -Dbuild-aco-tests=true -Dtools=nir,glsl build/debug"
# execcmd "meson ${ARGS_REL} -Ddri-drivers= -Dgallium-drivers=radeonsi -Dvulkan-drivers=amd -Dglvnd=true -Dgallium-extra-hud=true -Dvulkan-layers=device-select,overlay -Dbuild-aco-tests=true build/release"

CMD=('-Ddri-drivers=')
CMD+=('-Dgallium-drivers=radeonsi')
CMD+=('-Dvulkan-drivers=amd')
CMD+=('-Dglvnd=true')
CMD+=('-Dgallium-extra-hud=true')
# This doesn't work with mesa-21.0.3
#CMD+=('-Dvulkan-layers=device-select,overlay')
CMD+=('-Dbuild-aco-tests=true')

CMD_REL=(meson "${ARGS_REL[@]}")
CMD_REL+=("${CMD[@]}")
CMD_REL+=('build/release')

CMD_DBG=(meson "${ARGS_DBG[@]}")
CMD_DBG+=("${CMD[@]}")
CMD_DBG+=('-Dtools=nir,glsl')
CMD_DBG+=('build/debug')

else

echo Creating i965 $PWD/build dirs

# execcmd "meson ${ARGS_REL} -Dgallium-drivers= -Dvulkan-drivers=intel -Dglvnd=true -Ddri-drivers=i965 build/release"
# execcmd "meson ${ARGS_DBG} -Dgallium-drivers= -Dvulkan-drivers=intel -Dglvnd=true -Ddri-drivers=i965 -Dtools=intel,nir,glsl,intel-ui build/debug"

CMD=('-Dgallium-drivers=')
CMD+=('-Dvulkan-drivers=intel')
CMD+=('-Dglvnd=true')
CMD+=('-Ddri-drivers=i965')

CMD_REL=(meson "${ARGS_REL[@]}")
CMD_REL+=("${CMD[@]}")
CMD_REL+=('build/release')

CMD_DBG=(meson "${ARGS_DBG[@]}")
CMD_DBG+=("${CMD[@]}")
CMD_DBG+=('-Dtools=intel,nir,glsl,intel-ui')
CMD_DBG+=('build/debug')

fi

echo "${CMD_REL[@]}"
execcmd "${CMD_REL[@]}"

echo "${CMD_DBG[@]}"
execcmd "${CMD_DBG[@]}"
