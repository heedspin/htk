#!/bin/sh

rsync -va --exclude=Gemfile.lock --exclude-from=/Users/timothyharrison/Dropbox/p/htk/.rsync-exclude /Users/timothyharrison/Dropbox/p/htk/ blues:/home/ubuntu/rsync/p/htk
ssh blues 'cd rsync/p/htk ; bundle exec annotate'
rsync -va blues:/home/ubuntu/rsync/p/htk/ /Users/timothyharrison/Dropbox/p/htk
