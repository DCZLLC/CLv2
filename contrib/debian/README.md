
Debian
====================
This directory contains files used to package cld/cl-qt
for Debian-based Linux systems. If you compile cld/cl-qt yourself, there are some useful files here.

## cl: URI support ##


cl-qt.desktop  (Gnome / Open Desktop)
To install:

	sudo desktop-file-install cl-qt.desktop
	sudo update-desktop-database

If you build yourself, you will either need to modify the paths in
the .desktop file or copy or symlink your cl-qt binary to `/usr/bin`
and the `../../share/pixmaps/cl128.png` to `/usr/share/pixmaps`

cl-qt.protocol (KDE)

