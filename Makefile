# create archive and write manpage
VERSION=latest

all:
	mkdir -p isotop-files/usr/local/man/man7/
	mandoc -T man isotop.mdoc > isotop-files/usr/local/man/man7/isotop.man
	mandoc -T html isotop.mdoc > isotop.man.html
	cd isotop-files
	tar cvzf ../isotop-$(VERSION).tgz
