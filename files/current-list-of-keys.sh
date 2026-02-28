#!/bin/sh
#
# list all available knot keys
# into a file if sepcified, else stdout
#
if [ -n "$1" ] ;then
  exec > $1
fi

for dom in $(keymgr --list) ; do
        echo 
        echo === ${dom} 
        keymgr ${dom} list iso
done
