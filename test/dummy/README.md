# Typus Demo

This is the Rails application used to test **Typus** and to demo it.

You can see it working at <http://demo.typuscms.com/>.

## Installation

Clone the repository:

    $ git clone git://github.com/typus/typus.git typus
    $ cd typus/test/dummy

Edit the file `config/mongoid.yml` to set your **MongoDB** settings.

    $ bundle install
    $ bundle exec rake db:setup
    $ bundle exec rails server

Open your browser and go to <http://localhost:3000/>.

## Deploying the Demo (only for Typus developers)

Add the `git` endpoint:

    $ git remote add pushand deploy@demo.typuscms.com:demo.typuscms.com

Now you can deploy using `git`:

    $ git push pushand

**Note:** The `.pushand` file is executed after the source is pushed to the
server.

**MongoDB** is configured using environment variables. All these variables are
set the shell script `ruby_with_env`:

    #!/bin/sh

    export MONGOID_HOST=staff.mongohq.com
    export MONGOID_PORT=10051
    export MONGOID_USERNAME=typus
    export MONGOID_PASSWORD=YOUR_PASSWORD_HERE
    export MONGOID_DATABASE=demo_typuscms_com

    exec "/usr/local/rvm/wrappers/ruby-1.9.2-p180/ruby" "$@"

And then the `passenger_ruby` points to this script.

    # passenger_ruby /usr/local/rvm/wrappers/ruby-1.9.2-p180/ruby;
    passenger_ruby /opt/nginx/sbin/ruby_with_env;

Remember to make the script executable:

    $ chmod +x /opt/nginx/sbin/ruby_with_env
