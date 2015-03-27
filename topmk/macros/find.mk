# topmk: A makefile template for simiplify C/C++ projects building
# Li Xinjie (xjason.li@gmail.com)

###
# Find change log file in directory
# 1. directory
topmkFindChangeLog = $(firstword $(wildcard $(addprefix $1/,$(CHANGELOG_FILES))))

###
# Find readme file in directory
# 1. directory
topmkFindReadMe = $(firstword $(wildcard $(addprefix $1/,$(README_FILES))))

