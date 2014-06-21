#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "Usage:   " $0 " <start | stop> "
    exit 1
fi

action=$1

script_location=$(cd ${0%/*} && pwd -P)
cd $script_location/..
rails_root=`pwd`

logfile=$rails_root/log/monit_delayed_job.log
echo "-----------------------------------------------" >> $logfile 2>&1

if [[ $rails_root == *Dropbox* ]]
then
  . $script_location/export_rails_env_development
  echo "Running in development mode" >> $logfile 2>&1
else
  . $script_location/export_rails_env_production
  echo "Running in production mode" >> $logfile 2>&1
fi

echo "Running bundle exec ./script/delayed_job $action" >> $logfile 2>&1
echo `date` >> $logfile 2>&1
echo `env` >> $logfile 2>&1

bundle exec ./script/delayed_job $action >> $logfile 2>&1
