# topmk: A makefile template for simiplify C/C++ projects building
# Li Xinjie (xjason.li@gmail.com)

topmkUniq = $(strip $(if $1,$(firstword $1) $(call topmkUniq,$(filter-out $(firstword $1),$1))))

# Joins elements of the list in arg 2 with the given separator.
#   1. Element separator.
#   2. The list.
topmkJoinWith = $(subst $( ),$1,$(strip $2))

