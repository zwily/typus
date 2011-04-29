# Typus: Admin Panel for Ruby on Rails applications

**Typus** is designed for a single activity:

    Trusted users editing structured content.

**Typus** doesn't try to be all the things to all the people but it's
extensible enough to match lots of use cases.

## Key Features

- Built-in Authentication.
- User Permissions by using Access Control Lists. (stored in yaml files)
- CRUD and custom actions for your models on a clean interface.
- Internationalized interface ([See available translations][locales])
- Customizable and extensible templates.
- Integrated [paperclip][paperclip] and [dragonfly][dragonfly] attachments viewer.
- Low memory footprint.
- Works with `Rails 3.0.X`.
- Tested with `ruby-1.8.7-p334`, `ree-1.8.7-2011.03`, `ruby-1.9.2-p180` and `jruby-1.6.0`.
- Tested with `SQLite`, `MySQL` and `PostgreSQL`.
- MIT License, the same as Rails.

## Links

- [Documentation](http://core.typuscms.com/)
- [Demo](http://demo.typuscms.com/) ([Code][code])
- [Source Code](http://github.com/fesplugas/typus)
- [Mailing List](http://groups.google.com/group/typus)
- [Gems](http://rubygems.org/gems/typus)
- [Contributors List](http://github.com/fesplugas/typus/contributors)

## Installing

Add **Typus** to your `Gemfile`

    gem 'typus', :git => 'git://github.com/fesplugas/typus.git'

Update your bundle, run the generator and start the application server:

    $ bundle install
    $ rails generate typus
    $ rails server

and go to <http://0.0.0.0:3000/admin>.

## License

Typus is released under the MIT license.

[paperclip]: http://rubygems.org/gems/paperclip
[dragonfly]: http://rubygems.org/gems/dragonfly
[code]: https://github.com/fesplugas/typus/tree/master/test/fixtures/rails_app
[locales]: https://github.com/fesplugas/typus/tree/master/config/locales