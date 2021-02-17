.SUFFIXES: .mdoc .7 .html
VERSION != date +%Y%m%d%H%M


all: archive
	sha256 -h isotop-latest.sha256 isotop-latest.tgz

clean:
	rm -f isotop-*.tgz isotop-*.sha256
	
archive: clean
	echo $(VERSION) > isotop-files/etc/isotop.version
	tar -cf isotop-$(VERSION).tar \
		isotop-files/ \
		isotop-root.sh \
		isotop-user.sh
	gzip -9 -o isotop-$(VERSION).tgz isotop-$(VERSION).tar
	cp isotop-$(VERSION).tgz isotop-latest.tgz
