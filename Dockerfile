FROM ruby:3.3.4

ENV DATABASE_URL=
ENV REDIS_URL=

RUN apt-get update
RUN apt-get -y upgrade
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - &&\
    apt-get install -y nodejs
RUN npm install --global yarn@1.22

LABEL maintainer="gilcierweb@gmail.com"

WORKDIR /app

RUN bundle config build.nokogiri --use-system-libraries
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY package.json yarn.lock ./
RUN yarn install --check-files

COPY . ./

RUN yarn run build

# Executa a criação/atualização do Banco de Dados
ENV DEPLOY_DATABASE=false

# Executa os testes
ENV PERFORM_TESTS=false

# Inicia a aplicação
ENV START_APP=true

# Para Configuration Management
# Será o valor atribuído à variável RAILS_ENV
# Por padrão, assume o valor `development`
ENV CONFIG=development

ENTRYPOINT ["./entrypoints/app-entrypoint.sh"]
