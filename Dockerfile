FROM ruby:3.1.2

LABEL maintainer="gilcierweb@gmail.com"

ENV BUNDLER_VERSION=2.3.18

RUN gem install bundler -v 2.3.18

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install

COPY package.json yarn.lock ./

RUN apt-get update

RUN apt-get -y upgrade

RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - &&\
    apt-get install -y nodejs

RUN npm install --global yarn

RUN yarn install --check-files

COPY . ./ 

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]