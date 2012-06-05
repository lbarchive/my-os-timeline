#!/bin/bash
# Builds dist files from the current working branch.
#
# You can specify the version as first argument:
#   ./build.sh 1234
#
# Exception: if the argument is "svg", this script 
# will only generate the svg file and omit the rest.


##########
# Configuration

# The basename of the .csv and .conf file
PROJNAME='mot'

# Custom path to gnuclad (leave empty if you already installed it in your PATH)
GC=

#
##########
# Code starts here

BDIR="dist"

# Check if which is present. Otherwise abort.
type -P which &>/dev/null || { echo "which not found: aborting" >&2; exit 1;}

# Check if custom path is valid and nonempty. Otherwise try to get it via which.
type -P $GC &>/dev/null && [ -n "$GC" ] ||
	{ [ -n "$GC" ] && echo "No gnuclad in custom path: using system PATH";
	GC=$(which gnuclad); }

# If GC is present, check for svg shortcut. Otherwise abort.
[ -n "$GC" ] || { echo "gnuclad not found: aborting" >&2; exit 1; }

# Run gnuclad and abort on error.
CHECK=`$GC $PROJNAME.csv $PROJNAME.svg $PROJNAME.conf`
echo -e "$CHECK"
[[ `echo -e "$CHECK" | grep "^Error:"` ]] && exit 1;

# Check for Inkscape and run it if present. Otherwise ignore.
INK=$(which inkscape)
[ -n "$INK" ] || echo "Inkscape not found: will not generate png"
[ -n "$INK" ] && $INK $PROJNAME.svg -D --export-png=$PROJNAME.png

# Packaging
echo "Packaging..."

mkdir -p $BDIR
mv $PROJNAME.svg $BDIR
[ -n "$INK" ] && mv $PROJNAME.png $BDIR

echo "Distribution can be found in $BDIR"

