# Casa do Celular ERP

> _Cheap and always will be!_

ERP specialized in **mobile phone retail and repair**, with **IMEI / serial-number** stock tracking, service orders, warranties, NFe (Brazilian e-invoice) and marketplace integrations.

Built on **Ruby on Rails 7** (Stimulus, Turbo Frames/Streams) over PostgreSQL. Adapted fork of [Purple-Stock/open-erp](https://github.com/Purple-Stock/open-erp) — upstream attribution preserved.

Casa do Celular's official site: <https://casadocelular.com.br>.

## Development

If you want to run this project in your development environment, you need to clone this source code, compile it, and run it locally.

To set up the project in your environment, you must manually install the dependencies by [manually installing the dependencies](#manual-installation).

### Manual Installation

If you want to manually install all dependencies on your GNU/Linux environment, you need to execute the following commands:

```sh
apt update
apt install postgresql postgresql-contrib postgresql-server-dev-all cmake nodejs libpq-dev
gem install bundler
```

To install the libraries, execute:

```sh
bundle install
yarn install
```

To configure the database, execute:

```sh
cp .env.example .env
source .env
bin/rails db:setup
bin/dev # run app at http://localhost:3000
```

And access the local environment at [http://localhost:3000](http://localhost:3000):

```sh
bundle exec rails server
bin/dev
```

## Docker and Docker Compose
To use Docker and Docker Compose, run the following commands to start the database and application:
```sh
docker-compose build
docker-compose up # run http://localhost:3000
 
docker-compose up --build # run http://localhost:3000

# Optional
docker-compose ps
docker-compose stop
docker-compose
down
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

The Rails application will run through Docker Compose at [http://localhost:3000](http://localhost:3000).

## Testing without Docker and Docker Compose

To run the application tests and check if everything is working as expected, execute:

```sh
bundle exec rspec
```

## Style Guides

- [Ruby style guide](https://github.com/bbatsov/ruby-style-guide)
- [Rails style guide](https://github.com/bbatsov/rails-style-guide)
- [JavaScript style guide](https://github.com/airbnb/javascript)

You can check if the code complies with project standards by running RuboCop and correcting any warnings that arise:

```sh
bundle exec rubocop
```

## Roadmap

The full adaptation roadmap from the generic ERP to the mobile-phone vertical lives in [CLAUDE.md](CLAUDE.md) and the repository [issues](https://github.com/caiomonteirovf-bot/open-erp-celulares/issues).

## Upstream attribution

This project is a fork of [Purple-Stock/open-erp](https://github.com/Purple-Stock/open-erp) released under the MIT license. Original contributors are listed at <https://github.com/Purple-Stock/open-erp/graphs/contributors>.

## License

[MIT](LICENSE) — inherited from upstream.
