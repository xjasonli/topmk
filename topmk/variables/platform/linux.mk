# Linux system specific defines.

CPOPT_NO_FOLLOW := -d
CPOPT_RECURSIVE := -R
CPOPT_FORCE     := -f

SEDOPT_UNBUFFERED := -u

# Supported package types
SUPPORTED_PACKAGES = RPM

# Tar version >= 1.20 supports --transform flags
TAR_MAJOR := $(shell $(TAR) --version |head -1|${AWK} '{print $$NF}'|cut -d. -f1)
TAR_MINOR := $(shell $(TAR) --version |head -1|${AWK} '{print $$NF}'|cut -d. -f2)
TAR_XFORM_SUPPORT :=$(shell [ $(TAR_MAJOR) -ge 1 ] && [ $(TAR_MINOR) -ge 20 ] && echo true)

