ifeq ($(ROOT),)
ROOT = .
endif

ROOT:= $(abspath $(ROOT))
$(call topmkCheckExists,$(ROOT))

ifeq ($(CHANGELOG),)
CHANGELOG = $(call topmkFindChangeLog,$(ROOT))
endif

ifeq ($(VERSION),)
VERSION = $(call topmkConvertChangeLogToVersion2,$(CHANGELOG))
endif

ifeq ($(README),)
README = $(call topmkFindReadMe,$(ROOT))
endif

ifeq ($(origin ARFLAGS),default)
ARFLAGS = -cqv
endif

ifeq ($(PACKAGES),)
PACKAGES= $(foreach p,$(PACKAGE_SRCEXTS),$(wildcard *.$p))
endif

ifeq ($(CHECK_UNDEFINED_REFERENCE),)
CHECK_UNDEFINED_REFERENCE = true
endif

ifeq ($(BINDIR),)
BINDIR  = bin
endif

ifeq ($(LIBDIR),)
LIBDIR  = lib
endif

ifeq ($(INCLUDEDIR),)
INCLUDEDIR = include
endif

