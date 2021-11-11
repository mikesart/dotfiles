#
# .gdbinit
#

# https://lists.gnu.org/archive/html/info-gnu/2020-02/msg00008.html
# https://gcc.gnu.org/wiki/DebugFission
# https://reviews.llvm.org/D24267
# https://gcc.gnu.org/onlinedocs/gcc/Debugging-Options.html
# https://sourceware.org/gdb/wiki/How gdb loads symbol files
# https://chromium.googlesource.com/chromium/src/build/config/+/refs/heads/master/compiler/BUILD.gn

# set debug auto-load on
# or add this to command line: -iex "set debug auto-load on"

# Debugging with GDB:
#  https://sourceware.org/gdb/onlinedocs/gdb/index.html#SEC_Contents
#
# info os
# info vtbl
# info address
# info symbol
# info target
# info frame 1 ; show info about frame: https://siddhesh.in/posts/viewing-signal-numbers-in-gdb.html
# show osabi
# explore value
# explore type
# dprintf
# typeid operator
# $_exitsignal
# $_memeq, $_streq, $_strlen, $_regex

# python help (gdb)

# show convenience ; list defined convenience variables

# https://github.com/phcerdan/Gdbinit/blob/master/.gdb/setup.gdb
# https://github.com/Gr3yR0n1n/dotgdb/blob/master/.gdb/detect-target.sh

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

# command line (cmdline) arguments
# Show argument list to give program being debugged when it is started.
#   help show args

# print binary variable:
#   p/t 0x6
#   x/4t 0x0000000000400398 ; dump memory in binary
# For printing non-pretty printed objects, use /r (raw). Ie:
#   p /r foo

# x/30zg
#   x: hex int
#   z: zero padded 'x'
#   d: signed decimal
#   u: unsigned decimal
#   t: binary (t for two)
#   c: char
#   f: float
#   s: string
#   r: raw
#     b: bytes
#     h: halfwords (two bytes)
#     w: words (four bytes)
#     g: giant words (eight bytes)

# print utf-16, utf-32 string
#   print (wchar_t *)$rax
#   x /sh $rax

# https://ascending.wordpress.com/2007/09/02/a-couple-of-gdb-tricks/
#   set auto-solib-add off
#   shar libc ; load libc symbols
#   info sharedlibrary ; see what symbols are loaded

# Color convenience vars
set $ENDC     = "\033[0m"
set $BLACK    = "\033[30m"
set $RED      = "\033[31m"
set $GREEN    = "\033[32m"
set $YELLOW   = "\033[33m"
set $BLUE     = "\033[34m"
set $MAGENTA  = "\033[35m"
set $CYAN     = "\033[36m"
set $WHITE    = "\033[37m"
set $BBLACK   = "\033[1;30m"
set $BRED     = "\033[1;31m"
set $BGREEN   = "\033[1;32m"
set $BYELLOW  = "\033[1;33m"
set $BBLUE    = "\033[1;34m"
set $BMAGENTA = "\033[1;35m"
set $BCYAN    = "\033[1;36m"
set $BWHITE   = "\033[1;37m"

# _gdb_major added to GDB 9
#   init-if-undefined $_gdb_major = 7
py import os
py gdb.execute("set $GDB_VERSION_STR = \"" +  gdb.VERSION + "\"")
py gdb.execute("set $GDB_VERSION = " + gdb.VERSION.partition(".")[0])
py gdb.execute("set $GDB_IS_X64 = " + ("0" if "aarch" in gdb.TARGET_CONFIG else "1"))
py gdb.execute("set $GDB_IS_TERMDEBUG = " + ("1" if os.environ.get("VIMRUNTIME") else "0"))

printf "\nGDB_VERSION:%d GDB_IS_X64:%d\n", $GDB_VERSION, $GDB_IS_X64

# add-auto-load-safe-path /lib/i386-linux-gnu/libthread_db-1.0.so
set auto-load safe-path /

# print object vtbl
# p /a (*(void ***)obj)[0]@10
# info vtbl obj

# print array
#  (gdb) p *values@6
#  $2 = {4, 8, 15, 16, 23, 42}

# set disassemble-next-line on
#   do a "display /5i $eip" or "display /5i $pc"

# don't do the 'type <return> to continue thing'
set pagination off

if $GDB_VERSION >= 10
    # https://sourceware.org/gdb/current/onlinedocs/gdb/Output-Styling.html
    #  show style
    set style address foreground magenta
    set style file foreground cyan
    set style function foreground yellow
    set style function intensity bold
end

echo \n
skip -gfile /usr/include/c++/8/*
skip -gfile /usr/include/c++/8/bits/*
skip -gfile /usr/include/c++/9/*
skip -gfile /usr/include/c++/9/bits/*
skip -gfile /usr/include/c++/10/*
skip -gfile /usr/include/c++/10/bits/*

# RL_PROMPT_START_IGNORE is \001 in readline/readline.h, etc.
# set prompt \001\033[0;1;33m\002(gdb) \001\033[0m\002
if $GDB_IS_TERMDEBUG == 0
    if $GDB_VERSION >= 10
        # https://sourceware.org/gdb/onlinedocs/gdb/Frames-In-Python.html
        set extended-prompt \[\e[0;1;33m\](gdb \v: \f{name}) \[\e[0m\]
    else
        set prompt \001\033[1;33m\002(gdb) \001\033[0m\002
    end
end

set debug-file-directory /usr/lib/debug
# set debug-file-directory /usr/lib/debug:/mnt/symbols/linux

# save command history across sessions
set history save on
set history remove-duplicates unlimited
set history filename ~/.gdb-history
set history size 5000

if $GDB_IS_X64
  set disassembly-flavor intel
end

# -gdwarf-4 -gsplit-dwarf -ggnu-pubnames -Wl,--gdb-index
if $GDB_VERSION >= 10
    maint set worker-threads unlimited
end

# use set substitute-path from to
# '/foo/bar/bz.c' was moved to '/mnt/cross/baz.c', use
# set substitute-path /foo/bar /mnt/cross

# use 'catch fork', 'catch vfork', 'catch exec' to break on these
#  (also use 'catch load libname' or 'catch unload libname'
# parent, child, ask
set follow-fork-mode parent

# break when specific file is opened
#   catch syscall openat
#   condition 1 $_streq((char *)$rsi, "/dev/nvidia0")
#   commands 1
#     bt
#     c
#     end

# (gdb) help set scheduler-locking
# Set mode for locking scheduler during execution.
# off  == no locking (threads may preempt at any time)
# on   == full locking (no thread except the current thread may run)
# step == scheduler locked during every single-step operation.
#     In this mode, no other thread may run during a step command.
#     Other threads may run while stepping over a function call ('next').
# NOTE: This can only be done when the binary is running...
# set scheduler-locking on

# https://stackoverflow.com/questions/5697042/command-to-suspend-a-thread-with-gdb
# (gdb) help set non-stop
# Set whether gdb controls the inferior in non-stop mode.

# break open if !strcmp( *(char **)($esp+4), "game-icon.bmp" )

set backtrace past-main

# This can cause older QNX x86_64 GDBs to segfault?
if $GDB_VERSION >= 10
    set width unlimited
end

## TODO
## # These make gdb never pause in its output
## set height 0
## set width 0
##
## set output-radix 0x10
## set input-radix 0x10

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

define bt_args_none
    if $GDB_VERSION >= 10
        backtrace -frame-arguments presence -frame-info auto
    else
        backtrace
    end
end

define bt_args
    if $GDB_VERSION >= 10
        backtrace -frame-arguments scalars -frame-info auto
    else
        backtrace
    end
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
        printf "%s%p%s ", $BCYAN, $addr, $ENDC

        set $lineendaddr = $addr + 16
        if $lineendaddr > $endaddr
            set $lineendaddr = $endaddr
        end

        set $count = 0
        set $a = $addr
        while $a < $lineendaddr
            if ( *(char *)$a < 0x20 || *(char *)$a >= 0x7f )
                printf "%s%02x%s ", $BBLACK, *(unsigned char *)$a, $ENDC
            else
                printf "%02x ", *(unsigned char *)$a
            end

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

        set $count = 0
        set $a = $addr
        while $a < $lineendaddr
            if ( *(char *)$a < 0x20 || *(char *)$a >= 0x7f )
                printf "%s.%s", $BBLACK, $ENDC
            else
                printf "%s%c%s", $BGREEN, *(char *)$a, $ENDC
            end
            set $a++
            set $count++
        end

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

# define fstring
# set $val=CurrentDevice->NamePrivate->DisplayIndex.Value
# p ((FNameEntry&)GNameBlocksDebug[$val >> FNameDebugVisualizer::OffsetBits][FNameDebugVisualizer::EntryStride * ($val & FNameDebugVisualizer::OffsetMask)]).AnsiName
# end

define dumpaddr
    # Format letters are o(octal), x(hex), d(decimal), u(unsigned decimal),
    #   t(binary), f(float), a(address), i(instruction), c(char), s(string)
    #   and z(hex, zero padded on the left).
    #
    # Size letters are b(byte), h(halfword), w(word), g(giant, 8 bytes).
    printf "%s16-bit halfword:%s\n", $CYAN, $ENDC
    x/1uh $arg0
    x/1dh $arg0
    x/1zh $arg0
    x/1th $arg0

    printf "%secho 32-bit word:%s\n", $CYAN, $ENDC
    x/1f $arg0
    x/1uw $arg0
    x/1dw $arg0
    x/1zw $arg0
    x/1tw $arg0

    printf "%secho 64-bit giantword:%s\n", $CYAN, $ENDC
    x/1ug $arg0
    x/1dg $arg0
    x/1zg $arg0
    x/1tg $arg0

    set $i = 0
    set $val = *(unsigned long long *)$arg0
    if $val
        printf "%sBits set:%s\n", $CYAN, $ENDC

        while $i < 64
            set $mask = 1ULL << $i
            if ($val & $mask)
                printf "%d ", $i
            end
            set $i++
        end
        echo \n
    end

    printf "%sBytes:\n", $CYAN, $ENDC
    xxd $arg0 16
end

document dumpaddr
Dump given address with several different formats.
end

define next_time
    set $t0 = clock()
    next
    set $clocks = clock() - $t0
    set $CLOCKS_PER_SEC = 1000000
    printf "%s%.3f seconds.%s\n", $CYAN, (float)$clocks / $CLOCKS_PER_SEC, $ENDC
end

define colortest
    printf "%sBLACK%s (BLACK)\n", $BLACK, $ENDC
    printf "%sRED%s\n", $RED, $ENDC
    printf "%sGREEN%s\n", $GREEN, $ENDC
    printf "%sYELLOW%s\n", $YELLOW, $ENDC
    printf "%sBLUE%s\n", $BLUE, $ENDC
    printf "%sMAGENTA%s\n", $MAGENTA, $ENDC
    printf "%sCYAN%s\n", $CYAN, $ENDC

    printf "%sWHITE%s\n", $WHITE, $ENDC
    printf "%sBBLACK%s\n", $BBLACK, $ENDC
    printf "%sBRED%s\n", $BRED, $ENDC
    printf "%sBGREEN%s\n", $BGREEN, $ENDC
    printf "%sBYELLOW%s\n", $BYELLOW, $ENDC
    printf "%sBBLUE%s\n", $BBLUE, $ENDC
    printf "%sBMAGENTA%s\n", $BMAGENTA, $ENDC
    printf "%sBCYAN%s\n", $BCYAN, $ENDC
    printf "%sBWHITE%s\n", $BWHITE, $ENDC
end

document colortest
Spew colors
end

# Load python helpers
source ~/.gdbinit.py

