#!/usr/bin/make

SHELL = /bin/sh

UID := $(shell id -u)
GID := $(shell id -g)

export UID
export GID

up:
	UID=${UID} GID=${GID} docker-compose -f docker-compose.yml --profile main up --build -d --remove-orphans

run-app-with-setup:
	cp ./src/.env.example ./src/.env
	docker compose build
	docker compose up -d
	docker exec php /bin/sh -c "composer install && npm install && chmod -R 777 storage && php artisan key:generate"

run-app-with-setup-db:
	cp ./src/.env.example ./src/.env
	docker compose build
	docker compose up -d
	docker exec php /bin/sh -c "composer install && npm install && chmod -R 777 storage && php artisan key:generate && php artisan migrate:fresh --seed"

run-app:
	docker compose up -d

kill-app:
	docker compose down

enter-nginx-container:
	docker exec -it nginx /bin/sh

enter-php-container:
	docker exec -it php /bin/sh

enter-mysql-container:
	docker exec -it mysql /bin/sh

flush-db:
	docker exec php /bin/sh -c "php artisan migrate:fresh"

flush-db-with-seeding:
	docker exec php /bin/sh -c "php artisan migrate:fresh --seed"

code-format-check:
	docker exec php /bin/sh -c "npm run format:check"

code-format:
	docker exec php /bin/sh -c "npm run format"

code-test:
	docker exec php /bin/sh -c "php artisan test"
