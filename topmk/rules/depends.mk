ifeq ($(filter-out clean,$(MAKECMDGOALS)),)
ifneq ($(MAKECMDGOALS),)
DEPENDS_IGNORED = yes
endif
endif

# Depend file rule
# 1. user target
# 2. source file
define TOPMK_DEPEND_RULE
$$(call topmkCheckExists,$2)
$$(call topmkConvertPathWithPfxSfx,$2,$1-,.d): $2
ifneq ($$(filter $$(addprefix %.,$(C_SRCEXTS)),$2),)
	@$(CC) -MM $2 $$($1_CPPFLAGS) $$($1_CFLAGS) | \
		$(SED) 's!$$(basename $$(notdir $2))\.o!$$(call topmkConvertPathWithPfxSfx,$2,$1-,.d) $$(call topmkConvertPathWithPfxSfx,$2,$1-,.o)!' > $$@
else
ifneq ($$(filter $$(addprefix %.,$(CXX_SRCEXTS)),$2),)
	@$(CXX) -MM $2 $$($1_CPPFLAGS) $$($1_CXXFLAGS) | \
		$(SED) 's!$$(basename $$(notdir $2))\.o!$$(call topmkConvertPathWithPfxSfx,$2,$1-,.d) $$(call topmkConvertPathWithPfxSfx,$2,$1-,.o)!' > $$@
else
	$$(error $2 in $1_SOURCES is not supported(supported extensions: $(addprefix .,$(SRCEXTS))))
endif
endif

ifneq ($(DEPENDS_IGNORED),yes)
-include $$(call topmkConvertPathWithPfxSfx,$2,$1-,.d)
endif
endef

