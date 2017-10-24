# topmk: A makefile template for simiplify C/C++ projects building
# Li Xinjie (xjason.li@gmail.com)

###########################
# File extensions
###########################

# C source file extensions
C_SRCEXTS := c

# C++ source file extensions
CXX_SRCEXTS := cc cp cpp cxx CPP c++ C

# Allowed source file extensions
SRCEXTS := $(C_SRCEXTS) $(CXX_SRCEXTS)

# Rpm packages file extensions
RPM_PACKAGE_SRCEXTS := spec


###########################
# Character escaping
###########################

# Whitespace - using with $( )
_WHITESPACE_:=$() $()
$(_WHITESPACE_):=$(_WHITESPACE_)
undefine _WHITESPACE_

# Comma - using with $(,)
,	:= ,

# Hash - using with $(#)
_POUND_SIGN_   := \#
$(_POUND_SIGN_):= \#
undefine _POUND_SIGN_


###########################
# Special file names
###########################

# Change log files
CHANGELOG_FILES := CHANGELOG ChangeLog changelog CHANGES Changes changes

# Readme files
README_FILES := README README.* ReadMe Readme readme

