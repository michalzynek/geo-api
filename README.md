# README

## Overview

This is a simple Rails-based RESTful API application that stores and retrieves geolocation data based on IP addresses or hostnames (including full URLs). The application integrates with the Ipstack API to fetch geolocation data.

### Main features

- Save geolocation data for a given IP address or hostname. (`host` is the request host or IP, `ip` is the address found in geolocation)
- Fetch stored geolocation data.
- Remove stored geolocation data.
- The API adheres to the JSON API standard for both input and output.
- Integrates IPStack as a geolocation provider


## Getting started

### Prerequisites

Ruby: Version 3.0 or higher.
Rails: Version 7.0 or higher.
PostgreSQL: Recommended database for production.
Docker: For containerized development and deployment.

### Installation and quick setup

1. Clone repository and `cd` into the project directory
2. Install gems
```ruby
bundle install
```
3. Config environmental variables - example envs are in `.env.sample` file. `IPSTACK_ACCESS_KEY` is required to fetch geolocation from external provider
4. Setup PostgreSQL envs and run
```
bundle exec rails db:prepare
```
5. Verify the setup by running code analysis and tests
```
bundle exec rails code:analysis
bundle exec rspec
```
6. Start the application server on development
```
./bin/dev
```
or optionally use rails server command:
```
rails s
```

### Docker

To run docker, you have to set the `DOCKER_ENABLED=true` env variable. This can be done using the .env file, or exporting it in the terminal.

1. Ensure docker is installed and running on your machine
2. In the project directory, run:
```
docker-compose up --build
```

Docker entrypoint has already DB preparation for dev environment.

### How to run on MacOS & Windows
```bash
docker run --rm --name api-base -it -p 3000:3000 -e POSTGRES_HOST=host.docker.internal -v .:/src/app rails_api_base
```

#### Docker detailed information

`Dockerfile.dev` - Local development dockerfile
`Dockerfile` - Meant to be run on production
`docker-compose.yml` - This is dev-only, NOT PRODUCTION.

## API Documentation

Documentation is generated using automatic generation based on rspec requests specs. To generate documentation, simply set `OPENAPI=true` env while running rspec command.

The documentation uses `SwaggerUI` and is available under `/api-docs` path.

## Code quality

`bundle exec rails code:analysis`

- [Rubocop](https://github.com/bbatsov/rubocop/blob/master/config/default.yml) Edit `.rubocop.yml`
- [Rails Best Practices](https://github.com/flyerhzm/rails_best_practices#custom-configuration) Edit `config/rails_best_practices.yml`
- [Brakeman](https://github.com/presidentbeef/brakeman) Run `brakeman -I` to generate `config/brakeman.ignore`

## Parallel tests

All of the tests ran in CI are parallelized.