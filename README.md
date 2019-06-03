isotop
==========
OpenBSD easier to explore and use at first.

Available from OpenBSD > 6.5


Installation
------------

	# FIXME
	ftp -o- "https://yeuxdelibad.net/DL/isotop/isotop.sh" | sh

isotop specific configuration
---------------------------

* unwind(8) is configured as default domain name resolver 
* Use unwind-block script to adblock some domains
* Customized message in /etc/boot.conf
* Enable services hotplugd, messagebus, cups, xenodm, unbound,
* Disable ulpt for USB printers. This happens in rc.shutdown to enjoy
  KARL at reboot. 
  See [this thread](https://marc.info/?l=openbsd-misc&m=155746672110488&w=2)
* ntpd configuration does'nt use google as a reference
* Configure xenodm appearance
* Install additional packages 
  (see /usr/local/share/isotop/data/packages).
* doas is configured to avoid entering password for some commands.
* cwm is the default window manager. It is pre-configured and shipped
  with various script to ease window management for non-keyboard users.
* iridium is the default browser. Are disabled every option related to
  google and tracking. It is unveiled by default :
  this means the browser can't read files on your computer except in
  ~/Downloads. It keeps your ssh keys and passwords in configuration
  files safes. 
  Firefox is also making calls to google and can't be unveiled for now (see
  <https://marc.info/?l=openbsd-misc&m=152872551609819&w=2>)
* Alt_L is mapped as Esc for vi users :)
* Translations are included : english and french for now.
* A few scripts and tools are included in /usr/local/share/isotop/bin
  and set up in your PATH.

Why this name ?
---------------

At first, isotop was a iso file containing all packages and
configuration for intallation.
Now it's just a script to configure a vanilla OpenBSD.

Like an [isotope](https://en.wikipedia.org/wiki/Isotope), it is a
variant of OpenBSD with a few more things inside, but still OpenBSD.
