#!/bin/bash

rm -rf /app/tmp/pids/*
bundle exec rails tmp:create
echo "Starting Unicorn"
bundle exec unicorn -c /app/config/unicorn/production.rb -E production