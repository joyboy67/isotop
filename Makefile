# create archive and write manpage
VERSION=65

all:
	mkdir -p src/files/usr/local/man/man7/
	mandoc -T man isotop.mdoc > src/files/usr/local/man/man7/isotop.man
	mandoc -T html isotop.mdoc > isotop.man.html
	cd src/files
	tar cvzf ../../isotop-$(VERSION).tgz
