.SUFFIXES: .mdoc .7 .html
VERSION != date +%Y%m%d%H%M
MANSRC != find man/ -type f -name \*.mdoc
MAN7 = ${MANSRC:.mdoc=.7}
MANHTML = ${MANSRC:.mdoc=.html}
MANDST=isotop-files/man/man7/


all: archive man
	sed "s/_ISOTOPVERSION_/$(VERSION)/" isotop.sh > isotop-$(VERSION).sh
	sed "s/_ISOTOPVERSION_/$(VERSION)/" isotop-root.sh > isotop-files/isotop-root.sh
	sha256 -h isotop-$(VERSION).sha256 \
		isotop-$(VERSION).tgz \
		isotop-$(VERSION).sh

clean:
	rm -f isotop-*.tgz isotop-*.sha256 isotop-*.sh
	
archive: clean
	#tar -cf isotop-$(VERSION).tar -C isotop-files/ .
	tar -cf isotop-$(VERSION).tar isotop-files/
	gzip -9 -o isotop-$(VERSION).tgz isotop-$(VERSION).tar

.mdoc.7:
	mandoc -T man $< > $@

.mdoc.html:
	mandoc -T html $< > $@

man: $(MAN7) $(MANHTML)
	cp $(MAN7) $(MANDST)
