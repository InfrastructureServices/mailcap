VERSION = 2.1.54
TAG = r$(subst .,-,$(VERSION))

INSTALL = install
PYTHON3 = python3
sysconfdir = /etc
mandir = /usr/share/man

all: mime.types.nginx

mime.types.nginx: mime.types generate-nginx-mimetypes.sh
	sh generate-nginx-mimetypes.sh < mime.types > $@

check:
	$(PYTHON3) -Wd test.py < mime.types

install: mime.types.nginx
	$(INSTALL) -Dpm 644 mailcap $(DESTDIR)$(sysconfdir)/mailcap
	$(INSTALL) -Dpm 644 mime.types $(DESTDIR)$(sysconfdir)/mime.types
	$(INSTALL) -Dpm 644 mime.types.nginx $(DESTDIR)$(sysconfdir)/nginx/mime.types
	$(INSTALL) -Dpm 644 mailcap.5 $(DESTDIR)$(mandir)/man5/mailcap.5

clean:
	rm -f mime.types.nginx

tag-archive: check
	@git tag $(TAG)

create-archive:
	@git archive --prefix=mailcap-$(VERSION)/ $(TAG) | xz > mailcap-$(VERSION).tar.xz
	@echo ""
	@echo "The final archive is in mailcap-$(VERSION).tar.xz"

archive: tag-archive create-archive

.PHONY: all check install tag-archive create-archive archive
