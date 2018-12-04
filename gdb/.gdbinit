# Unreal:
#   import sys
#   sys.path.append('/home/mikesart/.config/Epic/GDBPrinters/')
#   from UE4Printers import register_ue4_printers
#   register_ue4_printers(None)
#   print("Registered pretty printers for UE4 classes")
#   end

# set debug auto-load on
# or add this to command line: -iex "set debug auto-load on"

#
# .gdbinit
#

# Debugging with GDB:
#  https://sourceware.org/gdb/onlinedocs/gdb/index.html#SEC_Contents
#
# info os
# info vtbl
# info address
# info symbol
# explore value
# explore type
# dprintf
# typeid operator
# $_exitsignal
# $_memeq, $_streq, $_strlen, $_regex
# python help (gdb)
# show convenience ; list defined convenience variables

# Set overload resolution in evaluating C++ functions
# set overload-resolution [on|off]

# show all defines, etc.
#   show user

# info inferiors
# print getpid()

# http://reverseengineering.stackexchange.com/questions/6657/why-does-ldd-and-gdb-info-sharedlibrary-show-a-different-library-base-addr
# info proc mapping
# info sharedlibrary libc

# Re-read symbol files: The first command tells it to forget all
# the symbol information it has, and the second command tells it to re-read it.
#   nosharedlibrary
#   sharedlibrary

# info signals
# handle SIGHUP nostop ; don't stop on SIGHUP signal

# https://github.com/scottt/debugbreak
# break into debugger on SIGILL
# handle SIGILL stop nopass

# GDB Command Reference
#  http://visualgdb.com/gdbreference/commands/
#  https://fedorahosted.org/gdb-heap/wiki
#  https://sourceware.org/gdb/onlinedocs/gdb/index.html#SEC_Contents
#  https://github.com/dholm/dotgdb
#  http://www.cinsk.org/wiki/Debugging_with_GDB:_How_to_create_GDB_Commands_in_Python
#  http://tromey.com/blog/
#  https://sourceware.org/gdb/current/onlinedocs/gdb/Python-API.html#Python-API

# to turn off address space layout randomization (Documentation/sysctl/kernel.txt):
#  0:disable ASLR, 1:randomize stack,VDSO,shared mem, 2:randomize stack,VDSO,shared mem,data seg
#  echo 0 > /proc/sys/kernel/randomize_va_space
#  setarch `uname -m` -R /bin/bash ; disable for bash and all descendents

# help set disable-randomization

# ignore 1 9999 ; ignore breakpoint 1 for next 9999 hits

# info file shows Entry point of debuggee. Useful for debugging w/o symbols.

# command line arguments
# Show argument list to give program being debugged when it is started.
#   help show args

# print binary variable:
#   p/t 0x6
#   x/4t 0x0000000000400398 ; dump memory in binary
# For printing non-pretty printed objects, use /r (raw). Ie:
#   p /r foo

# https://ascending.wordpress.com/2007/09/02/a-couple-of-gdb-tricks/
#   set auto-solib-add off
#   shar libc ; load libc symbols
#   info sharedlibrary ; see what symbols are loaded

# add-auto-load-safe-path /lib/i386-linux-gnu/libthread_db-1.0.so
set auto-load safe-path /

# print object vtbl
# p /a (*(void ***)obj)[0]@10
# info vtbl obj

# set disassemble-next-line on
#   do a "display /5i $eip" or "display /5i $eip" instead

# don't do the 'type <return> to continue thing'
set pagination off

# /home/mikesart/src/eglibc-2.15/sysdeps/i386/i686/multiarch/memcpy-ssse3-rep.S
# searching in ../sysdeps/i386/i686/multiarch/...
directory /home/mikesart/src/glibc-2.27/sysdeps
directory /home/mikesart/src/glibc-2.27/libio
directory /home/mikesart/src/glibc-2.27/elf
directory /home/mikesart/src/glibc-2.27/malloc
directory /home/mikesart/src/glibc-2.27/stdio-common
directory /home/mikesart/src/glibc-2.27/nss
directory /home/mikesart/src/glibc-2.27/stdlib
directory /home/mikesart/src/glibc-2.27/csu
directory /home/mikesart/src/glibc-2.27/posix
directory /home/mikesart/src/glibc-2.27/math

directory /home/mikesart/src/vulkan-1.1.73+dfsg

# Load color defines
source ~/.gdbcolors

echo \n
skip -gfile /usr/include/c++/6/*
skip -gfile /usr/include/c++/6/bits/*

# RL_PROMPT_START_IGNORE is \001 in readline/readline.h, etc.
# set prompt \001\033[0;1;33m\002(gdb) \001\033[0m\002

# https://sourceware.org/gdb/onlinedocs/gdb/Frames-In-Python.html
set extended-prompt \[\e[0;1;33m\](gdb \v: \f{name}) \[\e[0m\]

set debug-file-directory /usr/lib/debug
# set debug-file-directory /usr/lib/debug:/mnt/symbols/linux

# save command history across sessions
set history save on
set history filename ~/.gdb-history
set history size 5000

# use set substitute-path from to
# '/foo/bar/bz.c' was moved to '/mnt/cross/baz.c', use
# set substitute-path /foo/bar /mnt/cross
set substitute-path /home/bschaefer /mnt/drive2/dev

# use 'catch fork', 'catch vfork', 'catch exec' to break on these
#  (also use 'catch load libname' or 'catch unload libname'
# parent, child, ask
set follow-fork-mode parent

# (gdb) help set scheduler-locking
# Set mode for locking scheduler during execution.
# off  == no locking (threads may preempt at any time)
# on   == full locking (no thread except the current thread may run)
# step == scheduler locked during every single-step operation.
#     In this mode, no other thread may run during a step command.
#     Other threads may run while stepping over a function call ('next').
# NOTE: This can only be done when the binary is running...
# set scheduler-locking on

# break open if !strcmp( *(char **)($esp+4), "game-icon.bmp" )

set backtrace past-main
set width unlimited

# When displaying a pointer to an object, identify the actual (derived) type of
#   the object rather than the declared type, using the virtual function table.
set print object on

set print static-members on

# Print C++ names in their source form rather than their mangled form, even in assembler code
set print demangle on
set print asm-demangle on
set demangle-style gnu-v3

# Cause GDB to print structures in an indented format with one member per line
set print pretty on

# Pretty print arrays
set print array on

# Set printing of array indices
# set print array-indexes on

# Pretty print C++ virtual function tables.
set print vtbl on

set disassembly-flavor intel
set breakpoint pending on

# "p/a ptr" should now print source file location of ptr variable.
set print symbol-filename on

# Tell GDB to only display the symbolic form of an address if the offset
#   between the closest earlier symbol and the address is less than max-offset.
set print max-symbolic-offset 1

# set limit on how many elements GDB will print. 200 by default. 0 is no limit
set print elements 1024
# Set threshold for repeated print elements
set print repeats 0
# Cause GDB to stop printing the characters of an array when the first NULL is encountered.
# This is useful when large arrays actually contain only short strings. 
set print null-stop

define bt_args_on
    color $CYAN
    echo full backtrace args on\n
    color $ENDC
    set print frame-arguments scalar
    set filename-display relative
end

define bt_args_off
    color $CYAN
    echo backtrace args off\n
    color $ENDC
    set print frame-arguments none
    set filename-display basename
end

# https://stackoverflow.com/questions/25786982/how-can-gdb-show-both-hex-and-ascii-when-examing-memory/25794979#25794979
define xxd
    dont-repeat

    set $size = 128
    if $argc > 1
        set $size = $arg1
    end

    set $addr = (char *)($arg0)
    set $endaddr = $addr + $size
    while $addr < $endaddr
        color $BCYAN
        printf "%p ", $addr
        color $ENDC

        set $lineendaddr = $addr + 16
        if $lineendaddr > $endaddr
            set $lineendaddr = $endaddr
        end

        set $count = 0
        set $a = $addr
        while $a < $lineendaddr
            printf "%02x ", *(unsigned char *)$a
            if $count == 7
                printf " "
            end
            set $a++
            set $count++
        end
        printf ""

        while $count < 16
            printf "   "
            if $count == 7
                printf " "
            end
            set $count++
        end

        printf "|"
        color $BGREEN
        set $count = 0
        set $a = $addr
        while $a < $lineendaddr
            if ( *(char *)$a < 0x20 || *(char *)$a >= 0x7f )
                color $WHITE
                printf "."
                color $BGREEN
            else
                printf "%c", *(char *)$a
            end
            set $a++
            set $count++
        end
        color $ENDC

        while $count < 16
            printf " "
            set $count++
        end
        printf "|\n"

        set $addr = $addr + 16
    end
end

document xxd
hexdump usage: xxd address [count]
end

define dumpaddr
    # Format letters are o(octal), x(hex), d(decimal), u(unsigned decimal),
    #   t(binary), f(float), a(address), i(instruction), c(char), s(string)
    #   and z(hex, zero padded on the left).
    #
    # Size letters are b(byte), h(halfword), w(word), g(giant, 8 bytes).
    color $CYAN
    echo 16-bit halfword:\n
    color $ENDC
    x/1uh $arg0
    x/1dh $arg0
    x/1zh $arg0
    x/1th $arg0

    color $CYAN
    echo 32-bit word:\n
    color $ENDC
    x/1f $arg0
    x/1uw $arg0
    x/1dw $arg0
    x/1zw $arg0
    x/1tw $arg0

    color $CYAN
    echo 64-bit giantword:\n
    color $ENDC
    x/1ug $arg0
    x/1dg $arg0
    x/1zg $arg0
    x/1tg $arg0

    set $i = 0
    set $val = *(unsigned long long *)$arg0
    if $val
        color $CYAN
        echo Bits set:\n
        color $ENDC

        while $i < 64
            set $mask = 1ULL << $i
            if ($val & $mask)
                printf "%d ", $i
            end
            set $i++
        end
        echo \n
    end

    color $CYAN
    echo Bytes:\n
    color $ENDC
    xxd $arg0 16
end

document dumpaddr
Dump given address with several different formats.
end

# http://silmor.de/qtstuff.printqstring.php
define printqstring
    printf "(QString)0x%x (length=%i): \"",&$arg0,$arg0.d->size
    set $i=0
    while $i < $arg0.d->size
        set $c=$arg0.d->data[$i++]
        if $c < 32 || $c > 127
            printf "\\u0x%04x", $c
        else
            printf "%c", (char)$c
        end
    end
    printf "\"\n"
end

define printqs5static
    set $d=$arg0.d
    printf "(Qt5 QString)0x%x length=%i: \"",&$arg0,$d->size
    set $i=0
    set $ca=(const ushort*)(((const char*)$d)+$d->offset)
    while $i < $d->size
        set $c=$ca[$i++]
        if $c < 32 || $c > 127
            printf "\\u%04x", $c
        else
            printf "%c" , (char)$c
        end
    end
    printf "\"\n"
end

define printqs5dynamic
    set $d=(QStringData*)$arg0.d
    printf "(Qt5 QString)0x%x length=%i: \"",&$arg0,$d->size
    set $i=0
    while $i < $d->size
        set $c=$d->data()[$i++]
        if $c < 32 || $c > 127
            printf "\\u%04x", $c
        else
            printf "%c" , (char)$c
        end
    end
    printf "\"\n"
end

define next_time
    set $t0 = clock()
    next
    set $clocks = clock() - $t0
    set $CLOCKS_PER_SEC = 1000000
    color $CYAN
    printf "%.3f seconds.\n", (float)$clocks / $CLOCKS_PER_SEC
    color $ENDC
end

# Load python helpers
source ~/.gdbinit.py

