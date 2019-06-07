# FAQ : isotop

## What is isotop ?

Isotop is a pre-configured OpenBSD.
As much as possible, tools included in base are used.
Therefore, some choice have been made to focus on simplicity and
efficiency.

## Wait, where is my desktop ?

Right before your eyes.
The default window manager in isotop is
[cwm](https://man.openbsd.org/cwm). Its simplicity help to focus and be
efficient.

Before installing another window manager or desktop environment, give
cwm a try. We tried to make is nice to use 
(see "[How to use my desktop](#cwmtuto)?").

## What are the differences with a vanilla OpenBSD ?

* unwind(8) is configured as default domain name resolver.
* Use unwind-block script to adblock some domains. 
  [see unwind-block](#unwind-block).
* Customized message in /etc/boot.conf
* Enable services hotplugd, messagebus, cups, xenodm, unwind.
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
* $HOME/.aliases and $HOME/.functions are filled with some (useful ?) stuff.
* $HOME/.kshrc if filled with some autocompletion for OpenBSD.


## Why this name ?

At first, isotop was a iso file containing all packages and
configuration for intallation.
Now it's just a script to configure a vanilla OpenBSD.

Like an [isotope](https://en.wikipedia.org/wiki/Isotope), it is a
variant of OpenBSD with a few more things inside, but still OpenBSD.


## Can I install another web browser ?

Of course.

Firefox and chromium, amongst others, are available in ports.

However, we choosed iridium because : 

* It is unveiled, meaning it can't access your personal files that might
  contains password or ssh keys.
* It is more privacy friendly than chromium.


## Can I install another desktop environment ?

Of course.

Gnome, kde, lxde, xfce and more are availables for OpenBSD via ports.

## What does unwind-block do ?
<span id="unwind-block"></span>

In order to save your bandwidth and filter ads without any browser
addon, a script called ``unwind-block`` is executed at boot (see
``/etc/rc.local``).

Every 7 days, the script download a list of "bad domains" and record
them in ``/var/unwind.block``. Thus, unwind can choose not to resolve
them.

If you try to access one of these domains (why?), you'll get an error.

## How to use my desktop ?
<span id="cwmtuto"></span>

