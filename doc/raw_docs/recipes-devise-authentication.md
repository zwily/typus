# Devise Authentication

**Note**: This feature is in a [branch][1].

To use `typus` with `devise` you only need to set the `authentication` and
`user_class_name` options in the `typus.rb` initializer.

    Typus.setup do |config|
      config.authentication = :devise
      config.user_class_name = "AdminUser"
    end

[1]: https://github.com/typus/typus/tree/wip/devise

## Step by step

Add `typus` and `devise` to your `Gemfile`:

    gem 'devise'
    gem 'typus', :git => 'git://github.com/typus/typus.git', :branch => 'wip/devise'

Configure and install `devise`:

    # rails g devise:install <= Read the instructions
    # rails g devise AdminUser
    # rake db:migrate

Once installed you can run `typus` generator:

    # rails g typus

And configure the initializer:

    # config/initializers/typus.rb
    Typus.setup do |config|
      config.authentication = :devise
      config.user_class_name = "AdminUser"
    end

Now start your application and go to <http://localhost:3000/admin>.

## Gotchas

1. By default `devise` enables user registration. I suggest disabling that
   functionality and create the first user from the _rails console_.

2. Using this method all `devise` users are considered to have the user `role`.
   Adding the `role` field into the `devise` users table will allow you to
   have access by role.

3. There's not a feature to "enable" and disable users. (This will be fixed
   soon)
