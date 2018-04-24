#!/bin/bash

bundle exec sidekiq --environment production --logfile /app/log/sidekiq.log --concurrency 10