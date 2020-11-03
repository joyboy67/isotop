.SUFFIXES: .mdoc .7 .html
VERSION != date +%Y%m%d%H%M


all: archive
	echo $(VERSION) > isotop-files/etc/isotop.version
	sha256 -h isotop-$(VERSION).sha256 isotop-$(VERSION).tgz

clean:
	rm -f isotop-*.tgz isotop-*.sha256
	
archive: clean
	tar -cf isotop-$(VERSION).tar \
		isotop-files/ \
		isotop-root.sh \
		isotop-user.sh
	gzip -9 -o isotop-$(VERSION).tgz isotop-$(VERSION).tar
