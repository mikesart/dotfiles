#! /bin/bash

## 1. Build Mesa:
##
##    Set up debug and release build directories:
##
##    $ mkdir -p build/debug/install; CFLAGS='-g -O0' CXXFLAGS='-g -O0' meson --buildtype=debug --prefix=$PWD/build/debug/install -Ddri-drivers=i965 -Dgallium-drivers= -Dvulkan-drivers=intel -Dglvnd=true -Dtools=intel,nir,glsl,intel-ui build/debug
##
##    $ mkdir -p build/release/install; CFLAGS='-O3 -g -march=native -fno-omit-frame-pointer' CXXFLAGS='-O3 -g -fno-omit-frame-pointer -march=native' meson --buildtype=release --prefix=$PWD/build/release/install -Ddri-drivers=i965 -Dvulkan-drivers=intel -Dgallium-drivers= -Dglvnd=true -Db_ndebug=true build/release
##
##    Then run 'mesa-nj.sh debug' or 'mesa-nj.sh release' from anywhere in the
##    Mesa source tree to build one version or the other.
##
## 2. Use the new Mesa:
##
##    We normally don't install development versions system-wide - we just
##    launch particular apps with the driver.
##
##    $ mesa-with.sh debug glxinfo
##
##    will run the 'glxinfo' program with the Mesa in
##    ~/src/mesa/build/debug/install.

#
# Copyright 2017 Kenneth Graunke <kenneth@whitecape.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
# _____________________________________________________________________
#
# The "nj" ninja builder
#
# From any directory in a Git worktree, 'nj' will jump to the build
# directory, build, and optionally install your project.
#
# It supports in-tree builds, a single out-of-tree build (in build/),
# or multiple out-of-tree builds (in build/*/).
#
# Usage:
# $ nj [<build>] [<targets>] # if using multiple out-of-tree builds.
# $ nj [<targets>]           # if using an in-tree or single out-of-tree build
#
# By default, <build> defaults to "debug".
#
# Setup:
#
# You can create multiple out-of-tree builds, named whatever you like.
# An example build called 'debug' would look like:
#
# - build/debug
# - build/debug/extratargets (optional)
# - build/debug/install (optional)
#
# If no targets are specified, nj defaults to 'all'.  It appends the contents
# of the 'extratargets' file, if it exists, allowing you to build additional
# targets that aren't enabled by default in your project's build system, such
# as 'check'.
#
# Additionally, if 'install' exists, it runs 'ninja install'.  This can be
# a directory which you've set as Meson/CMake's install prefix, or just a
# blank file if you want it to install elsewhere.
# _____________________________________________________________________

topdir=$(git rev-parse --show-toplevel)
if [ -f "$topdir/build.ninja" ]; then
    # In-tree build exists, use that.
    builddir="${topdir}"
elif [ -f "$topdir/build/build.ninja" ]; then
    # Single out-of-tree build, use that.
    builddir="${topdir}/build"
else
    # Select an out of tree build from the first command line argument,
    # defaulting to build/debug if no directory was given.
    builddir="${topdir}/build/${1:-debug}"
    shift

    if [ ! -f "$builddir/build.ninja" ]; then
        echo "No build directory in \"$builddir\"...aborting."
        exit
    fi
fi

cd "$builddir"

extratargets="$(cat extratargets 2>/dev/null)"
targets="${@:-all $extratargets}"

ninja $targets
[[ "$targets" == all* ]] && [ -e install ] && ninja install > /dev/null
