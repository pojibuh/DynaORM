# DynaORM

## Summary

DynaORM is an object relational mapping software inspired by ActiveRecord, which is used in conjunction with frameworks such as Ruby on Rails. DynaORM performs database queries that maintain code DRYness and readability, while operating in a genuinely object-oriented fashion.

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

  * Intuitive API with similar core features to ActiveRecord::Base

  * Both follows traditional 'convention over configuration' mentality for associations, and allows users to place their own names.

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

In particular, the implementation of the `where` method involves separating the parameters passed into distinct conditions. This allows the user's query to return only what fulfills all the requirements.

```Ruby
module Searchable
  def where(params)
    where_line = params.keys.map { |key| "#{key} = ?" }.join(" AND ")
    search = DBConnection.execute(<<-SQL, params.values)
      SELECT
        *
      FROM
        #{self.table_name}
      WHERE
        #{where_line}
    SQL
    search.map do |el|
      self.new(el)
    end
  end
end
```
From there, it is possible to call the appropriate associations on any individual thing in the database. This is possible due to the utilization of metaprogramming, which allows for the dynamic creation of new methods. Although metaprogramming is very powerful, it is also initially unintuitive. My solution involved the use of `define_method` and accounting for user input in terms of what the association will be called. Comments could belong to a user or an author, but both will point to the same thing.

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

```Ruby
first_store = Store.all.first
first_store.organization # returns the organization that the store belongs to, by means of a has_one_through association
```

## API

Through SQLObject, DynaORM provides many methods and associations that allow for an intuitive user experience, such as:

  * `has_many`
  * `belongs_to`
  * `has_one_through`
  * `::where`
  * `::find`
  * `::all`
  * `::parse_all`
  * `#update`
  * `#insert`
  * `#save`
