FROM ruby:3.1.2

ENV NODE_VERSION 12
# Seta nosso path
ENV INSTALL_PATH /open_erp

# Instala as nossas dependencias
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq

RUN apt-get install -y --no-install-recommends nodejs postgresql-client \
  locales yarn

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN export LC_ALL="en_US.utf8"

# Cria nosso diretório
RUN mkdir -p $INSTALL_PATH

# Seta o nosso path como o diretório principal
WORKDIR $INSTALL_PATH


# Copia o nosso Gemfile para dentro do container
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
COPY yarn.lock yarn.lock

# Instala as Gems
RUN bundle install
# RUN npm install -g yarn
RUN yarn install --force
RUN yarn install --check-files

# Copia nosso código para dentro do container
COPY . $INSTALL_PATH
# Roda nosso servidor
CMD rackup config.ru -o 0.0.0.0
