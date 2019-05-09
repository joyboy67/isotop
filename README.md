isotop
==========
Une OpenBSD facilitante pour découvrir.

Installation
------------

	ftp -o- "https://yeuxdelibad.net/DL/isotop/isotop.sh" | sh

isotop specific configuration
---------------------------

* Unbound is configured as default domain name resolver 
* Use zerohosts script to adblock
* Message in /etc/boot.conf
* Enable services hotplugd, messagebus, cups, xenodm, unbound,
* Disable ulpt for USB printers
* Configure xenodm appearance
* Install some additional packages.
* chromium is the default browser. Are disabled every option related to
  google and tracking just like in iridium. It is unveiled by default :
  this means the browser can't read files on your computer except in
  ~/Downloads. It keeps you ssh keys and passwords in configuration
  files safes. 
  Firefox is also making calls to google and can't be unveiled (see
  <https://marc.info/?l=openbsd-misc&m=152872551609819&w=2>)
