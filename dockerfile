FROM ruby:3.0.0-slim
RUN apt-get update && apt-get install -y git
# Instala as nossas dependencias
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
  build-essential libpq-dev
# Seta nosso path
ENV INSTALL_PATH /onebitbot
# Cria nosso diretório
RUN mkdir -p $INSTALL_PATH
# Seta o nosso path como o diretório principal
WORKDIR $INSTALL_PATH
# Copia o nosso Gemfile para dentro do container
COPY Gemfile ./
# Instala as Gems
RUN bundle install
# Copia nosso código para dentro do container
COPY . .
# Roda nosso servidor
CMD rackup config.ru -o 0.0.0.0