
VERSION=$(shell awk '/Version:/ { print $$2 }' mailcap.spec)
TAG = r$(subst .,-,$(VERSION))

tag-archive:
	@git tag $(TAG)

create-archive:
	@git archive --prefix=mailcap-$(VERSION)/ $(TAG) | gzip > mailcap-$(VERSION).tar.gz 
	@echo ""
	@echo "The final archive is in mailcap-$(VERSION).tar.gz"

archive: tag-archive create-archive

