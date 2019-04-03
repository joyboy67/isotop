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
* iridium is the default browser. It is unveiled for better security,
  and more privacy-aware than chromium
  (https://github.com/iridium-browser/tracker/wiki/Differences-between-Iridium-and-Chromium).
  Firefox is also making calls to google and can't be unveiled (see
  <https://marc.info/?l=openbsd-misc&m=152872551609819&w=2>)
