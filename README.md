Phez, the App
=============

*Phez* is a Ruby on Rails application powering the website Phez.co:

[Phez.co](http://phez.co/)

Please consider donating some Bitcoin to Phez:

1NhonFuVMiCaM9RJj1DJBoYTiN6Qaf51KQ

![Donate Bitcoin to Phez - QR Code](https://raw.githubusercontent.com/phezco/phez/master/public/img/bitcoin-qr.png)


Contributing
------------

Contributions are encouraged and desired.

We love pull requests. Here's a quick guide:

1. Fork the repo.

2. Add some tests. Currently we don't have any (yet). But the more the better, especially unit tests. Ideally we'll get Factory Girl setup in lieu of fixtures.

3. Push your fork and submit a pull request.

Syntax:

* Two spaces, no tabs.
* No trailing whitespace. Blank lines should not have any space.
* Look through the code and try to use the same style/syntax that's already in place.

Installation
------------

*Phez* is a standard Ruby on Rails 4.2.x application. Installation is fairly straightforward.

Dependencies:
+ Ruby 2.2.x
+ PostgreSQL

**Configurations that are known to work well with Phez**

Development environment:
+ OS X
+ Ruby 2.2.x (via RVM)
+ PostgreSQL 9.x

**How to Install**

Checkout the repository:
```bash
git clone https://github.com/phezco/phez.git
```

Copy database_example.yml to database.yml (and modify for your localhost), bundle install, etc.

Create some fake data with:
```bash
rake phez:dummy
```

Rank the newly-created posts:
```bash
rake phez:rank
```

Browse to localhost:3000 and start phezing!


On the Shoulder of Giants
-------------------------

We'd like to thank the creators of the following libraries and frameworks. Without their contributions, *Phez* would not be possible.

+ Ruby http://www.ruby-lang.org/
+ Ruby on Rails http://rubyonrails.org/
+ jQuery http://jquery.com/
* Twitter Bootstrap http://twitter.github.com/bootstrap/
* PostgreSQL http://www.postgresql.org/
* Too many gems to list, but currently: devise, redcarpet, acts_as_commentable_with_threading, whenever, will_paginate, recaptcha, figaro, etc!

License
-------

Phez is released under the MIT License. See LICENSE for more info.
