PACKAGE_BUILD_DIR_NAME := build-package
PACKAGE_BUILD_DIR := $(shell pwd)/$(PACKAGE_BUILD_DIR_NAME)

.PHONY: all package clean clean-package clean-package-build-dir

all:
package:
clean: clean-package
clean-package: clean-package-build-dir
clean-package-build-dir:
	@if [ -d "$(PACKAGE_BUILD_DIR)" ]; then \
		echo "====> Cleaning package building directory"; \
		echo "$(RM) -fr $(PACKAGE_BUILD_DIR)"; \
		$(RM) -fr $(PACKAGE_BUILD_DIR); \
	fi

define TOPMK_PACKAGE_AUTO_RULE
ifneq ($$($1_PACKAGE_SRCEXTS),)
$1_PACKAGES = $$(foreach x,$$($1_PACKAGE_SRCEXTS),$$(wildcard *.$$x))
include $(TOPMK)/rules/package/$$(strip $$(shell echo $1 | tr A-Z a-z)).mk
endif
endef

$(foreach t,$(SUPPORTED_PACKAGES),$(eval $(call TOPMK_PACKAGE_AUTO_RULE,$t)))

