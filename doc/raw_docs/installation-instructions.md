# Installation Instructions

To install `Typus`, edit the application `Gemfile` and add:

    gem 'typus'

    # Bundle edge Typus instead:
    # gem 'typus', :git => 'https://github.com/typus/typus.git'

Install the gem using bundler:

    $ bundle install

`Typus` expects to have manageodels to manage, so run the generator in order to
generate the required configuration files:

    $ rails g typus

## Login into Typus

Start the application server, go to <http://0.0.0.0:3000/admin> and follow the
instructions.
