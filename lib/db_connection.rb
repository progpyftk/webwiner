require 'pg'

module WineDB
  @conn

  def self.connect_db
    # check if database exists - first connects to the "master-db", named postgres
    @conn = PG.connect( host: 'localhost', password: 'admin', user:'postgres' )
    result = @conn.exec("SELECT datname FROM pg_database;").map {|row| row.values_at('datname')}
    unless result.flatten.include?('webwiner')
      @conn.exec("CREATE DATABASE webwiner") # creates the database if not exists
      @conn.close
      @conn = PG.connect( host: 'localhost', password: 'admin', user:'postgres', dbname: 'webwiner' )
      create_tables
      # creates the tables
    end
    @conn.close
    @conn = PG.connect( host: 'localhost', password: 'admin', user:'postgres', dbname: 'webwiner' )
  end

  def self.disconnect_db
    @conn.close
  end

  def self.create_tables
    @conn.exec("
      CREATE TABLE wine_site (
        year integer NOT NULL,
        name VARCHAR(255) NOT NULL,
        maker VARCHAR(255) NOT NULL,
        region VARCHAR(255) NOT NULL,
        grape VARCHAR(255) NOT NULL,
        link VARCHAR(255) NOT NULL,
        price_club VARCHAR(255) NOT NULL,
        price_regular VARCHAR(255) NOT NULL,
        price_sale VARCHAR(255) NOT NULL,
        site_sku VARCHAR(255) NOT NULL,
        global_id VARCHAR(255) NOT NULL )"
    )

    @conn.exec("
      CREATE TABLE evino_site (
        year integer NOT NULL,
        name VARCHAR(255) NOT NULL,
        maker VARCHAR(255) NOT NULL,
        region VARCHAR(255) NOT NULL,
        grape VARCHAR(255) NOT NULL,
        link VARCHAR(255) NOT NULL,
        price_club VARCHAR(255) NOT NULL,
        price_regular VARCHAR(255) NOT NULL,
        price_sale VARCHAR(255) NOT NULL,
        site_sku VARCHAR(255) NOT NULL,
        global_id VARCHAR(255) NOT NULL )"
    )

    @conn.exec("
      CREATE TABLE same_wines (
        global_id_wine VARCHAR(255) NOT NULL,
        global_id_evino VARCHAR(255) NOT NULL )"
    )

    @conn.exec("
      CREATE TABLE price_history_wine (
        global_id VARCHAR(255) NOT NULL,
        price_club FLOAT NOT NULL,
        price_regular FLOAT NOT NULL,
	      price_sale FLOAT NOT NULL,
	      date DATE NOT NULL )"
    )

    @conn.exec("
      CREATE TABLE price_history_evino (
        global_id VARCHAR(255) NOT NULL,
        price_regular FLOAT NOT NULL,
	      price_sale FLOAT NOT NULL,
	      date DATE NOT NULL )"
    )
  end

  def insert_wine(site, wine_hash = {})
    table_name = "wine_site" if site == "wine"
    
    @conn.exec(
      INSERT INTO table_name(column1, column2, …)
VALUES (value1, value2, …);
    )

  end



end

WineDB.connect_db
WineDB.disconnect_db



