#! /bin/bash

ARG1=${1:---status}

if [[ $ARG1 == "debug" ]] || [[ $ARG1 == "release" ]] ; then
    echo "Running $ARG1..."
else
    echo "Usage: mesa-with.sh [release|debug] [application]"
    exit 1
fi

MESAROOT="/home/mikesart/dev/mesa.git/build/$1/install"

if [[ ! -d "$MESAROOT/lib" ]] ; then
    echo "Error: directory not found $MESAROOT"
    exit 1
fi

shift
export LD_LIBRARY_PATH="$MESAROOT/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"

if lsmod | grep -q 'amdgpu'; then
  export VK_ICD_FILENAMES="$MESAROOT/share/vulkan/icd.d/radeon_icd.x86_64.json"
else
  export VK_ICD_FILENAMES="$MESAROOT/share/vulkan/icd.d/intel_icd.x86_64.json"
fi

export LIBGL_DRIVERS_PATH="$MESAROOT/lib/x86_64-linux-gnu/dri"

echo "LD_LIBRARY_PATH:    $LD_LIBRARY_PATH"
echo "VK_ICD_FILENAMES:   $VK_ICD_FILENAMES"
echo "LIBGL_DRIVERS_PATH: $LIBGL_DRIVERS_PATH"

echo "exec $@"
exec "$@"
