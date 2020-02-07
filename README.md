
# 🐞 CRM System 🐞

This is a basic Rails app for a simple CRM system. The system helps users to keep track of contacts, and add notes to those contacts.

The project already provides an implementation for basic CRUD operations on Contacts, Notes and Tags as well as feature specs testing these operations. The specs pass.

Imagine you are on the development team for this app.

A customer has contacted support complaining that the app is not working for them. Here is their bug report:

> I am trying to find a contact in my database, but the app is not working. When I try to open the contact list it says "We're sorry, but something went wrong (500)".

For testing purposes, we have captured some data from the user's account and loaded it into fixture files:

- `spec/fixtures/contacts.yml` 
- `spec/fixtures/tags.yml` 
- `spec/fixtures/taggings.yml` 

## Questions

1. How can you identify the cause of the bug?
2. What is the culprit?
3. What approach might you take to fixing it?

## Extra Credit

Fix the bug and file a Pull Request!

## Installation

Install dependencies:

```
bundle install
```

Set up the database:

```
rake db:setup
```

Make sure the specs pass:

```
rspec spec/features
```

Run the development server:

```
rails server
```

Load the fixtures for exploratory testing:

```
rails console

> require 'active_record/fixtures'
> ActiveRecord::FixtureSet.create_fixtures(Rails.root.join('spec', 'fixtures'), 'contacts')
> ActiveRecord::FixtureSet.create_fixtures(Rails.root.join('spec', 'fixtures'), 'tags')
> ActiveRecord::FixtureSet.create_fixtures(Rails.root.join('spec', 'fixtures'), 'taggings')
```