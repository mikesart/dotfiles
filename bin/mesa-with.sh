#! /bin/bash
MESAROOT="/home/mikesart/dev/mesa.git/build/$1/install"
shift
export LD_LIBRARY_PATH="$MESAROOT/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH"
export VK_ICD_FILENAMES="$MESAROOT/share/vulkan/icd.d/intel_icd.x86_64.json"
export LIBGL_DRIVERS_PATH="$MESAROOT/lib/x86_64-linux-gnu/dri"

echo "LD_LIBRARY_PATH:$LD_LIBRARY_PATH"
echo "VK_ICD_FILENAMES:$VK_ICD_FILENAMES"
echo "LIBGL_DRIVERS_PATH:$LIBGL_DRIVERS_PATH"
exec "$@"
