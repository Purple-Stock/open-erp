# Casa do Celular ERP

> _É barato e sempre será!_

ERP especializado em **lojas de celulares e assistência técnica**, com controle de estoque por **IMEI / número de série**, ordens de serviço, garantias, NFe e integração com marketplaces.

Desenvolvido em **Ruby on Rails 7** (Stimulus, Turbo Frames/Streams) sobre PostgreSQL. Fork adaptado de [Purple-Stock/open-erp](https://github.com/Purple-Stock/open-erp) — manteremos atribuição ao projeto de origem.

A página oficial da Casa do Celular está em <https://casadocelular.com.br>.

## Desenvolvimento

Se você quiser executar este projeto no seu ambiente de desenvolvimento,
você deve clonar este código-fonte, compilá-lo e executá-lo localmente.

Para configurar o projeto no seu ambiente. Você deve instalar manualmente as dependências
[instalando manualmente as dependências](#instalando-manualmente).

### Instalando manualmente

Caso você queira instalar manualmente todas as dependências no seu ambiente GNU/Linux,
precisará executar os seguintes comandos:

```sh
apt update
apt install postgresql postgresql-contrib postgresql-server-dev-all cmake nodejs libpq-dev
gem install bundler
```

Para instalar as bibliotecas execute:

```sh
bundle install
yarn install
```

Para configurar o banco de dados execute:

```sh
cp .env.example .env
source .env
./bin/rails db:setup
./bin/dev # run app http://localhost:3000
```

E acesse no ambiente local [http://localhost:3000](http://localhost:3000):

```sh
bundle exec rails server
./bin/dev
```

## Docker and Docker Compose

Para usar basta executar os comandos abaixo para rodar o banco e aplicação.

```sh
docker-compose build
docker-compose up # run http://localhost:3000

docker-compose up --build # run http://localhost:3000

# Optional
docker-compose ps
docker-compose stop
docker-compose down
docker-compose run --rm app rails db:create
docker-compose run --rm app rails db:setup db:migrate
docker-compose run --rm app rails db:migrate
docker-compose run --rm app rails db:seed
docker-compose run --rm app rails console
docker-compose run --rm app rails rspec
docker-compose run --rm app rails rubocop
docker-compose run --rm app bash
docker-compose run --rm app bundle install
docker-compose run --rm app yarn install --check-files
```

A aplicação rails vai rodar atraves do Docker Compose [http://localhost:3000](http://localhost:3000)

## Testes sem Docker e Docker Compose

Para executar os testes da aplicação e verificar se tudo está funcionando como
esperado execute:

```sh
bundle exec rspec
```

## Style Guides

- [Ruby style guide](https://github.com/bbatsov/ruby-style-guide)
- [Rails style guide](https://github.com/bbatsov/rails-style-guide)
- [JavaScript style guide](https://github.com/airbnb/javascript)

Você pode verificar se o código está em conformidade com os padrões do projeto
executando o robocop e corrigindo qualquer alerta evidenciado:

```sh
bundle exec rubocop
```

## Roadmap

O roadmap completo de adaptação do ERP genérico para o setor de celulares está em [CLAUDE.md](CLAUDE.md) e nas [issues](https://github.com/caiomonteirovf-bot/open-erp-celulares/issues) do repositório.

## Atribuição (upstream)

Este projeto é um fork de [Purple-Stock/open-erp](https://github.com/Purple-Stock/open-erp) sob licença MIT. Os contribuidores originais estão listados em <https://github.com/Purple-Stock/open-erp/graphs/contributors>.

## Licença

[MIT](LICENSE) — herdada do projeto upstream.

