#!/bin/bash  

pushd /etc/profile.d
chmod 777 /etc/profile.d/rvm.sh 
source rvm.sh 
./rvm.sh 
rvm install ruby
gem install linkeddata
