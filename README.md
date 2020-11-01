# isotop

![isotop logo](img/logo_isotop.png)

isotop is a set of configuration files, translations and instructions to
make OpenBSD great for desktop.

Available from OpenBSD > 6.5

## Installation

Install OpenBSD. See
[intructions](https://www.openbsd.org/faq/faq4.html).

Add youself to group wheel (first user by default)

	# usermod -G wheel yourlogin

Set up [doas](http://man.openbsd.org/doas.conf) : 

	# echo "permit persist :wheel" >> /etc/doas.conf

Download isotop script and run it:

	$ ftp https://framagit.org/3hg/isotop/raw/master/isotop-$VERSION.sh
	$ sh isotop-$VERSION.sh

Screenshots
-----------

![isotop login screen](img/screenshots/isotop-xenodm.png)
![isotop desktop with pkg_mgr and pcmanfm and man](img/screenshots/isotop.png)
![isotop desktop showing group management](img/screenshots/isotop2.png)

