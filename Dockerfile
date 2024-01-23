FROM ruby:2.7

WORKDIR /workspace

COPY Gemfile Gemfile.lock ./
RUN gem install bundler -v 2.4.22 && \
    bundle config set --local without 'development test' && \
    bundle install

COPY . ./

ENV RAILS_ENV production

CMD bundle exec rails s
