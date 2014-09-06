#!/usr/bin/env bash                                                                                                                                                  

if [ $# -lt 1 ] ; then
    echo "Usage:   " $0 "<path to runner script>"
    echo "E.g. :   " $0 "'Production::InventoryReport.new.run_in_background!'"
    exit 1
fi

arguments=$@

script_location=$(cd ${0%/*} && pwd -P)
cd $script_location/..
rails_root=`pwd`
# echo $rails_root

if [ -f "/etc/environment" ]; then
  source /etc/environment
fi

if [[ $rails_root == *Dropbox* ]]
then
  . $script_location/export_rails_env_development
else
  . $script_location/export_rails_env_production
fi

logfile=$rails_root/log/runner.log
echo "-----------------------------------------------" >> $logfile 2>&1
echo `date` >> $logfile 2>&1
echo "$0 $arguments with path = $PATH" >> $logfile 2>&1

# echo "rails runner $arguments >> $logfile 2>&1"
rails runner $arguments >> $logfile 2>&1
