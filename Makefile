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
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/share/topmk/macros
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/share/topmk/rules/package
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/share/topmk/variables/platform
	$(MKDIR) -p $(DESTDIR)$(PREFIX)/share/topmk/skeletons
	$(CP) topmk/topmk.* ChangeLog README.md LICENSE $(DESTDIR)$(PREFIX)/share/topmk/
	$(CP) topmk/macros/*.mk $(DESTDIR)$(PREFIX)/share/topmk/macros/
	$(CP) topmk/rules/*.mk $(DESTDIR)$(PREFIX)/share/topmk/rules/
	$(CP) topmk/rules/package/*.mk $(DESTDIR)$(PREFIX)/share/topmk/rules/package/
	$(CP) topmk/variables/*.mk $(DESTDIR)$(PREFIX)/share/topmk/variables/
	$(CP) topmk/variables/platform/*.mk $(DESTDIR)$(PREFIX)/share/topmk/variables/platform/
	$(CP) topmk/skeletons/*.spec $(DESTDIR)$(PREFIX)/share/topmk/skeletons/
	for x in topmk/skeletons/*.mk; do \
		$(CAT) $${x} | \
		$(SED) '/^TOPMK=/d' | \
		$(SED) 's@$$(TOPMK)@$(PREFIX)/share/topmk@' > \
		$(DESTDIR)$(PREFIX)/share/topmk/skeletons/$$(basename $${x}); \
	done

