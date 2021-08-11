require 'pg'

# Next steps
# each method will begin and close a db connection, instead of all they have same connection.


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

    @conn.exec("
      CREATE TABLE evino_site (
        name VARCHAR(255)
       )"
    )

    @conn.exec("
      CREATE TABLE same_wines (
        global_id_wine VARCHAR(255) ,
        global_id_evino VARCHAR(255)  )"
    )

    @conn.exec("
      CREATE TABLE price_history_wine (
        global_id VARCHAR(255) ,
        price_club FLOAT ,
        price_regular FLOAT ,
	      price_sale FLOAT ,
	      date DATE  )"
    )

    @conn.exec("
      CREATE TABLE price_history_evino (
        global_id VARCHAR(255) ,
        price_regular FLOAT ,
	      price_sale FLOAT ,
	      date DATE  )"
    )
  end

  def self.insert_wine(site, wine_hash = {})
    conn = PG.connect( host: 'localhost', password: 'admin', user:'postgres', dbname: 'webwiner' )
    table_name = "wine_site" if site == "wine"
    table_name = "evino_site" if site == "evino"
    sql = "INSERT INTO #{table_name}
    (
      name
    ) VALUES
    (
      $1
    )"
    puts sql
    #conn.prepare("save", sql)
    conn.prepare("save", sql)
    conn.exec_prepared("save", wine_hash.values) # aqui é necessario passar um array
    conn.close


    

  end

end


WineDB.connect_db

WineDB.disconnect_db

hash = {
  name: "Vinho Cabrini"
}
site = 'wine'
WineDB.insert_wine(site, hash)