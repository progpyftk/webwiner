# frozen_string_literal: true

require_relative 'db_insert'
require_relative 'db_update'

class WineDB
  @table = 'wine_site'
  @conn_params = {
    dbname: 'webwiner',
    host: 'localhost',
    user: 'postgres',
    password: 'admin'
  }
  @field = 'global_id'

  def self.insert(wine)
    DBInsert.row(@conn_params, wine, @table)
  end

  def self.update(wine)
    DBUpdate.row(@conn_params, wine, @field, wine[:global_id], @table)
  end

  def self.exist?
    DB::Exist.row(@conn_params, @field, wine[:global_id], @table)
  end
end
