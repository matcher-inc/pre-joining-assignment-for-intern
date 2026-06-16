#!/bin/bash

# Setup Env
cp ./backend/.env.example ./backend/.env
cp ./frontend/.env.example ./frontend/.env
cp ./db/.env.example ./db/.env

docker compose build --no-cache

# node_modules
docker compose run --rm frontend sh -lc 'npm i'

# DB
docker compose run --rm backend sh -lc 'bundle exec rails db:drop db:create db:migrate'

docker compose stop
