#!/bin/sh

rsync -va --exclude=Gemfile.lock --exclude-from=/Users/timothyharrison/Dropbox/p/htk/.rsync-exclude /Users/timothyharrison/Dropbox/p/htk/ blues:/home/ubuntu/rsync/p/htk
ssh blues 'cd rsync/p/htk ; rake htk:build_gadgets'
rsync -va blues:/home/ubuntu/rsync/p/htk/extensions/comments_gadget/output/ /Users/timothyharrison/Dropbox/p/htk/extensions/comments_gadget/output
