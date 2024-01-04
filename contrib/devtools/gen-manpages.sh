#!/bin/sh

TOPDIR=${TOPDIR:-$(git rev-parse --show-toplevel)}
SRCDIR=${SRCDIR:-$TOPDIR/src}
MANDIR=${MANDIR:-$TOPDIR/doc/man}

CLD=${CLD:-$SRCDIR/cld}
CLCLI=${CLCLI:-$SRCDIR/cl-cli}
CLTX=${CLTX:-$SRCDIR/cl-tx}
CLQT=${CLQT:-$SRCDIR/qt/cl-qt}

[ ! -x $CLD ] && echo "$CLD not found or not executable." && exit 1

# The autodetected version git tag can screw up manpage output a little bit
clVER=($($CLCLI --version | head -n1 | awk -F'[ -]' '{ print $6, $7 }'))

# Create a footer file with copyright content.
# This gets autodetected fine for cld if --version-string is not set,
# but has different outcomes for cl-qt and cl-cli.
echo "[COPYRIGHT]" > footer.h2m
$CLD --version | sed -n '1!p' >> footer.h2m

for cmd in $CLD $CLCLI $CLTX $CLQT; do
  cmdname="${cmd##*/}"
  help2man -N --version-string=${clVER[0]} --include=footer.h2m -o ${MANDIR}/${cmdname}.1 ${cmd}
  sed -i "s/\\\-${clVER[1]}//g" ${MANDIR}/${cmdname}.1
done

rm -f footer.h2m
