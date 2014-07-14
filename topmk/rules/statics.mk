define TOPMK_STATIC_LIBRARY_AUTO_RULE
## validity checking
$$(call topmkCheckStatic,$1)

## source files
$1_SOURCES  ?=
$$(call topmkCheckNotEmpty,$$($1_SOURCES),$1_SOURCES)

# flags
$1_CPPFLAGS += $(CPPFLAGS)
$1_CFLAGS   += $(CFLAGS)
$1_CXXFLAGS += $(CXXFLAGS)
$1_ARFLAGS  += $(ARFLAGS)

## targets
$1_TARGETS = $1
$1_OBJECTS = $$(call topmkConvertPathWithPfxSfx,$$($1_SOURCES),$1-,.o)
$1_DEPENDS = $$(call topmkConvertPathWithPfxSfx,$$($1_SOURCES),$1-,.d)

$1_CLEAN += $$($1_OBJECTS) $$($1_DEPENDS) $$($1_TARGETS)

## installation
ifeq ($$($1_NOINST),)
$1_NOINST = $(NOINST)
endif
$1_NOINST:= $$(call topmkConvertBoolean, $$($1_NOINST))

$1_HEADERS_DIRS = $$(strip $$(filter-out ./,$$(sort $$(dir $$($1_HEADERS)))))

## rules
.PHONY: all clean clean-$1

all: $$($1_TARGETS)
$$($1_TARGETS) : $$($1_OBJECTS)
	@$(RM) -f $$@
	@echo "====> Archiving $$@"
	$(AR) $$($1_ARFLAGS) $$@ $$($1_OBJECTS)
ifneq ($(RANLIB),)
	$(RANLIB) $$@
endif

ifneq ($$($1_NOINST),true)
.PHONY: install install-$1

install: install-$1
install-$1: $$($1_TARGETS)
	@echo "====> Installing $1 to $(DESTDIR)$(PREFIX)"
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/$(LIBDIR)
	$(CP) $1 $(DESTDIR)$(PREFIX)/$(LIBDIR)
ifneq ($$($1_HEADERS),)
ifneq ($$($1_HEADERS_DIRS),)
	$(MKDIR) -p $$(addprefix $(DESTDIR)$(PREFIX)/$(INCLUDEDIR)/$$($1_HPREFIX)/,$$($1_HEADERS_DIRS))
endif
	@for h in $$($1_HEADERS); do \
		echo "$(CP) $(CPOPT_FORCE) $$$$h $(DESTDIR)$(PREFIX)/$(INCLUDEDIR)/$$($1_HPREFIX)/$$$$h"; \
		$(CP) $(CPOPT_FORCE) $$$$h $(DESTDIR)$(PREFIX)/$(INCLUDEDIR)/$$($1_HPREFIX)/$$$$h; \
	done
endif

endif

$$(foreach f,$$($1_SOURCES),$$(eval $$(call TOPMK_OBJECT_RULE,$1,$$f)))
$$(foreach f,$$($1_SOURCES),$$(eval $$(call TOPMK_DEPEND_RULE,$1,$$f)))

clean: clean-$1
clean-$1:
	@echo "====> Cleaning files for $1"
	$(RM) -f $$($1_CLEAN)

endef

STATIC_LIBRARIES +=$(filter %.$(STATIC_EXTENSION),$(TARGETS))

ifneq ($(STATIC_LIBRARIES),)
$(foreach t,$(STATIC_LIBRARIES),$(eval $(call TOPMK_STATIC_LIBRARY_AUTO_RULE,$t)))
endif

