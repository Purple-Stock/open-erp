#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

if [ -n "$DATABASE_URL"]; then
    echo "É necessário informar a a string de conexão com o banco de dados através da variável DATABASE_URL"
    echo "Tente iniciar o container usando --env DATABASE_URL=<string de conexão>"
    echo "A string de conexão precisa estar no seguinte formato: postgres://<nome do usuário>:<senha do usuário>@<host>:<porta>/<nome do banco>"
    echo "Exemplo:"
    echo "  postgres://server_app:P4s5w0rD@database:5432/openerp"
    exit 1
fi

if [ -n "$REDIS_URL"]; then
    echo "É necessário informar a a string de conexão com o Redis através da variável REDIS_URL"
    echo "Tente iniciar o container usando --env REDIS_URL=<string de conexão>"
    echo "A string de conexão precisa estar no seguinte formato: redis://<nome do usuário>:<senha do usuário>@<host>:<porta>/<número do banco>"
    echo "Exemplo:"
    echo "  redis://server_app:P4s5w0rD@redis:6379/0"
    exit 1
fi

export RAILS_ENV=$CONFIG

if [ $DEPLOY_DATABASE = true ]; then
    bundle exec rails db:create
    bundle exec rails db:schema:load
    bundle exec rails db:migrate
fi

if [ $PERFORM_TESTS = true ]; then
    bundle exec rspec
fi

if [ $START_APP = true ]; then
    bundle exec rails server -b 0.0.0.0
fi
