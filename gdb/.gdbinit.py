# source ~/.gdbinit.py

# An introduction to GDB scripting in Python
#   https://blog.vmsplice.net/2020/02/an-introduction-to-gdb-scripting-in.html

import os
import re
import time
import gdb
import sys
import platform

class bcolors:
    ENDC     = "\033[0m"
    BLACK    = "\033[30m"
    RED      = "\033[31m"
    GREEN    = "\033[32m"
    YELLOW   = "\033[33m"
    BLUE     = "\033[34m"
    MAGENTA  = "\033[35m"
    CYAN     = "\033[36m"
    WHITE    = "\033[37m"
    BBLACK   = "\033[1;30m"
    BRED     = "\033[1;31m"
    BGREEN   = "\033[1;32m"
    BYELLOW  = "\033[1;33m"
    BBLUE    = "\033[1;34m"
    BMAGENTA = "\033[1;35m"
    BCYAN    = "\033[1;36m"
    BWHITE   = "\033[1;37m"

# ue4printersfile = os.path.expanduser("/epic/p4/UE4/Release-4.25/Engine/Extras/GDBPrinters/UE4Printers.py")
# if (os.path.isfile(ue4printersfile)):
#     gdb.execute("source " + ue4printersfile, True, False)
#     register_ue4_printers(None)
#     print("\nRegistered UE4 pretty printers:", ue4printersfile, "\n")

# python help(gdb.prompt)

# https://sourceware.org/gdb/current/onlinedocs/gdb/Convenience-Vars.html#Convenience-Vars
#   gdb.convenience_variable("GDB_VERSION")
#   gdb.set_convenience_variable(name, value)

# http://stackoverflow.com/questions/9233095/memory-dump-formatted-like-xxd-from-gdb/9234007#9234007

## pframefile = os.path.expanduser("~/.gdb-stackframe.py")
## if (os.path.isfile(pframefile)):
##     gdb.execute("source " + pframefile, True, False)

# sys.platform == 'linux'
### platform_machine = platform.machine()
### print("Platform machine: %s" % platform_machine)

#if (platform_machine == "x86_64"):
#    # https://github.com/gdbinit/Gdbinit/blob/master/gdbinit
#    gdb.execute("set disassembly-flavor intel", True, False)

# https://stackoverflow.com/questions/23150124/gdb-how-to-change-a-convenience-variable-from-a-built-in-python
#   class my_own_len (gdb.Function):
#      def __init__ (self):
#        super (my_own_len, self).__init__ ("my_own_len")
#
#      def invoke (self, arg):
#         res=len(arg.string())
#         gdb.execute( "set $Retrn=" + str(res))
#         return res
#
#   my_own_len()
#
#   (gdb) p $_strlen("test")
#   $1 = 4
#   (gdb) p $my_own_len("test")
#   $2 = 4
#   (gdb) p $Retrn
#   $3 = 4
#   (gdb)

# Use:
#   python print_color_table_func()
def print_color_table_func():
    """
    prints table of formatted text format options
    """
    for style in range(0,2):
        for fg in range(30,38):
            s1 = ''
            for bg in range(40,48):
                format = ';'.join([str(style), str(fg), str(bg)])
                s1 += '\x1b[%sm %s \x1b[0m' % (format, format)
            print(s1)
        print('\n')

class print_color_table(gdb.Command):
    """Print ansi color table"""
    def __init__(self):
        gdb.Command.__init__ (self, "print_color_table", gdb.COMMAND_USER, gdb.COMPLETE_COMMAND)
    def invoke (self, arg, from_tty):
        print_color_table_func()
print_color_table()

# https://fossies.org/dox/gdb-7.12/classgdb_1_1printing_1_1RegexpCollectionPrettyPrinter.html
# https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Developer_Guide/debuggingprettyprinters.html
# https://gcc.gnu.org/git/?p=gcc.git;a=blob_plain;f=libstdc%2b%2b-v3/python/libstdcxx/v6/printers.py;hb=HEAD
# https://github.com/ruediger/Boost-Pretty-Printer/blob/master/boost/printers.py
# https://sourceware.org/gdb/onlinedocs/gdb/Pretty_002dPrinter-Introduction.html#Pretty_002dPrinter-Introduction
### class git_oidPrinter:
###     def __init__(self, val):
###         self.val = val
###
###     def to_string (self):
###         u = (self.val['id'][i] for i in range(20))
###         s = 'xxxx_xxxxxxxxxxxxxxxx'.replace('x', '%02x') % tuple(u)
###         return '(%s) %s' % ("git_oid", s)
###
### def git_oid_pp(val):
###     if str(val.type) == 'const git_oid':
###         return git_oidPrinter(val)
###     if str(val.type) == 'git_oid':
###         return git_oidPrinter(val)
###     return None
###
### # info pretty-printer global git_oid_pp
### # disable pretty-printer global git_oid_pp
### # enable pretty-printer global git_oid_pp
### gdb.pretty_printers.append(git_oid_pp)

# shortcut commands:
# https://blog.0x972.info/?d=2014/12/04/09/25/38-dev-tools-configuration-gdbs-gdbinit

class timethis(gdb.Command):
    """Execute and time gdb command"""
    def __init__(self):
        gdb.Command.__init__ (self, "timethis", gdb.COMMAND_USER, gdb.COMPLETE_COMMAND)
    def invoke (self, arg, from_tty):
        starttime = time.time()
        gdb.execute("%s" % arg, True, False)
        print (bcolors.CYAN + "%.3f seconds." % (time.time() - starttime) + bcolors.ENDC )
timethis()

#def my_ignore_errors(arg):
#  try:
#    gdb.execute("print \"" + "Executing command: " + arg + "\"")
#    gdb.execute (arg)
#  except:
#    gdb.execute("print \"" + "ERROR: " + arg + "\"")
#    pass
#
#class TryIgnoreErrors(gdb.Command):
#    """Execute gdb command and xdg-open results."""
#
#    def __init__(self):
#        super (TryIgnoreErrors, self).__init__ ("my_ignore_errors", gdb.COMMAND_USER)
#
#    def invoke(self, arg, from_tty):
#        try:
#            gdb.execute("%s" % arg)
#        except:
#            print("Error: %s" % arg)
#        pass
#
#TryIgnoreErrors()

class XdgOpen(gdb.Command):
    """Execute gdb command and xdg-open results."""

    def __init__(self):
        # help(type(self))
        super (XdgOpen, self).__init__ ("xdg-open", gdb.COMMAND_USER, gdb.COMPLETE_COMMAND)

    def invoke(self, arg, from_tty):
        if arg == "bt":
            print("Executing 'backtrace no-filters'")
            str = gdb.execute("set print frame-arguments none")
            str = gdb.execute("set filename-display relative")
            str = gdb.execute("backtrace no-filters", False, True)
            str = re.sub( r"\n\x1a\x1aframe-begin", "", str );
            str = re.sub( r"\n\x1a\x1aframe-address-end", "", str );
            str = re.sub( r"\n\x1a\x1aframe-address", "", str );
            str = re.sub( r"\n\x1a\x1aframe-function-name", "", str );
            str = re.sub( r"\n\x1a\x1aframe-source-begin", "", str );
            str = re.sub( r"\n\x1a\x1aframe-source-file-end", "", str );
            str = re.sub( r"\n\x1a\x1aframe-source-file", "", str );
            str = re.sub( r"\n\x1a\x1aframe-source-line", "", str );
            str = re.sub( r"\n\x1a\x1aframe-end", "", str );
            str = re.sub( r"\n\x1a\x1aframe-args", "", str );
        else:
            print("Executing '%s'" % arg)
            str = gdb.execute("%s" % arg, False, True)
            str = re.sub( r"\n\x1a\x1avalue-history-value\n", "", str );
            str = re.sub( r"\n\x1a\x1avalue-history-value\n", "", str );
            str = re.sub( r"\n\x1a\x1avalue-history-begin \d+ [\*|\-]\n", "", str );
            str = re.sub( r"\n\x1a\x1afield-begin [\*|\-]\n", "", str );
            str = re.sub( r"\n\x1a\x1afield-name-end\n", "", str );
            str = re.sub( r"\n\x1a\x1afield-value\n", "", str );
            str = re.sub( r"\n\x1a\x1afield-end\n", "", str );
            str = re.sub( r"\n\x1a\x1aarray-section-begin \d+ [\*|\-]\n", "", str );
            str = re.sub( r"\n\x1a\x1aarray-section-end\n", "", str );
            str = re.sub( r"\n\x1a\x1aelt\n", "", str );
            str = re.sub( r"\n\x1a\x1aelt-rep \d+\n", "", str );
            str = re.sub( r"\n\x1a\x1aelt-rep-end\n", "", str );
            str = re.sub( r"\n\x1a\x1avalue-history-end", "", str );

        filename = "/tmp/gdb.%s.txt" % os.getpid()
        with open(filename, "a") as text_file:
            text_file.write("\n%s\n%s" % (arg, str))
        os.system("xdg-open %s" % filename)

# The last line instantiates the class, and is necessary to trigger the registration of the command with GDB.
# You can now run the command like this:
#   xdg-open "help"
XdgOpen()

class XxdSymbol(gdb.Command):
    """Xxd block of memory and run info symbol on them."""

    def __init__(self):
        super (XxdSymbol, self).__init__ ("xxd-symbol", gdb.COMMAND_USER, gdb.COMPLETE_LOCATION)

    def invoke(self, arg, from_tty):
        print("Executing 'xxd-symbol %s'" % arg)
        argv = gdb.string_to_argv(arg)
        if ( len(argv) != 2 ):
            raise gdb.GdbError('hex-dump takes exactly 2 arguments.')

        addr0 = int(argv[0], 0)
        count = int(argv[1], 0)

        # TODO mikesart: This assume 64-bit pointers
        bytes = count * 8

        # memoryview: https://docs.python.org/dev/library/stdtypes.html#typememoryview
        # Format: https://docs.python.org/dev/library/struct.html#module-struct
        inferior = gdb.selected_inferior()
        addr = addr0
        mem = inferior.read_memory(addr, bytes).cast('L')
        for m in mem:
            # need to look up memory at this location using below inferior.read_memory and do info symbol on it?
            str = gdb.execute("info symbol 0x%x" % int(m), False, True).strip()
            solib = gdb.solib_name(m)
            sym = None
            if str.find("No symbol matches") == -1:
                sym = str
            if solib or sym:
                print("0x%08x (+%x): %08x (%s) is '%s'" % (addr, addr - addr0, int(m), solib, sym))
            addr = addr + 4

XxdSymbol()

#
# From https://github.com/tromey/gdb-helpers
#

class Hierarchy(gdb.Command):
    """Show the inheritance hierarchy of a class."""

    def __init__(self):
        super(Hierarchy, self).__init__("hierarchy", gdb.COMMAND_USER,
                                        gdb.COMPLETE_SYMBOL)

    def print_hierarchy(self, typeobj, depth):
        print(' ' * depth + typeobj.name)
        typeobj = typeobj.strip_typedefs()
        for field in typeobj.fields():
            if not field.is_base_class:
                continue
            self.print_hierarchy(field.type, depth + 2)

    def invoke(self, arg, from_tty):
        typeobj = gdb.lookup_type(arg)
        self.print_hierarchy(typeobj, 0)

Hierarchy()

# https://sourceware.org/gdb/onlinedocs/gdb/Breakpoints-In-Python.html#Breakpoints-In-Python
class bpcontainer:
    def __init__(self, bp):
        self._bp = bp

    def __eq__(self, other):
        return ( self._bp.enabled == other._bp.enabled and
                 self._bp.silent == other._bp.silent and
                 self._bp.pending == other._bp.pending and
                 self._bp.thread == other._bp.thread and
                 self._bp.task == other._bp.task and
                 self._bp.ignore_count == other._bp.ignore_count and
                 self._bp.type == other._bp.type and
                 self._bp.visible == other._bp.visible and
                 self._bp.temporary == other._bp.temporary and
                 self._bp.location == other._bp.location and
                 self._bp.expression == other._bp.expression and
                 self._bp.condition == other._bp.condition and
                 self._bp.commands == other._bp.commands )

    @property
    def number(self):
        return self._bp.number

    @property
    def location(self):
        return self._bp.location

    def delete(self):
        return self._bp.delete()

class bprune(gdb.Command):
    """Prune duplicate breakpoints"""

    def __init__(self):
        gdb.Command.__init__ (self, "bprune", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        bplist = []
        bpdupes = []

        quiet = (arg == "--quiet")

        if hasattr(gdb, 'breakpoints') and gdb.breakpoints():
            if not quiet:
                print("breakpoints: %d" % len(gdb.breakpoints()))
            for bp in gdb.breakpoints():
                if bp.is_valid():
                    t1 = bpcontainer(bp)
                    if t1 in bplist:
                        bpdupes.append(t1)
                    else:
                        bplist.append(t1)

        if bpdupes:
            print( bcolors.CYAN + "Deleting duplicate breakpoints:" + bcolors.ENDC )
            for bp in bpdupes:
                print( "  %d: <%s>" % ( bp.number, bp.location ) )
                bp.delete()
        else:
            if not quiet:
                print( bcolors.CYAN + "No duplicate breakpoints found." + bcolors.ENDC )

        if not quiet:
            print("")
            gdb.execute( "info breakpoints" )
bprune()

def dumpfile(filename):
    f = open(bpfname, 'r')
    str = f.read().split("\n")
    for line in str:
        print( bcolors.CYAN + "  " + line.strip() + bcolors.ENDC )
    f.close()

bpfname = "/tmp/.gdb_breakpoints"

class bpclear(gdb.Command):
    """Clear breakpoints file"""

    def __init__(self):
        gdb.Command.__init__ (self, "bpclear", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        print(bcolors.CYAN + "Deleting " + bpfname + bcolors.ENDC)
        if (os.path.isfile(bpfname)):
            os.remove(bpfname)
bpclear()

class bpsave(gdb.Command):
    """Save breakpoints"""

    def __init__(self):
        gdb.Command.__init__ (self, "bpsave", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        if hasattr(gdb, 'breakpoints') and gdb.breakpoints() and len(gdb.breakpoints()) > 0:
            gdb.execute("bprune --quiet")
            cmd = "save breakpoints " + bpfname
            print(bcolors.CYAN + cmd + bcolors.ENDC)
            gdb.execute(cmd, False, False)
            dumpfile(bpfname)
        else:
            gdb.execute("bpclear")
bpsave()

class bpload(gdb.Command):
    """Save breakpoints"""

    def __init__(self):
        gdb.Command.__init__ (self, "bpload", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        if (os.path.isfile(bpfname)):
            cmd = "source " + bpfname
            print(bcolors.CYAN + cmd + bcolors.ENDC)
            dumpfile(bpfname)
            gdb.execute("source " + bpfname, True, False)
            gdb.execute("bprune --quiet")
        else:
            print(bcolors.CYAN + "No breakpoints to restore." + bcolors.ENDC)
bpload()

def main():
    # Set dir search list
    glibcsrc = os.path.expanduser("~/src/glibc-2.31")
    if (os.path.isdir(glibcsrc)):
        gdb.execute("directory " + glibcsrc + "/sysdeps")
        gdb.execute("directory " + glibcsrc + "/libio")
        gdb.execute("directory " + glibcsrc + "/elf")
        gdb.execute("directory " + glibcsrc + "/malloc")
        gdb.execute("directory " + glibcsrc + "/stdio-common")
        gdb.execute("directory " + glibcsrc + "/nss")
        gdb.execute("directory " + glibcsrc + "/stdlib")
        gdb.execute("directory " + glibcsrc + "/csu")
        gdb.execute("directory " + glibcsrc + "/posix")
        gdb.execute("directory " + glibcsrc + "/math")
        gdb.execute("directory " + glibcsrc + "/locale")
        print()

    # Show source dir search list
    dirlist = gdb.execute("show directories", to_string = True).split(":")
    for dir in dirlist:
        print( bcolors.CYAN + dir.strip() + bcolors.ENDC )
    print()

if __name__ == "__main__":
    main()
