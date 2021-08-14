# frozen_string_literal: true

require 'pg'
require 'date'
module WineDB
  def self.check_db
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres') # check if database exists - first connects to the "master-db", named postgres
    result = conn.exec('SELECT datname FROM pg_database;').map { |row| row.values_at('datname') }
    if result.flatten.include?('webwiner') # db already exists
    else
      conn.exec('CREATE DATABASE webwiner') # creates the database if not exists and its table as well
    end
    conn.close
    create_tables # if some table was drop, it creates again
  end

  def self.insert_wine(site, wine_hash = {})
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'webwiner')
    table_name = 'wine_site' if site == 'wine'
    table_name = 'evino_site' if site == 'evino'

    sql = "INSERT INTO #{table_name} (
      year, name, maker, region, grape, link, price_club, price_regular, price_sale, site_sku, global_id
    ) VALUES
    ( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11 )"

    begin
      conn.prepare('save', sql) # values must match the same order as sql statement
      values = [wine_hash[:year], wine_hash[:name], wine_hash[:maker], wine_hash[:region],
                wine_hash[:grape], wine_hash[:link], wine_hash[:club_price], wine_hash[:regular_price],
                wine_hash[:sale_price], wine_hash[:site_sku], wine_hash[:global_id]]
      conn.exec_prepared('save', values) # this method requires an array as second argument
      conn.close
    rescue # StandardError => e # if it alreay exists, we are going to update it
      conn.close
      uptade_wine(site, wine_hash) # is it right to use the begin/rescue structure for it?
    end
  end

  def self.uptade_wine(site, wine_hash = {})
    table_name = 'wine_site' if site == 'wine'
    table_name = 'evino_site' if site == 'evino'
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'webwiner')
    values = [wine_hash[:year], wine_hash[:name], wine_hash[:maker], wine_hash[:region],
              wine_hash[:grape], wine_hash[:link], wine_hash[:club_price], wine_hash[:regular_price],
              wine_hash[:sale_price], wine_hash[:site_sku], wine_hash[:global_id]]

    sql = " UPDATE #{table_name} SET (year, name, maker, region, grape, link, price_club, price_regular, price_sale, site_sku) =
    ( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    WHERE global_id = $11 "
    conn.prepare('save', sql)
    conn.exec_prepared('save', values)
    conn.close
  end

  def self.add_price_history(site, wine_hash)
    table_name = 'price_history_wine' if site == 'wine'
    table_name = 'price_history_evino' if site == 'evino'
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'webwiner')
    values = [wine_hash[:global_id], wine_hash[:regular_price], wine_hash[:sale_price], wine_hash[:club_price],
              Date.today]
    sql = "INSERT INTO #{table_name} (global_id, price_regular, price_sale, price_club, date) VALUES ( $1, $2, $3, $4, $5 )"
    conn.prepare('save', sql)
    conn.exec_prepared('save', values)
    conn.close
  end

  

  def self.delete_database(db_name)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'postgres')
    sql = "DROP DATABASE IF EXISTS #{db_name}"
    conn.exec(sql)
    conn.close
  end

  def self.get_global_ids(table)
    conn = PG.connect(host: 'localhost', password: 'admin', user: 'postgres', dbname: 'webwiner')
    sql = "SELECT global_id FROM #{table}"
    result = conn.exec(sql)
    conn.close
    global_ids = []
    result.each do |global_id|
      global_ids << global_id unless global_ids.include?(global_id)
    end
    p  global_ids.map! { |each| each['global_id'] }
  end
end  
  