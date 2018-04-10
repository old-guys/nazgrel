FROM ruby:2.5.1

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

RUN apt-get update
RUN apt-get install -y nodejs mysql-client ruby-mysql2 -yq --no-install-recommends
RUN apt-get install -y vim -yq --no-install-recommends
# for nokogiri
RUN apt-get install -y build-essential libxml2-dev libxslt1-dev -yq --no-install-recommends
RUN apt-get install -y cron -yq --no-install-recommends
# Clean up apt
RUN apt-get clean && rm -f /var/lib/apt/lists/*_*

ENV LANG C.UTF-8

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_BIN=/bundle/bin \
  BUNDLE_JOBS=5 \
  BUNDLE_PATH=/bundle

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true

RUN bundle config --global frozen 1
RUN bundle install -j 20 --without development test

# COPY . /app

EXPOSE 3000

# ENTRYPOINT ["bundle", "exec"]

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]