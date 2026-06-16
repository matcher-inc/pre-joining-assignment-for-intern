#!/bin/bash

# Setup Env
cp ./backend/.env.example ./backend/.env
cp ./frontend/.env.example ./frontend/.env

docker compose build --no-cache
