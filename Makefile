VERSION = 2.1.41
TAG = r$(subst .,-,$(VERSION))

INSTALL = install
sysconfdir = /etc
mandir = /usr/share/man

all:

check:
	@perl test.pl < mime.types

install:
	$(INSTALL) -Dpm 644 mailcap $(DESTDIR)$(sysconfdir)/mailcap
	$(INSTALL) -Dpm 644 mime.types $(DESTDIR)$(sysconfdir)/mime.types
	$(INSTALL) -Dpm 644 mailcap.4 $(DESTDIR)$(mandir)/man4/mailcap.4

tag-archive: check
	@git tag $(TAG)

create-archive:
	@git archive --prefix=mailcap-$(VERSION)/ $(TAG) | xz > mailcap-$(VERSION).tar.xz
	@echo ""
	@echo "The final archive is in mailcap-$(VERSION).tar.xz"

archive: tag-archive create-archive

.PHONY: all check install tag-archive create-archive archive
