# Postgresql on Docker - Composer

Practical and straightforward docker PostgreSQL images. Easy to deploy in Debian based environment most usefully into raspberry Pi devices.  Using their basic commands in docker compose just to up in the server using **adminer** as admin panel.

    sudo docker compose -f docker-compose.yml up

## Using Custom Credentials

There are a **run.sh** file than execute a simple command showing below because a good practices must be implemented from the begin

    docker-compose up -e POSTGRES_USER=myuser -e POSTGRES_PASSWORD=mypassword -e POSTGRES_DB=mydatabase

### Connect to the virtual machine 

    docker exec -it <container name> bash

In our case:

    sudo docker exec -it psql-db bash
    find / -name .s.PGSQL.5432
    psql -h /run/postgresql/ test_db


## Postgresql common commands

    psql -U postgres -W
    \l #List database
    \c db_name #Change database
    \dt #Get all tables
    \du #list users

## Create and Alter User into PSQL
    CREATE USER <name> WITH <option>;
    ALTER USER <name> WITH <option>;

    ALTER USER username WITH PASSWORD 'password';
    ALTER USER username WITH LOGIN CREATEDB CREATEROLE;
