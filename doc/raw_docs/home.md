# Home

**Typus** is a control panel for [Ruby on Rails][rails] applications to allow
trusted users edit structured content.

It’s not a CMS with a full working system but it provides a part of the
system: authentication, permissions and basic look and feel for your
websites control panel. So using [Rails][rails] with **Typus** lets you
concentrate on your application instead of the bits to manage the system.

**Typus** is the "old latin" word for **type** which stands for:

> A category of people or things having common characteristics.

You can try a demo [here][demo].

## Key Features

* Integrated authentication with Access Control Lists.
* CRUD and custom actions for your models on a clean interface.
* Internationalized interface.
* Overridable and extensible templates.
* Low memory footprint.
* Tested with **SQLite3**, **MySQL** and **PostgreSQL**.
* **MIT License**, the same as [Rails][rails].

## For the impatients

Add **Typus** to your `Gemfile`.

    gem 'typus'

    # Bundle edge typus instead:
    # gem 'typus', :git => 'https://github.com/typus/typus.git'

Update your bundle.

    $ bundle install

Run the **Typus** generator.

    $ rails generate typus

Start the application server and go to http://0.0.0.0:3000/admin.

## Contribute

All of our hard work and help/support is free. We do have expenses to pay for
this project and your donations do allow us to spend more time building and
supporting the project.

Some interesting ways to contribute to the project:

* **Fork the project** - Fork the project on [GitHub][typus] and make it better.
* **Tell everybody about Typus** - Let us know and we'll link back to you as well.
* **Hire us** to work on your next project - we build websites large and small.
* [Contribute a few bucks][donate].

## Credits

Somehow involved in the project:

* [Yukihiro "matz" Matsumoto][matz] creator of [Ruby][ruby], in my opinion, the most
beautiful programming language.
* [David Heinemeier Hansson][dhh] for creating [Ruby on Rails][rails].
* [Django Admin][django] who inspired part of the  development, in special the
templates rendering and user interface.

You can see a list of contributors and their commits on [GitHub][contributors].

## Services

You can directly participate in the support and development of **Typus**, 
including new features, by hiring our team to work on your project. We offer 
customization services for modules and extensions for a fee.

Send your inquiries to <contact@typuscms.com>.

[demo]: http://demo.typuscms.com/
[donate]: http://pledgie.com/campaigns/11233
[typus]: http://github.com/typus/typus
[matz]: http://www.rubyist.net/~matz
[ruby]: http://ruby-lang.org/
[dhh]: http://loudthinking.com/
[rails]: http://rubyonrails.org/
[django]: http://www.djangoproject.com/
[contributors]: http://github.com/typus/typus/contributors

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
