#!/bin/bash

cd /usr/local/rubygems.org
[ -z "$SECRET_KEY_BASE" ] && export SECRET_KEY_BASE=`bundle exec rake secret`
echo $SECRET_KEY_BASE
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rails s
