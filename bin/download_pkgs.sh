#!/bin/sh
# Auteur :      thuban <thuban@yeuxdelibad.net>
# licence :     MIT

# Description : download all packages and theirs dependencies

. ./obsdiso.conf
OUTDIR=site/home/root/pkg_cache

TODL="
ImageMagick-6.9.9.11.tgz
aalib-1.4p6.tgz
adwaita-icon-theme-3.24.0.tgz
aspell-0.60.6.1p5.tgz
aspell-fr-0.50.3v1.tgz
at-spi2-atk-2.24.1.tgz
at-spi2-core-2.24.1.tgz
atk-2.24.0p0.tgz
atk2mm-2.24.2p0.tgz
avahi-0.7p0.tgz
babl-0.1.30.tgz
bash-4.4.12p0.tgz
blas-1.0p8.tgz
boehm-gc-7.6.0p1.tgz
bzip2-1.0.6p8.tgz
cairo-1.14.10.tgz
cairomm-1.12.2p0.tgz
cantarell-fonts-0.0.25.tgz
catfish-1.4.2p0.tgz
cdparanoia-3.a9.8p3.tgz
clucene-core-2.3.3.4p2.tgz
colord-1.3.5.tgz
consolekit2-1.2.0.tgz
cowsay-3.03.tgz
cups-2.2.4p3.tgz
cups-filters-1.17.7.tgz
cups-libs-2.2.4p1.tgz
cups-pk-helper-0.2.6.tgz
curl-7.55.1.tgz
cyrus-sasl-2.1.26p24.tgz
dbus-1.10.22p0v0.tgz
dbus-daemon-launch-helper-1.10.22p0.tgz
dbus-glib-0.108v0.tgz
dconf-0.26.0.tgz
deadbeef-0.7.2p4.tgz
desktop-file-utils-0.23.tgz
detox-1.2.0.tgz
dina-fonts-2.92p1.tgz
djvulibre-3.5.27p2.tgz
dmenu-4.7.tgz
e2fsprogs-1.42.12p4.tgz
eboard-1.1.1p3.tgz
enchant-1.6.1p1.tgz
evince-3.24.1p0-light.tgz
exo-0.10.7p0.tgz
faad-2.7p2.tgz
ffmpeg-20170825p1.tgz
ffmpeg2theora-0.29p3.tgz
ffmpegthumbnailer-2.0.8p5.tgz
fftw3-3.3.4p0.tgz
fftw3-common-3.3.4p0.tgz
firefox-56.0.tgz
firefox-i18n-fr-56.0.tgz
flac-1.3.2p1.tgz
foomatic-db-4.0.20170503.tgz
foomatic-db-engine-4.0.12p1.tgz
freeciv-client-2.5.7.tgz
freeciv-share-2.5.7.tgz
freefont-ttf-20120503.tgz
fribidi-0.19.7.tgz
garcon-0.6.1.tgz
gconf2-3.2.6p8.tgz
gcr-3.20.0.tgz
gdbm-1.13.tgz
gdk-pixbuf-2.36.10p0.tgz
geany-1.29p0.tgz
gegl-0.2.0p4.tgz
geoclue2-2.4.7.tgz
gettext-0.19.8.1p1.tgz
ghostscript-9.07p4.tgz
ghostscript-fonts-8.11p3.tgz
giflib-5.1.4.tgz
gimp-2.8.22.tgz
glew-2.0.0.tgz
glfw-3.2.1p0.tgz
glib2-2.52.3.tgz
glib2-networking-2.50.0p3.tgz
glib2mm-2.52.1.tgz
gmp-6.1.2p1.tgz
gnome-icon-theme-3.12.0p3.tgz
gnome-icon-theme-symbolic-3.12.0p2.tgz
gnome-themes-standard-3.22.3.tgz
gnupg-2.1.23.tgz
gnutls-3.5.15.tgz
gobject-introspection-1.52.1p0.tgz
graphite2-1.3.10p1.tgz
gsettings-desktop-schemas-3.24.1.tgz
gsl-1.15p2.tgz
gsm-1.0.17.tgz
gstreamer-0.10.36p12.tgz
gstreamer-plugins-base-0.10.36p17.tgz
gstreamer-plugins-good-0.10.31p22v0.tgz
gstreamer1-1.12.3.tgz
gstreamer1-plugins-bad-1.12.3p0.tgz
gstreamer1-plugins-base-1.12.3.tgz
gstreamer1-plugins-good-1.12.3p0.tgz
gstreamer1-plugins-libav-1.12.3.tgz
gstreamer1-plugins-ugly-1.12.3p0.tgz
gtar-1.29.tgz
gtk+2-2.24.31p1.tgz
gtk+2-cups-2.24.31p2.tgz
gtk+3-3.22.21p0.tgz
gtk+3-cups-3.22.21p0.tgz
gtk-engines2-2.20.2p7.tgz
gtk-update-icon-cache-3.22.21p0.tgz
gtk-xfce-engine-3.2.0p1.tgz
gtk2-murrine-engine-0.98.2p5.tgz
gtk2mm-2.24.5p0.tgz
gtksourceview-2.10.5p3.tgz
gtkspell-2.0.16p9.tgz
gutenprint-5.2.13.tgz
gvfs-1.32.1.tgz
hack-fonts-2.020.tgz
harfbuzz-1.5.1.tgz
harfbuzz-icu-1.5.1.tgz
hermit-font-1.21p1.tgz
hicolor-icon-theme-0.17.tgz
hunspell-1.6.1p1.tgz
hyphen-2.8.8.tgz
icedtea-web-1.6.2p4.tgz
icu4c-58.2p5.tgz
ijs-0.35p2.tgz
imlib2-1.4.10.tgz
inkscape-0.92.2.tgz
iso-codes-3.76.tgz
ja-fonts-funet-19911117p1.tgz
ja-fonts-gnu-1.2.1.tgz
jansson-2.10.tgz
jasper-1.900.1p5.tgz
jbig2dec-0.11.tgz
jbigkit-2.1.tgz
jdk-1.8.0.144v0.tgz
jmk-fonts-3.0p5.tgz
jpeg-1.5.1p0v0.tgz
json-glib-1.2.8p1.tgz
lame-3.99.5p1.tgz
lapack-3.1.1p5.tgz
lcms-1.19.tgz
lcms2-2.7.tgz
libarchive-3.3.2.tgz
libass-0.13.7.tgz
libassuan-2.4.3p0.tgz
libbluray-1.0.0.tgz
libbs2b-3.1.0p2.tgz
libcddb-1.3.2p0.tgz
libcdio-0.80p9.tgz
libcroco-0.6.12.tgz
libcue-1.4.0p0.tgz
libdaemon-0.14p1.tgz
libdvdcss-1.4.0.tgz
libdvdnav-5.0.3v0.tgz
libdvdread-5.0.3p0.tgz
libelf-0.8.13p3.tgz
liberation-fonts-2.00.1p0.tgz
libevent-2.0.22p0.tgz
libexecinfo-0.3p0v0.tgz
libexif-0.6.21p0.tgz
libf2c-3.3.6p11.tgz
libffi-3.2.1p2.tgz
libgcrypt-1.8.1.tgz
libglade2-2.6.4p13v0.tgz
libgnome-keyring-3.12.0p4.tgz
libgpg-error-1.27p0.tgz
libgsf-1.14.41.tgz
libical-2.0.0p1.tgz
libiconv-1.14p3.tgz
libid3tag-0.15.1bp4.tgz
libidn2-2.0.0.tgz
libksba-1.3.5p0.tgz
libltdl-2.4.2p1.tgz
libmad-0.15.1bp4.tgz
libmagic-5.32.tgz
libmms-0.6.2p3.tgz
libmng-1.0.10p3.tgz
libnatpmp-20150609.tgz
libnettle-3.3p0.tgz
libnotify-0.7.7.tgz
libogg-1.3.2p0.tgz
libproxy-0.4.15p0.tgz
libqrencode-3.4.4p0.tgz
libraw-0.18.2p0.tgz
libreoffice-5.2.7.2p6v0.tgz
libreoffice-i18n-fr-5.2.7.2p1v0.tgz
librsvg-2.40.18.tgz
libsecret-0.18.5.tgz
libshout-2.3.1.tgz
libsigc++-2.10.0p1.tgz
libsndfile-1.0.27.tgz
libsoup-2.58.2p0.tgz
libspectre-0.2.8p2.tgz
libtasn1-4.12.tgz
libtheora-1.1.1p3.tgz
libunique-1.1.6p9.tgz
libunistring-0.9.7.tgz
libusb1-1.0.21.tgz
libv4l-1.12.5.tgz
libvorbis-1.3.5.tgz
libvpx-1.6.1p0.tgz
libwebp-0.5.2.tgz
libwmf-0.2.8.4p4.tgz
libwnck-2.30.7p6.tgz
libxfce4ui-4.12.1p3.tgz
libxfce4util-4.12.1p0.tgz
libxkbcommon-0.7.2.tgz
libxklavier-5.4.tgz
libxml-2.9.5.tgz
libxslt-1.1.30p0.tgz
libyajl-2.1.0.tgz
libzip-1.3.0.tgz
linuxlibertine-fonts-otf-5.3.0p0.tgz
linuxlibertine-fonts-ttf-5.3.0p0.tgz
lua-5.1.5p6.tgz
lua-5.2.4p1.tgz
lz4-1.8.0p0.tgz
lzo2-2.10.tgz
miniupnpc-1.9p1.tgz
mousepad-0.4.0p2.tgz
mozilla-dicts-en-GB-1.3p1.tgz
mozilla-dicts-fr-1.3p1.tgz
mozjs17-17.0p4.tgz
mpfr-3.1.5.2.tgz
mpv-0.22.0p0.tgz
mupdf-1.11p1.tgz
musepack-475p2.tgz
neon-0.30.2p0.tgz
nghttp2-1.26.0.tgz
noto-emoji-20150929p0.tgz
noto-fonts-20150929p2.tgz
npth-1.5.tgz
nspr-4.17.tgz
nss-3.33.tgz
ntfs_3g-2016.2.22.tgz
openjp2-2.2.0.tgz
openldap-client-2.4.45p4.tgz
optipng-0.7.6.tgz
opus-1.2.1.tgz
orage-4.12.1p1.tgz
orc-0.4.24p0.tgz
p11-kit-0.23.2p0.tgz
p5-Clone-0.38.tgz
p5-DBI-1.633.tgz
p5-FreezeThaw-0.5001.tgz
p5-MLDBM-2.05.tgz
p5-Math-Base-Convert-0.08p0.tgz
p5-Module-Runtime-0.014.tgz
p5-Net-Daemon-0.48p0.tgz
p5-Params-Util-1.07p1.tgz
p5-PlRPC-0.2020.tgz
p5-SQL-Statement-1.407.tgz
p5-URI-1.71.tgz
p7zip-16.02p3.tgz
pango-1.40.12p0.tgz
pangomm-2.40.1p0.tgz
pcre-8.40p1.tgz
pcre2-10.23.tgz
pinentry-1.0.0.tgz
png-1.6.31.tgz
polkit-0.113p4.tgz
poppler-0.57.0.tgz
poppler-data-0.4.8.tgz
poppler-utils-0.57.0.tgz
popt-1.16p1.tgz
postgresql-client-9.6.5.tgz
potrace-1.15.tgz
py-MarkupSafe-1.0.tgz
py-beaker-1.6.2p5.tgz
py-cairo-1.15.3.tgz
py-chardet-3.0.4.tgz
py-crypto-2.6.1p4.tgz
py-dbus-common-1.2.4.tgz
py-gobject-2.28.6p6v0.tgz
py-gobject3-common-3.24.1.tgz
py-gtk2-2.24.0p4.tgz
py-lxml-3.7.0p0.tgz
py-mako-0.9.1p3.tgz
py-numpy-1.9.2p0.tgz
py-setuptools-28.6.1p0v0.tgz
py3-Pillow-3.4.2p1.tgz
py3-cairo-1.15.3.tgz
py3-cups-1.9.73.tgz
py3-curl-7.43.0p1.tgz
py3-dbus-1.2.4p0.tgz
py3-gobject3-3.24.1p1.tgz
py3-pexpect-4.2.1p0.tgz
py3-ptyprocess-0.5.1p0.tgz
py3-setuptools-28.6.1p0v0.tgz
py3-xdg-0.25p3.tgz
python-2.7.14.tgz
python-3.6.2.tgz
python-tkinter-3.6.2.tgz
qpdf-7.0beta1.tgz
quirks-2.367.tgz
ranger-1.7.2p0.tgz
raptor-2.0.15p1.tgz
rasqal-0.9.33p1.tgz
redland-1.0.17p4.tgz
redshift-1.11p0.tgz
ristretto-0.8.2.tgz
roboto-fonts-1.2p2v0.tgz
sane-backends-1.0.27p0.tgz
sdl-1.2.15p7.tgz
sdl2-2.0.5p1.tgz
sdl2-image-2.0.1.tgz
shared-mime-info-1.9.tgz
simple-scan-3.24.1.tgz
soundtouch-1.9.2p2.tgz
speex-1.2.0.tgz
speexdsp-1.2rc3.tgz
sqlite3-3.20.1.tgz
sselp-0.2p1.tgz
startup-notification-0.12p4.tgz
stone-soup-0.18.1p0.tgz
syncthing-0.14.30.tgz
system-config-printer-1.5.9p0.tgz
taglib-1.9.1p3.tgz
tb-browser-7.0.5p0.tgz
tb-https-everywhere-2017.8.31.tgz
tb-noscript-5.0.9.tgz
tcl-8.5.19p0.tgz
teeworlds-0.6.4p0.tgz
terminus-font-4.46.tgz
thunar-1.6.12.tgz
thunar-archive-0.3.1p3.tgz
thunderbird-52.2.1p3.tgz
thunderbird-i18n-fr-52.2.1.tgz
tiff-4.0.8p1.tgz
tk-8.5.19p0.tgz
tktray-1.3.9p4.tgz
tor-browser-7.0.5.tgz
tor-launcher-0.2.12.3p0.tgz
torbutton-1.9.7.6.tgz
transmission-2.92p4.tgz
transmission-gtk-2.92p4.tgz
tremor-20120410p1.tgz
tumbler-0.2.0.tgz
twolame-0.3.13p1.tgz
ubuntu-fonts-0.83.tgz
un-fonts-core-1.0.2.080608p1.tgz
un-fonts-extra-1.0.2.080608p1.tgz
unrar-5.50v1.tgz
unzip-6.0p11.tgz
upower-0.99.4p1.tgz
vim-8.0.0987p0-no_x11.tgz
vte3-0.48.3p0.tgz
w3m-0.5.3p5.tgz
wavpack-5.1.0p0.tgz
webkitgtk4-2.18.0.tgz
x264-20170717.tgz
x265-2.5p0.tgz
xarchiver-0.5.4p1.tgz
xclip-0.13.tgz
xdg-user-dirs-0.16.tgz
xdg-utils-1.1.2.tgz
xdotool-3.20150503.1v0.tgz
xfce-4.12p6.tgz
xfce4-appfinder-4.12.0p1.tgz
xfce4-battery-1.1.0p0.tgz
xfce4-clipman-1.4.2.tgz
xfce4-cpugraph-1.0.5p5.tgz
xfce4-datetime-0.7.0p0.tgz
xfce4-diskperf-2.6.1.tgz
xfce4-genmon-4.0.0.tgz
xfce4-mailwatch-1.2.0p5.tgz
xfce4-mixer-4.11.0p2.tgz
xfce4-mount-1.1.2.tgz
xfce4-netload-1.3.1.tgz
xfce4-notes-1.8.1p0.tgz
xfce4-notifyd-0.3.6.tgz
xfce4-panel-4.12.1p0.tgz
xfce4-places-1.7.0p1.tgz
xfce4-power-manager-1.6.0p0.tgz
xfce4-screenshooter-1.8.2p1.tgz
xfce4-session-4.12.1p2.tgz
xfce4-settings-4.12.1p0.tgz
xfce4-systemload-1.2.1.tgz
xfce4-taskmanager-1.2.0.tgz
xfce4-terminal-0.8.6.tgz
xfce4-time-out-1.0.2p1.tgz
xfce4-wavelan-0.6.0p0.tgz
xfce4-weather-0.8.9.tgz
xfce4-whiskermenu-1.7.2p1.tgz
xfconf-4.12.1p0.tgz
xfdesktop-4.12.3p0.tgz
xfwm4-4.12.4.tgz
xfwm4-themes-4.10.0.tgz
xvidcore-1.3.4.tgz
xz-5.2.3p0.tgz
yelp-3.22.0p3.tgz
yelp-xsl-3.20.1.tgz
youtube-dl-2017.08.23p0.tgz
zh-fonts-arphicttf-2.11p4.tgz
zh-fonts-kc-1.05p2.tgz
zh-wqy-bitmapfont-0.9.9.0p2.tgz
zip-3.0p0.tgz
"

mkdir -p $OUTDIR

if [ "$(uname)" = "OpenBSD" ]; then
    DLER="ftp -C"
else
    if [ -n "$(command -v curl)" ]; then
        DLER="curl -O -C -"
    elif [ -n "$(command -v wget)" ]; then
        DLER="wget --continue"
    fi
fi

for p in $TODL; do
    if [ ! -f $OUTDIR/$p ]; then
        $DLER $PKG_PATH/$p
        mv $p $OUTDIR/
    fi
done

exit 0
