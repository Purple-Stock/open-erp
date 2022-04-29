SO_NAME := $(shell uname -s)

config_environment:
ifeq ($(SO_NAME),Linux)
	apt update
	apt install postgresql
	apt install postgresql-contrib
	apt install postgresql-server-dev-all
	apt install cmake
	apt install nodejs
	apt install libpq-dev
	gem install bundler
	bundle install
endif
ifeq ($(SO_NAME),Darwin)
	brew install postgresql || brew install postgres
	brew install postgresql-contrib
	brew install postgresql-server-dev-all
	brew install cmake
	brew install nodejs
	brew install libpq-dev
	gem install bundler
	bundle install
endif
