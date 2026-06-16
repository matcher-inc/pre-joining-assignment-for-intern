#!/bin/bash

# Setup Env
cp ./backend/.env.example ./backend/.env
cp ./frontend/.env.example ./frontend/.env
cp ./db/.env.example ./db/.env

docker compose build --no-cache

docker compose run --rm frontend sh -lc 'npm i'
