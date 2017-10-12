# Installation procedure : 

At any prompt except password prompts you can escape to a shell by
typing '!'. Default answers are shown in []'s and are selected by
pressing RETURN.  You can exit this program at any time by pressing
Control-C, but this can leave your system in an inconsistent state.

Choose your keyboard layout ('?' or 'L' for list) [default] Enter

System hostname? (short form, e.g. 'foo') puffy

Available network interfaces are: fxp0 vlan0.
Which one do you wish to configure? (or 'done') [fxp0] Enter

IPv4 address for fxp0? (or 'dhcp' or 'none') [dhcp] Enter
DHCPDISCOVER on fxp0 to 255.255.255.255 port 67 interval 1
DHCPOFFER from 192.168.1.250 (08:00:20:94:0b:c8)
DHCPREQUEST on fxp0 to 255.255.255.255 port 67
DHCPACK from 192.168.1.250 (08:00:20:94:0b:c8)
bound to 192.168.1.199 -- renewal in 43200 seconds.

  IPv6 address for fxp0? (or 'rtsol' or 'none') [none] Enter
  Available network interfaces are: fxp0 vlan0.
  Which one do you wish to configure? (or 'done') [done] Enter
  Using DNS domainname example.org
  Using DNS nameservers at 192.168.1.252

  Password for root account? (will not echo) ****
  Password for root account? (again) ****

 Start sshd(8) by default? [yes] no
Start ntpd(8) by default? [no]
{Enter}

  Do you expect to run the X Window System? [yes] Enter
  Do you want the X Window System to be started by xdm(1)? [no] y

Setup a user? (Enter a lowercase login name, or 'no') [no]
gabriel{Enter}
 
Full user name for gabriel? [gabriel]
Gabriel Hautclocq
 
Password for gabriel account? (will not echo)
(user password){Enter}
 
Password for gabriel account? (again)
(user password){Enter}
 
Since you set up a user, disable sshd(8) logins to root? [yes]
{Enter}
What timezone are you in?
{Enter}
Available disks are: wd0

MBR has invalid signature; not showing it.
Use (W)hole disk or (E)dit the MBR? [whole]
{Enter}
Which one is the root disk? (or 'done') [wd0]
{Enter}

Use (A)uto layout, (E)dit auto layout, or (C)reate custom layout? [a]
{Enter}

Lets install the sets!
Location of sets? (cd disk ftp http or 'done') [cd]
{Enter}
 
Available CD-ROMs are: cd0
Which one contains the install media? (or 'done') [cd0]
{Enter}
 
Pathname of the sets? (or 'done') [6.2/amd64]
{Enter}
 
Set name(s)? (or 'abort' or 'done') [done]
all{Enter}
 
Set name(s)? (or 'abort' or 'done') [done]
{Enter}
