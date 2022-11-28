# fork from https://framagit.org/3hg/isotop


## Installation

Install OpenBSD. See
[intructions](https://www.openbsd.org/faq/faq4.html).

Download isotop last archive and checksum.

	$ ftp https://framagit.org/3hg/isotop/raw/master/isotop-latest.tgz
	$ ftp https://framagit.org/3hg/isotop/raw/master/isotop-latest.sha256
	$ sha256 -C isotop-latest.sha256 isotop-latest.tgz

If OK, extract archive and run scripts : 

	$ tar xvzf isotop-latest.tgz
	$ sh isotop-user.sh
	$ su root isotop-root.sh

When you have finished, feel free to remove every `isotop-*` files.

Screenshots
-----------

![isotop login screen](img/screenshots/isotop-xenodm.png)
![isotop desktop ](img/screenshots/isotop.png)
![isotop desktop 2](img/screenshots/isotop2.png)
![isotop desktop 3](img/screenshots/isotop3.png)

