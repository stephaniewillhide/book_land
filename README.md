# Rails Template

This is a Rails 5 template used for onboarding new Rails developers.

It gives us a known starting point from which we can gradually introduce developers to Rails.

## About this application

This is a very bare-bones application that has the following gems installed on top of the Rails defaults:

- [Devise](https://github.com/plataformatec/devise) for authentication
- [Bootstrap 4](https://getbootstrap.com/) to reduce eye-strain
- [Simple Form](https://github.com/plataformatec/simple_form) to provide a nicer experience building forms

I will provide tasks that will gradually expose the new developer to more of the gems that are part of InterExchange's SoE.

We use SQLite for a database for ease of entry.

## Getting started

Running `bin/setup` from your command line should setup the database and run the seeds file (db/seeds.rb) which will create a single User you can sign in with.

Look in the seeds file to find the user's credentials!
