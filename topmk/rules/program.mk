define TOPMK_PROGRAM_FILE_AUTO_RULE
# validity checking
$$(call topmkCheckProgram,$1)

# source files
$1_SOURCES  ?= 
$$(call topmkCheckNotEmpty,$$($1_SOURCES),$1_SOURCES)

# flags
$1_CPPFLAGS += $(CPPFLAGS)
$1_CFLAGS   += $(CFLAGS)
$1_CXXFLAGS += $(CXXFLAGS)
$1_LDFLAGS  += $(LDFLAGS)
$1_LDLIBS   += $(LDLIBS)
$1_RPATHS   += $(RPATHS)

## append rpath flags
$1_RPATH_LDFLAGS = $$(strip $$(call topmkConvertRpath,$$($1_RPATHS)))
ifneq ($$($1_RPATH_LDFLAGS),)
$1_LDFLAGS  += $$($1_RPATH_LDFLAGS) $(LD_NEW_DTAGS)
endif

## targets
$1_TARGETS = $1
$1_OBJECTS = $$(call topmkConvertPathWithPfxSfx,$$($1_SOURCES),$1-,.o)
$1_DEPENDS = $$(call topmkConvertPathWithPfxSfx,$$($1_SOURCES),$1-,.d)

## clean up
$1_CLEAN += $$($1_TARGETS) $$($1_OBJECTS) $$($1_DEPENDS)

## installation
ifeq ($$($1_NOINST),)
$1_NOINST = $(NOINST)
endif
$1_NOINST:= $$(call topmkConvertBoolean, $$($1_NOINST))

## rules
.PHONY: all clean clean-$1

all: $$($1_TARGETS)
$$($1_TARGETS) : $$($1_OBJECTS)
	@if $(NM) $$($1_OBJECTS) | $(DEMANGLE) | egrep -q '__throw|__gxx_personality|::' > /dev/null; then \
		echo "====> Linking Program $$@ for C++"; \
		echo "$(CXX) $$($1_OBJECTS) $$($1_LDFLAGS) $$($1_LDLIBS) -o $$@"; \
		$(CXX) $$($1_OBJECTS) $$($1_LDFLAGS) $$($1_LDLIBS) -o $$@; \
	else \
		echo "====> Linking Program $$@ for C"; \
		echo "$(CC) $$($1_OBJECTS) $$($1_LDFLAGS) $$($1_LDLIBS) -o $$@"; \
		$(CC) $$($1_OBJECTS) $$($1_LDFLAGS) $$($1_LDLIBS) -o $$@; \
	fi

ifneq ($$($1_NOINST),true)
.PHONY: install install-$1

install: install-$1
install-$1: $$($1_TARGETS)
	@echo "====> Installing $1 to $(DESTDIR)$(PREFIX)"
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/$(BINDIR)
	$(CP) $(CPOPT_FORCE) $1 $(DESTDIR)$(PREFIX)/$(BINDIR)

endif

$$(foreach f,$$($1_SOURCES),$$(eval $$(call TOPMK_OBJECT_RULE,$1,$$f)))
$$(foreach f,$$($1_SOURCES),$$(eval $$(call TOPMK_DEPEND_RULE,$1,$$f)))

clean: clean-$1
clean-$1:
	@echo "====> Cleaning files for $1"
	$(RM) -fr $$($1_CLEAN)

endef

PROGRAM_FILES +=$(filter-out %.$(SHARED_EXTENSION),$(filter-out %.$(STATIC_EXTENSION),$(TARGETS)))

ifneq ($(PROGRAM_FILES),)
$(foreach t,$(PROGRAM_FILES),$(eval $(call TOPMK_PROGRAM_FILE_AUTO_RULE,$t)))
endif

