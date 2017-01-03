#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : download all packages and theirs dependencies

. ./obsdiso.conf
OUTDIR=site/home/root/pkg_cache

TODL="ImageMagick-6.9.4.10.tgz
aalib-1.4p6.tgz
adwaita-icon-theme-3.20.tgz
aspell-0.60.6.1p3.tgz
aspell-fr-0.50.3v1.tgz
at-spi2-atk-2.20.1.tgz
at-spi2-core-2.20.2.tgz
atk-2.20.0.tgz
atk2mm-2.24.2.tgz
avahi-0.6.31p24.tgz
babl-0.1.16.tgz
bash-4.3.46.tgz
blas-1.0p7.tgz
boehm-gc-7.4.2p0.tgz
bzip2-1.0.6p8.tgz
cairo-1.14.6p1.tgz
cairomm-1.12.0.tgz
cdparanoia-3.a9.8p3.tgz
clisp-2.49.tgz
clucene-core-2.3.3.4p1.tgz
colord-1.3.2.tgz
conky-1.9.0p8.tgz
consolekit2-1.0.2.tgz
cowsay-3.03.tgz
cups-2.1.4.tgz
cups-filters-1.9.0p0.tgz
cups-libs-2.1.4.tgz
curl-7.49.0.tgz
cyrus-sasl-2.1.26p17.tgz
dbus-1.10.8v0.tgz
dbus-daemon-launch-helper-1.10.8.tgz
dbus-glib-0.106v0.tgz
dconf-0.26.0.tgz
desktop-file-utils-0.23.tgz
detex-2.8.1.tgz
detox-1.2.0.tgz
djvulibre-3.5.27p0.tgz
dmenu-4.6.tgz
dvi2tty-5.3.1p0.tgz
e2fsprogs-1.42.12p3.tgz
enchant-1.6.0p3.tgz
feh-2.16.1.tgz
ffcall-1.10p3.tgz
ffmpeg-20160502.tgz
ffmpeg2theora-0.29p3.tgz
fftw3-3.3.4p0.tgz
fftw3-common-3.3.4p0.tgz
filezilla-3.8.1p3.tgz
firefox-esr-45.2.0.tgz
firefox-esr-i18n-fr-45.2.0.tgz
flac-1.3.1p0.tgz
fluxbox-1.3.7p0.tgz
foomatic-db-4.0.20150819.tgz
foomatic-db-engine-4.0.12p0.tgz
fribidi-0.19.7.tgz
gamin-0.1.10p21.tgz
garcon-0.4.0.tgz
gcc-libs-4.9.3p9.tgz
gconf2-3.2.6p8.tgz
gcr-3.20.0.tgz
gd-2.1.1p3.tgz
gdbm-1.12.tgz
gdk-pixbuf-2.34.0.tgz
gegl-0.2.0p3.tgz
geoclue2-2.4.3p0.tgz
gettext-0.19.7.tgz
ghostscript-9.07p3.tgz
ghostscript-fonts-8.11p3.tgz
giblib-1.2.4p6.tgz
giflib-5.1.4.tgz
gimp-2.8.16.tgz
glew-1.12.0.tgz
glib2-2.48.1.tgz
glib2-networking-2.48.2.tgz
glib2mm-2.48.1.tgz
gmp-5.0.2p3.tgz
gnome-colors-icon-theme-5.5.1p8.tgz
gnome-icon-theme-3.12.0p3.tgz
gnome-icon-theme-symbolic-3.12.0p2.tgz
gnupg-2.1.9p0.tgz
gnutls-3.4.14.tgz
gobject-introspection-1.48.0.tgz
graphite2-1.3.8.tgz
gsettings-desktop-schemas-3.20.0p1.tgz
gsl-1.15p2.tgz
gsm-1.0.14.tgz
gstreamer-0.10.36p9.tgz
gstreamer-ffmpeg-0.10.13p11.tgz
gstreamer-plugins-bad-0.10.23p22.tgz
gstreamer-plugins-base-0.10.36p14.tgz
gstreamer-plugins-good-0.10.31p16v0.tgz
gstreamer-plugins-ugly-0.10.19p6.tgz
gstreamer1-1.8.2.tgz
gstreamer1-plugins-base-1.8.2.tgz
gtar-1.29.tgz
gtk+2-2.24.30.tgz
gtk+3-3.20.6.tgz
gtk-update-icon-cache-3.20.6.tgz
gtk2mm-2.24.4p2.tgz
gtksourceview-2.10.5p3.tgz
gtkspell-2.0.16p8.tgz
gummi-0.6.5p1.tgz
gvfs-1.28.2p0.tgz
hack-fonts-2.019.tgz
harfbuzz-1.2.7.tgz
harfbuzz-icu-1.2.7.tgz
hicolor-icon-theme-0.15.tgz
hunspell-1.3.2p2.tgz
hyphen-2.8.8.tgz
icedtea-web-1.6.2.tgz
icu4c-57.1.tgz
ijs-0.35p2.tgz
imlib2-1.4.7p1.tgz
inkscape-0.91p9.tgz
iodbc-3.52.10.tgz
iso-codes-3.68.tgz
jasper-1.900.1p5.tgz
jbig2dec-0.11.tgz
jbigkit-2.1.tgz
jdk-1.7.0.80p1v0.tgz
jpeg-1.5.0p0v0.tgz
json-glib-1.2.0.tgz
lame-3.99.5p0.tgz
lapack-3.1.1p5.tgz
lcms-1.19.tgz
lcms2-2.7.tgz
ldb-1.1.26p0.tgz
leafpad-0.8.18.1p3.tgz
liba52-0.7.5p2.tgz
libarchive-3.2.1.tgz
libass-0.13.2.tgz
libassuan-2.1.1.tgz
libbluray-0.9.3.tgz
libcdaudio-0.99.12p2.tgz
libcddb-1.3.2p0.tgz
libcdio-0.80p7.tgz
libcroco-0.6.11.tgz
libcue-1.4.0p0.tgz
libdaemon-0.14p1.tgz
libdca-0.0.5p4.tgz
libdvdcss-1.4.0.tgz
libdvdnav-5.0.3v0.tgz
libdvdread-5.0.3p0.tgz
libelf-0.8.13p3.tgz
liberation-fonts-2.00.1p0.tgz
libevent-2.0.22p0.tgz
libexecinfo-0.3v0.tgz
libexif-0.6.21p0.tgz
libf2c-3.3.6p9.tgz
libffi-3.2.1p2.tgz
libfm-1.2.4.tgz
libfm-extra-1.2.4.tgz
libgcrypt-1.7.1.tgz
libglade2-2.6.4p12v0.tgz
libgpg-error-1.23.tgz
libiconv-1.14p3.tgz
libid3tag-0.15.1bp4.tgz
libidn-1.32p1.tgz
libksba-1.3.3p0.tgz
liblrdf-0.5.0p4.tgz
libltdl-2.4.2p1.tgz
libmms-0.6.2p3.tgz
libmng-1.0.10p3.tgz
libmspack-0.5alphav0.tgz
libnatpmp-20140401p0.tgz
libnettle-3.2.tgz
libnotify-0.7.6p0.tgz
libogg-1.3.2p0.tgz
libpaper-1.1.24.4.tgz
libproxy-0.4.12p1.tgz
libreoffice-5.1.4.2p0v0.tgz
libreoffice-i18n-fr-5.1.4.2v0.tgz
librsvg-2.40.16.tgz
libsecret-0.18.5.tgz
libshout-2.3.1.tgz
libsigc++-2.8.0.tgz
libsigsegv-2.10p2.tgz
libsndfile-1.0.26.tgz
libsoup-2.54.1.tgz
libtalloc-2.1.7.tgz
libtasn1-4.8.tgz
libtheora-1.1.1p3.tgz
libusb-compat-0.1.5p0.tgz
libusb1-1.0.20.tgz
libv4l-1.10.1p0.tgz
libvorbis-1.3.5.tgz
libvpx-1.5.0p0.tgz
libwebp-0.5.0.tgz
libwmf-0.2.8.4p4.tgz
libxfce4ui-4.12.1p2.tgz
libxfce4util-4.12.1.tgz
libxkbcommon-0.6.1.tgz
libxml-2.9.3.tgz
libxslt-1.1.28p5.tgz
libyajl-2.1.0.tgz
lua-5.1.5p6.tgz
lynx-2.8.9pl9.tgz
lz4-0.131p1.tgz
lzo2-2.09.tgz
menu-cache-1.0.1.tgz
miniupnpc-1.9p1.tgz
mozilla-dicts-en-GB-1.3p1.tgz
mozilla-dicts-fr-1.3p1.tgz
mozjs17-17.0p3.tgz
mpfr-3.1.0.3p0.tgz
mpv-0.18.0.tgz
mupdf-1.8p3.tgz
musepack-475p1.tgz
neon-0.30.1.tgz
nghttp2-1.12.0.tgz
npth-1.2.tgz
nspr-4.12p0.tgz
nss-3.24.tgz
ntfs_3g-2016.2.22.tgz
numlockx-1.2.tgz
openjp2-2.1.0.tgz
openjpeg-1.5.1p1.tgz
openldap-client-2.4.44.tgz
openpam-20141014.tgz
optipng-0.7.6.tgz
opus-1.1.2.tgz
orc-0.4.24.tgz
p11-kit-0.23.2p0.tgz
p5-Clone-0.38.tgz
p5-DBI-1.633.tgz
p5-FreezeThaw-0.5001.tgz
p5-MLDBM-2.05.tgz
p5-Math-Base-Convert-0.08.tgz
p5-Module-Runtime-0.014.tgz
p5-Net-Daemon-0.48p0.tgz
p5-Params-Util-1.07p1.tgz
p5-PlRPC-0.2020.tgz
p5-SQL-Statement-1.407.tgz
p7zip-15.14.1p1.tgz
pango-1.40.1.tgz
pangomm-2.40.0.tgz
pcmanfm-1.2.4.tgz
pcre-8.38p0.tgz
pinentry-0.9.6p3.tgz
png-1.6.23.tgz
poezio-0.9p0.tgz
polkit-0.113p3.tgz
poppler-0.45.0p0.tgz
poppler-data-0.4.7.tgz
poppler-utils-0.45.0p0.tgz
popt-1.16p1.tgz
postgresql-client-9.5.3.tgz
potrace-1.13.tgz
ps2eps-1.68p0.tgz
psutils-1.23.tgz
py-MarkupSafe-0.23p1.tgz
py-beaker-1.6.2p4.tgz
py-cairo-1.10.0p1.tgz
py-chardet-2.3.0.tgz
py-crypto-2.6.1p2.tgz
py-dnspython-1.12.0p0.tgz
py-gobject-2.28.6p6v0.tgz
py-gobject3-common-3.20.1.tgz
py-gtk2-2.24.0p3.tgz
py-lxml-3.4.3p1.tgz
py-mako-0.9.1p2.tgz
py-numpy-1.9.2.tgz
py-setuptools-18.2p0v0.tgz
py3-Pillow-3.2.0.tgz
py3-aiodns-1.0.1.tgz
py3-asn1-0.1.9p0v0.tgz
py3-asn1-modules-0.0.8p1.tgz
py3-cairo-1.10.0p2.tgz
py3-cares-2.0.1.tgz
py3-crypto-2.6.1p2.tgz
py3-gobject3-3.20.1p0.tgz
py3-potr-1.0.1.tgz
py3-setuptools-18.2p0v0.tgz
py3-slixmpp-1.1p0.tgz
py3-xdg-0.25p2.tgz
python-2.7.12.tgz
python-3.4.5.tgz
python-tkinter-3.4.5.tgz
qpdf-6.0.0.tgz
quirks-2.241.tgz
ranger-1.7.2.tgz
raptor-2.0.15p0.tgz
rasqal-0.9.33p0.tgz
redland-1.0.17p1.tgz
redshift-1.11.tgz
rxvt-unicode-9.22p0.tgz
samba-4.4.5.tgz
samba-util-4.4.5.tgz
sane-backends-1.0.25p4.tgz
scrot-0.8p3.tgz
sdl-1.2.15p7.tgz
sdl-image-1.2.12p3.tgz
sdl2-2.0.4p0.tgz
shared-mime-info-1.6.tgz
simple-scan-3.18.0.tgz
slim-1.3.6p11.tgz
soundtouch-1.9.2.tgz
spandsp-0.0.6.tgz
speex-1.2rc1p1.tgz
startup-notification-0.12p4.tgz
stone-soup-0.15.2p0.tgz
t1utils-1.39.tgz
taglib-1.9.1p1.tgz
tcl-8.5.18p1.tgz
tdb-1.3.9.tgz
terminus-font-4.40p0.tgz
tevent-0.9.28p0.tgz
texlive_base-2015.tgz
texlive_texmf-buildset-2015.tgz
thunderbird-45.2.0.tgz
thunderbird-i18n-fr-45.2.0.tgz
tiff-4.0.6p1.tgz
tk-8.5.18p1.tgz
tktray-1.3.9p2.tgz
transmission-2.92p0.tgz
transmission-gtk-2.92p0.tgz
tremor-20120410p1.tgz
twolame-0.3.13p1.tgz
unzip-6.0p9.tgz
vim-7.4.1467p1-gtk2.tgz
vim-7.4.1467p1-no_x11.tgz
vim-spell-fr-7.4.tgz
wavpack-4.80.0.tgz
webkitgtk4-2.12.3.tgz
wxWidgets-gtk2-2.8.12p12.tgz
x264-20160508.tgz
x265-1.9p0.tgz
xarchiver-0.5.4p0.tgz
xclip-0.12p0.tgz
xcursor-dmz-0.4p0.tgz
xdg-utils-1.1.1.tgz
xdotool-3.20150503.1v0.tgz
xfce4-appfinder-4.12.0p0.tgz
xfconf-4.12.0p0.tgz
xvidcore-1.3.4.tgz
xz-5.2.2p0.tgz
yelp-3.20.1.tgz
yelp-xsl-3.20.1.tgz
youtube-dl-2016.07.09.2.tgz
zip-3.0p0.tgz
zziplib-0.13.62p0.tgz
"

mkdir -p $OUTDIR

if [ "$(uname)" = "OpenBSD" ]; then
    DLER="ftp -C"
else
    if [ -n "$(command -v curl)" ]; then
        DLER="curl -# -C -"
    elif [ -n "$(command -v wget)" ]; then
        DLER="wget"
    fi
fi

for p in $TODL; do
    $DLER $PKG_PATH/$p
    mv $p $OUTDIR/
done

exit 0
