
VERSION=$(shell awk '/define version/ { print $$3 }' mailcap.spec)
CVSTAG = r$(subst .,-,$(VERSION))

tag-archive:
	@cvs -Q tag -F $(CVSTAG)

create-archive:
	@rm -rf /tmp/mailcap
	@cd /tmp ; cvs -Q -d $(CVSROOT) export -r$(CVSTAG) mailcap || echo "Um... export aborted."
	@mv /tmp/mailcap /tmp/mailcap-$(VERSION)
	@cd /tmp ; tar -czSpf mailcap-$(VERSION).tar.gz mailcap-$(VERSION)
	@rm -rf /tmp/mailcap-$(VERSION)
	@cp /tmp/mailcap-$(VERSION).tar.gz .
	@rm -f /tmp/mailcap-$(VERSION).tar.gz
	@echo ""
	@echo "The final archive is in mailcap-$(VERSION).tar.gz"

archive: tag-archive create-archive

