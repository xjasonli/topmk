# C source file extensions
C_SRCEXTS := c

# C++ source file extensions
CXX_SRCEXTS := cc cp cpp cxx CPP c++ C

# Allowed source file extensions
SRCEXTS := $(C_SRCEXTS) $(CXX_SRCEXTS)

# Rpm packages file extensions
RPM_PACKAGE_SRCEXTS := spec

# Character escaping
# Whitespace
$() $() := $() $()
# Comma
,	:= ,
# Hash
POUND_SIGN   := \#
$(POUND_SIGN):= \#
POUND_SIGN   :=

# Change log files
CHANGELOG_FILES := CHANGELOG ChangeLog changelog CHANGES Changes changes

# Readme files
README_FILES := README README.* ReadMe Readme readme

