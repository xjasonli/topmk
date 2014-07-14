ifneq ($(SUBDIRS),)

.PHONY: all subdirs clean clean-subdirs $(SUBDIRS)

all: subdirs
subdirs: $(SUBDIRS)
$(SUBDIRS):
	@echo "====> Making subdir $@ for $(abspath .)"
	+@$(topmkMakeDirIfExists) $@ 2>&1 | $(SED) $(SEDOPT_UNBUFFERED) -e 's/^/| /'; exit $${PIPESTATUS[0]}

clean: clean-subdirs
clean-subdirs:
	+@for d in $(SUBDIRS); do \
		echo "====> Cleaning subdir $$d for $(abspath .)"; \
		$(topmkMakeDirIfExists) $$d -i clean 2>&1 | $(SED) $(SEDOPT_UNBUFFERED) -e 's/^/| /'; \
	done

endif
