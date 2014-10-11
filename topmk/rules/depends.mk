ifeq ($(filter-out clean,$(MAKECMDGOALS)),)
ifneq ($(MAKECMDGOALS),)
DEPENDS_IGNORED = yes
endif
endif

# Depend file rule
# 1. user target
# 2. source file
define TOPMK_DEPEND_RULE
$$(call topmkConvertPathWithPfxSfx,$2,$1-,.d): $2
ifneq ($$(filter $$(addprefix %.,$(C_SRCEXTS)),$2),)
	-@deps=$$$$($(CC) -MM $2 $$($1_CPPFLAGS) $$($1_CFLAGS) 2>/dev/null); \
		if [ $$$$? -eq 0 ]; then \
			$(ECHO) "$$$${deps}" | $(SED) 's!$$(basename $$(notdir $2))\.o!$$(call topmkConvertPathWithPfxSfx,$2,$1-,.d) $$(call topmkConvertPathWithPfxSfx,$2,$1-,.o)!' > $$@; \
		fi
else
ifneq ($$(filter $$(addprefix %.,$(CXX_SRCEXTS)),$2),)
	-@deps=$$$$($(CXX) -MM $2 $$($1_CPPFLAGS) $$($1_CXXFLAGS) 2>/dev/null); \
		if [ $$$$? -eq 0 ]; then \
			$(ECHO) "$$$${deps}" | $(SED) 's!$$(basename $$(notdir $2))\.o!$$(call topmkConvertPathWithPfxSfx,$2,$1-,.d) $$(call topmkConvertPathWithPfxSfx,$2,$1-,.o)!' > $$@; \
		fi
else
	$$(error $2 in $1_SOURCES is not supported(supported extensions: $(addprefix .,$(SRCEXTS))))
endif
endif

ifneq ($(DEPENDS_IGNORED),yes)
-include $$(call topmkConvertPathWithPfxSfx,$2,$1-,.d)
endif
endef

