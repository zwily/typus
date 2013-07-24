Typus User Guide
================

**Typus** is a control panel for `Rails`_ applications to allow
trusted users edit structured content.

It's not a CMS with a full working system but it provides a part of the system:
authentication, permissions and basic look and feel for your websites control
panel. So using `Rails`_ with **Typus** lets you concentrate on your
application instead of the bits to manage the system.

**Typus** is the "old latin" word for **type** which stands for:

    A category of people or things having common characteristics.

Key Features:

* Built-in Authentication and Access Control Lists.
* CRUD and custom actions for your models on a clean interface.
* Internationalized interface.
* Internationalized interface (`See available translations`_)
* Customizable and extensible templates.
* Integrated `paperclip`_ and `dragonfly`_ attachments viewer.
* Support for `Kaminari`_ and `WillPaginate`_.
* Supports Rails 4.0 and 3.2.
* Tested with **SQLite3**, **MySQL** and **PostgreSQL**.
* **MIT License**, the same as `Rails`_.

You can directly participate in the support and development of **Typus**,
including new features, by hiring our team to work on your project. We offer
customization services for modules and extensions for a fee.

Send your inquiries to contact@typuscmf.com.


.. _See available translations: https://github.com/fesplugas/typus/tree/master/config/locales
.. _paperclip: http://rubygems.org/gems/paperclip
.. _dragonfly: http://rubygems.org/gems/dragonfly
.. _Kaminari: http://rubygems.org/gems/kaminari
.. _WillPaginate: http://rubygems.org/gems/will_paginate


Installation
------------

.. toctree::
  :maxdepth: 1

  requirements
  installation/impatients
  installation/instructions
  installation/generators-and-rake-tasks


Configuration
-------------

.. toctree::
  :maxdepth: 1

  configuration/initializers
  configuration/resources
  configuration/resource
  configuration/roles
  customization/selectors
  customization/custom_css_and_js


Customization
-------------

.. toctree::
  :maxdepth: 1
  :glob:

  customization/*


Recipes
-------

.. toctree::
  :maxdepth: 1
  :glob:

  recipes/*


Misc
----

.. toctree::
  :maxdepth: 1

  usage
  upgrade
  credits


Contribute
----------

All of our hard work and help/support is free. We do have expenses to pay for
this project and your donations do allow us to spend more time building and
supporting the project.

Some interesting ways to contribute to the project:

* **Fork the project** - Fork the project on `GitHub`_ and make it better.
* **Tell everybody about Typus** - Let us know and we'll link back to you as well.
* **Hire us** to work on your next project - we build websites large and small.


.. _GitHub: https://github.com/fesplugas/typus/
.. _Rails: http://rubyonrails.org/


Credits
=======

Somehow involved in the project:

* `Yukihiro "matz" Matsumoto`_ creator of `Ruby`_, in my opinion, the most
  beautiful programming language.
* `David Heinemeier Hansson`_ for creating `Rails`_.
* `Django Admin`_ who inspired part of the  development, specially templates
  rendering and user interface.
* Our `Contributors`_.


.. _Yukihiro "matz" Matsumoto: http://www.rubyist.net/~matz
.. _Ruby: http://ruby-lang.org/
.. _David Heinemeier Hansson: http://loudthinking.com/
.. _Rails: http://rubyonrails.org/
.. _Django Admin: http://www.djangoproject.com/
.. _Contributors: http://github.com/typus/typus/contributors


MIT License
===========

.. code-block:: none

  Copyright (c) 2007-2013 Francesc Esplugas Marti

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
