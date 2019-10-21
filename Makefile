# create archive and write manpages
VERSION=660

all:
	mkdir -p src/files/usr/local/man/man7/
	mandoc -T man man/isotop.mdoc > src/files/usr/local/man/man7/isotop.7
	mandoc -T man man/isotop-fr.mdoc > src/files/usr/local/man/man7/isotop-fr.7
	mandoc -T html man/isotop.mdoc > man/isotop.man.html
	mandoc -T html man/isotop-fr.mdoc > man/isotop-fr.man.html
	cp man/*.html ~/geek/gitreps/3hg/3hg-website/website.static/Isos/isotop/
	cd src/files && tar cvzf ../../isotop-$(VERSION).tgz .
	sha256 isotop-$(VERSION).tgz > isotop.sha256
	cd src && sha256 isotop.sh >> ../isotop.sha256
	git add src/isotop.sh isotop-$(VERSION).tgz isotop.sha256
	git commit -m "update for $(VERSION)"
	git push
	scp man/isotop*.html pi:/var/www/htdocs/3hg.fr/Isos/isotop/
