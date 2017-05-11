# DynaORM

## Summary

The object relational mapping of DynaORM is based on ActiveRecord, which is used in conjunction with Ruby on Rails. DynaORM performs database queries that maintain code DRYness and readability, while operating in a genuinely object-oriented fashion.

## Demo

  1. Clone this repository
  2. Run `irb` or `pry` in terminal
  3. Run `load 'demo.rb'`
  4. Enjoy querying the database

For reference, here are the tables in the demo database:

### Stores

column name      | data type | details
-----------------|-----------|------------------------
id               | integer   | primary key
name             | string    | not null
owner_id         | integer   | foreign key (references humans)

### Humans

column name      | data type | details
-----------------|-----------|------------------------
id               | integer   | primary key
fname            | string    | not null
lname            | string    | not null
organization_id  | integer   | foreign key (references organizations)

### Organizations

column name      | data type | details
-----------------|-----------|------------------------
id               | integer   | primary key
name             | string    | not null

## Features

  * Both follows traditional 'convention over configuration' mentality for associations, and allows users to place their own names. An example is the belongs_to method
  ```Ruby
  module Associatable
    def belongs_to(name, options = {})

      self.assoc_options[name] = BelongsToOptions.new(name, options)

      define_method(name) do
        options = self.class.assoc_options[name]

        foreign_key = self.send(options.foreign_key)
        options.model_class.where(options.primary_key => foreign_key).first
      end
    end
  end
  ```
  * Intuitive API with similar core features to ActiveRecord::Base

## Libraries

  * ActiveSupport::Inflector
  * SQLite3 (gem)

## Examples

After loading the demo file, it is possible to search through tables in the database

```Ruby
Store.all # returns all the stores in the database

Organization.where({ id: 2 }) # returns the organization where there is a 2 in the id column

Human.find(id) #finds the person with an id matching the one passed in
```

From there, it is possible to call the appropriate associations on any individual thing in the database.

```Ruby
first_store = Store.all.first
first_store.organization # returns the organization that the store belongs to, by means of a has_one_through association
```

## API

Through SQLObject, DynaORM provides many core ActiveRecord methods and associations, such as :

  * `has_many`
  * `belongs_to`
  * `has_one_through`
  * `::where`
  * `::find`
