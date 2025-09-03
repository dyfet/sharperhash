# Copyright (C) 2025 Tycho Softworks.
# This code is licensed under MIT license.

.PHONY: vendor dist

ifndef ARCHIVE
ARCHIVE := $(PROJECT)
endif

dist:	vendor
	@rm -f $(ARCHIVE)-*.tar.gz $(ARCHIVE)-*.tar
	@git archive -o $(ARCHIVE)-$(VERSION).tar --format tar --prefix=$(ARCHIVE)-$(VERSION)/ v$(VERSION) 2>/dev/null || git archive -o $(ARCHIVE)-$(VERSION).tar --format tar --prefix=$(ARCHIVE)-$(VERSION)/ HEAD
	@if test -d vendor ; then \
		tar --transform s:^:$(ARCHIVE)-$(VERSION)/: --append --file=$(ARCHIVE)-$(VERSION).tar vendor ; fi
	@if test -f .make/nuget.config ; then \
		tar --transform s:^.make/:$(ARCHIVE)-$(VERSION)/: --append --file=$(ARCHIVE)-$(VERSION).tar .make/nuget.config ; fi

	@gzip $(ARCHIVE)-$(VERSION).tar

vendor:	restore
	@.make/vendor.sh $(DOTNET)
