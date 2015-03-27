# topmk: A makefile template for simiplify C/C++ projects building
# Li Xinjie (xjason.li@gmail.com)

ifneq ($(RPM_PACKAGES),)
RPM_PACKAGE_BUILD_DIR := $(PACKAGE_BUILD_DIR)/rpm

RPM_PKGTAR_OPT += $(PKGTAR_OPT) \
		--exclude "$(PACKAGE_BUILD_DIR_NAME)" \
		--exclude "*.rpm" \
		--exclude "*.o" \
		--exclude "*.d" \
		--exclude "*.a" \
		--exclude "*.so" \
		--exclude "*.so.*" \
		--exclude ".svn" \
		--exclude ".git" \
		--exclude "build-packages"

.PHONY: prepare-rpm-package
prepare-rpm-package: clean-package-build-dir
	@echo "====> Preparing rpm package building directory"
	$(MKDIR) -p $(RPM_PACKAGE_BUILD_DIR)/{BUILD,RPMS,SRPMS,SPECS,SOURCES}

define TOPMK_RPM_PACKAGE_AUTO_RULE
$$(call topmkCheckExists,$1)
$$(call topmkCheckSpecName,$1)

$1_NAME := $$(notdir $$(basename $1))

# default values
ifeq ($$($1_ROOT),)
$1_ROOT := $(ROOT)
else
$1_ROOT := $$(abspath $$($1_ROOT))
endif

# change log and version
ifeq ($$($1_CHANGELOG),)
$1_CHANGELOG := $$(call topmkFindChangeLog,$$($1_ROOT))
endif
ifeq ($$($1_CHANGELOG),)
$1_CHANGELOG := $(CHANGELOG)
endif
ifneq ($$($1_CHANGELOG),)
$$(call topmkCheckExists,$$($1_CHANGELOG))
ifeq ($$($1_VERSION),)
$1_VERSION := $$(call topmkConvertChangeLogToVersion2,$$($1_CHANGELOG))
endif
endif
ifeq ($$($1_VERSION),)
$1_VERSION := $(VERSION)
endif

# readme and summary
ifeq ($$($1_README),)
$1_README = $$(call topmkFindReadMe,$$($1_ROOT))
endif
ifeq ($$($1_README),)
$1_README := $(README)
endif
ifneq ($$($1_README),)
$$(call topmkCheckExists,$$($1_README))
ifeq ($$($1_SUMMARY),)
$1_SUMMARY := $$(shell head -1 $$($1_README))
endif
endif
ifeq ($$($1_SUMMARY),)
$1_SUMMARY := $(SUMMARY)
endif
ifeq ($$($1_SUMMARY),)
$1_SUMMARY := $$($1_NAME)
endif

ifeq ($$(origin $1_PKGTAR),undefined)
$1_PKGTAR ?= $(PKGTAR)
endif
ifneq ($$($1_PKGTAR),)
$1_PKGTAR := $$(abspath $$($1_PKGTAR))
$1_PKGTAR_OPT += $(RPM_PKGTAR_OPT)
endif

$1_PKGENV += $(PKGENV)
$1_PKGOPT += $(PKGOPT)
$1_PKGOPT += --define "root $$($1_ROOT)"
$1_PKGOPT += --define "name $$($1_NAME)"
$1_PKGOPT += --define "version $$($1_VERSION)"
$1_PKGOPT += --define "summary $$($1_SUMMARY)"
$1_PKGOPT += --define "_prefix $(PREFIX)"
$1_PKGOPT += --define "_topdir $(RPM_PACKAGE_BUILD_DIR)"

$1_SPECFILE := $(RPM_PACKAGE_BUILD_DIR)/SPECS/$$(strip $$(notdir $1))

ifneq ($$($1_PKGENV),)
$1_PKGCMD = env $$($1_PKGENV) rpmbuild
else
$1_PKGCMD = rpmbuild
endif

$$(call topmkCheckSpecFile,$1,$$($1_PKGOPT))
$1_VERSION := $$(call topmkConvertSpecFileToVersion,$1,$$($1_PKGOPT))
$1_PKGNAME := $$(call topmkConvertSpecFileToPkgName,$1,$$($1_PKGOPT))
$1_TARNAME := $$($1_PKGNAME)-$$($1_VERSION)

$1_PACKAGE_FULLPATH := $$(addprefix $(RPM_PACKAGE_BUILD_DIR),$$(call topmkConvertSpecFileToRpmList,$1,$$($1_PKGOPT)))
$1_PACKAGE := $$(notdir $$($1_PACKAGE_FULLPATH))

# Building rules
.PHONY: package-$1 clean-package-$1 prepare-package-$1 package-$$($1_NAME)

package: $$($1_PACKAGE)

$$($1_PACKAGE): package-$1

package-$1: prepare-package-$1
	@echo "====> Building package-$1"
	$$($1_PKGCMD) $$($1_PKGOPT) -bb $$($1_SPECFILE)
	-@mv $$($1_PACKAGE_FULLPATH) $$(shell pwd)/

prepare-package-$1: prepare-rpm-package $$($1_SPECFILE)
ifneq ($$($1_PKGTAR),)
	@echo "====> Preparing package-$1: $$($1_PKGTAR) -> $(RPM_PACKAGE_BUILD_DIR)/$$($1_TARNAME).tar.gz"
ifeq ($(TAR_XFORM_SUPPORT),true)
	tar -cz $$($1_PKGTAR_OPT) \
		-C $$($1_PKGTAR) . \
		-f $(RPM_PACKAGE_BUILD_DIR)/SOURCES/$$($1_TARNAME).tar.gz \
		--transform 's,^\.,$$($1_TARNAME),'
else
	$(RM) -fr $(RPM_PACKAGE_BUILD_DIR)/SOURCES/$$($1_TARNAME) \
		$(RPM_PACKAGE_BUILD_DIR)/SOURCES/$$(notdir $$($1_PKGTAR))
	tar -cz $$($1_PKGTAR_OPT) \
		-C $$(dir $$($1_PKGTAR)) $$(notdir $$($1_PKGTAR)) \
		-f $(RPM_PACKAGE_BUILD_DIR)/SOURCES/$$($1_TARNAME).tar.gz
	tar -xz \
		-C $(RPM_PACKAGE_BUILD_DIR)/SOURCES/ \
		-f $(RPM_PACKAGE_BUILD_DIR)/SOURCES/$$($1_TARNAME).tar.gz
	mv $(RPM_PACKAGE_BUILD_DIR)/SOURCES/$$(notdir $$($1_PKGTAR)) \
		$(RPM_PACKAGE_BUILD_DIR)/SOURCES/$$($1_TARNAME)
	tar -cz $$($1_PKGTAR_OPT) \
		-C $(RPM_PACKAGE_BUILD_DIR)/SOURCES/ $$($1_TARNAME) \
		-f $(RPM_PACKAGE_BUILD_DIR)/SOURCES/$$($1_TARNAME).tar.gz
	$(RM) -fr $(RPM_PACKAGE_BUILD_DIR)/SOURCES/$$($1_TARNAME)
endif
endif

$$($1_SPECFILE): $1 $$($1_CHANGELOG)
	@echo "====> Generating $$($1_SPECFILE)"
	$(CAT) $1 > $$($1_SPECFILE)
ifneq ($$($1_CHANGELOG),)
	echo "%changelog" >> $$($1_SPECFILE)
	$(CAT) $$($1_CHANGELOG) >> $$($1_SPECFILE)
endif

# Cleaning rules
clean-package: clean-package-$1
clean-package-$1:
	@echo "====> Cleaning files for package-$1"
	$(RM) -f $$($1_PACKAGE)

# Convenient rules
package-$$($1_NAME): package-$1

endef

$(foreach t,$(RPM_PACKAGES),$(eval $(call TOPMK_RPM_PACKAGE_AUTO_RULE,$t)))

endif
