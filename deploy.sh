#!/bin/bash
#
# Copies everything rooted in `build/` to the gh-pages branch

# Assumes the branch is clean. This code checks that condition
NUM_DIRTY_FILES=`git status --porcelain | wc -l`
if [ $NUM_DIRTY_FILES != 0 ]
then
    echo "ERROR: your git branch must be clean (no modifications or \
untracked files) for this command to succeed."
    exit 99
fi

# Create a temp directory to copy the build to
TMPDIR=`mktemp -d`
echo "Using temp directory $TMPDIR"

# Make sure to clean up even if interrupted
trap "rm -rf $TMPDIR" SIGINT SIGTERM || exit

# Copy build/* to the temp directory
cp -r build/* $TMPDIR/. || exit

# Switch git branches and clear all files
git checkout gh-pages || exit
git rm -rf * || exit

# Copy the build from the temp directory
cp -r $TMPDIR/* . || exit

# Clean up the temp directory
rm -rf $TMPDIR

# Message to the user
echo "IMPORTANT: add and commit the changes the push to gh-pages to complete \
the process"
