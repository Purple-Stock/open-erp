[![CodeFactor](https://www.codefactor.io/repository/github/puppe1990/open-erp/badge)](https://www.codefactor.io/repository/github/puppe1990/open-erp)
# OPEN ERP

O **Open ERP** é utilizado para controle de estoque, gerador de notas fiscais, financeiro. Integrações com eccomerce e diversos ERPs. Desenvolvido em Ruby on Rails a ideia do projeto é seguir o seguir o Rails Way de desenvolvimento mantendo o projeto um monolíto utilizando as últimas novidades da comunidade Rails como Stimulus, Turbo e HTML Over the Wire.

A página oficial do projeto está em [página institucional](https://purplestock.com.br/)

Este Projeto também é integrado com o aplicativo de QR CODE https://github.com/Purple-Stock/open-erp-qr-code-reader e o sistema gerador de etiquetas PIMACO de produtos com QR CODE https://github.com/Purple-Stock/open-erp-pimaco-print-tags.

![Captura de Tela 2022-04-24 às 11 59 42](https://user-images.githubusercontent.com/8432835/164982735-d0e2899f-f077-45d9-a70c-81ac9c3f7102.png)


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
```

Para configurar o banco de dados execute:

```sh
cp .env.db.sample .env
source .env
bin/rails db:setup
```

E acesse no ambiente local [http://localhost:3000](http://localhost:3000):

```sh
bundle exec rails server
```

## Testes

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
