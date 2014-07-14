# Common to all platforms defines.  These may be overridden in 
# more specific files.

ifeq ($(OS),)
OS   := $(shell uname -s | tr A-Z a-z)
endif

ifeq ($(ARCH),)
ARCH := $(shell uname -s | tr A-Z a-z)
endif

BASH  := $(shell which bash)
ifneq ($(BASH),)
SHELL := $(BASH)
else
$(warning bash is not found, using $(SHELL))
endif

ECHO  := /bin/echo
CAT   := /bin/cat
CP    := /bin/cp
MV    := /bin/mv
RM    := /bin/rm
LN    := /bin/ln
MKDIR := /bin/mkdir
RANLIB:= /usr/bin/ranlib
NM    := /usr/bin/nm
SED   := sed
AWK   := awk
TAR   := tar
FIND  := find
GPERF := gperf
DEMANGLE := c++filt
SHARED_EXTENSION := so
STATIC_EXTENSION := a
LD_RPATH_OPTION  := -Wl,-rpath,
LD_NEW_DTAGS     := -Wl,--enable-new-dtags

-include $(TOPMK)/variables/platform/$(OS).mk

