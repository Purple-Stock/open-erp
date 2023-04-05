[![Maintainability](https://api.codeclimate.com/v1/badges/08231e31f9e94ae977af/maintainability)](https://codeclimate.com/github/Purple-Stock/open-erp/maintainability)
[![Ruby](https://github.com/Purple-Stock/open-erp/actions/workflows/main.yml/badge.svg)](https://github.com/Purple-Stock/open-erp/actions/workflows/main.yml)
# OPEN ERP

**Open ERP** is used for inventory management, invoice generation, and financial management. It integrates with e-commerce platforms and various ERPs. Open ERP is an open-source alternative to Bling ERP and is developed using Ruby on Rails. The project aims to follow the Rails Way of development, maintaining a monolithic architecture while utilizing the latest Rails community innovations such as Stimulus, Turbo Frames, and Turbo Streams.

The official project page is available at [institutional page](https://purplestock.com.br/)

This project is also integrated with the QR CODE app https://github.com/Purple-Stock/open-erp-qr-code-reader and the PIMACO product label generator with QR CODE https://github.com/Purple-Stock/open-erp-pimaco-print-tags.

![Screenshot from 2022-11-04 19-30-07](https://user-images.githubusercontent.com/8432835/200084193-5c591172-c698-4e95-a849-f49f781a2b25.png)

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

## Demo

You can test Open ERP with one click on Heroku:

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/puppe1990/open-erp)

## Contributing

This project exists thanks to all the people who contribute. Feel free to contribute! These are good [issues](https://github.com/puppe1990/open-erp/issues?q=is%3Aissue+is%3Aopen+label%3A%22good+first+issue%22) to start with! If you have any questions or are interested in using it in a business, please contact matheus.puppe@gmail.com.

## Contributors

This project exists thanks to the effort and dedication of these people:

**Development**

<a href="https://github.com/puppe1990/open-erp/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=puppe1990/open-erp" />
</a>

## License

[MIT](https://github.com/puppe1990/open-erp/blob/master/LICENSE)
