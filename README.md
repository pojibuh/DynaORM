# DynaORM

## Summary

The object relational mapping of DynaORM is based on ActiveRecord, which is used in conjunction with Ruby on Rails. DynaORM performs database queries that maintain code DRYness and readability, while operating in a genuinely object-oriented fashion.

## Demo

  1. Clone this repository
  2. Load `irb` or `pry` in terminal
  3. Run `load 'demo.rb'`
  4. Enjoy querying the database (use the demo file as a reference)

## Features

  * Both follows traditional 'convention over configuration' mentality for associations, and allows users to place their own names
  * Intuitive API with similar core features to ActiveRecord::Base

## Libraries

  * ActiveSupport::Inflector
  * SQLite3 (gem)

## Examples

After loading the demo file, it is possible to search through tables in the database

```ruby
Store.all # returns all the stores in the database

Organization.all.first # returns the first organization
```

From there, 

## API

Through SQLObject, DynaORM provides many core ActiveRecord methods and associations, such as :

  * `has_many`
  * `belongs_to`
  * `has_one_through`
  * `::where`
  * `::find`
