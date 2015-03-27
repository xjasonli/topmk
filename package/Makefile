TOPMK=$(shell while [ ! -f topmk/topmk.all ] && [ `pwd` != / ] ; do cd ..; done ; echo `pwd`/topmk)
include $(TOPMK)/topmk.def

# Package prefix
PREFIX = /usr/local

# Root directory
ROOT = ..

# Variables for packages
PKGTAR = $(ROOT) 

# Optional local files to be removed when making 'clean'
# Objects and libraries are taken care of, they do *not* need to be set here
CLEAN = 

# If this is a directory with subdirectories to build, set SUBDIRS
SUBDIRS = 

# Do not add any build rules until *after* the include of top.mk
include $(TOPMK)/topmk.all
# Do not place any rules or targets above this line

all: package

