# Typus: Admin Panel for Ruby on Rails applications

**Typus** is a control panel for [Ruby on Rails][rails] applications to allow
trusted users edit structured content.

It’s not a CMS with a full working system but it provides a part of the
system: authentication, permissions and basic look and feel for your
websites control panel. So using [Rails][rails] with **Typus** lets you
concentrate on your application instead of the bits to manage the system.

**Typus** is the "old latin" word for **type** which stands for:

> A category of people or things having common characteristics.

You can try a demo [here][typus_demo].

## Key Features

- Built-in Authentication and Access Control Lists.
- CRUD and custom actions for your models on a clean interface.
- Internationalized interface ([See available translations][typus_locales])
- Customizable and extensible templates.
- Integrated [paperclip][paperclip] and [dragonfly][dragonfly] attachments viewer.
- Works with `Rails 3.1.X`.
- Tested with latest Rubies. (`1.8.7-p352`, `ree-1.8.7-2011.03`, `1.9.2-p290`, `jruby-1.6.3`)
- Tested with `SQLite`, `MySQL` and `PostgreSQL`.

## Installing

Add **Typus** to your `Gemfile`

    gem 'typus', '~> 3.1.0.rc'

    # Bundle edge typus instead:
    # gem 'typus', :git => 'git://github.com/typus/typus.git'

Update your bundle, run the generator and start the application server:

    $ bundle install
    $ rails generate typus
    $ rails server

and go to <http://0.0.0.0:3000/admin>.

## Links

- [Documentation](https://github.com/typus/typus/wiki)
- [Issues](https://github.com/typus/typus/issues)
- [Source Code][typus] and [RubyGems][typus_gem]
- [Mailing List](http://groups.google.com/group/typus)
- [Contributors List](http://github.com/typus/typus/contributors)
- [Travis Builds](http://travis-ci.org/#!/typus/typus)

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

[typus]: http://github.com/typus/typus
[typus_demo]: http://demo.typuscms.com/
[typus_demo_code]: https://github.com/typus/demo
[typus_locales]: https://github.com/typus/typus/tree/master/config/locales
[typus_gem]: http://rubygems.org/gems/typus
[paperclip]: http://rubygems.org/gems/paperclip
[dragonfly]: http://rubygems.org/gems/dragonfly
[rails]: http://rubyonrails.org/