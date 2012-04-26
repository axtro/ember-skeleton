Ember Skeleton
==============

A skeleton application framework using Ember.js and Rake Pipeline.

Running
-------

    $ bundle install
    $ bundle exec rackup

App Structure
-------------

    ember-skeleton
    ├── Assetfile - App build file
    ├── Gemfile - Package dependencies for rakep/rack
    ├── Gemfile.lock - Here be dragons: don't touch, always include
    ├── app - App specific code
    │   ├── css - App CSS or SCSS (.scss)
    │   ├── lib - App code, *modularized during build*
    │   ├── static - Static files, never touched, copied over during build
    │   ├── templates - Handlebars templates, *modularized during build*
    │   ├── tests - App tests
    │   └── vendor - Vendor code, *modularized during build*
    ├── assets - Built out asset files, minified in production
    ├── config.ru - Rack development web server configuration
    ├── index.html - The app entry point
    └── tmp - Temporary build files used by rakep

Testing
-------

You can test the app by invoking

    $ bundle exec rake test

This executes the tests by using [Phantom.JS](http://www.phantomjs.org/), which you need to have installed.

Or you can run the tests via

    $ bundle exec rackup
    $ open http://localhost:9292/tests/index.html

Deploying
---------

To create a production-ready build, invoke

    $ RAKEP_MODE=production bundle exec rakep

You will then find the production-ready files inside of assets/
