isotop
==========
Une OpenBSD facilitante pour découvrir.

Installation
------------

	# FIXME
	ftp -o- "https://yeuxdelibad.net/DL/isotop/isotop.sh" | sh

isotop specific configuration
---------------------------

* Unbound is configured as default domain name resolver 
* Use zerohosts script to adblock
* Message in /etc/boot.conf
* Enable services hotplugd, messagebus, cups, xenodm, unbound,
* Disable ulpt for USB printers. This happens in rc.shutdown to enjoy
  KARL at reboot. 
  See [this thread](https://marc.info/?l=openbsd-misc&m=155746672110488&w=2)
* ntpd does'nt use google as a reference
* Configure xenodm appearance
* Install additional packages.
* iridium is the default browser. Are disabled every option related to
  google and tracking. It is unveiled by default :
  this means the browser can't read files on your computer except in
  ~/Downloads. It keeps your ssh keys and passwords in configuration
  files safes. 
  Firefox is also making calls to google and can't be unveiled for now (see
  <https://marc.info/?l=openbsd-misc&m=152872551609819&w=2>)

Why this name ?
---------------

At first, isotop was a iso file containing all packages and
configuration for intallation.
Now it's just a script to configure a vanilla OpenBSD.

Like an [isotope](https://en.wikipedia.org/wiki/Isotope), it is a
variant of OpenBSD with a few more things inside, but still OpenBSD.
