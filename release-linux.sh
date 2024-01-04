VERSION=1.0.2.0
rm -rf ./release-linux
mkdir release-linux

cp ./src/cld ./release-linux/
cp ./src/cl-cli ./release-linux/
cp ./src/qt/cl-qt ./release-linux/
cp ./CLCOIN_small.png ./release-linux/

cd ./release-linux/
strip cld
strip cl-cli
strip cl-qt

#==========================================================
# prepare for packaging deb file.

mkdir clcoin-$VERSION
cd clcoin-$VERSION
mkdir -p DEBIAN
echo 'Package: clcoin
Version: '$VERSION'
Section: base 
Priority: optional 
Architecture: all 
Depends:
Maintainer: Cl
Description: Cl coin wallet and service.
' > ./DEBIAN/control
mkdir -p ./usr/local/bin/
cp ../cld ./usr/local/bin/
cp ../cl-cli ./usr/local/bin/
cp ../cl-qt ./usr/local/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../CLCOIN_small.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
#!/usr/bin/env xdg-open

[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/local/bin/cl-qt
Name=clcoin
Comment= cl coin wallet
Icon=/usr/share/icons/CLCOIN_small.png
' > ./usr/share/applications/clcoin.desktop

cd ../
# build deb file.
dpkg-deb --build clcoin-$VERSION

#==========================================================
# build rpm package
rm -rf ~/rpmbuild/
mkdir -p ~/rpmbuild/{RPMS,SRPMS,BUILD,SOURCES,SPECS,tmp}

cat <<EOF >~/.rpmmacros
%_topdir   %(echo $HOME)/rpmbuild
%_tmppath  %{_topdir}/tmp
EOF

#prepare for build rpm package.
rm -rf clcoin-$VERSION
mkdir clcoin-$VERSION
cd clcoin-$VERSION

mkdir -p ./usr/bin/
cp ../cld ./usr/bin/
cp ../cl-cli ./usr/bin/
cp ../cl-qt ./usr/bin/

# prepare for desktop shortcut
mkdir -p ./usr/share/icons/
cp ../CLCOIN_small.png ./usr/share/icons/
mkdir -p ./usr/share/applications/
echo '
[Desktop Entry]
Version=1.0
Type=Application
Terminal=false
Exec=/usr/bin/cl-qt
Name=clcoin
Comment= cl coin wallet
Icon=/usr/share/icons/CLCOIN_small.png
' > ./usr/share/applications/clcoin.desktop
cd ../

# make tar ball to source folder.
tar -zcvf clcoin-$VERSION.tar.gz ./clcoin-$VERSION
cp clcoin-$VERSION.tar.gz ~/rpmbuild/SOURCES/

# build rpm package.
cd ~/rpmbuild

cat <<EOF > SPECS/clcoin.spec
# Don't try fancy stuff like debuginfo, which is useless on binary-only
# packages. Don't strip binary too
# Be sure buildpolicy set to do nothing

Summary: Cl wallet rpm package
Name: clcoin
Version: $VERSION
Release: 1
License: MIT
SOURCE0 : %{name}-%{version}.tar.gz
URL: https://www.cryptoluck.online

BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

%description
%{summary}

%prep
%setup -q

%build
# Empty section.

%install
rm -rf %{buildroot}
mkdir -p  %{buildroot}

# in builddir
cp -a * %{buildroot}


%clean
rm -rf %{buildroot}


%files
/usr/share/applications/clcoin.desktop
/usr/share/icons/CLCOIN_small.png
%defattr(-,root,root,-)
%{_bindir}/*

%changelog
* Tue Aug 24 2021  Cl Project Team.
- First Build

EOF

rpmbuild -ba SPECS/clcoin.spec



