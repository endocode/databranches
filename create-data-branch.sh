#!/usr/bin/env bash
#
# (C) Endocode, 2018
# SPDX-License-Identifier: GPL-3.0
# Creator: Mirko Boehm
# PackageOriginator: Endocode AG

# This script expects two arguments, the data directory and the branch
# name. It expects to be invoked from the location of the working copy
# repository.
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <data directory> <branch name>" 1>&2
    exit 1
fi

WORKING_COPY=$PWD
DATA_DIR="$1"
BRANCH_NAME="$2"
# comment this out to see what Git is doing:
QUIET="--quiet"

if [ -d $DATA_DIR ]; then
    echo "Updating $BRANCH_NAME branch from content in $DATA_DIR..." 1>&2
else
    echo "No content found, verify $DATA_DIR!" 1>&2
    exit 1
fi

if git rev-parse --verify $QUIET $BRANCH_NAME > /dev/null; then
    echo "Target branch exists, it will be deleted and recreated..." 1>&2
    git branch $QUIET -D $BRANCH_NAME || {
	echo "Error deleting existing data branch $BRANCH_NAME." 1>&2
	exit 1
    }
fi

cd $DATA_DIR && \
    git init $QUIET . && \
    git checkout $QUIET --orphan $BRANCH_NAME && \
    git add * && \
    git commit $QUIET -a -m "[SCRIPTED] Creates orphan $BRANCH_NAME data branch." && \
    BRANCH_CREATED=1

if [ ! $BRANCH_CREATED ]; then
    echo "Error creating data branch $BRANCH_NAME." 1>&2
    exit 1
fi

git push $QUIET -f $WORKING_COPY $BRANCH_NAME || {
    echo "Error pushing data branch $BRANCH_NAME to working copy repository." 1>&2
    exit 1
}
echo "Data branch $BRANCH_NAME created in working copy repository." 1>&2

# The data branch now exists in the working copy repository. Other
# than that, the working copy repository remains unmodified.
