#!/bin/bash

cd /usr/local/rubygems.org
rake db:create
rake db:migrate RAILS_ENV=test
script/server production
