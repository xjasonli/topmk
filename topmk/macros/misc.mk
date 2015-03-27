# topmk: A makefile template for simiplify C/C++ projects building
# Li Xinjie (xjason.li@gmail.com)

topmkUniq = $(strip $(if $1,$(firstword $1) $(call topmkUniq,$(filter-out $(firstword $1),$1))))

