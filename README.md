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
- [Continous Integration](http://ci.typuscms.com/)

## Installing

Add **Typus** to your `Gemfile`

    gem 'typus', :git => 'https://github.com/fesplugas/typus.git'

    # If you have problems with "Smart HTTP" use the "Git Transfer Protocol".
    # gem 'typus', :git => 'git://github.com/fesplugas/typus.git'

Update your bundle

    $ bundle install

Run the generator

    $ rails generate typus

Start the application server

    $ rails server

and go to <http://0.0.0.0:3000/admin>.

## MIT License

    Copyright (c) 2007-2011 Francesc Esplugas Marti

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[paperclip]: http://rubygems.org/gems/paperclip
[dragonfly]: http://rubygems.org/gems/dragonfly
[code]: https://github.com/fesplugas/typus/tree/master/test/fixtures/rails_app
[locales]: https://github.com/fesplugas/typus/tree/master/config/locales