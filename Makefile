# create archive and write manpages
VERSION=65

all:
	mkdir -p src/files/usr/local/man/man7/
	mandoc -T man man/isotop.mdoc > src/files/usr/local/man/man7/isotop.7
	mandoc -T man man/isotop-fr.mdoc > src/files/usr/local/man/man7/isotop-fr.7
	mandoc -T html man/isotop.mdoc > man/isotop.man.html
	mandoc -T html man/isotop-fr.mdoc > man/isotop-fr.man.html
	cd src/files && tar cvzf ../../isotop-$(VERSION).tgz .
	scp isotop-$(VERSION).tgz pi:/var/www/htdocs/ybad.name/DL/isotop/
	scp src/isotop.sh pi:/var/www/htdocs/ybad.name/DL/isotop/
