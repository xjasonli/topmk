TOPMK=$(shell while [ ! -f topmk/topmk.all ] && [ `pwd` != / ] ; do cd ..; done ; echo `pwd`/topmk)
include $(TOPMK)/topmk.def

# Root directory
ROOT = .

# If this is a directory with subdirectories to build, set SUBDIRS
SUBDIRS = package

# Do not add any build rules until *after* the include of topmk.all
include $(TOPMK)/topmk.all
# Do not place any rules or targets above this line

install:
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/include/topmk/macros
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/include/topmk/rules/package
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/include/topmk/variables/platform
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/include/topmk/skeletons
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/include/topmk/skeletons/rpm
	$(CP) topmk/topmk.* ChangeLog README.md LICENSE $(DESTDIR)$(PREFIX)/include/topmk/
	$(CP) topmk/macros/*.mk $(DESTDIR)$(PREFIX)/include/topmk/macros/
	$(CP) topmk/rules/*.mk $(DESTDIR)$(PREFIX)/include/topmk/rules/
	$(CP) topmk/rules/package/*.mk $(DESTDIR)$(PREFIX)/include/topmk/rules/package/
	$(CP) topmk/variables/*.mk $(DESTDIR)$(PREFIX)/include/topmk/variables/
	$(CP) topmk/variables/platform/*.mk $(DESTDIR)$(PREFIX)/include/topmk/variables/platform/
	$(CP) topmk/skeletons/rpm/*.spec $(DESTDIR)$(PREFIX)/include/topmk/skeletons/rpm/
	for x in topmk/skeletons/*.mk; do \
		$(CAT) $${x} | \
		$(SED) 's@^TOPMK=.*@TOPMK=$(PREFIX)/include/topmk@' > \
		$(DESTDIR)$(PREFIX)/include/topmk/skeletons/$$(basename $${x}); \
	done

