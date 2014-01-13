#!/bin/sh

rsync -va --exclude=Gemfile.lock --exclude-from=/Users/timothyharrison/Dropbox/p/htk/.rsync-exclude /Users/timothyharrison/Dropbox/p/htk/ blues:/home/ubuntu/rsync/p/htk

