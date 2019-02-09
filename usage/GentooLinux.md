# Gentoo Installation

I'm documenting here, and following from the handbook.
I will be chrooting from another OS (Arch).
Also, I assume partitioning is done, and things are mounted at `/gentoo`.

## Tarball

After setting up partitions, all I did was unpack it.

```
cd /gentoo
sudo tar xpvf /home/sbp/Downloads/stage3-amd64-20190124T214501Z.tar.xz --xattrs-include='*.*' --numeric-owner
```

Then chrooting (my chroot-os script needs /bin/bash as second argument) works.

## World Set

I picked `default/linux/amd64/17.0` even though I know it wont work on my comp.
Will get the latest kernel later.

```
emerge --sync
eselect profile list
eselect profile set 12
emerge --ask --verbose --update --deep --newuse @world
```

## USE

`emerge --info | grep ^USE` gives me

```
USE="acl amd64 berkdb bzip2 cli crypt cxx dri fortran gdbm iconv ipv6 libtirpc multilib ncurses nls nptl openmp pam pcre readline seccomp ssl tcpd unicode xattr zlib"
```

along with some other variables.

I set mine in `/etc/portage/make.conf` (From `/usr/portage/profiles/use.desc`)

```
...
# Use flags
USE="X acpi alsa apache2 bash-completion blas bluetooth branding calendar crypt cups curl cxx djvu exif fftw flac ftp geoip geolocation gif gibp git gtk imagemagick imap inotify javascript jpeg jpeg2k -kde lapack latex libcaca libnotify lm_sensors lzo maildir matroska mp3 mp4 mpeg mysql mtp multilib musicbrainz ncurses mysqli nas nntp pdf -plasma png policykit posix pulseaudio python raw rdp rss sound ssl tiff udev udisks unicode upower usb vdpau vim-syntax vorbis wavpack wayland wifi xft xscreensaver zip zsh-completion"
```

## Locale

Edited `/etc/timezone` and `/etc/locale.gen`.

## Kernel

To allow installation of production not-ready kernel; I have in `/etc/portage/package.accept_keywords`

```
# Kernel
sys-kernel/gentoo-sources ~amd64
```

Then I installed `genkernel` and changed `/etc/genkernel.conf`

```
# Run 'make menuconfig' before compiling this kernel?
MENUCONFIG="yes"
```

## Boot

So far keymap during decryption and then LVM does not work!

* Added `keymap="dvorak"` in `/etc/conf.d/keymaps`
* `rc-update add keymaps boot` is already run.
* `rc-update add consolefont boot` added.
* Merged `sys-fs/lvm2`
* `rc-update add lvm boot` added.
* Adding `dolvm` in kernel parameters.
* Running `genkernel --no-splash --keymap --luks --lvm --disklabel --microcode --keymap --menuconfig all`
* Actually modified `/etc/genkernel.conf` and enabled all the above.
* Removed the Logo from Driver/Graphics options
* Adding keymap=dvorak to kernel options.


## Configuration

In `/etc/conf.d/hostname`

```
# Set the hostname variable to the selected host name
hostname="sbplaptop"
```

And in `/etc/conf.d/net`

```
# Set the dns_domain_lo variable to the selected domain name
dns_domain_lo="selfnetwork"
config_wifi="dhcp"
config_ethernet="dhcp"
```

Ran `passwd` to set up password.
Put `dvorak` in `/etc/conf.d/keymaps`


## Network

Ran `emerge --ask --noreplace net-misc/netifrc`

To have the network interfaces activated at boot,
they need to be added to the default runlevel.

```
cd /etc/init.d
ln -s net.lo net.ethernet
ln -s net.lo net.wifi
rc-update add net.ethernet default
rc-update add net.wifi default
```

Put in `/etc/hosts`

```
127.0.0.1   sbplaptop.selfnetwork sbplaptop localhost
```

Besides that have not configured the network stuff yet.

## Applications

For logging. I'm using syslog-ng.

```
rc-update add syslog-nd default
rc-update add fcron default
rc-update add iwd default
rc-update add dhcpcd default
```