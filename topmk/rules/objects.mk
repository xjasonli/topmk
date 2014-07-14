# Object file rule
# 1. uesr target
# 2. source file
define TOPMK_OBJECT_RULE
$$(call topmkCheckExists,$2)
$$(call topmkConvertPathWithPfxSfx,$2,$1-,.o): $2
ifneq ($$(filter $$(addprefix %.,$(C_SRCEXTS)),$2),)
	$(CC) -c $$($1_CPPFLAGS) $$($1_CFLAGS) -o $$@ $2
else
ifneq ($$(filter $$(addprefix %.,$(CXX_SRCEXTS)),$2),)
	$(CXX) -c $$($1_CPPFLAGS) $$($1_CXXFLAGS) -o $$@ $2
else
	$$(error $2 in $1_SOURCES is not supported(supported extensions: $(addprefix .,$(SRCEXTS))))
endif
endif
endef
