require_relative 'lib/sql_object'
require_relative 'lib/db_connection'
require_relative 'lib/associatable'

# SCHEMA
# Store
# Columns: 'id', 'name', 'owner_id'
#
# Human
# Columns: 'id', 'fname', 'lname', 'organization_id'
#
# Organization
# Columns: 'id', 'name'

`rm '#{SAMPLE_DB_FILE}'`
`cat '#{SAMPLE_SQL_FILE}' | sqlite3 '#{SAMPLE_DB_FILE}'`

DBConnection.open(SAMPLE_DB_FILE)

class Store < SQLObject
  belongs_to :owner,
    class_name: "Human",
    foreign_key: :owner_id,
    primary_key: :id
  has_one_through :organization, :owner, :organization

  finalize!
end

class Human < SQLObject
  self.table_name = "humans"
  has_many :stores, foreign_key: :owner_id
  belongs_to :organization

  finalize!
end

class Organization < SQLObject
  has_many :humans,
    class_name: "Human",
    foreign_key: :organization_id,
    primary_key: :id

  finalize!
end
