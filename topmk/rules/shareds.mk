define TOPMK_SHARED_LIBRARY_AUTO_RULE
## validity checking
$$(call topmkCheckShared,$1)

## source files
$1_SOURCES  ?=
$$(call topmkCheckNotEmpty,$$($1_SOURCES),$1_SOURCES)

# flags
$1_CPPFLAGS += $(CPPFLAGS)
$1_CFLAGS   += $(CFLAGS)
$1_CXXFLAGS += $(CXXFLAGS)
$1_LDFLAGS  += $(LDFLAGS)
$1_LDLIBS   += $(LDLIBS)
$1_RPATHS   += $(RPATHS)

## append -fPIC flags
$1_PIC      ?= -fPIC
$1_CFLAGS   += $$($1_PIC)
$1_CXXFLAGS += $$($1_PIC)

## append rpath flags
$1_RPATH_LDFLAGS = $$(strip $$(call topmkConvertRpath,$$($1_RPATHS)))
ifneq ($$($1_RPATH_LDFLAGS),)
$1_LDFLAGS  += $$($1_RPATH_LDFLAGS) $(LD_NEW_DTAGS)
endif

## create rpath-link flags
$1_RPATH_LINKS = $$(patsubst -L../%,-Wl$$(,)-rpath-link$$(,)../%,$$(filter -L%,$$($1_LDFLAGS)))

## version
$1_VERSION  ?= $(VERSION)
$1_MAJOR_VERSION:= $$(call topmkConvertMajor,$$($1_VERSION),$1_VERSION)
$1_LIBRARY  = $1
$1_LIBRARY_WITH_VERSION := $$($1_LIBRARY).$$($1_VERSION)
$1_LIBRARY_WITH_MAJOR_VERSION   := $$($1_LIBRARY).$$($1_MAJOR_VERSION)

## soname
$1_SONAME = -Wl,-soname,$$($1_LIBRARY_WITH_MAJOR_VERSION)

## targets
$1_TARGETS = $$($1_LIBRARY_WITH_VERSION) $$($1_LIBRARY_WITH_MAJOR_VERSION) $$($1_LIBRARY)
$1_OBJECTS = $$(call topmkConvertPathWithPfxSfx,$$($1_SOURCES),$1-,.o)
$1_DEPENDS = $$(call topmkConvertPathWithPfxSfx,$$($1_SOURCES),$1-,.d)

## clean up
$1_CLEAN += $$($1_TARGETS) $$($1_OBJECTS) $$($1_DEPENDS)

## Undefined reference checking
ifeq ($$($1_CHECK_UNDEFINED_REFERENCE),)
$1_CHECK_UNDEFINED_REFERENCE = $(CHECK_UNDEFINED_REFERENCE)
endif

## installation
ifeq ($$($1_NOINST),)
$1_NOINST = $(NOINST)
endif
$1_NOINST:= $$(call topmkConvertBoolean, $$($1_NOINST))

$1_HEADERS_DIRS = $$(strip $$(filter-out ./,$$(sort $$(dir $$($1_HEADERS)))))

## rules
.PHONY: all clean clean-$1

all: $$($1_TARGETS)
$$($1_LIBRARY) : $$($1_LIBRARY_WITH_MAJOR_VERSION)
	$(LN) -sf $$($1_LIBRARY_WITH_VERSION) $$@
$$($1_LIBRARY_WITH_MAJOR_VERSION) : $$($1_LIBRARY_WITH_VERSION)
	$(LN) -sf $$($1_LIBRARY_WITH_VERSION) $$@
$$($1_LIBRARY_WITH_VERSION) : $$($1_OBJECTS)
	@if $(NM) $$($1_OBJECTS) | $(DEMANGLE) | egrep -q "::" > /dev/null; then \
		echo "====> Linking $$@ for C++"; \
		echo "$(CXX) -o $$@ $$($1_OBJECTS) -shared -Wl,-x $$($1_SONAME) $$($1_LDFLAGS) $$($1_LDLIBS)"; \
		$(CXX) -o $$@ $$($1_OBJECTS) -shared -Wl,-x $$($1_SONAME) $$($1_LDFLAGS) $$($1_LDLIBS); \
	else \
		echo "====> Linking $$@ for C"; \
		echo "$(CC) -o $$@ $$($1_OBJECTS) -shared -Wl,-x $$($1_SONAME) $$($1_LDFLAGS) $$($1_LDLIBS)"; \
		$(CC) -o $$@ $$($1_OBJECTS) -shared -Wl,-x $$($1_SONAME) $$($1_LDFLAGS) $$($1_LDLIBS); \
		if $(NM) $$@ | egrep -q '__throw|__gxx_personality' > /dev/null; then \
			echo "====> Relinking for C++ due to dependency"; \
			echo "$(CXX) -o $$@ $$($1_OBJECTS) -shared -Wl,-x $$($1_SONAME) $$($1_LDFLAGS) $$($1_LDLIBS)"; \
			$(CXX) -o $$@ $$($1_OBJECTS) -shared -Wl,-x $$($1_SONAME) $$($1_LDFLAGS) $$($1_LDLIBS); \
		fi; \
	fi
ifeq ($$(call topmkConvertBoolean,$$($1_CHECK_UNDEFINED_REFERENCE)),true)
	@echo "====> Checking $$@ for undefined references"
	-@echo "int main (int argc __attribute__((unused)), char** argv __attribute__((unused))) { return 0; }" > $1_check_undefined_reference.c
	@echo "$(CC) -o $1_check_undefined_reference $$@ -Wl,-no-undefined -Wl,-x $$($1_RPATH_LINKS) $1_check_undefined_reference.c"
	@$(CC) -o $1_check_undefined_reference $$@ -Wl,-no-undefined -Wl,-x $$($1_RPATH_LINKS) $1_check_undefined_reference.c; \
		export topmk_check_undefined_reference_ok=$$$$?; \
		$(RM) -f $1_check_undefined_reference*; \
		test $$$${topmk_check_undefined_reference_ok} -ne 0 && $(RM) -f $$($1_TARGETS); \
		exit $$$${topmk_check_undefined_reference_ok}
endif

clean: clean-$1
clean-$1:
	@echo "====> Cleaning files for $1"
	$(RM) -f $$($1_CLEAN)

ifneq ($$($1_NOINST),true)
.PHONY: install install-$1

install: install-$1
install-$1: $$($1_TARGETS)
	@echo "====> Installing $1 to $(DESTDIR)$(PREFIX)"
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/$(LIBDIR)
	$(CP) $$($1_LIBRARY_WITH_VERSION) $(DESTDIR)$(PREFIX)/$(LIBDIR)
	$(CP) $(CPOPT_NO_FOLLOW) $$($1_LIBRARY_WITH_MAJOR_VERSION) $(DESTDIR)$(PREFIX)/$(LIBDIR)
	$(CP) $(CPOPT_NO_FOLLOW) $$($1_LIBRARY) $(DESTDIR)$(PREFIX)/$(LIBDIR)
ifneq ($$($1_HEADERS),)
ifneq ($$($1_HPREFIX),)
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/$(INCLUDEDIR)/$$($1_HPREFIX)
endif
ifneq ($$($1_HEADERS_DIRS),)
	$(MKDIR) -p $$(addprefix $(DESTDIR)$(PREFIX)/$(INCLUDEDIR)/$$($1_HPREFIX)/,$$($1_HEADERS_DIRS))
endif
	@for h in $$($1_HEADERS); do \
		echo "$(CP) $$$$h $(DESTDIR)$(PREFIX)/$(INCLUDEDIR)/$$($1_HPREFIX)/$$$$h"; \
		$(CP) $$$$h $(DESTDIR)$(PREFIX)/$(INCLUDEDIR)/$$($1_HPREFIX)/$$$$h; \
	done
endif

endif
	
$$(foreach f,$$($1_SOURCES),$$(eval $$(call TOPMK_OBJECT_RULE,$1,$$f)))
$$(foreach f,$$($1_SOURCES),$$(eval $$(call TOPMK_DEPEND_RULE,$1,$$f)))

endef

SHARED_LIBRARIES +=$(filter %.$(SHARED_EXTENSION),$(TARGETS))

ifneq ($(SHARED_LIBRARIES),)
$(foreach t,$(SHARED_LIBRARIES),$(eval $(call TOPMK_SHARED_LIBRARY_AUTO_RULE,$t)))
endif

