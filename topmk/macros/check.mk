
topmkCheckShared = $(if $(filter %.so,$1),,$(error $1 is not a valid shared object filename))

topmkCheckStatic = $(if $(filter %.a,$1),,$(error $1 is not a valid static archive filename))

topmkCheckProgram = $(if $(filter-out %.so %.a $(SRCEXTS),$1),,$(error $1 is not a valid program filename))

topmkCheckNotEmpty = $(if $1,,$(error $2 is empty))

topmkCheckSpecName = $(if $(filter %.spec,$1),,$(error $1 is not a valid rpm spec filename))

topmkCheckSpecFile = $(if $(call topmkConvertSpecFileToRpmList,$1,$2),,$(error $1 is not a valid rpm spec file))

topmkCheckExists = $(if $(wildcard $1),,$(error $1 is not exists))

