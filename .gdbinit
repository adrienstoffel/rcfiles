set auto-load safe-path /
set disassembly-flavor intel
set follow-fork-mode parent

source /usr/share/pwndbg/gdbinit.py
#source /usr/share/peda/peda.py
#source /usr/share/gef/gef.py

set enhance-comment-color cyan
set enhance-string-value-color cyan
set memory-rwx-color red,bold
set memory-data-color gray
set memory-rodata-color green
set disasm-branch-color light_yellow

set print elements 0
set print asm-demangle on

#set substitute-path /build/glibc-OTsEL5 /usr/src/glibc

#set environment LD_LIBRARY_PATH /home/awe/libc/glibc-2.24/build
#set environment LD_LIBRARY_PATH /home/awe/libc/glibc-2.25/build
#set environment LD_LIBRARY_PATH /home/awe/libc/glibc-2.26/build

# $ cat toto.c
#  #include "toto.h"
#  s_struct wtf;
# $ gcc -g -c grunt.c

#add-symbol-file toto.o 0
# p *(s_struct*) 0x62b798

handle SIGPWR noprint nostop
handle SIGXCPU noprint nostop
