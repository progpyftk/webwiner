require 'pg'

# Next steps
# each method will begin and close a db connection, instead of all they have same connection - Done
# set global_id as primary key in thw wine and evino tables - Done
module WineDB



  def self.check_db
    # check if database exists - first connects to the "master-db", named postgres
    conn = PG.connect( host: 'localhost', password: 'admin', user:'postgres' )
    result = conn.exec("SELECT datname FROM pg_database;").map {|row| row.values_at('datname')}
    if result.flatten.include?('webwiner')
      conn.close
    else
      conn.exec("CREATE DATABASE webwiner") # creates the database if not exists
      puts "... Creating Database ..."
      conn.close
      create_tables # creates the tables
    end

  end

  def self.create_tables
    conn = PG.connect( host: 'localhost', password: 'admin', user:'postgres', dbname: 'webwiner' )
    conn.exec("
      CREATE TABLE wine_site (
        year integer ,
        name VARCHAR(255) ,
        maker VARCHAR(255) ,
        region VARCHAR(255) ,
        grape VARCHAR(255) ,
        link VARCHAR(255) ,
        price_club VARCHAR(255) ,
        price_regular VARCHAR(255) ,
        price_sale VARCHAR(255) ,
        site_sku VARCHAR(255) ,
        global_id VARCHAR(255) PRIMARY KEY )"
    )

    conn.exec("
      CREATE TABLE evino_site (
        year integer ,
        name VARCHAR(255) ,
        maker VARCHAR(255) ,
        region VARCHAR(255) ,
        grape VARCHAR(255) ,
        link VARCHAR(255) ,
        price_club VARCHAR(255) ,
        price_regular VARCHAR(255) ,
        price_sale VARCHAR(255) ,
        site_sku VARCHAR(255) ,
        global_id VARCHAR(255)  )"
    )

    conn.exec("
      CREATE TABLE same_wines (
        global_id_wine VARCHAR(255) ,
        global_id_evino VARCHAR(255)  )"
    )

    conn.exec("
      CREATE TABLE price_history_wine (
        global_id VARCHAR(255) ,
        price_club FLOAT ,
        price_regular FLOAT ,
	      price_sale FLOAT ,
	      date DATE  )"
    )

    conn.exec("
      CREATE TABLE price_history_evino (
        global_id VARCHAR(255) ,
        price_regular FLOAT ,
	      price_sale FLOAT ,
	      date DATE  )"
    )

    puts "... Creating tables ..."
    conn.close
  end

  def self.insert_wine(site, wine_hash = {})
    conn = PG.connect( host: 'localhost', password: 'admin', user:'postgres', dbname: 'webwiner' )
    table_name = "wine_site" if site == "wine"
    table_name = "evino_site" if site == "evino"

    sql = "INSERT INTO #{table_name} (
      year, name, maker, region, grape, link, price_club, price_regular, price_sale, site_sku, global_id
    ) VALUES
    ( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11 )"

    begin
      conn.prepare("save", sql) # values must match the same order as sql statement
      values = [wine_hash[:year], wine_hash[:name], wine_hash[:maker], wine_hash[:region], 
              wine_hash[:grape], wine_hash[:link], wine_hash[:club_price], wine_hash[:regular_price], 
              wine_hash[:sale_price], wine_hash[:site_sku], wine_hash[:global_id]]
      result = conn.exec_prepared("save", values) # this method requires an array as second argument
      conn.close
    rescue => e # if it alreay exists, we are going to update it
      conn.close
      uptade_wine(site, wine_hash)
    end
  end

  def self.uptade_wine(site, wine_hash = {})
    table_name = "wine_site" if site == "wine"
    table_name = "evino_site" if site == "evino"
    conn = PG.connect( host: 'localhost', password: 'admin', user:'postgres', dbname: 'webwiner' )
    wine_hash[:year] = 111111
    values = [wine_hash[:year], wine_hash[:name], wine_hash[:maker], wine_hash[:region], 
              wine_hash[:grape], wine_hash[:link], wine_hash[:club_price], wine_hash[:regular_price], 
              wine_hash[:sale_price], wine_hash[:site_sku], wine_hash[:global_id]]
    sql = " UPDATE #{table_name} SET (year, name, maker, region, grape, link, price_club, price_regular, price_sale, site_sku) =
    ( $1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
    WHERE global_id = $11"

    conn.prepare("save", sql)
    conn.exec_prepared("save", values)
    conn.close
  end


end