# Testing the Plugin

Clone the repository.

    $ git clone https://github.com/typus/typus.git
    $ cd typus

## SQLite3 (default)

Run the following commands:

    $ rake

## MySQL

Run the following commands:

    $ mysqladmin -u root create typus_test
    $ rake DB=mysql

## PostgreSQL

Run the following commands:

    $ createdb typus_test
    $ rake DB=postgresql
