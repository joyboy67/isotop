# create archive and write manpages
VERSION=65

all:
	mkdir -p src/files/usr/local/man/man7/
	mandoc -T man man/isotop.mdoc > src/files/usr/local/man/man7/isotop.man
	mandoc -T man man/isotop-fr.mdoc > src/files/usr/local/man/man7/isotop-fr.man
	mandoc -T html man/isotop.mdoc > man/isotop.man.html
	mandoc -T html man/isotop-fr.mdoc > man/isotop-fr.man.html
	cd src/files && tar cvzf ../../isotop-$(VERSION).tgz .
	scp isotop-$(VERSION).tgz pi:/var/www/htdocs/ybad.name/DL/isotop/
