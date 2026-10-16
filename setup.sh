#!/bin/bash

set -euo pipefail

if [[ -f .done.setup ]]; then
  echo 'setup was done.' 1>&2
  exit 1
fi

# Clean up
rm -rf ./db/.data

# Setup Env
cp ./backend/.env.example ./backend/.env
cp ./frontend/.env.example ./frontend/.env
cp ./db/.env.example ./db/.env

mysql_root_password=$(openssl rand -hex 32)
database_user_password=$(openssl rand -hex 32)
# A backup suffix is required for compatibility with both BSD and GNU sed.
sed -i.bak "s/^MYSQL_ROOT_PASSWORD=.*/MYSQL_ROOT_PASSWORD=${mysql_root_password}/" ./db/.env
sed -i.bak "s/^DATABASE_USER_PASSWORD=.*/DATABASE_USER_PASSWORD=${database_user_password}/" ./backend/.env
rm ./db/.env.bak ./backend/.env.bak

set -a
. ./backend/.env
. ./db/.env
set +a

# Setup Container

docker compose build --no-cache

# node_modules
docker compose run --rm frontend sh -lc 'npm i'

# DB
docker compose up -d --wait db

docker compose exec -T db mysql \
  -uroot \
  -p"${MYSQL_ROOT_PASSWORD}" <<QUERY
    CREATE DATABASE IF NOT EXISTS \`${DATABASE_TABLE_NAME}\`
      CHARACTER SET ${DATABASE_CHARSET}
      COLLATE ${DATABASE_COLLATION};
    CREATE USER IF NOT EXISTS '${DATABASE_USER_NAME}'@'%' IDENTIFIED BY '${DATABASE_USER_PASSWORD}';
    GRANT
      ALTER,
      CREATE,
      CREATE TEMPORARY TABLES,
      DELETE,
      DROP,
      INDEX,
      INSERT,
      REFERENCES,
      SELECT,
      UPDATE
    ON \`${DATABASE_TABLE_NAME}\`.* TO '${DATABASE_USER_NAME}'@'%';
    FLUSH PRIVILEGES;
QUERY

docker compose run --rm backend sh -lc 'bundle exec rails db:migrate'

docker compose stop

touch .done.setup
