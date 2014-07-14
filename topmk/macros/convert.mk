
###
# Convert filename to the format described below.
# 1. filename list
# 2. prefix after directories
# 3. new suffix
# eg: topmkConvertPathWithPfxSfx('path/to/file.xx', 'pfx-', '.sfx')
#      => 'path/to/pfx-file.sfx'
topmkConvertPathWithPfxSfx = $(foreach f,$1,$(join $(dir $f), $(addprefix $2,$(addsuffix $3,$(basename $(notdir $f))))))

###
# Convert version number to major
# 1. version number, normally MAJOR.MINOR.REVISION
# 2. variable name to produce human readable error message
topmkConvertMajor = $(if $(findstring .,$1),$(firstword $(subst ., ,$1)),$(error $2 = $1 is invalid))

###
# Convert path list to rpath LDFLAGS
# 1. path list
topmkConvertRpath = $(addprefix $(LD_RPATH_OPTION),$(abspath $1))

###
# Convert rpm spec file to rpm file list
# 1. spec file
# 2. pkg opt
topmkConvertSpecFileToRpmList = $(shell rpm $2 -q --specfile --qf "/RPMS/%{arch}/%{name}-%{version}-%{release}.%{arch}.rpm " $1)

###
# Convert rpm spec file to package name
# 1. spec file
# 2. pkg opt
topmkConvertSpecFileToPkgName = $(shell rpm $2 -q --specfile --qf "%{name}\n" $1|head -1)

###
# Convert rpm spec file to package version
# 1. spec file
# 2. pkg opt
topmkConvertSpecFileToVersion = $(shell rpm $2 -q --specfile --qf "%{version}\n" $1|head -1)

###
# Convert changelog to version
topmkConvertChangeLogToVersion = $(if $1,$(if $(wildcard $1),$(shell awk '/^ *\*.* [0-9\.]* *$$/ {print $$NF; exit}' $1),),)

###
# Convert changelog to version with default 0.0.0
topmkConvertChangeLogToVersion2 = $(strip $(if $(call topmkConvertChangeLogToVersion,$1), \
									   $(call topmkConvertChangeLogToVersion,$1), 0.0.0))

###
# Convert boolean value to true/<empty string>
topmkConvertBoolean = $(findstring true,$(subst 1,true,$(subst True,true,$(subst TRUE,true,$(subst yes,true,$1)))))

