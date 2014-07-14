# These macros are used as commands or parts of shell in rules.
#
# For example,
#
#    libs:: oselink
#       ...
#	$(topmkMakeDirIfExists) f11stat libs
#	...

# topmkMakeDirIfExists - Recursively build a directory if it exists
# Usage:
#   $(topmkMakeDirIfExists) <directory> [[<make-options> ...] <make-targets> ...]
topmkMakeDirIfExists := \
    MakeDirIfExists() { \
        if [ -d $$1 ]; then \
            if [ -f "$$1/$(MAKEFILES)" -o \
	         -r "$$1/Makefile" -o \
	         -r "$$1/makefile" -o \
	         -r "$$1/GNUmakefile" ]; then \
	        echo $(MAKE) $(MAKEFILEARG) -C "$$@"; \
	        $(MAKE) $(MAKEFILEARG) -C "$$@"; \
	    else \
	        echo "Skipping non-makeable directory: $$1"; \
	    fi \
	else \
	    echo "Skipping non-existent directory: $$1"; \
        fi; \
    }; MakeDirIfExists

