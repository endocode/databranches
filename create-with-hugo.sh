#!/usr/bin/env bash
#
# (C) Endocode, 2018
# SPDX-License-Identifier: GPL-3.0
# Creator: Mirko Boehm
# PackageOriginator: Endocode AG

# The first parameter to the script should contain the output
# directory. If it is not specified, an automatically generated
# temporary directory is used.
if [ ! -z "$1" ]; then
    OUTPUT_DIR="$1"
else
    OUTPUT_DIR=`mktemp -d -t hugo-generated-content-XXXX`
    EXTRA_COMMENT=" temporary"
fi
echo "Generating static Hugo content in$EXTRA_COMMENT directory $OUTPUT_DIR." >&2

# The script assumes that the surrounding directory contains the Hugo
# website, and that Hugo is in the path. The environment variable
# HUGO_OPTIONS can be used to pass in extra arguments to Hugo, like
# "-D" to create draft pages.
hugo $HUGO_OPTIONS -d $OUTPUT_DIR 1>&2 || {
    echo "Error generating static Hugo content in $OUTPUT_DIR." >&2
    exit 1
}
echo "Static Hugo content generated in $OUTPUT_DIR." >&2
echo $OUTPUT_DIR
