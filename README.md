[![Maintainability](https://api.codeclimate.com/v1/badges/08231e31f9e94ae977af/maintainability)](https://codeclimate.com/github/Purple-Stock/open-erp/maintainability)
[![Ruby](https://github.com/Purple-Stock/open-erp/actions/workflows/main.yml/badge.svg)](https://github.com/Purple-Stock/open-erp/actions/workflows/main.yml)
# OPEN ERP
[README TO ENGLISH SPEAKERS](https://github.com/Purple-Stock/open-erp/README-english-version.MD)


O **Open ERP** é utilizado para controle de estoque, gerador de notas fiscais, financeiro. Integrações com eccomerce e diversos ERPs. É uma alternativa Open Source para o Bling ERP. Desenvolvido em Ruby on Rails a ideia do projeto é seguir o Rails Way de desenvolvimento mantendo o projeto um monolíto utilizando as últimas novidades da comunidade Rails como Stimulus, Turbo Frames, Turbo Streams.

A página oficial do projeto está em [página institucional](https://purplestock.com.br/)

Este Projeto também é integrado com o aplicativo de QR CODE https://github.com/Purple-Stock/open-erp-qr-code-reader e o sistema gerador de etiquetas PIMACO de produtos com QR CODE https://github.com/Purple-Stock/open-erp-pimaco-print-tags.

![Screenshot from 2022-11-04 19-30-07](https://user-images.githubusercontent.com/8432835/200084193-5c591172-c698-4e95-a849-f49f781a2b25.png)


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
bin/rails db:setup
bin/dev # run app http://localhost:3000
```

E acesse no ambiente local [http://localhost:3000](http://localhost:3000):

```sh
bundle exec rails server
bin/dev
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


## Demo

Você pode testar o Open Erp com um clique no Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/puppe1990/open-erp)

## Contribuindo

Este projeto existe graças a todas as pessoas que contribuem. Fique a vontade para contribuir! Essas aqui são boas [issues](https://github.com/puppe1990/open-erp/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) para começar! Se tiver dúvidas ou interesse em utilizar em algum negócio entre em contato em matheus.puppe@gmail.com

## Contribuidores

Esse projeto existe graças ao esforço e dedicação dessas pessoas:

**Desenvolvimento**

<a href="https://github.com/puppe1990/open-erp/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=puppe1990/open-erp" />
</a>

## Licença

[MIT](https://github.com/puppe1990/open-erp/blob/master/LICENSE)
