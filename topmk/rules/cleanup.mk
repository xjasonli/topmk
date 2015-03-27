# topmk: A makefile template for simiplify C/C++ projects building
# Li Xinjie (xjason.li@gmail.com)

ifneq ($(CLEAN),)

.PHONY: all clean clean-CUSTOMIZE

all:
clean: clean-CUSTOMIZE
clean-CUSTOMIZE:
	@echo "====> Cleaning customized files"
	$(RM) -fr $(CLEAN)

endif

