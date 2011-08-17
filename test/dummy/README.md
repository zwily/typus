# Typus Demo

This is the Rails application used to test **Typus** and to demo it.

You can see it working at <http://demo.typuscms.com/>.

## Installation

Clone the repository:

    $ git clone git://github.com/typus/typus.git typus
    $ cd typus/test/dummy

    $ bundle install
    $ bundle exec rake db:setup
    $ bundle exec rails server

Open your browser and go to <http://localhost:3000/>.

## MongoDB

If you want to see the `MongoDB` support rename the file `config/mongoid.yml.example`
and set your **MongoDB** settings.
