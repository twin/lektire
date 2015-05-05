require "sequel"
require "yaml"

DB = Sequel.connect(ENV["DATABASE_URL"] || "postgres:///kvizovi")

DB.extension :pg_array
DB.extension :pg_json
DB.extension :pagination

Sequel::Model.raise_on_save_failure = true

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :nested_attributes
Sequel::Model.plugin :pg_array_associations

module Kvizovi
  module Models
    Base = Sequel::Model
  end
end