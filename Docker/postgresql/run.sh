#!/bin/bash
#docker-compose --env-file .env.dev up 
docker stop psql-db pgadmin4_container
docker rm psql-db pgadmin4_container #postgresql_adminer_1
docker-compose build
docker-compose up -d #-e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=mydatabase 