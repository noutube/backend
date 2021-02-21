FROM ruby:2.7

WORKDIR /workspace

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && \
    bundle config set --local without 'development test' && \
    bundle install

COPY . ./

ENV RAILS_ENV production

CMD bundle exec rails s
