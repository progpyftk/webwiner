# frozen_string_literal: true

require_relative 'db_insert'
require_relative 'db_update'

# WineDB: works as a webwiner database layer, as a db framework
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
    puts 'Updating'
    DBUpdate.row(@conn_params, wine, @field, wine[:global_id], @table)
  end

  def self.exist?(wine)
    DB::Exist.row(@conn_params, @field, wine[:global_id], @table)
  end
end
