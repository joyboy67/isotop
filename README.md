isotop
==========
Une OpenBSD facilitante pour découvrir ?


---

This is a set of scripts to help building custom OpenBSD iso.

Dependencies
------------
dvd+rw-tools (cdrtools)

Usage
-----

Just run (with root privileges)

	make download
    make 

To build a `CustomOBSD.iso` and `CustomOBSD.fs` files.


You can burn this iso file. 

To copy CustomOBSD.fs on a bootable USB key : 

    dd if=CustomOBSD.fs of=/dev/your_usb_device



Simple configuration
-------------

Edit the file `obdiso.conf` to customize the openbsd version, packages to install, mirror to use to download iso...

Advanced configuration
----------------------

You can get the build environment with

    make prepare 

The configuration can be personnalized by filling up a site/ directory.

Reproduce in this directory the file tree you want on your freshly
installed system. As example : 

    site/etc/skel/.profile
    site/etc/pkg.conf

You can put in the site/ directory two scripts (both must have 755
permission): 

- site/install.site : every command in this script will be executed just
  after the installation in the new system (chrooted)
- site/etc/rc.firsttime : this script will be executed at the first boot of
  the fresly installed system


isotop specific configuration
---------------------------

- Some packages are stored in site/root/pkg_cache with their
  dependencies to ease packages installation in rc.firsttime
