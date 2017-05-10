require_relative 'lib/sql_object'

SAMPLE_DB_FILE = 'sample.db'
SAMPLE_SQL_FILE = 'sample.sql'

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
`sample '#{SAMPLE_SQL_FILE}' | sqlite3 '#{SAMPLE_DB_FILE}'`

DBConnection.open(SAMPLE_DB_FILE)

class Store < SQLObject
  belongs_to :owner, foreign_key: :owner_id
  has_one_through :organization, :owner, :organization

  finalize!
end

class Human < SQLObject
  self.table_name = "trainers"
  has_many :stores, foreign_key: :owner_id
  belongs_to :hideout

  finalize!
end

class Hideout < SQLObject
  has_many :humans,
    class_name: "Human",
    foreign_key: :organization_id,
    primary_key: :id

  finalize!
end
